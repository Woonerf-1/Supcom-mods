# 01 — Architektur: Ordner, VFS und Ladekette

## 1. Ordnerlandkarte

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\   ← $FA (Vanilla)
├── gamedata\            Vanilla-.scd (textures, effects, env, projectiles, props, meshes)
├── fonts\  movies\  sounds\
└── LOUD\                                                                          ← $LOUD
    ├── bin\             LoudDataPath.lua, CommonDataPath.lua, LOUD.log, StratIcon-.scd
    ├── doc\             Original-Readmes der LOUD-Distribution (NICHT unsere Doku)
    ├── gamedata\        LOUD-Inhalte als .scd (17 Archive, ~890 MB)
    ├── gamedata.entpackt\  entpackte 1:1-Kopie von gamedata\  🔒 Referenz, nur lesen
    ├── maps\  usermaps\  sounds\
    └── usermods\        ← unsere Mods  ✅ schreibbar, Git-Repository
        ├── .git\            ⛔ tabu
        ├── doc.claude\      ← unsere Doku  ✅ schreibbar
        └── <Mod-Ordner>\
```

## 2. `.scd` = ZIP

`.scd`-Dateien sind umbenannte ZIP-Archive (teils unkomprimiert, `method=store`).
`gamedata.entpackt\` enthält genau deren Inhalt.

### Direkt lesen oder entpackt lesen?

**Entpackt — immer.** Technisch könnte ein Archiv einzeln in die Analyseumgebung kopiert und
dort ausgepackt werden (getestet mit `loc_US.scd`, funktioniert). Praktisch scheitert das an
den Größen: `units.scd` hat 306 MB, `brewlan.scd` 200 MB. Und selbst bei kleinen Archiven
wäre jede Suche ein Einzelvorgang.

`gamedata.entpackt\` dagegen ist sofort und vollständig durchsuchbar — `search_files` über
890 MB Spieldaten, ohne Kopieren. **Das Entpacken lohnt sich also klar** und ist die
Grundlage der gesamten Referenzarbeit.

### ⚠️ Aktualität prüfen — `gamedata\` wird vom LOUD-Team gepflegt

`gamedata.entpackt\` ist eine **Momentaufnahme**. Nach jedem LOUD-Update sind die `.scd`
neu, der entpackte Stand aber alt — und dann würde gegen veralteten Referenzcode gearbeitet.

**Prüfung zu Sessionbeginn bei Codearbeit:**

```
get_file_info  LOUD\gamedata\<archiv>.scd            → modified
get_file_info  LOUD\gamedata.entpackt\<archiv>\      → created

created (Ordner) ≥ modified (.scd)   → aktuell
created (Ordner) <  modified (.scd)   → VERALTET, Nutzer bitten neu zu entpacken
```

Die Zeitstempel der Dateien *innerhalb* von `gamedata.entpackt\` sind dafür unbrauchbar —
sie stammen aus dem Archiv, nicht vom Entpackvorgang. Maßgeblich ist das Erstellungsdatum
der Archiv-Ordner der obersten Ebene.

**Stand 2026-08-05:** entpackt am 05.08.2026 12:55–12:56, neuestes `.scd` vom 01.08.2026
→ **aktuell**.

### Pfadregel

```
gamedata.entpackt\<archivname>\<pfad im archiv>   →   VFS-Pfad  /<pfad im archiv>
```

Beispiele:

| Datei auf der Platte | Pfad im Spiel (VFS) |
|---|---|
| `gamedata.entpackt\lua\lua\sim\Unit.lua` | `/lua/sim/Unit.lua` |
| `gamedata.entpackt\lua\lua\defaultunits.lua` | `/lua/defaultunits.lua` |
| `gamedata.entpackt\units\units\UEL0001\UEL0001_unit.bp` | `/units/UEL0001/UEL0001_unit.bp` |
| `gamedata.entpackt\effects\effects\...` | `/effects/...` |

Der doppelte Ordnername (`lua\lua`, `units\units`) ist kein Fehler: die erste Ebene ist der
Archivname, die zweite der oberste Ordner *im* Archiv.

## 3. Die 17 LOUD-Archive

| Archiv | Größe | Inhalt |
|---|---|---|
| `units.scd` | 306 MB | Basis-Einheiten (Vanilla + LOUD-Anpassungen) |
| `brewlan.scd` | 200 MB | BrewLAN-Einheitenpaket |
| `extra_env.scd` | 100 MB | zusätzliche Umgebungen/Terrain |
| `blackops.scd` | 89 MB | BlackOps-Einheitenpaket |
| `TotalMayhem.scd` | 56 MB | Total-Mayhem-Einheitenpaket |
| `civ_units.scd` | 49 MB | zivile Einheiten |
| `WyvernBattlePack.scd` | 30 MB | Wyvern-Paket |
| `loud_units.scd` | 25 MB | LOUD-eigene Einheiten |
| `4D-CompatibilityPack.scd` | 14 MB | Kompatibilitätsschicht der Pakete |
| `textures.scd` | 11 MB | Texturen |
| `loud_misc.scd` | 5,7 MB | diverse LOUD-Ergänzungen |
| **`lua.scd`** | **1,4 MB** | **Sim- und UI-Skripte — der wichtigste Ordner** |
| `env.scd`, `effects.scd`, `projectiles.scd` | | Umgebung, Effekte, Geschosse |
| `loc_US.scd` | 46 KB | Lokalisierung |
| `SC_Music.scd` | 1,8 KB | Musik-Stub |

## 4. VFS-Mounts (Quelle: `LOUD\bin\LoudDataPath.lua`)

Reihenfolge = Priorität. Was **später** gemountet wird, hat bei Namenskollision **Vorrang**
(letzter Mount gewinnt bei gleichem Pfad).

```lua
dofile(InitFileDir.."/CommonDataPath.lua")

