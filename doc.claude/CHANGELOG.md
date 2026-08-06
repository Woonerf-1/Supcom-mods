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

## 2026-08-06 - Skriptlauf deckt uebersehenes Archiv auf; Bestand korrigiert

- **Was:** `Get-Units.ps1` gelaufen (durch den Nutzer); Ergebnis gegen die Handerhebung
  abgeglichen und die Doku korrigiert
- **Wo:** `units\_generiert\` (neu), `units\mods.md`, `units\ueberschreibungen.md`,
  `units\README.md`, `17_UNITLISTE.md`, `TODO.md`
- **Getestet:** ja - Abgleich Skriptausgabe gegen alle Handerhebungen

### Der Fehler

**`loud_misc` wurde in der Handerhebung vollstaendig uebersehen** - 136 Einheiten in
fuenf LOUD-eigenen Mods: `LOUD Integrated Storage` (84),
`ZLOUD Structure Enhancements` (36), `Enhanced Nukes` (8), `Artillery` (4),
`Enhanced Commanders` (4).

In `02_MODSYSTEM.md` Abschnitt 6.5 stand seit dem 05.08., dass `loud_misc.scd` 24
LOUD-eigene Mods enthaelt - bei der Einheitenerhebung wurde dort trotzdem nie
hineingesehen. Dieselbe Sorte Fehler wie zuvor: **einen Vorbehalt dokumentiert, statt
ihn anzuwenden.**

Zwei weitere blinde Flecken der Methode "Ordner unter `units\` auflisten":

- **Blueprints ausserhalb von `units\`** - 17 `PING_*_unit.bp` in
  `brewlan\mods\BrewLAN_RNG\CrateDrop\effects\entities\`; `BrewLAN_Plenae\Logger`
  hat 3 Einheiten statt null.
- **Ordner ohne Blueprint** wurden mitgezaehlt: im Paket `units` sieben
  (`UEL0003` `URB0401` `URB3302` `URB4301` `XAA0002` `XRL0201` `XRL0404`), in
  `civ_units` 17 - darunter die fuenf Strassenobjekte.

### Korrigierte Zahlen

| Angabe | vorher | jetzt |
|---|---:|---:|
| basegame | 432 | **425** |
| mod | 525 | **661** |
| usermod | 218 | 218 |
| Gesamt | 1175 | **1311** |
| verschiedene IDs | 1075 | **1131** |
| mehrfach belegte IDs | 99 | **163** |

### Neue Erkenntnis: zwei Sorten von Mods

| Typ | Beispiele | Ersatzanteil |
|---|---|---|
| Inhaltspakete | `civ_units`, `TotalMayhem`, `BrewLAN_Units`, `BrewLAN_RNG`, `BrewLAN_Plenae` | 0 % |
| Aenderungsmods | `Enhanced Nukes`, `Artillery`, `Enhanced Commanders` | 100 % |
| | `LOUD Integrated Storage` | 67 % |

`LOUD Integrated Storage` ersetzt 56 Blueprints - 40 aus dem Basisspiel, dazu welche aus
BlackOps und `LOUD Unit Additions` - um Lager in Gebaeude einzubauen. Fuer diesen Modtyp
ist Ersetzen die Arbeitsweise, nicht ein Mangel.

**Damit faellt auch eine fruehere Aussage:** die `gamedata`-Pakete kollidieren sehr wohl
untereinander. Alle solchen Faelle gehen von `loud_misc` aus.

**96 der 425 Basiseinheiten werden von mindestens einem Mod ersetzt** - fast jede vierte.
Bei neun IDs konkurrieren drei Fassungen.

### Aufgeraeumt

Die drei Ausgabedateien lagen direkt in `units\`. Nach der eigenen Regel gehoeren
generierte Dateien nach `units\_generiert\` - verschoben, mit `README.md`, die den
Abgleich beider Zaehlweisen festhaelt.

### Offen

Namen aus `units.csv` in `pakete.md`, `usermods.md` und `basegame.md` uebernehmen;
`pakete.md` um die fuenf `loud_misc`-Mods erweitern.

**Es wurden keine Spiel- oder Moddateien veraendert.**

---

## 2026-08-05 - Alle 19 Ablageorte geprueft, Ueberschreibungen vollstaendig ermittelt

- **Was:** `pakete.md` neu erhoben und geschrieben; Ueberschreibungen aus
  Verzeichnislisten statt aus Markdown ermittelt
- **Wo:** `units\pakete.md`, `units\usermods.md`, `units\ueberschreibungen.md`,
  `units\mods.md`, `units\README.md`, `17_UNITLISTE.md`, `TODO.md`
- **Getestet:** ja - jede der 19 Verzeichnislisten gegen die Doku gediffed

### Bestand, jetzt vollstaendig belegt

| Kategorie | Ablageort | Einheiten |
|---|---|---:|
| basegame | `gamedata.entpackt\units\units\` | 432 |
| mod | 13 Pakete in `gamedata.entpackt\` | 525 |
| usermod | 5 Mods in `usermods\` | 218 |
| **Gesamt** | | **1175** |

1075 verschiedene IDs, **99 davon mehrfach belegt**.

### Korrigierte Zahlen

| Angabe | vorher | jetzt |
|---|---:|---:|
| `BlackOpsUnleashed` | 84 | **86** |
| mod-Summe | 523 | **525** |
| Gesamtbestand | 1173 | **1175** |
| mehrfach belegte IDs | 98 (fehlerhaft) | **99** |

### Ueberschreibungen

| Mod | ersetzt basegame | ersetzt mod | Summe |
|---|---:|---:|---:|
| `UEF_trans_men` | 39 | 49 | **88** |
| `NOMADS-try_b4_ur_BI` | 1 | 5 | 6 |
| `commanders` | 4 | 0 | 4 |
| `nomads-4-loud` | 1 | 0 | 1 |
| `test21000` | 1 | 0 | 1 |

**Die 13 gamedata-Pakete kollidieren untereinander nicht.** Alle 99 Faelle entstehen
durch Usermods, 88 davon durch `UEF_trans_men` allein - das sind **91 Prozent** dieses
Mods. Eigenstaendig sind dort nur 9 IDs: `MKT0409` `SAB0104` `SAB1312` `SEB1312`
`SRA4212` `SRB1312` `SRB4313` `SRB5383` `SSB1312`.

Anteilig am staerksten betroffen: `LOUD Unit Additions` (8 von 26, 31 %) und `4DC`
(4 von 15, 27 %). Bei `4DC` besonders heikel - das Paket ist die Kompatibilitaetsschicht
zwischen den anderen.

### Neu entdeckt

- `UABSSG01`, `UEBSSG01`, `URBSSG01`, `XSBSSG01` stammen aus `LOUD Unit Additions`,
  nicht aus `units` - die fruehere Zuordnung war falsch.
- `4DC` kollidiert **nicht** mit basegame, obwohl seine IDs Basisspiel-Praefixe tragen.
  Es sind eigene Einheiten.
- `XEL0307` und `XRS0402` liegen in `BlackOpsUnleashed`, ebenfalls ohne Kollision.

**Damit sind alle Einheitendaten geprueft.** Offen bleiben nur die Namen der mod-Pakete
und von `UEF_trans_men`.

**Es wurden keine Spiel- oder Moddateien veraendert.**

---

## 2026-08-05 - Einheitendateien auf ASCII und einspaltige Tabellen; Fehler in der Ueberschreibungsliste

- **Was:** Formatumstellung von `units\`; dabei ein Datenfehler aufgedeckt
- **Wo:** `units\basegame.md`, `units\mods.md`, `units\ueberschreibungen.md`,
  `units\README.md`, `TODO.md`
- **Getestet:** ja - `basegame.md` gegen das Dateisystem, `UEF_trans_men` gegen seine
  Verzeichnisliste

### Formatregeln (neu in `units\README.md`)

1. Kein Zeichen ausserhalb von ASCII - keine Emoji, keine Pfeile, keine Umlaute.
   Pruefung: `grep -P '[^\x00-\x7F]' datei.md` darf nichts liefern.
2. Tabellen einspaltig, eine Zeile pro Einheit. Zweispaltige Tabellen sind verboten.
3. Ueberschreibungen als eigene Spalte mit Modnamen, nicht als Symbol.
4. Zeilen maschinell erzeugen, nicht abtippen.

`basegame.md` wurde danach komplett neu erzeugt: 432 IDs aus der Verzeichnisliste,
Namen aus `strings_db.lua`, Ueberschreibungen als dritte Spalte. Verifiziert - keine
erfundene ID, keine fehlende, reines ASCII.

### WARNUNG: Ueberschreibungsliste war teilweise falsch

Die 98 mehrfach belegten IDs wurden urspruenglich durch **Parsen der Markdown-Listen**
ermittelt. Das Verfahren erfasst auch IDs, die dort nur im **Fliesstext** vorkommen -
etwa in der Tabelle "Abweichungen von der ID-Systematik". Sie wurden dem Mod zugeordnet,
unter dessen Abschnitt sie zufaellig standen.

Nachgewiesen: `UAM0004`, `UEM0006`, `URM0004`, `XSM0001` waren als von `UEF_trans_men`
ueberschrieben gefuehrt. Der Abgleich gegen die tatsaechliche Verzeichnisliste
(`usermods\UEF_trans_men\units\`, 97 Eintraege) zeigt: sie liegen dort nicht.

**Korrigiert:**

| Angabe | vorher | jetzt |
|---|---:|---:|
| basegame-Blueprints, die ueberschrieben werden | 49 | **45** |
| davon durch `UEF_trans_men` | 43 | **39** |

Die Zahlen fuer Ueberschreibungen von **mod-Paketen** (BrewLAN, blackops, Wyvern, 4DC,
loud_units) stammen aus demselben fehlerhaften Verfahren und sind jetzt ausdruecklich als
**ungeprueft** markiert. Neuermittlung aus Verzeichnislisten steht in `TODO.md` unter
"Dringend".

### Lehre

Dieselbe Ursache wie beim `TNTeleportJammer`-Fehler (`15_LOG.md` Abschnitt 1): **aus der
Dokumentation zurueckparsen ist keine Quelle.** Belastbar ist nur der Abgleich gegen das
Dateisystem.

**Noch offen:** `pakete.md` und `usermods.md` sind weder im neuen Format noch gegen das
Dateisystem geprueft.

**Es wurden keine Spiel- oder Moddateien veraendert.**

---

## 2026-08-05 — Korrektur: Kategorisierung nach Ablageort statt ID-Präfix

- **Was:** Die Trennung basegame/mod/usermod folgt jetzt dem **Ablageort des Blueprints**
- **Wo:** `units\basegame.md`, `units\mods.md`, `units\README.md`, `17_UNITLISTE.md`,
  `README.md`, `TODO.md`
- **Getestet:** entfällt (Umkategorisierung)

### Das Kriterium

| Kategorie | Ablageort | Einheiten |
|---|---|---:|
| `basegame` | `gamedata.entpackt\units\units\` | 432 |
| `mod` | `gamedata.entpackt\<Archiv>\…\units\` | 523 |
| `usermod` | `usermods\<Mod>\units\` | 218 |
| **Gesamt** | | **1173** |

### ⚠️ Was falsch war

Die vorherige Trennung erfolgte nach **Set-Präfix**: `U`/`X` = Basisspiel, alles andere =
Mod. Damit wanderten 13 Einträge mit `B`/`D`/`S`-Präfix aus `units\units\` in die
Mod-Datei, obwohl sie im Basisverzeichnis liegen.

Besonders ärgerlich: **ich hatte den Einwand selbst notiert** („Maßgeblich wäre der
Ablageort, nicht die ID") und trotzdem nach Präfix getrennt. Die ID-Systematik ist eine
**Lesehilfe, kein Ordnungsmerkmal** — das steht jetzt an allen drei Indexstellen.

Gegenbeispiele in beide Richtungen, in `units\README.md` festgehalten:
- `UAB8765`, `XSB8765` tragen Basisspiel-Präfixe, liegen aber in `LOUD Unit Additions`
- `BAA0001`, `DEA0202`, `SEB1401` u. a. tragen Mod-Präfixe, liegen aber in `units\units\`

### Folge

`basegame.md` enthält wieder alle 432 Einträge; die 13 mit abweichenden Präfixen stehen
dort in einem eigenen Abschnitt am Dateiende, mit Bilanztabelle. `mods.md` ist jetzt die
Übersicht der 523 Mod-Einheiten aus `gamedata` und verweist auf `pakete.md`.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — Basisspiel/Mod getrennt, Ablageformat entschieden, Zählung verifiziert

- **Was:** `units\` in Basisspiel und Mods getrennt; Markdown als Ablageformat bestätigt;
  Bestand gegen das Dateisystem geprüft
- **Wo:** `units\basegame.md` (aus `units.md`), `units\mods.md` (neu),
  `units\README.md`, `17_UNITLISTE.md`, `TODO.md`, `README.md`
- **Getestet:** ja — Abgleich Doku gegen `list_directory`

### Trennung

| | Einheiten |
|---|---:|
| Basisspiel — SupCom (`U`) + Forged Alliance (`X`) | 419 |
| Mods — 13 im Paket `units` + 523 Erweiterungspakete + 218 eigene | 754 |
| **Gesamt** | **1173** |

Die 13 Ergänzungen im Paket `units`: `D`-Präfix sind die FA-Einheiten Mercy, Janus,
Mongoose, Corsair, Hoplite, Absolver; `B`-Präfix vier namenlose `*A0309`; `S`-Präfix drei
Gebäude mit `1401` — im Basisspiel die Kennung des Aeon-Paragon, also vermutlich
Gegenstücke für die anderen Fraktionen. **Ungeprüft**, steht in `TODO.md`.

Das Trennkriterium ist das Set-Präfix und damit eine **Konvention, keine Prüfung** —
Zweifelsfälle in beide Richtungen sind in `units\mods.md` benannt.

### ⚠️ Fehlerkette und Korrektur

Beim Herausnehmen der 13 Zeilen aus den zweispaltigen Tabellen fielen drei Einträge heraus
(`UEB2304` Flayer, `URB3102` Noah, `XSB2401` Yolona Oss) und zwei IDs standen doppelt.
Alle korrigiert.

Die anschließende **Verifikation gegen das Dateisystem** ergab:

- **Die Tabellen sind vollständig korrekt** — kein erfundener Eintrag, keiner fehlt.
- **Falsch war die frühere Gesamtzahl „404"** für das Paket `units`. Tatsächlich sind es
  **432 Einheiten** plus den Ordner `Seraphim\`. Aufteilung: 419 + 13 = 432.
- Damit steigt die Gesamtsumme von 1145 auf **1173**.

Zwei Abschnittsüberschriften korrigiert (Aeon Luft 16→15, UEF Gebäude 57→56).

### Ablageformat: Markdown bleibt

Entscheidung des Nutzers. Wichtige Präzisierung: **die Fehler kamen nicht von Markdown,
sondern vom zweispaltigen Layout** `| ID | Name | ID | Name |` — beim Entfernen einer
Zeile verrutscht die zweite Spalte. Daraus zwei neue Regeln in `units\README.md`:

1. **Neue Tabellen einspaltig** (eine Zeile pro Einheit); bestehende bei Gelegenheit
   umstellen.
2. **Pflicht zur Zählprüfung** nach jeder Änderung — Einträge gegen die Kopfangabe,
   Summe gegen das Dateisystem. Verfahren mit `grep`/`comm` dort dokumentiert.

Die erwogene `units.json` entfällt damit.

**Noch ungeprüft:** `pakete.md` und `usermods.md` wurden nicht gegen das Dateisystem
abgeglichen — dort können dieselben Zählfehler stecken. Steht in `TODO.md`.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — Einheitendaten nach `units\` ausgelagert, Indexprinzip verankert

- **Was:** Ordner `doc.claude\units\` angelegt; `17_UNITLISTE.md` zum Index umgebaut;
  Basispaket-Namen aus `strings_db.lua` ergänzt; Überschreibungen als eigenes Dokument
- **Wo:** `doc.claude\units\` (neu, 6 Dateien), `17_UNITLISTE.md` (neu geschrieben),
  `CLAUDE.md` §7, `README.md`, `TODO.md`
- **Getestet:** entfällt (reine Doku)

### Neue Struktur

```
17_UNITLISTE.md          Index — Bestand, ID-Systematik, Verweise
└── units\
    ├── README.md            Ordner-Index, Namenskonvention, Regeln
    ├── units.md             Basispaket, 404 Einheiten mit Namen
    ├── pakete.md            alle Erweiterungspakete, 523 Einheiten
    ├── usermods.md          eigene Mods, 218 Einheiten
    ├── ueberschreibungen.md 98 mehrfach belegte IDs
    └── _VORLAGE.md          Vorlage für <UNITID>.md
