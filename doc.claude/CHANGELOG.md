## 2026-10-17 (2) - UEF_trans_men nach _Altlasten

- **Was (Paul):** `usermods\UEF_trans_men\` (1952 Dateien, 329 MB) nach
  `doc.claude\_Altlasten\UEF_trans_men\` verschoben. Kein anderer Mod verweist auf
  `/mods/uef_trans_men/` (geprueft).
- **Befund dabei:** `doc.claude\` wird als `/mods/doc.claude/` eingebunden, und `AllMods()`
  sucht rekursiv (`mods.lua` Z. 273, `DiskFindFiles('/mods', '*mod_info.lua')`) - ein
  archiviertes `mod_info.lua` taucht im Mod-Manager auf. Deshalb `mod_info.lua` ->
  `mod_info.lua.archiv` bei `UEF_trans_men` und `test21000`; falsche Aussage in
  `_Altlasten\README.md` korrigiert.
- **Regel fuers ganze Archiv (Paul):** `CLAUDE.md` Regel 9 - archivierte `mod_info.lua` immer
  als `.archiv`. Archiv geprueft: sonst keine. Alle anderen `DiskFindFiles`-Suchen in LOUD
  laufen nur ueber aktive Mods - uebrige Archivdateien sind unschaedlich.
- **Folge:** die 4 offenen Einheiten (Pearl, Yenesel, Wraith, Megaroach) sind im Spiel nicht
  mehr verfuegbar. Team-PDF liest Colins Fassung jetzt aus dem Archiv.
- **Wo:** `_Altlasten\UEF_trans_men\`, `_Altlasten\test21000\mod_info.lua.archiv`,
  `_Altlasten\README.md`, `tools\teamdiff\teamdiff_data.ps1`, `mods\*.md` (Quellpfade),
  `18_ABLEITUNG.md`, `UEBERGABE_CLAUDE_CODE.md`, `12_NEUSCHNITT.md`

---

## 2026-10-17 (1) - NavyRebalance: Yathsou ohne Flak, Preise wie LOUD

- **Was (Paul):** Yathsou (XSS0304, Seraphim-U-Boot-Jaeger) - Flak "Losaare AA Autocannon"
  entfernt, Masse/Bauzeit zurueck auf LOUD (3950 / 8000 statt Colins 2150 / 5000).
  Sonar-Tarnung bleibt aus (Colin).
- **Wie:** Merge `units\XSS0304\XSS0304_unit.bp` ohne `Economy`; neu
  `hook\lua\system\Blueprints.lua` entfernt die Waffe mit Label `AA` und den Faehigkeitstext
  "Anti-Air" (Merge kann keine Listeneintraege loeschen). Waffen werden per Label gesucht
  (`Unit.lua` Z. 1850, 4249, `LOUD\gamedata\lua.scd`) - Reihenfolge egal.
- **Wo:** `NavyRebalance\units\XSS0304\XSS0304_unit.bp`, `NavyRebalance\hook\lua\system\Blueprints.lua`,
  `mods\NavyRebalance.md`, `tools\teamdiff\` (Hook im Datenskript nachgebildet, Text), Team-PDF
- **Getestet:** statisch; im Spiel nein

---

## 2026-10-16 (1) - Corrosive Ocean: Schiffe ausgenommen, aufgeraeumt; Bayblade raus

- **Corrosive Ocean (Paul):** T2-Zerstoerer, die an Land laufen koennen, starben im Wasser.
  Ursache: Salem Class (URS0201, Cybran) hat `MotionType = 'RULEUMT_AmphibiousFloating'`
  (`LOUD\gamedata\units.scd`, `units/URS0201/URS0201_unit.bp` Z. 176) - die
  Bewegungsart-Ausnahme griff nicht, die Kategorie-Ausnahme deckte nur `NAVAL * FACTORY`.
  Jetzt `categories.NAVAL` insgesamt ausgenommen. (Paul nannte Aeon; der einzige
  landgaengige T2-Zerstoerer im Bestand ist der Cybran-Salem - im Spiel pruefen.)
- **Aufgeraeumt:** Ordner `AcidPools` -> `CorrosiveOcean`, Icon `acidpools.png` ->
  `CorrosiveOcean.png`, unbenutztes `Corrosive.dds` nach `_Altlasten\CorrosiveOcean\`,
  `mod_info.lua` mit Kopf, ASCII-Copyright. `uid` unveraendert (Auswahl im Mod-Manager bleibt).
- **AirForceRebalance:** Bayblade (SAA0306) ganz herausgenommen (Paul) - Ordner nach
  `_Altlasten\AirForceRebalance\units\SAA0306\`, zwei Beschreibungen entfernt. Jetzt 25 Einheiten.
- **Wo:** `CorrosiveOcean\` (Umbenennung, `mod_info.lua`, `hook\lua\sim\Unit.lua` + `.md`),
  `AirForceRebalance\` (Hook-Beschreibungen), `doc.claude\_Altlasten\`, `mods\AirForceRebalance.md`,
  `08_BESTANDSAUFNAHME.md`, `13_GIT.md`, `UEBERGABE_CLAUDE_CODE.md`, `units\usermods.md`, `TODO.md`,
  `tools\teamdiff\teamdiff.html`, `team\LOUD-Mods_Aenderungen.pdf`
- **Getestet:** statisch; im Spiel nein

---

## 2026-10-14 (12) - Team-PDF Original | Colin | Aktuell

- **Was:** Menschenlesbares PDF fuer das Team (Paul): je Mod und Einheit drei Spalten,
  Klartext-Feldnamen, Texte zu Script-/Regel-Aenderungen je Mod, offene Transmen-Einheiten.
  32 Seiten, 8 Mods, 79 Einheiten, dazu Basegame Bugfixes.
- **Wie:** `tools\teamdiff\` - Datenskript (Feldvergleich wie `bpmerge.ps1`, Merges
  angewendet, IHPP-Hookwerte nachgetragen), HTML-Vorlage, Druck per Edge headless.
- **Befund dabei:** Cooper (XES0102) - Colins gestrichenes `STRUCTURE` in den
  Zielprioritaeten fehlt in unserem Merge. **Entschieden (Paul): bleibt wie LOUD**, kein
  Eingriff; im PDF als bewusste Abweichung vermerkt.
- **Wo:** neu `doc.claude\team\LOUD-Mods_Aenderungen.pdf`, `doc.claude\tools\teamdiff\`
  (README, build.ps1, teamdiff_data.ps1, teamdiff.html); `TODO.md`, `mods\NavyRebalance.md`

---

## 2026-10-14 (11) - Neuer Mod TacticalMissileUpgrades

- **Was:** Siebter Extrakt aus `UEF_trans_men` (Paul): Colins Ausbauketten Serpentine ->
  Purifier, Volcano -> Purger (Aeon), Buzzkill -> Protector (UEF). 6 Einheiten. Icon: Purifier.
- **Wie:** 3 Basisspiel-Basen als **Merge** (nur `BuildRate`, `BuildableCategory`,
  `UpgradesTo`), 3 Ausbaustufen als Kopie; `conflicts` gegen BlackOps und BattlePack; Auszug
  `MIRVChild01Projectile` + 9 Effekte aus BlackOps; KI-Eintraege Purger/Protector; 3 Beschreibungen.
- **Korrekturen an Colins Fassung:** Volcano `Buildrate` -> `BuildRate` (sonst kein Ausbau);
  Purger-Bauzeit 120 -> 1800 wie LOUD (Paul); Basen nicht mehr in der eigenen
  `BuildableCategory`; Pfade auf den eigenen Mod.
- **Nebenbei:** Rest-Liste `UEF_trans_men` neu abgeglichen (Paul): Massenextraktoren liegen
  in `T4MassExtractors`, 5 Einheiten in `advanced_rebalence`, Gewittersturm und Dehgarwof
  unveraendert. Offen jetzt 4 Einheiten. Team-Diff als PDF am Ende (Paul).
- **Wo:** neu `usermods\TacticalMissileUpgrades\` (48 Dateien), `doc.claude\mods\TacticalMissileUpgrades.md`;
  `TODO.md`, `18_ABLEITUNG.md`, `UEBERGABE_CLAUDE_CODE.md`
- **Getestet:** statisch (alle Pfade loesen auf, ASCII); im Spiel nein

---

## 2026-10-14 (10) - Neuer Mod NavyRebalance

- **Was:** Sechster Extrakt aus `UEF_trans_men` (Paul): Colins Marine-Rebalancing - 4 T1-U-Boote,
  3 Raketen-U-Boote, Yathsou, Iavish, Atlantis, Cooper, Turtle, dazu Patch Class und Barnacle.
  14 Einheiten, Colins Werte. Icon: Atlantis (UES0401). Torrent (XAS0306) nicht aufgenommen -
  bei Colin unveraendert.
- **Wie:** 11 Basisspiel-Einheiten als **Merge** (maschinell aus dem Feldvergleich), 3 als
  Kopie; `conflicts` gegen BattlePack, BrewLAN, 4DC; 5 Beschreibungen.
- **Abweichungen von Colin:** Flak-Treibstoff-Buff `FUELRATIO` bei Iavish, Yathsou, Atlantis
  bleibt (Paul - Colin hatte ihn nur dort entfernt); entfernte `SonarStealth` als
  `SonarStealth = false` (Merge kann nicht loeschen).
- **Korrekturen:** Patch Class importierte ein in LOUD nicht vorhandenes
  `/lua/fieldengineers.lua` - jetzt eigener Auszug `lua\FieldEngineers.lua`; Turtle-
  Texturpfade auf den eigenen Mod, `desktop.ini` und leere `.txt` nicht uebernommen.
- **Wo:** neu `usermods\NavyRebalance\` (36 Dateien), `doc.claude\mods\NavyRebalance.md`;
  `TODO.md` (Rest `UEF_trans_men` jetzt 10 geaenderte Einheiten, abgeglichen gegen alle Mods inkl.
  `T4MassExtractors` und `advanced_rebalence`; Team-Diff als Dreispalten-Tabelle),
  `18_ABLEITUNG.md`, `UEBERGABE_CLAUDE_CODE.md`
- **Getestet:** statisch (41 Pfade loesen auf, ASCII, Kopien gegen Colin); im Spiel nein

---

## 2026-10-14 (9) - Neuer Mod AirForceRebalance

- **Was:** Fuenfter Extrakt aus `UEF_trans_men` (Paul): Colins Luftwaffen-Rebalancing -
  4 Jaeger, 6 Torpedobomber, 4 Gunships, 4 Penetration Fighter, Blade Raven, Wild Weasel,
  Bayblade, Orlok - plus reine Flugabwehr (Sky Boxer, Longbow, Slink, Vindicator) und auf
  Pauls Wunsch die Uyanah. 27 Einheiten, Colins Werte. Icon: Tomcat (SEA0313).
  **Nachtrag:** Sky Boxer wieder herausgenommen (Paul) - Colin gab nur dem UEF-Flakpanzer
  "feuert aus dem Transport", ein reiner UEF-Vorteil. Jetzt 26 Einheiten, 11 Merges; Frage
  offen in `TODO.md`, Merge-Datei in `_Altlasten\AirForceRebalance\`.
  **Nachtrag 2:** `BuildRate = 15` bestaetigt (Paul). Orlok-Bausymbol nachgetragen - es lag
  in `UEF_trans_men\textures\ui\common\icons\units\`, in der ersten Fassung uebersehen.
  Ialosaare `TightTurnMultiplier` geklaert (Paul: dreht nur das Modell), bleibt.
  T2-Flak aus dem Transport: entschieden nein (Paul) - Sky Boxer bleibt LOUD.
- **Wie:** 12 Basisspiel-Einheiten als **Merge** (nur geaenderte Felder, maschinell aus dem
  Feldvergleich erzeugt), 15 als Kopie; `conflicts` gegen BrewLAN, BlackOps, 4DC; eigene
  Auszuege aus 4DC (`4D_weapons`, `4D_projectiles`), KI-Registrierung, 15 Beschreibungen.
- **Korrekturen an Colins Fassung:** Longbow-Script (nicht existierende Methode, fehlender
  `Buff`-Import, tote Animation - Entscheidung Paul: reparieren); Bayblade
  `RemoveEnhancements`-Name, tote Stealth-Zweige; Uyanah zurueck auf BlackOps-Waffenklassen,
  Todesanimation wiederhergestellt; `BuildRate = 15` fuer drei Einheiten mit Ausbau; alle
  Fremdpfade auf den eigenen Mod.
- **Wo:** neu `usermods\AirForceRebalance\` (149 Dateien), `doc.claude\mods\AirForceRebalance.md`;
  `TODO.md`, `18_ABLEITUNG.md`, `UEBERGABE_CLAUDE_CODE.md`
- **Getestet:** statisch (121 Pfade loesen auf, ASCII, Kopien gegen Colin); im Spiel nein

---

## 2026-10-14 (8) - Neuer Mod BasegameBugfixes, B-04 zieht um

- **Was:** B-04-Fix im Spiel bestaetigt (Paul). Er ist ein LOUD-Fehler und kein Teil der
  T4-Erweiterung, deshalb in einen eigenen Mod `BasegameBugfixes` verschoben - Name,
  Reparatur-Icon des Basisspiels, neue GUID `4046F209-C6D2-4881-BACF-E434940CDACA`.
  Pauls urspruenglicher Wunsch war, `BasegameRevamp` umzubenennen; die Analyse zeigte,
  dass dort Colins Forschungssystem, die Einheit `SRB5383` und Balance-Kopien liegen -
  kein Bugfix-Material. Entscheidung Paul: neuer Mod, `BasegameRevamp` bleibt eingefroren.
  Die in der Doku vorgesehene uid `EFD7502E-...` traegt `BasegameRevamp`.
- **Wo:** neu `usermods\BasegameBugfixes\` (`mod_info.lua`, `hook\lua\terranunits.lua`);
  entfernt aus `usermods\T4UnitAdditions\hook\lua\`. Doku: `mods\BasegameBugfixes.md`,
  `mods\T4UnitAdditions.md`, `12_NEUSCHNITT.md`, `UEBERGABE_CLAUDE_CODE.md`, `TODO.md`
- **Wie:** Hook (Klassenersatz), unveraendert
- **Getestet:** Fix ja (noch in T4UnitAdditions); im neuen Mod noch nicht

---

## 2026-10-14 (7) - Aufraeumen: TODO, _ausrangiert, R-05, AcidPools

- **Was:**
  - `TODO.md` neu gegliedert: offene Punkte nach Thema (Mods, Modsystem, Log,
    Einheitenliste, Git, Neuschnitt, Update-Checkliste), Erledigtes gesammelt am Ende.
    Wortlaut unveraendert, maschinell gegen das Original geprueft. Doppelte Abschnitte
    zusammengefuehrt, 11 laengst erledigte oder doppelte Punkte als erledigt markiert (mit
    Vermerk "Aufgeraeumt 2026-10-14").
  - `_ausrangiert\` aufgeloest, Inhalt nach `_Altlasten\CustomAI\` (Paul: `_Altlasten`
    fuehrt).
  - R-05 "trying to cheat": sehr wahrscheinlich LOUDs eigene `ConExecute('path_...')`
    in `gamemain.lua` Z. 161-163, nicht PlayTest (`15_LOG.md`).
  - AcidPools-Schadensformel: bleibt ohne Deckel (Paul).
  - Darkness-Debug: war bereits am 2026-08-16 entfernt; offener Punkt in
    `mods\DynamicGameplay.md` abgehakt.
  - PlayTest: leerer `hook\lua\sim\Unit.lua` nach `_Altlasten\PlayTest\` (Paul).
    Richtigstellung in `mods\PlayTest.md`: die Cheat-Meldung kommt nicht vom Spawn.
  - Entschieden (Paul): DynamicGameplay bleibt wie von Colin (Panopticon, Darkness/Aria);
    Overlord-Energie 55000 bleibt.
- **Wo:** `doc.claude\TODO.md`, `15_LOG.md`, `_Altlasten\README.md`,
  `mods\DynamicGameplay.md`
- **Wie:** Doku
- **Getestet:** entfaellt

---

## 2026-10-14 (6) - T4UnitAdditions: alle T4-Landeinheiten transportierbar

- **Was:** Regel statt Einzelanpassung (Paul): jede anwaehlbare experimentelle
  Landeinheit mit Transportklasse fehlend/10 wird Klasse 4, alle mit Klasse 4 bekommen
  den Transportruf und `CanFireFromTransport = false`. Klasse 5 (Iyadesu u. a.) bleibt.
- **Wo:** neu `usermods\T4UnitAdditions\hook\lua\system\Blueprints.lua`;
  `units\UEL0401\UEL0401_unit.bp` (Merge) nach `_Altlasten\T4UnitAdditions\` - der Fatboy
  ist im Mod wieder reines LOUD.
- **Wie:** Hook auf `ModBlueprints`
- **Getestet:** nein. Details `mods\T4UnitAdditions.md` 11.6

---

## 2026-10-14 (5) - T4UnitAdditions: unsichtbare Fatboys (B-04)

- **Was:** Fatboys blieben nach dem Bau dauerhaft unsichtbar (voll funktionsfaehig, nur
  Schild und Lebensbalken sichtbar). Ursache per vorlaeufiger `T4DEBUG`-Diagnose belegt:
  LOUDs `TMobileFactoryUnit` blendet den Fatboy nur ueber den Baukubus-Thread ein; ist
  der Bau in unter ~6 Ticks fertig, wird der Thread vorher abgeraeumt, und ein Rueckfall
  fehlt. Die vermutete Verbindung zur Acclamator war Zufall (Lager voll waehrend ihres
  Baus). Partikel-Ueberlauf als Ursache widerlegt.
- **Wo:** neu `usermods\T4UnitAdditions\hook\lua\terranunits.lua`; Diagnosezeilen in
  `MKT0409_script.lua` wieder entfernt (Script = UTM bis auf drei Pfade).
  Doku: `mods\BasegameBugfixes.md` B-04, `mods\PlayTest.md` Abschnitt 7.
- **Wie:** Hook, Klassenersatz mit Rueckfall nach `defaultunits.lua` Z. 936-938
- **Getestet:** Diagnose ja; Fix im Spiel noch nicht

---

## 2026-10-14 (4) - T4UnitAdditions: Acclamator-Faehre

- **Was:** `AI.BeaconName = 'UEB5102'` ergaenzt. Im Spiel liess sich kein Faehrpunkt setzen
  (Paul), obwohl `RULEUCC_Ferry` gesetzt war - die Engine braucht die Bake. Wert wie bei
  allen UEF-Transportern in LOUD (`UEA0104_unit.bp` Z. 3).
- **Wo:** `usermods\T4UnitAdditions\units\MKT0409\MKT0409_unit.bp` Z. 3
- **Wie:** Vollkopie, ein Feld
- **Getestet:** nein - erneut pruefen

---

## 2026-10-14 (3) - t4add heisst jetzt T4UnitAdditions

- **Was:** Ordner `usermods\t4add\` -> `usermods\T4UnitAdditions\`, Anzeigename
  "T4 Unit Additions" (Paul). uid unveraendert.
- **Wo:** 36 VFS-Pfade `/mods/t4add/` -> `/mods/t4unitadditions/` in 16 Dateien;
  `lua\CustomUnits\t4add.lua` -> `T4UnitAdditions.lua`; Kopfkommentare.
  Doku: `mods\t4add.md` -> `mods\T4UnitAdditions.md`, `_Altlasten\t4add\` ->
  `_Altlasten\T4UnitAdditions\`, Verweise in `CLAUDE.md`, `18_ABLEITUNG.md`,
  `07_KONVENTIONEN.md`, `TODO.md`, `UEBERGABE_CLAUDE_CODE.md`. Aeltere CHANGELOG-Eintraege
  und die Analyseabschnitte behalten den alten Namen.
- **Wie:** Umbenennung, kein Mechanismus geaendert
- **Getestet:** statisch - alle 168 Pfadliterale loesen auf. Im Spiel: ausstehend
  (`Mounting mod 't4unitadditions'` im Log erwartet).

---

## 2026-10-14 (2) - t4add: umgesetzt

- **Was:** Alle acht Entscheidungen aus `mods\t4add.md` Abschnitt 10 nach Vorschlag:
  - Ballast entfernt: 414 Dateien nach `doc.claude\_Altlasten\t4add\` (397 Emitter,
    2 Bibliotheken, 2 Texturen, 1 Entity, `UEL0401`-Vollkopie, `Thumbs.db`);
    499 -> 87 Dateien
  - Bibliotheken auf die sechs genutzten Klassen gekuerzt (`lua\README.md`)
  - zwei Emitter auf LOUDs byte-identische Texturen umgestellt
  - `SSL0403`: drei kaputte Animationspfade korrigiert, toter `BrewLANLOUDPath`-Aufruf raus
  - `UEL0401`: Merge mit zwei Feldern statt Vollkopie
  - neu: `hook\lua\ui\help\unitdescription.lua` (8 Texte), `lua\CustomUnits\t4add.lua`
  - `mod_info.lua`: GUID `A0B5C51C-A8F7-47E0-BAEF-DE1FFCC63805`, Name korrigiert,
    `conflicts` gegen BrewLAN, 4DC, BattlePack, LOUD Unit Additions, `icon`
  - Colins Werte unveraendert
  - Nachtrag: `mkt0409` aus der KI-Registrierung wieder entfernt (Paul) - die KI baut die
    Acclamator nicht
  - Nachtrag: Rampage `UEL0402` repariert im Spiel nicht (kostet nur Energie) -> `BuildRate
    = 60`, `MaxBuildDistance = 15` ergaenzt (Paul). Ungeprueft
- **Wo:** `usermods\t4add\`, `doc.claude\mods\t4add.md`, `_Altlasten\README.md`,
  `18_ABLEITUNG.md`, `TODO.md`
- **Wie:** Merge (`UEL0401`), Hook (`unitdescription.lua`), sonst Vollkopie wie bisher
- **Warum:** Extrakt ohne Altlasten und ohne Abhaengigkeit von den Quellpaketen
  (`18_ABLEITUNG.md` Abschnitt 0)
- **Getestet:** **nein** - nur statisch (Pfadaufloesung, ASCII, Restverweise). Testlauf
  steht aus, Pruefliste `mods\t4add.md` Abschnitt 12.
- **Werkzeughinweis:** Das Edit-Werkzeug von Claude Code hat beim Schreiben ein
  Latin-1-Zeichen (Copyright-Zeichen) in ein UTF-8-Ersatzzeichen verwandelt. Bei Dateien mit
  Nicht-ASCII-Bytes vorher pruefen.

---

## 2026-10-14 - t4add: Analyse (nichts umgesetzt)

- **Was:** Dreifachvergleich LOUD-Quelle -> `UEF_trans_men` -> `t4add` fuer alle neun
  Einheiten und sieben Bibliotheken, Abhaengigkeiten verfolgt, 346 Pfadverweise gegen das
  VFS geprueft. Kernbefunde:
  - t4add aendert gegenueber UTM nur Pfade (plus ein Nil-Schutz in `SSL0403`); alle
    Wertaenderungen sind Colins aus UTM
  - von 406 Emittern werden 9 gebraucht, von 119 Bibliotheksklassen 6; beide eigenen
    Texturen sind byte-identisch mit LOUDs
  - `UEL0401` ist Basisspiel -> Merge moeglich
  - ohne Quellmods fehlen Beschreibungstexte und KI-Registrierung
  - acht Entscheidungen offen
- **Wo:** `doc.claude\mods\t4add.md` (neu), `18_ABLEITUNG.md` (Verweis, Abschnitt 6),
  `TODO.md`
- **Wie:** Doku
- **Getestet:** entfaellt - Analyse ohne Codeaenderung
- **Nebenbei:** `$FA\gamedata.entpackt` ist der Basisspiel-Spiegel (`14_TOOLS.md` §2) -
  in `CLAUDE.md` §2 und `UEBERGABE_CLAUDE_CODE.md` richtiggestellt; der Eintrag vom
  2026-10-13 hatte ihn als unverifiziert gefuehrt.

---

## 2026-10-13 - Regeln fuer Claude Code (Shell statt Filesystem-MCP)

- **Was:** Die drei offenen Abstimmungspunkte aus `UEBERGABE_CLAUDE_CODE.md` Abschnitt 7
  entschieden und in die Regeln uebernommen:
  1. lesendes Git (`status`, `diff`, `log`, `show`) erlaubt, alles Veraendernde weiter
     nur durch Paul
  2. Pfade relativ zu `$FA`; neuer Wurzelpfad `$REPOS` (`Repos\LOUD`, `Repos\FAF`)
  3. `BasegameRevamp` und `advanced_rebalence` eingefroren (Regel 5)
  Nebenbei: Negativbefund nur nach vollstaendiger case-insensitiver Suche (`rg -i`);
  Skripte, die nur in `$MODS` schreiben, darf Claude nach Freigabe ausfuehren.
- **Wo:** `doc.claude\CLAUDE.md` (Abschnitte 2, 3, 4, 5, 6), `13_GIT.md`, `README.md`,
  `07_KONVENTIONEN.md`, `UEBERGABE_CLAUDE_CODE.md`, `TODO.md`
- **Wie:** Doku
- **Warum:** Claude Code hat eine Shell; die bisherigen Regeln waren fuer Sitzungen ohne
  Shell geschrieben.
- **Getestet:** entfaellt

---

## EINFRIERPUNKT 2026-08-08 - `customai_aeon_air`

Die KI `AI: LOUD Aeon Airforce` gilt ab hier als **eingefroren**. Ihre Regeln sind in
rund fuenfundzwanzig Runden aus Beobachtung entstanden und funktionieren; sie werden
nicht mehr umgebaut, sondern hoechstens noch korrigiert.

**Was eingefroren ist:**

| Datei | Rolle |
|---|---|
| `usermods\CustomAI\lua\AI\AIs\NoRush.lua` | Phasen, Bedingungen, Kopiermechanismus |
| `usermods\CustomAI\lua\AI\AIDefinitions.lua`, Eintrag `customai_aeon_air` | die Regeln selbst |

**Was gemeinsam bleibt und weiterentwickelt wird:**

| Datei | warum |
|---|---|
| `hook\lua\aibrain.lua` | Personality, Startmassepunkte, Aufstiegsgrenze, Debug-Schalter |
| `hook\lua\defaultunits.lua` | Aufstiegsregeln, Referenzprotokoll |
| `hook\lua\sim\EngineerManager.lua` | Wartezeit |
| `lua\AI\AIFactory.lua` | Registrierung und Templatefabrik |

Alle drei Hooks schalten ueber `aiBrain.CustomAIKey` und lesen ihre Werte aus
`AIDefinitions.lua`. Eine zweite KI kann sie also mitbenutzen, ohne dass die erste
beruehrt wird - vorausgesetzt, sie traegt dieselben Feldnamen.

**Empfehlung:** vor dem naechsten Schritt einen Git-Commit setzen. Der Einfrierpunkt ist
damit wiederherstellbar, ohne Dateien zu duplizieren.

---

## Naechster Schritt: regelbasierte KI (geplant, noch nicht gebaut)

Statt einzelne Schrittfolgen zu definieren, sollen Regeln formuliert werden, aus denen
sich die Reihenfolge ergibt. Grundlage ist ein Fund aus der Datenstruktur: LOUDs Bauer
benennen ihre Gebaeudetypen systematisch.

```lua
BuildStructures = {'T1EnergyProduction'}    -- Loud_AI_Engineer_Energy_Builders.lua Z. 88
BuildStructures = {'T2EnergyProduction'}    -- Z. 138
BuildStructures = {'T1Resource'}            -- Loud_AI_Engineer_Mass_Builders.lua Z. 56
BuildStructures = {'T2Resource'}            -- Z. 306
BuildStructures = {'T1AirFactory'}          -- Loud_AI_Engineer_Factory_Builders.lua Z. 169
```

Damit lassen sich Regeln ueber **Gebaeudetypen** formulieren und die betroffenen Bauer
automatisch finden, statt sie namentlich zu listen.

**Drei Prinzipien, die sich generalisieren lassen:**

| Prinzip | Bedeutung | betrifft heute |
|---|---|---|
| Stufenverdraengung | sobald Stufe n+1 existiert oder im Bau ist, baut niemand mehr Stufe n | Kraftwerke, Techniker, Einheiten |
| Aufstieg statt Neubau | von einer Kette darf nur die unterste Stufe gebaut werden | Extraktoren |
| Vollendung vor Fortschritt | ein Aufstieg beginnt erst, wenn die Vorstufe abgeschlossen ist | steht im `defaultunits`-Hook |

**Was das geheilt haette:** drei Fehler dieser Sitzung waren uebersehene Bauer -
`Land Factory Rebuild`, `CDR - T1 Power`, die vier `Mass Extractor T2 - *`. Alle waeren
ueber ihren Gebaeudetyp automatisch erfasst worden.

**Wo es nicht traegt:**

- Einheitenbauer haben kein `BuildStructures`, sie bauen ueber `PlatoonTemplate`
- Zahlen bleiben Erfahrungswerte (4 Extraktoren, 2/4/8 Techniker, 6+4 Kraftwerke)
- Prioritaetsboeden, Assist-Regeln und Zeitphasen bleiben einzeln

---

**Commit-Vorschlag:** `doc: Einfrierpunkt customai_aeon_air`

---

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

## 2026-08-16 (4) - Darkness-Debug ausgewertet und entfernt, AcidPools auf Ereignishaken

- **Was:** Zielauswahl des Darkness vermessen und belegt, Debugcode entfernt;
  `AcidPools` von Dauerabfrage auf `OnLayerChange` umgebaut, Flugzeuge ausgenommen
- **Getestet:** **ja**, beides im Spiel bestaetigt

### Darkness: Zielauswahl vermessen

| Reichweite | gebufft | uebersprungen |
|---:|---:|---:|
| 18 | 2 | 16 |
| 20 | 4 | 16 |
| 24 | 8 | 16 |
| 29 | 13 | 16 |
| 33 | 17 | 16 |

`gebufft + uebersprungen = Reichweite` geht in jeder Zeile auf. Die 16 uebersprungenen
waren durchgaengig **Kommandanten** (`uel0001`, `ual0001`, `uel0301`, `ual0301`,
`url0301`, `xsl0301`) - also je Armee ein ACU und vier SCUs, und das ist der
**PlayTest-Aufbau**, nicht der Mod.

Damit belegt: Emitter werden erzeugt, die Funktion laeuft bis zum Ende durch,
`DarknessEffect` wird auf jede Einheit ausser Kommandanten, Galactic Colossus und Mauern
angewandt.

**Nebenbefund:** die Zielauswahl laeuft ueber `ArmyBrains`, erfasst also **alle Armeen** -
der Darkness trifft auch eigene Einheiten. Im Unterschied zum Panopticon, das ueber
`'Enemy'` filtert. Belegt durch die eigenen ACUs in der Uebersprungenenliste.

**Methodischer Hinweis, jetzt in `mods\PlayTest.md`:** wer mit `PlayTest` misst, hat je
Armee einen ACU und vier SCUs im Bild. Beim Deuten von Einheitenzahlen daran denken - eine
ueberraschende Zahl zuerst gegen den eigenen Testaufbau pruefen, bevor man dem fremden
Code ein Problem unterstellt.

Debugcode vollstaendig entfernt. **`DynamicGameplay` enthaelt jetzt keinen Debugcode
mehr.**

### AcidPools: Ereignishaken statt Dauerabfrage

`usermods\AcidPools\hook\lua\sim\Unit.lua` neu geschrieben. Doku daneben in `Unit.md`.

| | vorher | jetzt |
|---|---|---|
| Ausloeser | Thread je Einheit ab `OnStopBeingBuilt`, **Dauerlauf** | `OnLayerChange`, Thread nur im Wasser |
| Leerlauf an Land | alle 2 Sekunden ein `GetCurrentLayer()` je Einheit | **keiner** |
| Schleifenende | `while self do` - lief endlos, auch nach dem Tod | `while not self.Dead and WASSER[...] do` |
| Kategorienpruefung | bei jedem Threadstart | einmal je Einheit, gemerkt in `self.AcidGeprueft` |
| Flugzeuge | nicht ausgenommen | **`categories.AIR` und `RULEUMT_Air` ausgenommen** |

`OnLayerChange` ist LOUD-eigen (`gamedata\lua\lua\sim\Unit.lua` Z. 461) und wird in
`defaultunits.lua` Z. 1796 und 4194 weitergereicht - ein etablierter Ereignishaken, kein
Eigenbau. `OnStopBeingBuilt` deckt weiterhin den Fall ab, dass eine Einheit direkt im
Wasser entsteht. `self.AcidLaeuft` verhindert doppelte Threads bei schnellem
Ebenenwechsel.

**Im Spiel bestaetigt:** eine Landeinheit hat zwei Inselueberfahrten ueberstanden und ist
auf der dritten gestorben. Das belegt beides - der Zaehler wird beim Verlassen des Wassers
zurueckgesetzt (sonst waere die zweite Insel nicht erreicht worden), und `OnLayerChange`
feuert beim Wiedereintritt (sonst haette es gar keinen Schaden gegeben).

**Damit ist auch die `Class()`-Frage ein Stueck weiter:** ein **Klassenersatz**
(`Unit = Class(UnitOld) { ... }`) auf `/lua/sim/Unit.lua` greift nachweislich fuer
Einheiten, die ueber `defaultunits.lua` erben. Offen bleibt, warum der
**Methodenaustausch** im PlayTest-Versuch nie aufgerufen wurde.

Die Schadensformel bleibt unveraendert - der Schaden waechst quadratisch mit der
Verweildauer, weil er jeden Tick in Hoehe der bisherigen Verweildauer zugefuegt wird.
Nach dem Test **als spielbar bestaetigt**, kein Deckel noetig.

### Vorschlag Commit-Nachricht

```
Darkness-Zielauswahl belegt; AcidPools auf OnLayerChange

