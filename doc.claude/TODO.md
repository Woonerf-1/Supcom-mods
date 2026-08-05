# TODO

Arbeitsliste. Wird zu Sessionbeginn gelesen und zu Sessionende gepflegt.

---

## Nach jedem LOUD-Update — Checkliste für den Nutzer

`LOUD\gamedata\`, `LOUD\bin\`, `LOUD\doc\`, `LOUD\maps\`, `LOUD\sounds\` werden vom
LOUD-Team gepflegt und beim Update ersetzt. `usermods\` und `doc.claude\` bleiben erhalten.

- [ ] **`gamedata.entpackt\` neu erzeugen** — sonst arbeiten wir gegen veralteten
      Referenzcode. Prüfverfahren: `01_ARCHITEKTUR.md` §2.
- [ ] **`nomads-4-loud\CopyLoudDataPath.bat` ausführen**, falls Nomads gespielt werden soll.
      Ohne das fehlen die Nomads-Einheiten kommentarlos. → `11_DATAPATH.md` §4.
- [ ] **Referenzkopien in `doc.claude\referenz\` erneuern.**
- [ ] **Eigene Hooks gegen die neuen Originale prüfen** — hat sich eine gehookte Funktion
      geändert? Besonders bei `shadow`-Dateien zwingend.
- [ ] Datum des Updates in `CHANGELOG.md` vermerken.

---

## Dringend

_Nichts offen._

---

## Als Nächstes

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

## Einheitenliste ergänzen (Pfadfinderregel)

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
- [ ] `TotalMayhem` — 62 Einheiten, Fraktionen aus vier Stichproben belegt, Namen offen
- [ ] `blackops`, `brewlan`, `WyvernBattlePack`, `4DC`, `loud_units`, `units`, `civ_units`
      — zuerst nach `loc`-Ordnern in den Paketen sehen

---

## Ideen (unsortiert)

<!-- Hier Einfälle sammeln, bevor sie in „Als Nächstes" wandern. -->

---

## Erledigt

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
