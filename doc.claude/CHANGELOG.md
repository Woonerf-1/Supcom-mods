# CHANGELOG

Chronologisches Protokoll aller Änderungen in diesem Projekt.
Neueste Einträge oben. Format je Eintrag:

```
## JJJJ-MM-TT — <Mod oder Bereich>
- **Was:** ...
- **Wo:**  usermods\... / doc.claude\...
- **Wie:** Hook / Merge / Shadow / neu
- **Warum:** ...
- **Getestet:** ja/nein — Ergebnis
```

---

## 2026-08-05 — Doku nach `usermods\doc.claude\` umgezogen

- **Was:** Die Arbeitsdokumentation liegt jetzt im Git-Repository
- **Wo:** von `LOUD\doc.claude\` nach `LOUD\usermods\doc.claude\`
- **Wie:** Dateien vom Nutzer kopiert, Referenzen von Claude angepasst
- **Warum:** Doku und Code im selben Repository → gemeinsame Versionsgeschichte
- **Getestet:** entfällt (reine Doku)

Angepasste Verweise:
- `CLAUDE.md` — `$DOC` zeigt jetzt auf `$MODS\doc.claude`; Regel 1 und Definition of Done
  vereinfacht (nur noch eine Schreibzone: `$MODS`); Eigentumsmodell und Zonenschema
  aktualisiert.
- `README.md` — Strukturbaum, Schreibzonen-Tabelle, Ortsangabe.
- `01_ARCHITEKTUR.md` — Ordnerlandkarte; neuer Hinweis, dass `usermods\doc.claude\` als
  `/mods/doc.claude/` gemountet wird (harmlos, keine `mod_info.lua` → kein Mod).
- `06_WORKFLOW.md`, `07_KONVENTIONEN.md` — Pfadangaben und Zonenlisten.
- `08_BESTANDSAUFNAHME.md` — `doc.claude\` im Wurzelverzeichnis ergänzt.
- `13_GIT.md` — **Entscheidung revidiert:** die Doku liegt jetzt im Repo statt draußen.
  Begründung und Nebenwirkung im Spiel ergänzt.
- `referenz\README.md` — relative Verweise auf `..\`.

⚠️ **Offen:** Der alte Ordner `LOUD\doc.claude\` existiert weiterhin (kopiert, nicht
verschoben). Er muss gelöscht werden, sonst laufen zwei Stände auseinander. Liegt
außerhalb der Schreibzone → erledigt der Nutzer. Steht in `TODO.md` unter „Dringend".

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — Git: Zugangsdaten bereinigt, Geltungsbereich festgelegt

- **Was:** Sicherheitspunkt geschlossen; Umfang des Repositorys entschieden
- **Wo:** `doc.claude\13_GIT.md`, `README.md`, `TODO.md`
- **Getestet:** Zustand von `.git\config` und `.git\sourcetreeconfig.json` geprüft

✅ **Zugangsdaten erledigt.** Remote auf SSH (`git@github.com:Woonerf-1/Supcom-mods.git`,
auch als `pushurl`). In `.git\sourcetreeconfig.json` steht unter `Username` nur noch der
Kontoname, kein Token. Keine Zugangsdaten mehr unterhalb von `usermods\`.
Daraus abgeleitete Dauerregel in `13_GIT.md` §1.

**Geltungsbereich entschieden** (`13_GIT.md` §5):
- Das Repository umfasst **ausschließlich die Mods unter unserer Kontrolle**.
- Diese aber **vollständig**, inklusive Binär-Assets (`.scm`, `.dds`, `.sca`, `.bmp`).
  Ein Mod ohne seine Assets ist kein Mod.
- **Kein LFS**, **kein Ausschluss von Modinhalten** per `.gitignore`.
- **`doc.claude\` bleibt draußen** — es ist ein Mod-Repo, kein Projekt-Repo.

Daraus folgt für neue Mods: fertig ist ein Mod erst, wenn er komplett im Repository liegt
— keine Verweise auf nur lokal vorhandene Dateien. Das verstärkt zugleich die Regel gegen
unveränderte Asset-Kopien: was nicht geändert wurde, gehört weder in den Mod noch ins Repo.

Damit entfallen die früheren offenen Fragen zu `.gitignore`, LFS und `doc.claude\`.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — Remote auf SSH umgestellt

- **Was:** Git-Remote von HTTPS-mit-Token auf SSH umgestellt (durch den Nutzer);
  Doku nachgezogen
- **Wo:** `doc.claude\13_GIT.md`, `TODO.md`
- **Getestet:** entfällt (reine Doku)

✅ `.git\config` enthält keine Zugangsdaten mehr:
`origin` und `pushurl` zeigen auf `git@github.com:Woonerf-1/Supcom-mods.git`.
Lokale Identität ergänzt (`user.name`, `user.email`).

⚠️ **Zwei Punkte bleiben offen:**
1. In `.git\sourcetreeconfig.json` steht unter `RemoteProjectLinks[].Username` weiterhin
   ein Personal Access Token im Klartext — und zwar ein **anderer** als der zuvor in
   `.git\config`. Für Push/Pull über SSH wird er nicht gebraucht.
2. Beide Token sind auf GitHub **weiterhin gültig**. Entfernen aus einer Konfigurationsdatei
   widerruft sie nicht. Widerruf steht aus.

Verfahren in `13_GIT.md` §1, Aufgaben in `TODO.md` unter „Dringend".
Token wurden bewusst nicht in die Dokumentation übernommen.

---

## 2026-08-05 — Git-Anbindung von `usermods\`

- **Was:** `usermods\` ist jetzt ein Git-Arbeitsverzeichnis; Doku erfasst den neuen Stand
- **Wo:** `doc.claude\13_GIT.md` (neu), `CLAUDE.md`, `README.md`,
  `08_BESTANDSAUFNAHME.md`, `TODO.md`
- **Wie:** neu + Aktualisierung
- **Getestet:** entfällt (reine Doku)

Erfasster Zustand:
- Remote `origin` → `github.com/Woonerf-1/Supcom-mods`, Branch `main`, Werkzeug SourceTree.
- Lokale Historie besteht bisher nur aus dem Clone-Eintrag — keine eigenen Commits.
- Kein `.gitignore` vorhanden.
- Neu im Wurzelverzeichnis: `README.md` (`"#Supcom-mods"`), `test.txt` (`"s"`).
- **`EscalatingBuildCosts` ist entfallen** → Bestand jetzt 6 statt 7 Mods.
  Befunde dazu bleiben als Negativbeispiel in `04_LUA_SIM.md` §3 und `12_NEUSCHNITT.md` §2.

Neue Regeln:
- Regel 6 in `CLAUDE.md`: **`.git\` ist tabu.** Claude führt kein Git aus — es gibt keine
  Shell auf dem Rechner des Nutzers. Claude schreibt Dateien, benennt am Ende die
  geänderten und schlägt eine Commit-Nachricht vor; committen tut der Nutzer.
- Definition of Done um diesen Punkt ergänzt.

⚠️ **Sicherheitsbefund:** `usermods\.git\config` enthält einen GitHub Personal Access
Token im Klartext in der Remote-URL. Widerruf und Bereinigung stehen als dringender
Punkt in `TODO.md`, Verfahren in `13_GIT.md` §1. Der Token wurde bewusst **nicht** in
die Dokumentation übernommen.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — Klarstellung: alles in `usermods\` gehört uns

- **Was:** Eigentumsfrage innerhalb `usermods\` korrigiert; Zuschnitt-Vorschlag zurückgezogen
- **Wo:** `CLAUDE.md`, `README.md`, `08_BESTANDSAUFNAHME.md`, `12_NEUSCHNITT.md`, `TODO.md`
- **Wie:** Korrektur
- **Getestet:** entfällt (reine Doku)

- Es gibt in `usermods\` **keine Fremd-Mods**. Die Autorenfelder in den `mod_info.lua`
  begründen keine Zuständigkeit. Frühere Formulierungen wie „Fremdpaket" und
  „stammen nicht aus diesem Projekt" entfernt.
- Der Freeze bleibt, aber mit anderer Begründung: **nicht** weil das Material jemand
  anderem gehört, sondern weil alles neu gedacht und in neuen Mods umgesetzt wird.
- **`12_NEUSCHNITT.md` §3 (Zuschnitt) geleert.** Der vorherige Vorschlag mit `mm_*`-Namen
  war verfrüht — er hätte den Bestand als Vorlage fortgeschrieben. Der inhaltliche
  Zuschnitt kommt vom Nutzer.
- Befunde und Regeln (§2, §4, §5) bleiben, sie gelten unabhängig vom Zuschnitt.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — Bestand eingefroren, Neuschnitt-Konzept angelegt

- **Was:** Der vorhandene Mod-Bestand ist eingefroren; Konzeptpapier für den Neuschnitt
- **Wo:** `doc.claude\12_NEUSCHNITT.md` (neu), `CLAUDE.md`, `README.md`,
  `08_BESTANDSAUFNAHME.md`, `TODO.md`
- **Wie:** neu + Umstellung der Bestandsdoku
- **Warum:** Alle sieben Mods sind optional, teils fehlerhaft und sollen grundsätzlich neu
  geschnitten werden
- **Getestet:** entfällt (reine Doku)

Änderung der Arbeitsgrundlage:
- Regel 5 in `CLAUDE.md` umformuliert — vorher „Fremd-Mods nicht anfassen", jetzt
  „Bestand eingefroren, Ausgangsmaterial für den Neuschnitt". Abschalten ja,
  überschreiben/löschen nein.
- Neue Zone in der Schreibzonen-Tabelle: bestehende Mods = ❄️ eingefroren,
  neue `mm_*`-Ordner = ✅ schreibbar.
- `08_BESTANDSAUFNAHME.md` ist jetzt ausdrücklich Ausgangsaufnahme, kein Sollzustand.
  Neue Spalte „Ersetzt durch".
- Offene Bestandsprobleme in `TODO.md` von Aufgaben zu Befunden umgewidmet.

Messung für das Konzept (Diff über die Analyseumgebung):
- **`test21000` ändert 8 Felder**, alle in `Economy` (`BuildRate` 10→1000,
  `MaxBuildDistance` 10→100, `ProductionPerSecondEnergy` 20→1 000 000,
  `ProductionPerSecondMass` 2→10 000, `StorageEnergy` 5000→4000,
  `BuildableCategory` von 4 UEF-Einträgen auf alle fünf Fraktionen).
  Ausgeliefert als 1283-Zeilen-Blueprint plus 16 unveränderte Asset-Kopien.
  Als Merge-Blueprint: ~12 Zeilen, null Assets. → Musterfall des Neuschnitts.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — Korrekturen: `.scd`-Zugriff, Eigentumsmodell, Nomads

- **Was:** Drei Klarstellungen des Nutzers eingearbeitet
- **Wo:** `01_ARCHITEKTUR.md`, `CLAUDE.md`, `11_DATAPATH.md`, `08_BESTANDSAUFNAHME.md`,
  `referenz\README.md`, `TODO.md`
- **Wie:** Korrektur bestehender Doku
- **Getestet:** `.scd`-Auspacken praktisch verifiziert (`loc_US.scd` → ZIP, `method=store`)

1. **`.scd` direkt lesen?** Technisch ja — Archiv in die Analyseumgebung kopieren und
   auspacken funktioniert. Praktisch nein: `units.scd` 306 MB, `brewlan.scd` 200 MB, und
   jede Suche wäre ein Einzelvorgang. **`gamedata.entpackt\` bleibt die Referenz.**
   Neu dokumentiert: Verfahren zur Aktualitätsprüfung des entpackten Stands
   (`01_ARCHITEKTUR.md` §2). Stand heute: aktuell (entpackt 05.08., neuestes `.scd` 01.08.).

2. **Eigentumsmodell** als eigener Abschnitt in `CLAUDE.md` §3:
   `usermods\` + `doc.claude\` = unser Bereich, überlebt Updates.
   Alles andere = LOUD-Team, wird beim Update ersetzt. Änderungen dort wären flüchtig.
   Neue Regel Nr. 2: keine mitgelieferten Installationsskripte ausführen — nur erklären.

3. **Korrektur Nomads:** Das Überschreiben von `bin\LoudDataPath.lua` ist **beabsichtigt
   und nötig**, nicht gefährlich. Der Mod braucht Mounts vor den LOUD-Daten; das geht nur
   über die Mount-Konfiguration. `CopyLoudDataPath.bat` ist ein QoL-Helfer und muss nach
   jedem LOUD-Update erneut laufen. Frühere Warnung („nicht ausführen") zurückgenommen —
   ersetzt durch: der Nutzer führt aus, Claude dokumentiert.

Neu in `TODO.md`: Checkliste „Nach jedem LOUD-Update".

**Es wurden keine Spieldateien verändert.**

---

## 2026-08-05 — `LoudDataPath.lua` / `CommonDataPath.lua` analysiert

- **Was:** Vollständige Analyse der VFS-Aufbaudateien; neue Doku + Referenzkopien
- **Wo:** `doc.claude\11_DATAPATH.md`, `doc.claude\referenz\`
- **Wie:** neu; Korrekturen in `06_WORKFLOW.md`, `08_BESTANDSAUFNAHME.md`, `CLAUDE.md`, `README.md`, `TODO.md`
- **Warum:** Diese beiden Dateien bestimmen vor allem anderen, welche Dateien das Spiel sieht
- **Getestet:** entfällt (reine Doku)

Neue Erkenntnisse:
- `mount_mods()` mountet **jeden** Unterordner von `usermods\` — unabhängig von `mod_info.lua`.
  Deaktivieren durch Verschieben funktioniert daher nicht (Korrektur in `06_WORKFLOW.md` §5).
- VFS-Name eines Mods = **kleingeschriebener Ordnername**, nicht das `name`-Feld.
- Gepackte Mods (`.zip`/`.scd`/`.rar`) in `usermods\` landen auf `/` statt `/mods/`.
- Eigene `sounds\*.xwb` werden **komplett verworfen**, wenn ein Dateiname mit einer der
  ~80 fest codierten FA-Soundbanks oder einer bereits geladenen Mod-Bank kollidiert.
- **Korrektur:** `mountpoints` und `hooks` in `mod_info.lua` (bei `nomads-4-loud`,
  `commanders`) sind **wirkungslos** — weder `mods.lua` noch `CommonDataPath.lua` lesen sie.
  Frühere Annahme in `08_BESTANDSAUFNAHME.md` berichtigt.
- Der SCFA-Standardpfad unter *Eigene Dateien* ist auskommentiert → nur `LOUD\usermods\` zählt.
- `bin\LoudDataPath.lua` ist derzeit die **Originalversion**; `nomads-4-loud` hat sie nicht
  überschrieben. Vergleichskopie liegt in `referenz\`.

Gelesene Quellen (nur gelesen):
`LOUD\bin\CommonDataPath.lua`, `usermods\nomads-4-loud\LoudDataPath.lua`,
`usermods\nomads-4-loud\mount_nomads.lua`, `usermods\nomads-4-loud\CopyLoudDataPath.bat`

**Es wurden keine Spieldateien verändert.**

---

## 2026-08-05 — Projektaufsetzung (doc.claude)

- **Was:** Dokumentationsstruktur für die Zusammenarbeit angelegt
- **Wo:** `doc.claude\`
- **Wie:** neu
- **Warum:** klare Projektanweisung, Schreibzonen und modulare Nachschlagewerke
- **Getestet:** entfällt (reine Doku)

Erstellte Dateien:
`CLAUDE.md`, `README.md`, `01_ARCHITEKTUR.md`, `02_MODSYSTEM.md`, `03_BLUEPRINTS.md`,
`04_LUA_SIM.md`, `05_UI_MODS.md`, `06_WORKFLOW.md`, `07_KONVENTIONEN.md`,
`08_BESTANDSAUFNAHME.md`, `09_GLOSSAR.md`, `10_VORLAGEN.md`, `CHANGELOG.md`, `TODO.md`,
`mods\_VORLAGE.md`

Analysierte Quellen (nur gelesen):
- `LOUD\bin\LoudDataPath.lua` — VFS-Mounts, `mount_mods` → `/mods`, globaler Hook `/schook`
- `LOUD\bin\LOUD.log` — bestätigte Mountpfade und Ladereihenfolge
- `gamedata.entpackt\lua\lua\mods.lua` — Modsystem, alle `mod_info.lua`-Felder
- `gamedata.entpackt\lua\lua\system\Blueprints.lua` — Ladeablauf, `Merge`, `ModBlueprints`
- `gamedata.entpackt\lua\lua\system\utils.lua` — `table.merged` (indexweiser Listen-Merge)
- `gamedata.entpackt\units\units\UEL0001\UEL0001_unit.bp` — Blueprint-Referenz
- alle `mod_info.lua` in `usermods\`

**Es wurden keine Spieldateien verändert.**

---

<!-- Neue Einträge oberhalb dieser Zeile einfügen. -->
