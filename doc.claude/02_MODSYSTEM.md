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

## 2. `mod_info.lua` - alle Felder

**Geprueft am 2026-08-06** gegen `LoadModInfo()` in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\mods.lua`
(Zeile 227-252). Die Datei wird als Lua-Skript in eine vorbelegte Umgebung ausgefuehrt;
was sie nicht setzt, behaelt den Vorgabewert.

### Vorgabewerte laut Code

| Feld | Vorgabe | Anmerkung |
|---|---|---|
| `name` | Dateiname | also der volle Pfad - immer selbst setzen |
| `description` | `(No description)` | |
| `author` | leer | |
| `copyright` | leer | |
| `exclusive` | `false` | |
| `icon` | generisches Symbol aus `/textures/ui/common/dialogs/mod-manager/` | |
| `selectable` | `true` | |
| `hookdir` | `/hook` | |
| `shadowdir` | `/shadow` | |
| `uid` | **Dateiname** | gefaehrlich - siehe unten |
| `location` | Verzeichnis der `mod_info.lua` | wird von der Engine gesetzt |

**`uid` hat keinen sinnvollen Vorgabewert.** Ohne eigene Angabe ist die uid der volle
Pfad zur `mod_info.lua`. Das funktioniert zufaellig, weil Pfade eindeutig sind - aber der
Mod ist dann fuer `requires`, `conflicts`, `before` und `after` praktisch nicht
referenzierbar, und die uid aendert sich, sobald jemand den Ordner umbenennt.
**Immer eine eigene GUID setzen.**

### Ohne Vorgabewert

Diese Felder sind schlicht `nil`, wenn sie nicht gesetzt werden - der Code prueft
jeweils auf Vorhandensein:

`version` - `url` - `ui_only` - `requires` - `requiresNames` - `conflicts` -
`before` - `after` - `enabled`

### `enabled` - zwei Zustaende, drei Bedeutungen

```lua
-- mods.lua, Zeile 295
if mod and (mod.enabled ~= false) then
    r[mod.uid] = mod
end
```

Die Pruefung ist `~= false`, nicht `== true`. Also:

| `enabled` | Ergebnis |
|---|---|
| nicht gesetzt (`nil`) | Mod wird geladen |
| `true` | Mod wird geladen |
| `false` | Mod ist **unsichtbar** - er erscheint nicht einmal im Mod-Manager |

`enabled = false` ist damit der harte Aus-Schalter beim Entwickeln. `selectable = false`
ist etwas anderes: der Mod existiert, ist aber nicht von Hand waehlbar (fuer Mods, die
ueber `requires` oder eine Karte automatisch aktiviert werden).

### Vorlage

```lua
name        = "Mein Mod"          -- Anzeigename
version     = 1.0                 -- Versionsnummer
description = "Was der Mod tut"
author      = "..."
copyright   = "..."               -- optional
url         = "..."               -- optional

uid = "A0BC6CD8-2F26-4D3D-96EA-EB6A8B34A8F1"
    -- PFLICHT. Ohne Angabe wird der Dateipfad verwendet.
    -- Global eindeutige GUID, siehe 07_KONVENTIONEN.md Abschnitt 2.

icon = "/mods/meinmod/icons/meinmod.bmp"

selectable = true      -- im Mod-Manager sichtbar
enabled    = true      -- false = wird NIE geladen
exclusive  = false     -- true = nur ein exklusiver Mod gleichzeitig
ui_only    = false     -- true = reiner UI-Mod, nur lokal noetig

hookdir   = '/hook'    -- ueberschreibbar
shadowdir = '/shadow'  -- ueberschreibbar

