# Mod: ImprovedHydrocarbonPowerPlants

| | |
|---|---|
| **Ordner** | `usermods\ImprovedHydrocarbonPowerPlants\` |
| **VFS-Pfad** | `/mods/improvedhydrocarbonpowerplants/` |
| **uid** | `AD88F006-304B-42E6-8612-E63918A7BE22` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Log-Praefix** | `IHPP:` |
| **Status** | Entwurf - angepasst 2026-08-15, **im Spiel ungetestet** |
| **Geprueft** | 2026-08-15 |

Uebergeordnet: [18_ABLEITUNG.md](../18_ABLEITUNG.md)

Hiess bis 2026-08-15 `HCPP`, Anzeigename `MoreHydro`.

---

## 1. Zweck

**Extrakt aus `BlackOpsUnleashed`.** Stellt acht verbesserte Hydrocarbon-Kraftwerke bereit -
Stufe 2 und Stufe 3 fuer alle vier Fraktionen - **ohne** die uebrigen 78 Einheiten dieses
Pakets.

## 2. Bestand

```
usermods\ImprovedHydrocarbonPowerPlants\
  mod_info.lua
  config.lua                              Einstellungen fuer den Mod-Manager
  hook\lua\system\Blueprints.lua          vereinheitlicht Adjacency, RegenRate, StorageEnergy
  units\BEB1202\  units\BEB1302\    UEF       "HCPP - X2000" / "HCPP - X3000"
  units\BAB1202\  units\BAB1302\    Aeon      ohne UnitName
  units\BRB1202\  units\BRB1302\    Cybran    ohne UnitName
  units\BSB1202\  units\BSB1302\    Seraphim  "Uya-atoh"
