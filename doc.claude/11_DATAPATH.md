# 11 — `LoudDataPath.lua` und `CommonDataPath.lua`

Diese beiden Dateien in `LOUD\bin\` bestimmen **vor jedem anderen Lua-Code**, welche Dateien
das Spiel überhaupt sieht. Sie sind der Schlüssel zu jeder Pfadfrage.

| Datei | Rolle |
|---|---|
| `LOUD\bin\CommonDataPath.lua` | definiert die Mount-**Funktionen** (`mount_dir`, `mount_contents`, `mount_mods`) |
| `LOUD\bin\LoudDataPath.lua` | **ruft sie auf** und baut damit das konkrete VFS auf |

🔒 **Beide nur lesen — sie gehören dem LOUD-Team.** Sie liegen außerhalb der Schreibzonen
und werden bei jedem LOUD-Update überschrieben. Änderungen dort wären ohnehin flüchtig.
Eine Ausnahme betreibt der Nutzer bewusst selbst (siehe §4).
Verbatim-Kopien zum Nachschlagen: `doc.claude\referenz\`.

---

## 1. `LoudDataPath.lua` — annotiert

```lua
do
dofile(InitFileDir.."/CommonDataPath.lua")     -- (1) Mount-Funktionen laden

-- LOUD Strat Icons
mount_dir(InitFileDir..'\\BrewLAN-StrategicIconsOverhaul-SMALL-classic.scd', '/')   -- (2)

-- LOUD content
mount_dir(InitFileDir..'\\..\\gamedata\\*.scd', '/')     -- (3) alle 17 LOUD-Archive
mount_dir(InitFileDir..'\\..\\maps',   '/maps')
mount_dir(InitFileDir..'\\..\\sounds', '/sounds')

-- Vanilla content
mount_dir(InitFileDir..'\\..\\..\\fonts',                   '/fonts')     -- (4)
mount_dir(InitFileDir..'\\..\\..\\gamedata\\textures.scd',  '/')
mount_dir(InitFileDir..'\\..\\..\\gamedata\\effects.scd',   '/')
mount_dir(InitFileDir..'\\..\\..\\gamedata\\env.scd',       '/')
mount_dir(InitFileDir..'\\..\\..\\gamedata\\projectiles.scd','/')
mount_dir(InitFileDir..'\\..\\..\\gamedata\\props.scd',     '/')
mount_dir(InitFileDir..'\\..\\..\\gamedata\\meshes.scd',    '/')
mount_dir(InitFileDir..'\\..\\..\\movies',                  '/movies')
mount_dir(InitFileDir..'\\..\\..\\sounds',                  '/sounds')

-- LOUD directory user maps & mods
mount_dir (InitFileDir..'\\..\\usermaps', '/maps')
mount_mods(InitFileDir..'\\..\\usermods', '/mods')       -- (5) ← unsere Mods

-- Documents directory (SCFA-Standard) — AUSKOMMENTIERT                    -- (6)
--mount_contents(SHGetFolderPath('PERSONAL')..'My Games\\...\\maps', '/maps')
--mount_contents(SHGetFolderPath('PERSONAL')..'My Games\\...\\mods', '/mods')

hook = { '/schook' }                                      -- (7)
protocols = { 'http', 'https' }
end
```

**(1)** `InitFileDir` ist `LOUD\bin`. Alle Pfade sind relativ dazu:
`..` = `LOUD\`, `..\..` = das SCFA-Wurzelverzeichnis.

**(2)** Nur die **SMALL-classic**-Strategiesymbole sind aktiv. In `bin\` liegen noch fünf
weitere Varianten (MEDIUM, LARGE, jeweils auch `-classic`) — der Wechsel würde eine Änderung
dieser Datei erfordern, also außerhalb unserer Schreibzone.

**(3)** Wildcard-Mount **aller** `.scd` aus `LOUD\gamedata\`. Die Engine arbeitet sie
alphabetisch ab — deshalb überschreibt `units.scd` bei Pfadkollision z. B. `blackops.scd`.
Genau diese Reihenfolge steht auch im `LOUD.log`.

**(4)** Vanilla-Inhalte kommen **nach** LOUD, dienen also als Rückfallebene für alles, was
LOUD nicht selbst mitbringt (Props, Meshes, Movies, Fonts).

**(5)** Der entscheidende Aufruf für uns. Details in §2.
Das zweite Argument `'/mods'` wird von der Funktion **ignoriert** — der Mountpunkt ist im
Funktionsrumpf fest verdrahtet. Das ist ein Überbleibsel, kein Konfigurationspunkt.

**(6)** Der klassische SCFA-Pfad unter *Eigene Dateien* ist in dieser Installation
**deaktiviert**. Mods dort haben also keine Wirkung — es zählt ausschließlich
`LOUD\usermods\`.

**(7)** Globaler Hook-Pfad. Alles, was im VFS unter `/schook/<pfad>` landet, wird nach dem
Laden von `/<pfad>` zusätzlich ausgeführt — unabhängig vom mod-eigenen `hook\`-Ordner.

---

## 2. `mount_mods()` — was mit `usermods\` wirklich passiert

Definiert in `CommonDataPath.lua`. Der Ablauf pro Eintrag in `usermods\`:

```
für jeden Eintrag in usermods\:
    Name → Kleinbuchstaben
    Endung .zip / .scd / .rar ?
        JA  → mount_dir(eintrag, '/')            "ohne additional functionality"
        NEIN→ mount_mod(name, ordner):
                LOG("Mounting mod '<name>' with additional functionality (e.g. sounds)")
                mount_dir(ordner, '/mods/<name>')
                falls Unterordner 'sounds' existiert:
                    alle *.xwb darin prüfen
                    Name schon in der globalen Soundbank-Liste? → ALLE Sounds verwerfen
                    sonst → mount_dir(ordner\sounds, '/sounds')