- SRB4402: Debugcode entfernt, Messung in SRB4402_script.md festgehalten
  (Zielauswahl ueber ArmyBrains, trifft auch eigene Einheiten)
- AcidPools: Dauerabfrage durch OnLayerChange ersetzt, kein Leerlauf an Land
- AcidPools: Flugzeuge ausgenommen, Kategorienpruefung nur noch einmal je Einheit
- AcidPools/hook/lua/sim/Unit.md neu
- PlayTest.md: Hinweis, dass der Testaufbau Einheitenzahlen praegt

Beides im Spiel bestaetigt.
```

---

## 2026-08-16 (3) - Mod-Bilder, AcidPools bereinigt, test21000 ausgemustert

- **Was:** eigene Mod-Bilder fuer `CustomAI`, `PlayTest` und `AcidPools`; zwei Fehler in
  `AcidPools` behoben; `test21000` nach `_Altlasten`; `BuildableCategory` dokumentiert;
  `14_TOOLS.md` fertiggestellt
- **Getestet:** Mod-Bilder im Mod-Manager bestaetigt, `conflicts` bestaetigt

### Mod-Bilder

| Mod | Datei | Herkunft |
|---|---|---|
| `CustomAI` | `customai.png` | gezeichnet, HAL-Anmutung |
| `PlayTest` | `playtest.png` | gezeichnet, Laborkolben |
| `AcidPools` | `acidpools.png` | **Originalpiktogramm GHS05**, zugeschnitten und freigestellt |

Alle 256x256 mit Alphakanal. **Der Mod-Manager stellt Transparenz korrekt dar** - im Spiel
bestaetigt.

Versuche, das HAL-Bild aus der Vorlage zu rekonstruieren (Radialprofil, Reflex-Ersetzung,
Spiegelung der unteren Haelfte), sind alle gescheitert: die Reflexe liegen direkt ueber der
hellsten Stelle, und keine Ersatzquelle trifft die Helligkeitsverteilung genau genug. Beim
GHS-Piktogramm ging es, weil dort nur zugeschnitten und freigestellt wurde.

### `conflicts` bestaetigt

Der Mod-Manager meldet beim Aktivieren von BrewLAN korrekt:
*"The requested mod requires the following mods be disabled: Dynamic Gameplay"*.
Damit ist der Mechanismus im Spiel belegt, nicht mehr nur aus `mods.lua` abgeleitet.

### AcidPools bereinigt

Fremdmaterial von Balthazar, ein herausgeloestes Teilstueck von `BrewLAN_Gameplay`.
Zwei Fehler:

| | vorher | jetzt |
|---|---|---|
| `icon` | `/mods/BrewLAN_Gameplay/AcidPools/Corrosive.dds` - der Pfad existiert nicht, der Mod wird als `/mods/acidpools/` gemountet | `/mods/acidpools/acidpools.png` |
| Schleife in `hook\lua\sim\Unit.lua` | `while self do` - `self` ist immer wahr, **jede jemals gebaute Landeinheit hinterliess einen Thread**, der bis Spielende weiterlief | `while not self.Dead do` |

**Nicht angefasst:** die Schadensformel (Schaden waechst mit der Verweildauer im Wasser,
nach 60 Sekunden 60 Schaden pro Tick, unbegrenzt steigend) und der Klassenersatz
`Unit = Class(UnitOld) { ... }`.

**Der Klassenersatz ist ein Pruefkandidat fuer die offene `Class()`-Frage:** wenn
Landeinheiten im Wasser tatsaechlich Schaden nehmen, greifen Klassenersetzungen auf `Unit`
sehr wohl - im Unterschied zu meinem gescheiterten PlayTest-Hook, der nur eine *Methode*
ueberschrieben hat. Steht in `TODO.md`.

### test21000 ausgemustert

Colins Cheat-Mod fuer den UEF-ACU, nach `_Altlasten\test21000\` verschoben. Vollstaendig
durch `PlayTest` ersetzt, und zwar sauberer: `test21000` **ersetzte den Blueprint
`UEL0001` vollstaendig** und kollidierte damit mit jedem anderen Mod an derselben Einheit,
etwa `usermods\commanders\`.

Der Mehrwert, der bleibt, steht jetzt in `03_BLUEPRINTS.md` Abschnitt 2a:
**`Economy.BuildableCategory`** - Leerzeichen innerhalb eines Eintrags = UND, mehrere
Eintraege = ODER. Colin hat schlicht die `BUILTBY*`-Bedingung weggelassen, damit faellt
die gesamte Staffelung weg. Das stuetzt nebenbei unsere Lesart von
`BuildableCategory = { }` in `SquareShields` (nichts baubar) - **bewiesen ist sie damit
nicht.**

### 14_TOOLS.md fertiggestellt

Alle drei Skripte, die `.reg`-Dateien, die Repos als Suchwerkzeug und eine
"wann was"-Tabelle. Die beiden wichtigsten Fallstricke stehen drin: **zwei Spiegel** und
was LOUD davon ueberhaupt mountet, sowie die **gross-/kleinschreibungsempfindliche**
Dateisuche.

### Vorschlag Commit-Nachricht

```
Mod-Bilder; AcidPools bereinigt; test21000 ausgemustert; 14_TOOLS fertig

- CustomAI, PlayTest, AcidPools: eigene Mod-Bilder mit Alphakanal
- AcidPools: icon-Pfad korrigiert, Endlosschleife im Unit-Hook behoben
- test21000 nach _Altlasten, BuildableCategory in 03_BLUEPRINTS dokumentiert
- 14_TOOLS.md: Expand-Gamedata, Test-Maps, Repos als Suchwerkzeug
- conflicts im Mod-Manager bestaetigt
```

---

## 2026-08-16 (2) - Panopticon-Abschalten geklaert, DynamicGameplay abgeschlossen

- **Was:** Ursache des Panopticon-Abschaltens gefunden, Tooltip ergaenzt,
  Debug-Instrumentierung wieder entfernt, Skript-Dokumentation nach der neuen
  Kommentarregel angelegt
- **Getestet:** ja - vier Testlaeufe mit `PlayTest`

### Der Befund: B-03

Das Panopticon schaltet sich ab einer bestimmten Ausbaustufe ab und **kommt nicht von
selbst zurueck**. Ursache ist LOUDs `IntelWatchThread` (`gamedata\lua\lua\sim\Unit.lua`):

```lua
if GetEconomyStored( aiBrain, 'ENERGY' ) < bpVal then
```

Verglichen wird der **Vorrat** gegen den **Sekundenverbrauch** - das Einkommen kommt in der
Formel nicht vor. Gemessen bei vollem Konto: `erhalten 1` (100 Prozent der Anforderung
erfuellt), Einkommen ueber eine Million pro Sekunde, und trotzdem AUS, weil 19 895
gespeichert < 65 999 Verbrauch/s.

Die innere Warteschleife prueft dieselbe Bedingung und wird nie falsch - im Test ging das
Geraet erst wieder an, nachdem Paul den Schalter von Hand betaetigt hatte.

Vollstaendig als **B-03** in `mods\BasegameBugfixes.md`, mit Pauls Vorschlag fuer die
richtige Bedingung (Bilanz negativ **und** Puffer zu klein) und dem Hinweis auf die
Einheitenfalle Tick gegen Sekunde.

**Bewusst nicht behoben.** Es waere ein Hook auf `/lua/sim/Unit.lua` - die Datei mit der
offenen `Class()`-Frage - und ein Eingriff in LOUDs Wirtschaftslogik fuer alle Einheiten.
Behelf: genug Energiespeicher, Faustregel **Speicher >= Sekundenverbrauch**.

### Drei widerlegte Erklaerungen unterwegs

| These | widerlegt durch |
|---|---|
| Mauern und Minen treiben den Verbrauch | leere Karte, 0 markierte Objekte |
| Buff-Anwendung schaltet um | Umschaltungen liegen **vor** den Buffs |
| Baubedarf der SCUs | geht auch ohne Bau aus |

Eine daraufhin gebaute Anpassung an `IntelSearch` (Verbrauch nur bei Aenderung neu setzen)
wurde getestet und **wieder zurueckgenommen** - der Beleg steht im Log: die Bedingung
griff, und es toggelte weiter.

### Neu: Beschriftung des Umschalters

`DynamicGameplay\hook\lua\ui\help\tooltips.lua`. Das Blueprint verweist korrekt auf
`helpText = 'toggle_economy_watch'`, den Text liefert aber **BrewLAN** - LOUD hat ihn nicht
uebernommen, Colin auch nicht. LOUDs Standardtext `toggle_weapon` waere zudem falsch
("Toggle between air and ground weaponry").

Der Schalter heisst **Toggle Economy Watch** und schaltet nichts ab - er verkleinert bei
Bedarf die Reichweite auf ein bezahlbares Mass. Logik invertiert: Bit gesetzt =
**keine** Beschraenkung.

### Sichtweiten und Verbrauch dokumentiert

Alle neun Ausbaustufen mit Radar, Omni, Sicht und Energieverbrauch in
`DynamicGameplay\units\SEB3404\SEB3404_Script.md`. Voll ausgebaut: Radar 1115, Omni 394,
Sicht unveraendert 16, **66 000 Energie/s** (x10,25 gegenueber Grundausbau). Kein Sonar.

Dazu die Erklaerung, warum die Anzeige `-29999` statt `-30000` zeigt: LOUDs
Multiplikatoren sind rueckwaerts gerechnet, das Ergebnis verfehlt die glatte Zahl um
Tausendstel, und die Anzeige schneidet ab.

### Skript-Dokumentation nach der neuen Kommentarregel

Keine erklaerenden Kommentare mehr im Code - stattdessen eine `.md` daneben mit Verweis im
Kurzkommentar:

| Code | Doku |
|---|---|
| `DynamicGameplay\units\SEB3404\SEB3404_Script.lua` | `SEB3404_Script.md` |
| `DynamicGameplay\units\SRB4402\SRB4402_script.lua` | `SRB4402_script.md` |
| `DynamicGameplay\hook\lua\ui\help\tooltips.lua` | `tooltips.md` |
| die vier `PlayTest`-Hooks | `PlayTest\hook\lua\hooks.md` |

### Aufgeraeumt

Alle `MM:`-Ausgaben aus `SEB3404_Script.lua` entfernt, `BuffDialog` wieder
auskommentiert. Die Datei ist gegenueber LOUD jetzt **nur noch in Colins einer Zeile**
veraendert. Im Darkness bleibt die Ausgabe, bis dessen Knochen-Korrektur im Log bestaetigt
ist - der Effekt ist im Spiel bereits gesehen.

### Vorschlag Commit-Nachricht

```
Panopticon-Abschalten geklaert (B-03); Tooltip; Skript-Doku

- BasegameBugfixes B-03: IntelWatchThread vergleicht Vorrat gegen
  Sekundenverbrauch, ignoriert das Einkommen, kein Rueckweg
- DynamicGameplay: tooltips.lua aus BrewLAN ergaenzt (Toggle Economy Watch)
- SEB3404_Script.lua: Debug entfernt, versuchte Anpassung zurueckgenommen
- Doku neben den Code: SEB3404_Script.md, SRB4402_script.md, tooltips.md,
  PlayTest/hook/lua/hooks.md
- PlayTest: BuffDialog wieder aus