```

Je Einheit sechs bis sieben Dateien (Blueprint, Script, Mesh, drei Texturen, bei UEF
zusaetzlich eine `.sca`). Kein `shadow\`, kein `lua\`, kein `icons\`, kein `sounds\`.

Das Mod-Bild im Mod-Manager ist das Bausymbol der UEF-Stufe 3:
`icon = "/textures/ui/common/icons/units/BEB1302_icon.dds"`. Der Wert geht unveraendert an
`Bitmap:SetTexture()` (`gamedata.entpackt\lua\lua\ui\dialogs\modmanager.lua` Z. 1131 und
1365), ist also ein reiner VFS-Pfad - **es liegt keine Bilddatei im Mod**. Dargestellt
wird es mit 36x36 in der Liste und 70x70 in der Detailansicht.

## 3. Warum dieser Mod gebraucht wird

Der staerkste Befund der Pruefung: **LOUD rechnet in seinen eigenen Basiseinheiten fest
mit diesen Blueprints.**

`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\units\units\UEB1102\UEB1102_unit.bp`
- also Basisspiel, kein Mod:

```lua
BuildableCategory = { 'beb1202', },
RebuildBonusIds   = {'ueb1102','beb1202','beb1302'},
UpgradesTo        = 'beb1202',
```

Dasselbe in `UAB1102` -> `bab1202`, `URB1102` -> `brb1202`, `XSB1102` -> `bsb1202`.

**Ohne einen Mod, der diese IDs liefert, zeigt LOUDs Standard-Hydrokraftwerk auf ein nicht
vorhandenes Aufstiegsziel.** Der Extrakt schliesst also eine Luecke, die LOUD selbst offen
laesst.

### Die Aufstiegskette ist vollstaendig

```
ueb1102 (Basisspiel)  ->  beb1202  ->  beb1302
uab1102               ->  bab1202  ->  bab1302
urb1102               ->  brb1202  ->  brb1302
xsb1102               ->  bsb1202  ->  bsb1302
```

Nichts haengt in der Luft - anders als bei `SquareShields`, wo die Stufe `...02` fehlt.
Die `1302`-Blueprints tragen `UpgradesFrom` und `UpgradesFromBase`, die `1202` zusaetzlich
`BuildableCategory` und `UpgradesTo` auf die jeweilige `1302`.

Gebaut werden koennen sie auch direkt: `BUILTBYTIER2ENGINEER` / `BUILTBYTIER3ENGINEER`
(die `1302` nur T3), dazu die entsprechenden `BUILTBYTIER*COMMANDER`.

## 4. Warum Vollkopie

Wie bei `SquareShields`: `Merge = true` greift nur bei bereits vorhandener ID
(`Blueprints.lua`, `StoreBlueprint()`). Da `BlackOpsUnleashed` per `conflicts`
ausgeschlossen ist, existiert sie nicht.

Die Assetkopien sind hier ohnehin klein - acht Gebaeude ohne Waffen, keine LOD-Kaskaden,
keine Effektbibliothek.

## 5. Aenderungen gegenueber dem Original

Ausgangsbasis:
`gamedata.entpackt\blackops\mods\BlackOpsUnleashed\units\<ID>\`

### 5.1 Scripts: keine

**Alle acht Scripts sind byte-identisch** mit dem BlackOps-Original. Einzeln gediffed,
jeweils 0 geaenderte Zeilen.

### 5.2 Blueprints: keine

**Alle acht Blueprints sind byte-identisch** mit dem BlackOps-Original.

Bis 2026-08-15 wichen `BAB1202` und `BAB1302` ab (`Adjacency` auf
`T2`/`T3PowerGeneratorAdjacencyBuffs`, dazu `RegenRate = 10` bei `BAB1202`) - eine
Abweichung, die nur Aeon betraf und aus `UEF_trans_men` stammte. Sie ist
zurueckgenommen: die Adjacency wird jetzt fuer alle acht zentral gesetzt (Abschnitt 6),
`RegenRate` ist entfallen.

### 5.3 `mod_info.lua`

| Feld | Alt | Neu |
|---|---|---|
| Ordner | `HCPP` | `ImprovedHydrocarbonPowerPlants` |
| `name` | `MoreHydro` | `Improved Hydrocarbon PowerPlants` |
| `uid` | `morehydromodv01` | `AD88F006-304B-42E6-8612-E63918A7BE22` |
| `conflicts` | nicht gesetzt | `{ "9e8ea941-c306-4751-b367-a11000000502" }` |
| `icon` | nicht gesetzt | `/textures/ui/common/icons/units/BEB1302_icon.dds` |

`requiresNames` nicht gesetzt - die Tabelle gilt laut `mods.lua` Z. 86-91 nur fuer
`requires`.

### 5.4 Neu hinzugekommen

- `config.lua` - Einstellungen fuer den Mod-Manager
- `hook\lua\system\Blueprints.lua` - vereinheitlicht Adjacency, RegenRate und
  StorageEnergy zentral

## 6. Vereinheitlichung der acht Kraftwerke

### 6.1 Der Vollvergleich

Alle acht Blueprints wurden feldweise gegeneinander gestellt (28 Felder plus
Kategorien). Einheitlich sind: `Health` (3800 / 10600), `EconomyThreatLevel` (113 / 543),
`BuildCostEnergy` (21000 / 64250), `BuildCostMass` (1750 / 4250), `BuildTime`
(2000 / 5400), `ProductionPerSecondEnergy` (875 / 4075), `CapCost` (6 / 12), `ArmorType`,
Footprint, Skirt, `MotionType`, Strategiesymbole, `SelectionPriority`, `LifeBarHeight`.

Auch die **Kategorien** sind bis auf das Fraktionskuerzel deckungsgleich - 15 gemeinsame
bei Stufe 2, 12 bei Stufe 3, kein Ausreisser.

Vier echte Abweichungen im BlackOps-Original:

| Feld | UEF | Aeon | Cybran | Seraphim | Behandlung |
|---|---:|---:|---:|---:|---|
| `RegenRate` Stufe 2 | 1 | **kein Eintrag** | 2 | 2 | einstellbar, Vorgabe 2 |
| `RegenRate` Stufe 3 | 2 | 2 | 4 | 3 | einstellbar, Vorgabe 4 |
| `Adjacency` | Hydro | *T2/T3PowerGen* | Hydro | Hydro | einstellbar |
| `Economy.StorageEnergy` Stufe 2 | 200 | 200 | 200 | **kein Eintrag** | fest auf 200 |

Zwei weitere Unterschiede sind **keine** Abweichungen:

- `SizeY` und `UniformScale` unterscheiden sich zwangslaeufig - die Modelle sind
  verschieden.
- `BuildIconSortPriority` steht bei Aeon auf 70 statt 80. Das verschiebt nur die Position
  im Baumenue, ist ueber beide Stufen konsistent und sieht nach Absicht aus. **Nicht
  angefasst.**

Die Aeon-`Adjacency` stammt aus `UEF_trans_men` (dort gegengeprueft: identisch), die
uebrigen drei Abweichungen aus `BlackOpsUnleashed` selbst.

### 6.2 Wie es geloest ist

Zwei Dateien:

| Datei | Rolle |
|---|---|
| `config.lua` | die einstellbaren Werte - erscheinen im Mod-Manager |
| `hook\lua\system\Blueprints.lua` | liest sie, setzt sie plus die festen Werte fuer die acht IDs |

Die Werte in den `_unit.bp` bleiben auf dem BlackOps-Originalwert stehen und werden vom
Hook ueberschrieben. Das ist Absicht: so bleibt der Diff gegen das Original sauber, und es
gibt keine zweite Stelle, die etwas Widersprechendes behauptet.

### 6.3 Einstellbar im Mod-Manager

| Schluessel | Label | Auswahl | Vorgabe |
|---|---|---|---|
| `RegenRateT2` | Selbstreparatur Stufe 2 | 0 bis 10 | **2** |
| `RegenRateT3` | Selbstreparatur Stufe 3 | 0 bis 10 | **4** |
| `AdjacencyT2` | Nachbarschaftsboni Stufe 2 | 3 Tabellen | `T2PowerGeneratorAdjacencyBuffs` |
| `AdjacencyT3` | Nachbarschaftsboni Stufe 3 | 3 Tabellen | `T3PowerGeneratorAdjacencyBuffs` |

Die Vorgabe ist im Anzeigetext jeweils mit "(Vorgabe)" markiert, die Null mit dem Zusatz
"keine". Bei den Adjacency-Optionen steht beim T2-Eintrag der Hinweis, dass er inhaltlich
gleich `HydrocarbonAdjacencyBuffs` ist - sonst haelt man ihn faelschlich fuer eine
Verbesserung.

`config.lua` liefert immer **Zeichenketten**; der Hook wandelt mit `tonumber()` und faellt
bei `nil` auf den Vorgabewert zurueck.

### 6.4 Fest vereinheitlicht, nicht einstellbar

`Economy.StorageEnergy` der Stufe 2 wird fuer alle vier auf **200** gesetzt. Drei der vier
tragen den Wert bereits, `BSB1202` hat den Eintrag gar nicht - eine Luecke im Original,
keine Fraktionseigenheit.

Zum Vergleich die T1-Kraftwerke aus dem Basisspiel: `UEB1102`, `UAB1102`, `URB1102` haben
500, `XSB1102` hat 600.

**Stufe 3 bleibt unberuehrt** - dort hat keines der vier einen Eintrag, die Stufe ist also
bereits einheitlich. Der Hook setzt das Feld dort bewusst nicht.

### 6.5 Was die Adjacency-Einstellung wirklich bewirkt

**Sie steuert ausschliesslich, was das Kraftwerk seinen Nachbarn GIBT - nicht, was es
bekommt.** Belegt an vier Codestellen:

| Datei | Funktion | Zeile | Muster |
|---|---|---|---|
| `defaultunits.lua` | `StructureUnit:OnAdjacentTo` | 983 | `ApplyBuff(adjacentUnit, v, self)` |
| `defaultunits.lua` | `StructureUnit:OnNotAdjacentTo` | 1013 | `RemoveBuff(adjacentUnit, v, ...)` |
| `Unit.lua` | `OnProductionUnpaused` | 1274 | `ApplyBuff(unit, v, self)` |
| `Unit.lua` | `OnProductionPaused` | 1228 | `RemoveBuff(unit, v, ...)` |

Ueberall wird `__blueprints[self.BlueprintID].Adjacency` gelesen - das eigene Blueprint,
nie das des Nachbarn.

Die Kategoriemasken bestaetigen es unabhaengig davon:

```
Hydrocarbon-Buffs:  STRUCTURE * SIZEn - NUKE - ENERGYPRODUCTION
Speicher-Buffs:     STRUCTURE * ENERGYPRODUCTION * SIZEn
```

Die Hydrocarbon-Buffs schliessen `ENERGYPRODUCTION` ausdruecklich aus - ein Kraftwerk
koennte sie gar nicht empfangen.

**Praktische Folge:** wer ein T3-Hydrokraftwerk mit Energiespeichern umbaut, merkt von
dieser Einstellung **nichts**. Speicher bauen nicht und verbrauchen keine Wartungsenergie,
die Buffs greifen ins Leere. Der Nutzen des Speicherrings kommt aus der Gegenrichtung:
`UEB1105` traegt `Adjacency = 'T1EnergyStorageAdjacencyBuffs'`, davon greift bei einem
`SIZE12`-Nachbarn genau ein Eintrag - `T1EnergyStorageEnergyProductionBonusSize12`,
`EnergyProduction Add = 0.033`, also **+3,3 Prozent je Speicher**, `Stacks = 'ALWAYS'`.
Bei 4075 Energie/s waeren das rechnerisch rund 4209 bei einem und rund 6227 bei sechzehn
Speichern. **Nicht im Spiel gemessen**, und ob `BuffCalculate` linear addiert oder
deckelt, ist ungeprueft.

Die Einstellung wirkt also nur bei Nachbarn, die Energie verbrauchen: Fabriken, Schilde,
Massefabrikatoren, Verteidigung.

### 6.6 Die drei Buff-Tabellen im Vergleich

Aus `gamedata.entpackt\lua\lua\sim\AdjacencyBuffs.lua`, alle Werte `Mult = 1.0`,
gewirkt wird ueber `Add` (negativ = Ersparnis):

| Groesse des Nachbarn | Hydrocarbon (Z. 623) | T3PowerGenerator (Z. 1078) | Faktor |
|---|---:|---:|---:|
| 4, 8, 12 | -0,100 | -0,150 | 1,50 |
| 16 | -0,075 | -0,150 | 2,00 |
| 20 | -0,060 | -0,120 | 2,00 |
| 24 | -0,050 | -0,100 | 2,00 |
| 30 | -0,040 | -0,075 | 1,875 |
| 32 | -0,035 | -0,070 | 2,00 |
| 36 | -0,030 | -0,060 | 2,00 |
| 40 | -0,025 | -0,040 | 1,60 |
| 44 | -0,020 | -0,035 | 1,75 |
| 48 | -0,015 | -0,030 | 2,00 |

Gilt fuer `EnergyActive` (Bauen) und `EnergyMaintenance` (Betrieb) gleichermassen - die
beiden Reihen sind Zeile fuer Zeile identisch. Dazu Waffenenergie (Hydro: -0,04 / -0,0375
/ -0,03 fuer Size 4-12 / 16 / 20; T3: ein einziger Eintrag -0,08 fuer Size 4-16) und
Feuerrate (-0,04 gegen -0,075, nur Size 4).

`T2PowerGeneratorAdjacencyBuffs` (Z. 655) ist **Eintrag fuer Eintrag identisch** mit
`HydrocarbonAdjacencyBuffs` - 24 gegen 24, dieselben Buff-Namen. Ein Wechsel zwischen
beiden aendert nichts.

**Hydrocarbon und T3PowerGenerator sind dagegen zwei voellig getrennte Saetze eigener
`BuffBlueprint`-Definitionen** - die Schnittmenge der Buff-Namen ist **leer**. Die eine
Liste heisst durchgaengig `T2Power...`, die andere `T3Power...`; keine einzige Definition
wird geteilt. Es ist also nicht eine Tabelle mit skalierten Zahlen, sondern zwei
unabhaengige Tabellen.

**Ein einzelner Faktor bildet den Unterschied deshalb auch nicht ab:** 15 der 30
verglichenen Zeilen liegen auf 2,0, die kleinen Groessen 4-12 aber auf 1,5, dazu 1,6, 1,75,
1,875 und 2,133. Zwei Unterschiede sind zudem struktureller Natur - Size 16 wechselt die
Groessenklasse (`Size4to16` statt einer eigenen Stufe), und der Waffenbonus fuer Size 20
entfaellt bei T3 ersatzlos. Ein Faktor kann einen Eintrag nicht loeschen.

**Das erkennbare Bildungsgesetz ist eine Verschiebung, keine Skalierung.** Sechs der neun
T3-Werte stehen wortgleich in der Hydrocarbon-Kurve, nur bei groesseren Nachbarn:

| Wert | bei Hydrocarbon | bei T3PowerGenerator |
|---:|---|---|
| -0,100 | Size 4-12 | Size 24 |
| -0,075 | Size 16 | Size 30 |
| -0,060 | Size 20 | Size 36 |
| -0,040 | Size 30 | Size 40 |
| -0,035 | Size 32 | Size 44 |
| -0,030 | Size 36 | Size 48 |

T3 gibt einem grossen Nachbarn also das, was Hydrocarbon einem deutlich kleineren gibt.
Drei Werte fallen aus dem Muster und kommen in der Hydrocarbon-Kurve gar nicht vor:
-0,15 (Size 4-16), -0,12 (Size 20) und -0,07 (Size 32).

Deshalb werden die Tabellen zur Auswahl gestellt statt skaliert.

### 6.7 Verworfen: eine eigene Settings-Datei per `import`

Zuerst vorgesehen war `lua\Settings.lua` plus `import()` im Hook. Verworfen, weil
**nicht belegbar ist, ob `import` in der Blueprint-Ladephase ueberhaupt verfuegbar ist**:
`Blueprints.lua` selbst benutzt dort `doscript`, nie `import`; auch BrewLANs
833-Zeilen-Hook auf dieselbe Datei kommt ohne aus, und keiner der rund 45 geprueften
Blueprints nutzt `import`.

`config.lua` ist der bessere Weg: dokumentierter Mechanismus, im Mod-Manager sichtbar,
keine Hardcodierung.

### 6.8 Wie die Konfiguration ankommt

`config.lua` wird von `mods.lua`, `AllMods()` (Z. 277-292) gelesen. Zwei Eigenheiten:

- **`default` ist ein 1-basierter INDEX** in die `values`-Liste, kein Schluessel:
  `allConfigs[mod.uid][v.key] = v.values[v.default].key`.
- **Die Werte liegen im Spielerprofil** (`Prefs`, Schluessel `modConfig`), nicht im Mod,
  und werden nur gesetzt, **wenn dort noch nichts steht** (Z. 285). Eine spaetere
  Aenderung der Vorgabe wirkt also nur bei Spielern, die den Mod nie eingestellt haben.

Zur Laufzeit liest der Hook sie ueber `__active_mods`:

```lua
for _, mod in __active_mods do
    if mod.uid == MODUID then
        Konfiguration = mod.config
        break
    end