requires = {
    "fec58b30-0036-4b9e-9995-fe2d6fe4c6e9",   -- Name des benoetigten Mods
}
requiresNames = {
    ["fec58b30-0036-4b9e-9995-fe2d6fe4c6e9"] = "Name fuer die Fehlermeldung",
}
conflicts = { "..." }   -- Spiel verweigert gleichzeitige Aktivierung
before    = { "..." }   -- dieser Mod wird VOR den genannten angewandt
after     = { "..." }   -- ... NACH den genannten
```

**`requires` regelt keine Reihenfolge** - dafuer `after` setzen. Einzelheiten in
Abschnitt 5.

Zur Laufzeit ergaenzt die Engine `id` (voller Pfad zur `mod_info.lua`) und `location`
(Ordner).

### Felder, die NICHT gelesen werden

`mountpoints` und `hooks` kommen in zwei vorhandenen Mods vor, werden aber weder von
`mods.lua` noch von `bin\CommonDataPath.lua` ausgewertet. Sie stammen aus einem anderen
Mod-Loader und sind hier wirkungslos - `11_DATAPATH.md` Abschnitt 2.

### `config.lua` (optional)

Erlaubt Einstellungen pro Mod, abfragbar im Sim ueber `GetModConfig(uid)`.
Struktur: `config = { { key=..., default=..., values={ {key=...}, ... } }, ... }`.

Die Werte werden **im Spielerprofil** gespeichert (`Prefs`, Schluessel `modConfig`),
nicht im Mod. Ist die Datei leer oder fehlerhaft, schreibt die Engine
`Mod <name> has an empty or malformed config file` ins Log.

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

## 5. Abhaengigkeiten und Ladereihenfolge

**Quelle:** `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\mods.lua`
Geprueft am 2026-08-06 gegen den tatsaechlichen Code, nicht nur gegen den Kopfkommentar.

### Vier Felder, zwei verschiedene Zwecke

| Feld | Zweck | Wirkt auf |
|---|---|---|
| `requires` | dieser Mod braucht einen anderen | **Verfuegbarkeit** |
| `conflicts` | dieser Mod vertraegt sich nicht mit einem anderen | **Verfuegbarkeit** |
| `before` | dieser Mod wird **vor** dem genannten angewandt | **Reihenfolge** |
| `after` | dieser Mod wird **nach** dem genannten angewandt | **Reihenfolge** |

Alle vier enthalten Listen von **uids**, nicht von Modnamen.

**Das ist der entscheidende Punkt: `requires` regelt keine Reihenfolge.** Wer will, dass
sein Mod nach einem anderen greift, muss `after` setzen - `requires` allein genuegt nicht.

### Die Sortierung

```lua
-- mods.lua, Zeile 326-345
local function ModComp(first, second)
    if _mod_cache[first].before then
        for i,uid in _mod_cache[first].before do
            if _mod_cache[second].uid == uid then return true end
        end
    end
    if _mod_cache[first].after then
        for i,uid in _mod_cache[first].after do
            if _mod_cache[second].uid == uid then return false end
        end
    end
    return first < second
