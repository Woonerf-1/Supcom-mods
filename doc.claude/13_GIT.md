# 13 — Git-Anbindung von `usermods\`

`LOUD\usermods\` ist seit dem 05.08.2026 ein Git-Arbeitsverzeichnis.

| | |
|---|---|
| **Repository-Wurzel** | `LOUD\usermods\` |
| **Enthält** | alle Mods + Dokumentation (`doc.claude\`, inkl. `tools\`) |
| **Remote** | `origin` → `git@github.com:Woonerf-1/Supcom-mods.git` (**SSH**) |
| **Push-URL** | identisch, SSH |
| **Branch** | `main` (folgt `origin/main`) |
| **Identität** | `DESKTOP-WOHNZIM\paulm` / `paul.mertens@hotmail.de` (lokal gesetzt) |
| **Historie lokal** | bisher nur der Clone-Eintrag, keine lokalen Commits |
| **Werkzeug** | SourceTree (`.git\sourcetreeconfig.json` vorhanden) |
| **`.gitignore`** | keine — bewusst, siehe §5 |

---

## 1. Zugangsdaten — erledigt ✅

Stand 2026-08-05, geprüft:

- `.git\config` enthält **keine Zugangsdaten**. `url` und `pushurl` zeigen auf
  `git@github.com:Woonerf-1/Supcom-mods.git`, Authentifizierung über SSH-Schlüssel.
- `.git\sourcetreeconfig.json` enthält **keinen Token** mehr — unter `Username` steht nur
  noch der Kontoname.
- Lokale Identität gesetzt: `user.name`, `user.email`.

Die zwischenzeitlich vorhandenen Personal Access Tokens wurden entfernt und vom Nutzer
bereinigt. Keine Zugangsdaten mehr in Dateien unter `usermods\`.

**Regel für die Zukunft:** Zugangsdaten gehören nicht in Dateien unterhalb von `usermods\`.
SSH-Schlüssel oder Windows-Credential-Manager — nichts im Klartext im Spielverzeichnis.

---

## 2. Was das für die Arbeit bedeutet

**Gut:** Der Freeze des Bestands ist jetzt technisch abgesichert. Jeder Stand ist
wiederherstellbar, ein versehentliches Überschreiben ist reversibel. Der Grundsatz
„löschen nein, nur abschalten" wird dadurch entspannter — Git ist das Sicherheitsnetz.

**Zu beachten:**

- **Claude fuehrt nur lesendes Git aus** (seit 2026-10-13, Claude Code mit Shell):
  `git status`, `git diff`, `git log`, `git show`. **Commits, Branches, Push und Pull macht
  der Nutzer** (SourceTree oder Kommandozeile). Claude schreibt Dateien und sagt, was
  committet werden sollte.
- **`doc.claude\` liegt jetzt im Repository** (`usermods\doc.claude\`). Dokuänderungen sind
  damit Teil der Commits — idealerweise zusammen mit der zugehörigen Modänderung.
- Bei Änderungen an einem Mod sollte vorher der Arbeitsbaum sauber sein, damit der Diff
  hinterher aussagekräftig ist.

---

## 3. Aktueller Inhalt des Arbeitsverzeichnisses

```
usermods\
├── .git\                      Repository
├── doc.claude\                Arbeitsdokumentation (seit 05.08.2026 hier)
│   ├── referenz\              Verbatim-Kopien der DataPath-Dateien
│   ├── tools\                 Hilfsmittel, kein Mod (14_TOOLS.md)
│   └── mods\                  je ein Dokument pro eigenem Mod
├── README.md                  Inhalt derzeit nur "#Supcom-mods"
├── test.txt                   Inhalt "s" — Testartefakt, kann weg
├── AcidPools\
├── commanders\
├── nomads-4-loud\
├── NOMADS-try_b4_ur_BI\
├── test21000\
└── UEF_trans_men\
```

**Veränderung gegenüber der Bestandsaufnahme vom 05.08.:**
`EscalatingBuildCosts\` ist **entfallen** (vorher 7 Mods, jetzt 6).
→ `08_BESTANDSAUFNAHME.md` entsprechend angepasst.

---

## 4. Regeln für Claude

1. **`.git\` wird nicht angefasst** — weder gelesen zur Manipulation noch beschrieben.
   Ausnahme: Konfigurationsdateien lesen, um den Repository-Zustand zu verstehen.
2. **Keine Git-Operationen simulieren.** Claude committet nicht, merged nicht, löst keine
   Konflikte auf. Claude schreibt Dateien; die Versionierung macht der Nutzer.
3. **Am Ende einer Arbeitseinheit** kurz benennen, welche Dateien geändert wurden und
   welche Commit-Nachricht sinnvoll wäre.
4. **Keine Zugangsdaten in Dateien schreiben**, die im Repository landen könnten.
5. Der Freeze des Bestands (`CLAUDE.md` Regel 5) gilt weiterhin — Git ersetzt ihn nicht,
   es sichert ihn nur ab.

---

## 5. Festgelegter Geltungsbereich

**Das Repository umfasst die Mods unter unserer Kontrolle — diese vollständig — sowie die
Arbeitsdokumentation.** Das ist eine bewusste Entscheidung, keine offene Frage.

### Was daraus folgt

| Punkt | Entscheidung |
|---|---|
| Umfang | alles unter `usermods\` — die Mods sind vollständig im Repo |
| Binärdateien (`.scm`, `.dds`, `.sca`, `.bmp`) | **mitversioniert**. Ein Mod ohne seine Assets ist kein Mod. |
| Git LFS | nicht eingerichtet. Bei Bedarf später nachrüstbar, derzeit kein Thema. |
| `.gitignore` | **kein Ausschluss von Modinhalten.** Falls überhaupt, dann nur für Systemmüll, der zu keinem Mod gehört (siehe unten). |
| `doc.claude\` | **liegt seit 05.08.2026 im Repo** (`usermods\doc.claude\`) und wird mitversioniert. Vorher außerhalb — Entscheidung revidiert. Enthält auch `tools\` → `14_TOOLS.md`. **Keine Zugangsdaten darin.** |
| LOUD-Spieldaten | draußen — werden vom LOUD-Team gepflegt |

### Warum die Doku mit ins Repo gehört

- **Doku und Code bleiben synchron.** Ein Commit kann Modänderung und zugehörige
  Dokumentation zusammen enthalten.
- **Die Entscheidungshistorie ist gesichert.** `CHANGELOG.md` und `TODO.md` bekommen eine
  echte Versionsgeschichte statt nur des jeweils aktuellen Stands.
- **Ein Backup weniger zu bedenken.** Vorher wäre die Doku bei einem Plattenschaden weg
  gewesen, die Mods nicht.

### Nebenwirkung im Spiel (harmlos)

`mount_mods()` mountet **jeden** Unterordner von `usermods\` — also auch `doc.claude\`,
als `/mods/doc.claude/`. Da dort keine `mod_info.lua` liegt, registriert die Engine keinen
Mod, und `.md`-Dateien liest sie ohnehin nie. Der Ordner taucht lediglich im `LOUD.log`
bei den Mounts auf. Siehe `01_ARCHITEKTUR.md` §4.

### Konsequenz für neue Mods

Ein neuer Mod ist erst fertig, wenn er **komplett** im Repository liegt: `mod_info.lua`,
Hooks, Blueprints, Icons und alle Assets, die er tatsächlich braucht. Kein Verweis auf
Dateien, die nur lokal existieren.

Das ist ein weiteres Argument gegen unveränderte Asset-Kopien (`12_NEUSCHNITT.md` §2):
was nicht geändert wurde, gehört nicht in den Mod — und damit auch nicht ins Repository.

### Kleinkram, falls doch eine `.gitignore` gewünscht wird

Diese Dateien gehören zu keinem Mod und stammen von Windows bzw. Werkzeugen:

```
desktop.ini
Thumbs.db
```

Im Bestand betrifft das u. a. `UEF_trans_men\desktop.ini` sowie
`UEF_trans_men\All BO Assets.inCaseOfCorruption.bak`. **Keine Eile** — mitversioniert
schaden sie nicht, sie sind nur Rauschen in der Historie.

---

## 6. Offene Punkte

- [x] **Alte Doku unter `LOUD\doc.claude\` gelöscht** (05.08.2026, geprüft) — nur noch
      ein Stand.
- [ ] `test.txt` entfernen — Testartefakt mit Inhalt `"s"`, gehört zu keinem Mod.
- [ ] `README.md` im Repo füllen — derzeit nur `"#Supcom-mods"`. Sinnvoll: kurze
      Übersicht der enthaltenen Mods und ein Verweis auf `doc.claude\`.