DynamicGameplay damit abgeschlossen bis auf die vertagte Panopticon-Entscheidung.
```

---

## 2026-08-16 - DynamicGameplay fertig, PlayTest ausgebaut, Fundstellenregister

- **Was:** Durchgang `DynamicGameplay` abgeschlossen, Darkness-Effekt korrigiert,
  `PlayTest` zur Testumgebung ausgebaut, zwei LOUD-Fehler dokumentiert, neues
  Kartenpruefskript
- **Getestet:** teilweise - `PlayTest` im Spiel bestaetigt, Darkness-Korrektur noch nicht

### DynamicGameplay

- umbenannt von `dynamic_gameplay`, GUID `8837F2BC-7C07-4CCF-8F80-34F545858442`,
  `conflicts` gegen **BrewLAN** und **BlackOps**, Mod-Bild gesetzt
- Ballast nach `_Altlasten\DynamicGameplay\`: `VersionCheck.lua`, `AdjacencyBuffs.lua`,
  `Buff.lua`, eine Sicherungskopie, dazu toter `BrewLANPath`-Code in zwei Scripts
- `unitdescription.lua` von zehn auf drei Eintraege gekuerzt; die uebrigen sieben
  betreffen `t4add` und liegen in `_Altlasten`
- Dreifachvergleich **LOUD -> Colin -> unser** fuer alle acht Dateien: der Extrakt
  aendert **kein** Spielverhalten, nur Pfade und Importe

**Darkness-Effekt korrigiert** (`SRB4402_script.lua`): die drei Schockwellenring-Emitter
hingen am Knochen `'XRC2201'`. Die Knochentabelle beider Modelle wurde aus dem SCM-Format
gelesen - jedes hat genau einen Knochen, benannt je Detailstufe unterschiedlich
(`XRC2201` im LOD0, `lod1_XRC2201` im LOD1). Aus groesserer Kameraentfernung existierte
der Knochen also nicht. **Die Zeilen stehen vor dem Buff und vor dem Entfernen der
Panopticon-Markierungen** - ein Abbruch dort haette den Darkness vollstaendig wirkungslos
gemacht. Korrektur auf Knochen `0`, LOD-unabhaengig. Der Fehler stammt aus **BrewLAN** und
wurde von **LOUD** und **Colin** unveraendert uebernommen.

**Panopticon bleibt wie von Colin gestaltet**, Entscheidung vertagt. Die Wirkung ist
dokumentiert: Suchradius 560 -> 212 (voll ausgebaut 1115 -> 394), dazu Mauern und Minen
nicht mehr ausgenommen.

### Zwei Fehlbefunde richtiggestellt

- **`DarknessEffect` ist LOUD-eigen**, `gamedata\lua\lua\sim\buffdefinitions.lua` Z. 217
  (Sicht x0,9, Radar x0,85, Omni x0,75, 20,1 s, stapelnd). Frueher als "nirgends
  definiert" notiert - es war nur nach BrewLANs Namen `DarknessOmniNerf` gesucht worden.
- **Die neun Panopticon-Buffs** sind in derselben Datei definiert, mit gegenueber BrewLAN
  entschaerften Werten. Ursache des Fehlbefunds: `Filesystem:search_files` ist
  **gross-/kleinschreibungsempfindlich**, `buffdefinitions.lua` fiel durch das Muster
  `**/*Buff*`.

Beides steht als Richtigstellung in `mods\DynamicGameplay.md` und
`_Altlasten\README.md` - nicht stillschweigend geloescht.

### PlayTest

Neu: `hook\lua\simInit.lua` (vier SCUs je ACU, alle Fraktionen),
`hook\lua\system\Blueprints.lua` (Produktion x1000, Massespeicher x100),
`hook\lua\aibrain.lua` (Debug-Schalter). Dokumentiert in `mods\PlayTest.md`.

**Eigener Schalter `ScenarioInfo.MMDialog`** mit Praefix `MM:` - unsere Feature-Mods
belegen damit ihr Verhalten. Ausgewertet im Panopticon und im Darkness. Die
Panopticon-Ausgaben sollen klaeren, warum es sich immer wieder abschaltet.

`ScenarioInfo.norushradius` wird ergaenzt, falls die Lobby sie nicht liefert - die
CustomAI-Warnung entfaellt damit.

**Nebenbefund:** die Meldung `Paul is trying to cheat!` stammt von **unserem** PlayTest -
`CreateUnitHPR` laesst die Engine die Einheiten in `Sync.Cheaters` vermerken.

### Neue Fundstellen in BasegameBugfixes

- **B-01** `construction.lua` Z. 1427/1431 reicht `sortedOptions.selection[1]` ungeprueft
  weiter - stuerzt bei schnellen Upgrades ab. LOUD macht es Z. 659 derselben Datei richtig.
- **B-02** `maputil.lua` Z. 92/98: `local mapName = 'Unknown' or scenario.name` - der
  `or`-Zweig greift nie, jede Kartenwarnung nennt "Unknown".

**Beide sollten an das LOUD-Projekt gemeldet werden.** Steht so im Register.

### Neues Werkzeug

`tools\Test-Maps.ps1` - prueft `maps\` und `usermaps\` auf Szenarien mit fehlender
`save`-, `script`- oder `map`-Datei und auf fehlende `armies`-Tabelle. Loest VFS-Pfade in
beiden Wurzeln auf, weil beide Ordner nach `/maps/` gemountet werden. Behelf gegen B-02.

### Vorschlag Commit-Nachricht

```
DynamicGameplay fertig; PlayTest als Testumgebung; Fundstellenregister

- SRB4402: Schockwellen-Emitter auf Knochen 0 (LOD-unabhaengig)
- DynamicGameplay: Ballast nach _Altlasten, unitdescription gekuerzt
- PlayTest: SCU-Spawn, Produktion x1000, Massespeicher x100, MMDialog
- DynamicGameplay: MM-Debugausgaben in Panopticon und Darkness
- BasegameBugfixes: B-01 construction.lua, B-02 maputil.lua dokumentiert
- tools/Test-Maps.ps1 neu
- Richtigstellung: DarknessEffect und Panopticon-Buffs sind LOUD-eigen

Darkness-Korrektur ungetestet.
```

---

## 2026-08-15 (7) - Testlaeufe: wie loest die Engine .sca-Pfade auf?

- **Was:** Drei Testlaeufe zur Aufloesung von Animationspfaden; Regel in
  `07_KONVENTIONEN.md` verankert; `XSBSSG01` korrigiert; `DynamicGameplay` umbenannt
- **Wo:** `doc.claude\07_KONVENTIONEN.md` (neuer Abschnitt 4),
  `mods\SquareShields.md`, `usermods\SquareShields\units\XSBSSG01\XSBSSG01_unit.bp`,
  `usermods\PlayTest\hook\...`
- **Getestet:** **ja** - drei Laeufe, jeweils Laufanimation bzw. Todesanimation beobachtet

### Der Befund

`.sca`-Pfade in Blueprints werden **strikt und absolut** aufgeloest:

| Form | Beispiel | Ergebnis |
|---|---|---|
| erfundenes Verzeichnis | `/units/gibtesnicht/XSL0301_AWalk01.sca` | kaputt |
| richtige Wurzel, ohne Unterordner | `/units/XSL0101_awalk01.sca` | kaputt |
| reiner Dateiname | `XSL0301_AWalk01.sca` | kaputt |

Kein Rueckfall auf das Blueprint-Verzeichnis, keine Dateinamensuche, keine Suche innerhalb
von `/units/`. **Das unterscheidet `.sca` von Mesh-Texturen**, wo ein blosser Dateiname
sehr wohl neben der `.bp` aufloest.

**Fehlschlaege bleiben stumm** - in allen drei Laeufen keine `error:`- oder
`warning:`-Zeile zum fehlenden Pfad. "Nichts im Log" ist bei Animationen kein Beleg fuer
"alles in Ordnung".

### Verfahren

Test ueber einen `ModBlueprints`-Hook in `PlayTest`, der ein einzelnes Feld umbiegt -
kein eigenes Blueprint, keine Assetkopie, keine Instrumentierung. Beurteilt wurde mit
blossem Auge: ein Seraphim-SCU (`XSL0301`) und eine Selen (`XSL0101`) laufen auf Beinen,
ohne Animation gleiten sie starr.

Der Hook protokollierte je Einheit den Ausgangswert und verglich ihn mit dem erwarteten
Original - in allen Laeufen deckungsgleich, kein anderer Mod hatte die Felder angefasst.

### Fehlgeschlagener erster Anlauf - eigener Befund

Zuerst wurde eine Umhuellung von `Unit.PlayAnimationThread` in
`PlayTest\hook\lua\sim\Unit.lua` gebaut. Sie wurde laut Log geladen
(`Hooked /lua/sim/unit.lua with /mods/playtest/hook/lua/sim/unit.lua`) und lief
fehlerfrei - **aber sie wurde nie aufgerufen**, obwohl im selben Lauf zwei Gebaeude mit
`AnimationDeath` gesprengt wurden.

**Vermutung, UNBELEGT:** `Class()` kopiert die Methoden der Elternklasse beim Anlegen der
Unterklasse, statt sie ueber eine Metatabelle nachzuschlagen. Dann traegt `StructureUnit`
aus `/lua/defaultunits.lua` weiterhin die Originalfassung, und eine Umhuellung an `Unit`
greift nur bei Einheiten, die direkt von `Unit` erben - praktisch bei keiner.

Falls das stimmt, waeren Hooks auf `/lua/sim/Unit.lua` fuer die meisten Einheiten
wirkungslos - ein Befund mit Reichweite ueber dieses Projekt hinaus. Steht in `TODO.md`.

### Korrekturen

- **`SquareShields\units\XSBSSG01\XSBSSG01_unit.bp`** Z. 61:
  `/units/XSBSSG01/...` -> `/mods/squareshields/units/XSBSSG01/...`
  Der Originalpfad aus `LOUD Unit Additions` ist damit belegt kaputt; Thanatos hat dort
  seit jeher keine Todesanimation, `XSBSSG02` erbt denselben Fehler.
- **`PlayTest`**: beide Hooks stillgelegt (nur noch Kommentar mit dem Ergebnis). Wichtig -
  ein aktiver Testhook haette SCU und Selen in jedem Spiel die Laufanimation genommen.
- **`t4add\units\SSL0403`**: die drei Pfade `/mods/brewlan/mods/BrewLAN_LOUD/...` sind
  damit ebenfalls belegt kaputt. **Noch nicht korrigiert** - kommt beim Durchgang dieses
  Mods.

### Nebenher: DynamicGameplay

`usermods\dynamic_gameplay\` heisst jetzt `usermods\DynamicGameplay\`
(VFS `/mods/dynamicgameplay/`), uid `8837F2BC-7C07-4CCF-8F80-34F545858442`,
`conflicts` gegen **beide** Quellpakete: BrewLAN for LOUD
(`25D57D85-7D84-27HT-A501-BR3WL4N000079`) und BlackOps Unleashed
(`9e8ea941-c306-4751-b367-a11000000502`). Mod-Bild:
`/textures/ui/common/icons/units/SEB3404_icon.dds`.

**Zwei Pfadverweise mussten mitgezogen werden** - genau der Fall, den der Testbefund
beschreibt:
`units\BSB2402\BSB2402_unit.bp` Z. 40 und `units\SEB3404\SEB3404_Script.lua` Z. 30.

### Vorschlag Commit-Nachricht

```
.sca-Pfade: strikte Aufloesung belegt, Konvention und Korrekturen

- 07_KONVENTIONEN.md Abschnitt 4: drei getestete Pfadformen, alle strikt;
  Fehlschlaege bleiben stumm; Folge fuer das Umbenennen von Mod-Ordnern
- SquareShields/XSBSSG01: Animationspfad korrigiert (belegt kaputt im Original)
- DynamicGameplay: umbenannt, GUID, conflicts gegen BrewLAN und BlackOps,
  zwei Pfadverweise nachgezogen
- PlayTest: Testhooks stillgelegt, Ergebnis im Dateikopf dokumentiert

Offen: greifen Hooks auf /lua/sim/Unit.lua ueberhaupt? Siehe TODO.
```

---

## 2026-08-15 (6) - Alle acht Kraftwerke vollstaendig vereinheitlicht

- **Was:** Vollvergleich aller acht Blueprints untereinander; `RegenRate` einstellbar
  gemacht; `StorageEnergy` der Stufe 2 fest vereinheitlicht
- **Wo:** `usermods\ImprovedHydrocarbonPowerPlants\config.lua`,
  `...\hook\lua\system\Blueprints.lua`; Doku `mods\ImprovedHydrocarbonPowerPlants.md`
- **Wie:** Hook auf `ModBlueprints` plus `config.lua`
- **Getestet:** **nein**

### Vollvergleich: 28 Felder plus Kategorien

Einheitlich sind Gesundheit, Bedrohungswert, Kosten, Bauzeit, Energieproduktion,
`CapCost`, Panzerung, Footprint, Skirt, Strategiesymbole und die Kategorien (15 gemeinsame
bei T2, 12 bei T3, bis auf das Fraktionskuerzel deckungsgleich).

Vier echte Abweichungen:

| Feld | UEF | Aeon | Cybran | Seraphim | Behandlung |
|---|---:|---:|---:|---:|---|
| `RegenRate` T2 | 1 | **kein Eintrag** | 2 | 2 | einstellbar, Vorgabe 2 |
| `RegenRate` T3 | 2 | 2 | 4 | 3 | einstellbar, Vorgabe 4 |
| `Adjacency` | Hydro | *T2/T3PowerGen* | Hydro | Hydro | einstellbar |
| `Economy.StorageEnergy` T2 | 200 | 200 | 200 | **kein Eintrag** | fest auf 200 |

Keine Abweichungen im Sinne eines Fehlers sind `SizeY` und `UniformScale` (verschiedene
Modelle) sowie `BuildIconSortPriority` (Aeon 70 statt 80, ueber beide Stufen konsistent,
verschiebt nur die Position im Baumenue) - **nicht angefasst**.

### Neu: RegenRate einstellbar

| Schluessel | Label | Auswahl | Vorgabe |
|---|---|---|---|
| `RegenRateT2` | Selbstreparatur Stufe 2 | 0 bis 10 | 2 |
| `RegenRateT3` | Selbstreparatur Stufe 3 | 0 bis 10 | 4 |

Damit hat `config.lua` vier Eintraege. Die Werte kommen als Zeichenkette an und werden mit
`tonumber()` gewandelt, mit Rueckfall auf die Vorgabe.

### Neu: StorageEnergy fest vereinheitlicht

`BSB1202` war das einzige der vier T2-Kraftwerke **ohne** `Economy.StorageEnergy`; die
anderen drei tragen 200. Der Hook setzt jetzt alle vier auf 200 - **bewusst nicht
einstellbar**, weil es eine Luecke im Original ist und keine Fraktionseigenheit.

Zum Vergleich die T1-Kraftwerke aus dem Basisspiel: `UEB1102`, `UAB1102`, `URB1102` = 500,
`XSB1102` = 600. Stufe 3 bleibt unberuehrt - dort hat keines der vier einen Eintrag.

### Belegt: Adjacency wirkt nur nach aussen

Anlass war die Frage, was ein Ring aus Energiespeichern um ein T3-Kraftwerk bringt.
Vier Codestellen zeigen dasselbe Muster - gelesen wird immer
`__blueprints[self.BlueprintID].Adjacency`, angewandt per `ApplyBuff(adjacentUnit, v, self)`:

| Datei | Funktion | Zeile |
|---|---|---|
| `defaultunits.lua` | `StructureUnit:OnAdjacentTo` | 983 |
| `defaultunits.lua` | `StructureUnit:OnNotAdjacentTo` | 1013 |
| `Unit.lua` | `OnProductionUnpaused` | 1274 |
| `Unit.lua` | `OnProductionPaused` | 1228 |

Unabhaengig davon bestaetigen es die Kategoriemasken: die Hydrocarbon-Buffs schliessen
`ENERGYPRODUCTION` aus, die Speicher-Buffs zielen genau darauf.

**Folge:** bei einem Speicherring ist unsere Adjacency-Einstellung wirkungslos. Der Nutzen
kommt aus `T1EnergyStorageAdjacencyBuffs` des Speichers: +3,3 Prozent Energieproduktion je
angrenzendem Speicher fuer ein `SIZE12`-Gebaeude, `Stacks = 'ALWAYS'`. Die Einstellung
greift nur bei Nachbarn, die Energie verbrauchen.

### Vorschlag Commit-Nachricht

```
IHPP: RegenRate einstellbar, StorageEnergy vereinheitlicht

- config.lua: RegenRateT2 (Vorgabe 2) und RegenRateT3 (Vorgabe 4), Auswahl 0-10
- hook: setzt RegenRate, Adjacency und StorageEnergy fuer alle acht IDs
- StorageEnergy T2 fest auf 200 - BSB1202 hatte als einziges keinen Eintrag
- Doku: Vollvergleich aller acht Blueprints, Belege zur Wirkrichtung von Adjacency

Ungetestet.
```

---

## 2026-08-15 (5) - Adjacency zentral und im Mod-Manager einstellbar; Mod-Bilder

- **Was:** Nachbarschaftsboni der Hydrocarbon-Kraftwerke aus den Blueprints herausgeloest
  und ueber `config.lua` im Mod-Manager einstellbar gemacht; `RegenRate` bei `BAB1202`
  entfernt; beiden fertigen Mods ein Mod-Bild gegeben
- **Wo:** neu `usermods\ImprovedHydrocarbonPowerPlants\config.lua` und
  `...\hook\lua\system\Blueprints.lua`; geaendert `...\units\BAB1202\BAB1202_unit.bp`,
  `...\units\BAB1302\BAB1302_unit.bp`, beide `mod_info.lua`;
  Doku `mods\ImprovedHydrocarbonPowerPlants.md`, `mods\SquareShields.md`
- **Wie:** Hook auf `ModBlueprints` plus `config.lua`
- **Getestet:** **nein**

### Erledigt: die Aeon-Abweichung

Alle acht Blueprints sind jetzt **byte-identisch mit `BlackOpsUnleashed`**. `BAB1202` und
`BAB1302` stehen wieder auf `HydrocarbonAdjacencyBuffs`, das zusaetzliche
`RegenRate = 10` bei `BAB1202` ist entfallen.

### Neu: Einstellung im Mod-Manager

| Schluessel | Label | Vorgabe |
|---|---|---|
| `AdjacencyT2` | Nachbarschaftsboni Stufe 2 | `T2PowerGeneratorAdjacencyBuffs` |
| `AdjacencyT3` | Nachbarschaftsboni Stufe 3 | `T3PowerGeneratorAdjacencyBuffs` |

Je drei Auswahlmoeglichkeiten, die Vorgabe im Anzeigetext mit "(Vorgabe)" markiert, beim
T2-Eintrag mit dem Hinweis, dass er inhaltlich gleich `HydrocarbonAdjacencyBuffs` ist.
In der Vorgabe gilt damit fuer **alle vier Fraktionen**, was vorher nur Aeon hatte.

Der Hook setzt `bp.Adjacency` fuer die acht IDs und protokolliert mit dem Praefix `IHPP:`.
Die Werte in den `_unit.bp` bleiben auf dem Originalwert und werden ueberschrieben - so
bleibt der Diff gegen BlackOps sauber.

### Belegt: `mod.config` ist in der Blueprint-Ladephase verfuegbar

Dank des Hinweises auf `Enhanced Static HP`. Dessen Hook
(`gamedata.entpackt\loud_misc\mods\Enhanced Static HP\hook\lua\system\Blueprints.lua`)
liest die Einstellung genau so:

```lua
for _, v in __active_mods do
    if v.uid == 'ffffffff-9d4e-11dc-8314-0800200c0600' then
        modConfig = v.config
        break
    end
end
```

Zwei Eigenheiten aus `mods.lua` `AllMods()` (Z. 277-292): **`default` ist ein 1-basierter
Index** in die `values`-Liste, kein Schluessel; und die Werte liegen im **Spielerprofil**
(`Prefs`, `modConfig`) und werden nur gesetzt, wenn dort noch nichts steht.

**Verworfen** wurde eine eigene `lua\Settings.lua` per `import`: ob `import` in der
Blueprint-Ladephase verfuegbar ist, laesst sich nicht belegen - `Blueprints.lua` benutzt
dort `doscript`, BrewLANs 833-Zeilen-Hook kommt ganz ohne aus.

### Neu: Mod-Bilder ohne mitgelieferte Dateien

| Mod | `icon` |
|---|---|
| `ImprovedHydrocarbonPowerPlants` | `/textures/ui/common/icons/units/BEB1302_icon.dds` |
| `SquareShields` | `/textures/ui/common/icons/units/UEBSSG01_icon.dds` |

Beides Bausymbole der jeweiligen UEF-Einheit, die ohnehin in `textures.scd` liegen. Der
Wert geht unveraendert an `Bitmap:SetTexture()`
(`gamedata.entpackt\lua\lua\ui\dialogs\modmanager.lua` Z. 1131 und 1365) - **keine
Bilddatei im Mod noetig**. Darstellung 36x36 in der Liste, 70x70 in der Detailansicht.

### UNGEPRUEFT - moegliches Desync-Risiko

`mods.lua` Z. 266 liest die Mod-Konfiguration aus
`Prefs.GetFromCurrentProfile("modConfig")`, also aus dem **lokalen** Profil. Ob die Lobby
den gewaehlten Wert an alle Spieler uebertraegt, ist **nicht geprueft**. Falls nicht,
wuerden bei unterschiedlichen Einstellungen die Blueprints auseinanderlaufen.
**Vor dem Gruppeneinsatz klaeren.**

### Vorschlag Commit-Nachricht

```
IHPP: Adjacency zentral ueber config.lua steuerbar; Mod-Bilder

- config.lua: AdjacencyT2/T3, Vorgaben T2- bzw. T3PowerGeneratorAdjacencyBuffs
- hook/lua/system/Blueprints.lua: setzt bp.Adjacency fuer alle acht IDs
- BAB1202/BAB1302 auf den BlackOps-Originalwert zurueck, RegenRate entfernt
  -> alle acht Blueprints jetzt byte-identisch mit BlackOpsUnleashed
- mod_info.lua (beide Mods): icon auf das UEF-Bausymbol aus textures.scd

Ungetestet. Offen: wird die Mod-Konfiguration im Multiplayer uebertragen?
```

---

## 2026-08-15 (4) - ImprovedHydrocarbonPowerPlants: vollstaendig geprueft, uid und conflicts

- **Was:** Mod komplett durchgegangen, uid auf GUID umgestellt, `conflicts` gegen
  `BlackOpsUnleashed` gesetzt, Dokumentation angelegt
- **Wo:** `usermods\ImprovedHydrocarbonPowerPlants\mod_info.lua`;
  neu `doc.claude\mods\ImprovedHydrocarbonPowerPlants.md`; `18_ABLEITUNG.md` nachgezogen
- **Wie:** Vollkopie als Extrakt, wie bei `SquareShields`
- **Getestet:** **nein**

| Feld | Alt | Neu |
|---|---|---|
| `uid` | `morehydromodv01` | `AD88F006-304B-42E6-8612-E63918A7BE22` |
| `conflicts` | nicht gesetzt | `{ "9e8ea941-c306-4751-b367-a11000000502" }` (BlackOps Unleashed) |

An den Blueprints und Scripts wurde **nichts** geaendert.

### Wichtigster Befund: LOUD rechnet mit diesen Blueprints

`gamedata.entpackt\units\units\UEB1102\UEB1102_unit.bp` - Basisspiel, kein Mod - enthaelt
`UpgradesTo = 'beb1202'`, `BuildableCategory = { 'beb1202' }` und
`RebuildBonusIds = {'ueb1102','beb1202','beb1302'}`. Dasselbe in `UAB1102`, `URB1102`,
`XSB1102`.

**Ohne einen Mod, der diese IDs liefert, zeigt LOUDs Standard-Hydrokraftwerk auf ein nicht
vorhandenes Aufstiegsziel.** Der Extrakt schliesst damit eine Luecke im Basisspiel - ein
deutlich staerkeres Argument als bei `SquareShields`.

Die Kette ist vollstaendig: `ueb1102 -> beb1202 -> beb1302` und entsprechend fuer die
drei anderen Fraktionen. Nichts haengt in der Luft.

### Diffs gegen BlackOpsUnleashed

- **alle acht Scripts: 0 geaenderte Zeilen**
- sechs von acht Blueprints: 0 geaenderte Zeilen
- `BAB1202`: 3, `BAB1302`: 2 - gegen `UEF_trans_men` gediffed und dort identisch, also
  Altbestand

### OFFEN: die Aeon-Abweichung

```
BAB1202  Adjacency 'HydrocarbonAdjacencyBuffs' -> 'T2PowerGeneratorAdjacencyBuffs'
BAB1202  RegenRate = 10 neu
BAB1302  Adjacency 'HydrocarbonAdjacencyBuffs' -> 'T3PowerGeneratorAdjacencyBuffs'
```

Vergleich der Buff-Listen in `gamedata.entpackt\lua\lua\sim\AdjacencyBuffs.lua`:

| Paar | Eintraege | Befund |
|---|---|---|
| Hydrocarbon gegen T2PowerGenerator | 24 / 24 | **deckungsgleich** - die Aenderung an `BAB1202` ist wirkungslos |
| Hydrocarbon gegen T3PowerGenerator | 24 / 20 | **vollstaendig disjunkt** - `BAB1302` gibt Nachbarn T3-Boni statt T2 |

Aeon bekommt damit als einzige Fraktion einen Vorteil. **Unveraendert gelassen**, weil
nicht feststellbar ist, ob das Absicht war - Entscheidung steht aus, Optionen in
`mods\ImprovedHydrocarbonPowerPlants.md` Abschnitt 6.

### Erbfehler, nicht korrigiert

`BRB1202_script.lua` und `BRB1302_script.lua` deklarieren beide die Klasse `URB1102`.
Das steht **wortgleich so im BlackOps-Original** - kein Kopierfehler. Folgenlos, weil
`TypeClass` direkt darunter zugewiesen wird.

### Vorschlag Commit-Nachricht

```
ImprovedHydrocarbonPowerPlants: frische GUID, conflicts gegen BlackOpsUnleashed

- mod_info.lua: uid AD88F006-..., conflicts 9e8ea941-...
- doc.claude/mods/ImprovedHydrocarbonPowerPlants.md angelegt
- Blueprints und Scripts unveraendert

Offen: Aeon-Adjacency (BAB1202/BAB1302) - Entscheidung steht aus.
Ungetestet.
```

---

## 2026-08-15 (3) - HCPP umbenannt in ImprovedHydrocarbonPowerPlants

- **Was:** Ordner und Anzeigename des Hydrocarbon-Mods sprechend gemacht
- **Wo:** `usermods\HCPP\` -> `usermods\ImprovedHydrocarbonPowerPlants\`,
  darin `mod_info.lua`; nachgezogen in `doc.claude\18_ABLEITUNG.md` und `TODO.md`
- **Wie:** Ordnerumbenennung, `mod_info.lua` neu geschrieben
- **Warum:** "HCPP" (HydroCarbon Power Plant) ist der Anzeigename **einer** Einheit
  (`BEB1202` = "HCPP - X2000"), nicht des Mods. Dazu kamen drei verschiedene Namen fuer
  dieselbe Sache: Ordner `HCPP`, Anzeigename `MoreHydro`, Sollliste `Improved Hydrocarbons`.
- **Getestet:** **nein**

| | vorher | jetzt |
|---|---|---|
| Ordner | `HCPP` | `ImprovedHydrocarbonPowerPlants` |
| VFS-Pfad | `/mods/hcpp/` | `/mods/improvedhydrocarbonpowerplants/` |
| `name` | `MoreHydro` | `Improved Hydrocarbon PowerPlants` |
| `uid` | `morehydromodv01` | unveraendert |

**Warum das gefahrlos war:** alle acht Blueprints und Scripts wurden auf `/mods/`-Verweise
geprueft - **kein einziger**. Die Scripts importieren nur `/lua/defaultunits.lua` bzw.
`/lua/seraphimunits.lua` und Standard-Emitter aus `/effects/emitters/`. Die `uid` ist
explizit gesetzt, aendert sich beim Umbenennen also nicht (`mods.lua`, `LoadModInfo`).

Die `uid` bleibt vorerst `morehydromodv01` - die Umstellung auf eine GUID gehoert in den
Durchgang dieses Mods, zusammen mit `conflicts` gegen `BlackOpsUnleashed`.

### Vorschlag Commit-Nachricht

```
HCPP in ImprovedHydrocarbonPowerPlants umbenannt

- Ordner und Anzeigename sprechend gemacht ("HCPP" war der Name einer Einheit)
- uid unveraendert, keine Pfadverweise betroffen
- doc.claude: 18_ABLEITUNG.md und TODO.md nachgezogen
```

---

## 2026-08-15 (2) - SquareShields: Extrakt fertiggestellt

- **Was:** uid auf GUID umgestellt, `conflicts` gegen `LOUD Unit Additions` gesetzt,
  Aufstieg auf die Stufe 02 aus allen vier Blueprints entfernt, kaputten
  Animationspfad in `XSBSSG01` repariert
- **Wo:** `usermods\SquareShields\mod_info.lua`,
  `usermods\SquareShields\units\{UABSSG01,UEBSSG01,URBSSG01,XSBSSG01}\*_unit.bp`,
  `doc.claude\mods\SquareShields.md`
- **Wie:** Vollkopie mit Anpassung (kein Merge - siehe unten)
- **Warum:** Der Mod soll die vier Wuerfelschilde ohne die uebrigen 22 Einheiten aus
  `LOUD Unit Additions` bereitstellen, ohne Aufstiegsstufe
- **Getestet:** **nein** - Testlauf steht aus

### Aenderungen im Einzelnen

| Datei | Aenderung |
|---|---|
| `mod_info.lua` | `uid = "D5F66739-FD09-4166-8D73-A5D496772B7C"` statt `SquareShieldThyngVersion01`; `conflicts = { "fffffffe-6e98-4864-9599-4133236eea7a" }` |
| alle vier `_unit.bp` | `Economy.BuildableCategory` -> `{ }`; `Economy.RebuildBonusIds` -> nur noch `...ssg01`; `General.UpgradesTo` entfernt |

Mehr nicht. Die Blueprints bleiben ansonsten byte-gleich mit `LOUD Unit Additions`.

`requiresNames` wurde **nicht** gesetzt: die Tabelle gilt laut `mods.lua` Z. 86-91 nur
fuer `requires`, nicht fuer `conflicts`.

### Warum Vollkopie

`Merge = true` greift nur bei bereits vorhandener ID (`Blueprints.lua`,
`StoreBlueprint()`). Da `LOUD Unit Additions` per `conflicts` ausgeschlossen ist, existiert
sie nicht - ein Merge-Blueprint wuerde einen Torso ergeben.

Zwei schlankere Wege wurden geprueft und verworfen:

- **`excludes.lua`** (`Blueprints.lua` Z. 1243-1285) koennte Blueprints eines anderen Mods
  vom Laden ausschliessen. Blockiert, weil `m.config` fuer Mods ohne `config.lua` `nil`
  bleibt - belegt durch das Fehlen der Warnung `has an empty or malformed config file`
  im `LOUD.log`.
- **Nur Blueprints, Assets aus `/mods/LOUD Unit Additions/`** waere moeglich (Mounten und
  Aktivieren sind getrennt), haengt den Mod aber still an LOUDs Dateilayout.

### Offen und ausdruecklich unbelegt: der Animationspfad in XSBSSG01

`XSBSSG01_unit.bp` Z. 61 verweist auf `/units/XSBSSG01/XSBSSG01_ADeath1.sca`. Diesen Pfad
gibt es im VFS nicht - `/units/` speist sich nur aus `units.scd` und `civ_units.scd`, den
einzigen beiden Archiven mit einem `units\`-Ordner im Wurzelverzeichnis; die `.sca` liegt
unter `loud_units\mods\LOUD Unit Additions\units\XSBSSG01\`.

**Ob daraus folgt, dass die Animation fehlt, ist nicht belegt.** Die Aufloesung von
`.sca`-Pfaden passiert engineseitig und steht nicht im Lua-Code. Im selben Blueprint
werden LOD-Texturen als blosse Dateinamen angegeben und neben der `.bp` gefunden - es gibt
also mindestens einen relativen Mechanismus. Das Log meldet fehlende Ressourcen nicht.

**Nicht geaendert** - eine Anpassung ohne belegten Anlass. Steht als Testauftrag in
`mods\SquareShields.md` Abschnitt 4.2 und in `TODO.md`.

### Vorschlag Commit-Nachricht

```
SquareShields: Extrakt aus LOUD Unit Additions fertiggestellt

- mod_info.lua: frische GUID, conflicts gegen LOUD Unit Additions
- alle vier Blueprints: Aufstieg auf ...ssg02 entfernt
- doc.claude/mods/SquareShields.md: vollstaendige Referenzliste ergaenzt

Ungetestet - Testlauf steht aus.
```

---

## 2026-08-15 - Ableitung aus UEF_trans_men: Bestandsanalyse, SquareShields geprueft

- **Was:** Die vier vom Kollegen angelegten Mods (`t4add`, `SquareShields`, `HCPP`,
  `dynamic_gameplay`) analysiert; alle 25 Blueprints gegen ihre LOUD-Originale gediffed;
  `mount_mods`, `hook`, `shadow` und `Merge` am Quellcode nachgeprueft; `SquareShields`
  vollstaendig durchgegangen
- **Wo:** neu `doc.claude\18_ABLEITUNG.md`, neu `doc.claude\mods\SquareShields.md`;
  ergaenzt `CLAUDE.md` Abschnitt 7, `README.md`, `TODO.md`
- **Wie:** reine Analyse - **kein Mod-Code geaendert**
- **Warum:** vor dem Umbau musste belegt sein, was die vier Ordner tatsaechlich enthalten
- **Getestet:** Diffs und Pfadaufloesungen belegt; **kein Spielstart**

### Kernbefunde

- **Alle 25 Blueprints existieren bereits in einem LOUD-eigenen Mod.** Einzige Ausnahme:
  `MKT0409`. Die vier Mods fuegen nichts hinzu, sie ueberschreiben.
- **15 von 25 Blueprints sind byte-identische Kopien** ohne jede Aenderung.
- **Korrektur einer frueheren Fehlannahme:** ein `lua\sim\...` im Mod-Ordner ist ein
  voellig normales Muster (`BrewLAN_LOUD` nutzt `lua\` und `hook\lua\` nebeneinander).
  Entscheidend ist, ob die Datei ein *Modul* oder ein *Patch* ist, nicht wo sie liegt.
- **`T2/T3PowerGeneratorAdjacencyBuffs` sind LOUD-eigen** (`AdjacencyBuffs.lua` Z. 655,
  1078). `HCPP` braucht dafuer keine mitgelieferte Datei - die gegenteilige Behauptung
  war falsch.
- **Ein Pfad ist nachweislich kaputt:** `t4add\units\SSL0403\SSL0403_unit.bp` verweist
  auf `/mods/brewlan/mods/BrewLAN_LOUD/...`; im VFS gibt es nur `/mods/BrewLAN_LOUD/`.
- **`SquareShields` aendert nichts.** Vollkopie aus `LOUD Unit Additions`, dazu fehlt die
  Aufstiegsstufe `...02`. Entscheidung ueber den Zweck des Mods steht aus.

### Vorschlag Commit-Nachricht

```
doc: Bestandsanalyse der vier aus UEF_trans_men abgeleiteten Mods

- 18_ABLEITUNG.md: Zuschnitt, Diff aller 25 Blueprints gegen die LOUD-Originale,
  nachgeprueftes Modsystem (mount_mods/hook/shadow/Merge mit Quellenangabe)
- mods/SquareShields.md: Vollpruefung - Mod ist eine unveraenderte Teilkopie von
  LOUD Unit Additions, Aufstiegsstufe fehlt
- CLAUDE.md, README.md, TODO.md: Index und offene Punkte nachgezogen

Kein Mod-Code geaendert.
```

---

## 2026-08-08 - CustomAI: zwei weitere KIs; Korrektur an der Stellschrauben-Doku

- **Was:** `customai_small` und `customai_smaller` als zusaetzliche KIs; die drei
  `Loud_Main_*`-Templates verglichen; zwei Fehler in der Doku korrigiert; neue Ebene 5
  (Zeitsteuerung) beschrieben
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`, `mods\CustomAI.md`,
  `mods\CustomAI_Stellschrauben.md`, `TODO.md`
- **Wie:** Eintrag in die Definitionsliste (kein Code, keine neue Datei)
- **Getestet:** **nein** - Testlauf 5 steht aus, siehe `TODO.md`

### Nur drei Templates kommen als `Source` in Frage

`Loud_Main_Standard`, `Loud_Main_Small`, `Loud_Main_Smaller`. Die uebrigen elf sind
Aussenposten-, Marine- und Verteidigungsplaene. Beleg gegen
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBaseTemplates\Loud_Naval_Large.lua`
Z. 7: `Builders = {}` - alles steht in `WaterMapBuilders`, es gibt keine
`ACU Tasks - Start Game`-Gruppe.

Weil unsere Fabrik `FirstBaseFunction` ersetzt, spielt `customai_small` sein kompaktes
Layout auf **jeder** Kartengroesse. Das ist der Zweck der beiden Eintraege.

### ⚠️ Korrektur 1: ein Basistemplate hat sieben Builder-Listen, nicht eine

`CustomAI_Stellschrauben.md` fuehrte "die 64 BuilderGroups" als eine Liste. Tatsaechlich
gibt es neben `Builders` noch `WaterMapBuilders`, `LandOnlyBuilders`,
`StandardCommanderUpgrades`, `BOACUCommanderUpgrades`, `LOUD_IS_Installed_Builders` und
`LOUD_IS_Not_Installed_Builders` - ausgewertet in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\aiaddbuildertable.lua`.

Ein `Apply()`, das nur `template.Builders` umbaut, erreicht Naval, Torpedobomber,
Amphibisch, alle Schild- und Storage-Builder und die ACU-Ausbaugruppen **nicht**.
Ausserdem prueft `GlobalBaseTemplate.lua` nur `Builders` auf gueltige Gruppennamen -
ein Tippfehler in den anderen sechs Listen bleibt still.

### Neu: Ebene 5 - Zeitsteuerung ueber `PriorityFunction`

BuilderGroups werden **einmal** beim Anlegen der Basis geladen; das Basistemplate taugt
daher nicht fuer "erst ab Minute X". Dynamisch ist nur die Prioritaet.

`Builder:Create` (`sim\Builder.lua` Z. 209-224) legt je Brain und Manager ein eigenes
Builder-Objekt an, die `PriorityFunction` bekommt den Brain als Parameter. Damit laesst
sich `Builders[<name>].PriorityFunction` **einmal global umhuellen** und im Inneren ueber
`aiBrain.CustomAIKey` nach KI unterscheiden - fremde KIs bleiben unberuehrt.

Wichtig dabei: `0, false` schaltet **permanent** ab (`SetPriority` loescht `OldPriority`,
`Builder.lua` Z. 253-256). Fuer ein Zeitfenster ist nur `10, true` richtig.

**Alles davon ist aus dem Code gelesen und im Spiel ungeprueft** - steht in `TODO.md`.

### ⚠️ Neuer offener Befund: globale Tabellen werden geleert

`AddGlobalBaseTemplate` setzt am Ende `BaseBuilderTemplates = nil` und
`BuilderGroups = nil`. `GetBestBasePlan` (jede KI) und `AINewExpansionBase` (jeder
Aussenposten) lesen sie danach wieder - was wegen des `__index`-Wachters in
`lua\system\config.lua` einen Fehler erzeugen muesste. **Der im Quellkommentar
angekuendigte Reload wurde nicht gefunden.** Der Log von Testlauf 4 endet bei Zeile 965
und beweist nichts - es gab weder eine zweite KI noch einen Aussenposten. Naechster
Testlauf soll das klaeren.

**Commit-Vorschlag:** `CustomAI: KIs fuer Loud_Main_Small und _Smaller; Doku-Korrektur Builder-Listen`

### Nachtrag desselben Tages: zwei NoRush-KIs

- **Was:** `customai_norush20` und `customai_norush5` - Phasen-KIs (Wirtschaft →
  Flugabwehr → minimale Bodenabwehr → Truppen)
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua` (neu),
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`, `mods\CustomAI.md`
- **Wie:** Umhuellung der `PriorityFunction` einzelner Builder, Weiche ueber
  `aiBrain.CustomAIKey`
- **Getestet:** **nein**

Anlass: im privaten Kreis wird mit 20 Minuten No-Rush gespielt. Die KI soll in dieser
Zeit nicht sinnlos Truppen bauen, sondern Wirtschaft und Tech hochziehen.

`NoRush.lua` haelt zwei Tabellen auf Modulebene (`Umhuellt`, `Sperren`), damit mehrere
KIs denselben Builder mit unterschiedlichen Zeiten sperren koennen, ohne die Umhuellung
doppelt zu legen. Bei Mehrfacheintraegen gewinnt der spaeteste Zeitpunkt.

**Der Techaufstieg brauchte keinen Eintrag.** `LaunchUpgradeThread` und
`FactorySelfEnhanceThread` werden von
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\FactoryBuilderManager.lua`
Z. 630-645 gestartet, sobald die Bauschlange einer Fabrik leer ist - unabhaengig von
jedem BuilderGroup. Phase 1 erzeugt genau diesen Zustand.

**Commit-Vorschlag:** `CustomAI: NoRush-Phasen-KIs (20 und 5 Minuten)`

### Nachtrag 2: Aufklaerung faellt ebenfalls in Phase 4

- **Was:** `Factory Production Air - Scouts` und `Land Scout` sind nicht mehr
  ausgenommen, sondern laufen erst ab `tTruppen`
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`, `mods\CustomAI.md`
- **Warum:** Wunsch des Nutzers - waehrend No-Rush gibt es nichts aufzuklaeren
- **Getestet:** nein

Die urspruengliche Ausnahme war mit `LandRatio`/`AirRatio` begruendet. **Der Einwand
traegt fuer Phase 1 nicht:** die `BuilderConditions` in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBuilders\Loud_AI_Engineer_Mass_Builders.lua`
und `...\Loud_AI_Engineer_Energy_Builders.lua` sind ausschliesslich
`EBC`-Lagerverhaeltnisse (`LessThanEconMassStorageRatio`,
`LessThanEconEnergyStorageRatio`) - kein einziger Ratio-Bezug. Der Wirtschaftsaufbau
laeuft ohne Aufklaerung unveraendert.

**Was der Einwand weiterhin trifft, ist Phase 4:** Bedrohungskarte, Gegnerwahl
(`loudutilities.lua` ab Z. 6270) und Angriffsplanung starten bei null. Deshalb liegt
`tTruppen` bewusst vor dem Ende des No-Rush-Zeitraums. Ob der Vorlauf reicht, ist
ungeprueft und steht in `TODO.md`.

**Commit-Vorschlag:** `CustomAI: Aufklaerung in NoRush-Phase 4`

### Nachtrag 3: eine NoRush-KI statt einer je Einstellung

- **Was:** `customai_norush20` und `customai_norush5` durch **eine** KI
  `customai_norush` ersetzt, die die Lobbyoption ausliest
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`, `mods\CustomAI.md`
- **Getestet:** nein

Die No-Rush-Einstellung ist definiert in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\ui\lobby\lobbyOptions.lua`
Z. 91-118: `key = 'NoRushOption'`, Werte `'Off'` / `'5'` / `'10'` / `'20'` als
Zeichenketten, Einheit Minuten. `LEMLobbyOptions.lua` (LOUDs eigene Lobbyerweiterung)
fasst sie nicht an.

**Dass Optionen dieser Tabelle unter ihrem `key` in `ScenarioInfo.Options` landen, ist an
zwei unmittelbaren Nachbarn belegt:** `simInit.lua` Z. 208 liest
`ScenarioInfo.Options.TeamLock`, `loudutilities.lua` Z. 5996 liest
`ScenarioInfo.Options.TeamSpawn`. Beide stehen in `lobbyOptions.lua` direkt vor
`NoRushOption`.

Die Phasen sind jetzt **Anteile** statt Sekunden - 0.35 / 0.55 / 0.75. Fuer 20 Minuten
ergibt das exakt die vorher von Hand gewaehlten 7:00 / 11:00 / 15:00, fuer 5 Minuten die
1:45 / 2:45 / 3:45. Bei `'Off'` ergibt `tonumber('Off')` nil, daraus 0 Sekunden, daraus
keine Sperre - die KI spielt dann wie LOUD.

**Die Auswertung passiert zur Laufzeit**, beim ersten Aufruf einer umhuellten
`PriorityFunction`, nicht beim Laden. Damit stellt sich die Frage nach der Verfuegbarkeit
von `ScenarioInfo.Options` im simInit-Hook gar nicht.

Feste Sekunden bleiben moeglich (`Zeit` statt `Anteil` in einer Phase).

**Commit-Vorschlag:** `CustomAI: NoRush-KI liest die Lobbyoption aus`

### Nachtrag 4: Testlauf 5 ausgewertet - Mechanik vollstaendig bestaetigt

- **Was:** `LOUD.log` von Testlauf 5 (vier eigene KIs gleichzeitig) ausgewertet
- **Wo:** `mods\CustomAI.md` (neuer Abschnitt Testlauf 5), `TODO.md`
- **Getestet:** ja - Karte 2048, Cheat 1, Sandbox, vier KI-Gegner

#### Bestaetigt

| Befund | Beleg im Log |
|---|---|
| Vier KIs registriert, jede mit eigener Quelle | `CUSTOMAI: 4 von 4 KIs registriert` |
| Jede gewinnt **ihre eigene** Basiswahl | vier `Selected "CustomAI_customai_<key>"` |
| `ScenarioInfo.Options.NoRushOption` kommt im Sim an | `Lobbyoption NoRushOption = 20 -> 1200 Sekunden` |
| `aiBrain.CustomAIKey` ist in der `PriorityFunction` gesetzt | dieselbe Zeile - sie steht nur im Sperrzweig |
| 95 Sperren gesetzt | `95 Sperren gesetzt` |
| Keine `Invalid BuilderGroup`, keine `Duplicate BaseBuilderTemplate` | kein Treffer |

#### Der offene Befund zu den geleerten Globalen relativiert sich

`AddGlobalBaseTemplate` setzt `BaseBuilderTemplates = nil` und `BuilderGroups = nil`.
**Vier KIs liefen nacheinander durch `GetBestBasePlan` - kein
`access to nonexistent global variable`.** Entweder weicht die installierte Fassung von
`gamedata.entpackt\lua\lua\AI\aiaddbuildertable.lua` ab, oder es gibt doch einen Reload.
Offen bleibt der Fall Aussenposten; in diesem kurzen Lauf entstand keiner.

#### Was der Lauf nicht zeigt

Die KIs verhielten sich sichtbar gleich. **Erwartbar:** die Partie endete vor der ersten
Phasengrenze (7:00 bei `NoRushOption = 20`), und die Fabrikgrenzen von Small/Smaller
(5 statt 7) werden so frueh nicht erreicht. Ausserdem protokolliert der Log ohne die
Debug-Schalter `DisplayFactoryBuilds` und `EngineerDialog` keine Bautaetigkeit.

**Beobachtung des Nutzers, die zweite Fabrik betreffend:** das ist Absicht.
`Engineer Factory Construction` steht bewusst nicht in den Sperren, weil der Techaufstieg
in LOUD ueber Fabrikaufstiege laeuft. Ob das so bleiben soll, steht als Entscheidung in
`TODO.md`.

**Es wurden keine Mod-Dateien veraendert - reine Auswertung.**

### Nachtrag 5: Fabriken erst ab Phase 3, danach hinter der Wirtschaft

- **Was:** neuer Mechanismus `Prioritaet` (dauerhafter Prioritaetsdeckel) in
  `NoRush.lua`; acht Fabrikbauer bis Phase 3 gesperrt und dauerhaft auf 745 gedeckelt
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`, `mods\CustomAI.md`
- **Getestet:** **nein**

Anlass: Beobachtung aus Testlauf 5 - die NoRush-KI baut in den ersten Minuten eine zweite
Fabrik, die nichts produziert. Vorgabe des Nutzers: neue Fabriken erst ab Phase 3, und
generell Wirtschaft vor Fabriken.

#### Neuer Mechanismus

Eine Phase kann jetzt neben `Zeit`/`Anteil` ein Feld `Prioritaet` tragen. Der Wert wirkt
**auch nach der Freigabe** und begrenzt den Rueckgabewert der Original-PriorityFunction
nach oben - nur nach unten, nie nach oben. Damit laesst sich eine Aufgabenart dauerhaft
hinter eine andere stellen, ohne sie abzuschalten.

Wirksam wird das durch `GetHighestBuilder`: nur das oberste Prioritaetsband konkurriert
ueberhaupt (`mods\CustomAI_Stellschrauben.md` Ebene 4c).

#### Die Zahl 745

Die Wirtschaftsbauer an `MAIN` liegen zwischen 900 (T2 Power) und 750 (Hydrocarbon,
Mass Storage 600); die Fabrikbauer im Original bei 800/801 - also **ueber** T1-Kraftwerk
(761), den entfernteren Massextraktoren (760/755) und Hydrokarbon (750). Mit 745 rutschen
sie unter alles davon. Vollstaendige Tabelle in `mods\CustomAI.md`.

#### Nicht betroffen

`ACU Tasks - Start Game` baut weiterhin die erste Fabrik
(`Loud_AI_ACU_Builders.lua` ab Z. 126) - ohne sie gaebe es keine Ingenieure und keinen
Techaufstieg. Ebenso ausgenommen: die beiden Rebuild-Bauer (Originalprioritaet 10) und
`Quantum Gate`, weil er SCUs produziert und damit als Wirtschaft zaehlt.

**Commit-Vorschlag:** `CustomAI: Fabriken erst ab Phase 3 und hinter der Wirtschaft`

### Nachtrag 6: Baureihenfolge - Bedingungen, Prioritaetsboden, BaseSettings

- **Was:** drei neue Mechanismen in `NoRush.lua` (`Bedingung`, `PrioritaetMin`,
  `definition.BaseSettings`); damit Fabriken zusaetzlich an 4 T3-Extraktoren gebunden,
  Massespeicher/Quantentor/SCU vorgezogen, SCU-Obergrenze angehoben
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`, `mods\CustomAI.md`
- **Getestet:** **nein**

#### ⚠️ Zwei Wuensche waren schon erfuellt - ohne unser Zutun

**"Sobald T3-Kraftwerke stehen, keine kleineren mehr."** Macht LOUD bereits.
`T1 Power Template` und `T2 Power Template` haben beide eine `PriorityFunction`, die
`11` bzw. `12` zurueckgibt, sobald `UnitsGreaterAtLocation(..., 0, ENERGYT3)` wahr ist
(`Loud_AI_Engineer_Energy_Builders.lua` Z. 46-58 und Z. 101-113). Und zwar **je Basis**,
nicht je Armee. Nichts geaendert.

**"SCU soll das Ressourcen-Upgrade machen."** Macht LOUD bereits.
`SCUSelfEnhanceThread` (`aibehaviors.lua` Z. 8162), gestartet von `EngineerManager.lua`
Z. 225, arbeitet je SCU eine Fraktionsliste ab - `ResourceAllocation` steht bei UEF, Aeon
und Cybran an **erster** Stelle. Seraphim fehlt es, weil die Seraphim-SCU das Upgrade gar
nicht hat (geprueft in `units\units\XSL0301\XSL0301_unit.bp`). Nichts geaendert.

#### ⚠️ Extraktoraufstiege sind ueberhaupt keine Builder

T1 -> T2 -> T3 laeuft ueber `SelfUpgradeThread`, je Extraktor einzeln gestartet von
`LaunchUpgradeThread` in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\defaultunits.lua`
Z. 793-820, gesteuert ueber Wirtschaftstrends (T1: masslow .66, energylow 1.007; T2:
masslow .70, energylow 1.008). **Ueber Prioritaeten nicht erreichbar.** Wer daran drehen
will, braucht einen Hook auf `/lua/defaultunits.lua`. Steht in `TODO.md`.

#### Neue Mechanismen

| Feld | Wirkung |
|---|---|
| `Bedingung` / `BedingungWert` | Freigabebedingung zusaetzlich zur Zeit - beide muessen erfuellt sein. Namensregister in `NoRush.lua`, damit `AIDefinitions.lua` reine Daten bleibt (die Datei liest auch die Lobby-UI, dort gibt es kein `categories`). |
| `PrioritaetMin` | Prioritaetsboden als Gegenstueck zum Deckel |
| `definition.BaseSettings` | feldweises Ueberschreiben von `template.BaseSettings` |

Deckel und Boden greifen **nur oberhalb von 100**. Sonst haette der Boden von 855 genau
die oben beschriebene Kraftwerksabschaltung (11/12) ueberstimmt.

#### Aenderungen an der KI

| | Original | neu |
|---|---:|---:|
| Fabriken: zusaetzliche Bedingung | - | 4 T3-Extraktoren |
| `Engineer Mass Storage Construction` | 750 / 740 | 843 |
| `Quantum Gate` | 850 | 855 |
| `Sub Commander - Extra` | 650 | 905 |
| `BaseSettings.EngineerCount.SCU` | 12 | 20 |

Die SCU-Grenze war der eigentliche Engpass, nicht die Prioritaet: `Sub Commander` steht
schon bei 900, wird aber von `BelowEngineerCapCheck('SCU')` gedeckelt. Bei
Einheitenlimit 5000 und Cheat 1 ergeben LOUDs 12 genau 22 SCUs; mit 20 werden es 30.
Rechnung in `mods\CustomAI.md`.

**Commit-Vorschlag:** `CustomAI: Baureihenfolge - Bedingungen, Prioritaetsboden, SCU-Grenze`

### Nachtrag 7: nur eine Fabrik; Fabrikaufstieg an Extraktoren gebunden

- **Was:** Rebuild-Bauer mitgesperrt; neuer Hook auf `/lua/defaultunits.lua`, der den
  Fabrikaufstieg T1 -> T2 an 4 Extraktoren ab Stufe 2 bindet
- **Wo:** `usermods\CustomAI\hook\lua\defaultunits.lua` (neu),
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`, `mods\CustomAI.md`
- **Getestet:** **nein**

#### ⚠️ Korrektur: "Rebuild" heisst nicht "nur ersetzen"

Testlauf 6 zeigte: die zweite Fabrik kam von `Land Factory Rebuild`, nicht von den acht
gesperrten Bauern. Meine Ausnahmebegruendung ("Prioritaet 10, ersetzen nur zerstoerte
Fabriken") war falsch - die Bauer tragen `PriorityFunction = HaveZeroLandFactories` bzw.
`HaveZeroAirFactories` (`Loud_AI_Engineer_Factory_Builders.lua` Z. 54-82) und liefern nach
60 Sekunden **990**, sobald von einem Typ keine Fabrik da ist. Das ist LOUDs Garantie
"mindestens je eine Land- und eine Luftfabrik".

Ablauf auf Karte 2048: `CDR Initial Large Map` (`MapGreaterThan 1024`) laesst den ACU eine
**Luft**fabrik bauen; danach hat die KI null Landfabriken und der Rebuild-Bauer greift bei
Sekunde 60.

Jetzt mitgesperrt - **ohne** Prioritaetsdeckel, damit der Notfallwert 990 nach der
Freigabe unangetastet bleibt.

**Kein Nachteil beim Ingenieurnachschub:** die Luftfabrik hat
`BUILTBYTIER1FACTORY UEF MOBILE LAND CONSTRUCTION` in ihrer `BuildableCategory`
(`units\units\UEB0102\UEB0102_unit.bp` Z. 95) und baut Ingenieure.

#### Neuer Hook auf `/lua/defaultunits.lua`

Fabrikaufstiege sind keine Builder. `StructureUnit.LaunchUpgradeThread` (Z. 696) startet
`SelfUpgradeThread`; ueber Prioritaeten ist da nichts erreichbar.

**Umhuellt wird `FactoryUnit`, nicht `StructureUnit`.** `FactoryUnit = Class(StructureUnit)`
steht in Z. 2046 und wird beim Laden der Datei ausgewertet - ein Hook auf `StructureUnit`
laeuft danach und erreicht die Fabriken nicht mehr.

Die Weiche haengt an `aiBrain.CustomAIKey`. Ist die Bedingung nicht erfuellt, tut der Hook
schlicht nichts; `FactoryBuilderManager.lua` Z. 630-636 ruft `LaunchUpgradeThread` von
selbst erneut auf, sobald die Bauschlange leer ist. Ein Wartethread war deshalb nicht
noetig.

#### Zum Thema Unterstuetzung: LOUD hat das bereits

| Builder | Prio | tut |
|---|---:|---|
| `Assist Mass` | 740 | Ingenieure unterstuetzen Bau **und Aufstieg** von `MASSPRODUCTION - TECH1` im Umkreis 120, 4 Instanzen |
| `Eng Assist Structure/Exp` | 720 | T2/T3-Ingenieure unterstuetzen Strukturbauten, Umkreis 120, 6 Instanzen |
| `T1 Assist Structure/Exp` | 720 | dasselbe fuer T1, 5 Instanzen |

Alle drei stehen sehr niedrig - **das ist Absicht und richtig**: sie greifen genau dann,
wenn ein Ingenieur nichts Wertvolleres zu tun hat. Ein Prioritaetsboden waere hier
kontraproduktiv.

**Grenze, nicht behebbar mit dem jetzigen Mechanismus:** `Assist Mass` traegt die
Bedingung `LessThanEconMassStorageRatio { 60 }` - es unterstuetzt nur, solange das
Masselager unter 60 Prozent steht. In Phase 1 wird es oft voller sein. `BuilderConditions`
und `InstanceCount` werden von `Builder:Create` (`sim\Builder.lua`) je Manager aus der
globalen Tabelle kopiert; sie liessen sich nur fuer **alle** KIs aendern. Steht in
`TODO.md`.

**Commit-Vorschlag:** `CustomAI: nur eine Fabrik; Fabrikaufstieg an Extraktoren gebunden`

### Nachtrag 8: Umhuellung ist jetzt ein echter Leerlauf fuer fremde KIs

- **Was:** Rueckgabewert `false`, wenn der Builder urspruenglich keine
  `PriorityFunction` hatte und fuer diese KI nichts gesetzt ist
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`, `mods\CustomAI.md`
- **Warum:** Vorgabe des Nutzers - keine Aenderungen an der Default-KI
- **Getestet:** nein

#### Der Fehler

Fuer Builder **ohne** eigene `PriorityFunction` ueberspringt `BuilderManager.lua` Z. 316
den ganzen Zweig. Unsere Umhuellung legte dort eine Funktion hin, wo vorher keine war -
und gab `(self.OldPriority or self.Priority), true` zurueck. Das ist kein Leerlauf: Z. 327
lautet `if newPri and newPri != Priority`, und `Priority` ist der **aktuelle** Wert des
Managers. Hatte der Manager die Aufgabe gerade voruebergehend auf 10 gesetzt (Z. 170),
haette unsere Umhuellung sie ungefragt wiederhergestellt - **auch bei LOUDs eigenen KIs.**

#### Die Loesung

`return false`. Z. 327 prueft `if newPri and ...` - ein falscher Wert laesst die Zuweisung
aus, also exakt das Verhalten ohne `PriorityFunction`.

#### Nebenbefund: `self` ist die globale Tabelle

Der Aufruf lautet `Builders[TaskName]:PriorityFunction( aiBrain, unit, self )`. `self` ist
also `Builders[name]` - **nicht** das Builder-Objekt des Managers, auf das `SetPriority`
schreibt. Folgen:

- `self.Priority` ist der urspruengliche, statische Wert
- `self.OldPriority` ist in einer `PriorityFunction` **immer nil**
- LOUDs verbreitetes `return (self.OldPriority or self.Priority), true` ist damit
  effektiv nur `return self.Priority, true`

#### Zur Frage nach konkurrierendem Masseverbrauch

**Nichts wird pausiert.** Die Engine verteilt Masse und Energie anteilig auf alle aktiven
Verbraucher - bei Knappheit wird alles langsamer, nichts angehalten. Das
Prioritaetssystem entscheidet nur, **welche Aufgaben begonnen** werden, nicht wie die
Ressourcen danach verteilt werden.

Die einzigen echten Pausen in LOUD:

| Stelle | Verhalten |
|---|---|
| `MassFabricationUnit.MassFabThread` (`defaultunits.lua` Z. 3265) | Massefabrikator aus, wenn Masselager > 95 % oder Energie knapp |
| `WatchUpgradeConsumption` (`defaultunits.lua` Z. 3185) | aufsteigende Struktur drosselt Produktion und Verbrauch, wenn sie nicht 100 % bekommt |
| `AssistEnergy` / `AssistMass` in `BuilderData` | Ingenieure brechen die Unterstuetzung ab, wenn die Vorraete unter den Wert fallen |

**Der eigentliche Schutz vor Uebernahme sind die `BuilderConditions**, nicht die
Prioritaet - `GreaterThanEconStorageCurrent`, `GreaterThanEconTrendEfficiencyOverTime`
und Verwandte lassen eine Aufgabe gar nicht erst starten, wenn die Wirtschaft sie nicht
traegt.

**Commit-Vorschlag:** `CustomAI: Umhuellung als echter Leerlauf fuer fremde KIs`

### Nachtrag 9: T1 raus, T3-Flak zuerst, Aufstieg vor Speicher

- **Was:** vier neue Bedingungen; T1-Verteidigung und T1-Einheiten dauerhaft aus;
  T3-Flak vorgezogen; T1-Kraftwerke begrenzt; Transporter an Bedingungen geknuepft;
  `Assist Mass` ueber die Speicher gehoben
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein** - alles aus Beobachtungen zu Testlauf 6 abgeleitet

#### Neue Bedingungen in `NoRush.lua`

| Name | wahr wenn |
|---|---|
| `Nie` | nie - dauerhafte Sperre |
| `WenigerAlsT1Kraftwerke` | weniger als n T1-Kraftwerke (ohne Hydrokarbon) |
| `TransporterFreigabe` | T3-Luftfabrik vorhanden UND Quantentor vorhanden oder im Bau |

`KeinQuantentor` wurde entfernt - ungenutzt.

#### Aenderungen

| Was | Wie |
|---|---|
| T1-Verteidigung | `Nie` auf 6 Bauer: `T1 Base Defense - PD/AA`, `T1 Perimeter PD - Small/Large Map`, `T1 Perimeter - AA`, `T1 Extractor Defense` |
| T1-Einheiten | `Nie` auf 13 Bauer, Land und Luft |
| T3-Flak zuerst | Boden 760 auf `T3 Base AA - Base Template`, `T3 Perimeter AA`, `T3 Picket AA`, `T3 Base AA - Expansions`. Fast alle Verteidigungsbauer liegen im Original bei 750, `T3 Base PD` bei 751. |
| T1-Kraftwerke | Bedingung `WenigerAlsT1Kraftwerke` = 12. LOUD bremst erst bei 70 Stueck im Umkreis 33 oder wenn ein T3-Kraftwerk steht (`Loud_AI_Engineer_Energy_Builders.lua` Z. 46-58) - daher die Beobachtung. **Die 12 sind geraten.** |
| Transporter | `Air Transport T1` faellt unter T1-Sperre; `Air Transport T2/T3` und `UEF Gunship Transports` an `TransporterFreigabe` |
| Aufstieg vor Speicher | `Assist Mass` Boden 844, Speicher bleibt 843 |

#### ⚠️ Nur halb geloest: Aufstieg vor Speicher

Die Beobachtung war: der vierte T2-Extraktor stieg nicht auf T3, stattdessen wurde ein
zweiter Speicher gebaut. Ursache ist die Reihenfolge - `Mass Storage 600` lag mit unserem
Boden bei 843, `Assist Mass` bei 740.

Neu: 845/846/850 (nahe Extraktoren) > **844 Assist** > 843 Speicher.

**Das reicht womoeglich nicht.** `Assist Mass` traegt
`LessThanEconMassStorageRatio { 60 }` - es unterstuetzt nur, solange das Masselager unter
60 Prozent steht. Genau bei vollem Lager, wenn Unterstuetzung am meisten braechte, ist es
aus. `BuilderConditions` lassen sich mit dem jetzigen Mechanismus nicht je KI aendern;
der saubere Weg waere eine eigene Builder-Kopie. Steht in `TODO.md`.

#### ⚠️ Nebenwirkung der T1-Sperre: keine Aufklaerung vor Stufe 2

`Land Scout` und `Air Scout T1` fallen mit weg. Aufklaerung gibt es damit erst, wenn die
Fabriken auf Stufe 2 sind. `aiBrain.IL`, `LandRatio` und `AirRatio` bleiben bis dahin
leer. Bei No-Rush unkritisch, danach beobachten.

**Commit-Vorschlag:** `CustomAI: keine T1-Einheiten und -Verteidigung, T3-Flak zuerst`

### Nachtrag 10: eigene Builder-Kopien - der Schluessel zu allem Uebrigen

- **Was:** neuer Mechanismus `definition.Kopien`; Kraftwerksplan 20 T1 / 4 T2 / dann T3
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Der Mechanismus

Prioritaeten sind ueber die Umhuellung erreichbar, `BuilderConditions` und
`InstanceCount` nicht - `Builder:Create` liest beide je Manager aus der globalen Tabelle.

**Der Ausweg: eine Kopie unter neuem Namen.** Alle drei Bausteine liegen im
simInit-Fenster bereit:

| Konstruktor | Datei | traegt ein in |
|---|---|---|
| `Builder{}` | `lua\system\GlobalBuilderTemplate.lua` | `Builders[name]` |
| `BuilderGroup{}` | `lua\system\GlobalBuilderGroup.lua` | `BuilderGroups[name]` |
| - | - | `template.Builders` (unsere tiefe Kopie) |

Ablauf je Kopie: Original kopieren, Felder aendern, unter neuem Namen registrieren, in
eine Gruppe `CustomAI_<Key>_<Typ>` stecken, Gruppe an `template.Builders` haengen.
**Andere KIs sehen die Gruppe nie, weil ihre Templates sie nicht auflisten.**
Das Original wird automatisch mit Bedingung `Nie` gesperrt, sonst liefen beide nebeneinander.

#### Zwei Fallen beim Kopieren

**Kein `table.deepcopy` auf der ganzen Tabelle.** `BuilderConditions` tragen in Feld 1
ganze Modultabellen (`EBC`, `UCBC`, `LUTL`); ein tiefes Kopieren wuerde die Module
mitkopieren. Stattdessen: Kopffelder flach, Bedingungen als neue Liste mit denselben
Tabellen (`Builder:Create` kopiert sie ohnehin je Manager tief).

**`BuilderData` muss dagegen tief kopiert werden.** `EngineerBuilder.Create`
(`sim\Builder.lua`) ueberschreibt darin `Construction.BuildStructures` - geteilt waere das
ein Fehler.

#### Erste zwei Anwendungen

| Kopie | Aenderung | warum |
|---|---|---|
| `Assist Mass - NoRush` | `LessThanEconMassStorageRatio { 60 }` entfernt, Prioritaet 740 -> 844, Instanzen 4 -> 6 | die Bedingung schaltete die Unterstuetzung genau dann ab, wenn das Lager voll war |
| `Mass Storage 600 - NoRush` | Instanzen 2 -> 4, Prioritaet 843 | mehr Ingenieure bauen die Speicher gleichzeitig |

Neue Ordnung: 845/846/850 nahe Extraktoren > **844 Assist** > 843 Speicher. Erst
Massepunkte besetzen, dann aufsteigen, dann Speicher.

#### Kraftwerksplan

| Stufe | Grenze | Begruendung des Nutzers |
|---|---|---|
| T1 | 20 | 16 umranden eine Fabrik, 32 waeren zu viel |
| T2 | 4 | |
| T3 | keine | ab dann ausschliesslich |

Die Deckel wirken nur, bis ein T3-Kraftwerk steht - danach schaltet LOUD T1 und T2 selbst
ab (`Loud_AI_Engineer_Energy_Builders.lua` Z. 46-58 und Z. 101-113).

**⚠ RISIKO:** `T3 Power Template` hat `BuilderType = {'T3','SubCommander'}`. Zwischen
"4 T2 erreicht" und "erster T3-Ingenieur" kann die KI **gar kein** Kraftwerk mehr bauen.
Bei Energiemangel in dieser Luecke die T2-Grenze anheben.

**Commit-Vorschlag:** `CustomAI: eigene Builder-Kopien; Kraftwerksplan 20/4/T3`

### Nachtrag 11: waehrend des ACU-Ausbaus alles andere zurueckstellen

- **Was:** Bedingung `KeinACUAusbau`; Bedingungen sind jetzt eine UND-Liste statt einer
  einzelnen; zwei ACU-T1-Verteidigungsbauer nachgetragen
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### ⚠️ Befund: die Prioritaet war beim ACU nie das Problem

`UEF CDR Upgrade` und die drei Fraktionsgeschwister stehen bei **850**
(`Loud_AI_ACU_Builders.lua` ab Z. 940). Die uebrigen ACU-Aufgaben liegen alle bei
**hoechstens 780** (`CDR - T1 Power` 780, `CDR - Mass Extractor` 775, `CDR Assist Energy`
780, alles andere darunter). **Der Ausbau gewinnt also ohnehin, sobald seine Bedingungen
erfuellt sind.** Und `ResourceAllocation` steht bei allen vier Fraktionen an erster Stelle
der `Enhancement`-Liste.

Die eigentlichen Bremsen sind die `BuilderConditions`:

```
{ MIBC, 'GreaterThanGameTime', { 420 } }                         -- nicht vor 7:00
{ EBC,  'GreaterThanEconStorageCurrent', { 300, 3600 }}
{ EBC,  'GreaterThanEconTrendEfficiencyOverTime', { 2, 75, 1.015, 1.025 }}
```

Eine Anhebung der Prioritaet waere wirkungslos gewesen. **Nichts angehoben.**

#### Was stattdessen gebaut wurde

Bedingung `KeinACUAusbau`: solange ein Kommandant `Upgrading` ist oder im Zustand
`Enhancing`, bleiben 24 BuilderGroups und 5 einzelne Bauer auf Prioritaet 10.

Die Erkennung laeuft ueber `aiBrain:GetListOfUnits( categories.COMMAND, false, true )`,
**mit Zwischenspeicher je Tick und Brain** - sonst liefe der Aufruf je umhuelltem Builder
und Auswahldurchlauf.

**Nicht gesperrt und damit weiterlaufend:** `Engineer Mass Builders`,
`Engineer Energy Builders`, `Engineer Tasks` (enthaelt `Assist ACU SACU` mit 740 - freie
Ingenieure gehen dem ACU helfen, weil ihnen nichts anderes uebrig bleibt) und `ACU Tasks`.

#### ⚠️ Das ist keine echte Pause

Die Engine verteilt Masse und Energie anteilig; **laufende Bauten laufen weiter**. Der
Eintrag verhindert nur, dass NEUE Aufgaben begonnen werden. Eine Fabrik mit einer Einheit
in der Schlange baut sie zu Ende.

#### Bedingungen sind jetzt eine UND-Liste

Vorher trug ein Builder genau eine Bedingung; ein zweiter Eintrag ueberschrieb sie still.
Das waere hier sofort aufgefallen - `Air Transport T2` traegt jetzt `TransporterFreigabe`
**und** `KeinACUAusbau`. `Sperren1` sammelt sie in einer Liste, die Umhuellung prueft alle.

#### Nachgetragen

`CDR T1 Base Defense - PD` (754) und `CDR T1 AA - Response - Small Maps` (700) - auch der
Kommandant baut T1-Verteidigung. Bei der letzten Runde uebersehen.

**Commit-Vorschlag:** `CustomAI: ACU-Ausbau hat Vorfahrt; Bedingungen als UND-Liste`

### Nachtrag 12: Testeintraege entfernt, KI umbenannt

- **Was:** `customai_standard`, `customai_small`, `customai_smaller` geloescht;
  `customai_norush` umbenannt zu `customai_aeon_air` /
  `AI: LOUD Aeon Airforce General`
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`, `mods\CustomAI.md`
- **Getestet:** nein

Die drei Testeintraege hatten ihren Zweck erfuellt: Testlauf 5 belegte, dass `Source`
umschaltbar ist und vier eigene KIs gleichzeitig laufen. Als Spielinhalte waren sie nie
gedacht.

**Der Phasenplan bleibt die Grundlage.** `Phasenplan()` ist eine lokale Funktion in
`AIDefinitions.lua`; jede weitere KI kann sie mit eigenen Anteilen aufrufen und ihre
eigenen `Kopien`, `BaseSettings` und Sonderregeln danebenstellen.

**Der Name ist bisher nur ein Name.** Das Verhalten ist unveraendert das der frueheren
NoRush-KI - es gibt noch keine Luftwaffenausrichtung und keine Fraktionsbindung.
Siehe `TODO.md`.

**Commit-Vorschlag:** `CustomAI: Testeintraege entfernt, KI heisst Aeon Airforce General`

### Nachtrag 13: Fraktion und Farbe in der Lobby vorbelegen

- **Was:** neuer Hook auf `/lua/ui/lobby/lobby.lua`; `LobbyFraktion` und `LobbyFarbe`
  in der Definition
- **Wo:** `usermods\CustomAI\hook\lua\ui\lobby\lobby.lua` (neu),
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

**Erster Eingriff in die UI-Schicht.** Bisher nur `simInit`, `aibrain` und
`defaultunits`. Die Lobby ist Netzwerkcode: der Host verteilt, alle Clients uebernehmen.

#### Warum die Parameter nicht reichen

`HostTryAddPlayer` nimmt `requestedFaction` entgegen, **ignoriert ihn aber**:
`lobby.lua` Z. 2329 setzt `Faction` unbedingt auf
`table.getn(FactionData.Factions) + 1`, also Zufall. Es bleibt nur, hinterher
nachzufassen.

#### Warum ueber `SetPlayerOption`

`gameInfo` ist eine **dateilokale** Variable (`lobby.lua` Z. 34) und aus einem Hook nicht
erreichbar - Hookdateien teilen sich die Globalen, nicht die Locals. `SetPlayerOption`
dagegen ist global (Z. 5241), schreibt in `gameInfo`, verteilt an alle Clients und ruft
`UpdateGame` auf. Mit `override = true` entfaellt die Besitzpruefung.

#### Werte

| Feld | Wert | Quelle |
|---|---|---|
| `LobbyFraktion` | 2 (Aeon) | Reihenfolge in `gamedata\lua\lua\factions.lua`: 1 UEF, 2 Aeon, 3 Cybran, 4 Seraphim |
| `LobbyFarbe` | `{252,252,252}` | Farbrad arbeitet mit 3-252 (`RandomColor` Z. 915) |

**`IsColorFree` wird bewusst uebergangen** - im Spielkreis sollen alle KIs weiss sein,
weil ein Mitspieler farbenblind ist. Doppelte Farben sind gewollt.

#### Bekannte Luecke

Bei `slot = -1` sucht `HostTryAddPlayer` selbst einen freien Platz und teilt ihn nicht
mit; ohne Zugriff auf `gameInfo` laesst sich die Nummer nicht ermitteln. Aus der
Slot-Auswahl (`lobby.lua` Z. 454) kommt immer eine echte Nummer, aus dem Netzwerkpfad
(Z. 4801) ebenfalls. **Ob die Fill-Slots-Funktion einen echten Slot uebergibt, ist
ungeprueft.**

**Commit-Vorschlag:** `CustomAI: Lobby belegt Fraktion Aeon und Farbe Weiss vor`

### Nachtrag 14: Luftwaffe, Teil 1 - Fabriken und Produktionsschwerpunkt

- **Was:** `FactoryCount` LAND 0 / AIR 8 / SEA 0; Land- und Marinefabrikbauer dauerhaft
  gesperrt; Gunships und ASF auf Boden 650; Aufklaerer auf Deckel 300
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Der Deckel allein haette nicht gereicht

`FactoryCount.LAND = 0` laesst `FactoryCapCheck` immer scheitern - aber
**`Land Factory Rebuild` prueft den Deckel gar nicht.** Seine Bedingungen sind nur
`GreaterThanEconStorageCurrent` und `FactoryLessAtLocation { 'LocationType', 1, LAND }`,
und seine `PriorityFunction` liefert 990, sobald keine Landfabrik da ist. Er ist deshalb
zusaetzlich mit `Nie` gesperrt, ebenso die Expansions- und Marinefassungen.

#### Alle Einheitenbauer standen bei 600

In `Loud_AI_Factory_Air_Builders.lua` haben Aufklaerer, Jaeger, Bomber, Gunships und
Torpedobomber **alle Prioritaet 600** - ein voellig flaches Feld. Es gab also gar keine
Rangfolge, die man haette verschieben koennen; erst Boden und Deckel erzeugen eine:

| Prioritaet | Bauer |
|---:|---|
| 650 | `Gunship T2/T3`, `Fighters T2`, `Fighters T2 Crossover`, `Fighters T3`, `Fighters T3 Advanced` |
| 600 | Bomber und Torpedobomber, unveraendert |
| 300 | `Air Scout T2/T3` |

#### ⚠️ Auf kleinen Karten haette diese KI gar keine Fabrik

Bis Kartengroesse 1024 baut der ACU ueber `CDR Initial Small Map` eine **Land**fabrik -
und die ist jetzt dauerhaft gesperrt, der Rebuild-Bauer ebenfalls. Auf 20k und 40k
greift `CDR Initial Large Map` mit einer Luftfabrik, dort passt es. Steht in `TODO.md`.

#### Teil 2 bewusst nicht gebaut

Schwaerme, Czar-Schwelle und Zielwahl liegen in den PlatoonFormBuildern und im
Angriffsplaner - einem Teilsystem, das bisher nicht untersucht war. Die Stellschrauben
sind gefunden und in `TODO.md` mit Fundstellen festgehalten; der Kopiermechanismus muss
dafuer erst um `BuilderData`-Aenderungen und ein Register fuer PriorityFunctions
erweitert werden.

**Commit-Vorschlag:** `CustomAI: reine Luftwaffe - keine Landfabriken, Gunships und ASF vorn`

### Nachtrag 15: Testlauf 7 - `IsUnitState` ist kein Global

- **Was:** Fehlerbehebung; KI umbenannt in `AI: LOUD Aeon Airforce`
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** Fehler im Log belegt, Behebung **ungeprueft**

#### ⚠️ Der Fehler

```
warning: Error running lua script: ...customai\lua\ai\ais\norush.lua(104):
         access to nonexistent global variable "IsUnitState"
```

`IsUnitState` ist **kein Global**. Richtig ist `moho.unit_methods.IsUnitState` - so
holen es sich `loudutilities.lua` Z. 70, `EngineerManager.lua` Z. 46 und
`aibehaviors.lua` Z. 76.

**Auswirkung:** die Umhuellung warf bei jedem Aufruf. Damit fielen alle **120 Builder**
der Phase "Waehrend ACU-Ausbau zurueckstellen" aus - darunter
`Factory Production - Engineers`. Die KI baute **gar keine Ingenieure mehr**.

Das ist derselbe Fehlertyp wie in Testlauf 1 (`_G.FOO` auf nicht gesetzte Globale).
Die Regel in `..\04_LUA_SIM.md` Abschnitt 2 galt bisher nur fuer Variablen - sie gilt
genauso fuer **Funktionen**, die man aus LOUD-Quelltext uebernimmt: dort sind sie
haeufig eine dateilokale Kopie aus `moho`, kein Global.

#### Die Behebung

`moho.unit_methods.IsUnitState` wird beim ersten Aufruf ueber `rawget(_G,'moho')`
aufgeloest. Faellt das aus, wird nur noch `u.Upgrading` geprueft und eine Warnung
ausgegeben - statt zu werfen.

Fuer den Kommandanten ist `Upgrading` ohnehin der belegte Weg: `aibehaviors.lua` Z. 156
prueft `(not cdr.Upgrading)`.

#### Umbenannt

`AI: LOUD Aeon Airforce General` war zu lang - der Nickname wird bei 24 Zeichen
beschnitten, im Log stand `AI: LOUD Aeon Airforce G`. Jetzt `AI: LOUD Aeon Airforce`
(22 Zeichen).

**`AI: LOUD` bleibt drin und muss drin bleiben** - ohne diesen Praefix im Nickname tritt
LOUD zurueck und startet gar keinen Plan. Belegt in Testlauf 2, siehe
`mods\CustomAI.md` Abschnitt 3.

**Commit-Vorschlag:** `CustomAI: IsUnitState aus moho holen; KI umbenannt`

### Nachtrag 16: Lobby-Vorbelegung verworfen und zurueckgebaut

- **Was:** Hook auf `/lua/ui/lobby/lobby.lua` entfernt, Felder `LobbyFraktion` und
  `LobbyFarbe` aus der Definition entfernt
- **Wo:** `usermods\CustomAI\hook\lua\ui\lobby\lobby.lua` nach
  `doc.claude\_ausrangiert\lobby.lua.ausrangiert` verschoben;
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** der Fehlschlag ist belegt, der Rueckbau nicht

#### Warum

Testlauf 7: der Hook wurde **nie geladen**. Weder eine `CUSTOMAI Lobby:`-Zeile noch ein
`Hooked /lua/ui/lobby/lobby.lua` im Log. Der Mod ist ab Z. 49 gemountet, aber alle Hooks
greifen erst beim Sitzungsstart (Z. 665, 721, 818) - **die Lobby laeuft davor**.
Auch die UI-Hooks fremder Mods erscheinen erst ab Z. 609 und betreffen In-Game-UI.

Einschaetzung des Nutzers: machbar vermutlich nur ueber einen Shadow-Mod, wie es die
Nomads-Fraktion macht. Nicht wichtig genug, also verworfen.

#### Was aus der Analyse gueltig bleibt

Festgehalten in `doc.claude\_ausrangiert\lobby.lua.ausrangiert`:

- `HostTryAddPlayer` nimmt `requestedFaction` entgegen, **ignoriert ihn aber** -
  `lobby.lua` Z. 2329 setzt die Fraktion unbedingt auf Zufall
- `gameInfo` ist dateilokal (Z. 34) und aus Hooks nicht erreichbar
- `SetPlayerOption` (Z. 5241) waere der richtige Weg gewesen: global, verteilt an alle
  Clients, `override = true` umgeht die Besitzpruefung
- Fraktionsnummern: 1 UEF, 2 Aeon, 3 Cybran, 4 Seraphim
- Farbe ist `{r,g,b}` mit Werten 3 bis 252

#### Verallgemeinerbare Regel

**Mod-Hooks greifen nur ab dem Sitzungsstart.** Alles, was in der Lobby oder im
Hauptmenue passieren soll, ist aus einem gewoehnlichen Usermod heraus nicht erreichbar.
Der einzige Code, der im Lobbykontext laeuft, ist `lua\AI\CustomAIs_v2\CustomAI.lua` -
von `enhancedlobby.lua` `GetAIList` importiert, aber in einer eigenen Umgebungstabelle.

**Commit-Vorschlag:** `CustomAI: Lobby-Vorbelegung verworfen`

### Nachtrag 17: Eroeffnung - Kraftwerke nach Bedarf, Speicher erst nach T2

- **Was:** zwei neue Bedingungen; Kraftwerksplan von festen Deckeln auf mitwachsende
  Grenzen umgestellt; Speicher bis zum vierten T2-Extraktor gesperrt
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

Anlass: Beobachtung aus Testlauf 7 - die Techniker bauten wieder, aber das Falsche.
Die T1-Extraktoren stiegen nicht auf T2 auf, stattdessen entstanden Speicher.

#### Warum der Prioritaetsboden allein nicht reichte

Speicher kosten Masse und druecken damit den **Massetrend** - und genau daran haengt
`SelfUpgradeThread`. Ein Speicher, der zu frueh gebaut wird, verzoegert also den
Aufstieg, den er beschleunigen soll. Eine Rangfolge ueber Prioritaeten reicht dagegen
nicht: sobald kein Extraktorplatz mehr frei ist, faellt der Ingenieur auf die
naechstniedrige Aufgabe zurueck - und das war der Speicher.

Deshalb jetzt eine echte Sperre: `MindestensT2Extraktoren = 4` auf
`Mass Storage 600 - NoRush`, `Mass Storage 1024`, `Mass Storage DP` sowie die Gruppen
`Engineer Mass Energy Construction` und `Engineer Energy Storage Construction`.

#### Kraftwerke wachsen jetzt mit

Der feste Deckel von 20 war der zweite Fehler. Der Aufstieg T1 -> T2 haengt auch am
**Energietrend** (`energylowtrigger 1.007` fuer T1-Extraktoren, `defaultunits.lua`
Z. 813). Zu wenig Energie heisst: die Extraktoren steigen nicht auf.

| Bedingung | Regel |
|---|---|
| `T1KraftwerkeNachBedarf` | Grundstock 6, dazu 4 je Extraktor ab Stufe 2 |
| `T2KraftwerkeImWechsel` | hoechstens so viele wie T3-Extraktoren plus 1 |

Bei 4 T1-Extraktoren sind das 6 T1-Kraftwerke; sind alle vier auf T2, sind es 22.
Die zweite Regel erzeugt die Abfolge Kraftwerk, Extraktor, Kraftwerk, Extraktor von
selbst - ohne dass irgendwo ein Zaehler mitlaufen muss.

`BedingungWert` darf jetzt auch eine Tabelle sein (`{ 6, 4 }`); die Werte werden
unveraendert an die Bedingungsfunktion durchgereicht.

#### Was schon passte

`FabrikAufstiegAbT2Extraktoren = 4` - die Fabrik geht auf Stufe 2, sobald alle vier
Extraktoren auf T2 sind. Das war seit Nachtrag 7 so und deckt sich mit der Vorgabe.

**Commit-Vorschlag:** `CustomAI: Eroeffnung - Kraftwerke nach Bedarf, Speicher erst nach T2`

### Nachtrag 18: Testlauf 8 - gesperrte Builder kamen nie zurueck

- **Was:** Fehlerbehebung in der Umhuellung
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`
- **Getestet:** Symptom belegt, Behebung **ungeprueft**

#### Das Symptom

Die vier Extraktoren gingen sauber auf T2 - und danach passierte nichts mehr. Keine
Speicher, obwohl die Bedingung `MindestensT2Extraktoren = 4` erfuellt war.
**Der Log war fehlerfrei**, kein Absturz, keine Warnung.

#### Die Ursache

Der `false`-Zweig aus Nachtrag 8. Er war fuer fremde KIs richtig gedacht: ein Builder
ohne eigene `PriorityFunction` soll sich verhalten, als gaebe es unsere Umhuellung nicht,
und `false` bewirkt genau das (`BuilderManager.lua` Z. 327 prueft
`if newPri and newPri != Priority`).

**Fuer Builder, die WIR vorher auf 10 gesetzt haben, ist das aber verhaengnisvoll.**
`false` heisst "nichts aendern". Sobald die Bedingung erfuellt war, gab die Umhuellung
also `false` zurueck - und der Builder blieb auf **10**. Fuer immer.

Die Bedingung war der einzige Weg zurueck, und sie hatte keinen.

#### Warum es nicht frueher auffiel

Builder **mit** eigener `PriorityFunction` waren nie betroffen: dort laeuft das Original
und liefert den Wert ohnehin neu. Betroffen war ausschliesslich die andere Haelfte -
und `Mass Storage 600` hat keine. Alle bisherigen Freigaben liefen ueber Builder mit
PriorityFunction oder wurden nie erreicht.

#### Die Behebung

Der `false`-Zweig greift jetzt nur noch, wenn **kein Eintrag fuer diesen Key** existiert -
also fuer fremde KIs und unbeteiligte Builder. Verwalten wir den Builder, wird
`self.Priority` aktiv zurueckgegeben, danach Deckel und Boden angewandt.

Damit bleibt die Zusicherung aus Nachtrag 8 erhalten (fremde KIs unberuehrt), und unsere
eigenen Sperren sind wieder umkehrbar.

#### Lehre

Eine Sperre ueber `10, true` braucht **immer** einen aktiven Rueckweg. Wer nur den
Hinweg baut, merkt es erst, wenn die erste Bedingung tatsaechlich umschlaegt - und dann
sieht es aus wie ein Wirtschaftsproblem, nicht wie ein Programmfehler.

**Commit-Vorschlag:** `CustomAI: gesperrte Builder aktiv wiederherstellen`

### Nachtrag 19: Technikerplan und Unterstuetzungsreihenfolge

- **Was:** vier neue Bedingungen fuer die Technikerzahlen; T2-Kraftwerke haengen jetzt
  an den T2-Technikern statt an den T3-Extraktoren; Reihenfolge der
  Unterstuetzungsaufgaben festgelegt
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Technikerplan

| Stufe | Regel | Bedingung |
|---|---|---|
| T1 | 2 Stueck, dazu 2 je Extraktor ab Stufe 2 | `T1TechnikerNachBedarf { 2, 2 }` |
| T2 | 2 je stehendem T2-Kraftwerk plus 2 Vorlauf | `T2TechnikerVorKraftwerk 2` |
| T3 | hoechstens 10, SCU nicht mitgezaehlt | `HoechstensT3Techniker 10` |
| SCU | der Rest, Deckel 20 in `BaseSettings` | - |

`BaseSettings.EngineerCount` steht jetzt auf 16/16/16 - bewusst grosszuegig, damit die
Rechnung im Phasenteil den Ausschlag gibt und nicht LOUDs `BelowEngineerCapCheck`.

#### Warum die T1-Kraftwerke zu viele waren

Die Ursache war **nicht** der Deckel, sondern die alte Regel
`T2KraftwerkeImWechsel`: sie erlaubte nur `T3-Extraktoren + 1` T2-Kraftwerke, also
anfangs genau **eins**. Die gesamte Energieversorgung musste damit ueber T1 laufen -
und LOUD baut so lange T1-Kraftwerke, wie sein eigener Energietrend unter 45 liegt
(`T1 Power Template`, `LessThanEnergyTrendOverTime { 45 }`).

Der Deckel von 6 + 4 je T2-Extraktor war nie die Bremse; er ist eine Obergrenze, keine
Vorgabe. Neu haengen die T2-Kraftwerke an den T2-Technikern
(`T2KraftwerkeNachTechnikern`), womit die Abfolge
**2 Techniker, 1 Kraftwerk, 2 Techniker, 1 Kraftwerk** entsteht und die Energie frueh auf
T2 umsteigt.

#### Was ein freier Techniker tut

Alle Unterstuetzungsaufgaben liegen im Original zwischen 720 und 750 - unter den
Bauaufgaben. Das bleibt so; geaendert wurde nur die Reihenfolge untereinander:

| Prioritaet | Aufgabe |
|---:|---|
| 848 | `Assist ACU SACU` - SCU-Ausbau, also RAS zuerst |
| 844 | `Assist Mass - NoRush` - Extraktoren und deren Aufstieg |
| 842 | `Assist Energy` - Kraftwerke |
| 838 | `T1/Eng Assist Structure/Exp` - alles Uebrige, darunter das Quantentor |

`Assist ACU SACU` steht damit ueber den mittleren Extraktorbauern (845/846) und knapp
unter den nahen (850) - bewusst: ein SCU im Ausbau ist die lohnendste Investition, die
die KI hat.

#### Nicht umgesetzt

"Die T2 Storages aktualisieren vor den T2 Extraktoren" - **unklar, was gemeint ist**.
Speicher haben in Supreme Commander keinen Aufstieg. Rueckfrage laeuft, steht in
`TODO.md`.

**Commit-Vorschlag:** `CustomAI: Technikerplan und Unterstuetzungsreihenfolge`

### Nachtrag 20: Technikerplan verschaerft

- **Was:** Obergrenze 10 je Stufe; T1 und T2 werden nicht mehr nachgebaut, sobald eine
  T3-Fabrik steht; T3 wird aktiv auf 10 aufgestockt
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Drei neue Bedingungen

| Name | Regel |
|---|---|
| `HoechstensT1Techniker` | weniger als n mobile T1-Techniker (ohne ACU) |
| `HoechstensT2Techniker` | weniger als n mobile T2-Techniker |
| `KeineT3Fabrik` | keine `FACTORY * TECH3` vorhanden |

`KeineT3Fabrik` liegt auf allen vier T1- und T2-Technikerbauern. Sobald die erste
T3-Fabrik steht, ist Schluss mit Nachbau der unteren Stufen. **Das Quantentor zaehlt
mit** - `Engineer T3 - Initial` hat `BuilderType = {'AirT3','LandT3','SeaT3','Gate'}`,
kann also auch dort gebaut werden.

#### T3 aktiv aufstocken

Eine Obergrenze allein reicht dafuer nicht. Im Original liegt nur
`Engineer T3 - Initial` bei 900 - und der baut wegen `UseBuilderOnce` **genau einmal**.
`Engineer T3 - Standard` und `- Extra` liegen bei **650**, also unter den
Einheitenbauern. Sie bekommen deshalb einen Prioritaetsboden von 900.

Damit stehen sie gleichauf mit `Sub Commander`. Ist die Zehnergrenze erreicht, sperrt
die Bedingung sie, und die SCU-Produktion laeuft allein weiter - genau die gewuenschte
Reihenfolge "hoechstens 10 T3, Rest SCU".

#### Zum Zusammenspiel

Mehrere Bedingungen an einem Builder werden **UND**-verknuepft (seit Nachtrag 11). Die
T1-Techniker tragen jetzt drei: die Bedarfsrechnung, die Zehnergrenze und `KeineT3Fabrik`.
Die strengste gewinnt automatisch.

**Commit-Vorschlag:** `CustomAI: Techniker - 10 je Stufe, kein T1/T2 nach der T3-Fabrik`

### Nachtrag 21: Massespeicher steigen auf - Korrektur und Sperre

- **Was:** Hook auf `defaultunits.lua` umgebaut; neue Regel
  `SpeicherAufstiegAbT3Extraktoren`
- **Wo:** `usermods\CustomAI\hook\lua\defaultunits.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### ⚠️ KORREKTUR: Massespeicher haben sehr wohl einen Aufstieg

Ich hatte behauptet, Speicher haetten in Supreme Commander keinen Aufstieg. **Falsch.**
Geprueft in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\units\units\UAB1106\UAB1106_unit.bp`
Z. 90: `UpgradesTo = 'uab2106'`.

Gestartet wird der Aufstieg vom **Auffangzweig** in `defaultunits.lua` Z. 877-883:

```lua
-- pick up any structure that has an upgrade not covered by above
if __blueprints[finishedUnit.BlueprintID].General.UpgradesTo != '' and not finishedUnit.UpgradeThread then
    ... SelfUpgradeThread( ..., 1.01, 1.03, 9999, 9999, 36, 300, false, ... )
end
```

Die namentlich behandelten Faelle sind Fabriken, Kraftwerke, Hydrokarbon, Extraktoren,
Massefabrikatoren, Schilde und Aufklaerung. Speicher fallen in den Auffangzweig - deshalb
hatte ich sie beim ersten Lesen uebersehen.

#### Die Sperre

`SpeicherAufstiegAbT3Extraktoren = 4`: der Speicheraufstieg beginnt erst, wenn vier
Extraktoren auf Stufe 3 stehen. Vorher nimmt er den Extraktoraufstiegen die Masse weg -
genau die Beobachtung des Nutzers.

#### Zwei Klassen, zwei Gruende

Der Hook umhuellt jetzt **beide** Klassen:

| Klasse | warum |
|---|---|
| `FactoryUnit` | `FactoryUnit = Class(StructureUnit)` steht in Z. 2046 und wird beim Laden der Datei ausgewertet - ein Hook auf `StructureUnit` erreicht Fabriken nicht mehr |
| `StructureUnit` | Massespeicher leiten sich erst beim Laden der Einheitenskripte ab (`UAB1106_script.lua` Z. 1 importiert `StructureUnit`), also **nach** unserem Hook |

Die `StructureUnit`-Umhuellung liegt damit auf allen uebrigen Strukturen. Sie greift
deshalb nur bei `MASSSTORAGE` und reicht sonst unveraendert durch.

#### Nicht relevant

LOUD Integrated Storage ist nicht aktiv, Massefabrikatoren sind ausgeschaltet. Die
Gruppen `Engineer Mass Energy Construction` und die Fabrikatorbauer bleiben trotzdem in
den Listen - sie schaden nicht und greifen, falls sich das aendert.

**Commit-Vorschlag:** `CustomAI: Speicheraufstieg erst nach den Extraktoren`

### Nachtrag 22: Speicher vor dem T3-Aufstieg; T2-Kraftwerke entkoppelt

- **Was:** neue Regel `ExtraktorAufstiegT3AbSpeichern`; T2-Kraftwerke wieder an eine
  schlichte Obergrenze statt an die Technikerzahl
- **Wo:** `usermods\CustomAI\hook\lua\defaultunits.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### ⚠️ Warum nur ein T2-Kraftwerk entstand

Die Regel aus Nachtrag 19 (`T2KraftwerkeNachTechnikern`, ein Kraftwerk je zwei
T2-Techniker) sah sauber aus, war aber an eine Zahl gekoppelt, die kaum waechst:

`Engineer T2 - Standard` traegt
`PoolLessAtLocation { 'LocationType', 1, MOBILE * ENGINEER * TECH2 }`
(`Loud_AI_Factory_Engineer_Builders.lua` Z. 161) - er baut also **nur nach, wenn kein
T2-Techniker untaetig im Pool liegt**. Solange die vorhandenen beschaeftigt sind,
entsteht hoechstens einer nach.

Mit zwei bis drei T2-Technikern ergab `floor(Techniker / 2)` genau **ein** Kraftwerk -
und weil die Techniker wiederum an den Kraftwerken hingen, hielten sich beide
gegenseitig fest.

**Jetzt entkoppelt:** T2-Kraftwerke haben eine schlichte Obergrenze von 4
(`WenigerAlsT2Kraftwerke`). Die Technikerregel haengt weiterhin an den Kraftwerken,
aber nicht mehr umgekehrt.

**Lehre:** eine Regel, die zwei Groessen wechselseitig aneinander bindet, laeuft nur
an, wenn mindestens eine von aussen waechst. Sonst ist der Anfangszustand ein
Gleichgewicht.

#### Speicher vor dem T3-Aufstieg

Neue Regel `ExtraktorAufstiegT3AbSpeichern = 16` - vier Speicher je Extraktor. Damit
steht die Adjazenz, bevor die Extraktoren weitersteigen. Der Schritt T1 -> T2 bleibt
frei; nur die Stufe 2 wird gebremst.

Die drei Aufstiegsregeln ergeben zusammen:

| | Schritt | Bedingung |
|---|---|---|
| 1 | Extraktoren auf T2 | frei |
| 2 | T1-Speicher rundherum | ab 4 Extraktoren auf T2 (Builder-Sperre) |
| 3 | Extraktoren auf T3 | ab 16 Massespeichern |
| 4 | Speicher auf T2 | ab 4 Extraktoren auf T3 |

**Commit-Vorschlag:** `CustomAI: Speicher vor T3-Extraktoren; T2-Kraftwerke entkoppelt`

### Nachtrag 23: Umbauung je Extraktor pruefen statt armeeweit zaehlen

- **Was:** `ExtraktorAufstiegT3AbSpeichern = 16` ersetzt durch
  `ExtraktorAufstiegT3ErstVollUmbaut = true`
- **Wo:** `usermods\CustomAI\hook\lua\defaultunits.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Warum die armeeweite Zahl falsch war

Eine feste Zahl von 16 Speichern setzt voraus, dass an jedem der vier Massepunkte auch
vier Speicher hinpassen. Liegt ein Punkt am Wasser, am Hang oder neben einem fremden
Gebaeude, wird die Zahl nie erreicht - und **alle** Extraktoren blieben auf Stufe 2
haengen. Derselbe Blockadetyp wie bei den T2-Kraftwerken in Nachtrag 22.

#### Die Pruefung

Jetzt je Extraktor an seinen vier Nachbarplaetzen. Die Versaetze stehen in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBuilders\Loud_MAIN_base_templates.lua`
Z. 2739-2776 (`MassAdjacency`) und sind bei allen vier Fraktionen gleich:
`{-2,0}, {2,0}, {0,-2}, {0,2}`.

| Zustand des Platzes | Bewertung |
|---|---|
| Speicher steht | erledigt |
| frei **und** baubar | noch nicht fertig, Aufstieg wartet |
| frei und **nicht** baubar | zaehlt als erledigt |

Damit gilt genau die Vorgabe: jeder Extraktor darf aufsteigen, sobald er maximal umbaut
ist - und ein unbaubarer Platz haelt nichts auf.

#### Verwendete Methoden

| Aufruf | Beleg |
|---|---|
| `aiBrain:CanBuildStructureAt( bp, position )` | `EconomyBuildConditions.lua` Z. 214 und 251 |
| `aiBrain:GetNumUnitsAroundPoint( cat, pos, radius, 'Ally' )` | `UnitCountBuildConditions.lua` Z. 377 |

Speicher-Blueprints je Fraktion: `ueb1106`, `uab1106`, `urb1106`, `xsb1106` - alle vier
Verzeichnisse unter `gamedata.entpackt\units\units\` geprueft. Bei unbekannter
Fraktionsnummer, etwa aus einem Fraktionsmod, wird **nicht** blockiert.

**Commit-Vorschlag:** `CustomAI: Extraktoraufstieg je Extraktor pruefen`

### Nachtrag 24: Wartezeit untaetiger Techniker gekuerzt

- **Was:** neuer Hook auf `/lua/sim/EngineerManager.lua`; Feld
  `TechnikerWartezeitFehlschlaege`
- **Wo:** `usermods\CustomAI\hook\lua\sim\EngineerManager.lua` (neu),
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Wie LOUD die Wartezeit rechnet

`EngineerManager.lua` Z. 391-399:

```lua
DelayAssignEngineerTask = function( self, unit, aiBrain )
    local delay = LOUDMIN( 101, 14 + ((unit.failedbuilds or 0) * 5))
    ...
    WaitTicks( delay )
```

`failedbuilds` waechst um 1, sooft kein Auftrag gefunden wurde (Z. 304 und Z. 379), und
wird auf 0 zurueckgesetzt, sobald einer gefunden ist (Z. 316).

Grundwert 14 Ticks, also 1,4 Sekunden. Nach rund **18 vergeblichen Anlaeufen** sind es
101 Ticks - **gut zehn Sekunden**. Genau so lange steht ein Techniker dann noch herum,
nachdem wieder etwas zu tun waere.

**Bei dieser KI faellt das besonders auf**, weil viele Auftraege an Bedingungen haengen.
Der Techniker findet reihenweise nichts, `failedbuilds` klettert auf den Hoechstwert -
und wenn eine Sperre faellt, merkt er es erst zehn Sekunden spaeter.

#### Der Eingriff

Statt die Funktion nachzubauen, wird nur `failedbuilds` gedeckelt, bevor das Original
laeuft. Die Formel bleibt LOUDs:

| Deckel | Wartezeit hoechstens |
|---:|---|
| 0 | 14 Ticks (1,4 s) |
| **2** | **24 Ticks (2,4 s)** |
| 6 | 44 Ticks (4,4 s) |

`failedbuilds` wird sonst nirgends gelesen - geprueft in `EngineerManager.lua` und
`aibehaviors.lua` -, der Deckel hat also keine Nebenwirkung.

#### ⚠️ Was das nicht loest

Die Wartezeit ist im Original **Absicht**: "Delays him before seeking a new task to
avoid thrashing the EM". Kuerzere Wartezeiten heissen mehr Suchlaeufe und mehr
Rechenzeit.

Und sie ist nur die halbe Ursache. Ein Techniker, der herumsteht, hat in aller Regel
schlicht **keine Aufgabe** - und daran aendert haeufigeres Fragen nichts. Der Gewinn
liegt im Moment des Umschlagens: wenn eine Bedingung erfuellt wird, reagiert die KI
jetzt nach 2,4 statt nach 10 Sekunden.

Ob Techniker daneben auch **sinnlos umherfahren**, ist eine andere Frage - die liegt
in `AssignEngineerTask` und den `EngineerBuildAI`-Zielpunkten und ist **nicht
untersucht**. Der Debug-Schalter `EngineerDialog` protokolliert je Techniker, welche
Aufgabe er bekommt und wie lange er wartet.

**Commit-Vorschlag:** `CustomAI: Wartezeit untaetiger Techniker gekuerzt`

### Nachtrag 25: Blueprint nachschlagen statt fest eintragen; Wartezeit zeitabhaengig

- **Was:** Speicher-Blueprint kommt jetzt aus `buildingTemplates.lua`; der
  Technikerdeckel gilt nur bis zum Ende der No-Rush-Frist
- **Wo:** `usermods\CustomAI\hook\lua\defaultunits.lua`,
  `usermods\CustomAI\hook\lua\sim\EngineerManager.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### ⚠️ Feste Blueprint-IDs waren ein Fehler

Die Tabelle `{ 'ueb1106', 'uab1106', 'urb1106', 'xsb1106' }` haette gebrochen, sobald
eine Fraktion dazukommt - und Fraktionsmods sind bei LOUD ueblich. Der
Fallback "unbekannte Fraktion, nicht blockieren" haette den Fehler zusaetzlich
**still** gemacht: die Extraktoren waeren einfach ohne Speicher aufgestiegen.

Richtig ist die Nachschlagetabelle, die das Spiel selbst benutzt:

```lua
-- lua\buildingTemplates.lua
BuildingTemplates[FactionIndex] = { ... { 'MassStorage', 'uab1106' }, ... }
```

Zeilen 40, 147, 252 und 354 fuer die vier Grundfraktionen. Eine neue Fraktion bringt
ihren eigenen Block mit - damit stimmt der Blueprint automatisch. Genau so loest
`EngineerBuilder.Create` in `lua\sim\Builder.lua` seine `BuildStructures` auf.

#### Warum nicht ein anderes Gebaeude gleicher Groesse

Die Ueberlegung lag nahe, taugt aber nicht: `CanBuildStructureAt` prueft neben dem
Platzbedarf auch Bauzonen und Gelaendeneigung, und die koennen sich je Gebaeudetyp
unterscheiden. Eine Wand als Stellvertreter waere eine Naeherung mit unbekanntem
Fehler. Der echte Speicher ist die einzige ehrliche Probe.

#### Wartezeit jetzt zeitabhaengig

Neues Feld `TechnikerWartezeitBis = 'NoRush'`. Der Deckel auf `failedbuilds` gilt nur,
solange die No-Rush-Frist laeuft; danach greift LOUDs Original.

Begruendung: waehrend der Frist hat die KI wenige Techniker und keine Aussenposten -
da kostet haeufiges Suchen nichts. Spaeter, mit vielen Technikern und mehreren Basen,
ist LOUDs Bremse gegen das Durchpfluegen des Managers berechtigt.

Der Hook liest `ScenarioInfo.Options.NoRushOption` selbst; bei `'Off'` ergibt sich 0
und der Deckel entfaellt ganz. Statt `'NoRush'` ist auch eine feste Sekundenzahl
moeglich.

**Commit-Vorschlag:** `CustomAI: Blueprint aus buildingTemplates; Wartezeit zeitabhaengig`

### Nachtrag 26: Testlauf 9 - vier Ursachen gefunden

- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** die Ursachen sind belegt, die Behebungen **nicht**

#### 1. Drei statt zwei T1-Techniker

`GetCurrentUnits` zaehlt nur **fertige** Einheiten. Eine Obergrenze wird damit erst
falsch, wenn das ueberzaehlige Stueck fertig ist - die Fabrik hat es da laengst begonnen.

Neue Hilfsfunktion `Zaehle` mit `GetListOfUnits( cat, false, false )`, also
einschliesslich angefangener Bauten. **Alle Obergrenzen** benutzen sie jetzt; die
Untergrenzen (`MindestensT2Extraktoren`) bleiben bei `GetCurrentUnits` - ein Extraktor,
der gerade erst aufsteigt, foerdert noch nichts.

#### 2. Niemand half beim T1->T2-Aufstieg, beim T3-Aufstieg schon

Nicht die Prioritaet, sondern die zweite Bedingung von `Assist Mass`
(`Loud_AI_Engineer_Task_Builders.lua` Z. 286):

```lua
{ EBC, 'GreaterThanEconStorageCurrent', { 150, 2500 }}
```

**2500 gelagerte Energie.** Zu Spielbeginn steht noch kein Kraftwerk - die Schwelle wird
nie erreicht. Erst spaeter, rechtzeitig zum T3-Aufstieg. Genau das Beobachtete.

Dafuer kann eine Kopie jetzt Bedingungen **umparametrieren** statt nur zu streichen:
neues Feld `BedingungWerte` ersetzt die Argumentliste, das Modul bleibt. `AIDefinitions.lua`
bleibt datenrein. Neuer Wert `{ 50, 200 }`.

#### 3. T2->T3-Aufstieg ohne Speicher, auch an Aussenposten

**Architekturfehler im Kopiermechanismus.** Unsere Kopien haengen nur am MAIN-Template;
Aussenposten benutzen LOUDs `Loud_Expansion_*`. Die automatische Sperre des Originals
wirkt aber **armeeweit** - damit war `Mass Storage 600` an Aussenposten komplett weg,
und `Assist Mass` ebenso.

Beide Kopien tragen jetzt `OriginalSperren = false`. An MAIN laufen Original und Kopie
nebeneinander (harmlos, `InstanceCount` begrenzt jede fuer sich), der Aussenposten
behaelt LOUDs Fassung. Das Original `Mass Storage 600` ist dafuer in die Phasensperre
"Speicher erst ab 4 Extraktoren auf T2" aufgenommen.

#### 4. Air Staging vor dem Ende der Frist

`Air Staging T1/T2` und die Small-Base-Fassungen sind jetzt auf `Anteil = 1.0` gesetzt,
kommen also fruehestens mit Ablauf der No-Rush-Frist.

#### ⚠️ Warum das Quantentor nicht kam - keine Behebung, nur der Befund

`Loud_AI_Engineer_Factory_Builders.lua` Z. 726ff:

```lua
{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
{ EBC,  'GreaterThanEconStorageCurrent', { 400, 5000 }},
BuilderType = { 'T3','SubCommander' },
```

**12600 Energieeinkommen.** Vier T2-Kraftwerke liefern rund 2000. Das Tor braucht also
T3-Kraftwerke, die wiederum T3-Techniker brauchen, die eine T3-Fabrik brauchen. Der
Prioritaetsboden von 855 aus Nachtrag 19 ist an dieser Stelle **wirkungslos** - die
Bedingung ist der Engpass, nicht die Rangfolge.

Ob die Kette in der Praxis durchlaeuft, muss der naechste Lauf zeigen. Falls nicht, ist
der T2-Kraftwerksdeckel von 4 der erste Verdaechtige.

**Commit-Vorschlag:** `CustomAI: Zaehlung, Assist-Schwelle, Aussenposten-Speicher, Air Staging`

### Nachtrag 27: Quantentor - Spielregel gegen Bauregel verwechselt

- **Was:** Kopie `Quantum Gate - NoRush` mit gelockerter Energieschwelle
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### ⚠️ Meine Aussage war falsch

Ich hatte geschrieben, das Tor "braucht T3-Kraftwerke". Das stimmt nicht.
**Das Spiel verlangt gar nichts** - `GreaterThanEnergyIncome { 12600 }` ist eine
**Bauregel von LOUDs KI**, keine Voraussetzung des Gebaeudes. Ein menschlicher Spieler
baut das Tor, sobald er es bezahlen kann.

Damit ist es genau der Fall, fuer den der Kopiermechanismus da ist.

#### Die Zahlen zur Einordnung

`GreaterThanEnergyIncome` rechnet `GetEconomyIncome(aiBrain,'ENERGY') * 10`
(`loudutilities.lua` Z. 119-121), also Energie je **Sekunde**.

| Quelle | Energie/s | Beleg |
|---|---:|---|
| Aeon-ACU mit RAS | 2700 | `UAL0001_unit.bp` Z. 490 |
| dieselbe Stufe 2 | 5400 | Z. 512 |
| T2-Kraftwerk | 500 | `UAB1201_unit.bp` Z. 149 |
| T1-Kraftwerk | 20 | `UAB1101_unit.bp` Z. 95 |

ACU mit RAS plus vier T2-Kraftwerken sind rund **4700/s**. LOUDs Schwelle von 12600
setzt damit faktisch T3-Kraftwerke voraus - was fuer LOUDs eigene Spielweise sinnvoll
sein mag, aber nicht zu einer KI passt, die frueh auf Tor und SCU setzt.

#### Die Kopie

`Quantum Gate - NoRush`, Schwelle auf **2500/s** - erreichbar allein mit dem RAS des
Kommandanten. `BuilderType = {'T3','SubCommander'}` bleibt unveraendert: ein
T3-Techniker muss es bauen. Das Original wird automatisch gesperrt (hier unbedenklich,
weil `Engineer Quantum Gate Construction` nur am MAIN-Template haengt; die Fassungen
`- Small Base` und `- Expansion` sind eigene Builder und unberuehrt).

#### Lehre

Bei jeder Bedingung, die als Hindernis auffaellt, zuerst fragen: **Spielregel oder
Bauregel?** Blueprint-Felder wie `UpgradesTo` oder `BuildableCategory` sind Spielregeln
und nicht verhandelbar. Alles in `BuilderConditions` ist LOUDs Meinung - und die duerfen
wir fuer unsere KI aendern.

**Commit-Vorschlag:** `CustomAI: Quantentor mit gelockerter Energieschwelle`

### Nachtrag 28: Testlauf 10 - die Platoon-Vorlage bestimmt die Stueckzahl

- **Was:** Kopiermechanismus kann jetzt auch die Platoon-Vorlage kopieren und die
  Squadgroesse kappen; Kopie `Engineer T1 - Initial - NoRush`
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### ⚠️ Warum drei Techniker trotz Obergrenze zwei

Die Zaehlung aus Nachtrag 26 war richtig und trotzdem wirkungslos. Die Stueckzahl steht
gar nicht im Builder, sondern in seiner **Platoon-Vorlage**:

```lua
-- lua\AI\PlatoonTemplates\Loud_AI_Factory_Platoons.lua Z. 27
PlatoonTemplate { Name = 'T1BuildEngineerInitial',
    FactionSquads = {
        Aeon = { { 'ual0105', 1, 3, 'Support', 'none' } },
```

Das dritte Feld ist die **Hoechstzahl je Auftrag**. `Engineer T1 - Initial` erzeugt also
drei Techniker auf einen Schlag. Eine Bedingung wird **einmal vor dem Auftrag** geprueft -
sie kann eine bereits laufende Dreierbestellung nicht mehr halbieren.

Zum Vergleich: `T1BuildEngineer` (fuer `Engineer T1 - Standard`) steht auf `1, 1`.

#### Neues Feld `PlatoonMax`

Eine Kopie kopiert damit auch die Vorlage, kappt in jeder Squadzeile das dritte Feld und
traegt die neue Vorlage unter eigenem Namen ein. `PlatoonTemplate{}` schreibt nach
`PlatoonTemplates[name]` (`lua\system\GlobalPlatoonTemplate.lua`) - derselbe Baustein
wie `Builder{}` und `BuilderGroup{}`, ebenfalls im simInit-Fenster verfuegbar.

`Engineer T1 - Initial - NoRush` mit `PlatoonMax = 2`, `Gruppentyp = 'FactoryBuilder'`.

#### Lehre

Drei Ebenen bestimmen, was am Ende gebaut wird, und sie greifen an verschiedenen
Stellen:

| Ebene | bestimmt | wann geprueft |
|---|---|---|
| `BuilderConditions` / unsere Bedingungen | **ob** ein Auftrag beginnt | einmal, vor dem Auftrag |
| `Priority` | **welcher** Auftrag gewinnt | bei jeder Auswahl |
| `PlatoonTemplate` | **wie viele** Einheiten der Auftrag umfasst | beim Auftrag |

Eine Obergrenze auf Ebene 1 kann eine Stueckzahl auf Ebene 3 nicht korrigieren.

#### Offen: Unterstuetzung beim Kraftwerksbau

`Assist Energy` steht bei uns auf Boden 842 und traegt
`GreaterThanEconStorageCurrent { 250, 500 }` - deutlich milder als die 2500 bei
`Assist Mass`, sollte also fruehzeitig greifen. Ausserdem verlangt es
`BuildingGreaterAtLocationAtRange { ..., 105 }`: es muss ueberhaupt **etwas im Bau**
sein, das unterstuetzt werden kann.

**Warum die Techniker stattdessen zu entfernten Massepunkten laufen, ist aus dem
Quelltext nicht mehr zu klaeren.** Naechster Schritt sind die Debug-Schalter
`EngineerDialog` und `PriorityDialog` in `aibrain.lua` - sie protokollieren je Techniker,
welche Aufgabe er mit welcher Prioritaet bekommt. Steht in `TODO.md`.

**Commit-Vorschlag:** `CustomAI: PlatoonMax - Squadgroesse der Anfangstechniker`

### Nachtrag 29: Testlauf 11 - der Unterstuetzungsradius von 120

- **Was:** zwei neue Kopierfelder (`BedingungArgAendern`, `BuilderDatenWerte`);
  Unterstuetzungsradius von `Assist Mass - NoRush` auf 300
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein** - der Befund ist belegt, der Zusammenhang zur Beobachtung
  ist eine **Vermutung**

#### Bestaetigt: nur noch zwei Anfangstechniker

`PlatoonMax = 2` wirkt. Nachtrag 28 erledigt.

#### Der wahrscheinliche Grund fuer die fehlende Unterstuetzung

`Assist Mass` (`Loud_AI_Engineer_Task_Builders.lua` Z. 299):

```lua
{ UCBC, 'BuildingGreaterAtLocationAtRange',
  { 'LocationType', 0, MASSPRODUCTION - TECH1, ENGINEER + MASSPRODUCTION, 120 }}
```

Das letzte Argument ist ein **Radius um den Basispunkt**. Steht der aufsteigende
Extraktor weiter als 120 entfernt, ist die Bedingung falsch - aus Sicht des Builders
gibt es nichts zu unterstuetzen. Auf grossen Karten liegen die Massepunkte regelmaessig
weiter weg; im Bild des Nutzers lagen sie an den Kartenecken.

Dieselbe Zahl steht ein zweites Mal in `BuilderData.Assist.AssistRange` - selbst wenn
die Bedingung greift, sucht `EngineerAssistAI` nur innerhalb dieses Radius.

**Das erklaert vermutlich beide Beobachtungen auf einmal:** weil die Unterstuetzung nie
greift, faellt der Techniker auf die naechstniedrige Aufgabe zurueck - und das sind die
entfernten Massextraktoren (760/755). Der "in die Gegend fahrende" Techniker waere dann
kein eigener Fehler, sondern die Folge.

Beides auf **300** gesetzt.

#### Zwei neue Kopierfelder

| Feld | Zweck |
|---|---|
| `BedingungArgAendern` | einzelne Argumente einer Bedingung ueber ihre Position aendern |
| `BuilderDatenWerte` | Felder in `BuilderData` ueberschreiben, zwei Ebenen tief |

`BedingungArgAendern` war noetig, weil in der Argumentliste von
`BuildingGreaterAtLocationAtRange` **Kategorieobjekte** stehen. Ein vollstaendiger
Ersatz der Liste (`BedingungWerte`) haette diese in `AIDefinitions.lua` erfordert - und
die Datei muss datenrein bleiben, weil auch die Lobby-UI sie liest und dort kein
`categories` existiert. Ueber die Position laesst sich die eine Zahl aendern, ohne die
Kategorien anzufassen.

#### Falls es nicht reicht

Dann bleibt nur noch, im Spiel mitzulesen. `EngineerDialog` und `PriorityDialog` in
`aibrain.lua` protokollieren je Techniker die zugewiesene Aufgabe und jede
Prioritaetsaenderung. Bisher wurde ausschliesslich aus dem Quelltext geschlossen -
dieser Befund ist der dritte in Folge, bei dem eine Zahl tief in einer Bedingung die
Ursache war.

**Commit-Vorschlag:** `CustomAI: Unterstuetzungsradius auf 300`

### Nachtrag 30: Warum nicht das naechste Massefeld - `MaxChoices`

- **Was:** zwei Kopien der Extraktorbauer mit `MaxChoices = 1`
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Die Antwort

LOUD staffelt den Extraktorbau nach Entfernung zur Basis, mit fallender Prioritaet:

| Bauer | Prio | Bereich | `MaxChoices` |
|---|---:|---|---:|
| `Mass Extractor T1 - 250` | 850 | 0-250 | - (nur der naechste) |
| `- 750 - Loop - BuildClose` | 846 | 200-750 | **4** |
| `- 750 - Loop` | 845 | 200-750 | - |
| `- 1500 - Loop` | 760 | 300-1500 | **6** |
| `- 1500 - Loop - Extra` | 755 | 300-1500 | - |

Die naechste Staffel wird also durchaus bevorzugt. Innerhalb einer Staffel aber gilt
(`Loud_AI_Engineer_Mass_Builders.lua` Z. 189):

```lua
MaxChoices = 6,   -- pick from list of up to 6 closest
```

**LOUD waehlt zufaellig aus den sechs naechstgelegenen freien Punkten.** Das streut die
Basis absichtlich - sinnvoll gegen berechenbare Bauplaetze, falsch fuer eine KI, die
frueh Masse braucht.

`MaxChoices = 1` in beiden Kopien: immer der naechste.

#### Warum die Techniker ueberhaupt weit laufen

Weil auf dieser Karte im 250er-Bereich um die Basis kein freier Massepunkt liegt.
`CanBuildOnMassAtRange { 'LocationType', 0, 250, ... }` ist dann falsch, der 850er-Bauer
faellt aus, und es bleibt die 1500er-Staffel. Der Techniker geht also **nicht** an einem
naeheren Punkt vorbei - es gibt keinen. Er sucht sich nur bisher einen der sechs
naechsten statt des naechsten.

#### ⚠️ Beide Beobachtungen bleiben offen

"Einer faehrt raus, einer steht dumm rum" ist damit **nicht** erklaert. Der Radius von
300 aus Nachtrag 29 hat offenbar nicht gereicht.

Ab hier sind es reine Laufzeitfragen: welche Aufgabe bekommt ein Techniker, mit welcher
Prioritaet, und warum faellt die Unterstuetzung durch. Weitere Schluesse aus dem
Quelltext waeren Raten. **Naechster Schritt sind die Debug-Schalter** `EngineerDialog`
und `PriorityDialog` in `aibrain.lua`.

**Commit-Vorschlag:** `CustomAI: Extraktoren zum naechsten Punkt (MaxChoices 1)`

### Nachtrag 31: Diagnose statt Vermutung - Debug-Schalter eingebaut

- **Was:** `DebugSchalter` in der Definition, ausgewertet vom aibrain-Hook
- **Wo:** `usermods\CustomAI\hook\lua\aibrain.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Warum

Vier Runden hintereinander wurde eine Ursache allein aus dem Quelltext gefunden - und
jedes Mal erst, nachdem die vorherige Vermutung falsch war:

| Runde | vermutet | tatsaechlich |
|---|---|---|
| 26 | Prioritaet zu niedrig | `GreaterThanEconStorageCurrent { 150, 2500 }` |
| 28 | Obergrenze wirkt nicht | Platoon-Vorlage baut 3 auf einmal |
| 29 | Bedingung zu streng | Radius 120 um den Basispunkt |
| 30 | falsche Staffel | `MaxChoices = 6`, Zufall aus den sechs naechsten |

Die Startbauordnung ist der wichtigste Teil dieser KI. Weiter zu raten kostet je
Irrtum einen Testlauf.

#### Was jetzt im Log steht

| Schalter | zeigt |
|---|---|
| `EngineerDialog` | welcher Techniker welche Aufgabe bekommt - und wann keine |
| `PriorityDialog` | jede Prioritaetsaenderung mit altem und neuem Wert |
| `StructureUpgradeDialog` | jeder Aufstieg mit Ausloeser und Schwelle |
| `NameEngineers` | benennt die Techniker im Spiel, damit man sie im Bild wiedererkennt |

`PriorityDialog` beantwortet die derzeit wichtigste offene Frage: **kommen unsere
Boeden und Deckel ueberhaupt an?** Steht dort nie eine 844 fuer
`Assist Mass - NoRush`, liegt der Fehler in der Umhuellung und nicht in den
Bedingungen - dann waren die letzten drei Nachtraege am falschen Ende angesetzt.

#### Umsetzung

Die Schalter sind Felder in `ScenarioInfo`, gesetzt am Kopf von `/lua/aibrain.lua`
Z. 13-74. Sie gelten **fuer die ganze Partie**, nicht je KI - in einem Testspiel mit
nur unserer KI unerheblich. Der Hook setzt sie nach dem Laden der Definitionen.

**⚠ Vor dem naechsten normalen Spiel wieder abschalten** - der Log waechst erheblich.

**Commit-Vorschlag:** `CustomAI: Debug-Schalter fuer die Startbauordnung`

### Nachtrag 32: Testlauf 13 - die Techniker warteten auf einen Transport, den es nicht gab

- **Was:** `Air Transport T1` wieder freigegeben
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** die Ursache ist **im Log belegt**, die Behebung nicht

#### Der Befund

Die Debug-Schalter haben die Frage in einem Lauf beantwortet:

```
MAIN Eng 1048578 EM T1 adding "Mass Extractor T1 - 250" on tick 420
MAIN Eng 1048578 Mass Extractor T1 - 250 calls for transport - count is 12 failed moves is 0
... dieselbe Zeile zwoelf Mal, bis zum Ende des Laufs
```

Beide T1-Techniker bekamen **genau einen** Auftrag - auf Tick 420 und 540 - und hingen
danach bis zum Ende fest. Kein weiteres `adding` fuer sie im ganzen Log.

Ursache in `platoon.lua` Z. 8614-8621:

```lua
if count == 12 or eng.failedmoves > 2 then
    if (distance > 160 or eng.failedmoves > 0) and not LOUDENTITY( COMMANDER, eng ) then
        ... calls for transport
```

Ist der Bauplatz nach zwoelf Bewegungsschritten noch weiter als 160 entfernt, fordert der
Techniker einen **Lufttransport** an. Gibt es keinen, wiederholt er die Anforderung
endlos - er verlaesst das Platoon nie und ist fuer jede andere Aufgabe verloren.

**Wir hatten `Air Transport T1` dauerhaft gesperrt** ("keine T1-Einheiten") und T2/T3 an
`TransporterFreigabe` gebunden. Der angeforderte Transport konnte also nie entstehen.

#### Das erklaert alle offenen Beobachtungen auf einmal

| Beobachtung | Erklaerung |
|---|---|
| "einer faehrt in die Gegend" | unterwegs zum Bauplatz |
| "einer steht dumm rum" | wartet auf den Transport |
| "das Extraktorupgrade bekommt keinen Support" | beide Techniker sind gebunden |

**Und es erklaert, warum die Nachtraege 26, 29, 30 und 31 nichts bewirkt haben.** Die
dort gefundenen Ursachen waren alle echt - Lagerschwelle, Radius, `MaxChoices` -, aber
sie waren wirkungslos, weil die Techniker gar nicht erst frei waren, um eine andere
Aufgabe annehmen zu koennen. Vier Runden lang wurde an Aufgaben gedreht, die nie zur
Auswahl standen.

#### Die Behebung

`Air Transport T1` ist **keine Kampfeinheit**, sondern Vorbedingung dafuer, dass die
Wirtschaft ueberhaupt anlaeuft. Er ist jetzt an drei Stellen freigegeben: aus der
T1-Sperre entfernt und in den beiden Gruppensperren
("Waehrend ACU-Ausbau zurueckstellen", "Truppen, Aufklaerung und schweres Geraet") als
`Ausser` ausgenommen. Die Regel des Nutzers fuer T2- und T3-Transporter
(`TransporterFreigabe`) bleibt unveraendert.

#### Lehre

**Eine Sperre kann eine Einheit betreffen, die gar keine Einheit im gemeinten Sinn ist.**
"Keine T1-Einheiten, die sind bei No-Rush Verschwendung" zielte auf Kampfeinheiten. Der
Transport fiel unter dieselbe Kategorie und war doch das Gegenteil von Verschwendung.

Und methodisch: **wenn mehrere Korrekturen hintereinander nichts bewirken, liegt der
Fehler wahrscheinlich davor, nicht daneben.** Die richtige Frage war nicht "warum wird
die Unterstuetzung nicht gewaehlt", sondern "wird ueberhaupt noch etwas gewaehlt". Ein
Blick in den `EngineerDialog` haette sie nach dem ersten Fehlversuch beantwortet.

**Commit-Vorschlag:** `CustomAI: T1-Lufttransport freigeben - Techniker hingen fest`

### Nachtrag 33: KORREKTUR von Nachtrag 32 - die Techniker hingen nicht fest

- **Was:** Transportfreigabe zurueckgenommen; `Assist Mass - NoRush` von 844 auf 852
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** die Ursache ist **im Log belegt**, die Behebung nicht

#### ⚠️ Nachtrag 32 war falsch

Ich hatte aus den wiederholten `calls for transport`-Zeilen geschlossen, die Techniker
hingen fest. **Das stimmt nicht.** Der vollstaendige Verlauf von Techniker 1048578:

```
tick  420  buildPosition { 809.5, 0, 358.5 }   distance 56   orders build "xsb1103"
tick  746  ends loop due to resource shortage
tick  746  buildPosition { 809.5, 0, 408.5 }   distance 50   orders build "xsb1103"
tick 1053  ends loop due to resource shortage
tick 1053  buildPosition { 750.5, 0, 221.5 }   distance 194
```

Er baut durchgehend Extraktoren. Der dritte Bauplatz liegt 194 entfernt - ueber der
Schwelle von 160 aus `platoon.lua` Z. 8618 -, also fordert er einen Transport an.
Bekommt er keinen, **laeuft er einfach weiter**: `SendPlatoonWithTransportsLOUD`
liefert false, es folgt `WaitTicks(12)` und die Bewegungsschleife geht weiter
(Z. 8637-8641). Die wiederholte Logzeile ist ein Nebeneffekt langer Wege, kein Stillstand.

**Der Transport bleibt gesperrt** - ausdrueckliche Vorgabe: T1-Techniker gehen zu Fuss,
in der Fruehphase fehlt die Masse sonst beim Extraktor.

#### Die tatsaechliche Ursache

Es fehlte kein Transport, sondern **freie Techniker**. Beide waren durchgehend mit
`Mass Extractor T1 - 250` beschaeftigt - Prioritaet **850**, unsere Unterstuetzung lag
bei **844**. Der Builder laeuft mit `LoopBuild = true` und beginnt nach jedem
"ends loop due to resource shortage" von vorn. Solange freie Massepunkte in Reichweite
liegen, kommt die Unterstuetzung nie an die Reihe.

`Assist Mass - NoRush` steht jetzt auf **852**, also darueber. Sie greift nur, solange
tatsaechlich etwas aufsteigt, und ist ueber `BuilderData.Assist.Time = 90` begrenzt -
der Extraktorbau verliert also nur waehrend eines Aufstiegs.

#### Was der Log sonst bestaetigt

Die Umhuellung arbeitet einwandfrei. Aus der Prioritaetsliste von Techniker 1048578:

```
PriorityFunction change for 745 Assist Energy to 842
PriorityFunction change for 720 T1 Assist Structure/Exp to 838
PriorityFunction change for 843 Mass Storage 600 - NoRush to 10
PriorityFunction change for 760 T1 Extractor Defense to 10
PriorityFunction change for 750 T1 Base Defense - AA to 10
```

Boeden, Deckel und Sperren kommen alle an. Die Kopien stehen in der Aufgabenliste
(`MAIN EM T1 844 Assist Mass - NoRush`). **Der Mechanismus stimmt - es waren durchweg
falsch gewaehlte Zahlen.**

#### Lehre

Zwei Fehler in Folge aus demselben Grund: **aus einer auffaelligen Logzeile auf die
Ursache geschlossen, statt den ganzen Verlauf zu lesen.** `calls for transport` sah nach
Blockade aus; drei Zeilen weiter stand `orders build`. Bei der naechsten Diagnose zuerst
den vollstaendigen Verlauf einer Einheit ansehen, dann die auffaellige Zeile deuten.

**Commit-Vorschlag:** `CustomAI: Unterstuetzung ueber den Extraktorbau (852)`

### Nachtrag 34: `LoopBuild` - warum die Prioritaet nie zur Anwendung kam

- **Was:** Kopie `Mass Extractor T1 - 250 - NoRush` mit `LoopBuild = false`
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** die Ursache ist **im Log belegt**, die Behebung nicht

#### Die Mechanik

`platoon.lua` Z. 8872-8898, am Ende von `ProcessBuildCommand`:

```lua
if self.PlatoonData.Construction.LoopBuild and self.PlanName then
    if GetEconomyStored(aiBrain,'MASS') >= LoopMass
       and (GetEconomyStoredRatio(aiBrain,'MASS')*100) < 75 then
        if GetEconomyStored(aiBrain,'ENERGY') >= LoopEnergy then
            self:SetAIPlan( self.PlanName, aiBrain )
            return
```

**Mit `LoopBuild` startet das Platoon denselben Builder erneut - ohne ueber
`GetHighestBuilder` zu gehen.** `Mass Extractor T1 - 250` hat `LoopMass = 1` und
`LoopEnergy = 500`; beides ist praktisch immer erfuellt. Der Techniker baut damit
Extraktor um Extraktor und fragt nie wieder, was zu tun waere.

#### Der Beleg

```
tick  420  Eng 1048578 EM T1 adding "Mass Extractor T1 - 250"
tick  504  Eng 1048580 EM T1 adding "Mass Extractor T1 - 250"
           ... kein weiteres "adding" im ganzen Log ...
tick 1260  Basic Mass Extractor UPGRADING TO "uab1202"
```

Der erste Aufstieg begann auf Tick **1260**. Zu diesem Zeitpunkt hatte seit Tick 504
kein Techniker mehr gefragt, was zu tun ist.

**Damit war jede Prioritaetsaenderung wirkungslos - die Wahl wurde nie erneut
getroffen.** Das gilt rueckwirkend fuer die Nachtraege 26, 29, 30, 32 und 33: die dort
gefundenen Zahlen waren alle richtig gelesen, aber sie steuern eine Entscheidung, die
nicht mehr stattfand.

#### Die Behebung

`LoopBuild = false` in einer Kopie. Nach jedem Extraktor geht der Techniker ueber
`ReturnToBaseAI` zurueck in den Pool und waehlt neu - dann kann
`Assist Mass - NoRush` (852) den Extraktorbau (850) schlagen.

**Preis:** der Techniker laeuft zwischen den Extraktoren zur Basis zurueck. Bei
Entfernungen von 50 bis 200 kostet das Zeit. Falls es zu traege wird, waere die
Alternative, den Aufstieg ueber `DesiresAssist`/`NumAssistees` anzufordern statt ueber
die Aufgabenwahl - dafuer muesste der Hook auf `defaultunits.lua` erweitert werden.

#### Lehre

**Eine Prioritaet wirkt nur an dem Punkt, an dem gewaehlt wird.** Bei LOUD ist das
`GetHighestBuilder`, und ein Platoon mit `LoopBuild` umgeht diesen Punkt vollstaendig.
Vor der naechsten Prioritaetsaenderung zuerst pruefen: **findet an dieser Stelle
ueberhaupt eine Wahl statt?** Im `EngineerDialog` ist das die Zeile `adding "..."` - wo
sie fehlt, aendert keine Zahl etwas.

**Commit-Vorschlag:** `CustomAI: LoopBuild aus - Techniker waehlen nach jedem Extraktor neu`

### Nachtrag 35: Testlauf 15 - `LoopBuild` wirkt, aber der Techniker ist zu traege

- **Was:** `CDR Assist Mass` auf Prioritaetsboden 790
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Was der Log zeigt

Die Kopie greift und der Loop ist weg:

```
Kopie "Mass Extractor T1 - 250 - NoRush" - BuilderData.Construction.LoopBuild true -> false
```

Und die Techniker waehlen wieder neu - im Gegensatz zu Testlauf 14, wo es nach Tick 504
kein einziges `adding` mehr gab:

```
tick  422  Eng 2097154 adding "Mass Extractor T1 - 250 - NoRush"
tick  551  Eng 2097156 adding "Mass Extractor T1 - 250 - NoRush"
tick  776  Eng 2097156 adding "Mass Extractor T1 - 250 - NoRush"
tick  780  Eng 2097154 adding "Mass Extractor T1 - 250 - NoRush"
tick 1115  Eng 2097156 adding "Mass Extractor T1 - 250 - NoRush"
tick 1169  Eng 2097154 adding "Mass Extractor T1 - 250 - NoRush"
```

**Nachtrag 34 war also richtig.** Nur: der erste Aufstieg begann auf **Tick 1265**, und
der Lauf endete auf **1569**. Zwischen der letzten Wahl (1169) und dem Ende wurde kein
Techniker frei - die Unterstuetzung konnte gar nicht zur Wahl stehen.

#### Warum das trotzdem nicht reicht

Ein Techniker wird erst nach einem **fertigen Extraktor** wieder waehlbar; das dauert
rund 300 bis 400 Ticks. Ein Aufstieg, der genau dazwischen beginnt, laeuft ohne
Unterstuetzung an.

#### Der schnellere Helfer

Der Kommandant waehlt zuverlaessig alle rund **168 Ticks** neu - im Log auf 319, 525,
693, 861, 1029, 1197, 1365, 1533. Er ist der schnellste verfuegbare Helfer und mit
seiner Baurate der wirksamste.

`CDR Assist Mass` liegt im Original bei **756**, `CDR - T1 Power` bei **780** - die
Unterstuetzung hatte also nie eine Chance. Mit Boden **790** steht sie an der Spitze der
ACU-Liste. Sie greift nur, solange tatsaechlich etwas aufsteigt; sonst scheitern ihre
Bedingungen und der ACU baut weiter Kraftwerke.

#### Offen

Ob die Technikerunterstuetzung (852) jemals zum Zuge kommt, ist weiterhin ungeprueft -
dafuer braucht es einen Lauf, der ueber Tick 1600 hinausgeht. Der ACU-Weg ist davon
unabhaengig und sollte sofort sichtbar sein: im `EngineerDialog` als
`EM Commander adding "CDR Assist Mass"` kurz nach einem `UPGRADING TO`.

**Commit-Vorschlag:** `CustomAI: ACU unterstuetzt den Extraktoraufstieg (790)`

### Nachtrag 36: Referenzprotokoll - was baut der menschliche Spieler?

- **Was:** neuer Schalter `ReferenzLog`; protokolliert Baubeginne menschlicher Spieler
- **Wo:** `usermods\CustomAI\hook\lua\defaultunits.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Warum

LOUDs Debug-Ausgaben haengen an den **KI-Managern**. Ein menschlicher Spieler hat keine,
also steht im Log nichts ueber ihn - in Testlauf 15 waren von `PlayerCount=3` nur zwei
KIs sichtbar.

Die Vorgabe fuer die Bauordnung musste damit bisher muendlich beschrieben und von Hand in
Bedingungen uebersetzt werden. **Genau an dieser Uebersetzung sind mehrere Runden
gescheitert** - nicht am Mechanismus.

#### Was jetzt mitgeschrieben wird

```
CUSTOMAI Referenz: <Spieler> beginnt uab1103 (<LOC uab1103_desc>Basic Mass Extractor)
                   durch ual0001 auf Tick 412
```

Umgesetzt in `StructureUnit.OnStartBeingBuilt` und - noetigerweise ein zweites Mal - in
`FactoryUnit.OnStartBeingBuilt`. Die Fabrikklasse leitet sich schon vor unserem Hook von
`StructureUnit` ab (`defaultunits.lua` Z. 2046) und bekommt die obere Umhuellung deshalb
nicht; derselbe Fallstrick wie beim Aufstieg.

Die Weiche ist `brain.BrainType != 'Human'` (`aibrain.lua` Z. 831 und 863). Zivilarmeen
tragen `'AI'` und fallen damit heraus.

#### Grenzen

| | |
|---|---|
| nur Strukturen | Mobile Einheiten haengen an `MobileUnit`, dessen Unterklassen vor unserem Hook feststehen |
| Baubeginn, nicht Fertigstellung | fuer eine Bauordnung ist der Beginn die richtige Marke |
| Aufstiege erscheinen mit | dabei entsteht eine neue Einheit - eher nuetzlich als stoerend |

#### Alternative, die verworfen wurde

Das Replay unter
`...\My Games\Gas Powered Games\Supreme Commander Forged Alliance\replays\Paul\LastGame.SCFAReplay`
enthaelt jeden Befehl jedes Spielers - aber als Binaerformat. Es auszuwerten waere ein
eigenes Projekt; das Mitschreiben im Sim kostet zehn Zeilen.

**Commit-Vorschlag:** `CustomAI: Referenzprotokoll fuer menschliche Bauordnung`

### Nachtrag 37: Testlauf 16 - Referenzlog luecken haft; erster echter Vergleich

- **Was:** neun weitere Klassen umhuellt, damit Extraktoren und Kraftwerke im
  Referenzlog erscheinen
- **Wo:** `usermods\CustomAI\hook\lua\defaultunits.lua`
- **Getestet:** die Luecke ist belegt, die Behebung nicht

#### ⚠️ Die Ableitungsfalle - zum dritten Mal

Der Referenzlog zeigte die Luftfabrik auf Tick 69 und dann nichts bis Tick 3578.
**Extraktoren und Kraftwerke fehlten vollstaendig** - also genau der interessante Teil.

`defaultunits.lua` leitet **siebzehn** Klassen von `StructureUnit` ab (Z. 2046 bis 4911),
alle beim Laden der Datei und damit vor unserem Hook. Sie zeigen weiter auf die alte
Klasse. Nur was erst in den Einheitenskripten entsteht, bekam die Umhuellung - deshalb
erschienen ausgerechnet die Massespeicher.

Jetzt einzeln umhuellt: `MassCollectionUnit`, `EnergyCreationUnit`, `EnergyStorageUnit`,
`MassFabricationUnit`, `TeleportUnit`, `AirStagingPlatformUnit`, `RadarUnit`,
`SonarUnit`, `ShieldStructureUnit`.

Dieselbe Falle traf schon `FactoryUnit` beim Aufstiegshook (Nachtrag 7) und beim
Referenzlog (Nachtrag 36). **Regel: in `defaultunits.lua` reicht es nie, die Basisklasse
zu umhuellen.**

#### Erster Vergleich Mensch gegen KI

Gleicher Lauf, Mensch UEF, KI Seraphim.

| | Mensch | KI |
|---|---|---|
| Luftfabrik | 69 | ~18 |
| 4. Extraktor auf T2 | (fehlt im Log) | 3632 |
| Luftfabrik T2 | 4248 | 5089 |
| Luftfabrik T3 | 9182 | **7700** |
| Extraktoren auf T3 | (fehlt) | 7949 |
| Quantentor | **10942** | nicht gebaut (Lauf endet 12184) |
| erster T3-Techniker | - | 11153 |

**Beim Techaufstieg ist die KI nicht schlechter** - die T3-Luftfabrik hatte sie sogar
1500 Ticks frueher.

#### Warum das Tor fehlte

`Quantum Gate - NoRush` hat `BuilderType = { 'T3','SubCommander' }`. Der erste
T3-Techniker entstand auf **Tick 11153**, der Lauf endete auf 12184. Das Tor stand ab
11431 mit Prioritaet 855 zur Wahl - es fehlte schlicht die Zeit.

Der Mensch baute sein Tor auf 10942, also praktisch im selben Moment, in dem die KI
ihren ersten T3-Techniker bekam.

#### Bestaetigt: der ACU unterstuetzt jetzt

```
tick 1433  Basic Mass Extractor UPGRADING TO "xsb1202"
tick 1533  EM Commander adding "CDR Assist Mass"
tick 2117  UPGRADING TO ...
tick 1966  EM Commander adding "CDR Assist Mass"
tick 2264  EM Commander adding "CDR Assist Mass"
tick 2697  EM Commander adding "CDR Assist Mass"
```

**Nachtrag 35 wirkt.** Der Kommandant geht nach jedem Aufstieg helfen.

#### Der wahrscheinliche Rueckstand

Nicht der Techaufstieg, sondern die **Technikerzahl**. Der Mensch setzte zwischen Tick
3578 und 5350 siebzehn Massespeicher, teils im Abstand von zwei Ticks (4437 und 4439) -
das geht nur mit mehreren parallel arbeitenden Technikern. Die KI hatte zu diesem
Zeitpunkt zwei.

Das ist kein Fehler, sondern die Vorgabe aus Nachtrag 19: T1 = 2 Stueck plus 2 je
Extraktor ab Stufe 2. Bis zum vierten T2-Extraktor (Tick 3632) sind das hoechstens vier.
**Zu klaeren mit dem Nutzer**, ob die Grenze so bleiben soll.

**Commit-Vorschlag:** `CustomAI: Referenzlog erfasst jetzt Extraktoren und Kraftwerke`

### Nachtrag 38: Tooltip fuer die Lobby

- **Was:** neue Datei `lua\AI\CustomAITooltips\CustomAI.lua`
- **Wo:** `usermods\CustomAI\lua\AI\CustomAITooltips\CustomAI.lua`
- **Getestet:** **nein**

Behebt die Warnung `No tooltip in table for key: aitype_customai_aeon_air` und gibt dem
Lobbyeintrag eine Beschreibung.

#### Wie es gelesen wird

`enhancedlobby.lua` Z. 287-300 durchsucht jeden **aktiven** Mod nach
`<mod>/lua/AI/CustomAITooltips/*.lua` und uebernimmt aus jeder Datei die Tabelle
`Tooltips`.

Der Schluessel ist `aitype_` plus dem Key aus `AIDefinitions.lua`. Aufbau wie bei LOUDs
eigenen Eintraegen (`gamedata.entpackt\lua\lua\ui\help\tooltips.lua` Z. 770):

```lua
aitype_loud = { title = "LOUD AI", description = "..." }
```

**Der Pfad liegt unter `lua\AI\`, nicht unter `hook\`** - die Datei wird importiert,
nicht gehookt, und darf deshalb nur Daten enthalten. Sie wird im Lobbykontext gelesen;
das ist derselbe Weg, ueber den auch `CustomAIs_v2\CustomAI.lua` laeuft.

**Bei jeder neuen KI hier einen Eintrag ergaenzen**, sonst kehrt die Warnung zurueck.

#### Nebenbei erledigt

Die vier Warnungen zu `readme.md` und `test.txt` in `usermods\` sind weg - der Nutzer
hat die Dateien geloescht. LOUD durchsucht dieses Verzeichnis nach Mod-Archiven und
versucht jede Datei als ZIP zu oeffnen.

**Commit-Vorschlag:** `CustomAI: Tooltip fuer den Lobbyeintrag`

### Nachtrag 39: Testlauf 17 - erster vollstaendiger Vergleich

- **Was:** Speicherfreigabe von 4 auf 1 T2-Extraktor
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Die Eroeffnung des Menschen, vollstaendig

| Tick | was | durch |
|---:|---|---|
| 66 | Luftfabrik | ACU |
| 338, 474 | 2 Kraftwerke | ACU |
| **567** | **Extraktor 1** | Techniker |
| 610 | Kraftwerk | ACU |
| **657** | **Extraktor 2** | Techniker |
| 746, 882 | 2 Kraftwerke | ACU |
| **925** | **Extraktor 3** | Techniker |
| **1017** | **Extraktor 4** | Techniker |
| 1092 | Kraftwerk | ACU |
| **1146** | Extraktor 1 -> T2 | |
| 1679 | Extraktor 2 -> T2 | |
| 2303 | Extraktor 3 -> T2 | |
| 2914 | Extraktor 4 -> T2 | |
| 3404 | erster Speicher | |

**Der ACU baut durchgehend Kraftwerke** (alle rund 136 Ticks), die Techniker
ausschliesslich Extraktoren. Klare Arbeitsteilung.

#### Die KI im selben Lauf

| | Mensch | KI |
|---|---:|---:|
| Extraktor 1 | 567 | **420** |
| Extraktor 2 | 657 | **540** |
| Extraktor 3 | 925 | **809** |
| Extraktor 4 | 1017 | **929** |
| 1. Aufstieg auf T2 | 1146 | 1371 |
| 4. Aufstieg auf T2 | 2914 | 3314 |

**Bei den ersten vier Extraktoren ist die KI schneller als der Mensch** - zwischen 90 und
150 Ticks. Der Rueckstand entsteht erst beim Aufstieg.

#### Die Laufwege

| Techniker | Tick | Entfernung |
|---|---:|---:|
| 1048578 | 420 | 56 |
| 1048580 | 540 | 56 |
| 1048578 | 809 | 46 |
| 1048580 | 929 | 45 |
| 1048578 | 1091 | **194** |
| 1048580 | 1211 | **341** |

Die ersten vier Wege sind kurz. Erst der fuenfte und sechste Extraktor liegen weit -
dann sind die nahen Massepunkte belegt.

**⚠ OFFEN:** 341 ueberschreitet die eigene Reichweite des Builders.
`Mass Extractor T1 - 250` hat `MaxRange = 250` und
`CanBuildOnMassAtRange { 'LocationType', 0, 250, ... }`; die Basis liegt bei etwa
{784, 393}, das Ziel bei {1095, 465} - rund 319 von der Basis. Wie der Punkt durch die
Reichweitenpruefung kommt, ist **ungeklaert**.

#### Der eigentliche Unterschied

Der Mensch hoert nach vier Extraktoren auf zu expandieren und zieht sie hoch. Die KI
baut weiter nach aussen - Extraktor 5 und 6 auf 194 und 341 Entfernung - und bindet
damit beide Techniker genau in dem Zeitraum, in dem die Aufstiege Unterstuetzung
braeuchten.

#### Geaendert

Speicherfreigabe von `MindestensT2Extraktoren = 4` auf **1**: nach Vorgabe des Nutzers
macht jeder Extraktor fuer sich T1 > T2 > Speicher > T3, statt auf alle vier zu warten.

**⚠ Risiko:** `MassExtractorInRangeHasLessThanStorage` prueft nicht die Stufe des
Extraktors. Mit Wert 1 koennen Speicher auch an T1-Extraktoren entstehen - im naechsten
Lauf beobachten.

**Commit-Vorschlag:** `CustomAI: Speicher ab dem ersten T2-Extraktor`

### Nachtrag 40: Der No-Rush-Radius steht in der Karte

- **Was:** Platzhalter `'NoRushRadius'` in `BuilderDatenWerte`; Extraktorbau auf den
  No-Rush-Kreis begrenzt; entfernte Staffeln erst nach Ablauf der Frist
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Der Fund

`ScenarioInfo.norushradius` - ein Feld der Szenariodatei jeder Karte:

```lua
-- maps\LostTemple\losttemple_scenario.lua Z. 15
norushradius = 52,
```

Die Datei setzt die globale Tabelle `ScenarioInfo`; das Feld ist damit im Sim lesbar.
**Der Radius ist kartenweise verschieden** - eine feste Zahl waere immer fuer die eine
oder andere Karte falsch gewesen.

Nicht zu finden war dagegen irgendeine Lua-Stelle, die den No-Rush-Kreis *durchsetzt* -
durchsucht wurden `lobby.lua`, `lobbyOptions.lua`, `simInit.lua`, `ScenarioUtilities.lua`
und `ScenarioFramework.lua`. Die Durchsetzung liegt offenbar in der Engine; gelesen
werden kann der Wert trotzdem.

#### Umsetzung

Neuer Platzhalter in `BuilderDatenWerte`: die Zeichenkette `'NoRushRadius'` wird beim
Anlegen der Kopie durch `ScenarioInfo.norushradius` ersetzt. Fehlt das Feld, bleibt der
Originalwert stehen und es gibt eine Warnung - **kein stiller Fehlschlag**.

```lua
Mass Extractor T1 - 250 - NoRush:
    Construction.MaxRange = 'NoRushRadius'
```

Dazu: die 750er- und 1500er-Staffel liegt bis `Anteil = 1.0` auf 10. Diese Massepunkte
sind waehrend der Frist ohnehin unerreichbar - sie banden nur Techniker, die naeher
gebraucht wurden (Testlauf 17: Wege von 194 und 341).

#### Was das loest

Die Beobachtung aus Testlauf 17 war nicht, dass die KI an nahen Punkten vorbeilaeuft -
die ersten vier Wege waren 56, 56, 46 und 45 lang. Es war der **fuenfte und sechste**
Extraktor ausserhalb des Kreises. Genau die entfallen jetzt bis zum Ablauf der Frist,
und die Techniker bleiben fuer Aufstiegsunterstuetzung und Speicher verfuegbar.

Damit erledigt sich vermutlich auch die offene Anomalie aus Nachtrag 39 (Ziel 341 weit
trotz `MaxRange = 250`): der Bereich, in dem sie auftrat, ist jetzt gesperrt. **Erklaert
ist sie damit nicht** - falls sie innerhalb des Kreises wieder auftritt, muss
`AIExecuteBuildStructure` genauer gelesen werden.

**Commit-Vorschlag:** `CustomAI: Extraktorbau auf den No-Rush-Radius begrenzen`

### Nachtrag 41: Die Speicherwarnungen sind ein Wettlauf, kein Logikfehler

- **Was:** `Mass Storage 600 - NoRush` von 4 auf 2 Instanzen
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Die Annahme war falsch

Vermutet war, LOUD pruefe die Bebaubarkeit der Speicherplaetze nicht vorab. **Es tut es.**
`AIBuildBaseTemplateOrdered` (`aibuildstructures.lua` Z. 293):

```lua
if not eng.Dead and CanBuildStructureAt( aiBrain, whatToBuild, { position[1], 0, position[2] } )
   or EngineerTryRepair( { position[1],0,position[2] } ) then
    LOUDINSERT(eng.EngineerBuildQueue, { whatToBuild, position } )
```

Der Platz kommt also nur in die Bauschlange, wenn er zum **Zeitpunkt des Einreihens**
bebaubar ist.

#### Die tatsaechliche Ursache

Geprueft wird beim Einreihen, gebaut viel spaeter. `ProcessBuildCommand`
(`platoon.lua` Z. 8797) prueft erneut - und inzwischen steht dort der Speicher eines
**anderen eigenen Technikers**:

```
Eng 1048617  Mass Storage 600          fails ... { 759.5, 0, 410.5 }
Eng 1048611  Mass Storage 600 - NoRush fails ... { 759.5, 0, 410.5 }
Eng 1048604  Mass Storage 600 - NoRush fails ... { 759.5, 0, 410.5 }
```

Dreimal derselbe Punkt, drei verschiedene Techniker. **Ein Wettlauf um vier
Nachbarplaetze.**

Je mehr Instanzen, desto mehr Techniker rechnen aus derselben Extraktorliste dieselben
Positionen aus. Mit vier Instanzen der Kopie plus zwei des nicht gesperrten Originals
waren es bis zu sechs.

**Eine zusaetzliche Vorabpruefung haette daran nichts geaendert** - ein Wettlauf laesst
sich nicht durch mehr Pruefen aufloesen, nur durch weniger Wettlaeufer.

#### Was geaendert wurde

Instanzen der Kopie von 4 auf **2**. LOUD faengt den Fall ohnehin sauber ab (Eintrag
verwerfen, weiterziehen); es kostet nur den Hinweg. Zwei Instanzen sind der Kompromiss
zwischen Tempo und vergeblichen Laeufen.

**Die Warnungen werden dadurch seltener, nicht unmoeglich.** Solange Original und Kopie
nebeneinander laufen - noetig wegen der Aussenposten, siehe Nachtrag 26 - bleiben vier
Instanzen im Rennen.

#### Lehre

Dieselbe Sorte Fehlschluss wie in Nachtrag 32: aus einer Warnung auf einen fehlenden
Mechanismus geschlossen, statt zu pruefen, ob es ihn gibt. **Vor dem Bau eines
Mechanismus zuerst nachsehen, ob LOUD ihn schon hat.**

**Commit-Vorschlag:** `CustomAI: weniger Speicherinstanzen - Wettlauf entschaerfen`

### Nachtrag 42: Testlauf 19 - zwei Luecken in der eigenen Umsetzung

- **Was:** `MaxChoices = 1` beim 250er-Extraktorbauer; Ersatzwert
  `NoRushRadiusStandard` fuer Karten ohne `norushradius`
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### 1. Der Radius kam nie an

```
warning: CUSTOMAI NoRush: Mass Extractor T1 - 250 - NoRush -
         ScenarioInfo.norushradius fehlt, Construction.MaxRange bleibt unveraendert
```

**Die Karte `rockbottom` bringt das Feld nicht mit.** `norushradius` ist optional; nur
Karten mit definiertem No-Rush-Kreis setzen es (Beleg fuer den Normalfall:
`maps\LostTemple\losttemple_scenario.lua` Z. 15).

`MaxRange` blieb damit auf LOUDs 250 - und genau das schickte einen Techniker auf Tick
1070 wieder **243** weit.

Die Warnung war richtig gebaut (kein stiller Fehlschlag), aber ohne Ersatzwert nutzlos.
Neues Feld `NoRushRadiusStandard = 100`: die vier nahen Massepunkte lagen in diesem Lauf
zwischen 25 und 57, die naechsten unerwuenschten bei 211 und 243 - der Wert trennt
beides deutlich.

#### 2. `MaxChoices` fehlte ausgerechnet beim wichtigsten Bauer

```
tick 422  Eng 2097154  Entfernung 57
tick 506  Eng 2097156  Entfernung 25
```

Der **erste** Techniker nahm den 57 weit entfernten Punkt, obwohl der 25 weite noch frei
war. Genau die Beobachtung "es wird nicht der naechste angefahren".

In Nachtrag 30 wurde `MaxChoices = 1` auf die 750er- und 1500er-Staffel gesetzt - **beim
250er-Bauer nicht**, weil dessen Original das Feld gar nicht hat und ich daraus schloss,
er nehme ohnehin den naechsten. Falsch: ohne gesetzten Wert greift LOUDs Vorgabe, und
die ist nicht 1.

Jetzt auch dort `MaxChoices = 1`.

#### Lehre

Beide Fehler haben dieselbe Form: **eine Annahme darueber, was passiert, wenn ein Feld
fehlt.** Einmal "dann bleibt eben der alte Wert" (ohne zu pruefen, ob der taugt), einmal
"dann ist es wohl 1" (ohne die Vorgabe zu kennen).

Bei jedem Feld, das gesetzt oder ersetzt wird, gehoert die Frage dazu: **was gilt, wenn
es fehlt - und ist das brauchbar?**

**Commit-Vorschlag:** `CustomAI: MaxChoices und Radius-Ersatzwert fuer den Extraktorbau`

### Nachtrag 43: ACU-Unterstuetzung zurueckgenommen

- **Was:** Prioritaetsboden 790 auf `CDR Assist Mass` entfernt
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Warum der Kommandant zum Extraktor lief

Weil Nachtrag 35 es so eingestellt hat: `CDR Assist Mass` von 756 auf **790** gehoben,
also ueber `CDR - T1 Power` (780). Damit steht die Unterstuetzung an der Spitze der
ACU-Aufgabenliste, sobald ein Extraktor aufsteigt.

Weit lief er dabei nicht - `CDR Assist Mass` traegt
`BuildingGreaterAtLocationAtRange { 'LocationType', 0, ..., 36 }` und
`Assist.AssistRange = 48`. Der ACU bleibt also im Umkreis von rund 48 um die Basis.

#### Warum es trotzdem falsch war

**Das Referenzlog des Nutzers zeigt das genaue Gegenteil.** Sein ACU baut durchgehend
Kraftwerke - Tick 338, 474, 610, 746, 882, 1092, 1829, 1965, 2348, 2484, 2620, 2756,
2892, 3028, 3164, 3377, 3528 - und unterstuetzt **kein einziges Mal**. Die Extraktoren
machen ausschliesslich die Techniker. Klare Arbeitsteilung.

Die ACU-Unterstuetzung war eine Notloesung gegen ein Symptom: die Techniker wurden nie
frei. Diese Ursache ist inzwischen behoben - `LoopBuild = false` (Nachtrag 34) gibt sie
nach jedem Extraktor zurueck in die Auswahl, `MaxRange` und `MaxChoices` (Nachtrag 42)
halten sie in Basisnaehe.

Zurueck auf LOUDs 756, also unter `CDR - T1 Power`. Der Kommandant baut damit weiter
Kraftwerke und hilft nur, wenn sonst nichts ansteht.

#### Lehre

**Eine Notloesung gegen ein Symptom sollte fallen, sobald die Ursache behoben ist.**
Sonst bleiben zwei Mechanismen fuer dieselbe Sache stehen, und der zweite verdeckt, ob
der erste ueberhaupt wirkt.

Der Eintrag bleibt als leerer Platzhalter mit Begruendung stehen - damit die Ueberlegung
nicht verlorengeht und nicht versehentlich noch einmal so geloest wird.

**Commit-Vorschlag:** `CustomAI: ACU baut wieder Kraftwerke statt zu unterstuetzen`

### Nachtrag 44: Die Arbeitsteilung in der Eroeffnung, ausformuliert

- **Was:** ACU-Unterstuetzung an den vierten T2-Extraktor gebunden;
  `CDR - Mass Extractor` bis dahin gesperrt
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Die Regel

Vorgabe des Nutzers: **bis alle vier Extraktoren auf T2 sind, ist der Kommandant allein
fuer die T1-Kraftwerke zustaendig. Ab dann darf und soll er die Aufstiege T2 -> T3
unterstuetzen.**

`MindestensT2Extraktoren = 4` trifft den Umschaltpunkt exakt: solange noch ein Extraktor
auf T1 steht, laufen T1 -> T2-Aufstiege; sind alle vier auf T2, bleiben nur noch
T2 -> T3.

| | vor dem vierten T2-Extraktor | danach |
|---|---|---|
| `CDR - T1 Power` (780) | laeuft | laeuft |
| `CDR Assist Mass` (756) | **gesperrt** | **Boden 790**, also ueber Kraftwerken |
| `CDR - Mass Extractor` (775) | **gesperrt** | frei |

#### Warum auch `CDR - Mass Extractor` gesperrt ist

Im Referenzlog baut der Mensch **jeden** Extraktor mit einem Techniker (`uel0105`),
keinen einzigen mit dem ACU. Der Bauer liegt im Original bei 775, knapp unter
`CDR - T1 Power` (780) - er wuerde also einspringen, sobald gerade kein Kraftwerk
faellig ist. Genau das verwaessert die Arbeitsteilung.

#### Zum Vorgehen

Nachtrag 43 hatte den Boden ersatzlos entfernt, weil er der beobachteten Spielweise
widerspricht. Richtig war die Beobachtung, falsch die Schlussfolgerung: der Nutzer will
die Unterstuetzung sehr wohl - nur **spaeter**. Aus "der ACU soll das nicht tun" wurde
durch Nachfrage "der ACU soll das ab einem bestimmten Punkt tun".

**Ein beobachtetes Muster ersetzt keine Absicht.** Das Referenzlog zeigte, WAS der
Spieler tut, nicht, ab wann er es fuer richtig haelt - der Lauf endete vor dem
Umschaltpunkt.

**Commit-Vorschlag:** `CustomAI: ACU - Kraftwerke bis zum vierten T2-Extraktor, dann Unterstuetzung`

### Nachtrag 45: Fabriken 2 bis 4 ab der ersten T3-Fabrik

- **Was:** Fabrikfreigabe an `T3FabrikVorhanden` statt an Phase und T3-Extraktoren;
  zweistufige Luftfabrikgrenze; `Air Factory Rebuild` entsperrt
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Die Regel

Vorgabe: *"die zweite bis vierte Fabrik koennen kommen, sobald die erste auf T3 ist.
QG ist zwar wichtiger, aber sonst wasten wir Masse."*

Alt war `Anteil = aBoden` **und** `MindestensT3Extraktoren = 4` - zwei Riegel, die mit
dem eigentlichen Grund nichts zu tun hatten. Neu genau einer:
`T3FabrikVorhanden`. Eine T3-Fabrik heisst: der Techaufstieg ist durch, die Wirtschaft
traegt.

**Das Quantentor bleibt vorrangig, ohne dass es hier erwaehnt werden muss:**
`Quantum Gate - NoRush` steht auf 855, die Fabriken auf 745. Der Deckel von 745 sorgt
zugleich dafuer, dass Fabriken hinter der gesamten Wirtschaft rangieren - sie fangen
also genau den Ueberschuss ab, um den es geht.

#### Zweistufige Grenze

Neue Bedingung `LuftfabrikenGrenze` mit `{ 4, 8 }`: bis zum Ende der No-Rush-Frist
hoechstens vier, danach acht. Eine feste Zahl taugt nicht - waehrend der Frist wird
nichts produziert, mehr als vier waeren reine Massesenken; danach sind Fabriken der
Zweck der KI. `BaseSettings.FactoryCount.AIR = 8` bleibt die harte Grenze darueber.

Die Bedingung liest `NoRushDauer()` selbst und passt sich damit der Lobbyeinstellung an.

#### `Air Factory Rebuild` entsperrt

Er feuert nur, wenn die KI **gar keine** Luftfabrik hat (`HaveZeroAirFactories`,
`Loud_AI_Engineer_Factory_Builders.lua` Z. 54-82). Fuer eine reine Luftwaffe ist das der
Totalausfall: keine Fabrik, keine Techniker, kein Wiederaufbau.

Dazu kommt ein Fall, den die Sperre bisher verdeckte: auf Karten bis 1024 baut der ACU
ueber `CDR Initial Small Map` eine **Land**fabrik - und die ist bei uns dauerhaft
gesperrt. Dort war dieser Bauer der einzige Weg zu ueberhaupt einer Luftfabrik.

#### Lehre

Die alte Freigabe hatte zwei Bedingungen, von denen keine den eigentlichen Grund traf -
sie waren aus "es ist zu frueh" abgeleitet, nicht aus "woran erkennt man, dass es nicht
mehr zu frueh ist". **Eine Bedingung sollte den Sachverhalt benennen, nicht ihn
umschreiben.**

**Commit-Vorschlag:** `CustomAI: Fabriken ab der ersten T3-Fabrik, 4 bis Fristende`

### Nachtrag 46: Die T2-T3-Phase - Rangfolge dokumentiert, kein Eingriff

- **Was:** Dokumentationsblock in `AIDefinitions.lua`
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** entfaellt - keine Verhaltensaenderung

#### Die Vorgabe war schon erfuellt

Vorgabe: waehrend der T2 -> T3-Aufstiege bauen die Techniker Strom (T2-Kraftwerke) und
unterstuetzen den Aufstieg.

Die Rangfolge ergibt das bereits:

| Prioritaet | Aufgabe |
|---:|---|
| 900 | `T2 Power Template` |
| 852 | `Assist Mass - NoRush` |
| 851 | `T3 Power Template` |
| 850 | `Mass Extractor T1 - 250 - NoRush` (Bedingung scheitert hier ohnehin) |
| 848 | `Assist ACU SACU` |
| 843 | `Mass Storage 600 - NoRush` |
| 842 | `Assist Energy` |
| 745 | neue Fabriken |

Alles Uebrige ist zu diesem Zeitpunkt gesperrt: entfernte Extraktoren (`Anteil 1.0`),
Verteidigung (Phasen 2 und 3), Einheiten (Phase 4), Air Staging (`Anteil 1.0`).

**Dass Strom vor Unterstuetzung kommt, ist inhaltlich richtig** und nicht nur Zufall der
Zahlen: der Aufstieg haengt am Energietrend (`SelfUpgradeThread`, `defaultunits.lua`
Z. 813). Ohne Strom nuetzt die beste Unterstuetzung nichts.

#### Warum trotzdem ein Eintrag

Die Reihenfolge stand an sechs verschiedenen Stellen verstreut und war nirgends als
Absicht festgehalten. Bei der naechsten Prioritaetsaenderung waere sie unbemerkt
kaputtgegangen - dieser Block sagt, welche Ordnung gewollt ist und warum.

Kein Wert wurde geaendert.

**Commit-Vorschlag:** `doc: Rangfolge der T2-T3-Phase festgehalten`

### Nachtrag 47: Das Quantentor vor die Kraftwerke

- **Was:** `Quantum Gate - NoRush` von 855 auf 905
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Die Vorgabe

*"Es gibt keine Aufstiege mehr, wenn T3-Techniker kommen. Die koennen erstmal das eine
QG starten, bevor sie auf Strom gehen."*

Damit zerfaellt die Eroeffnung in zwei Abschnitte mit **unterschiedlicher** Rangfolge -
und Nachtrag 46 hatte nur den ersten beschrieben.

| | waehrend der T2 -> T3-Aufstiege | sobald T3-Techniker da sind |
|---|---|---|
| 1. | `T2 Power Template` (900) | **`Quantum Gate - NoRush` (905)** |
| 2. | `Assist Mass - NoRush` (852) | `T2 Power Template` (900) |
| 3. | `Mass Storage 600 - NoRush` (843) | `T3 Power Template` (851) |

#### Der Fehler

Mit **855** stand das Tor zwar ueber `T3 Power Template` (851), aber **unter**
`T2 Power Template` (900). Solange die vier T2-Kraftwerke noch nicht standen, haette der
erste T3-Techniker also Kraftwerke gebaut statt das Tor zu setzen.

Das war in Nachtrag 19 nicht falsch gedacht, sondern gar nicht gedacht: 855 wurde
gewaehlt, um knapp ueber den Massextraktoren (850) zu liegen - der Vergleich mit den
Kraftwerksbauern fand nie statt.

#### Warum 905 unbedenklich ist

Es ist die einzige Aufgabe im **Ingenieurmanager** mit dieser Prioritaet.
`Sub Commander - Extra` (905) und `Engineer T3 - Standard` (900) liegen zwar gleichauf,
sind aber `FactoryBuilder` und damit in einer anderen Aufgabenliste - sie konkurrieren
nicht miteinander.

Die Bedingungen des Tors bleiben die Bremse gegen einen zu frueh begonnenen Bau:
2500 Energie je Sekunde sowie 400 Masse und 5000 Energie im Lager.

#### Lehre

Eine Prioritaet wurde gegen **eine** Nachbaraufgabe gesetzt und nie gegen die uebrigen
geprueft. Bei jedem Boden gehoert die Frage dazu: **wer steht sonst noch darueber, und
ist das gewollt?** Der Dokumentationsblock aus Nachtrag 46 ist genau dafuer da - er
haette den Fehler gezeigt, wenn er die zweite Phase mit aufgefuehrt haette. Jetzt tut er
es.

**Commit-Vorschlag:** `CustomAI: Quantentor vor die Kraftwerke (905)`

### Nachtrag 48: `StartingMassPointList` - warum `MaxRange` und `MaxChoices` nie wirkten

- **Was:** neues Feld `StartMassepunkte`; Kuerzung der Liste im aibrain-Hook
- **Wo:** `usermods\CustomAI\hook\lua\aibrain.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein** - die Ursache ist im Code belegt

#### Der Befund

Der Log von Testlauf 20 zeigt beide Werte korrekt gesetzt:

```
Mass Extractor T1 - 250 - NoRush - BuilderData.Construction.MaxRange 250 -> 100
Mass Extractor T1 - 250 - NoRush - BuilderData.Construction.MaxChoices nil -> 1
```

Und trotzdem:

```
tick  422  Entfernung  57      (waehrend ein Punkt bei 25 frei war)
tick 1070  Entfernung 243      (MaxRange ist 100)
tick 1219  Entfernung 319
```

**Fuer Massextraktoren laeuft der Bau ueber einen anderen Codepfad.**
`AIBuildBaseTemplateOrdered` reicht bei `IsResource(buildingType)` an
`AIExecuteBuildStructure` weiter (`aibuildstructures.lua` Z. 43), und dort steht ab
Z. 97:

```lua
if testtype == 'Mass' and aiBrain.StartingMassPointList[1] then
    location = LOUDREMOVE(aiBrain.StartingMassPointList, 1)
    location = location.Position
    if CanBuildStructureAt( aiBrain, testunit, location ) then
        constructionData.MaxRange = 1500
```

Solange die Liste nicht leer ist, nimmt der Techniker stur den **naechsten
Listeneintrag**. `MaxChoices` wird gar nicht gelesen, `MaxRange` sogar aktiv auf 1500
gesetzt.

#### Woher die Liste kommt

`ScenarioUtilities.lua` Z. 1036-1075, am Ende von `InitializeArmies`: die Massepunkte
des Teams werden nach Entfernung zur Startposition sortiert, und jede KI bekommt reihum
`MassPointShare` Stueck zugeteilt. Die Zahl (Z. 954):

```lua
min( 12 + PlayerCount, floor(NumMassPoints/PlayerCount) - 1 )
```

Auf einer massereichen Karte sind das leicht vierzehn Punkte - und die hinteren liegen
weit ausserhalb.

#### Die Behebung

Neues Feld `StartMassepunkte = 4`. Ein Thread im aibrain-Hook wartet, bis die Liste
gefuellt ist (sie entsteht erst in `InitializeArmies`, also **nach** `OnCreateAI`), und
kuerzt sie auf die ersten vier - die naechstgelegenen, weil sie sortiert zugeteilt
wurden. Alles Weitere faellt danach in den normalen Pfad, der `MaxRange = 100` und
`MaxChoices = 1` sehr wohl beachtet.

#### Lehre

**Drei Nachtraege (30, 40, 42) haben Werte gesetzt, die dieser Codepfad nie liest.** Der
Log bestaetigte jedes Mal brav, dass sie gesetzt wurden - das sagt aber nichts darueber,
ob sie auch gelesen werden.

Vor der naechsten Stellschraube: **erst den Codepfad bis zur Verwendung verfolgen**, nicht
nur die Datenstruktur finden, in der das Feld steht. `IsResource()` war die Weiche, die
den ganzen Unterschied ausmacht, und sie stand eine Ebene ueber der Stelle, die ich
gelesen hatte.

**Commit-Vorschlag:** `CustomAI: StartingMassPointList auf vier Punkte kuerzen`

### Nachtrag 49: Testlauf 21 - Kuerzung wirkt, zwei Regelverstoesse bleiben

- **Was:** `T1 Power Template` und Hydrokarbon bis zum vierten T2-Extraktor gesperrt;
  Startmassepunkte nach Entfernung zum Kommandanten neu sortiert
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`,
  `usermods\CustomAI\hook\lua\aibrain.lua`
- **Getestet:** **nein**

#### Bestaetigt: die Kuerzung greift

```
CUSTOMAI: Zoe (AI: LOUD Aeon Airforce) - StartingMassPointList von 15 auf 4
          Eintraege gekuerzt (MassPointShare war 15)
```

Die weiten Wege sind weg. Alle vier Extraktoren liegen nah: **57, 25, 46, 43** - vorher
waren es 243 und 319. Nachtrag 48 war richtig.

#### 1. Techniker bauten Kraftwerke

```
tick 1093  Eng 2097156  T1 Power Template   -> 20
tick 1185  Eng 2097156  T1 Power Template   -> 13
tick 1219  Eng 2097154  Hydrocarbon         -> 105
```

Vorgabe war: *"vorher ist er [der ACU] alleine fuer die paar T1-Kraftwerke
zustaendig"*. Der Kommandant baut sie ueber `CDR - T1 Power` - einen **eigenen** Builder.
`T1 Power Template` ist der Technikerbauer und war nie gesperrt.

Beide jetzt bis `MindestensT2Extraktoren = 4` aus, dazu Hydrokarbon (105 Entfernung ist
weit ausserhalb der Eroeffnung und keine Extraktorarbeit).

#### 2. Der erste Techniker nahm den zweitnaechsten Punkt

```
tick 422  Eng 2097154  -> 57
tick 506  Eng 2097156  -> 25
```

Die Liste war richtig sortiert - nur nach dem falschen Bezug. `ScenarioUtilities.lua`
Z. 1062 sortiert nach `{ brain.StartPosX, brain.StartPosZ }`, also der **Startposition
der Armee**. Die Techniker stehen aber an der Fabrik, und die liegt versetzt dazu
(im Lauf: Start `{512,542}`, Fabrik `{530,542}`).

Der Kuerzungsthread sortiert die verbliebenen vier jetzt nach Entfernung zum
Kommandanten neu - er steht zu diesem Zeitpunkt an der Basis, und der Basispunkt des
Managers ist dort noch nicht sicher verfuegbar.

#### Lehre

Zweimal in Folge war eine LOUD-Sortierung korrekt und trotzdem unpassend, weil sie
gegen einen anderen Bezugspunkt lief als erwartet. **Bei jeder uebernommenen Sortierung
gehoert die Frage dazu: sortiert nach was, und ist das mein Bezugspunkt?**

**Commit-Vorschlag:** `CustomAI: Techniker nur Extraktoren; Startpunkte neu sortiert`

### Nachtrag 50: Testlauf 22 - der Fabrikaufstieg war eine Sackgasse

- **Was:** Wartethread fuer aufgeschobene Aufstiege; Startmassepunkte gegen die Fabrik
  sortiert statt gegen den Kommandanten
- **Wo:** `usermods\CustomAI\hook\lua\defaultunits.lua`,
  `usermods\CustomAI\hook\lua\aibrain.lua`
- **Getestet:** **nein**

#### 1. Die Fabrik stieg nie auf - und konnte es nicht

Im ganzen Lauf (bis Tick 8770) keine einzige Zeile
`STRUCTUREUpgrade <Fabrik> starts upgrade thread`. Die Bedingung (4 Extraktoren ab
Stufe 2) war ab etwa Tick 3500 erfuellt.

**Der Wiederholungsversuch haengt an `OnUnitBuilt`** - `FactoryBuilderManager.lua`
Z. 617-636:

```lua
if not factory.Dead then
    if LOUDGETN(factory:GetCommandQueue()) <= 1 then
        ...
        if not factory.UpgradesComplete then
            if not factory.UpgradeThread and factory.LaunchUpgradeThread then
                factory:LaunchUpgradeThread( aiBrain )
```

Der Aufruf kommt also nur, wenn die Fabrik gerade eine Einheit **fertig gebaut** hat.
Waehrend der No-Rush-Frist ist die Einheitenproduktion gesperrt, und sobald die
Technikergrenze erreicht ist, baut die Fabrik gar nichts mehr - **es gab keinen zweiten
Versuch**. Unser einmaliges `return` war endgueltig.

Nachtrag 7 hatte genau das ausgeschlossen: *"Nichts tun heisst spaeter noch einmal
fragen"*. Die Annahme stimmte fuer eine produzierende Fabrik und faellt bei einer
stillstehenden - und Stillstand ist bei dieser KI der Normalfall.

Jetzt ein Wartethread mit Flag am Objekt, der alle fuenf Sekunden selbst nachfragt und
den Aufstieg nachholt. Gilt fuer Fabriken **und** Strukturen, weil dieselbe Falle dort
lauert.

#### 2. Die Sortierung lief gegen den falschen Punkt - zum zweiten Mal

Die Entfernungen blieben unveraendert **57, 25, 46, 43**, obwohl die Sortierzeile im Log
steht. Kein Wunder: sortiert wurde gegen den **Kommandanten**, und der steht zu diesem
Zeitpunkt noch auf der Startposition - also genau dort, wonach LOUD ohnehin sortiert
(`ScenarioUtilities.lua` Z. 1062). Die Umsortierung war eine teure Nulloperation.

Die Techniker entstehen an der **Fabrik**. Der Thread wartet jetzt zusaetzlich auf die
erste fertige Fabrik und sortiert gegen deren Position - und zwar **vor** dem Kuerzen,
sonst blieben die vier Punkte uebrig, die der Startposition am naechsten sind.

#### Bestaetigt

`Assist Mass - NoRush` greift jetzt: Ticks 1258, 1260, 1953, 1956, 2237. Die
Unterstuetzung der Extraktoraufstiege funktioniert.

#### Offen: zu viele Techniker zu frueh

`Engineer T1 - Standard` auf Tick 2115, ein weiterer Techniker auf 2237. Die geltende
Regel ist `2 + 2 je Extraktor ab Stufe 2` - bei vier T2-Extraktoren also zehn.
Laut Nutzer kommen sie in seinem Spiel spaeter. **Eine Zahl fehlt** - das Referenzlog
erfasst nur Strukturen, keine Einheiten, der Vergleich ist daraus nicht zu ziehen.

**Commit-Vorschlag:** `CustomAI: Aufstiege nachholen; Massepunkte gegen die Fabrik sortiert`

### Nachtrag 51: Technikerzahl in Stufen

- **Was:** neue Bedingung `T1TechnikerStufen`; Speicherfreigabe zurueck auf 4
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Die Regel

*"Als Mensch brauche ich erst nach 3 fertigen T2E neue Techniker, vorher wuerde denen die
Masse fehlen zum Durchbauen. Dann +2. Nach 4 T2E nochmal +4 Techniker und auf die
Storages."*

| fertige Extraktoren ab Stufe 2 | hoechstens T1-Techniker |
|---:|---:|
| 0 | 2 |
| 3 | 4 |
| 4 | 8 |

Die alte Regel `2 + 2 je T2-Extraktor` legte schon beim **ersten** Aufstieg nach - in
Testlauf 22 kam der dritte Techniker auf Tick 2115.

#### Zwei Zaehlweisen in einer Bedingung

| | Methode | warum |
|---|---|---|
| Extraktoren | `GetCurrentUnits` | nur **fertige** - ein aufsteigender foerdert noch nicht, und genau die Foerderung ist die Begruendung |
| Techniker | `Zaehle` (mit angefangenen) | sonst wird die Grenze um einen ueberschritten, wie in Nachtrag 26 |

Die beiden Zaehlweisen stehen jetzt zum ersten Mal in **derselben** Funktion. Das ist
kein Versehen, sondern folgt der Regel aus Nachtrag 26: Untergrenzen zaehlen fertige
Einheiten, Obergrenzen zaehlen angefangene mit.

#### Speicher zurueck auf 4

Zwischenzeitlich stand die Freigabe bei **1** T2-Extraktor - abgeleitet aus "jeder
Extraktor fuer sich T1 > T2 > Storage > T3". **Das war eine Fehldeutung.** Die
Reihenfolge gilt pro Extraktor, der **Einstieg** in den Speicherbau aber erst, wenn alle
vier auf T2 stehen. Danach entscheidet `ExtraktorAufstiegT3ErstVollUmbaut` je Extraktor,
wann er weiter darf.

Damit faellt auch das in Nachtrag 39 notierte Risiko weg: mit Wert 1 haetten Speicher an
T1-Extraktoren entstehen koennen, weil `MassExtractorInRangeHasLessThanStorage` die
Stufe nicht prueft.

#### Lehre

"Jeder fuer sich" beschrieb die **Reihenfolge innerhalb** eines Extraktors, nicht den
Zeitpunkt, ab dem die Kette ueberhaupt beginnt. Ich hatte eine Aussage ueber die
Abfolge in eine Aussage ueber den Startzeitpunkt uebersetzt.

**Commit-Vorschlag:** `CustomAI: Technikerzahl in Stufen; Speicher ab 4 T2-Extraktoren`

### Nachtrag 52: Startphase und Expansionsphase getrennt; keine T2-Extraktoren direkt

- **Was:** vier `Mass Extractor T2 - *`-Bauer dauerhaft gesperrt; Phasentrennung
  dokumentiert
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Der Fund: LOUD baut T2-Extraktoren aus dem Nichts

Vorgabe: *"nicht T3 bauen, sondern immer brav die Buildorder durchziehen"*.

In `Loud_AI_Engineer_Mass_Builders.lua` stehen vier Bauer, die einen **fertigen
T2-Extraktor** setzen, statt T1 zu bauen und aufsteigen zu lassen:

| Zeile | Bauer | wo |
|---:|---|---|
| 262 | `Mass Extractor T2 - 750 - Loop - BuildClose` | MAIN |
| 449 | `Mass Extractor T2 - 250 - DP` | Verteidigungspunkt |
| 537 | `Mass Extractor T2 - 750 - Loop - Expansion` | Aussenposten |
| 637 | `Mass Extractor T2 - 750 - Loop - Naval` | Marinebasis |

Sie brauchen T2-Techniker und greifen deshalb **erst in der Expansionsphase** - genau
dort, wo die Kette T1 > T2 > Speicher > T3 gelten soll. Alle vier jetzt dauerhaft aus.

**Der T1-Bau selbst war nie das Problem:** `DecideWhatToBuild` ist eine Enginemethode,
aber die Logs zeigen durchgaengig `uab1103` bzw. `xsb1103` - also T1. Die KI springt
nicht von sich aus auf eine hoehere Stufe; sie hatte nur zusaetzliche Bauer fuer den
Direktbau.

#### Die Phasentrennung

| | Startphase | Expansionsphase |
|---|---|---|
| Grenze | bis Ablauf der No-Rush-Frist | danach |
| Massepunkte | nur die vier im Basisumkreis (`StartMassepunkte = 4`, `MaxRange = 100`) | 750er- und 1500er-Staffel frei |
| Techniker | 2 / 4 / 8 in Stufen | dieselbe Obergrenze |
| Kraftwerke | ACU allein (T1) | Techniker uebernehmen |
| Kette je Extraktor | T1 > T2 > Speicher > T3 | **dieselbe** |

**Die Kette gilt in beiden Phasen automatisch**, weil sie an den Aufstiegsregeln haengt
(`FabrikAufstiegAbT2Extraktoren`, `ExtraktorAufstiegT3ErstVollUmbaut`,
`SpeicherAufstiegAbT3Extraktoren`) - und die pruefen **je Einheit**, nicht je Phase.

#### Nebenbefund: Speicher an Aussenposten

Es gibt in LOUD **keinen** Speicherbauer fuer Aussenposten - nur
`Engineer Mass Storage Construction` (MAIN) und `- Active DP`. Der MAIN-Bauer hat aber
`Construction.Radius = 600` und die Bedingung
`MassExtractorInRangeHasLessThanStorage { 'LocationType', 20, 600, 4 }`; er greift also
auch weit ausserhalb der Basis.

**Ob 600 in der Praxis bis zu den Aussenposten reicht, ist ungeprueft.** Falls nicht,
wuerde `ExtraktorAufstiegT3ErstVollUmbaut` dort dauerhaft blockieren - die Extraktoren
blieben auf T2. Im naechsten laengeren Lauf darauf achten.

**Commit-Vorschlag:** `CustomAI: keine T2-Extraktoren direkt; Phasentrennung dokumentiert`

### Nachtrag 53: Expansion erst nach der Frist - LOUD differenziert schon selbst

- **Was:** vier Expansions-BuilderGroups auf `Anteil 1.0`
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Die Sorge aus Nachtrag 52 war unbegruendet

Aussenposten haben sehr wohl einen Speicherbauer.
`Loud_Expansion_Standard.lua` fuehrt ihn in `LOUD_IS_Not_Installed_Builders`:

```lua
LOUD_IS_Not_Installed_Builders = {
    'Engineer Mass Fab Construction - Expansions',
    'Engineer Mass Storage Construction',
    'Engineer Energy Storage Construction',
    'Engineer Shield Construction - Expansions',
},
```

Da LOUD Integrated Storage aus ist, gilt genau diese Liste. Und weil `Mass Storage 600`
bewusst nicht gesperrt ist (`OriginalSperren = false`, Nachtrag 26), laeuft dort LOUDs
Original.

**Derselbe Fehler wie ganz am Anfang:** in `Builders` nachgesehen, obwohl ein
Basistemplate sieben Listen hat. Die Korrektur dazu steht seit dem ersten Tag in
`CustomAI_Stellschrauben.md` Ebene 3 - ich habe sie selbst geschrieben und trotzdem
nicht angewandt.

#### LOUD unterscheidet die Aussenposten bereits

Vorgabe: *"wenn wieder so eine 4er Gruppe, dann ist das im Kern eine Basis und darf voll
belegt werden. Einzelne Extraktoren brauchen nur minimal Schild und Defense."*

Genau das tut LOUD ueber den **Markertyp der Karte**:

| Markertyp | Template | Inhalt | EngineerCount |
|---|---|---|---|
| `Large Expansion Area` | `Loud_Expansion_Standard` | volle Basis: Fabriken, Verteidigung, Radar, Schilde, Artillerie, T4 | 2/3/4/9 |
| `Expansion Area` | `Loud_Expansion_Small` / `_Tiny` | je eine Fabrik, Extraktoren, Speicher, Radar | 1/2/2/2 |
| `Defensive Point` | `Loud_DP_Standard` / `_Small` | **nur** `Engineer Defenses DP Standard`, `Engineer Mass Builders - Defensive Point`, `Engineer Mass Storage Construction - Active DP` - keine Fabrikbauer | **0**/1/1/1 |

