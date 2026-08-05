# 02 — Das Modsystem

Primärquelle: `gamedata.entpackt\lua\lua\mods.lua` (Kopfkommentar + Implementierung).
Diese Datei ist die maßgebliche Dokumentation der Engine — bei Zweifeln dort nachlesen.

---

## 1. Grundaufbau eines Mods

```
usermods\MeinMod\
├── mod_info.lua          PFLICHT — sonst wird der Ordner ignoriert
├── icons\
│   └── MeinMod.bmp       optional, Icon im Mod-Manager
├── hook\                 empfohlener Eingriffsweg   (Standard-hookdir)
│   └── lua\sim\Unit.lua
├── shadow\               Vollersatz von Dateien     (Standard-shadowdir) — letztes Mittel
│   └── lua\sim\Unit.lua
├── units\                neue oder ersetzende Einheiten
│   └── XXX0001\XXX0001_unit.bp
├── lua\                  eigene Module (per import('/mods/meinmod/lua/x.lua'))
├── effects\ projectiles\ textures\ sounds\ env\ loc\
└── config.lua            optional, In-Lobby-Konfiguration
```

Der Ordner wird als `/mods/meinmod/` gemountet — **kleingeschrieben**. Interne Pfade wie in
`icon = "/mods/MeinMod/icons/..."` funktionieren trotzdem, weil der VFS case-insensitiv ist;
für neuen Code trotzdem konsequent kleinschreiben.

---

## 2. `mod_info.lua` — alle Felder

```lua
name        = "Mein Mod"          -- Anzeigename
version     = 1.0                 -- Versionsnummer
description = "Was der Mod tut"
author      = "..."
copyright   = "..."               -- optional
url         = "..."               -- optional

uid = "A0BC6CD8-2F26-4D3D-96EA-EB6A8B34A8F1"
    -- PFLICHT in der Praxis. Muss global eindeutig sein (GUID).
    -- Default wäre der Dateiname → unsicher.
    -- Regel: jede neue Version eines Mods bekommt eine neue uid,
    --        damit abhängige Mods gezielt auswählen können.

icon = "/mods/meinmod/icons/meinmod.bmp"
    -- Default: mod_icon.dds neben mod_info.lua

selectable = true      -- im Mod-Manager sichtbar/wählbar
enabled    = true      -- false = wird NIE geladen (praktisch zum Deaktivieren beim Entwickeln)
exclusive  = false     -- true = nur ein exklusiver Mod gleichzeitig; schließt requires/conflicts aus
ui_only    = false     -- true = reiner UI-Mod, nur lokal nötig

hookdir   = '/hook'    -- überschreibbar
shadowdir = '/shadow'  -- überschreibbar

requires = {
    "fec58b30-0036-4b9e-9995-fe2d6fe4c6e9",   -- uid des benötigten Mods
}
requiresNames = {
    ["fec58b30-0036-4b9e-9995-fe2d6fe4c6e9"] = "Name für die Fehlermeldung",
}
conflicts = { "..." }   -- Spiel verweigert gleichzeitige Aktivierung
before    = { "..." }   -- dieser Mod wird VOR den genannten angewandt
after     = { "..." }   -- ... NACH den genannten (Default: = requires)
```

Zur Laufzeit ergänzt die Engine `id` (voller Pfad zur `mod_info.lua`) und `location` (Ordner).

### `config.lua` (optional)

Erlaubt Einstellungen pro Mod, abfragbar im Sim über `GetModConfig(uid)`.
Struktur: `config = { { key=..., default=..., values={ {key=...}, ... } }, ... }`.
Ist die Datei leer oder fehlerhaft, schreibt die Engine eine Warnung ins Log.

---

## 3. Die drei Eingriffsmechanismen

### 3.1 `hook\` — **Standardweg**

> „A mod can also contain a 'hook' folder […]. After any script file is loaded, we check in the
> active mods to see if they define a hook of the same name; if so, we run the hook in the same
> environment as the original script."

- Pfad im Mod spiegelt den VFS-Pfad:
  `hook\lua\sim\Unit.lua` hakt sich in `/lua/sim/Unit.lua` ein.
- Der Hook läuft **nach** dem Original, **im selben Environment**. Alle globalen Symbole der
  Originaldatei (Klassen, Funktionen, Tabellen) sind direkt sichtbar.
- Mehrere Mods können dieselbe Datei hooken → Kette. Reihenfolge über `before`/`after`.

**Kanonisches Muster (Funktion erweitern statt ersetzen):**