```

**Prinzip „Index oben, Details unten"** in `CLAUDE.md` §7 als Arbeitsregel verankert:
große Datenmengen in Unterordner mit eigener `README.md`, die Ebene darüber verlinkt nur.
Keine Daten doppelt führen.

### Namen des Basispakets

Aus
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loc_US\loc\US\strings_db.lua`
(514 Unit-Schlüssel) konnten **385 der 404** Einheiten benannt werden. Die Datei führt
teils nur `_desc`/`_help` statt `_name` — das erklärt, warum die `commanders`-Blueprints
kein `UnitName`-Feld brauchen.

### Überschreibungen ermittelt

Abgleich aller ID-Listen: **98 IDs kommen in mehr als einem Paket vor.** Alle
überschreibenden Mods liegen in `usermods\`; die Paket-Mods aus `gamedata` kollidieren
untereinander nicht.

| Mod | überschreibt |
|---|---:|
| `UEF_trans_men` | 86 |
| `NOMADS-try_b4_ur_BI` | 6 |
| `commanders` | 4 |
| `test21000` | 1 |
| `nomads-4-loud` | 1 |

`UEL0001` ist dreifach belegt. Betroffene IDs sind in `units\units.md` und
`units\pakete.md` mit ⚠️ markiert.

Festgehalten in `units\ueberschreibungen.md`: **`Merge = true` schützt nicht** — ein Merge
wirkt gegenüber dem Original, nicht gegenüber einem später angewandten Vollersatz.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — Einheitenliste erhoben (`17_UNITLISTE.md`)

- **Was:** Vollständige Liste aller Einheiten über alle Pakete, Mods und Fraktionen
- **Wo:** `doc.claude\17_UNITLISTE.md` (neu); `16_UNITS.md` zurückgestuft,
  `CLAUDE.md`, `README.md`, `TODO.md`
- **Wie:** Auflisten der Blueprint-Verzeichnisse; Fraktion und Domäne über die
  ID-Systematik abgeleitet
- **Getestet:** entfällt (Bestandsaufnahme)

**1145 Blueprint-Ordner** in 19 Mods. Größte: `units` (404),
`BrewLAN_LOUD` (149), `civ_units` (117), `nomads-4-loud` (107), `UEF_trans_men` (97),
`BlackOpsUnleashed` (84), `TotalMayhem` (62).

Die Summe zählt Ordner, nicht eindeutige Einheiten — `UEF_trans_men`,
`NOMADS-try_b4_ur_BI`, `commanders` und `test21000` überschreiben überwiegend fremde IDs.

### Beim Erheben gefundene Besonderheiten

- **`brewlan` ist tiefer verschachtelt** als die übrigen Pakete: `BrewLAN_Units` hat keinen
  eigenen `units\`-Ordner, sondern enthält die Untermods `BrewIntel` und `BrewResearch`.
  Ebenso `BrewLAN_Plenae` (`CityGeneration`, `Spomeniki`, `Logger`) und `BrewLAN_RNG`
  (`CrateDrop`).
- **Total Mayhem hat eine eigene ID-Systematik.** Alle IDs beginnen mit `BR`, die Fraktion
  steckt im **3. Zeichen**. Aus `Categories` in vier Stichproben bestimmt:
  `BRM` = Cybran, `BRN` = UEF, `BRO` = Aeon, `BRP` = Seraphim.
- **Nomads ist die fünfte Fraktion** — 2. Zeichen `N`, in der Grundsystematik nicht
  vorgesehen.
- Weitere Abweichungen: `C` = Civilian im 3. Zeichen (`civ_units`, `CityGeneration`),
  `K`-Kennung bei BlackOps, `ZZZ…`/`ZZCRATE`/`SNLMER1` ohne Fraktion, `…M…` in `units`,
  benannte Objekte (`UEF_Bus` u. a.).
- **Belegte Set-Präfixe:** `U` `X` `B` `D` `S` `L` `V` `W` `E` `Z` `C` `M` `N`.
  Frei für eigene Einheiten u. a. `F` `G` `H` `I` `J` `K` `P` `Q` `T` `Y`.

### ⚠️ Vorgehensfehler korrigiert

Auf die Bitte um eine Liste hatte ich zunächst einen PowerShell-Generator gebaut
(`tools\Get-Units.ps1`), statt die Verzeichnisse selbst durchzugehen — eigenmächtig und
nicht das Gefragte. Das Skript bleibt als **optionales** Werkzeug bestehen (es kann
zusätzlich den Anzeigenamen aus den Blueprints ziehen), `16_UNITS.md` ist entsprechend
zurückgestuft. Maßgeblich ist `17_UNITLISTE.md`.

Merksatz für künftige Fälle: **im Zweifel fragen, nicht ersatzweise etwas anderes bauen**
(`CLAUDE.md` §5, Schritt 1).

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — Einheitenliste: Generator angelegt; R-01 korrigiert

- **Was:** Generator für die vollständige Einheitenliste; zwei eigene Fehler korrigiert
- **Wo:** `doc.claude\tools\Get-Units.ps1` (neu), `doc.claude\16_UNITS.md` (neu),
  `15_LOG.md`, `CLAUDE.md`, `README.md`, `tools\README.md`, `TODO.md`
- **Getestet:** Verzeichnisstruktur aller Pakete geprüft; Skript selbst noch nicht gelaufen

### ⚠️ Korrektur 1: R-01 war falsch geklärt

Behauptet war, die Blueprint-IDs `beb4209` u. a. **existierten nicht**. Sie existieren:
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\units\BEB4209\BEB4209_unit.bp
```
Das `b`-Präfix steht für **BlackOps**, nicht BrewLAN.

