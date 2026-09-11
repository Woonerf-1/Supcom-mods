# 18 - Ableitung aus `UEF_trans_men`

**Stand: 2026-08-15. Reine Analyse - es wurde noch kein Mod-Code geaendert.**

Aus dem Sammelmod `usermods\UEF_trans_men\` (97 Einheiten) sollen **vier eigenstaendige,
voneinander unabhaengige Mods** entstehen. Die vier Ordner hat der Kollege - derselbe
Autor wie `UEF_trans_men` - bereits angelegt und befuellt.

Dieses Dokument haelt fest, **was dort steht** und **was daran nachweislich stimmt oder
nicht stimmt**. Je Mod gibt es ein eigenes Dokument unter `mods\`.

---

## 1. Der Zuschnitt

| Mod | Ordner | uid | Einheiten Soll | Ist |
|---|---|---|---:|---:|
| Experimental Additions | `usermods\t4add\` | `expt4modsV01` | 8 | **9** |
| Squareshields | `usermods\SquareShields\` | `D5F66739-FD09-4166-8D73-A5D496772B7C` | 4 | 4 |
| Improved Hydrocarbons | `usermods\ImprovedHydrocarbonPowerPlants\` | `AD88F006-304B-42E6-8612-E63918A7BE22` | 8 | 8 |
| Dynamic Gameplay | `usermods\dynamic_gameplay\` | `Dynamic_gameplay_Version01` | 4 | 4 |

Abweichung: **`VEB2302` liegt zusaetzlich in `t4add`** und steht nicht auf der Sollliste.

Dieser Zuschnitt ist **nicht identisch** mit dem aus `12_NEUSCHNITT.md` Abschnitt 3
(`BasegameBugfixes`, `T4MassExtractors`, `CustomAI`, `PlayTest`). Er kommt hinzu.

### Einzelne Dokumente

- [mods/SquareShields.md](mods/SquareShields.md) - geprueft und angepasst 2026-08-15
- `mods/t4add.md` - noch nicht angelegt
- [mods/ImprovedHydrocarbonPowerPlants.md](mods/ImprovedHydrocarbonPowerPlants.md) - geprueft und angepasst 2026-08-15
- `mods/dynamic_gameplay.md` - noch nicht angelegt

**Umbenennungen:** `usermods\HCPP\` heisst seit 2026-08-15
`usermods\ImprovedHydrocarbonPowerPlants\`, der Anzeigename lautet jetzt
"Improved Hydrocarbon PowerPlants" statt "MoreHydro". Die `uid` blieb unveraendert.

---

## 2. Der zentrale Befund: nichts davon ist neu

**Alle 25 Blueprints existieren bereits in einem von LOUD mitgelieferten Mod.** Die vier
Mods fuegen dem Spiel keine Einheiten hinzu - sie **ueberschreiben** vorhandene.

Erhoben aus `units\_generiert\units.csv` (Stand 2026-08-06, ohne die vier neuen Ordner):

| ID | liegt ausserdem in |
|---|---|
| `UAL0402` `UEL0402` | `4DC` (`gamedata.entpackt\4D-CompatibilityPack\mods\4DC\`) |
| `WEL0401` `WSL0404` | `BattlePack` (`gamedata.entpackt\WyvernBattlePack\mods\BattlePack\`) |
| `SSL0403` `SSA0001` `SEB3404` `SRB4402` | `BrewLAN_LOUD` (`gamedata.entpackt\brewlan\mods\BrewLAN_LOUD\`) |
| `UEL0401` | **Basisspiel** (`gamedata.entpackt\units\units\UEL0401\`) |
| `VEB2302` | `LOUD Unit Additions` |
| `UEBSSG01` `UABSSG01` `URBSSG01` `XSBSSG01` | `LOUD Unit Additions` **und** `LOUD Integrated Storage` |
| `BEB1202` `BEB1302` `BAB1202` `BAB1302` `BRB1202` `BRB1302` `BSB1202` `BSB1302` | `BlackOpsUnleashed`; die vier T3 zusaetzlich in `LOUD Integrated Storage` |
| `BSL0005` `BSB2402` | `BlackOpsUnleashed` |
| `MKT0409` | nirgends sonst - einzige echte Neuheit |

Daraus folgt fuer jeden der vier Mods dieselbe Leitfrage:

> **Was aendert dieser Mod gegenueber dem, was LOUD ohnehin mitbringt - und rechtfertigt
> das eine Vollkopie?**

### Diff gegen die LOUD-Originale

Verfahren: beide `_unit.bp` in die Analyseumgebung kopieren, `\r` entfernen, `diff`.

| Blueprint | geaenderte Zeilen | Inhalt |
|---|---:|---|
| `BEB1202` `BEB1302` `BRB1202` `BRB1302` `BSB1202` `BSB1302` | **0** | byte-identisch |
| `BSL0005` `MKT0409` `SEB3404` `SRB4402` `SSA0001` | **0** | byte-identisch |
| `UABSSG01` `UEBSSG01` `URBSSG01` `XSBSSG01` `VEB2302` | **0** | byte-identisch |
| `BAB1202` | 3 | `Adjacency` -> `T2PowerGeneratorAdjacencyBuffs`, `RegenRate = 10` |
| `BAB1302` | 2 | `Adjacency` -> `T3PowerGeneratorAdjacencyBuffs` |
| `BSB2402` | 2 | nur Pfadumschreibung nach `/mods/dynamic_gameplay/` |
| `SSL0403` | 6 | drei Animationspfade - **kaputt**, siehe Abschnitt 4 |
| `UEL0401` | 3 | `TransportClass` 10 -> 4, `RULEUCC_CallTransport` |
| `WSL0404` | 4 | `BuildTime` 2500 -> 8000, `TransportClass` 10 -> 4 |
| `UAL0402` | 28 | HP 60000 -> 50000, Energie 395k -> 55k, Masse 23k -> 25k, `BuildTime` 6585 -> 9000, `MaxRadius` 60 -> 42 |
| `UEL0402` | 25 | HP 36500 -> 25000, Masse 14000 -> 9000, `BuildTime` 35000 -> 7000, neu `REPAIR` `PATROLHELPER` `Capture` `Repair`, transportierbar |
| `WEL0401` | 41 | `TurretYawSpeed` durchgehend hoeher, `TurnRadius` 4 -> 0, transportierbar, Schildregeneration |

**15 von 25 Blueprints sind unveraenderte Kopien.** Die inhaltliche Klammer ueber `t4add`
ist erkennbar: fast alles wird **transportierbar** gemacht (`TransportClass 10 -> 4`) -
passend zur Acclamator als Traeger.

---

## 3. Nachgeprueft: wie das Modsystem wirklich arbeitet

Anlass war eine Fehlannahme in einer frueheren Analyse. Die folgenden Punkte sind am Code
belegt, nicht abgeleitet.

### 3.1 `mount_mods` - ein Mount, keine Wurzel

`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\bin\CommonDataPath.lua`,
Funktion `mount_mod`:

```lua
local function mount_mod(modName, modDir)
    LOG("Mounting mod '"..modName.."' with additional functionality (e.g. sounds)");
    loaded_mods[modName] = true;
    mount_dir(modDir, "/mods/"..modName);       -- der EINZIGE Mount des Ordners
    for _, fileOrFolder in upvIo_dir(modDir.."/*") do
        if fileOrFolder == 'sounds' then ... mount_dir(fullPath, "/sounds") ... end
    end