end
```

`_mod_cache` ist nach `uid` indiziert (Zeile 296: `r[mod.uid] = mod`). Der Rueckfall
`first < second` vergleicht also **uids alphabetisch**.

**Die uid-Sortierung erzwingt nichts** - sie ist nur das, was uebrig bleibt, wenn weder
`before` noch `after` greifen.

### Drei Fallstricke im Code

**1. Der Kopfkommentar stimmt nicht.** Er behauptet:

> *"If you do not supply an 'after' list, the 'requires' list will be used in its place."*

**Das ist in dieser Fassung nicht implementiert.** `ModComp` liest ausschliesslich
`.before` und `.after`; nirgends wird `requires` als Reihenfolge herangezogen.
Wer sich darauf verlaesst, bekommt die alphabetische uid-Reihenfolge.

**2. `ModComp` ist ein Paarvergleich, keine topologische Sortierung.** `before`/`after`
wirken nur, wenn genau diese beiden Mods waehrend des Sortierens miteinander verglichen
werden. Daraus folgt: **die Beziehung ist nicht transitiv.** Wenn A vor B und B vor C
steht, ist A **nicht** garantiert vor C - es sei denn, A nennt C ausdruecklich.

Bei drei und mehr Mods also **jede** Beziehung einzeln deklarieren, nicht auf eine Kette
vertrauen.

**3. Widersprueche werden nicht gemeldet.** Der Kopfkommentar sagt dazu (Zeile 177):

> *"If two mods specify an inconsistent ordering (e.g. they both ask to be before the
> other) then the game will pick one arbitrarily."*

Ein Vergleichsoperator, der fuer `(A,B)` und `(B,A)` beide Male `true` liefert, ist
inkonsistent - das Sortierergebnis ist dann nicht definiert. **Es gibt keine Warnung im
Log.** Widersprueche fallen nur durch merkwuerdiges Spielverhalten auf.

### `requires` und `conflicts` im Detail

`GetDependencies(uid)` (Zeile 396) loest sie auf und liefert drei Listen:

| Rueckgabe | Bedeutung |
|---|---|
| `requires` | benoetigte Mods, die **vorhanden** sind |
| `missing` | benoetigte Mods, die **fehlen** |
| `conflicts` | Mods, die sich mit diesem beissen |

Zwei Eigenschaften, die man kennen sollte:

- **`requires` wird rekursiv aufgeloest.** Braucht A den Mod B und B den Mod C, findet
  die Funktion auch C.
- **`conflicts` wirkt in beide Richtungen.** Es genuegt, wenn *einer* der beiden Mods den
  anderen nennt - die Funktion durchsucht alle Mods danach, ob sie *diesen* als Konflikt
  fuehren.

`requiresNames` ist rein kosmetisch: eine Zuordnung uid -> Klartextname fuer die
Fehlermeldung, wenn ein benoetigter Mod fehlt.

### Praktische Regeln fuer eigene Mods

1. **Reihenfolge braucht `before` oder `after`.** `requires` reicht nicht.
2. **Jede Beziehung einzeln deklarieren** - Ketten sind nicht transitiv.
3. **Widersprueche vermeiden**, sie werden nicht gemeldet.
4. **uids in den Listen, keine Namen.** Kommentar dahinter setzen, damit die Liste
   lesbar bleibt.
5. **`requiresNames` ausfuellen**, wenn `requires` gesetzt ist - sonst sieht der Nutzer
   nur eine uid.
6. **Nicht auf die uid-Sortierung bauen.** Sie ist ein Rueckfall, kein Mechanismus.

### Was noch offen ist

Ob die Reihenfolge im Spiel tatsaechlich so wirkt, ist **nicht praktisch geprueft** -
nur aus dem Code gelesen. Steht in `TODO.md`.

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

## 6.5 LOUD bringt eigene Mods mit

Neben `usermods\` gibt es eine zweite Quelle: `loud_misc.scd` enthält einen Ordner
`mods\`, der über den Wurzel-Mount ebenfalls unter `/mods/` landet.

Referenz: `gamedata.entpackt\loud_misc\mods\` — **24 Mods**, unter anderem:

| Mod | Zweck (soweit erkennbar) |
|---|---|
| `Enhanced Resources` | hookt `/lua/system/Blueprints.lua` → Musterbeispiel für `ModBlueprints` |
| `Enhanced Commanders`, `Enhanced Nukes`, `Enhanced Static HP` | Balance-Erweiterungen |
| `BrewLAN_Gameplay`, `BrewLAN_Plenae`, `BrewLAN_RNG` | BrewLAN-Spielmodi |
| `LOUD Debug Tools`, `CommonModTools` | **beim Entwickeln direkt nützlich** |
| `SupremeEconomy`, `SupremeScoreBoard`, `HotStats`, `UI-Party` | UI-Erweiterungen |
| `Disperse Move`, `SelectionDeprioritizer`, `zSUEKeybind` | Bedienhilfen |
| `LOUD Evenflow Engineers`, `LOUD Integrated Storage`, `V2ExtractorUpgrades` | Mechanik |
| `Artillery`, `No VO Alerts`, `SC_Music`, `pauseReplayAtTime`, `TanksysExperiments`, `UIMassFabManager`, `ZLOUD Structure Enhancements` | diverse |

**Folgen für eigene Mods:**

- Sie erscheinen im Mod-Manager **neben** unseren — die Liste dort ist keine Abbildung
  von `usermods\`.
- Sie hooken teils dieselben Dateien. Bei „eigener Hook wirkt nicht" auch hier nachsehen.
- Sie werden **bei jedem LOUD-Update ersetzt** (`gamedata\` gehört dem LOUD-Team).
- **Vor jedem eigenen Eingriff prüfen, ob LOUD dafür schon etwas mitbringt.**

Welche davon in einer Partie aktiv waren, steht im `LOUD.log` (`15_LOG.md` §4.5).

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
