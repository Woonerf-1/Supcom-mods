# Unit.lua - Corrosive Ocean

Datei: `usermods\CorrosiveOcean\hook\lua\sim\Unit.lua` (Ordner bis 2026-10-16 `AcidPools`)
Wirkt auf: `/lua/sim/Unit.lua`

## Herkunft

**BrewLAN (Balthazar) -> herausgeloest als eigener Mod -> hier ueberarbeitet.**
Der Mod ist ein Teilstueck von `BrewLAN_Gameplay`, `uid` und Urheberrecht unveraendert.

## Zweck

Gewaesser fuegen Einheiten Schaden zu, der mit der Verweildauer waechst.

## Wie es arbeitet

Die Datei **ersetzt die Klasse `Unit`** (`Unit = Class(UnitOld) { ... }`), statt einzelne
Methoden zu ueberschreiben. Das ist wichtig: der Klassenersatz greift nachweislich auch
fuer Einheiten, die ueber `defaultunits.lua` erben - ein blosser Methodenaustausch tut das
offenbar nicht (siehe `doc.claude\TODO.md`, `Class()`-Frage).

## Aenderungen gegenueber Balthazars Fassung

### 1. Kein Dauerthread mehr - Ereignis statt Abfrage

**Vorher:** `OnStopBeingBuilt` startete fuer jede betroffene Einheit einen Thread, der bis
zum Spielende lief und **alle zwei Sekunden** `GetCurrentLayer()` abfragte, um zu merken,
ob die Einheit ins Wasser geraten ist.

```lua
while self do                      -- self ist immer wahr: lief endlos
    if layer == 'Water' ... then
        ... WaitTicks(1)
    else
        damage = 0
        WaitSeconds(2)             -- Leerlauf an Land
    end
end
```

**Jetzt:** der Thread startet erst beim Betreten des Wassers und endet beim Verlassen.

```lua
OnLayerChange = function(self, new, old)
    UnitOld.OnLayerChange(self, new, old)
    if WASSER[new] and self:AcidBetroffen() then
        self:AcidStart()
    end
end,
```

`OnLayerChange` ist LOUD-eigen (`gamedata\lua\lua\sim\Unit.lua` Z. 461) und wird von
`defaultunits.lua` an mehreren Stellen weitergereicht (Z. 1796, 4194) - also ein
etablierter Ereignishaken, kein Eigenbau.

`OnStopBeingBuilt` prueft weiterhin, ob die Einheit **direkt im Wasser** entsteht.

`self.AcidLaeuft` verhindert, dass mehrere Threads gleichzeitig laufen, falls die Ebene
schnell wechselt.

**Wirkung:** an Land kostet der Mod jetzt **nichts**. Vorher waren es bei 200 Einheiten
rund 100 Abfragen pro Sekunde im Leerlauf.

### 2. Flugzeuge ausgenommen

Neu in der Ausnahmeliste: `categories.AIR` und `MotionType == 'RULEUMT_Air'`.

Balthazars Fassung nahm sie nicht aus. Flugzeuge tragen zwar normalerweise die Ebene
`Air`, konnten aber beim Aufsetzen oder in Randfaellen in den Wasserzweig geraten.

### 3. Pruefung nur einmal je Einheit

`AcidBetroffen()` merkt sich das Ergebnis in `self.AcidGeprueft`. Vorher lief die
Kategorienpruefung bei jedem Threadstart neu.

### 4. Endlosschleife behoben

`while self do` -> `while not self.Dead and WASSER[...] do`. `self` ist als Tabelle immer
wahr; die Schleife konnte nie enden, auch nach dem Tod der Einheit nicht.

## Ausgenommen vom Schaden

| Kategorie | Grund |
|---|---|
| `MotionType` `RULEUMT_Water`, `RULEUMT_SurfacingSub`, `RULEUMT_Air` | Schiffe, U-Boote, Flugzeuge |
| `NAVAL` | **alle Schiffe** inkl. Marinefabriken (seit 2026-10-16, vorher nur `NAVAL * FACTORY`) |
| `ANTINAVY * STRUCTURE` | Torpedostellungen |
| `SONAR * TECH1/TECH2 * STRUCTURE` | Sonar der Stufen 1 und 2 |
| `ENGINEER` | Ingenieure - sonst waere Bauen im Wasser unmoeglich |
| `AIR` | **neu** |

### 5. Alle Schiffe ausgenommen (2026-10-16)

Paul: ein T2-Zerstoerer, der auch an Land laufen kann, starb im Wasser. Das ist die
**Salem Class** (URS0201, Cybran): `MotionType = 'RULEUMT_AmphibiousFloating'`,
`AltMotionType = 'RULEUMT_Water'` (`LOUD\gamedata\units.scd`, `units/URS0201/URS0201_unit.bp`
Z. 154, 176). Die Bewegungsart-Ausnahme griff deshalb nicht, und die Kategorienliste nahm
nur `NAVAL * FACTORY` aus. Jetzt `NAVAL` insgesamt: was das Spiel als Schiff fuehrt, nimmt
keinen Schaden - unabhaengig von der Bewegungsart. Die anderen drei T2-Zerstoerer (Exodus,
Valiant, Uashavoh) waren schon ueber die Bewegungsart ausgenommen.

## Nicht angefasst: die Schadensformel

```lua
local beginn = GetGameTimeSeconds()
...
self:OnDamage(self, GetGameTimeSeconds() - beginn, Vector(0,0,0), 'normal')
WaitTicks(1)
```

Der Schaden entspricht der **Verweildauer in Sekunden** und wird **jeden Tick** zugefuegt:
nach 60 Sekunden im Wasser also 60 Schaden pro Tick, 600 pro Sekunde - unbegrenzt
steigend.

Das sieht nach Absicht aus ("wer im Saeuresee stehenbleibt, loest sich auf"), hat aber
keine Obergrenze. **Bewusst unveraendert gelassen** (Entscheidung 2026-08-16), im Spiel
bestaetigt als spielbar.

## Referenzen

- `gamedata\lua\lua\sim\Unit.lua` Z. 461 - `OnLayerChange`
- `gamedata\lua\lua\defaultunits.lua` Z. 1796, 4194 - Weiterreichung
- `doc.claude\TODO.md` - offene `Class()`-Frage