end
```

Ein Mod-Ordner erscheint ausschliesslich unter `/mods/<kleingeschrieben>/`. Einzige
Ausnahme ist `sounds\` -> `/sounds`. Bestaetigt im `LOUD.log`, wo auch `.git` und
`doc.claude` als Mods auftauchen.

**Wichtig - `/mods/` gehoert nicht nur uns.** `LoudDataPath.lua` mountet alle `.scd` aus
`gamedata\` nach `/`. Enthaelt ein Archiv einen Ordner `mods\`, landet dessen Inhalt
ebenfalls unter `/mods/`:

```
gamedata.entpackt\brewlan\mods\BrewLAN_LOUD\      ->  /mods/BrewLAN_LOUD/
gamedata.entpackt\4D-CompatibilityPack\mods\4DC\  ->  /mods/4DC/
gamedata.entpackt\loud_misc\mods\<24 Mods>\       ->  /mods/<n>/
gamedata.entpackt\loud_units\mods\LOUD Unit Additions\ -> /mods/LOUD Unit Additions/
```

Harte Verweise auf diese Pfade sind daher **legitim**, solange der Pfad auch wirklich
aufloest. Sie bleiben eine theoretische Fehlerquelle, weil `gamedata\` beim naechsten
LOUD-Update ersetzt wird.

### 3.2 `lua\` gegen `hook\lua\` - der Unterschied liegt im Inhalt

Ein Unterordner `lua\sim\...` im Mod ist voellig normal. `BrewLAN_LOUD` betreibt beides
nebeneinander:

```
gamedata.entpackt\brewlan\mods\BrewLAN_LOUD\
  hook\lua\sim\Unit.lua              <- patcht /lua/sim/Unit.lua
  hook\lua\sim\DefaultWeapons.lua
  hook\lua\system\Blueprints.lua
  lua\sim\defaultweapons.lua         <- eigenes Modul
  lua\sim\NukeDamage.lua             <- eigenes Modul
  lua\legacy\VersionCheck.lua        <- eigenes Modul