Die präzise Formulierung lautet: **nicht geladen**, nicht „existiert nicht". Blueprints
eines Mods werden nur eingelesen, wenn der Mod in der Partie aktiv ist —
`BlackOpsUnleashed` ist es in der Regel nicht. R-01 steht wieder auf 🟡.

### ⚠️ Korrektur 2: `search_files` ist unzuverlässig

Ursache des Irrtums. Nachgewiesen:

| Suchwurzel | Muster | Ergebnis |
|---|---|---|
| `…\gamedata.entpackt\blackops` | `*4209*` | keine Treffer |
| `…\gamedata.entpackt\blackops` | `BEB4209_unit.bp` | keine Treffer |
| `…\BlackOpsUnleashed\units\BEB4209` | `BEB4209_unit.bp` | Treffer |

**Ein negatives `search_files`-Ergebnis beweist nichts.** Dokumentiert in `15_LOG.md` §6,
als Falle in `CLAUDE.md` Regel 4 aufgenommen.

### Neu: `tools\Get-Units.ps1`

PowerShell-Skript, das `gamedata.entpackt\` und `usermods\` nach `*_unit.bp` durchsucht und
`units.csv`, `units.md`, `units-summary.md` nach `doc.claude\units\` schreibt.
Spalten: Paket, Mod, UnitID, Fraktion, Tech, Domaene, Name, Datei.

Fraktion/Tech/Domäne werden aus `Categories` gelesen, mit `General.FactionName` bzw.
`General.TechLevel` und der ID-Systematik als Rückfallebenen. Nur lesend, keine Adminrechte.
**Ausführung durch den Nutzer** (`CLAUDE.md` Regel 2).

Erfasste Struktur der Pakete:
```
gamedata.entpackt\<Archiv>\mods\<Mod>\units\<ID>\<ID>_unit.bp
gamedata.entpackt\<Archiv>\units\<ID>\<ID>_unit.bp          (units, civ_units)
usermods\<Mod>\units\<ID>\<ID>_unit.bp
```
Mod-Ordner: `blackops` → BlackOpsUnleashed, BlackopsACUs · `brewlan` → BrewLAN_Units,
BrewLAN_LOUD, BrewLAN_Plenae, BrewLAN_RNG · `TotalMayhem` → TotalMayhem ·
`loud_units` → LOUD Unit Additions · `WyvernBattlePack` → BattlePack ·
`4D-CompatibilityPack` → 4DC.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — Regel: Dateien immer mit vollständigem Pfad

- **Was:** Neue Stilregel — jede Datei außerhalb von `$DOC` wird mit vollständigem
  absolutem Pfad genannt, in Antworten wie in der Dokumentation
- **Wo:** `CLAUDE.md` §6, `07_KONVENTIONEN.md` §7 (neu), `15_LOG.md` (Register umgestellt),
  `TODO.md`
- **Warum:** Angaben wie `BuildingTemplates.lua` oder `lua\lua\AI\aibuildstructures.lua`
  zwingen zum Suchen. Der Pfad soll direkt kopierbar sein.

```
✅ C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\BuildingTemplates.lua  (Z. 77–78)
❌ BuildingTemplates.lua
❌ $SRC\lua\lua\BuildingTemplates.lua
```

Ausnahme: Verweise auf Dokumente innerhalb von `$DOC` — dort reicht der Dateiname.
Die Kurzformen `$FA`/`$LOUD`/`$SRC`/`$MODS`/`$DOC` bleiben für Übersichtstabellen,
sind aber **keine** Pfadangabe für eine konkrete Datei.

Alle Belegstellen im Befundregister (`15_LOG.md` §5) entsprechend umgeschrieben.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — `15_LOG.md` als Befundregister umgebaut, R-01 geklärt

- **Was:** Log wird nicht beschreibend abgelegt, sondern als Register geführt — jede
  grundsätzliche Warnung wird Schritt für Schritt im Code zurückverfolgt
- **Wo:** `doc.claude\15_LOG.md` (umgebaut), `TODO.md`, `CLAUDE.md`, `README.md`
- **Getestet:** R-01 vollständig belegt

### 🟢 R-01 geklärt: 15.041 Warnungen aus einem LOUD-Datenfehler

Rückverfolgung in vier Schritten:

1. Meldung stammt aus `lua\lua\AI\aibuildstructures.lua` Zeile 315, Funktion
   `AIBuildBaseTemplateOrdered()`.
2. Auslöser ist Zeile 249: `DecideWhatToBuild(...)` liefert `nil` → `else`-Zweig.
3. `DecideWhatToBuild` ist eine **Engine-Methode** (`AIBrainMethods.DecideWhatToBuild`,
   vgl. `sim\EngineerManager.lua` Z. 33/467) — kein Lua, nicht einsehbar.
   Also die **Eingabedaten** prüfen.
4. `lua\lua\BuildingTemplates.lua` ordnet `T2/T3TeleportJammer` die Blueprint-IDs
   `beb4209`, `bab4209`, `brb4209`, `bsb4209` zu. **Suche nach `*4209*` über die gesamte
   `gamedata.entpackt`: kein Treffer.** Die Einheiten existieren nicht.

→ Datenfehler in LOUD (`b`-Präfix deutet auf BrewLAN), kein Modfehler. Die KI versucht in
jedem Durchlauf einen Bau, der nie gelingen kann.

### ⚠️ Eigener Methodenfehler korrigiert

Im ersten Durchgang wurden beim Gruppieren alle Ziffern normalisiert
(`sed 's/[0-9]\+/N/g'`). Dadurch wurde aus `T3TeleportJammer` ein `TNTeleportJammer` —
und aus `T2Bomber` ein `TNBomber`. Die Tech-Stufe ist bei SupCom nie Rauschen; der
vorherige Eintrag war insoweit falsch. Richtig ist `grep -o` auf den interessanten
Teilstring. In `15_LOG.md` §1 als Fallstrick dokumentiert.

### Register angelegt

🟢 R-01, R-07 (lose Dateien in `usermods\`), R-08 (`ModBlueprints`-Hookpfad)
🔴 R-02 leere Aeon-Platoon-Templates · R-03 `RuleInit.lua` · R-04 Lobby `BadMap` ·
R-05 `is trying to cheat!` · R-06 `GetResource: Invalid name ""`

Die §4.4-Tabelle mit einmaligen Beobachtungen aus der Partie ist entfallen — solche
Details gehören nicht in die Doku, nur zurückverfolgte Grundsätzlichkeiten.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — `LOUD.log` ausgewertet, `15_LOG.md` angelegt

- **Was:** Das Partie-Log als feste Analysequelle dokumentiert und erstmals durchgesehen
- **Wo:** `doc.claude\15_LOG.md` (neu); Korrekturen in `02_MODSYSTEM.md`,
  `03_BLUEPRINTS.md`, `06_WORKFLOW.md`, `08_BESTANDSAUFNAHME.md`, `10_VORLAGEN.md`,
  `CLAUDE.md`, `README.md`, `TODO.md`
- **Getestet:** Referenzlauf vom 05.08.2026, 22:11 — 23.392 Zeilen, 2,1 MB

### ✅ Offene Frage geklärt: `ModBlueprints`-Hookpfad

```
info: Hooked /lua/system/Blueprints.lua with /mods/enhanced resources/hook/lua/system/Blueprints.lua
```

Der Pfad lautet **`hook\lua\system\Blueprints.lua`** — normales Hook-Muster. Der
abweichende Kopfkommentar in `Blueprints.lua` ist irreführend. Zusätzlich bestätigt durch
die Ordnerstruktur von `gamedata.entpackt\loud_misc\mods\Enhanced Resources\`.
Nachgetragen in `03_BLUEPRINTS.md` §5 und `10_VORLAGEN.md` §3.

### Neu entdeckt: LOUD bringt 24 eigene Mods mit

`loud_misc.scd\mods\` wird über den Wurzel-Mount ebenfalls nach `/mods/` gemountet.
Darunter `Enhanced Resources`, `BrewLAN_Gameplay`, `SupremeEconomy`, `LOUD Debug Tools`,
`CommonModTools` und 19 weitere. Sie erscheinen im Mod-Manager neben unseren, hooken teils
dieselben Dateien und werden bei jedem LOUD-Update ersetzt.
Neuer Abschnitt `02_MODSYSTEM.md` §6.5.

### Neu: lose Dateien in `usermods\` erzeugen Warnungen

`README.md` und `test.txt` werden von `mount_mods()` wie Archive behandelt und schlagen
fehl — je zwei Warnungen pro Spielstart. `.git\` wird als `/mods/.git/` gemountet
(ohne Warnung, da Ordner). Siehe `15_LOG.md` §4.2.

### Warnungsaufkommen

15.041 der 15.136 Warnungen (64 % aller Logzeilen) stammen aus **einer** LOUD-KI-Schleife:
`Eng N failed DecideWhatToBuild - "TNTeleportJammer" platoon nil`, verteilt auf fünf
KI-Spieler. Kein Modfehler, aber bei der Fehlersuche zwingend zu filtern.
`06_WORKFLOW.md` §2 entsprechend ergänzt.

### ⚠️ Zwei eigene Befunde korrigiert

- **`commanders`-Icon:** Der Pfad `/mods/nomads-4-loud/icons/nomads.bmp` ist **gültig** —
  die Datei existiert. Früher als „Fremdreferenz/Fehler" notiert; tatsächlich eine
  undeklarierte Abhängigkeit (fehlendes `requires`).
- **`AcidPools`-Icon:** `BrewLAN_Gameplay` **existiert** (LOUD-eigener Mod), enthält aber
  keinen Unterordner `AcidPools`. Der Pfad läuft ins Leere — Befund bleibt, Begründung
  war falsch.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — `doc.claude\tools\` angelegt

- **Was:** Ordner für Hilfsmittel; Registry-Einträge, um `.scd` im Explorer als gepackten
  Ordner anzuzeigen
- **Wo:** `usermods\doc.claude\tools\` (neu), `doc.claude\14_TOOLS.md` (neu)
- **Wie:** neu; Verweise ergänzt in `CLAUDE.md`, `README.md`, `01_ARCHITEKTUR.md`,
  `08_BESTANDSAUFNAHME.md`, `13_GIT.md`, `TODO.md`
- **Getestet:** Dateiformat von `.sca` empirisch geprüft (siehe unten)

Angelegte Dateien:
- `tools\README.md` — Kurzübersicht
- `tools\scd_als_ordner_an.reg` — `HKCU\Software\Classes\.scd`, **ohne Adminrechte**
- `tools\scd_als_ordner_aus.reg` — Rücknahme
- `tools\scd_als_ordner_an_systemweit.reg` — `HKEY_CLASSES_ROOT`, mit Adminrechten

Zunächst als `usermods\tools\` angelegt, auf Wunsch nach `usermods\doc.claude\tools\`
verschoben.

**Abweichung von der Vorlage:** Der eingereichte Registry-Eintrag enthielt zusätzlich
`[HKEY_CLASSES_ROOT\.sca]` mit `CompressedFolder`. Das ist nicht korrekt — `.sca` sind
Animationen, keine Archive. Geprüft an
`gamedata.entpackt\units\units\UEL0001\UEL0001_A001.sca`:
Magic Bytes `41 4E 49 4D` („ANIM“) statt `50 4B 03 04` („PK“); `unzip` meldet
„End-of-central-directory signature not found“. Der Eintrag würde bewirken, dass ein
Doppelklick auf eine `.sca` den ZIP-Handler öffnet und fehlschlägt. Weggelassen,
Begründung in `14_TOOLS.md` §1.

Zusätzlich gewählt: **HKCU statt HKCR** als Standardvariante — wirkt für den angemeldeten
Benutzer, braucht keine erhöhten Rechte, sauber zurücknehmbar. Die systemweite Variante
liegt daneben, falls gewünscht.

Hinweis in `01_ARCHITEKTUR.md` §4 präzisiert: `mount_mods()` mountet nur die **direkten**
Unterordner von `usermods\`. `doc.claude\` wird als `/mods/doc.claude/` gemountet, die
tiefer liegenden `tools\` und `referenz\` bekommen **keinen** eigenen Mountpunkt.
Damit ist die Lage unterhalb von `doc.claude\` auch aus VFS-Sicht die sauberere Wahl.

**Es wurden keine Spiel- oder Moddateien verändert.**

---

## 2026-08-05 — Doku nach `usermods\doc.claude\` umgezogen

- **Was:** Die Arbeitsdokumentation liegt jetzt im Git-Repository
- **Wo:** von `LOUD\doc.claude\` nach `LOUD\usermods\doc.claude\`
- **Wie:** Dateien vom Nutzer kopiert, Referenzen von Claude angepasst, alter Ordner
  anschließend vom Nutzer gelöscht
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

✅ **Alter Ordner `LOUD\doc.claude\` gelöscht** (geprüft). Es gibt nur noch einen Stand,
unter `LOUD\usermods\doc.claude\`.

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