```lua
-- hook\lua\sim\Unit.lua
local OldOnStartBuild = Unit.OnStartBuild

function Unit:OnStartBuild(unitBeingBuilt, order)
    -- eigene Logik davor ...
    local result = OldOnStartBuild(self, unitBeingBuilt, order)
    -- ... oder danach
    return result
end
```

Regeln:
- Die alte Funktion **immer** sichern und aufrufen, sonst brechen andere Mods und LOUD-Logik.
- Rückgabewerte durchreichen.
- Nichts Teures in häufig laufenden Funktionen (`OnDamage`, `OnFrame`-nahe Pfade).

### 3.2 `shadow\` — Vollersatz

> „These files will REPLACE the game's files on all lookups. […] when a game file is shadowed,
> the original file becomes completely inaccessible. This is ok for textures and such but
> usually not what you want for scripts."

- Nur für Assets (Texturen, Sounds, Meshes) oder wenn eine Datei strukturell umgebaut werden muss.
- Bricht sämtliche Hooks anderer Mods auf dieselbe Datei.
- **Wenn shadow: in `mods\<modname>.md` begründen** und LOUD-Version notieren, denn bei jedem
  LOUD-Update muss die Datei neu abgeglichen werden.

### 3.3 `/schook` — globaler Hook-Pfad

`LoudDataPath.lua` setzt `hook = { '/schook' }`. Eine Datei, die im VFS unter
`/schook/lua/sim/Unit.lua` liegt, wird ebenfalls nach `/lua/sim/Unit.lua` ausgeführt.
Wird von größeren Mods genutzt, die eigene Mountpunkte anlegen. **Für unsere Mods:
`hook\` verwenden**, das ist die mod-lokale, saubere Variante.

---

## 4. Blueprints aus Mods

Aus `mods.lua`:

- Jede `.bp`-Datei eines aktiven Mods wird beim Blueprint-Laden automatisch mitgeladen.
- Gleiche ID wie ein Original (z. B. `uel0001`) → **Original wird komplett ersetzt**.
- Mit `Merge = true` im Blueprint → **Felder werden zusammengeführt**, der Rest bleibt intakt.
  Das ist der Weg für Balance-Änderungen.
- Nicht-Unit-Blueprints müssen zum Ersetzen ausdrücklich `BlueprintId` setzen; bei Units wird
  die ID aus dem Dateinamen abgeleitet.
- Alternativ: eine Funktion `ModBlueprints(all_blueprints)` definieren, die die geladene
  Blueprint-Tabelle programmatisch manipuliert (für Massenänderungen über viele Einheiten).

Details und Beispiele: `03_BLUEPRINTS.md`.

---

## 5. Ladereihenfolge zwischen Mods

1. Standard: **alphabetisch nach uid**.
2. `before = {...}` / `after = {...}` verschieben gezielt.
3. Widersprüchliche Angaben → die Engine wählt willkürlich und schreibt eine Warnung ins Log;
   beide Mods bleiben aktiv.
4. **Wer zuletzt läuft, gewinnt** bei konkurrierenden Änderungen.

Für unsere Mods gilt: wenn ein Mod auf Änderungen eines anderen aufbaut, `after` setzen und in
`mods\<modname>.md` dokumentieren.

---

## 6. Mod-Typen und Multiplayer

| Typ | Flag | Wer braucht ihn |
|---|---|---|
| Game-Mod (Sim) | `ui_only = false` | **alle** Spieler in der Partie |
| UI-Mod | `ui_only = true` | nur der eigene Rechner |
| Frontend-Mod | — | laut `mods.lua` **funktioniert derzeit nicht** |

Die Lobby übergibt die aktiven Game-Mods über `gameinfo.Options.Mods` an die Simulation.
UI-Mods werden direkt aus den Preferences angewandt.

---

## 7. Karten-Mods

Enthält ein Mod Karten, erscheinen sie automatisch in der Kartenliste. Wird eine solche Karte
gewählt, aktiviert sich der Mod (und seine `requires`) automatisch für diese Partie.
Für solche Mods `selectable = false` setzen.

---

## 8. Checkliste vor dem ersten Start eines neuen Mods

- [ ] `mod_info.lua` vorhanden, syntaktisch gültiges Lua
- [ ] `uid` ist eine frische GUID, nicht kopiert
- [ ] `name` und `description` aussagekräftig (erscheinen im Mod-Manager)
- [ ] `ui_only` korrekt gesetzt
- [ ] Ordnername enthält keine Leer- oder Sonderzeichen
- [ ] Hook-Pfade spiegeln exakt die VFS-Pfade
- [ ] keine Datei außerhalb von `usermods\<Mod>\`