end
```

**Dass `__active_mods` und `mod.config` in der Blueprint-Ladephase verfuegbar sind, ist
belegt** - LOUDs eigener Mod `Enhanced Static HP` macht genau das:
`gamedata.entpackt\loud_misc\mods\Enhanced Static HP\hook\lua\system\Blueprints.lua`.

Der Hook faellt auf die im Code hinterlegten Vorgabewerte zurueck, falls die Konfiguration
fehlt, und protokolliert das.

## 7. Referenzen nach aussen - vollstaendige Liste

**Kein `/mods/`-Verweis, kein Import aus `BlackOpsUnleashed`.** Die acht Einheiten haben
keine Waffen und brauchen daher keines der BlackOps-Lua-Module
(`BlackOpsweapons.lua`, `BlackOpsprojectiles.lua` usw.).

### 7.1 Animationen - Basisspiel

| Blueprint | Feld | Pfad |
|---|---|---|
| `BEB1202` Z. 50, `BEB1302` Z. 44 | `AnimationOpen` | `/units/UEB1102/ueb1102_Aopen.sca` |
| `BSB1202` Z. 43, `BSB1302` Z. 40 | `LoopingAnimation` | `/units/XSB1102/XSB1102_aloop.sca` |

Beide Ziele liegen in `units.scd` (`gamedata.entpackt\units\units\UEB1102\` bzw.
`XSB1102\`) - **vorhanden, geprueft**. Aeon und Cybran haben keine Animation.

### 7.2 Texturen

`/textures/environment/Falloff_seraphim_lookup.dds` - `BSB1202` Z. 45, `BSB1302` Z. 46.
Aus `textures.scd`.

### 7.3 Emitter in den Scripts

| Emitter | verwendet von |
|---|---|
| `/effects/emitters/hydrocarbon_smoke_01_emit.bp` | UEF, Aeon, Cybran |
| `/effects/emitters/hydrocarbon_heatshimmer_01_emit.bp` | Seraphim |
| `/effects/emitters/underwater_idle_bubbles_01_emit.bp` | alle acht (Seabed) |

### 7.4 Lua-Importe

| Script | Import |
|---|---|
| `BEB1202` `BEB1302` `BRB1202` `BRB1302` | `/lua/defaultunits.lua` -> `EnergyCreationUnit` |
| `BAB1202` `BAB1302` | `/lua/defaultunits.lua` -> `StructureUnit` |
| `BSB1202` `BSB1302` | `/lua/seraphimunits.lua` -> `SEnergyCreationUnit` |

### 7.5 Sounds - vorhandene Banks, kein `sounds\`-Ordner

`UELDestroy` (UEF) - `UALDestroy` (Aeon) - `URLDestroy` (Cybran) - `XSL_Destroy`
(Seraphim) - `Interface` und `SeraphimSelect` (Auswahl). Damit greift die
`.xwb`-Kollisionsfalle aus `11_DATAPATH.md` Abschnitt 2 Regel 4 nicht.

### 7.6 Icons - schon im Spiel

Alle acht liegen in `textures.scd`:
`gamedata.entpackt\textures\textures\ui\common\icons\units\BEB1202_icon.dds` und die
sieben uebrigen. `LoadBlueprints()` (Z. 1300) sucht nur dann im Mod nach einem Icon, wenn
dort keines liegt - **der Mod braucht keine eigenen Icons.**

Strategiesymbole: `icon_structure2_energy` (1202) und `icon_structure3_energy` (1302).

### 7.7 Adjacency

`HydrocarbonAdjacencyBuffs` (sechs von acht) bzw. `T2/T3PowerGeneratorAdjacencyBuffs`
(Aeon) - alle drei stehen in `gamedata.entpackt\lua\lua\sim\AdjacencyBuffs.lua`
Z. 623, 655 und 1078. **Der Mod muss dafuer nichts mitliefern.**

### 7.8 Lokalisierung

`<LOC beb1202_name>HCPP - X2000` usw. Der Mod bringt keine eigene Lokalisierung mit; fehlt
der Schluessel, greift der Klartext dahinter. Aeon und Cybran haben ueberhaupt keinen
`UnitName`, dort erscheint die `Description`.

## 8. Erbfehler aus BlackOps - nicht korrigiert

`BRB1202_script.lua` und `BRB1302_script.lua` deklarieren beide die Klasse **`URB1102`**
statt `BRB1202` / `BRB1302`. Das steht **wortgleich so im BlackOps-Original** - kein
Kopierfehler.

Funktional folgenlos, weil `TypeClass = URB1102` unmittelbar darunter zugewiesen wird und
damit die richtige Klasse greift. Beide Dateien belegen aber denselben globalen Namen, und
zwar denselben wie das Cybran-T1-Hydrokraftwerk. **Nicht angefasst** - eine Aenderung ohne
belegten Anlass, und der Extrakt soll byte-nah am Original bleiben.

## 9. Abhaengigkeiten und Konflikte

- **`requires`:** keine.
- **`conflicts`:** `9e8ea941-c306-4751-b367-a11000000502` (BlackOps Unleashed Units for LOUD).
- **`before` / `after`:** nicht gesetzt.
- **`LOUD Integrated Storage`** bringt fuer die vier `1302` ein Merge mit
  (`loud_misc\mods\LOUD Integrated Storage\hook\units\<ID>\`). Wird laut Entscheidung vom
  2026-08-15 nicht gesondert behandelt. **Was genau es aendert, ist noch nicht geprueft** -
  bei den Squareshields war es ein einzelnes Feld.

## 10. Performance / Multiplayer

Keine Lua-Logik ausserhalb der acht Unit-Scripts (unveraendert aus `BlackOpsUnleashed`)
und des Blueprint-Hooks, der einmal beim Laden laeuft und acht Tabelleneintraege setzt.
Sim-Mod, also von allen Spielern benoetigt.

**UNGEPRUEFT - moegliches Desync-Risiko:** die Mod-Konfiguration wird laut `mods.lua`
Z. 266 aus `Prefs.GetFromCurrentProfile("modConfig")` gelesen, also aus dem **lokalen**
Profil. Ob die Lobby den gewaehlten Wert an alle Spieler uebertraegt oder ob jeder
Rechner seine eigene Einstellung verwendet, ist **nicht geprueft**. Im zweiten Fall
wuerden bei unterschiedlichen Einstellungen die Blueprints auseinanderlaufen. **Vor dem
Gruppeneinsatz klaeren** - siehe `TODO.md`.

## 11. Tests

| Datum | Was getestet | Ergebnis |
|---|---|---|
| 2026-08-15 | alle acht Scripts gegen `BlackOpsUnleashed` gediffed | 0 Unterschiede |
| 2026-08-15 | alle acht Blueprints gegen `BlackOpsUnleashed` gediffed | nach der Anpassung 0 Unterschiede |
| 2026-08-15 | `BAB1202` gegen `UEF_trans_men` gediffed | identisch - Abweichung war Altbestand |
| 2026-08-15 | Aufstiegskette gegen die Basiseinheiten geprueft | vollstaendig |
| 2026-08-15 | Buff-Tabellen in `AdjacencyBuffs.lua` verglichen | T2 deckungsgleich, T3 disjunkt |
| 2026-08-15 | Fremdverweise vollstaendig aufgelistet | keiner ausserhalb des Spiels |
| - | Start im Spiel | **noch nicht** |

Log-Praefix dieses Mods: `IHPP:`

## 12. Offene Punkte

- [ ] **Testlauf.** Erwartet im Log, in dieser Reihenfolge:
      `Mounting mod 'improvedhydrocarbonpowerplants'`,
      `Hooked /lua/system/Blueprints.lua with /mods/improvedhydrocarbonpowerplants/hook/lua/system/Blueprints.lua`,
      `IHPP: T2 - RegenRate = 2, Adjacency = ..., StorageEnergy = 200`,
      `IHPP: T3 - RegenRate = 4, Adjacency = ..., StorageEnergy = unveraendert`,
      `IHPP: 8 von 8 Kraftwerken vereinheitlicht`.
      Im Spiel: T1-Hydrokraftwerk mit Aufstiegsknopf, Aufstieg bis Stufe 3 durchspielbar.
- [ ] **Hat BSB1202 jetzt 200 Energiespeicher?** Im Spiel an der Einheitenanzeige
      pruefen - das ist die einzige feste Aenderung gegenueber dem Original.
- [ ] **Erscheinen die Einstellungen im Mod-Manager?** `config.lua` ist neu und
      **ungeprueft**. Erwartet werden vier Auswahlfelder. Erscheint stattdessen
      `Mod ... has an empty or malformed config file` im Log, ist die Datei fehlerhaft.
- [ ] **Wirkt die Einstellung?** Wert umstellen und die `IHPP:`-Zeile im Log vergleichen.
- [ ] **Multiplayer: wird die Konfiguration uebertragen?** Siehe Abschnitt 10. **Vor dem
      Gruppeneinsatz klaeren.**
- [ ] **Greift `conflicts`?** Im Mod-Manager pruefen, ob `BlackOpsUnleashed` und dieser
      Mod wirklich nicht gleichzeitig aktivierbar sind. Bisher nur aus `mods.lua`
      abgeleitet.
- [ ] **Wird das Mod-Bild angezeigt?** `icon` zeigt auf ein `.dds` aus `textures.scd`
      statt auf eine Datei im Mod. Dass `SetTexture()` damit umgehen kann, ist aus
      `modmanager.lua` abgeleitet, aber **nicht im Spiel gesehen**.
- [ ] **Baut die KI sie?** `BO_Buildings.lua` in `BlackOpsUnleashed` fuehrt eine
      `UnitList` fuer LOUDs KI - die Hydrocarbons stehen **nicht** darin. Ob die KI sie
      trotzdem ueber die normalen Kraftwerks-Builder aufsteigt, ist **ungeprueft**. Der
      Mechanismus hinter `lua\CustomUnits\` ist ohnehin noch nicht gelesen (`TODO.md`).
- [ ] **Was aendert `LOUD Integrated Storage` an den vier `1302`?** Ungeprueft.

## 13. Referenzen

- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\units\`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\mod_info.lua`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\lua\CustomUnits\BO_Buildings.lua`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\units\units\UEB1102\UEB1102_unit.bp` (und `UAB1102`, `URB1102`, `XSB1102`)
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\AdjacencyBuffs.lua`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\system\Blueprints.lua`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\mods.lua` (Abschnitt `AllMods`, Z. 262-300)
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\ui\dialogs\modmanager.lua` (Z. 794-801, 1131, 1236-1238, 1365)
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loud_misc\mods\Enhanced Static HP\config.lua` - Vorbild fuer `config.lua`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loud_misc\mods\Enhanced Static HP\hook\lua\system\Blueprints.lua` - Vorbild fuer den Zugriff auf `mod.config`
