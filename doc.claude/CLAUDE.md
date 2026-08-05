# CLAUDE.md — Projektanweisung (Master)

> **Diese Datei zuerst lesen. Sie hat Vorrang vor allen anderen Dateien in `doc.claude`.**
> Alles andere in diesem Ordner ist Nachschlagewerk, das aus dieser Datei heraus verlinkt wird.

---

## 1. Projekt in einem Satz

Modding von **Supreme Commander: Forged Alliance** in der **LOUD**-Distribution.
Alle Änderungen entstehen ausschließlich als eigenständige User-Mods unter `LOUD\usermods\`.

---

## 2. Wurzelpfade (immer absolut, immer mit Backslashes)

| Kürzel | Pfad | Zugriff |
|---|---|---|
| `$FA` | `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance` | **nur lesen** |
| `$LOUD` | `$FA\LOUD` | **nur lesen** |
| `$GAMEDATA` | `$LOUD\gamedata` | **nur lesen** (gepackte `.scd`) |
| `$SRC` | `$LOUD\gamedata.entpackt` | **nur lesen** — Referenzquelle, entpackte Version von `$GAMEDATA` |
| `$MODS` | `$LOUD\usermods` | **SCHREIBEN ERLAUBT** |
| `$DOC` | `$MODS\doc.claude` | **SCHREIBEN ERLAUBT** (liegt seit 05.08.2026 **innerhalb** von `usermods`, damit im Git-Repo) |
| `$LOG` | `$LOUD\bin\LOUD.log` | nur lesen (Laufzeit-Log des Spiels) |
| `$DATAPATH` | `$LOUD\bin\LoudDataPath.lua` + `CommonDataPath.lua` | **nur lesen** — bestimmt das gesamte VFS, siehe `11_DATAPATH.md` |

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
mitversioniert. Claude kann **kein Git ausführen** — es gibt keine Shell auf dem Rechner
des Nutzers. Claude schreibt Dateien; Commits, Branches, Push und Pull macht der Nutzer.
Details: `13_GIT.md`.

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
   sagen, was das Skript tut und dass er es selbst ausführen kann.
3. **`$SRC` ist heilig.** Es ist die Referenzbibliothek zum Nachschlagen von Engine- und
   LOUD-Code. Nie verändern. Wenn Originalcode als Grundlage gebraucht wird → **kopieren**
   in den Ziel-Mod unter `$MODS`, dort anpassen.
4. **Kein Raten bei Engine-APIs.** Jede verwendete Funktion, Blueprint-Feld oder Kategorie muss
   vorher in `$SRC` verifiziert werden (`search_files` / `read_text_file`). Wenn etwas nicht
   auffindbar ist: sagen, dass es unverifiziert ist — nicht plausibel erfinden.
5. **Der vorhandene Mod-Bestand ist eingefroren.** Die sechs Ordner in `$MODS` (Stand
   2026-08-05) werden **nicht mehr verändert** — weder repariert noch aufgeräumt. Nicht
   weil sie jemand anderem gehören, sondern weil alles **neu gedacht** wird. Sie bleiben
   als Vergleichsstand liegen. Neue Arbeit → **neuer Mod-Ordner mit neuer uid**.
   Konzept und Zuschnitt: `12_NEUSCHNITT.md`.
6. **`$MODS\.git\` ist tabu.** Kein Schreiben, keine Git-Operationen, kein Simulieren von
   Commits. Am Ende einer Arbeitseinheit nennt Claude die geänderten Dateien und einen
   Vorschlag für die Commit-Nachricht — mehr nicht. Siehe `13_GIT.md`.
7. **`shadow` nur als letztes Mittel.** Standard ist `hook`. Begründung siehe `02_MODSYSTEM.md`.
8. **Kein Blueprint-Vollersatz, wenn `Merge = true` reicht.**

---

## 5. Standard-Arbeitsablauf für jede Aufgabe

```
1. VERSTEHEN   → Was genau soll sich im Spiel ändern? Sim oder UI? Blueprint oder Lua?
2. VERORTEN    → In $SRC die zuständige Originaldatei finden und lesen.
                 (search_files mit *.lua / *.bp, dann read_text_file)
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
- **Knapp.** Kein Nacherzählen dessen, was ohnehin im Code steht.
- **Vollständige Dateien** bei neuen Dateien; **gezielte Diffs/Edits** bei bestehenden.
- Bei jedem Eingriff angeben: *welche Datei*, *welcher Mechanismus* (Hook/Merge/Shadow),
  *welche Original-Referenz aus `$SRC`*.
- Unsicherheiten explizit markieren: `-- UNGEPRÜFT:` im Code, „nicht verifiziert" im Text.

---

## 7. Modularisierung der Doku

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
