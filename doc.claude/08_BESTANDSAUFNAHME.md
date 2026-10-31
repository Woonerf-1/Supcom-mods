# 08 — Bestandsaufnahme `usermods\` (eingefroren)

Stand: **2026-08-05**, aktualisiert nach der Git-Anbindung.
Alle Mods sind `enabled = true`, `selectable = true`, `exclusive = false`,
`ui_only = false` (also allesamt Sim-Mods).

`usermods\` ist inzwischen ein **Git-Arbeitsverzeichnis** → `13_GIT.md`.

> **❄️ EINGEFROREN.** **Alles in `usermods\` gehört uns**, unabhängig vom Autorenfeld in
> der jeweiligen `mod_info.lua`. Dieser Bestand wird trotzdem **nicht mehr verändert** —
> nicht aus Respekt vor fremdem Eigentum, sondern weil alles **neu gedacht und in neuen
> Mods umgesetzt** wird. Reparaturen hier wären in Material investiert, das ohnehin
> abgelöst wird.
>
> Dieses Dokument ist damit **Vergleichsstand und Befundsammlung**, kein Sollzustand.
> Konzept: `12_NEUSCHNITT.md`.
>
> Die Autorenangaben unten stehen nur der Vollständigkeit halber — sie sind das, was in
> den Dateien steht, und begründen keine Zuständigkeit.

Die Spalte „Ersetzt durch" in der Übersicht wird gepflegt, sobald ein Neuschnitt steht.

---

## Übersicht

| Ordner | Name | Autor | uid | Mechanismus | Ersetzt durch |
|---|---|---|---|---|---|
| `AcidPools` (seit 2026-10-16 `CorrosiveOcean`) | Corrosive Ocean | Balthazar | `BREWLANS-22b4-4936-820e-acid00000000` | `hook\lua\sim\Unit.lua` | — |
| `commanders` | Factions for Commanders | „the love for max" | `THISoneIS4myBOImax` | `units\` (4 ACUs) | — |
| `nomads-4-loud` | Nomads for LOUD | (Pseudonym) | `ILL-BE_FASTERRRR-THAN-PM-BC-OF-icon` | Vollpaket: `hook`, `shadow`, `units`, eigene Mounts | — |
| `NOMADS-try_b4_ur_BI` | NOMAD BI men | Colin | `2100thousendmilliontest31` | Erweiterung zu Nomads | — |
| `test21000` | TEST21000 | Colin | `12345678901234567890test21000` | `units\UEL0001` (Vollersatz) | — |
| `UEF_trans_men` | Trans men are sexy | Colin | `d59081a9-603b-46f1-becd-3b6520614469+1` | `hook`, `units`, `lua`, Assets | — |

Außerdem im Repository-Wurzelverzeichnis: `doc.claude\` (diese Dokumentation, inkl.
`tools\`), `README.md` (Inhalt nur `"#Supcom-mods"`) und `test.txt` (Inhalt `"s"`,
Testartefakt).

### Entfallen

| Ordner | Stand |
|---|---|
| `EscalatingBuildCosts` | mit der Git-Anbindung **entfernt**. Befunde dazu bleiben in `12_NEUSCHNITT.md` §2 erhalten (O(n) pro Bauauftrag als Negativbeispiel). |

---

## Details

### `AcidPools` — Corrosive Ocean

> **Stand 2026-10-16:** Ordner heisst jetzt `CorrosiveOcean`, Icon `CorrosiveOcean.png`,
> `Corrosive.dds` (unbenutzt) in `_Altlasten\CorrosiveOcean\`, alle Schiffe (`NAVAL`)
> vom Schaden ausgenommen. Doku: `usermods\CorrosiveOcean\hook\lua\sim\Unit.md`. Der
> Abschnitt unten ist der historische Befund.

```
Corrosive.dds
hook\lua\sim\Unit.lua
mod_info.lua
```
Gewässer verursachen Schaden über Zeit. Hookt `Unit.lua`.
⚠️ `icon` zeigt auf `/mods/BrewLAN_Gameplay/AcidPools/Corrosive.dds`. Der Mod
`BrewLAN_Gameplay` **existiert** (LOUD-eigener Mod aus `loud_misc.scd`), enthält aber
keinen Unterordner `AcidPools`. Der Pfad läuft also ins Leere — offenbar wurde der Mod
aus einem BrewLAN-Bündel herausgelöst, ohne den Icon-Pfad anzupassen. Kosmetisch.

### `commanders` — Factions for Commanders
Ersetzt die vier ACU-Ordner **vollständig** (kein Merge):
`UAL0001` (Aeon), `UEL0001` (UEF), `URL0001` (Cybran), `XSL0001` (Seraphim).
Nutzt die LOUD-Felder `mountpoints` und `hooks` (siehe unten).
⚠️ **Kollidiert mit `test21000`**, das ebenfalls `UEL0001` vollständig ersetzt.
**Welcher gewinnt, ist nicht ermittelt.** Die uid-Sortierung ist nur die
Standardreihenfolge und erzwingt nichts; über `before`/`after` in `mod_info.lua` lässt
sich die Reihenfolge gezielt festlegen. Steht in `TODO.md`.
ℹ️ `icon` verweist auf `/mods/nomads-4-loud/icons/nomads.bmp`. Diese Datei **existiert**
— der Pfad ist also gültig, solange `nomads-4-loud` installiert ist. Es ist eine
undeklarierte Abhängigkeit (kein `requires`), kein Fehler.

### `EscalatingBuildCosts` — **entfernt**
Nicht mehr in `usermods\`. Bis dahin:
```
hook\lua\sim\Unit.lua
icons\EscalatingBuildCosts.bmp
mod_info.lua
```
Hookte `Unit:OnStartBuild`. Ab 100 Einheiten desselben Typs verdoppelten sich die Kosten je
100er-Stufe; die Mehrkosten wurden per `brain:TakeResource` sofort abgezogen.
Zählte bei **jedem** Bauauftrag alle Einheiten des Spielers durch (`GetListOfUnits` +
Schleife) — O(n) pro Bauauftrag. Bleibt als Negativbeispiel in `04_LUA_SIM.md` §3 und
`12_NEUSCHNITT.md` §2 dokumentiert.

### `nomads-4-loud` — Nomads for LOUD
Das größte Paket, und ein **Sonderfall**: es lässt sich nicht über das Standard-Modsystem
laden, sondern braucht eigene Mounts, die vor den LOUD-Daten greifen. Dazu bringt es eine
eigene `LoudDataPath.lua` mit, die per `CopyLoudDataPath.bat` nach `LOUD\bin\` kopiert wird.

```
hook\  shadow\  lua\  units\  effects\  projectiles\  env\  meshes\  movies\
sounds\  textures\  icons\  loc\  setup\  tools\
init_nomads.lua   mount_nomads.lua   LoudDataPath.lua   CopyLoudDataPath.bat
.github\  .vscode\  shader_cleaner.bat
```
**Das ist die vorgesehene Installation, kein Fehler.** Die `.bat` ist ein QoL-Helfer und
muss **nach jedem LOUD-Update erneut** ausgeführt werden — sonst ist Nomads still
deaktiviert. Ausführen tut das der Nutzer, nicht Claude. Details: `11_DATAPATH.md` §4.

⚠️ Bei aktivem Nomads liegt dessen `shadow\` **vor allen Spieldaten**. Hooks anderer Mods
auf geshadowte Dateien wirken dann nicht. Bei „mein Hook tut nichts" zuerst
`usermods\nomads-4-loud\shadow\` nach der betroffenen Datei durchsuchen.
Die Originale bleiben über den Ersatzpfad `/loud` erreichbar.

### `NOMADS-try_b4_ur_BI` — NOMAD BI men
Erweiterung zum Nomads-Paket. Keine `requires`-Angabe, obwohl inhaltlich abhängig.

### `test21000`
```
mod_info.lua
units\UEL0001\   (vollständiger Einheitenordner, 17 Dateien)
```
Vollersatz des UEF-ACU. Siehe Kollisionshinweis bei `commanders`.

**Diff gegen das Original ergab: 8 geänderte Felder, alle in `Economy`.**

| Feld | Original | test21000 |
|---|---|---|
| `BuildRate` | 10 | 1000 |
| `MaxBuildDistance` | 10 | 100 |
| `ProductionPerSecondEnergy` | 20 | 1 000 000 |
| `ProductionPerSecondMass` | 2 | 10 000 |
| `StorageEnergy` | 5000 | 4000 |
| `BuildableCategory` | 4 × `BUILTBY*COMMANDER UEF` | `UEF`, `AEON`, `SERAPHIM`, `CYBRAN`, `NOMADS` |

Dafür werden ein 1283-Zeilen-Blueprint und 16 unveränderte Asset-Kopien ausgeliefert.
Als Merge-Blueprint wären es ~12 Zeilen und null Assets → Musterfall für den Neuschnitt,
ausgeführt in `12_NEUSCHNITT.md` §2.

### `UEF_trans_men`
Experimentelle Transporter u. a.
```
hook\  lua\  units\  effects\  projectiles\  env\  textures\  icons\
changes.txt  units.txt  All BO Assets  AllBOUnits  BO_Unleashed_UEF
All BO Assets.inCaseOfCorruption.bak   desktop.ini
```
Baut auf BO-Unleashed-Assets auf.

---

## LOUD-Erweiterung: `mountpoints` und `hooks` in `mod_info.lua` — **wirkungslos**

Zwei Mods (`nomads-4-loud`, `commanders`) verwenden Felder, die im Kopfkommentar von
`lua\mods.lua` nicht dokumentiert sind:

```lua
mountpoints = {
    ['effects'] = '/effects',   ['env']     = '/env',
    ['loc']     = '/loc',       ['lua']     = '/lua',
    ['meshes']  = '/meshes',    ['movies']  = '/movies',
    ['hook']    = '/hook',      ['projectiles'] = '/projectiles',
    ['sounds']  = '/sounds',    ['textures'] = '/textures',
    ['units']   = '/units',
}
hooks = { '/hook', '/sounds' }
```

**Geprüft: Diese Felder werden in dieser LOUD-Version von nichts ausgewertet.**
Weder `lua\mods.lua` noch `bin\CommonDataPath.lua` lesen sie. Sie stammen aus einem
anderen Mod-Loader und sind hier tote Deklarationen. **Nicht in eigene Mods übernehmen.**

Die Log-Zeile beim Start
`info: Mounting mod '<name>' with additional functionality (e.g. sounds)`
kommt **nicht** von diesen Feldern, sondern von `mount_mod()` in `CommonDataPath.lua` —
sie erscheint für *jeden* Mod-Ordner. Der zusätzliche Mount
`...\usermods\nomads-4-loud\sounds', mounted as '/sounds/'`
entsteht schlicht daraus, dass dieser Mod einen `sounds\`-Unterordner ohne
Namenskollisionen hat.

Vollständige Analyse: `11_DATAPATH.md` §2.

---

## Beobachtete Auffälligkeiten (nicht angefasst, nur notiert)

1. **`uid`-Qualität:** Nur `EscalatingBuildCosts` und `UEF_trans_men` haben GUID-artige uids.
   Die anderen nutzen Freitext (`THISoneIS4myBOImax`). Funktioniert, ist aber kollisionsanfällig.
   Die uid-Sortierung ist die **Standardreihenfolge**, wenn nichts anderes angegeben ist —
   sie erzwingt nichts. Wer die Reihenfolge braucht, setzt `before`/`after`.
2. **Doppelbelegung `UEL0001`** durch `commanders` und `test21000`. Einer von 187
   mehrfach belegten IDs insgesamt — vollständige Aufstellung in
   `units\ueberschreibungen.md`.
3. **Icon-Pfade:** `AcidPools` zeigt auf einen nicht existierenden Unterordner in
   `BrewLAN_Gameplay` (kosmetisch). `commanders` verweist auf ein Icon aus
   `nomads-4-loud` — gültig, aber eine undeklarierte Abhängigkeit.
4. Kein Mod nutzt `requires`/`conflicts`/`before`/`after`, obwohl mehrere voneinander abhängen
   oder kollidieren. Bei `NOMADS-try_b4_ur_BI` wäre ein `requires` auf `nomads-4-loud`
   inhaltlich korrekt.
5. **`nomads-4-loud` ist nach jedem LOUD-Update erneut zu installieren** (`.bat` ausführen).
   Kein Mangel des Mods, sondern Folge davon, dass `LOUD\bin\` vom LOUD-Team gepflegt wird.

---

## Vergebene uids neuer Mods

Nach `07_KONVENTIONEN.md` Abschnitt 2. Neue Eintraege werden angehaengt.

| Ordner | Name | uid | Angelegt | Doku |
|---|---|---|---|---|
| `EnhancedPauseBehavior` | Enhanced Pause Behavior | `E9410707-B979-462F-B9E8-3DDB886DB31B` | 2026-10-31 | `mods\EnhancedPauseBehavior.md` |