```

| | Modul | Patch |
|---|---|---|
| Ort | `lua\...` | `hook\lua\<VFS-Pfad>` |
| Laden | nur wenn jemand `import('/mods/<n>/lua/...')` aufruft | automatisch nach der Originaldatei |
| Erkennungsmerkmal | definiert neue Klassen, gibt eine Tabelle zurueck | `local Old = X ; function X(...)` |

**Entscheidungsregel:** Wer eine bestehende globale Funktion umhuellt, braucht `hook\`.
Wer neue Dinge definiert, die jemand importiert, gehoert nach `lua\`. Der Ort allein sagt
nichts.

Sonderfall Buffs: `Buffs` und `BuffBlueprint` sind **global**
(`gamedata.entpackt\lua\lua\system\BuffBlueprints.lua` Z. 5 und 24). Eine Datei mit
`BuffBlueprint{...}` registriert also von jedem Ort aus - sie muss nur **ueberhaupt
ausgefuehrt** werden.

### 3.3 `shadow`

Quelle: `gamedata.entpackt\lua\lua\mods.lua` Z. 153-158 (Kopfkommentar; die Umsetzung ist
engineseitig).

Der Ordner spiegelt die oberste Spielverzeichnisebene. Eine Datei dort **ersetzt** die
Spieldatei bei jedem Lookup - die Originaldatei wird **vollstaendig unerreichbar**, auch
fuer `import`. Kein Verketten, kein Zugriff aufs Original. Bricht damit auch alle Hooks
anderer Mods auf dieselbe Datei.

Standardpfad `/shadow`, aenderbar ueber `shadowdir` (Z. 239). Grossanwender:
`usermods\nomads-4-loud\` (`11_DATAPATH.md` Abschnitt 4).

### 3.4 `hook`

`mods.lua` Z. 160-165: nach dem Laden einer Skriptdatei prueft die Engine alle aktiven
Mods auf eine gleichnamige Datei unter `hookdir` und fuehrt sie **in derselben Umgebung**
aus. Mehrere Mods koennen dieselbe Datei hooken - Reihenfolge ueber `before`/`after`.

Nachweis im Log (`LOUD\bin\LOUD.log`, letzte Partie, genau 10 Zeilen):

```
Hooked /lua/system/Blueprints.lua with /mods/enhanced resources/hook/lua/system/Blueprints.lua
Hooked /lua/aibrain.lua           with /mods/customai/hook/lua/aibrain.lua
Hooked /lua/simInit.lua           with /mods/customai/hook/lua/simInit.lua
...
```

**Hooks werden erst beim Sitzungsstart angewandt**, nicht beim Mounten - deshalb greift
kein Hook in der Lobby (Befund aus Testlauf 7, siehe `TODO.md`).

### 3.5 `Merge`

`gamedata.entpackt\lua\lua\system\Blueprints.lua`, `StoreBlueprint()`:

```lua
local function StoreBlueprint(group, bp)
    local id = bp.BlueprintId
    local t = original_blueprints[group]
    if t[id] and bp.Merge then
        bp.Merge = nil
        bp.Source = nil
        t[id] = table.merged(t[id], bp)
    else
        t[id] = bp                      -- Vollersatz
    end
