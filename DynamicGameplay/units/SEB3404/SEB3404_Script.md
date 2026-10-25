# SEB3404_Script.lua - Panopticon, Experimental Sensor Array

Datei: `usermods\DynamicGameplay\units\SEB3404\SEB3404_Script.lua`

## Herkunft

**BrewLAN -> LOUD -> Colin (`UEF_trans_men`) -> dieser Mod.**
Quellenkonvention: `doc.claude\07_KONVENTIONEN.md` Abschnitt 4.

Gegen LOUD gediffed ist die Datei bis auf **zwei Stellen** unveraendert.

## Abweichungen gegenueber LOUD

### Von Colin uebernommen, bewusst beibehalten

`IntelSearch`, Zeile 72:

```lua
LOUD:   FindAllUnits(aiBrain, SELECTABLE - COMMAND - SUBCOMMANDER
                     - WALL - HEAVYWALL - MEDIUMWALL - MINE,
                     self:GetIntelRadius('radar'), true)

jetzt:  FindAllUnits(aiBrain, SELECTABLE - COMMAND - SUBCOMMANDER,
                     self:GetIntelRadius('omni'), true)
```

Zwei Aenderungen in einer Zeile, beide von Colin, beide in einem einzigen Eingriff -
die Datei ist sonst zeichengleich mit LOUD (274 Zeilen wie dort, BrewLAN hat 232).

| | LOUD | jetzt |
|---|---:|---:|
| Suchradius ohne Ausbau | 560 (Radar) | **212** (Omni) |
| Suchradius voll ausgebaut | 1115 | **394** |
| markierte Objekte | ohne Mauern und Minen | **mit** |

Der Radius sinkt also auf gut ein Drittel, gleichzeitig werden mehr Objekte markiert, und
jedes markierte Objekt kostet Unterhalt. Die beiden Teilaenderungen wirken gegeneinander -
nach den Anhaltspunkten in `18_ABLEITUNG.md` Abschnitt 0 spricht das eher fuer Versehen
als fuer Absicht.

**Relativierung:** `GetUnitsAroundPoint(..., 'Enemy')` findet **nur Feinde**. Der Wegfall
der Mauer- und Minenausnahme betrifft also ausschliesslich gegnerische Mauern und Minen.

**Entscheidung vertagt** (Stand 2026-08-16). Colins Fassung bleibt bis dahin.

### Von uns: keine

Am Verhalten wurde nichts geaendert. Eine Anpassung an `IntelSearch` (Verbrauch nur bei
Aenderung neu setzen) wurde gebaut, getestet und **wieder zurueckgenommen** - sie loeste
das Abschaltproblem nicht, der Beleg steht im Log: die Bedingung griff, und es toggelte
weiter. Siehe unten.

## Wie das Geraet funktioniert

### Neun Ausbaustufen, keine Einheitenersetzung

`SEB3404` hat **kein** `UpgradesTo`. Der Ausbau laeuft ueber `Enhancements` - neun Stufen,
alle im Slot `LCH`, per `Prerequisite` verkettet. Die Entitaet bleibt dieselbe, es werden
nur Knochen eingeblendet und Buffs angewandt.

### Sichtweiten und Verbrauch je Stufe

Grundwerte aus dem `Intel`-Block des Blueprints, Multiplikatoren aus LOUDs
`gamedata\lua\lua\sim\buffdefinitions.lua`.

| Stufe | Icon | Radar | Omni | Sicht | Energie/s | kumul. |
|---|---|---:|---:|---:|---:|---:|
| Grundausbau | - | 560 | 212 | 16 | 6 440 | x1,00 |
| Small_Dish_001 | sre | 623 | 223 | 16 | 9 660 | x1,50 |
| Med_Dish_001 | sresre | 653 | 237 | 16 | 10 143 | x1,58 |
| Small_Dish_002 | sre | 735 | 248 | 16 | 16 500 | x2,56 |
| Med_Dish_002 | sresre | 774 | 271 | 16 | 18 150 | x2,82 |
| Small_Dish_003 | sre | 877 | 285 | 16 | 30 000 | x4,66 |
| Med_Dish_003 | sresre | 925 | 320 | 16 | 34 500 | x5,36 |
| Small_Dish_004 | sre | 1 042 | 336 | 16 | 55 000 | x8,54 |
| Med_Dish_004 | sresre | **1 115** | **394** | 16 | **66 000** | x10,25 |
| Xband_Dish | xbndl | 1 115 | 394 | 16 | 66 000 | x10,25 |

**Kein Sonar.** Die Sicht bleibt bei 16 - die Buffs fassen nur `RadarRadius`, `OmniRadius`
und `EnergyMaintenance` an. Weitere Werte: `SpyBlipRadius = 2`, `ReactivateTime = 0`.
Ob das Omni-Feld allein getauchte Einheiten zeigt, entscheidet die Engine - ungeprueft.
**Aber:** ab `Xband_Dish` markiert der Suchlauf jede feindliche Einheit im Omni-Radius ohne
Ebenen-Filter (auch U-Boote, nicht getarnte), und der Marker hat `Vision` **und**
`WaterVision` (`AttachVisEntityToTargetUnit`, Z. 219-234). Im Omni-Radius werden getauchte
Einheiten dann also voll sichtbar - kein Sonar-Blip, sondern echte Sicht.

