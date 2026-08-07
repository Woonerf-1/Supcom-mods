# TODO

Arbeitsliste. Wird zu Sessionbeginn gelesen und zu Sessionende gepflegt.

---

### Aus der KI-Erweiterung (`mods\CustomAI.md`)

- [x] **Wie wirkt der Lobby-Key auf das Verhalten?** Geklaert 2026-08-06: **gar nicht.**
      `FirstBaseFunction` in `Loud_Main_Standard.lua` (Z. 159-220) entscheidet allein
      nach Kartengroesse, Wasseranteil, Einheitenlimit und Startposition und gibt in
      allen acht Rueckgabepfaden festverdrahtet `'loud'` zurueck.
- [x] **Kann ein Mod eigene AIBaseTemplates laden?** Geklaert 2026-08-06: nicht
      automatisch (`simInit.lua` hat keinen Mod-Zweig), aber ueber expliziten Import mit
      vollem `/mods/...`-Pfad aus einem Hook. Weg A (`shadow` + `DiskFindFiles`) ist
      **nicht belegt**; Nomads nutzt ihn nicht, sondern importiert explizit.
- [ ] **Greift ein Hook auf `simInit.lua`?** Abgeleitet, nicht getestet. Falls nicht:
      Hook auf eine spaeter ladende Datei, etwa `/lua/aibrain.lua`.
- [ ] **Enthaelt `ScenarioInfo.ArmySetup[<Armee>].AIPersonality` innerhalb von
      `FirstBaseFunction` noch den Lobby-Key?** `GetBestBasePlan` laeuft vor dem
      Ueberschreiben in `SetupMainBase` Zeile 47 - aus der Aufrufreihenfolge abgeleitet,
      nicht getestet. **Davon haengt ab, ob eine eigene KI ueberhaupt gezielt greifen
      kann.**
