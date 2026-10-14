# CLAUDE.md — Projektanweisung (Master)

> **Diese Datei zuerst lesen. Sie hat Vorrang vor allen anderen Dateien in `doc.claude`.**
> Alles andere in diesem Ordner ist Nachschlagewerk, das aus dieser Datei heraus verlinkt wird.

---

## 1. Projekt in einem Satz

Modding von **Supreme Commander: Forged Alliance** in der **LOUD**-Distribution.
Alle Änderungen entstehen ausschließlich als eigenständige User-Mods unter `LOUD\usermods\`.

---

## 2. Wurzelpfade (relativ zu `$FA`, immer mit Backslashes)

`$FA` ist das Arbeitsverzeichnis von Claude Code. Alle anderen Pfade werden relativ dazu
angegeben (Vorgabe Paul, 2026-10-13). Pfade enthalten Leerzeichen und `(x86)` - in der
Shell immer quoten.

| Kürzel | Pfad | Zugriff |
|---|---|---|
| `$FA` | `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance` | **nur lesen** |
| `$LOUD` | `$FA\LOUD` | **nur lesen** |
| `$GAMEDATA` | `$LOUD\gamedata` | **nur lesen** (gepackte `.scd`) |
| `$SRC` | `$LOUD\gamedata.entpackt` | **nur lesen** — Referenzquelle, entpackte Version von `$GAMEDATA` |
| `$MODS` | `$LOUD\usermods` | **SCHREIBEN ERLAUBT** |
| `$DOC` | `$MODS\doc.claude` | **SCHREIBEN ERLAUBT** (liegt seit 05.08.2026 **innerhalb** von `usermods`, damit im Git-Repo) |
| `$LOG` | `$LOUD\bin\LOUD.log` | **nur lesen** — Log der zuletzt gespielten Partie, wird bei jedem Start überschrieben. Auswertung: `15_LOG.md` |
| `$DATAPATH` | `$LOUD\bin\LoudDataPath.lua` + `CommonDataPath.lua` | **nur lesen** — bestimmt das gesamte VFS, siehe `11_DATAPATH.md` |
| `$REPOS` | `Repos` | **nur lesen** - Klone `Repos\LOUD` (https://github.com/LOUD-Project/Git-LOUD) und `Repos\FAF` (https://github.com/FAForever/fa). Massgeblich fuer "was laeuft im Spiel" bleibt `$SRC`; beide koennen abweichen |

Nicht verwechseln: `gamedata.entpackt` direkt unter `$FA` (nicht unter `LOUD`) ist **nicht**
`$SRC`, sondern der Basisspiel-Spiegel aus `Expand-Gamedata.ps1` (`14_TOOLS.md` §2). Im
Spiel erreichbar sind davon nur `textures`, `effects`, `env`, `projectiles`, `props`,
`meshes`; ein Treffer dort unter `lua\` oder `units\` sagt nichts ueber das laufende Spiel.

---

## 3. Eigentumsmodell — der Grund für alle Schreibregeln

```
usermods\  (inkl. usermods\doc.claude\)  →  UNSER Bereich, vollständig. Überlebt LOUD-Updates.
alles andere unter LOUD\ und $FA         →  LOUD-Team. Wird beim Update ERSETZT.
```

**Alles in `usermods\` gehört uns** — unabhängig davon, welcher Autor in einer
`mod_info.lua` steht. Es gibt hier keine fremden Besitzstände, nur Material in
unterschiedlichem Zustand.

Innerhalb von `usermods\` gilt derzeit:

```
Bestand (6 Mod-Ordner, Stand 2026-08-05)  →  EINGEFROREN. Vergleichsstand, wird abgelöst.
doc.claude\                               →  Dokumentation + tools\. ✅ schreiben.
neue Mods                                 →  hier entsteht alles Neue. Wird neu gedacht.
.git\                                     →  Werkzeugbereich. NICHT anfassen.
```

`usermods\` ist ein **Git-Arbeitsverzeichnis** (Remote: `Woonerf-1/Supcom-mods`, SSH,
Branch `main`). Die Dokumentation liegt seit dem 05.08.2026 mit darin und wird damit
mitversioniert. Claude schreibt Dateien; Commits, Branches, Push und Pull macht der Nutzer
in Sourcetree. Seit 2026-10-13 (Claude Code mit Shell) darf Claude **lesende** Git-Befehle
ausfuehren (`git status`, `git diff`, `git log`, `git show`) - nichts, was Index,
Arbeitsverzeichnis, Refs oder Remote veraendert. Details: `13_GIT.md`.

Das ist keine reine Vorsichtsregel: `gamedata\`, `bin\`, `doc\`, `maps\`, `sounds\` werden
vom LOUD-Team gepflegt und bei jedem Update überschrieben. Eine Änderung dort wäre
**ohnehin flüchtig** — sie ginge beim nächsten Update verloren, ohne Fehlermeldung.

Daraus folgt auch:
- **`gamedata.entpackt\` veraltet nach einem Update.** Vor Codearbeit Aktualität prüfen,
  siehe `01_ARCHITEKTUR.md` §2.
- **Bewusste Ausnahmen betreibt der Nutzer selbst.** Beispiel: `nomads-4-loud` ersetzt
  `bin\LoudDataPath.lua` per Batchdatei — das ist die vorgesehene Installation dieses Mods
  und muss nach jedem LOUD-Update wiederholt werden (`11_DATAPATH.md` §4).
  Wir führen das nicht aus, wir dokumentieren es.

---

## 4. Harte Regeln (nicht verhandelbar)

1. **Schreiben ausschließlich in `$MODS`** (also `usermods\`, einschließlich
   `usermods\doc.claude\`). Kein Schreiben, Verschieben, Umbenennen oder Löschen irgendwo
   sonst — insbesondere nicht in `$GAMEDATA`, `$SRC`, `$LOUD\bin`, `$LOUD\doc`,
   `$LOUD\maps`, `$LOUD\sounds`, `$FA\...`.
2. **Keine Batch-, Shell- oder Installationsskripte ausführen**, die außerhalb der
   Schreibzonen wirken — auch nicht die von Mods mitgelieferten. Stattdessen dem Nutzer
   sagen, was das Skript tut und dass er es selbst ausführen kann. Skripte, die
   ausschliesslich in `$MODS` schreiben (etwa `$DOC\tools\*.ps1`), fuehrt Claude nur nach
   Freigabe durch den Nutzer aus.
3. **`$SRC` ist heilig.** Es ist die Referenzbibliothek zum Nachschlagen von Engine- und
   LOUD-Code. Nie verändern. Wenn Originalcode als Grundlage gebraucht wird → **kopieren**
   in den Ziel-Mod unter `$MODS`, dort anpassen.
4. **Kein Raten bei Engine-APIs.** Jede verwendete Funktion, Blueprint-Feld oder Kategorie muss
   vorher in `$SRC` verifiziert werden. Wenn etwas nicht
   auffindbar ist: sagen, dass es unverifiziert ist — nicht plausibel erfinden.
   **Zwei Fallen dabei:**
   - **Ein Negativbefund gilt erst nach vollstaendiger Inhaltssuche** - case-insensitiv
     ueber den ganzen Baum (`rg -i` bzw. `Select-String`). Das fruehere Filesystem-MCP
     (`search_files`) lieferte ueber tiefe Baeume falsche negative Ergebnisse
     (`15_LOG.md` §6).
   - **„Existiert nicht" ≠ „nicht geladen".** Ein Blueprint aus einem inaktiven Mod liegt
     auf der Platte, ist im Spiel aber nicht vorhanden (`16_UNITS.md` §6).
5. **Der vorhandene Mod-Bestand ist eingefroren.** Die sechs Ordner in `$MODS` (Stand
   2026-08-05) werden **nicht mehr verändert** — weder repariert noch aufgeräumt. Nicht
   weil sie jemand anderem gehören, sondern weil alles **neu gedacht** wird. Sie bleiben
   als Vergleichsstand liegen. Neue Arbeit → **neuer Mod-Ordner mit neuer uid**.
   Konzept und Zuschnitt: `12_NEUSCHNITT.md`.
   Ebenfalls eingefroren (Entscheidung Paul 2026-10-13): `BasegameRevamp` und
   `advanced_rebalence` (beide Colin).
6. **`$MODS\.git\` ist tabu.** Kein Schreiben, keine veraendernden Git-Operationen, kein
   Simulieren von Commits. Erlaubt sind nur lesende Befehle (`status`, `diff`, `log`,
   `show`; Entscheidung Paul 2026-10-13). Am Ende einer Arbeitseinheit nennt Claude die
   geänderten Dateien und einen Vorschlag für die Commit-Nachricht — mehr nicht.
   Siehe `13_GIT.md`.
7. **`shadow` nur als letztes Mittel.** Standard ist `hook`. Begründung siehe `02_MODSYSTEM.md`.
8. **Kein Blueprint-Vollersatz, wenn `Merge = true` reicht.**

---

## 5. Standard-Arbeitsablauf für jede Aufgabe

```
1. VERSTEHEN   → Was genau soll sich im Spiel ändern? Sim oder UI? Blueprint oder Lua?
2. VERORTEN    → In $SRC die zuständige Originaldatei finden und lesen.
                 (rg -i ueber *.lua / *.bp, dann Datei lesen)