`Loud_DP_Standard` ist wortwoertlich "einzelner Extraktor, minimal Schild und Defense".
**Ein eigenes Expansionstemplate ist damit nicht noetig.**

#### Was tatsaechlich fehlte

Nur die Zeitsperre. `Engineer Construction - Land Base`, `- Land DP`, `- Naval Base` und
`- Naval DP` liegen jetzt auf `Anteil 1.0`.

Bei No-Rush `'Off'` ergibt `NoRushDauer()` null und die Sperre entfaellt - dann
expandiert die KI wie LOUD, was fuer Partien ohne Frist richtig ist.

#### Lehre

**Vor dem Bau eines eigenen Bauteils zuerst pruefen, ob LOUD den Fall schon
unterscheidet.** Das ist nach Nachtrag 41 das zweite Mal, dass ein geplanter Mechanismus
bei genauerem Hinsehen schon existierte - hier haette ein eigenes Expansionstemplate
drei Templates nachgebaut, die es fertig gibt.

**Commit-Vorschlag:** `CustomAI: Expansion erst nach Ablauf der No-Rush-Frist`

### Nachtrag 54: Gar kein Land

- **Was:** Landeinheiten und Land-Experimentals dauerhaft gesperrt
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Die Luecke

Landeinheiten waren bisher nur **zeitlich** gesperrt - Phase 4, ab 75 Prozent der Frist.
Dauerhaft aus waren nur die Landfabrikbauer. Ohne Fabrik entstehen zwar ohnehin keine
Landeinheiten, aber die Regel galt damit nur als **Nebenwirkung**, nicht als Aussage.

