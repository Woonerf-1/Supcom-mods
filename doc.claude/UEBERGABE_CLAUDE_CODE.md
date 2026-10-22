# Uebergabe an Claude Code

Stand: 2026-10-13. Verfasst aus der claude.ai-Projektarbeit fuer die erste
Claude-Code-Sitzung. Arbeitsverzeichnis von Claude Code ist `$FA`:

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance
```

Alle Pfade in dieser Datei sind **relativ zu `$FA`**.

---

## 0. Zuerst lesen, in dieser Reihenfolge

1. `LOUD\usermods\doc.claude\CLAUDE.md` - Master-Projektanweisung. Gilt weiter,
   mit den Abweichungen aus Abschnitt 2 dieser Datei.
2. `LOUD\usermods\doc.claude\TODO.md` - offene Punkte. Nicht hier wiederholt.
3. `LOUD\usermods\doc.claude\CHANGELOG.md` - neueste Eintraege oben.
4. Je nach Aufgabe die Datei aus der Tabelle in `CLAUDE.md` Abschnitt 7.

**Im Zweifel fragen statt eigenwillig etwas anderes tun als gefragt.**
Kein Code wird ohne ausdruecklichen Auftrag geaendert.

---

## 1. Projekt

- Spiel: Supreme Commander: Forged Alliance in der Distribution **LOUD**.
- **LOUD ist Codebasis und Massstab.** Teilweise werden Dinge aus **FAF** geholt;
  FAF, BrewLAN und BlackOps sind Referenz, nicht Grundlage.
- Zweck: gepflegte, dokumentierte Modsammlung fuer eine feste private
  Mehrspielergruppe.
- Gruppenregeln: 20 Minuten No-Rush; ein farbenblinder Spieler, daher alle KIs
  weiss; Cheat-Multiplikator 1.3.
- Beteiligte: Paul (Nutzer); Woonerf-1 (Eigentuemer des Git-Repos);
  Colin (Autor von `UEF_trans_men`, `advanced_rebalence`, `BasegameRevamp`).

---

## 2. Was sich gegenueber claude.ai aendert

Die Regeln in `CLAUDE.md` wurden fuer Sitzungen **ohne Shell** geschrieben
(nur Filesystem-MCP). Claude Code hat eine Shell. Daraus folgt:

| Thema | bisher (`CLAUDE.md`) | fuer Claude Code |
|---|---|---|
| Git | "Claude kann kein Git ausfuehren", `.git\` tabu (Abschnitt 3, Regel 6) | Commits, Push, Pull macht Paul in Sourcetree. **Lesende Befehle (`status`, `diff`, `log`, `show`) erlaubt** (Paul, 2026-10-13; in `CLAUDE.md` uebernommen). |
| Inhaltssuche | `search_files` findet nur Dateinamen, case-sensitiv, falsche Negative in tiefen Baeumen | `rg -i` bzw. `Select-String` ueber den ganzen Baum. Ein Negativbefund gilt erst nach vollstaendiger, case-insensitiver Suche. |
| Dreifachvergleich | Kopien nach `/home/claude/orig`, `new`, `utm`, dann `tr -d '\r'` | direkt auf den Windows-Dateien diffen, Zeilenenden normalisieren (`git diff --no-index --ignore-cr-at-eol` oder PowerShell). Keine Kopien noetig. |
| Skripte | Paul fuehrt `tools\*.ps1` aus | Ausfuehren nur, wenn das Skript ausschliesslich in `LOUD\usermods\` schreibt und Paul es freigibt. Regel 2 in `CLAUDE.md` gilt weiter. |
| Pfadangaben | absolut (`CLAUDE.md` Abschnitt 6) | **relativ zu `$FA`** (Vorgabe Paul, 2026-10-13). In `CLAUDE.md` Abschnitt 2 und 6 uebernommen. |

Pfade enthalten Leerzeichen und `(x86)` - in der Shell immer quoten.

---

## 3. Wurzelpfade

| Kuerzel | Pfad relativ zu `$FA` | Zugriff |
|---|---|---|
| `$LOUD` | `LOUD` | nur lesen |
| `$SRC` | `LOUD\gamedata.entpackt` | nur lesen - entpackte LOUD-Referenz |
| `$MODS` | `LOUD\usermods` | **schreiben** - Git-Arbeitsverzeichnis `Woonerf-1/Supcom-mods`, Branch `main` |
| `$DOC` | `LOUD\usermods\doc.claude` | **schreiben** |
| `$LOG` | `LOUD\bin\LOUD.log` | nur lesen, wird je Spielstart ueberschrieben |
| `$REPOS` | `Repos` | nur lesen - seit 2026-10-13 in `CLAUDE.md` Abschnitt 2 |
| | `Repos\LOUD` | Klon von https://github.com/LOUD-Project/Git-LOUD |
| | `Repos\FAF` | Klon von https://github.com/FAForever/fa |

`gamedata.entpackt` direkt unter `$FA` (nicht unter `LOUD`) ist der Basisspiel-Spiegel
aus `Expand-Gamedata.ps1` (`14_TOOLS.md` §2, nachgetragen 2026-10-13). Nicht mit `$SRC`
verwechseln.

`$SRC` und `Repos\LOUD` koennen voneinander abweichen. Massgeblich fuer "was laeuft
im Spiel" ist `$SRC` bzw. `LOUD\gamedata` - Aktualitaet pruefen nach
`01_ARCHITEKTUR.md` Abschnitt 2.

---

## 4. Stand der Mods in `LOUD\usermods\`

| Ordner | Stand | Doku |
|---|---|---|
| `SquareShields` | fertig (Extrakt aus `LOUD Unit Additions`) | `mods\SquareShields.md` |
| `ImprovedHydrocarbonPowerPlants` | fertig, im MP bestaetigt | `mods\ImprovedHydrocarbonPowerPlants.md` |
| `DynamicGameplay` | fertig bis auf offene Entscheidungen (TODO.md, Abschnitt DynamicGameplay) | `mods\DynamicGameplay.md` |
| `T4UnitAdditions` (bis 2026-10-14 `t4add`) | umgesetzt 2026-10-14, Testlauf laeuft | `mods\T4UnitAdditions.md` |
| `CustomAI` | `customai_aeon_air` seit 2026-08-08 eingefroren; regelbasierte KI geplant, nicht gebaut (CHANGELOG oben) | `mods\CustomAI*.md` |
| `CorrosiveOcean` (bis 2026-10-16 `AcidPools`) | ueberarbeitet (ereignisgesteuert), laeuft; seit 2026-10-16 alle Schiffe ausgenommen | `CorrosiveOcean\hook\lua\sim\Unit.md` |
| `PlayTest` | Testwerkzeug; Nebenwirkungen in `mods\PlayTest.md` Abschnitt 7 | `mods\PlayTest.md` |
| `T4MassExtractors` | Vorlage | `mods\T4MassExtractors.md` |
| `BasegameRevamp` | **geklaert 2026-10-14:** war die Bugfix-Vorlage (uid `EFD7502E-...`), von Colin zu eigenem Inhalt umgebaut (BrewLAN-Forschungssystem, Einheit `SRB5383`, Balance an `UAL0301`/`XAB3301`/`XSA0402`). Kein Bugfix-Mod, eingefroren. | - |
| `BasegameBugfixes` | **neu 2026-10-14**, eigene GUID, enthaelt B-04 (Fatboy-Sichtbarkeit) | `mods\BasegameBugfixes.md` |
| `AirForceRebalance` | **neu 2026-10-14**, 25 Luftwaffen-/Flugabwehr-Einheiten (Bayblade am 2026-10-16 entfernt) aus `UEF_trans_men`, im Spiel ungeprueft | `mods\AirForceRebalance.md` |
| `NavyRebalance` | **neu 2026-10-14**, 14 Marine-Einheiten aus `UEF_trans_men`, im Spiel ungeprueft | `mods\NavyRebalance.md` |
| `Nomads` | **neu 2026-10-22**, Neuaufbau der Nomads-Fraktion (109 Einheiten), braucht Custom Factions mit den Hooks aus `uebergabe\CustomFactions\`; im Spiel ungeprueft | `mods\Nomads.md` |
| `nomads-4-loud`, `NOMADS-try_b4_ur_BI` | **seit 2026-10-22 in `doc.claude\_Altlasten\`** (Paul), `mod_info.lua` als `.archiv` | `_Altlasten\README.md` |
| `AdjacencyRebalance` | **neu 2026-10-21**, staerkere Adjacency-Boni der Energie-/Experimental-Speicher, aus `nomads-4-loud` herausgeloest, im Spiel ungeprueft | `mods\AdjacencyRebalance.md` |
| `TacticalMissileUpgrades` | **neu 2026-10-14**, Ausbauketten Serpentine/Volcano/Buzzkill aus `UEF_trans_men`, im Spiel ungeprueft | `mods\TacticalMissileUpgrades.md` |
| `UEF_trans_men` | **seit 2026-10-17 in `doc.claude\_Altlasten\UEF_trans_men\`** (Paul), `mod_info.lua` als `.archiv`; nur noch Vergleichsquelle fuer das Team-PDF | `_Altlasten\README.md` |
| `advanced_rebalence` | **neu, undokumentiert.** Autor Colin; Cybran-Minen, T3-Feldingenieure, Tarnfeldgeneratoren, Seraphim-Restoration-Field. Totfelder `mountpoints`/`hooks`, Icon aus `nomads-4-loud`. | - |
| `commanders`, `nomads-4-loud`, `NOMADS-try_b4_ur_BI` | eingefrorener Bestand (`CLAUDE.md` Regel 5) | `08_BESTANDSAUFNAHME.md` |

`BasegameRevamp` und `advanced_rebalence` fallen unter Regel 5 - **eingefroren**
(Entscheidung Paul, 2026-10-13).

---

## 5. Arbeitsweise

- **Vollstaendige Codepfad-Verfolgung vor jedem Vorschlag.** Fruehere Fehler kamen
  aus unvollstaendigem Tracing und daraus, LOUDs KI-Beschraenkungen fuer Spielregeln
  zu halten statt fuer aenderbare Builder-Bedingungen. Nichts nachbauen, was LOUD
  schon loest.
- **Empirie vor Annahme.** Offene Fragen klaert Paul per Testlauf; danach `$LOG`
  nach `15_LOG.md` auswerten. OneDrive- und Soundmeldungen
  (`SND: XACT3DApply failed`, Soundbank/Wave-Bank) ignorieren.
- **Nicht aus Logausschnitten diagnostizieren** - vollstaendige Spur lesen.
- **Quellen immer benennen:** LOUD, FAF, BrewLAN, BlackOps, Colin, unser. Nie nur
  "das Original".
- **Absicht oder Versehen bei Colins Aenderungen:** Kriterien in
  `18_ABLEITUNG.md` Abschnitt 0.
- **Belegpflicht:** belegen (Pfad + Zeile), als ungeprueft markieren **und** in
  `TODO.md` eintragen, oder weglassen (`CLAUDE.md` Abschnitt 6).
- **Doku parallel zur Implementierung:** `mods\<name>.md`, `CHANGELOG.md`,
  `TODO.md`.
- **Code ohne erklaerende Kommentare.** Erklaerung als `.md` neben den Code, im Code
  hoechstens ein Kurzkommentar mit Verweis. Ausgenommen werkzeuggelesene Konstrukte.
- **Alle Dateien ASCII.**
- **Entfernt wird nicht geloescht,** sondern nach `doc.claude\_Altlasten\<Mod>\` mit
  Begruendung verschoben.
- **Neue Mods:** eigener Ordner, eigene GUID als `uid`, `conflicts` gegen
  Quellpakete. Hook vor Shadow, `Merge = true` vor Vollersatz.
- **Sitzungsende:** geaenderte Dateien auflisten und Commit-Nachricht vorschlagen.

---

## 6. Technische Fallen (bestaetigt)

- `.sca`-Pfade werden **strikt absolut** aufgeloest, kein Rueckfall, Fehlschlag
  stumm. Richtig: `/mods/<mod>/units/<ID>/...` (`07_KONVENTIONEN.md` Abschnitt 4).
- Hooks auf `/lua/sim/Unit.lua`: **Klasse ersetzen** (`Unit = Class(UnitOld) {...}`)
  greift; **Methode ueberschreiben** wurde nie aufgerufen. Ursache offen (TODO.md).
- Strikte Globals im Sim: unbelegte Variablen mit `rawget` pruefen.
- `table.merged` und Listenindizes: Falle, dokumentiert in `03_BLUEPRINTS.md`.
- Lobby-Hooks greifen nicht - Hooks werden erst beim Sitzungsstart angewandt.
- `mod.config` und `__active_mods` sind in der Blueprint-Ladephase verfuegbar.
- LOUD-KI: sieben Builderlisten je Basistemplate; `FactoryUnit` separat hooken;
  Extraktoren umgehen `MaxRange`/`MaxChoices` ueber `StartingMassPointList`;
  `LoopBuild = true` umgeht `GetHighestBuilder` nach der ersten Zuweisung;
  `UpgradeIssuedLimit = 1` serialisiert alle Selbstaufstiege armeeweit;
  `aiBrain.Personality` steuert das Cheatsystem, `ArmySetup[x].AIPersonality` wird
  ueberschrieben - Loesung ueber `OnCreateAI`-Hook und `self.CustomAIKey`.
  Vollstaendig: `mods\CustomAI_Stellschrauben.md`, `mods\CustomAI_Erkenntnisse.md`.
- Panopticon schaltet ab: LOUD-Fehler B-03 (`mods\BasegameBugfixes.md`).
- `nomads-4-loud` nutzt `shadow\` und blockiert Hooks anderer Mods auf dieselben
  Dateien - bei "Hook wirkt nicht" zuerst dort nachsehen.

---

## 7. Offene Abstimmungspunkte mit Paul

Stehen hier, weil sie die Regeln selbst betreffen, nicht eine einzelne Aufgabe:

Alle drei entschieden am 2026-10-13:

1. Lesende Git-Befehle erlaubt? - **Ja** (`status`, `diff`, `log`, `show`).
2. `CLAUDE.md` Abschnitt 2 und 6 auf `$REPOS` und relative Pfade umstellen? - **Ja, erledigt.**
3. Status von `BasegameRevamp` und `advanced_rebalence`. - **Eingefroren** (Regel 5).
