# doc.claude — Arbeitsdokumentation LOUD-Modding

Dieser Ordner ist die **Wissensbasis für die Zusammenarbeit mit Claude** am LOUD-Modding-Projekt.

**Ort:** `LOUD\usermods\doc.claude\` — seit dem 05.08.2026 innerhalb des Git-Repositorys und
damit mitversioniert. Nicht zu verwechseln mit `LOUD\doc\` (Original-Readmes der
LOUD-Distribution).

---

## Einstieg

**→ [`CLAUDE.md`](CLAUDE.md) ist die Projektanweisung und wird zuerst gelesen.**

---

## Struktur

```
LOUD\usermods\                     ← Git-Repository (Woonerf-1/Supcom-mods)
└── doc.claude\
    ├── CLAUDE.md                 Projektanweisung (Master, Vorrang vor allem)
    ├── README.md                 diese Datei
    │
    ├── 01_ARCHITEKTUR.md         Ordnerlandkarte, VFS-Mounts, Ladekette
    ├── 02_MODSYSTEM.md           mod_info.lua, hook / shadow / schook, Ladereihenfolge
    ├── 03_BLUEPRINTS.md          .bp-Format, Merge, Unit-IDs, Kategorien
    ├── 04_LUA_SIM.md             Simulations-Lua: Klassen, Hook-Punkte, Kartei
    ├── 05_UI_MODS.md             UI-Mods, /lua/ui, ui_only
    ├── 06_WORKFLOW.md            Testzyklus, Logging, Debugging, Fehlerbilder
    ├── 07_KONVENTIONEN.md        Namens-, Code- und Dateikonventionen
    ├── 08_BESTANDSAUFNAHME.md    Inventar der vorhandenen Mods (eingefroren)
    ├── 09_GLOSSAR.md             Begriffe & Abkürzungen
    ├── 10_VORLAGEN.md            Copy-Paste-Gerüste für neue Mods
    ├── 11_DATAPATH.md            LoudDataPath.lua / CommonDataPath.lua — VFS-Aufbau
    ├── 12_NEUSCHNITT.md          Freeze des Bestands, Befunde, Regeln für neue Mods
    ├── 13_GIT.md                 Git-Anbindung — Remote, Regeln, Geltungsbereich
    ├── 14_TOOLS.md               tools\ — Registry-Einträge, Hilfsskripte
    ├── 15_LOG.md                 LOUD.log — Auswertung + Befundregister (R-01…)
    ├── 16_UNITS.md               Einheitenliste — optionaler Generator
    ├── 17_UNITLISTE.md           Einheitenliste — alle Pakete, Mods, Fraktionen
    │
    ├── CHANGELOG.md              chronologisches Änderungsprotokoll
    ├── TODO.md                   offene Punkte, Ideen, Blocker
    │
    ├── referenz\
    │   ├── README.md
    │   ├── LoudDataPath.lua.txt    Verbatim-Kopie (Stand 2026-08-05)
    │   └── CommonDataPath.lua.txt  Verbatim-Kopie (Stand 2026-08-05)
    │
    ├── tools\                    Hilfsmittel — kein Mod
    │   ├── README.md
    │   ├── Get-Units.ps1           erzeugt units\ (Nutzer führt aus)
    │   ├── scd_als_ordner_an.reg   .scd als gepackten Ordner (HKCU, ohne Admin)
    │   ├── scd_als_ordner_aus.reg  Rücknahme
    │   └── scd_als_ordner_an_systemweit.reg   (HKCR, mit Admin)
    │
    ├── units\                    GENERIERT — nicht von Hand bearbeiten
    │   ├── units.csv
    │   ├── units.md
    │   └── units-summary.md
    │
    └── mods\
        ├── _VORLAGE.md           Kopiervorlage für Mod-Dokumentation
        └── <modname>.md          je ein Dokument pro selbst gebautem Mod
```

---

## Schreibzonen — Kurzfassung

| Zone | Pfad | Status |
|---|---|---|
| **Neue** Mods | `LOUD\usermods\` (neue Ordner) | ✅ schreiben |
| Diese Doku | `LOUD\usermods\doc.claude\` | ✅ schreiben (inkl. `tools\`, Ausführen: Nutzer) |
| **Bestehende** Mods | `LOUD\usermods\` (6 Mod-Ordner) | ❄️ eingefroren — gehören uns, werden aber abgelöst |
| Git-Verwaltung | `LOUD\usermods\.git\` | ⛔ tabu — Claude führt kein Git aus |
| Referenzcode | `LOUD\gamedata.entpackt\` | 🔒 nur lesen |
| Spieldaten | `LOUD\gamedata\`, `LOUD\bin\`, `LOUD\doc\`, alles unter `$FA` | 🔒 nur lesen (LOUD-Team) |

Kurz: **alles unter `usermods\` ist schreibbar** — außer `.git\` und den eingefrorenen
Mod-Ordnern. Alles außerhalb ist nur lesbar.

## Aktueller Projektstand

**Alles in `usermods\` gehört uns.** Der vorhandene Bestand ist **eingefroren** und wird
nicht repariert, sondern **abgelöst**: alles wird neu gedacht und in neuen Mods umgesetzt.
Der inhaltliche Zuschnitt steht noch aus.

Befunde und Verfahren: **`12_NEUSCHNITT.md`**.

`usermods\` ist seit dem 05.08.2026 ein **Git-Arbeitsverzeichnis**
(`Woonerf-1/Supcom-mods`, SSH, Branch `main`) → **`13_GIT.md`**.
Das Repo umfasst die Mods — vollständig inkl. Assets — **und diese Dokumentation**.

---

## Faustregel für den Eingriffspunkt

```
Nur Zahlen/Werte ändern?        → Blueprint mit Merge = true      (03_BLUEPRINTS.md)
Verhalten/Logik ändern?         → hook\lua\...                    (02_MODSYSTEM.md, 04_LUA_SIM.md)
Neue Einheit?                   → units\<ID>\ im Mod              (03_BLUEPRINTS.md)
Nur Interface?                  → ui_only = true + hook\lua\ui\   (05_UI_MODS.md)
Datei komplett ersetzen?        → shadow\  ← letztes Mittel, begründen
```

## Wenn etwas mit Pfaden, Mounts oder Sounds nicht stimmt

→ **`11_DATAPATH.md`**. Dort steht, wie `LOUD\bin\LoudDataPath.lua` und
`CommonDataPath.lua` das gesamte Dateisystem des Spiels aufbauen — inklusive der Regeln,
nach denen `usermods\` gemountet wird und warum eigene Sounds stillschweigend verworfen
werden können.

## Nach einer Partie

→ **`15_LOG.md`**. `LOUD\bin\LOUD.log` enthält immer das Log der zuletzt gespielten
Partie — die wichtigste Quelle für „greift mein Hook?" und „warum tut der Mod nichts?".
Wird bei jedem Start überschrieben.

Dort liegt auch das **Befundregister**: jede grundsätzliche Warnung und Fehlermeldung wird
Schritt für Schritt im Code zurückverfolgt, bis die Ursache belegt ist — statt sie nur zu
beschreiben.
