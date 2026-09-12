# SRB4402_script.lua - Darkness, Experimental Omni Disrupting Facility

Datei: `usermods\DynamicGameplay\units\SRB4402\SRB4402_script.lua`

## Herkunft

**BrewLAN -> LOUD -> Colin (`UEF_trans_men`) -> dieser Mod.**
Quellenkonvention: `doc.claude\07_KONVENTIONEN.md` Abschnitt 4.

## Abweichungen gegenueber LOUD

### Von uns korrigiert: der Schockwellen-Effekt

Die drei Schockwellenring-Emitter in `OnWeaponFired`:

| | |
|---|---|
| BrewLAN, LOUD, Colin | `CreateAttachedEmitter(self.unit, 'XRC2201', army, epathR)` |
| jetzt | `CreateAttachedEmitter(self.unit, 0, army, epathR)` |

Der Darkness benutzt das Modell des Zivilgebaeudes `XRC2201` aus `civ_units.scd` und bringt
nur eine eigene LOD1-Geometrie mit. Die Knochentabelle beider Modelle wurde aus dem
SCM-Format gelesen - jedes hat genau **einen** Knochen, und er heisst je Detailstufe
anders:

```
XRC2201_lod0.scm  ->  'XRC2201'
SRB4402_lod1.scm  ->  'lod1_XRC2201'
```

Aus groesserer Kameraentfernung greift LOD1, der Knochen `'XRC2201'` existiert dann nicht.

**Das war mehr als ein fehlender Effekt.** Die drei Zeilen stehen in `OnWeaponFired` vor
allem, was wirkt - vor den vier `cybran_qai_shutdown_ambient`-Emittern, vor
`Buff.ApplyBuff(v, 'DarknessEffect')` und vor dem Entfernen der Panopticon-Markierungen.
Ein Abbruch dort haette den Darkness vollstaendig wirkungslos gemacht, alle 2,5 Sekunden
erneut.

Knochen `0` ist der Wurzelknochen: LOD-unabhaengig, und bei einem Modell mit genau einem
Knochen an derselben Stelle. Die `OffsetEmitter( 0, 4, 0 )` bleiben unveraendert. Dieselbe
Funktion benutzt fuer Blitz und Flimmern ohnehin schon `0`.

Der Fehler stammt aus **BrewLAN** und wurde von **LOUD** und **Colin** unveraendert
uebernommen.

**Ungeprueft:** ob die Engine bei einem ungueltigen Knochen wirklich abbricht oder still
nichts tut. Die Korrektur ist in beiden Faellen richtig.

### Von Colin uebernommen, bewusst beibehalten

Zeile 74, Ausnahmeliste des Pulses:

```lua
LOUD:   ... + categories.ual0401 + categories.sab2306 + categories.WALL
jetzt:  ... + categories.ual0401 + categories.WALL
```

`sab2306` ist Aeons Aria, BrewLANs T3-Punktverteidigung. LOUD nimmt sie vom Darkness aus,
Colin nicht - sie wird also mitgetroffen. **Als gewuenscht bestaetigt.**

### Von uns entfernt

`local BrewLANPath = import('/lua/game.lua').BrewLANPath()` - von Colin hinzugefuegt,
nirgends benutzt. Mit `conflicts` gegen BrewLAN liefert der Aufruf ohnehin immer `nil`.

## Der Buff

`Buff.ApplyBuff(v, 'DarknessEffect')` - der Buff ist **LOUD-eigen**, definiert in
`gamedata\lua\lua\sim\buffdefinitions.lua` Z. 217:

```lua
BuffBlueprint { Name = 'DarknessEffect',
    BuffType = 'COUNTERINTEL', Stacks = 'ALWAYS', Duration = 20.1,
    Affects = {
        VisionRadius = { Add = 0, Mult = 0.9  },
        RadarRadius  = { BuffCheckFunction = AdjBuffFuncs.RadarRadiusBuffCheck, Add = 0, Mult = 0.85 },
        OmniRadius   = { BuffCheckFunction = AdjBuffFuncs.OmniRadiusBuffCheck,  Add = 0, Mult = 0.75 },
    },
    Effects = { '/effects/emitters/jammer_ambient_01_emit.bp',
                '/effects/emitters/jammer_ambient_02_emit.bp' },
}
```