Das ist genau der Zustand, der spaeter zu Ueberraschungen fuehrt: faellt aus
irgendeinem Grund doch einmal eine Landfabrik an - ein erbeutetes Gebaeude, eine
Expansionsvorlage mit vorgebauten Strukturen -, produziert sie sofort.

Jetzt mit `Nie` gesperrt:

```
Factory Production Land
Factory Production Land - Land Only Map
Factory Production Land - Water Map
Engineer T4 Construction Land
Engineer T4 Construction Land - Expansions
```

#### Was ausdruecklich NICHT dazugehoert

`Engineer Construction - Land Base` und `- Land DP` klingen danach, sind es aber nicht:
das sind **Aussenposten an Land**, keine Landeinheiten. Die braucht auch eine reine
Luftwaffe - sie stehen weiterhin nur unter der Zeitsperre aus Nachtrag 53.

Die Verbandsbildung (`Land Formations - *`) bleibt frei. Ohne Landeinheiten bildet sie
nichts; eine Sperre waere eine Zeile ohne Wirkung.

#### Damit ist die Luftwaffe vollstaendig

| | |
|---|---|
| Fabriken | `FactoryCount` LAND 0 / SEA 0 / AIR 8; alle Land- und Marinefabrikbauer `Nie` |
| Einheiten | Landeinheiten `Nie`, T1-Einheiten `Nie`, Gunships und ASF auf Boden 650 |
| Experimentals | Land-T4 `Nie`, Luft-T4 in Phase 4 |
| Aussenposten | erlaubt, auch an Land - ab Ablauf der Frist |