```

### Daraus folgende Regeln

1. **Jeder Unterordner von `usermods\` wird gemountet — ohne Rücksicht auf `mod_info.lua`.**
   Das Mounten und das Aktivieren im Mod-Manager sind zwei getrennte Vorgänge. Ein Ordner
   ohne `mod_info.lua` ist im VFS trotzdem vorhanden.
   → Ein Mod lässt sich **nicht** durch Verschieben in einen Unterordner deaktivieren;
   dafür `enabled = false` setzen.

2. **Der VFS-Name ist der kleingeschriebene Ordnername**, nicht das `name`-Feld:
   `usermods\UEF_trans_men\` → `/mods/uef_trans_men/`.

3. **Gepackte Mods (`.zip`/`.scd`/`.rar`) landen direkt auf `/`**, nicht unter `/mods/`.
   Sie überschreiben damit potenziell beliebige Spieldateien. Für eigene Mods: **immer als
   entpackter Ordner** arbeiten.

4. **Eigene Sounds funktionieren nur bei kollisionsfreien Dateinamen.**
   `CommonDataPath.lua` führt eine feste Liste von rund 80 FA-Soundbanks
   (`uel.xwb`, `xsl_weapon.xwb`, …). Trägt der eigene `sounds\`-Ordner **eine** `.xwb` mit
   einem dieser Namen — oder mit dem Namen einer bereits geladenen Mod-Bank —, werden
   **sämtliche** Sounds dieses Mods verworfen. Im Log:
   `Did not load the custom sounds for '<name>' because there were conflicting file names`
   → Eigene Soundbank eindeutig benennen, z. B. `meinmod_weapons.xwb`.

5. **Reihenfolge der Mod-Mounts** ergibt sich aus der Verzeichnisreihenfolge von `io.dir`,
   nicht aus `mod_info.lua`. Das betrifft nur das *Mounten*; die Reihenfolge der
   *Anwendung* von Hooks und Blueprints steuert weiterhin `mods.lua` über `before`/`after`.

### ⚠️ Korrektur zu `mountpoints` / `hooks` in `mod_info.lua`

Die Mods `nomads-4-loud` und `commanders` enthalten Felder `mountpoints = {...}` und
`hooks = {...}`. **Diese werden in dieser LOUD-Version von nichts ausgewertet:**
weder `CommonDataPath.lua` noch `mods.lua` lesen sie. Sie stammen aus einem anderen
Mod-Loader und sind hier wirkungslos. Nicht in eigene Mods übernehmen.

---

## 3. Die weiteren Funktionen aus `CommonDataPath.lua`

```lua
mount_dir(dir, mountpoint)      -- Verzeichnis oder Archiv an einen VFS-Punkt hängen;
                                -- füllt nur die globale Tabelle 'path', die Engine wertet sie aus
mount_contents(dir, mountpoint) -- jeden Eintrag von dir einzeln mounten,
                                -- Endung .scd/.zip wird vom Mountnamen abgeschnitten