**Nicht zu verwechseln mit BrewLANs `DarknessOmniNerf`** (`Mult = 0.6`, nur Omni). LOUD hat
den Buff ersetzt und ausgebaut - er wirkt auf Sicht, Radar und Omni, mit
Buff-Check-Funktionen und eigenen Effekten am betroffenen Gegner. **Dieser Mod muss dafuer
nichts mitliefern.**

`Stacks = 'ALWAYS'` bei 20,1 Sekunden Laufzeit, und `FirePulse` feuert alle 5 Sekunden -
es liegen also bis zu vier Anwendungen uebereinander.

## Modell und Effekte

`SRB4402` bringt nur drei Dateien mit (`_lod1.scm`, `_script.lua`, `_unit.bp`). Alles
Uebrige kommt von `XRC2201`:

| Zeile | Feld | Pfad |
|---|---|---|
| 55 | `AnimationDeath` | `/units/XRC2201/XRC2201_Adeath1.sca` |
| 72-75 | Mesh und Texturen LOD0 | `/units/xrc2201/xrc2201_*` |
| 81 | Normals LOD1 | `/units/xrc2201/xrc2201_lod1_normalsTS.dds` |

`UniformScale = 0.04` - das Zivilgebaeude wird stark verkleinert.

Emitter je Puls: `flash_01` (Knochen 0, Skalierung 20), dreimal
`destruction_explosion_concussion_ring_03` (Knochen 0, Skalierung 1/3/6),
`cybran_qai_shutdown_ambient_01` bis `_04` (Knochen 0). Alle aus dem Basisspiel,
Existenz geprueft.

Die Rotatoren sitzen auf `' B01'`, `' B02'`, `' B03'` - **mit fuehrendem Leerzeichen.**

## Debug

**Entfernt am 2026-08-16**, nachdem alle Fragen beantwortet waren. Die Messung ergab:

| Reichweite | gebufft | uebersprungen |
|---:|---:|---:|
| 18 | 2 | 16 |
| 20 | 4 | 16 |
| 24 | 8 | 16 |
| 29 | 13 | 16 |
| 33 | 17 | 16 |

`gebufft + uebersprungen = Reichweite` geht in jeder Zeile auf.

**Die 16 uebersprungenen waren durchgaengig Kommandanten:**

```
uel0001 uel0301 ual0301 url0301 xsl0301   ual0001 uel0301 ual0301 url0301 xsl0301
ual0001 uel0001 uel0301 ual0301 url0301 xsl0301
```

Also je Armee ein ACU und vier SCUs - das ist der **PlayTest-Aufbau**, nicht der Mod.
Wer mit `PlayTest` misst, hat diese Einheiten immer im Bild; beim Deuten von
Einheitenzahlen daran denken.

Damit belegt:

- die Emitter werden erzeugt, die Funktion laeuft bis zum Ende durch
- `DarknessEffect` wird angewandt, auf **jede** Einheit ausser Kommandanten,
  Galactic Colossus und Mauern
- die Knochen-Korrektur wirkt, der Puls ist im Spiel sichtbar

**Die Zielauswahl erfasst alle Armeen, nicht nur Feinde.** Der Darkness trifft also auch
eigene Einheiten - im Unterschied zum Panopticon, das ueber `'Enemy'` filtert. Im Log
belegt durch die eigenen ACUs in der Uebersprungenenliste:

```lua
for index, brain in ArmyBrains do
    for i, unit in AIUtils.GetOwnUnitsAroundPoint(brain, categories.ALLUNITS - categories.WALL, Mypos, Range) do
```

**Fuer den Spielbetrieb heisst das:** den Darkness nicht in die eigene Verbandsmitte
stellen.

## Referenzen

- `gamedata\BrewLAN_LOUD\mods\BrewLAN_LOUD\units\SRB4402\` - LOUD-Fassung
- `mods/BrewLAN/units/SRB4402/` im BrewLAN-Repo - Ursprung, `DarknessOmniNerf`
- `gamedata\lua\lua\sim\buffdefinitions.lua` Z. 217 - `DarknessEffect`
- `gamedata\civ_units\units\XRC2201\` - Modell
- `doc.claude\07_KONVENTIONEN.md` Abschnitt 5 - `.sca`-Pfadaufloesung