- [ ] **Registrierung testen:** `key` in `lua\AI\CustomAIs_v2\` eintragen und pruefen,
      ob die KI in der Lobby erscheint. Erwartete Logzeile:
      `*AI DEBUG Processing AI Mod <pfad>`.

---

### Aus der KI-Erweiterung (`mods\CustomAI.md`)

**Testlauf 1 (2026-08-06):** Sim-Absturz durch `_G.FOO`-Zugriff - behoben, Regel in
`04_LUA_SIM.md` Abschnitt 2 dokumentiert.
**Testlauf 2 (2026-08-07):** Sim startet. Registrierung, Hook-Weg und Template-Import
belegt. Uebergabemechanismus gefunden.

- [x] **Registrierung ueber den Mod-Zweig** funktioniert - `Processing AI Mod
      "/mods/customai"`, Key in der Lobby waehlbar.
- [x] **Hook auf `simInit.lua` greift** - und laeuft vor dem Hook auf `aibrain.lua`.
- [x] **Eigenes BaseBuilderTemplate laesst sich per Import registrieren.**
- [x] **Wie uebergibt LOUD an eine eigene KI?** Ueber den **Nickname**, nicht den Key.
      `aibrain.lua` `OnCreateAI` (~Z. 950): sobald ein aktiver Mod einen
      `CustomAIs_v2`-Ordner hat, startet LOUD `ExecutePlan` nur noch fuer KIs, deren
      Nickname `AI: LOUD` enthaelt. Sonst tritt LOUD zurueck.
- [ ] **Naechster Testlauf:** Sonde heisst jetzt `AI: LOUD Sonde (Test)`. Erwartet:
      LOUDs Plan laeuft, `CUSTOMAI: FirstBaseFunction ...` erscheint im Log.
      Damit klaert sich, welcher Wert in `AIPersonality` steht.
- [ ] **Eigener Einstiegspunkt fuer eine echte KI.** Wenn LOUD zuruecktritt, muss der
      Mod selbst einen Plan forken - Hook auf `OnCreateAI`. Sonst laufen LOUD-Threads
      auf uninitialisierten Daten weiter:
      `loudutilities.lua(5291): attempt to loop over field 'HiPri' (a nil value)`.
- [ ] **Ziel festlegen:** Was soll die eigene KI anders machen?

---

## Ungeprueftes - Pflichtliste

**Regel (`CLAUDE.md` Abschnitt 6):** Jede Vermutung in der Doku steht hier als Aufgabe.
Eine Vermutung ohne Eintrag hier ist ein Fehler.

### Aus der Einheitenerhebung

- [ ] **Wer gewinnt bei mehrfach belegten IDs?** Beispiel `UEL0001` - `units`,
      `commanders` und `test21000` beanspruchen dieselbe ID.
      **Code gelesen 2026-08-06** (`02_MODSYSTEM.md` Abschnitt 5): `before`/`after`
      steuern die Reihenfolge, die uid-Sortierung ist nur Rueckfall und erzwingt nichts.
      Beide Mods setzen weder `before` noch `after`, also greift die uid-Sortierung -
      **im Spiel aber nicht nachgeprueft**.
- [ ] **Wirkt `before`/`after` tatsaechlich wie gelesen?** Nur aus dem Code abgeleitet.
      Test: zwei kleine Mods, die dasselbe Blueprint-Feld unterschiedlich setzen, mit und
      ohne `after` starten und das Ergebnis im Spiel vergleichen.
- [ ] **Ist die Nicht-Transitivitaet von `before`/`after` praktisch relevant?**
      `ModComp` ist ein Paarvergleich, keine topologische Sortierung. Bei drei Mods in
      einer Kette ist die Reihenfolge nicht garantiert - ungetestet.
- [ ] **Zweck der `M`-Kennungen** `UAM0004` `UEM0006` `URM0004` `XSM0001` - kein
      `UnitName`, keine bekannte Domaenenkennung.
- [ ] **Herkunft der `B`- und `S`-Ergaenzungen im Basispaket** (`BAA0309` u. a.,
      `SEB1401` u. a.). Namen sind bekannt (Illuminate, Apotheosis ...), die Herkunft nicht.
- [ ] **Einteilung "Inhaltspakete vs. Aenderungsmods"** in `units\ueberschreibungen.md`
      ist eine Deutung der Zahlen, keine Aussage der Modautoren.
- [ ] **`XNO...` und `XNY...`** in `nomads-4-loud` - Domaenenkennung ungeklaert.
- [ ] **Ohne Namenseintrag:** `SAB1312` `SRB1312` `ZZZ2220` `ZZZ2402` `ZZZ5301`.

### Aus dem Log

- [ ] R-02 bis R-06 in `15_LOG.md` - offene Befunde, naechster Schritt jeweils notiert.

### Aus der Modsystem-Doku

- [ ] **`/schook` gegen mod-eigenes `hook\`** - Reihenfolge der Ausfuehrung.
- [ ] **`CustomUnits\LOUD_Buildings.lua`** - Mechanismus nie gelesen.

### Verifikation der Doku selbst

- [x] **Sechs Paketdateien gegengeprueft** (2026-08-06). Ergebnis: vier Fehler gefunden
      und behoben - zwei Kopfzahlen in `blackops.md`, zwei Fraktionszahlen und 62 nicht
      auffindbare IDs in `civ_units.md`. Verfahren jetzt in `units\README.md`,
      Abschnitt "Zaehlung pruefen".
- [x] **Zwischenueberschriften nachgerechnet** - alle acht Paketdateien ohne Abweichung.
- [x] **Veraltete Zahlen in aelteren Dateien geprueft** (2026-08-06). Befund: `08_BESTANDSAUFNAHME.md`,
      `12_NEUSCHNITT.md` und `16_UNITS.md` enthielten **keine** veralteten Gesamtzahlen -
      der TODO-Eintrag war selbst eine ungepruefte Vermutung. Gefunden wurde anderes:
      die uid-Aussage in `08_BESTANDSAUFNAHME.md` (zweimal) und der falsche Ausgabepfad
      in `16_UNITS.md`. Beides behoben.
- [x] **Tote Links geprueft** - keine gefunden. Der Verweis auf `units.md` in
      `16_UNITS.md` meint die **Skriptausgabe**, nicht die frueher so benannte
      Paketdatei; zur Klarstellung ergaenzt.

---

## Nach jedem LOUD-Update - Checkliste

`LOUD\gamedata\`, `LOUD\bin\`, `LOUD\doc\`, `LOUD\maps\`, `LOUD\sounds\` werden vom
LOUD-Team gepflegt und beim Update ersetzt. `usermods\` bleibt erhalten.

- [ ] **`gamedata.entpackt\` neu erzeugen** - sonst arbeiten wir gegen veralteten
      Referenzcode. Pruefverfahren: `01_ARCHITEKTUR.md` Abschnitt 2.
- [ ] **`tools\Get-Units.ps1` neu laufen lassen** - erzeugt `units\_generiert\` neu.
- [ ] **Claude den Abgleich machen lassen:** alte gegen neue `units.csv` diffen,
      geaenderte und neue Einheiten benennen, betroffene Paketdateien nachziehen.
- [ ] **`tools\Compare-Units.ps1` bauen** - vergleicht zwei `units.csv` und gibt
      Hinzugefuegtes, Entferntes und Geaendertes aus. Damit wird der Abgleich nach einem
      Update eine Minute statt einer Sitzung. Voraussetzung: die alte CSV vor dem
      Neulauf sichern.
- [ ] **`nomads-4-loud\CopyLoudDataPath.bat` ausfuehren**, falls Nomads gespielt werden
      soll. Ohne das fehlen die Nomads-Einheiten kommentarlos - `11_DATAPATH.md`
      Abschnitt 4.
- [ ] **Referenzkopien in `doc.claude\referenz\` erneuern.**
- [ ] **Eigene Hooks gegen die neuen Originale pruefen** - hat sich eine gehookte
      Funktion geaendert? Bei `shadow`-Dateien zwingend.
- [ ] Datum des Updates in `CHANGELOG.md` vermerken.

---

## Dringend

_Nichts offen._

---

## Dringend

_Nichts offen._ Die Einheitendaten sind vollstaendig erhoben, benannt und gegen das
Dateisystem geprueft (Stand 2026-08-06).

---

## Als Naechstes

- [ ] **`Get-Units.ps1` ausführen** (durch den Nutzer) → erzeugt die vollständige
      Einheitenliste in `doc.claude\units\`. Aufruf und Details: `16_UNITS.md`.
- [ ] **Warten auf den inhaltlichen Zuschnitt.** Der Nutzer legt fest, was entstehen soll.
      Danach `12_NEUSCHNITT.md` §3 ausfüllen und mit dem ersten neuen Mod nach dem
      Verfahren aus §5 beginnen.
- [ ] Nichts auf Verdacht nachbauen — der Bestand ist Vergleichsstand, keine Vorlage.

---

## Offene Verifikationen

Punkte, die aus dem Quellcode nicht eindeutig hervorgehen und beim ersten praktischen
Einsatz geklärt werden müssen. Ergebnis jeweils in der genannten Datei nachtragen.

- [ ] **`ModBlueprints`-Hookpfad.** ~~`hook\lua\system\` vs. `hook\system\`~~
      → **GEKLÄRT 05.08.2026 aus dem `LOUD.log`:** `hook\lua\system\Blueprints.lua`.
      Beleg: LOUD-eigener Mod `Enhanced Resources`. Nachgetragen in `03_BLUEPRINTS.md` §5,
      `10_VORLAGEN.md` §3, `15_LOG.md` §4.1.
- [ ] **`mountpoints` / `hooks` in `mod_info.lua`.** ~~Undokumentierte LOUD-Erweiterung~~
      → **ERLEDIGT 2026-08-05:** Felder sind wirkungslos, werden von nichts ausgewertet.
      Dokumentiert in `11_DATAPATH.md` §2 und `08_BESTANDSAUFNAHME.md`.
- [ ] **`/schook` vs. mod-eigenes `hook\`.** Praktischer Unterschied und Reihenfolge
      der Ausführung. → `02_MODSYSTEM.md` §3.3.
- [ ] **LOUD `CustomUnits\LOUD_Buildings.lua`.** Mechanismus zum Registrieren neuer
      Bauoptionen bisher nur dem Namen nach bekannt — Datei lesen und dokumentieren.
      → neuer Abschnitt in `03_BLUEPRINTS.md` §6.
- [ ] **Merge-Verhalten bei `Weapon`-Listen** praktisch gegenprüfen (Theorie steht in
      `03_BLUEPRINTS.md` §4, aus `table.merged` abgeleitet).

---

## Bestand — eingefroren, Befunde für den Neubau

Alles in `usermods\` gehört uns, wird aber nicht mehr repariert. Diese Punkte sind Lehren
für die neuen Mods (`12_NEUSCHNITT.md` §2), keine Aufgaben.

- [x] `commanders` und `test21000` ersetzen beide `UEL0001` vollständig → Konflikt,
      im Neuschnitt aufzulösen.
- [x] `test21000`: 8 geänderte Felder, ausgeliefert als 1283-Zeilen-Blueprint + 16
      Asset-Kopien → Musterfall für Merge (`12_NEUSCHNITT.md` §2).
- [x] `EscalatingBuildCosts`: O(n) pro Bauauftrag → im Neuschnitt Zähler cachen.
- [x] Falsche Icon-Pfade in `AcidPools` und `commanders`.
- [x] 5 von 7 uids ohne GUID-Charakter; steuern nebenbei die Ladereihenfolge.
- [x] Kein Mod nutzt `requires`/`conflicts`/`before`/`after`.
- [x] Tote Felder `mountpoints`/`hooks` in `nomads-4-loud` und `commanders`.

Weiterhin **aktiv zu beachten** (kein Neuschnitt-Thema):

- [ ] `nomads-4-loud` nutzt `shadow\` → blockiert Hooks anderer Mods auf dieselben Dateien.
      Bei „mein Hook wirkt nicht" zuerst hier nachsehen.
- [ ] **Nomads-Installation:** `bin\LoudDataPath.lua` ist derzeit die LOUD-Version, nicht
      die Nomads-Variante. Falls Nomads gespielt werden soll, muss der Nutzer
      `CopyLoudDataPath.bat` ausführen. → `11_DATAPATH.md` §4.

---

## Git (`13_GIT.md`)

**Entschieden:** Das Repo umfasst die Mods unter unserer Kontrolle — vollständig inkl.
Assets — **und die Dokumentation** (`usermods\doc.claude\`). Kein Ausschluss von
Modinhalten, kein LFS. Details in `13_GIT.md` §5.

- [ ] `test.txt` entfernen — erzeugt bei **jedem Spielstart zwei Warnungen** im `LOUD.log`
      (`Search path element ... is not a valid .zip file`), siehe `15_LOG.md` §4.2
- [ ] `README.md` im Repo füllen — derzeit nur `"#Supcom-mods"`, sollte auf `doc.claude\`
      verweisen. Erzeugt ebenfalls zwei Warnungen pro Start; als Repo-README aber
      an dieser Stelle sinnvoll — funktional folgenlos.

---

## Befundregister (`15_LOG.md` §5)

Warnungen und Fehler aus dem `LOUD.log`, Schritt für Schritt im Code zurückverfolgt.

- [ ] **R-01** `failed DecideWhatToBuild - "T3TeleportJammer"` (15.041×) → 🟡 **teilweise:**
      `beb4209` existiert in
      `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\units\BEB4209\`,
      der Mod ist aber in der Regel **nicht aktiv** → Blueprint nicht geladen.
      Noch zu bestätigen: Mod-Liste im Referenzlauf; knüpft `BuildingTemplates.lua` den
      Eintrag an eine Bedingung?
- [x] **R-07** Lose Dateien in `usermods\` erzeugen Warnungen → geklärt (`mount_mods`).
- [x] **R-08** `Hooked …` belegt den `ModBlueprints`-Pfad → geklärt.
- [ ] **R-02** `Template "T2Bomber" for "Aeon" is empty` → in `PlatoonTemplates\` und
      `GlobalPlatoonTemplate.lua` suchen
- [ ] **R-03** `Error in file /lua/RuleInit.lua : Unknown exception` → `RuleInit.lua` lesen
- [ ] **R-04** Lobby `Attempt to set attribute 'BadMap' on nil` → Traceback-Zeilen in
      `ui\lobby\lobby.lua` nachschlagen
- [ ] **R-05** `<Spieler> is trying to cheat!` → Meldungstext im Referenzcode suchen.
      **Bis zur Klärung nicht bewerten.**
- [ ] **R-06** `GetResource: Invalid name ""` → `GetResource` im Referenzcode suchen

---

## Zu entscheiden

_Nichts offen._ Ablageformat: **Markdown bleibt** (entschieden 2026-08-05).
Begründung und Konsequenzen in `units\README.md`.

---

## Einheitenliste ergaenzen (Pfadfinderregel)

**Erledigt.** Alle 1311 Einheiten sind erfasst, benannt und verifiziert.
Restliche Kleinigkeiten:

- [ ] Vier Einheiten ohne Namen klaeren: `UAM0004` `UEM0006` `URM0004` `XSM0001`
      (die `M`-Kennungen im Basisspiel)
- [ ] `SAB1312` und `SRB1312` in `UEF_trans_men` ohne Namenseintrag
- [ ] `ZZZ2220` `ZZZ2402` `ZZZ5301` in BrewLAN_LOUD ohne Namen

`17_UNITLISTE.md` wird bei Gelegenheit um Namen und belegte Fraktionen ergänzt.
Stand siehe dort in der Kopftabelle.

**Bewährtes Verfahren, in dieser Reihenfolge probieren:**

1. **Lokalisierungsdatei des Mods suchen** — eine Datei, alle Namen. Bei
   `nomads-4-loud` waren es 128 Einträge in
   `…\usermods\nomads-4-loud\loc\US\nomads_strings_core.lua`.
   Auch die Pakete haben welche, z. B.
   `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loc_US\loc\US\strings_db.lua` (226 KB).
2. **Sonst Blueprint einzeln** — kopieren, dann
   `grep -oE "(UnitName|FactionName)\s*=\s*['\"][^'\"]*['\"]"`.
   Etwa ein Vorgang pro Einheit, also nur für kleine Mods sinnvoll.

- [ ] `usermods\UEF_trans_men` — 97 Blueprints, keine eigene Lokalisierung
      → `units\usermods.md`
- [ ] `TotalMayhem` — 62 Einheiten, Fraktionen aus vier Stichproben belegt, Namen offen
      → `units\pakete.md`
- [ ] `blackops`, `brewlan`, `WyvernBattlePack`, `4DC`, `loud_units`, `civ_units`
      — zuerst nach `loc`-Ordnern in den Paketen sehen → `units\pakete.md`
- [ ] Bei Bedarf `units\pakete.md` aufteilen (`blackops.md`, `brewlan.md` …), wenn sie
      zu groß wird — Index in `units\README.md` mitpflegen
- [x] **Uebrige Pakete gegen das Dateisystem abgleichen** - **erledigt 2026-08-05.**
      Alle 19 Ablageorte geprueft: 432 + 525 + 218 = 1175.
- [x] **`pakete.md` und `usermods.md` auf das neue Format bringen** - erledigt.

## Basisspiel/Mod-Trennung prüfen (`units\mods.md`)

Die Kategorisierung folgt seit 2026-08-05 dem **Ablageort**, nicht der ID.
Offene Fragen betreffen nur noch die Herkunft einzelner Einträge:

- [ ] Herkunft der `B`-Ergänzungen im Paket `units` klären:
      `BAA0001` `BAA0309` `BRA0309` `BSA0309` — kein Namenseintrag, Zweck unklar
- [ ] Herkunft der `S`-Gebäude klären: `SEB1401` `SRB1401` `SSB1401` — `1401` entspricht
      im Basisspiel dem Aeon-Paragon, also vermutlich Gegenstücke für die anderen
      Fraktionen. `S` ist auch BrewLAN-Präfix, die Dateien liegen aber in `units\units\`.
- [ ] Warum tragen `UAB8765`/`XSB8765` (in `LOUD Unit Additions`) Basisspiel-Präfixe?

---

## Ideen (unsortiert)

<!-- Hier Einfälle sammeln, bevor sie in „Als Nächstes" wandern. -->

---

## Erledigt

- [x] **2026-08-06** **Einheitendaten abgeschlossen.** Alle 1311 Einheiten in acht
      Paketdateien erfasst, benannt und gegen das Dateisystem verifiziert:
      `basegame.md` (425), `brewlan.md` (209), `loud_misc.md` (136), `civ_units.md` (100),
      `blackops.md` (86), `kleinpakete.md` (75), `totalmayhem.md` (62),
      `usermods.md` (218). `pakete.md` ist Index.

- [x] **2026-08-06** `basegame.md` (425) und `usermods.md` (218) aus der CSV neu erzeugt:
      Namen fast vollstaendig, Spalte "Ersetzt durch" mit Modnamen. Verifiziert gegen
      die CSV, reines ASCII.

- [x] **2026-08-06** `loud_misc` nachgetragen (`units\loud_misc.md`): 136 Einheiten in
      5 LOUD-eigenen Mods, 104 davon Ueberschreibungen. Kollisionen case-insensitiv neu
      gerechnet: **187** statt 163. Basiseinheiten mit Ersatz: **120 von 425**.
      Neue Regeln 9 und 10 in `units\README.md`.

- [x] **2026-08-06** `Get-Units.ps1` gelaufen: 1311 Einheiten mit Namen, Fraktion und
      Techstufe. Ausgabe nach `units\_generiert\` verschoben, Abgleich gegen die
      Handerhebung dokumentiert (`units\_generiert\README.md`).

- [x] **2026-08-05** Alle 19 Ablageorte gegen das Dateisystem geprueft. Bestand:
      432 basegame + 525 mod + 218 usermod = **1175** Blueprint-Ordner, 1075
      verschiedene IDs, **99 mehrfach belegt**. Korrekturen: BlackOpsUnleashed 86 statt
      84, mod-Summe 525 statt 523, Gesamt 1175 statt 1173.
      `units\pakete.md`, `usermods.md`, `ueberschreibungen.md` neu geschrieben.

- [x] **2026-08-05** `units\basegame.md`, `mods.md`, `ueberschreibungen.md` und
      `units\README.md` auf reines ASCII und einspaltige Tabellen umgestellt;
      Ueberschreibungen als eigene Spalte statt Symbol. Formatregeln in
      `units\README.md`.

- [x] **2026-08-05** Kategorisierung auf den **Ablageort** umgestellt:
      `basegame` (`units\units\`, 432) · `mod` (`gamedata.entpackt\<Archiv>\…\units\`, 523) ·
      `usermod` (`usermods\<Mod>\units\`, 218). Die ID-Systematik ist Lesehilfe, kein
      Ordnungsmerkmal.

- [x] **2026-08-05** Ablageformat entschieden: **Markdown**. Fehlerquelle war nicht das
      Format, sondern zweispaltige Tabellen → künftig einspaltig, plus Pflicht zur
      Zählprüfung (`units\README.md`).
- [x] **2026-08-05** `basegame.md` + `mods.md` gegen das Dateisystem verifiziert:
      419 + 13 = 432, kein Eintrag fehlt oder ist erfunden. Frühere Angabe „404" war
      eine Fehlzählung; Gesamtsumme daher 1173 statt 1145.

- [x] **2026-08-05** `units\` in **Basisspiel** (`basegame.md`, 391) und **Mods**
      (`mods.md` als Übersicht, 754) getrennt.

- [x] **2026-08-05** Einheitendaten nach `units\` ausgelagert, `17_UNITLISTE.md` zum
      Index umgebaut. Prinzip „Index oben, Details unten" in `CLAUDE.md` §7 verankert.
- [x] **2026-08-05** Namen des Basispakets ergänzt (385 von 404 aus `strings_db.lua`);
      98 Überschreibungen ermittelt → `units\ueberschreibungen.md`.

- [x] **2026-08-05** `17_UNITLISTE.md` um Namen ergänzt für `nomads-4-loud` (aus der
      Lokalisierung), `NOMADS-try_b4_ur_BI` und `commanders` (aus den Blueprints).

- [x] **2026-08-05** `16_UNITS.md` + `tools\Get-Units.ps1` angelegt (Generator für die
      vollständige Einheitenliste). Ausführung steht aus.
- [x] **2026-08-05** Werkzeugfalle dokumentiert: `search_files` liefert falsche negative
      Ergebnisse über tiefe Verzeichnisbäume (`15_LOG.md` §6). R-01 entsprechend korrigiert.

- [x] **2026-08-05** `15_LOG.md` als **Befundregister** angelegt (statt beschreibender
      Log-Ablage). R-01 vollständig im Code zurückverfolgt.
      Methodenfehler dokumentiert: Ziffern beim Gruppieren nicht wegnormalisieren.

- [x] **2026-08-05** `doc.claude\tools\` angelegt mit Registry-Einträgen für `.scd` als
      gepackten Ordner (An/Aus, HKCU und systemweit). Doku: `14_TOOLS.md`.
      `.sca` bewusst ausgelassen — kein ZIP (Magic `ANIM`, geprüft).

- [x] **2026-08-05** Doku nach `usermods\doc.claude\` umgezogen und alle Referenzen
      angepasst. Damit im Git-Repository und mitversioniert.
      Alter Ordner `LOUD\doc.claude\` gelöscht — geprüft, es gibt nur noch einen Stand.

- [x] **2026-08-05** Zugangsdaten bereinigt: Remote auf SSH umgestellt, Token aus
      `.git\config` und `.git\sourcetreeconfig.json` entfernt. Keine Zugangsdaten mehr
      unterhalb von `usermods\`.
- [x] **2026-08-05** Geltungsbereich des Repositorys festgelegt: nur die Mods unter
      unserer Kontrolle, diese vollständig inkl. Assets.

- [x] **2026-08-05** Git-Anbindung erfasst: `usermods\` ist Arbeitsverzeichnis von
      `Woonerf-1/Supcom-mods` (Branch `main`). `13_GIT.md` angelegt.
      `EscalatingBuildCosts` ist entfallen → Bestand jetzt 6 Mods.

- [x] **2026-08-05** Bestand eingefroren; `12_NEUSCHNITT.md` als Konzeptpapier angelegt.
      `test21000` gegen das Original gediffed → 8 geänderte Felder von 1283 Zeilen.

- [x] **2026-08-05** `.scd`-Zugriff geklärt: direktes Auspacken technisch möglich, aber bei
      306-MB-Archiven unpraktikabel → `gamedata.entpackt\` bleibt die Referenz.
      Aktualitätsprüfung dokumentiert (`01_ARCHITEKTUR.md` §2). Stand: entpackt am
      05.08.2026, neuestes `.scd` vom 01.08.2026 → aktuell.
- [x] **2026-08-05** Eigentumsmodell in `CLAUDE.md` §3 festgehalten; Nomads-Sonderfall
      korrekt eingeordnet (beabsichtigte Installation statt Fehler).

- [x] **2026-08-05** `LOUD\bin\LoudDataPath.lua` und `CommonDataPath.lua` vollständig
      analysiert → `11_DATAPATH.md`, Verbatim-Kopien in `referenz\`.
      Ergebnis: `mount_mods()`-Semantik geklärt, `mountpoints`/`hooks` als wirkungslos
      entlarvt, Sound-Kollisionsregel dokumentiert, Nomads-Überschreibung als noch nicht
      erfolgt bestätigt.
- [x] **2026-08-05** Doku-Struktur `doc.claude\` angelegt, Umgebung analysiert,
      Bestandsaufnahme der 7 vorhandenen usermods erstellt.