end
```

Zwei Bedingungen zugleich: die ID muss **schon vorhanden** sein **und** `Merge = true`
gesetzt. Sonst Vollersatz.

`table.merged` (`gamedata.entpackt\lua\lua\system\utils.lua` Z. 130) arbeitet **rekursiv
ueber Untertabellen**. Aus dem Kommentar dort:

```
t1 = { x=1, y=2, sub1={z=3}, sub2={w=4} }
t2 = { y=5, sub1={a=6}, sub2="Fred" }
merged(t1,t2) -> { x=1, y=5, sub1={a=6,z=3}, sub2="Fred" }
```

**Falle:** Listen (`Categories`, `Weapons`) sind numerisch indizierte Tabellen. Sie werden
**positionsweise** gemerged, nicht angehaengt. Ein Merge mit drei Kategorien ueberschreibt
die ersten drei Eintraege. Fuer Kategorienlisten ist `ModBlueprints()` der richtige Weg
(`Blueprints.lua` Z. 521).

**Musterbeispiel aus LOUDs eigenem Material** -
`gamedata.entpackt\loud_misc\mods\LOUD Integrated Storage\hook\units\UEBSSG01\UEBSSG01_unit.bp`,
**22 Zeilen statt 194**, kein einziges Asset:

```lua
UnitBlueprint {
    Merge = true,
    BlueprintId = "uebssg01",
    Economy = { BuildRate = 25, BuildableCategory = { 'uebssg02' }, ... },
    General = { CapCost = 10, UpgradesTo = 'uebssg02', ... },
}
```

Beachtenswert: die Datei liegt unter `hook\units\...`, nicht unter `units\`. Blueprints
sind Lua-Skripte, also greift der Hook-Mechanismus auch fuer `.bp`.

---

## 4. Fremdverweise - was aufloest und was nicht

| Verweis | Fundort | Auflösung |
|---|---|---|
| `/mods/4DC/units/uel0402/...`, `/mods/4DC/env/common/splats/...` | `t4add\units\UEL0402\UEL0402_unit.bp` Z. 73/74/100/116 | **loest auf** |
| `/mods/brewlan_LOUD/env/common/decals/Tarmacs/Tar18x_01_*.dds` | `dynamic_gameplay\units\SEB3404\SEB3404_unit.bp` Z. 104/105 | **loest auf**, steht so schon im BrewLAN-Original |
| `/mods/brewlan/mods/BrewLAN_LOUD/units/ssl0403/...` | `t4add\units\SSL0403\SSL0403_unit.bp` Z. 82/88/620 | **loest NICHT auf** |
| `/mods/t4add/...` | mehrere in `t4add` | loest auf, korrekt umgeschrieben |
| `/mods/dynamic_gameplay/...` | `SEB3404_Script.lua` Z. 30, `BSB2402_unit.bp` Z. 40 | loest auf, korrekt umgeschrieben |

**Kein einziger Verweis auf `/mods/uef_trans_men/`** - die Umschreibung wurde vollstaendig
durchgezogen.

Der SSL0403-Fall ist eine **eingebaute Regression**: das BrewLAN-Original schreibt korrekt
`/mods/BrewLAN_LOUD/units/ssl0403/...`. Das zusaetzliche `/mods/brewlan/mods/` davor
existiert im VFS nicht. Folge: Iyadesu verliert Lauf-, Angriffs- und Todesanimation.

---

## 5. Weitere Einzelbefunde

- **`SRB4402_script.lua` ist eine aeltere Fassung als LOUDs.** LOUD hat die Zeile
  `local BrewLANPath = import('/lua/game.lua').BrewLANPath()` entfernt und `sab2306` zur
  Ausnahmeliste ergaenzt. `BrewLANPath()` existiert zwar noch
  (`gamedata.entpackt\lua\lua\game.lua` Z. 30), liefert aber `nil`, wenn kein Mod mit der
  uid `25D57D85-7D84-27HT-A501-BR3WL4N000079` aktiv ist.
- **`BRB1202_script.lua` und `BRB1302_script.lua` in `ImprovedHydrocarbonPowerPlants`
  deklarieren beide die Klasse `URB1102`.** Funktional folgenlos, weil `TypeClass` direkt
  darunter zugewiesen wird - aber beide belegen denselben globalen Namen. Aus dem
  Ursprungsmaterial mitkopiert.
- **`T2PowerGeneratorAdjacencyBuffs` und `T3PowerGeneratorAdjacencyBuffs` existieren in
  LOUD** (`gamedata.entpackt\lua\lua\sim\AdjacencyBuffs.lua` Z. 655 und 1078,
  `HydrocarbonAdjacencyBuffs` Z. 623). `ImprovedHydrocarbonPowerPlants` braucht dafuer
  **keine** mitgelieferte Datei.
- **Alle vier uids waren keine GUIDs** - Verstoss gegen `12_NEUSCHNITT.md` Abschnitt 4
  Regel 4. Behoben fuer `SquareShields` und `ImprovedHydrocarbonPowerPlants`
  (2026-08-15); offen fuer `t4add` und `dynamic_gameplay`.
- **Kein Mod setzte `requires`, `conflicts`, `before` oder `after`** - obwohl alle vier mit
  LOUD-eigenen Mods um dieselben Blueprint-IDs konkurrieren. `conflicts` gesetzt fuer
  `SquareShields` (gegen `LOUD Unit Additions`) und `ImprovedHydrocarbonPowerPlants`
  (gegen `BlackOpsUnleashed`).

---

## 6. Offen

- Ob BrewLANs eigener Hook
  `gamedata.entpackt\brewlan\mods\BrewLAN_Units\BrewResearch\hook\lua\sim\AdjacencyBuffs.lua`
  unter LOUD ueberhaupt durchlaeuft: er referenziert `AdjBuffFuncs` und `DefaultBuffAffect`,
  beide sind in LOUDs `AdjacencyBuffs.lua` **`local`** (Z. 1, 3, 4). Ein Hook laeuft in
  derselben *Umgebung*, sieht aber die *Locals* des Originalchunks nicht. Nur mit einem
  Testlauf bei aktivem `BrewLAN_Units` zu klaeren. -> `TODO.md`
- Ob die Wertaenderungen aus Abschnitt 2 vom Kollegen stammen oder aus `UEF_trans_men`
  uebernommen sind. Stichprobe `UEBSSG01`: identisch, also Altbestand. Fuer `UAL0402`,
  `UEL0402`, `WEL0401` noch nicht geprueft.
- Die Scripts der 25 Einheiten gegen ihre Originale - bisher nur fuer `SquareShields`
  vollstaendig und fuer `SRB4402` einzeln gemacht.