**Commit-Vorschlag:** `CustomAI: keine Landeinheiten, auch nicht an Aussenposten`

### Nachtrag 55: Speicherschwellen, T3-Fabrikaufstieg, Kampfeinheiten

- **Was:** Speicher-Wirtschaftsschwellen gelockert; neue Regel
  `FabrikAufstiegT3AbT3Extraktoren`; Kampfeinheiten an T3-Techniker und Tor gebunden
- **Wo:** `usermods\CustomAI\hook\lua\defaultunits.lua`,
  `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### 1. Speicher kamen zu spaet - wieder eine Energieschwelle

Nicht die Prioritaet war die Bremse, sondern zwei Bedingungen im Original
(`Loud_AI_Engineer_Mass_Builders.lua` Z. 864-866):

```lua
{ EBC, 'GreaterThanEconEnergyStorageCurrent', { 2500 }},
{ EBC, 'GreaterThanEnergyTrendOverTime', { 20 }},
```

**2500 gelagerte Energie** - derselbe Wert, der schon bei `Assist Mass` die
Unterstuetzung verhinderte (Nachtrag 26). Zu diesem Zeitpunkt stehen erst wenige
T1-Kraftwerke; die Schwelle wird spaet erreicht.

Gelockert auf **500** und **5**. Ganz streichen waere falsch: Speicher sind teuer, und
bei negativem Energietrend soll die KI nicht weiterbauen.

**Das ist der dritte Fall derselben Sorte.** LOUDs Bauer tragen durchweg
Energieschwellen, die auf eine KI mit breiter Kraftwerksbasis zugeschnitten sind - eine
KI, die in der Eroeffnung bewusst wenig Strom baut, laeuft regelmaessig dagegen.

#### 2. T3-Fabrikaufstieg erst nach den T3-Extraktoren

Neue Regel `FabrikAufstiegT3AbT3Extraktoren = 4`. Der Hook bremst jetzt beide
Schritte getrennt:

| Schritt | Bedingung |
|---|---|
| Fabrik T1 -> T2 | 4 Extraktoren ab Stufe 2 |
| Fabrik T2 -> T3 | 4 Extraktoren der Stufe 3 |

#### 3. Kampfeinheiten erst nach Technikern und Tor

Neue Bedingung `TechnikerUndTorStehen` mit Wert 10: zehn **fertige** T3-Techniker und
ein Quantentor, das steht **oder im Bau ist** ("anfangen" genuegt laut Vorgabe).

Gilt zusaetzlich zur Phasengrenze `aTruppen`; Aufklaerung und Transporter bleiben bei
ihren eigenen Regeln.

**⚠ Die Kette wird lang:** Kampfeinheiten brauchen Tor und T3-Techniker, die T3-Fabrik,
die vier T3-Extraktoren, die Speicher, die vier T2-Extraktoren. Reisst ein Glied, baut
die KI gar keine Kampfeinheiten mehr. Im naechsten Lauf pruefen, ob die Kette vor Ablauf
der Frist durchlaeuft.

#### Offen: "nicht supporten"

Die Klammer *"(nicht supporten!!!)"* beim gleichzeitigen ACU-RAS ist nicht eindeutig -
sie kann heissen: der Fabrikaufstieg soll nicht unterstuetzt werden, oder das ACU-RAS
soll nicht unterstuetzt werden. Beides waere umsetzbar, aber die beiden Regeln schliessen
einander teilweise aus. **Rueckfrage laeuft, nichts geaendert.**

**Commit-Vorschlag:** `CustomAI: Speicherschwellen, T3-Fabrikaufstieg, Kampfeinheiten`

### Nachtrag 56: Das ACU-RAS wird nicht mehr unterstuetzt

- **Was:** Kopie `Assist SCU - NoRush` ohne den Kommandanten; neuer Platzhalter
  `'EngineerOhneACU'`
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`,
  `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Der Kommandant fordert die Unterstuetzung aktiv an

`CDREnhance` (`aibehaviors.lua` Z. 886-891) setzt beim Ausbau:

```lua
IssueScript( {unit}, {TaskName = "EnhanceTask", Enhancement = v} )
unit.CurrentBuildOrder = 'Enhance'
unit.DesiresAssist = true
unit.IssuedBuildCommand = true
unit.NumAssistees = 3
```

und nimmt es erst nach dem Ausbau zurueck (Z. 928-930). `Assist ACU SACU` zieht daraufhin
bis zu **drei Techniker** ab - genau in der Phase, in der sie die T3-Techniker und das
Quantentor voranbringen sollen.

#### Die Kopie

Der Kommandant faellt an beiden Stellen heraus, an denen die Kategorie geprueft wird:

| Stelle | alt | neu |
|---|---|---|
| `BuilderData.Assist.AssisteeCategory` | `categories.ENGINEER` | `ENGINEER - COMMAND` |
| `LocationEngineerNeedsBuildingAssistanceInRange`, Argument 2 | `categories.ENGINEER` | `ENGINEER - COMMAND` |

**Die SCU bleibt erfasst** - `SUBCOMMANDER` ist `ENGINEER`, aber nicht `COMMAND`. Die
Vorrangregel "bevorzugt SCU-RAS" aus Nachtrag 19 gilt unveraendert, ebenso die Bedingung
`KeinACUAusbau`, die waehrend des Ausbaus 120 Bauer zurueckstellt.

#### Neuer Platzhalter `'EngineerOhneACU'`

Kategorienausdruecke lassen sich in `AIDefinitions.lua` nicht schreiben - die Datei wird
auch von der Lobby-UI gelesen, und dort gibt es kein `categories`. Derselbe Weg wie bei
`'NoRushRadius'`: ein Name in der Definition, aufgeloest in `NoRush.lua`.

`BedingungArgAendern` loest die Platzhalter jetzt ebenfalls auf - vorher nur
`BuilderDatenWerte`.

#### Lehre

Beinahe haette ich hier "das geht ohnehin nicht" geantwortet: Aufstiege sind
Enhancements, und die schienen mir nicht unterstuetzbar. Erst der Blick in `CDREnhance`
zeigte, dass LOUD die Unterstuetzung **ausdruecklich anfordert**.

**Zweimal in dieser Sitzung war die Annahme "das gibt es nicht" falsch** (Nachtrag 21:
Speicher haben doch einen Aufstieg). Bei jedem "geht nicht" gehoert ein Blick in den
Code dazu, nicht nur ins Gedaechtnis.

**Commit-Vorschlag:** `CustomAI: ACU-RAS ohne Unterstuetzung, SCU weiterhin mit`

### Nachtrag 57: Beide RAS-Stufen des Aeon-Kommandanten

- **Was:** Kopie `Aeon CDR Upgrade - NoRush` mit `ResourceAllocationAdvanced`
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### LOUD kennt nur die erste Stufe

`Loud_AI_ACU_Builders.lua` Z. 999:

```lua
Enhancement = { 'ResourceAllocation', 'AdvancedEngineering', 'EnhancedSensors' },
```

Die zweite Stufe heisst **`ResourceAllocationAdvanced`**
(`units\units\UAL0001\UAL0001_unit.bp` Z. 505-513) und traegt
`Prerequisite = 'ResourceAllocation'` - sie kann also unmittelbar folgen.

| Stufe | Energie/s | Masse/s |
|---|---:|---:|
| `ResourceAllocation` | 2700 | 18 |
| `ResourceAllocationAdvanced` | **5400** | **36** |

Neue Liste:

```lua
{ 'ResourceAllocation', 'ResourceAllocationAdvanced',
  'AdvancedEngineering', 'EnhancedSensors' }