Kosten: `sre`-Stufen je 105 147 Energie / 10 515 Masse, `sresre`-Stufen je
157 720 / 15 772. `Xband_Dish` aendert keine Radien.

**Warum die Anzeige krumme Zahlen zeigt:** LOUDs Multiplikatoren sind rueckwaerts aus
Zielwerten gerechnet (`1.6267376`, `1.6528925`, `1.5942028`). Das Ergebnis verfehlt die
glatte Zahl um wenige Tausendstel, und die Anzeige schneidet ab statt zu runden -
29 999,9979 wird zu **-29999**.

### Was `Xband_Dish` freischaltet

Drei Dinge gleichzeitig, im Zweig `if enh == 'Xband_Dish'`:

1. den Umschalter `RULEUTC_WeaponToggle` (Beschriftung: siehe
   `..\..\hook\lua\ui\help\tooltips.md`)
2. `self.PanopticonUpkeep`
3. den Suchlauf-Thread

Vor dem letzten Ausbau erhoehen die acht Vorstufen **nur Radien und Verbrauch** - markiert
wird nichts.

### Der Suchlauf

```lua
while true do
    if self.Intel then
        self:IntelSearch(bp, army, aiBrain)
    end
    WaitSeconds(1)
end
```

**Jede Sekunde**, endlos bis zum Tod des Gebaeudes. Je Durchlauf:

- eine Umkreissuche ueber den vollen Omni-Radius, **nur Feinde**
- ein `GetBlueprint()` je gefundener Einheit
- **ein neuer Vis-Marker je Einheit** mit `LifeTime = 1` - bei 200 Einheiten also 200
  Entitaeten pro Sekunde, dauerhaft
- bei aktiver Beschraenkung zusaetzlich eine Sortierung mit `VDist2Sq` und einem
  zusammengesetzten Zeichenkettenschluessel je Einheit

Das ist der teuerste Teil des Mods. **Nicht gemessen**; eine Taktung auf 2-3 Sekunden
waere die naheliegende Entlastung, `LifeTime` muesste dann mitwachsen.

### Verbrauchsformel

```
Grundverbrauch = 6440 x Produkt aller EnergyMaintenance-Multiplikatoren
```

Zusatz je markierter Einheit, aus `MaintenanceConcumptionVision` im Blueprint:

```
Gebaeude:  BuildCostEnergy / 10000,  begrenzt auf  1 .. 100
Mobil:     BuildCostEnergy /  1000,  begrenzt auf 10 .. 1000
```

Bei aktiver Beschraenkung bricht die Schleife ab, sobald
`Verbrauch + Kosten > Einkommen - Bedarf + bisheriger Panopticon-Verbrauch`.

## Bekannte Probleme

### Das Geraet schaltet sich ab, obwohl das Konto voll ist

**Ursache liegt nicht hier, sondern in LOUDs `IntelWatchThread`** (`Unit.lua`). Dort wird
der gespeicherte Energievorrat gegen den Sekundenverbrauch verglichen; das Einkommen
kommt nicht vor. Ist der Verbrauch groesser als die Speicherkapazitaet, schaltet die
Anlage grundsaetzlich ab - **und kommt nicht von selbst zurueck.**

Vollstaendige Analyse als **B-03** in `doc.claude\mods\BasegameBugfixes.md`.

**Faustregel im Spiel: Energiespeicher >= Sekundenverbrauch.**

| Ausbaustufe | Verbrauch/s | T1-Speicher (3 000) |
|---|---:|---:|
| Grundausbau | 6 440 | 3 |
| Med_Dish_002 | 18 150 | 7 |
| Small_Dish_003 | 30 000 | 10 |
| Med_Dish_004 | 66 000 | **22** |

### Kurzes Ausgehen waehrend der Ausbaustufen

Beim Abschluss jeder Stufe initialisiert `TStructureUnit.CreateEnhancement` die Sensoren
neu - aus, Werte setzen, wieder an. Im Log als Paare sichtbar, selbstheilend. LOUD-Code,
nicht behebbar ohne Eingriff in `defaultunits.lua`.

### Erbfehler in der Abbruchbedingung

```lua
if self.ActiveConsumptionRestriction and NewUpkeep + cost > SpareEnergy then
    if i == 1 then
        NewUpkeep = bp.Economy.MaintenanceConsumptionPerSecondEnergy
    end
    break
```

Bei aktiver Beschraenkung wurde die Tabelle vorher umgebaut - die Schluessel sind dann
**Zeichenketten** der Form `"Entfernung.EntityId"`. `i == 1` trifft nie zu, der Rueckfall
auf den Grundverbrauch laeuft ins Leere. Steht so in BrewLAN und LOUD. **Nicht behoben.**

## Referenzen

- `gamedata\BrewLAN_LOUD\mods\BrewLAN_LOUD\units\SEB3404\` - LOUD-Fassung
- `mods/BrewLAN/units/SEB3404/` im BrewLAN-Repo - Ursprung
- `gamedata\lua\lua\sim\buffdefinitions.lua` - die neun `*_Buff`
- `gamedata\lua\lua\sim\Unit.lua`, `IntelWatchThread` - Ursache des Abschaltens
- `doc.claude\mods\DynamicGameplay.md`