mount_mods(modsDir)             -- siehe §2
io_findFiles(dir, extension)    -- Hilfsfunktion, Ergebnis kleingeschrieben
```

Die Soundbank-Liste ist laut Kommentar bewusst hart codiert („Forged Alliance is no longer
maintained by GPG"), um sich das Abfragen des Dateisystems bei jedem Start zu sparen.

---

## 4. `nomads-4-loud` ersetzt diese Datei — **beabsichtigt und nötig**

Der Mod `usermods\nomads-4-loud\` bringt eine eigene `LoudDataPath.lua` plus ein
QoL-Hilfsskript mit:

```bat
rem usermods\nomads-4-loud\CopyLoudDataPath.bat
copy /Y "LoudDataPath.lua" "..\..\bin\"
pause
```

**Das ist kein Fehler, sondern die vorgesehene Installation.** Nomads lässt sich mit dem
Standard-Modsystem nicht laden — der Mod braucht eigene Mounts, die *vor* den LOUD-Daten
greifen. Das geht nur über die Mount-Konfiguration selbst.

### Die Datei muss nach jedem LOUD-Update erneut kopiert werden

`LOUD\bin\` wird vom LOUD-Team gepflegt. Ein Update setzt `LoudDataPath.lua` auf die
Originalversion zurück — **und damit ist Nomads still deaktiviert**, ohne Fehlermeldung.
Deshalb existiert die `.bat`: sie stellt den Zustand mit einem Doppelklick wieder her.

**Symptom eines vergessenen Kopiervorgangs:** Nomads-Einheiten fehlen, keine Fehlermeldung
im Log, alles andere läuft normal.

### Aktueller Zustand prüfen

Die **Nomads-Version** erkennt man an zwei Merkmalen:

1. Sie enthält eine Zeile mit `mount_nomads.lua`.
2. Die `mount_contents`-Zeilen für den Dokumente-Ordner sind **aktiv** (nicht auskommentiert).

**Stand 2026-08-05:** In `bin\` liegt die **LOUD-Originalversion** — die `.bat` wurde seit
dem letzten Update (`.scd` vom 01.08.2026) noch nicht ausgeführt. Nomads ist damit derzeit
vermutlich wirkungslos. Vergleichskopien beider Varianten: `doc.claude\referenz\`.

### Was die Nomads-Version zusätzlich tut

| Änderung | Wirkung |
|---|---|
| `mount_dir(usermods\BrewLAN-StrategicIcons*.scd, '/')` statt der Variante aus `bin\` | Strategiesymbole kommen aus `usermods\` |
| `pcall(dofile, usermods\nomads-4-loud\mount_nomads.lua)` **vor** allen LOUD-Mounts | siehe unten |
| `mount_contents(...)` für *Eigene Dateien* **aktiviert** | Maps und Mods aus dem Dokumente-Ordner werden zusätzlich geladen |

`mount_nomads.lua`:

```lua
mount_dir(usermods\nomads-4-loud\shadow, '/')        -- shadow VOR allen Spieldaten
mount_dir(gamedata\lua.scd, '/loud')                 -- Originale bleiben unter /loud erreichbar
mount_dir(usermods\nomads-4-loud, '/')               -- kompletter Mod-Ordner auf die Wurzel
mount_dir(usermods\nomads-4-loud\movies,   '/')
mount_dir(usermods\nomads-4-loud\textures, '/')
mount_dir(usermods\nomads-4-loud\textures\ui\common, '/')
mount_dir(usermods\nomads-4-loud\tools, '/tools')
```

Der Mod legt sich also **vor** die gesamten Spieldaten. Die LOUD-Originalskripte bleiben
unter `/loud` erreichbar — der Kommentar im Mod sagt das ausdrücklich
(„otherwise no way to access the original").

### Konsequenz für eigene Mods

Bei aktivem Nomads liegt dessen `shadow\` über allem. Wenn ein eigener Hook auf eine Datei
wirkungslos bleibt, die Nomads shadowed, ist das die Ursache. Prüfen:
`usermods\nomads-4-loud\shadow\` nach der betroffenen Datei durchsuchen.

---

## 5. Was das für eigene Mods bedeutet — Kurzfassung

| Frage | Antwort |
|---|---|
| Wo müssen meine Dateien liegen? | `LOUD\usermods\<Ordner>\` — der Dokumente-Ordner ist deaktiviert |
| Wie heißt mein Mod im VFS? | kleingeschriebener **Ordnername**, unter `/mods/<name>/` |
| Mod als ZIP packen? | Nein — gepackte Mods landen auf `/` und überschreiben Spieldaten |
| Eigene Sounds? | eindeutige `.xwb`-Namen, sonst wird der ganze Soundordner verworfen |
| Mod deaktivieren? | `enabled = false` oder Mod-Manager — **nicht** durch Verschieben |
| Kann ich die Mount-Konfiguration ändern? | Nein, sie liegt in `LOUD\bin\` außerhalb der Schreibzone |