```

`CDREnhance` arbeitet die Liste der Reihe nach ab - die Position bestimmt die Abfolge.

#### Was das fuer die Kette bedeutet

Die 5400 Energie/s des Kommandanten liegen weit ueber den **2500**, die unsere
gelockerte Quantentor-Bedingung verlangt (Nachtrag 27). Der ACU allein traegt das Tor
damit sicher - die lange Kette aus Nachtrag 55 (Kampfeinheiten -> Tor -> T3-Techniker ->
T3-Fabrik -> T3-Extraktoren) wird an dieser Stelle deutlich robuster.

Dazu kommen 36 Masse/s - mehr als drei T3-Extraktoren.

#### ⚠ Gilt nur fuer Aeon

Der Builder traegt `FactionIndex = 2`. Wird die KI in der Lobby auf eine andere Fraktion
gestellt, greift die Kopie nicht und LOUDs Liste bleibt stehen. Seit die
Lobby-Vorbelegung verworfen wurde (Nachtrag 16), ist die Fraktion von Hand zu waehlen -
daran haengt jetzt also mehr als nur das Erscheinungsbild.

**Commit-Vorschlag:** `CustomAI: beide RAS-Stufen des Aeon-Kommandanten`

### Nachtrag 58: RAS fuer alle vier Fraktionen geprueft

- **Was:** Kopie `Seraphim CDR Upgrade - NoRush`; UEF und Cybran geprueft, nichts noetig
- **Wo:** `usermods\CustomAI\lua\AI\AIDefinitions.lua`
- **Getestet:** **nein**

#### Der Bestand

| Fraktion | RAS Stufe 1 | RAS Stufe 2 | LOUDs Liste beginnt mit RAS? |
|---|---|---|---|
| UEF | 3300 E/s, 14 M/s | **keine** | ja |
| Aeon | 2700 E/s, 18 M/s | 5400 E/s, 36 M/s | ja |
| Cybran | 3500 E/s, 12 M/s | **keine** | ja |
| Seraphim | 3000 E/s, 16 M/s | 6000 E/s, 32 M/s | ja |

Belege: `UEL0001_unit.bp` Z. 411, `UAL0001_unit.bp` Z. 484 und 505,
`URL0001_unit.bp` Z. 559, `XSL0001_unit.bp` Z. 655 und 673.

#### Was zu tun war

Nur Seraphim - dieselbe Luecke wie bei Aeon:

```lua
-- LOUD, Z. 1061
{ 'ResourceAllocation', 'AdvancedEngineering', 'RegenAura' }