3. PLANEN      → Kürzesten Eingriffspunkt wählen: Blueprint-Merge > Hook > Shadow.
                 Betroffene Dateien + Mod-Ordner benennen, bevor geschrieben wird.
4. SCHREIBEN   → Nur unter $MODS\<modname>\...
5. DOKU        → mods\<modname>.md aktualisieren + CHANGELOG.md ergänzen.
6. TESTEN      → Nutzer startet LOUD; danach $LOG auswerten (siehe 06_WORKFLOW.md).
```

**Bei Unklarheit im Schritt 1 wird gefragt, nicht geraten.** Eine falsch verstandene Aufgabe
kostet mehr als eine Rückfrage.

---

## 6. Antwort- und Codestil

- **Sprache: Deutsch.** Codekommentare Deutsch, Bezeichner Englisch (Engine-Konvention).
- **Keine Vermutungen als Befund.** Was nicht belegt ist, wird nicht behauptet.
  Drei Moeglichkeiten, keine vierte:
  1. **belegen** - Quelle mit Pfad (relativ zu `$FA`) und Zeilenangabe,
  2. **als ungeprueft kennzeichnen** und **gleichzeitig als Aufgabe in `TODO.md`
     eintragen**,
  3. **weglassen**.

  Eine Vermutung ohne TODO-Eintrag ist ein Fehler. Formulierungen wie "vermutlich",
  "duerfte", "ist bei vielen Spielern aktiv" sind Warnzeichen - dort steht meist eine
  unbelegte Behauptung, die spaeter als Tatsache gelesen wird.

  Erlebte Faelle: "`commanders` gewinnt gegen `test21000`" (aus der uid-Sortierung
  abgeleitet, die aber nichts erzwingt), "`LOUD Integrated Storage` ist bei vielen
  Spielern aktiv" (frei erfunden - auf dieser Installation ist er nicht aktiv).
- **Dateien immer mit Pfad relativ zu `$FA` nennen** (Vorgabe Paul, 2026-10-13). Nie nur
  `BuildingTemplates.lua` oder `lua\AI\aibuildstructures.lua` — sondern:
  ```
  LOUD\gamedata.entpackt\lua\lua\BuildingTemplates.lua
  ```
  Der Pfad muss eindeutig sein, ohne suchen zu müssen. Gilt für
  Antworten **und** für neue Dokumentation. Zeilennummern dahinter, wenn bekannt.
  Aeltere Doku enthaelt noch absolute Pfade - die bleiben gueltig und werden nicht
  pauschal umgeschrieben.
  Ausnahme: Verweise auf Dokumente innerhalb von `$DOC` (dort reicht der Dateiname,
  weil sie nebeneinander liegen).
- **Knapp.** Kein Nacherzählen dessen, was ohnehin im Code steht.
- **Vollständige Dateien** bei neuen Dateien; **gezielte Diffs/Edits** bei bestehenden.
- Bei jedem Eingriff angeben: *welche Datei*, *welcher Mechanismus* (Hook/Merge/Shadow),
  *welche Original-Referenz aus `$SRC`*.
- Unsicherheiten explizit markieren: `-- UNGEPRÜFT:` im Code, „nicht verifiziert" im Text
  — **und in `TODO.md` eintragen** (siehe oben).

---

## 7. Modularisierung der Doku

**Prinzip: Index oben, Details unten.** Große Datenmengen liegen in Unterordnern mit
eigener `README.md` als Index; die Datei eine Ebene höher verweist nur darauf. So bleibt
jede Ebene klein genug, um sie ganz zu lesen — und man muss nie alles laden, um etwas zu
finden.

```
17_UNITLISTE.md → units\README.md → units\<paket>.md → units\<UNITID>.md
```

Beim Anlegen neuer Daten: **erst prüfen, ob ein Index vorhanden ist**, dort eintragen und
verlinken. Keine Daten doppelt führen — wandert Inhalt in eine Detaildatei, verschwindet
er aus der übergeordneten und wird nur noch verlinkt.

| Datei | Inhalt | Wann lesen |
|---|---|---|
| `README.md` | Index & Einstieg | Orientierung |
| `01_ARCHITEKTUR.md` | Ordner, VFS, Mounts, Ladekette | immer bei Pfadfragen |
| `02_MODSYSTEM.md` | `mod_info.lua`, hook/shadow/schook, Ladereihenfolge | vor jedem neuen Mod |
| `03_BLUEPRINTS.md` | `.bp`-Aufbau, Merge, Unit-IDs, Kategorien | Balance/Einheiten |
| `04_LUA_SIM.md` | Sim-Klassen, Hook-Punkte, wichtige Dateien | Verhaltensänderungen |
| `05_UI_MODS.md` | `ui_only`, `/lua/ui`, Lobby | Interface |
| `06_WORKFLOW.md` | Testzyklus, Log, typische Fehler | bei jedem Testlauf |
| `07_KONVENTIONEN.md` | Namens-, Code- und Dateikonventionen | beim Schreiben |
| `08_BESTANDSAUFNAHME.md` | Was liegt schon in `usermods` | vor Namenswahl |
| `09_GLOSSAR.md` | Begriffe, Abkürzungen, Präfixe | bei Fachbegriffen |
| `10_VORLAGEN.md` | Copy-Paste-Gerüste | beim Anlegen |
| `11_DATAPATH.md` | **`LoudDataPath.lua` / `CommonDataPath.lua`** — VFS-Aufbau, `mount_mods` | bei jeder Pfad-, Mount- oder Sound-Frage |
| `12_NEUSCHNITT.md` | **Konzept für den Neuschnitt der Mods** — Freeze, Befunde, Zielstruktur | vor jeder Arbeit an einem Mod |
| `13_GIT.md` | **Git-Anbindung von `usermods\`** — Remote, Regeln, offene Punkte | bei Versionierungsfragen |
| `14_TOOLS.md` | **`doc.claude\tools\`** — Registry-Einträge, Hilfsskripte | bei Werkzeugfragen |
| `15_LOG.md` | **`LOUD.log`** — Auswertungsverfahren + **Befundregister** (Warnungen/Fehler mit Code-Rückverfolgung) | nach jedem Testlauf |
| `16_UNITS.md` | Einheitenliste — optionaler Generator | ergänzend |
| `17_UNITLISTE.md` | **Einheiten-Index** — Bestand, ID-Systematik, Verweise nach `units\` | Einstieg bei Unit-Fragen |
| `18_ABLEITUNG.md` | **Ableitung aus `UEF_trans_men`** — vier neue Mods, Befunde, nachgeprüfte Modsystem-Mechanik (mount/hook/shadow/merge) | bei Arbeit an `T4UnitAdditions`, `SquareShields`, `ImprovedHydrocarbonPowerPlants`, `DynamicGameplay` |
| `units\` | **Einheitendaten** — `units.md`, `pakete.md`, `usermods.md`, `ueberschreibungen.md` | Details |
| `referenz\` | Verbatim-Kopien der beiden DataPath-Dateien | zum Vergleich bei Verdacht auf Überschreibung |
| `CHANGELOG.md` | Was wurde wann geändert | nach jeder Änderung |
| `TODO.md` | Offene Punkte, Ideen, Blocker | Sessionstart/-ende |
| `mods\<name>.md` | Ein Dokument pro eigenem Mod | mod-spezifisch |

---

## 8. Definition of Done

Eine Aufgabe gilt erst als erledigt, wenn:

- [ ] alle geschriebenen Dateien unter `$MODS` liegen — nachweislich, nichts sonst
- [ ] der Mod ein gültiges `mod_info.lua` mit **eindeutiger `uid`** hat
- [ ] `mods\<modname>.md` existiert und den Eingriff erklärt (was, wo, warum, Risiken)
- [ ] `CHANGELOG.md` einen Eintrag mit Datum hat
- [ ] die geänderten Dateien benannt und eine Commit-Nachricht vorgeschlagen wurde
- [ ] verwendete Engine-Funktionen in `$SRC` belegt sind
- [ ] bekannte Konflikte mit anderen aktiven Mods benannt sind

---

## 9. Sessionstart-Checkliste

1. `README.md` und diese Datei überfliegen.
2. `TODO.md` lesen — womit ging es zuletzt weiter?
3. **Bei Codearbeit: Aktualität von `$SRC` prüfen** (`01_ARCHITEKTUR.md` §2). Nach einem
   LOUD-Update ist der entpackte Stand veraltet.
4. Die betroffene Referenzdatei in `$SRC` **frisch lesen**, nicht aus dem Gedächtnis
   arbeiten. LOUD weicht an vielen Stellen vom Vanilla-FA ab.