mount_dir(bin\BrewLAN-StrategicIconsOverhaul-SMALL-classic.scd , '/')

-- LOUD-Inhalte
mount_dir(..\gamedata\*.scd , '/')
mount_dir(..\maps          , '/maps')
mount_dir(..\sounds        , '/sounds')

-- Vanilla-Inhalte
mount_dir($FA\fonts                    , '/fonts')
mount_dir($FA\gamedata\textures.scd    , '/')
mount_dir($FA\gamedata\effects.scd     , '/')
mount_dir($FA\gamedata\env.scd         , '/')
mount_dir($FA\gamedata\projectiles.scd , '/')
mount_dir($FA\gamedata\props.scd       , '/')
mount_dir($FA\gamedata\meshes.scd      , '/')
mount_dir($FA\movies                   , '/movies')
mount_dir($FA\sounds                   , '/sounds')

-- Nutzerinhalte
mount_dir (..\usermaps , '/maps')
mount_mods(..\usermods , '/mods')     ← HIER landen unsere Mods

hook = { '/schook' }
protocols = { 'http', 'https' }
```

### Konsequenzen

- **`usermods\<Name>\` wird zu `/mods/<name>/`** im VFS (kleingeschrieben!).
  Bestätigt im Log: `AddSearchPath: '...\loud\usermods\acidpools', mounted as '/mods/acidpools/'`
- **Das gilt für jeden Unterordner** — auch für `usermods\doc.claude\`, das als
  `/mods/doc.claude/` gemountet wird. Da dort keine `mod_info.lua` liegt, wird kein Mod
  registriert; die `.md`-Dateien werden von der Engine nie gelesen. Harmlos, aber gut zu
  wissen — der Ordner taucht im `LOUD.log` bei den Mounts auf.
- `mount_mods` ist speziell: es hängt zusätzlich Unterordner wie `sounds\` eines Mods
  an die passenden globalen Mountpunkte an
  (Log: `...\usermods\nomads-4-loud\sounds', mounted as '/sounds/'`).
- Der **globale Hook-Pfad ist `/schook`**. Zusätzlich hat jeder Mod seinen eigenen
  Hook-Ordner (`hookdir`, Standard `/hook`) — siehe `02_MODSYSTEM.md`.
- `mount_dir(gamedata\*.scd, '/')` mountet **alphabetisch**; deshalb überschreiben
  spätere Archive (z. B. `units.scd`) frühere (z. B. `blackops.scd`) bei gleichem Pfad.

## 5. Ladekette beim Spielstart (vereinfacht)

```
LOUD.exe
 └─ bin\LoudDataPath.lua        → VFS aufbauen, Mods mounten
     └─ /lua/globalInit.lua     → Basis-Umgebung, Klassen, Import-System
         ├─ /lua/userInit.lua   → UI-Prozess
         │    └─ /lua/ui/...    → Lobby, HUD, Mod-Manager
         └─ /lua/SessionInit.lua / simInit.lua → Sim-Prozess
              ├─ Blueprints laden (/units/**/*.bp, Mod-Blueprints, ModBlueprints())
              ├─ /lua/sim/Unit.lua, weapon.lua, ... laden  → danach jeweils Hooks
              └─ Spiel läuft
```

**Merksatz:** Ein Hook läuft **nach** dem Original *im selben Environment*. Deshalb darf ein
Hook die Originalfunktion in einer lokalen Variable sichern und aufrufen.

## 6. Sim vs. UI — zwei getrennte Welten

| | Sim | UI |
|---|---|---|
| Zweck | Spiellogik, deterministisch, alle Spieler synchron | Darstellung, nur lokal |
| Code | `/lua/sim/`, `/lua/*units.lua`, `/lua/*weapons.lua` | `/lua/ui/` |
| Mod-Flag | `ui_only = false` | `ui_only = true` |
| Multiplayer | **alle** Spieler brauchen den Mod | nur der eigene Rechner |
| Fehler | Desync / Absturz aller | nur lokale Fehldarstellung |

Nie direkt aus der Sim in die UI schreiben (und umgekehrt) — Kommunikation läuft über
`SimCallbacks.lua`, `SimSync.lua`, `UserSync.lua`.