-- neu
{ 'ResourceAllocation', 'ResourceAllocationAdvanced',
  'AdvancedEngineering', 'RegenAura' }
```

**Fuer UEF und Cybran gibt es nichts zu tun.** Ein
`ResourceAllocationAdvanced` existiert in ihren Blueprints nicht, und
`ResourceAllocation` steht in beiden LOUD-Listen bereits an erster Stelle. Eine Kopie
waere eine Kopie ohne Aenderung - die Begruendung steht als Kommentarblock in
`AIDefinitions.lua`, damit die Pruefung nicht bei der naechsten Durchsicht wiederholt
wird.

#### Nebenbei

Seraphim hat mit **6000 Energie/s** die staerkste zweite Stufe, Aeon mit **36 Masse/s**
die staerkste Masseausbeute. Beide liegen deutlich ueber den 2500 Energie/s, die unsere
gelockerte Quantentor-Bedingung verlangt.

Damit traegt der Kommandant das Tor bei allen vier Fraktionen: UEF 3300, Cybran 3500,
Seraphim 3000, Aeon 2700 - jeweils schon mit der ersten Stufe.

**Commit-Vorschlag:** `CustomAI: RAS-Stufe 2 auch fuer Seraphim`

### Nachtrag 59: `NoRushDauer` war zum Aufrufzeitpunkt kein Local

- **Was:** Vorwaertsdeklaration fuer `NoRushDauer`
- **Wo:** `usermods\CustomAI\lua\AI\AIs\NoRush.lua`
- **Getestet:** der Fehler ist im Log belegt, die Behebung **nicht**

#### Der Fehler

```
warning: Error running lua script: ...customai\lua\ai\ais\norush.lua(349):
         access to nonexistent global variable "NoRushDauer"
```

Zwoelf Mal im Log von Testlauf 24.

Zeile 349 steht in der Bedingung `LuftfabrikenGrenze`:

```lua
if aiBrain.CycleTime < NoRushDauer() then
```

`NoRushDauer` war als `local function` **nach** der Tabelle `Bedingungen`
definiert. Zum Zeitpunkt des Aufrufs ist der Name damit kein sichtbares Local,
sondern ein **Global** - und nicht gesetzte Globale sind im Sim ein Fehler, kein `nil`
(`system\config.lua`).

#### Die Auswirkung war nicht kosmetisch

`LuftfabrikenGrenze` haengt an drei Buildern: `Air Factory Balance`,
`Air Factory - Land Ratio High` und `Air Factory Balance - Expansion`. Bei jedem Aufruf
warf die Bedingung - **die Fabriken 2 bis 4 kamen also gar nicht**, obwohl Nachtrag 45
sie ab der ersten T3-Fabrik freigegeben hatte.

#### Die Behebung

`local NoRushDauer` als Vorwaertsdeklaration vor die Tabelle, die spaetere Definition
als Zuweisung (`NoRushDauer = function() ... end`) statt als `local function`. Damit
schliesst sie dasselbe Local.

#### Lehre

Das ist der **dritte** Fall desselben Musters in dieser Sitzung: `IsUnitState`
(Nachtrag 15), `LOUDFLOOR` (Nachtrag 19, vor dem Einbau bemerkt), jetzt `NoRushDauer`.
Alle drei waren Namen, die aussahen, als waeren sie verfuegbar.

Bei strikten Globals gilt: **jeder Name, der weder Parameter noch weiter oben
deklariertes Local ist, ist ein Global - und ein nicht gesetztes Global ist ein
Fehler.** Die Reihenfolge im Quelltext ist dabei entscheidend, nicht die Reihenfolge der
Aufrufe zur Laufzeit.

Eine Datei mit einer grossen Bedingungstabelle in der Mitte ist dafuer besonders
anfaellig: alles, was die Tabelle aufruft, muss darueber stehen.

**Commit-Vorschlag:** `CustomAI: NoRushDauer vorwaerts deklarieren`

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
