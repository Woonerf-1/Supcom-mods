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

### Aus dem Templatevergleich (2026-08-08)

- [x] **Testlauf 5:** erledigt 2026-08-08. Vier KIs, jede gewinnt ihre eigene Basiswahl -
      `Source` ist umschaltbar, die bewusste Fehlpaarung traegt.
- [x] **Zwei und mehr KIs / `BaseBuilderTemplates = nil`:** **kein Fehler aufgetreten.**
      Vier KIs liefen nacheinander durch `GetBestBasePlan`, alle erfolgreich, kein
      `access to nonexistent global variable`. Entweder weicht die installierte Fassung
      von `aiaddbuildertable.lua` ab, oder es gibt doch einen Reload.
      **Offen bleibt der Fall Aussenposten** - in Lauf 5 entstand keiner
      (kein `Creating new base`).
- [ ] **Ist `gamedata.entpackt\lua\lua\AI\aiaddbuildertable.lua` aktuell?** Falls der
      Punkt oben sich im Spiel nicht bestaetigt, ist der entpackte Stand die erste
      Verdaechtige. Pruefverfahren: `01_ARCHITEKTUR.md` Abschnitt 2.
- [ ] **`Builders[<name>].PriorityFunction` global umhuellen** - Muster fuer
      zeitgesteuerte KIs, aus dem Code abgeleitet (`sim\Builder.lua` Z. 209-224,
      `sim\BuilderManager.lua`), **im Spiel ungeprueft**. Offene Punkte: greift der
      Wrapper vor `Builder:Create`? Ist `aiBrain.CustomAIKey` in der
      `PriorityFunction` schon gesetzt? Bleiben fremde KIs wirklich unberuehrt?
      Beschreibung: `mods\CustomAI_Stellschrauben.md` Ebene 5.

### Aus den NoRush-KIs (2026-08-08)

**Testlauf 5 (2026-08-08) hat die Mechanik vollstaendig bestaetigt** - vier eigene KIs
gleichzeitig, jede gewinnt ihre eigene Basiswahl, `NoRushOption` kommt an, keine Warnung.
Auswertung in `mods\CustomAI.md`, Testlauf 5.

- [x] **Testlauf 6 / Registrierung und Sperren** - erledigt in Lauf 5:
      `95 Sperren gesetzt`, kein `Builder "..." nicht gefunden`, kein
      `BuilderGroup "..." nicht gefunden`.
- [x] **Kommt `NoRushOption` wirklich im Sim an?** **Ja.**
      `CUSTOMAI NoRush: Lobbyoption NoRushOption = 20 -> 1200 Sekunden`.
- [x] **Ist `aiBrain.CustomAIKey` beim ersten Aufruf der `PriorityFunction` gesetzt?**
      **Ja** - `NoRushDauer()` wird nur innerhalb des Sperrzweigs aufgerufen, die Zeile
      koennte sonst nicht erscheinen.
- [ ] **Gegenprobe mit No-Rush = Off:** erwartete Zeile
      `NoRushOption = Off -> 0 Sekunden`, danach normales LOUD-Verhalten von Beginn an.
- [ ] **Wirkt die Sperre im Spiel?** In Lauf 5 nicht beobachtbar - die Partie endete vor
      der ersten Phasengrenze (7:00 bei NoRush 20). **Naechster Lauf: NoRush-Einstellung
      auf 5 stellen**, dann liegen alle drei Grenzen bei 1:45 / 2:45 / 3:45.
      Zusaetzlich die Debug-Schalter `DisplayFactoryBuilds` und `EngineerDialog`
      einschalten - ohne sie steht im Log nicht, was gebaut wurde.
- [x] **ENTSCHEIDUNG: Fabrikbau in Phase 1 sperren?** **Ja, erledigt 2026-08-08.**
      Acht Fabrikbauer (4x MAIN, 3x Expansion, 1x Naval) sind bis Phase 3 gesperrt und
      danach dauerhaft auf Prioritaet 745 gedeckelt. Neuer Mechanismus `Prioritaet` in
      `NoRush.lua`. Ausgenommen: `ACU Tasks - Start Game` (erste Fabrik), die beiden
      Rebuild-Bauer, `Quantum Gate`.
- [ ] **Wirkt der Prioritaetsdeckel?** **Ungeprueft.** Zu pruefen im naechsten Lauf:
      baut die KI in Phase 1 wirklich nur eine Fabrik? Setzt sie nach Phase 3
      Wirtschaft vor Fabrik? Hilfsmittel: Debug-Schalter `PriorityDialog` - er
      protokolliert jede Prioritaetsaenderung, dort muesste `745` auftauchen.
- [ ] **Nebenwirkung des Deckels beobachten.** Mit nur einer Fabrik in Phase 1 sinkt
      die Ingenieurproduktion. **Vermutung:** der Wirtschaftsaufbau wird dadurch
      langsamer, nicht schneller - der Engpass koennte von "zu wenig Masse" auf "zu
      wenig Bauer" wechseln. Falls ja, Deckel lockern (z. B. 790, dann stehen Fabriken
      nur noch unter den Massextraktoren) oder die Sperre auf Phase 2 vorziehen.
- [ ] **Greift `AboveUnitCap75` noch?** `Land Factory Balance` hat im Original diese
      `PriorityFunction`. Unsere Umhuellung ruft sie weiter auf und deckelt nur das
      Ergebnis - im Log daran erkennbar, dass bei hoher Auslastung 10 statt 745 steht.
- [ ] **Tooltips ergaenzen** - 22 Warnungen `No tooltip in table for key: aitype_customai_*`
      in Lauf 5. `enhancedlobby.lua` Z. 289 liest
      `usermods\CustomAI\lua\AI\CustomAITooltips\*.lua` mit einer `Tooltips`-Tabelle.
      Die Texte stehen schon als `Description` in `AIDefinitions.lua`.
- [ ] **Bleiben fremde KIs unberuehrt?** In Lauf 5 lief keine Original-`AI: LOUD` mit.
- [ ] **Massestau in Phase 1.** `MassToFactoryValues` steuert, ab wann neue Fabriken und
      Basen entstehen. Ohne Truppenproduktion wird die Schwelle **vermutlich** sehr frueh
      gerissen. Falls die KI Fabriken baut, die nichts produzieren: `MassToFactoryValues`
      im `Apply()` anheben. **Ungeprueft.**
- [ ] **Zeiten nachjustieren** nach dem ersten echten 20-Minuten-Spiel.

### Aus der Baureihenfolge (2026-08-08)

- [x] **`aiBrain:GetCurrentUnits(categories.X)` in einer `PriorityFunction`** -
      Testlauf 6 lief ohne Absturz. **Noch nicht belegt ist, ob die Funktion wirklich
      aufgerufen wurde** - die Fabrikbauer waren wegen der Phasengrenze (7:00) ohnehin
      gesperrt und die Bedingung wird erst danach geprueft.
- [x] **ENTSCHEIDUNG: `Land Factory Rebuild` und `Air Factory Rebuild` mitsperren?**
      **Ja, erledigt 2026-08-08.** Zusammen mit `Land Factory Rebuild - Expansion` und
      `Naval Factory Rebuild`, in einer eigenen Phase **ohne** Prioritaetsdeckel - der
      Notfallwert 990 soll nach der Freigabe gelten.
- [ ] **Hat die KI jetzt wirklich nur eine Fabrik?** Im naechsten Lauf beobachten.
      Erwartung auf Karte ueber 1024: eine Luftfabrik vom ACU, sonst nichts bis
      Phase 3. **Ungeprueft.**
- [ ] **Greift der Hook auf `/lua/defaultunits.lua`?** Erwartete Logzeile beim ersten
      Aufruf: `CUSTOMAI Fabrikaufstieg: customai_norush erst ab 4 Extraktoren ab Stufe 2`.
      Fehlt sie, wurde `LaunchUpgradeThread` nie mit gesetztem `CustomAIKey` gerufen -
      oder der Hook greift nicht. **Ungeprueft, neues Hookziel.**
- [ ] **Steigt die Fabrik danach wirklich auf?** Der Hook tut bei nicht erfuellter
      Bedingung nichts und verlaesst sich darauf, dass `FactoryBuilderManager.lua`
      Z. 630-636 erneut aufruft, sobald die Bauschlange leer ist. Bleibt die Fabrik
      dauerhaft auf T1, ist diese Annahme falsch und es braucht doch einen Wartethread.
- [ ] **`Assist Mass` bleibt bei 740 - richtig so?** Der Builder unterstuetzt Bau und
      Aufstieg von Extraktoren ab Stufe 2 (Umkreis 120, 4 Instanzen). Die niedrige
      Prioritaet ist Absicht: er greift, wenn ein Ingenieur nichts Besseres zu tun hat.
      **Grenze:** die Bedingung `LessThanEconMassStorageRatio { 60 }` schaltet ihn ab,
      sobald das Masselager ueber 60 Prozent steht - in Phase 1 also womoeglich meistens.
- [x] **`BuilderConditions` und `InstanceCount` je KI aendern?** **Gebaut 2026-08-08** -
      Mechanismus `definition.Kopien` in `NoRush.lua`. Erste Anwendungen:
      `Assist Mass - NoRush` (ohne Lagerbedingung) und
      `Mass Storage 600 - NoRush` (4 statt 2 Instanzen).

- [ ] **Greift der Kopiermechanismus?** Erwartete Logzeilen:
      `Kopie "Assist Mass - NoRush" aus "Assist Mass"`,
      `Bedingung LessThanEconMassStorageRatio entfernt`,
      `BuilderGroup "CustomAI_customai_norush_EngineerBuilder" mit 2 Kopien an das
      Template gehaengt`. **Ungeprueft.**
- [ ] **Meckert `GlobalBaseTemplate.lua` beim Registrieren?** Es prueft, dass jeder Name
      in `template.Builders` in `BuilderGroups` existiert (Z. 33-37). Kaeme unsere Gruppe
      zu spaet, gaebe es dort eine Warnung. Die Reihenfolge in `Apply()` ist so gewaehlt,
      dass die Gruppe vor dem Anhaengen registriert wird - **ungeprueft**.
- [ ] **Ist `BuildersType` der Kopien richtig?** Beide sind `EngineerBuilder`. Bei
      Kopien von FactoryBuildern muss `Gruppentyp = 'FactoryBuilder'` gesetzt werden,
      sonst landet die Aufgabe beim falschen Manager.
- [ ] **Energieluecke zwischen T2-Deckel und T3-Ingenieuren.** `T3 Power Template` hat
      `BuilderType = {'T3','SubCommander'}`. Sind 4 T2-Kraftwerke erreicht, bevor der
      erste T3-Ingenieur steht, kann die KI **gar kein** Kraftwerk mehr bauen.
      Im Lauf auf Energieeinbrueche achten; notfalls T2-Grenze anheben.

### Aus Testlauf 6, Beobachtungen im Spiel (2026-08-08)

Alle folgenden Aenderungen sind **ungeprueft** und stammen aus einem einzigen Lauf.

- [ ] **Hilft die Kopie `Assist Mass - NoRush`?** Beobachtung war: vierter T2-Extraktor
      stieg nicht auf T3, stattdessen zweiter Speicher. Jetzt ohne Lagerbedingung,
      Prioritaet 844 gegen 843 beim Speicher.

### Aus Testlauf 8 (2026-08-08)

- [x] **Speicher kamen nach dem vierten T2-Extraktor nicht.** Ursache gefunden und
      behoben: der `false`-Zweig in der Umhuellung liess gesperrte Builder auf 10
      stehen, wenn sie keine eigene `PriorityFunction` hatten. Details im CHANGELOG,
      Nachtrag 18.
- [ ] **Kommen die Speicher jetzt?** Erste Sache, die im naechsten Lauf zu sehen sein
      muss - vier Speicher rund um jeden T2-Extraktor.
- [ ] **Welche Freigaben waren noch betroffen?** Jeder gesperrte Builder ohne eigene
      `PriorityFunction` kam bisher nie zurueck. Im naechsten Lauf pruefen, ob nach
      7:00 Flugabwehr und nach 11:00 Bodenabwehr tatsaechlich entstehen.
- [ ] **Steht die KI nach den Speichern wieder still?** Zwischen den vier T2-Extraktoren
      und 7:00 gibt es wenig zu tun: Extraktorplaetze belegt, Kraftwerke von LOUD selbst
      gedrosselt (`LessThanEnergyTrendOverTime { 45 }` in `T1 Power Template`), Fabriken
      und Verteidigung von uns gesperrt. **Moeglicherweise ist der Plan schlicht zu
      eng** - dann waeren Aussenposten (`Engineer Construction - Land Base`) der
      naechste sinnvolle Kanal.

### Aus der Eroeffnung (2026-08-08, Testlauf 7)

- [ ] **Steigen die T1-Extraktoren jetzt auf T2?** Das war die Kernbeobachtung: es
      passierte nicht. Zwei Ursachen vermutet, beide behoben - Speicher gesperrt
      (Massetrend) und Kraftwerke mitwachsend (Energietrend). **Ungeprueft, ob eine
      davon oder beide der Grund waren.**
- [ ] **Reichen 6 T1-Kraftwerke fuer 4 T1-Extraktoren?** Zahl vom Nutzer vorgegeben.
      Falls die Extraktoren weiterhin nicht aufsteigen, ist Energie nicht der Engpass -
      dann liegt es am Massetrend oder an fehlender Unterstuetzung.
- [ ] **Greift `T2KraftwerkeImWechsel` wie gedacht?** Die Regel "hoechstens T3-Extraktoren
      plus 1" erzeugt die Abfolge nur, wenn die T3-Aufstiege ueberhaupt anlaufen.
      Stockt der erste T3-Extraktor, bleibt es bei einem einzigen T2-Kraftwerk -
      **moeglicher Energieengpass**.
- [ ] **Kommen die Speicher nach der Freigabe schnell genug?** Kopie mit Prioritaet 843
      und vier Instanzen. Falls zu langsam: Instanzen weiter hoch.
- [ ] **Zaehlt `MindestensT2Extraktoren` das Richtige?** Die Bedingung zaehlt
      `MASSEXTRACTION - TECH1`, also T2 **und** T3. Steigt ein Extraktor weiter auf T3,
      bleibt er mitgezaehlt - gewollt.
- [x] **Sind 12 T1-Kraftwerke der richtige Deckel?** Ersetzt durch eine mitwachsende
      Grenze: Grundstock 6 plus 4 je Extraktor ab Stufe 2
      (`T1KraftwerkeNachBedarf`, 2026-08-08).
- [ ] **Fehlt der KI ohne T1-Aufklaerer etwas?** `Land Scout` und `Air Scout T1` sind
      dauerhaft gesperrt. Laut Nutzer unkritisch - Aufklaerung lohnt bei No-Rush
      ohnehin erst nach Ablauf der Frist.
- [ ] **Kommt die KI ohne T1-Einheiten ueberhaupt durch?** 13 Bauer dauerhaft aus.
      Falls zum Ablauf der No-Rush-Frist nichts dasteht, war die Sperre zu breit.
- [ ] **Greift `TransporterFreigabe`?** T3-Luftfabrik **und** Quantentor. Beides ist
      spaet - moeglicherweise kommen Transporter damit nie.

### Aus der Lobby-Vorbelegung (2026-08-08) - VERWORFEN

**Aufgegeben und zurueckgebaut.** Fraktion und Farbe werden von Hand gesetzt.

Befund aus Testlauf 7: der Hook auf `/lua/ui/lobby/lobby.lua` wurde **nie geladen** -
keine `CUSTOMAI Lobby:`-Zeile, kein `Hooked /lua/ui/lobby/lobby.lua`. Alle Hooks, die
greifen, greifen erst beim Laden der Partie:

```
 49  DISK: AddSearchPath: ...\usermods\customai, mounted as '/mods/customai/'
558  Hooked /lua/system/Blueprints.lua      (Sitzungsstart)
665  Hooked /lua/simInit.lua      mit /mods/customai/hook/lua/simInit.lua
721  Hooked /lua/aibrain.lua      mit /mods/customai/hook/lua/aibrain.lua
818  Hooked /lua/defaultunits.lua mit /mods/customai/hook/lua/defaultunits.lua
```

Der Mod ist ab Z. 49 gemountet, aber **Hooks werden erst beim Sitzungsstart angewandt** -
die Lobby laeuft davor. Auch die UI-Hooks anderer Mods erscheinen erst ab Z. 609, und
das sind In-Game-UI-Dateien.

**Einschaetzung des Nutzers:** geht vermutlich nur ueber einen Shadow-Mod, wie es die
Nomads-Fraktion macht. Nicht weiterverfolgt, weil unwichtig.

Die Hookdatei liegt zum Nachschlagen unter
`doc.claude\_ausrangiert\lobby.lua.ausrangiert`. Die Analyse darin bleibt gueltig:
`HostTryAddPlayer` ignoriert `requestedFaction`, `gameInfo` ist dateilokal, `SetPlayerOption`
waere der richtige Weg gewesen.

### Erweitertes Verhalten "Airforce General" (2026-08-08)

**Teil 1 gebaut:** `FactoryCount` LAND 0 / AIR 8 / SEA 0, Land- und Marinefabrikbauer
dauerhaft gesperrt, Gunships und ASF auf Boden 650, Aufklaerer auf Deckel 300.
Alle Einheitenbauer in `Loud_AI_Factory_Air_Builders.lua` liegen im Original bei 600 -
ein flaches Feld ohne jede Rangfolge.

- [ ] **Kleine Karten: die KI haette gar keine Fabrik.** Auf Karten bis 1024 baut der ACU
      ueber `CDR Initial Small Map` eine **Land**fabrik - und die ist jetzt dauerhaft
      gesperrt, ebenso der Rebuild-Bauer. Die KI stuende ohne Fabrik da.
      Abhilfe waere, `CDR Initial Small Map` und `CDR Initial Threat Nearby` zu sperren,
      damit `CDR Initial Large Map` uebrig bleibt - dessen Bedingung
      `MapGreaterThan 1024` wuerde dann aber ebenfalls scheitern. Sauber waere eine
      eigene Kopie des ACU-Startbauers mit `T1AirFactory`. **Noch nicht gebaut.**

#### Teil 2: Schwaerme, Czars und Zielwahl - noch nicht gebaut

Die Bausteine sind gefunden, alle in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBuilders\Loud_AI_Formations_Air.lua`:

| Wunsch | Stellschraube | Fundstelle |
|---|---|---|
| 100+ Gunships vor dem Angriff | `PoolGreaterAtLocation { 'LocationType', 27, AIRGUNSHIP }` und `PriorityFunction ... < 28 -> 10` in `Hunt Gunships Large` | Z. 1422-1450 |
| kein Angriff mit kleinen Gruppen | `Hunt Gunships Defensive/Local/Economic` sperren | Z. 1265, 1317, 1370 |
| Verband groesser als das Template | `MergeLimit` (aktuell 64) | Z. 1458 |
| Ziel der Gunships: AA, Schilde, Kraftwerke | `PrioritizedCategories` in `BuilderData` | Z. 1460 |
| Angriff ab 10 Czars | `Czar Group`, `PriorityFunction ... AIRT4 < 3 -> 10` | Z. 2058-2075 |
| Ziel der Czar: Kommandant | `PrioritizedCategories` in `Czar Group` | Z. 2088 |

**Was am Kopiermechanismus fehlt:**

- [ ] `BuilderData` teilweise ueberschreiben (`PrioritizedCategories`, `MergeLimit`,
      `MissionTime`) - bisher wird `BuilderData` nur tief kopiert, nicht veraendert
- [ ] Die Schwellen stehen in **PriorityFunctions**, nicht in Bedingungen. Fuer eine
      Kopie braucht es eine neue Funktion. Die kann nicht in `AIDefinitions.lua`
      stehen (die Datei liest auch die UI), also braucht es ein Namensregister wie
      bei den `Bedingungen` - etwa `PoolSchwelle('AIRGUNSHIP', 100)`.
- [ ] `Gruppentyp = 'PlatoonFormBuilder'` bei den Kopien setzen, sonst landen sie beim
      falschen Manager.

**Offene Sachfrage:** `PrioritizedCategories` wird bei `Hunt Gunships Large` mit
`categories.X`-Objekten befuellt, bei `Czar Group` dagegen mit **Zeichenketten**
(`'ANTIAIR STRUCTURE'`). Ob beide Formen ueberall funktionieren, ist **ungeprueft** -
`aibehaviors.lua` Z. 2965 reicht die Liste unveraendert weiter. Wenn Zeichenketten
ueberall gehen, koennte `AIDefinitions.lua` datenrein bleiben; sonst muessen auch die
Zielkategorien ins Register in `NoRush.lua`.

- [ ] **Ob ein Platoon ueberhaupt 100 Einheiten fassen kann**, haengt am
      `PlatoonTemplate` (`GunshipAttack Large`) und am `MergeLimit`. Die
      Platoon-Vorlagen in `lua\AI\PlatoonTemplates\` sind **noch nicht gelesen**.

### Aus dem ACU-Ausbau (2026-08-08)

- [ ] **Wird der ACU-Ausbau ueberhaupt erkannt?** Die Bedingung `KeinACUAusbau` prueft
      `u.Upgrading or IsUnitState(u, 'Enhancing')`. Fuer SCUs setzt
      `SCUSelfEnhanceThread` das Feld `Upgrading` ausdruecklich; **fuer den ACU ist es
      nicht belegt** - `CDREnhance` (`aibehaviors.lua` Z. 813) wurde nur bis Z. 855
      gelesen. Faellt beides durch, greift die Sperre nie und es passiert schlicht
      nichts (harmlose Richtung). Im Spiel beobachten, ob die KI beim ACU-Ausbau
      wirklich stillsteht.
- [ ] **Kostet die Erkennung zu viel Rechenzeit?** `aiBrain:GetListOfUnits(COMMAND)`
      laeuft hoechstens einmal je Tick und Brain (Zwischenspeicher in `NoRush.lua`).
      Bei mehreren KIs auf einer Karte auf Ruckler achten.
- [ ] **Verklemmt sich die KI, wenn der Ausbau haengt?** Bricht der Ausbau nicht sauber
      ab, blieben 24 BuilderGroups dauerhaft auf 10. `SCUSelfEnhanceThread` hat dafuer
      eine Zaehlerschleife; ob `CDREnhance` das auch hat, ist **ungeprueft**.
      Notausstieg waere eine zusaetzliche Zeitgrenze in `ACUBautAus`.
- [ ] **Sollen die ACU-Ausbaubedingungen gelockert werden?** `GreaterThanGameTime { 420 }`
      verhindert jeden Ausbau vor 7:00, dazu kommt
      `GreaterThanEconTrendEfficiencyOverTime { 2, 75, 1.015, 1.025 }`. Wenn die vier
      T2-Kraftwerke frueher stehen, wartet der ACU trotzdem. Mit dem Kopiermechanismus
      waere eine eigene Fassung je Fraktion moeglich - **noch nicht entschieden**,
      weil es vier bis fuenf Kopien braucht.
- [ ] **Steht T3-Flak jetzt wirklich zuerst?** Boden 760 gegen 750/751 im Rest der
      Verteidigung. Falls die KI trotzdem T2-Flak setzt, liegt es an den
      `BuilderConditions` (T3 braucht T3-Ingenieure), nicht an der Prioritaet.
- [ ] **Ist der Fabrikriegel "4 T3-Extraktoren" zu streng?** Er gilt ZUSAETZLICH zur
      Phasengrenze. Bei No-Rush 5 (Phase 3 bei 2:45) hat die KI dann kaum T3-Extraktoren
      - die Fabriken kaemen also praktisch nie. **Vermutung, ungeprueft.** Falls ja:
      Wert senken oder die Bedingung nur fuer laengere No-Rush-Zeiten setzen.
- [ ] **Quantentor auf 855 - zu aggressiv?** Das Tor ist teuer und steht jetzt ueber den
      nahen Massextraktoren (850). Wenn die Wirtschaft darunter einbricht, diesen Eintrag
      streichen; 850 war ohnehin schon in der Spitzengruppe.
- [ ] **SCU-Grenze 20 ausreichend?** Ergibt bei Einheitenlimit 5000 dreissig SCUs.
      Beobachten, ob die KI die Grenze ueberhaupt erreicht oder vorher an der
      Wirtschaft haengt.
- [ ] **Massespeicher auf 843 - Nebenwirkung?** Speicher stehen jetzt ueber
      `Mass Fab T2` (800) und den entfernten Extraktoren (760/755). **Vermutung:** die KI
      besetzt entfernte Massepunkte spaeter. Falls das stoert, auf 805 senken.
- [ ] **OPTIONAL: Hook auf `/lua/defaultunits.lua`** fuer die Aufstiegsschwellen der
      Extraktoren (`LaunchUpgradeThread`, Z. 793-820). Damit liesse sich der Weg
      T1 -> T2 -> T3 beschleunigen oder verzoegern. **Noch nicht entschieden** - waere
      ein neues Hookziel und beruehrt jede Einheit, nicht nur unsere KI. Die Weiche
      ueber `aiBrain.CustomAIKey` waere aber genauso moeglich wie bei den Buildern.
- [ ] **Reicht der Aufklaerungsvorlauf?** Aufklaerung laeuft erst ab Phase 4, also bei
      75 Prozent der No-Rush-Frist. Bedrohungskarte, Gegnerwahl
      (`loudutilities.lua` ab Z. 6270) und `CreateAttackPlan` starten dann bei null.
      Ob das restliche Viertel genuegt, ist **ungeprueft**. Im Log auf `AttackPlan`
      achten (Debug-Schalter `AttackPlanDialog`). Falls zu spaet: eine eigene Phase
      fuer die Aufklaerung einziehen, etwa bei 0.60.

### Aus der Small/Smaller-Frage (2026-08-08)

- [ ] **Bauen Small und Smaller unterm Strich weniger Einheiten als Standard?**
      **Vermutung war: ja - das ist nicht belegt und eher zweifelhaft.** Die
      Fabrik- und Ingenieurgrenzen gelten je Basis (`FactoryCapCheck`,
      `BelowEngineerCapCheck` lesen
      `aiBrain.BuilderManagers[locationType].BaseSettings`), nicht je Armee. Bei
      gleichen `MassToFactoryValues` und weniger Fabriken an MAIN faellt
      `MassToFactoryRatioBaseCheck` frueher positiv aus - die KI expandiert also
      **frueher**, statt zu sparen. Gegenlaeufig: `ExistingBasesHaveGreaterThanFactory`
      und `AboveUnitCap65`. Messbar im Testlauf 5: Zahl der Basen und
      `GetArmyUnitCostTotal` gegen einen Standard-Lauf auf derselben Karte.
- [ ] **Wohin fliesst der Ueberschuss bei Smaller?** Kein Paragon-Bauer, keine
      T4-Wirtschaftsverteidigung. Beobachten, ob die KI stattdessen mehr expandiert
      oder ob Masse ungenutzt im Lager steht.

### Noch nicht gelesen (`mods\CustomAI_Stellschrauben.md`)

- [ ] **Die Manager im Inneren** - wie `aiBrain.BuilderManagers` Builder auswaehlen und
      ausfuehren. Meistgenutzte Struktur der KI (79 Vorkommen), Arbeitsweise unbekannt.
- [ ] **Zielauswahl der Angriffsplanung** - `AttackPlan.Goal` wird in
      `loudutilities.lua` ab Z. 1368 verwendet, aber woher kommt das Ziel?
- [ ] `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\SkirmishStrategyList.lua`
- [ ] `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\aibehaviors.lua`
- [ ] **Wirkung von `BuilderType` und `InstanceCount`** - bislang nur aus dem Namen
      erschlossen.
- [ ] **Debug-Schalter ausprobieren** - `ReportRatios` und `AttackPlanDialog` sind die
      beiden aussagekraeftigsten. Einmal einschalten und sehen, was im Log landet.

---

### Aus der Ableitung von `UEF_trans_men` (2026-08-15) - `18_ABLEITUNG.md`

- [x] **Alle 25 Blueprints gegen ihre LOUD-Originale gediffed.** 15 von 25 sind
      unveraenderte Kopien. Ergebnis in `18_ABLEITUNG.md` Abschnitt 2.
- [x] **`mount_mods`, `hook`, `shadow`, `Merge` am Code nachgeprueft** - `18_ABLEITUNG.md`
      Abschnitt 3. Korrektur einer frueheren Fehlannahme: ein `lua\sim\...` im Mod ist
      legitim, entscheidend ist der Inhalt der Datei, nicht der Ort.
- [x] **`SquareShields` vollstaendig geprueft** - `mods\SquareShields.md`.
      Befund: Vollkopie aus `LOUD Unit Additions` ohne jede Aenderung, Aufstiegsstufe
      `...02` fehlt.
- [x] **ENTSCHEIDUNG getroffen (2026-08-15):** Der Mod ist ein **Extrakt** aus
      `LOUD Unit Additions` - nur die vier Schilde der Stufe 01, **ohne** Aufstieg,
      `conflicts` gegen `LOUD Unit Additions`, `LOUD Integrated Storage` wird ignoriert.
      Damit ist die Vollkopie der richtige Mechanismus. Umgesetzt, siehe CHANGELOG.
- [ ] **Zeigt Thanatos eine Todesanimation?** `SquareShields\units\XSBSSG01\XSBSSG01_unit.bp`
      Z. 61 verweist auf `/units/XSBSSG01/XSBSSG01_ADeath1.sca`. Diesen Pfad gibt es im
      VFS nicht (`/units/` speist sich nur aus `units.scd` und `civ_units.scd`). **Ob die
      Engine trotzdem aufloest, ist unbelegt** - die Aufloesung von `.sca`-Pfaden steht
      nicht im Lua-Code, und das Log meldet fehlende Ressourcen nicht. Der Pfad steht so
      auch im Original von `LOUD Unit Additions` und in `XSBSSG02`.
      Wenn die Animation fehlt: auf `/mods/squareshields/units/XSBSSG01/...` aendern.
- [x] **`ImprovedHydrocarbonPowerPlants` vollstaendig geprueft** (2026-08-15) -
      `mods\ImprovedHydrocarbonPowerPlants.md`. Alle acht Scripts und sechs von acht
      Blueprints byte-identisch mit `BlackOpsUnleashed`; uid auf GUID, `conflicts`
      gesetzt. Wichtigster Befund: LOUDs Basiseinheiten `UEB1102` / `UAB1102` / `URB1102`
      / `XSB1102` verweisen selbst auf `beb1202` & Co - ohne diesen Mod zeigt der
      Aufstieg ins Leere.
- [x] **ENTSCHEIDUNG getroffen (2026-08-15): die Aeon-Abweichung.** Alle vier Fraktionen
      gleich, Wahl zentral. Umgesetzt ueber `config.lua` plus Hook auf `ModBlueprints`;
      `BAB1202`/`BAB1302` zurueck auf den BlackOps-Wert, `RegenRate = 10` entfernt.
      Alle acht Blueprints sind jetzt byte-identisch mit `BlackOpsUnleashed`.
- [ ] **MULTIPLAYER: wird die Mod-Konfiguration uebertragen?** `mods.lua` Z. 266 liest
      sie aus `Prefs.GetFromCurrentProfile("modConfig")`, also **lokal**. Ob die Lobby
      den gewaehlten Wert an alle Spieler weitergibt, ist **nicht geprueft**. Falls
      nicht, laufen bei unterschiedlichen Einstellungen die Blueprints auseinander -
      Desync. **Vor dem Gruppeneinsatz klaeren.** Betrifft jeden kuenftigen Mod mit
      `config.lua`.
- [ ] **Erscheint `config.lua` im Mod-Manager?** Neu und ungeprueft. Erwartet: zwei
      Auswahlfelder. Erscheint stattdessen `has an empty or malformed config file` im
      Log, ist die Datei fehlerhaft.
- [ ] **Werden die Mod-Bilder angezeigt?** Beide Mods verweisen mit `icon` auf ein `.dds`
      aus `textures.scd` statt auf eine eigene Datei. Aus `modmanager.lua` Z. 1131/1365
      abgeleitet, **nicht im Spiel gesehen**.
- [ ] **Baut die KI die Hydrocarbon-Aufstiege?** `BO_Buildings.lua` in
      `BlackOpsUnleashed` fuehrt eine `UnitList` fuer LOUDs KI - die Hydrocarbons stehen
      **nicht** darin. Ob die KI sie ueber die normalen Kraftwerks-Builder aufsteigt, ist
      ungeprueft. Haengt am ungelesenen Mechanismus hinter `lua\CustomUnits\`.
- [ ] **Was aendert `LOUD Integrated Storage` an `BEB1302` / `BAB1302` / `BRB1302` /
      `BSB1302`?** Merge unter `loud_misc\mods\LOUD Integrated Storage\hook\units\`,
      Inhalt noch nicht geprueft.
- [ ] **`t4add` und `dynamic_gameplay` einzeln durchgehen** - je ein Dokument unter
      `mods\` nach dem Muster von `SquareShields.md`. Beide haben noch keine GUID und
      kein `conflicts`.
- [ ] **Ordnernamen von `t4add` und `dynamic_gameplay` pruefen.** `HCPP` wurde 2026-08-15
      in `ImprovedHydrocarbonPowerPlants` umbenannt; beide anderen sind ebenfalls nicht
      selbsterklaerend - beim jeweiligen Durchgang mitentscheiden.
- [ ] **Laeuft BrewLANs Hook `hook\lua\sim\AdjacencyBuffs.lua` unter LOUD ueberhaupt?**
      Er referenziert `AdjBuffFuncs` und `DefaultBuffAffect`; beide sind in
      `gamedata.entpackt\lua\lua\sim\AdjacencyBuffs.lua` **`local`** (Z. 1, 3, 4). Ein
      Hook laeuft in derselben Umgebung, sieht aber die Locals des Originalchunks nicht.
      **Nur mit einem Testlauf bei aktivem `BrewLAN_Units` zu klaeren.** Erwartete
      Logzeile: `Hooked /lua/sim/AdjacencyBuffs.lua with ...`, danach entweder Ruhe oder
      ein `attempt to index nil`.
- [ ] **Stammen die Wertaenderungen an `UAL0402`, `UEL0402`, `WEL0401` vom Kollegen oder
      aus `UEF_trans_men`?** Stichprobe `UEBSSG01`: identisch, also Altbestand. Die drei
      grossen sind **noch nicht gegen `UEF_trans_men` gediffed**.
- [x] **`.sca`-Pfade: wie loest die Engine sie auf?** Geklaert 2026-08-15 durch drei
      Testlaeufe mit `PlayTest`. **Strikt und absolut** - kein Rueckfall auf das
      Blueprint-Verzeichnis, keine Dateinamensuche, keine Suche innerhalb von `/units/`.
      Fehlschlaege bleiben stumm, kein Logeintrag. Regel in `07_KONVENTIONEN.md`
      Abschnitt 4, Auswertung im CHANGELOG (7).
- [ ] **Greifen Hooks auf `/lua/sim/Unit.lua` ueberhaupt?** Beim ersten Testanlauf wurde
      eine Umhuellung von `Unit.PlayAnimationThread` laut Log geladen und lief fehlerfrei,
      **wurde aber nie aufgerufen** - obwohl im selben Lauf zwei Gebaeude mit
      `AnimationDeath` gesprengt wurden.
      **Vermutung, UNBELEGT:** `Class()` kopiert die Methoden der Elternklasse beim
      Anlegen der Unterklasse, statt sie ueber eine Metatabelle nachzuschlagen. Dann
      traegt `StructureUnit` aus `/lua/defaultunits.lua` weiterhin die Originalfassung.
      **Reichweite:** falls das stimmt, sind Hooks auf `/lua/sim/Unit.lua` fuer die
      meisten Einheiten wirkungslos - das betrifft auch fremde Mods, die genau das tun.
      Pruefverfahren: `Class()` in `gamedata.entpackt\lua\lua\system\Class.lua` (oder wo
      immer sie definiert ist) lesen; Gegenprobe mit einem Hook auf
      `/lua/defaultunits.lua`, der `StructureUnit.OnKilled` umhuellt - dass Hooks dort
      greifen, ist belegt (`Hooked /lua/defaultunits.lua with /mods/customai/...`).
      Stillgelegte Testdatei: `usermods\PlayTest\hook\lua\sim\Unit.lua`.
- [ ] **`t4add\units\SSL0403`: drei kaputte Pfade korrigieren.**
      `/mods/brewlan/mods/BrewLAN_LOUD/units/ssl0403/...` in Z. 82, 88 und 620 - richtig
      waere `/mods/BrewLAN_LOUD/...`. Seit 2026-08-15 **belegt** kaputt (siehe oben),
      kostet Iyadesu Lauf-, Angriffs- und Todesanimation. Kommt beim Durchgang von
      `t4add`.
- [ ] **`PlayTest` aufraeumen.** Beide Hooks sind stillgelegt, enthalten aber noch die
      Befunde als Kommentar. Loeschen, sobald sie in `07_KONVENTIONEN.md` und `TODO.md`
      vollstaendig aufgegangen sind.

### Aus dem Durchgang DynamicGameplay (2026-08-15)

- [x] **Dreifachvergleich Original -> `UEF_trans_men` -> Extrakt** fuer alle vier
      Blueprints und alle vier Scripts. Ergebnis: **der Extrakt aendert kein
      Spielverhalten**, nur Pfade und Importe. Alle inhaltlichen Abweichungen stammen aus
      `UEF_trans_men`.
- [x] **Ballast nach `_Altlasten` verschoben:** `lua\legacy\VersionCheck.lua`,
      `lua\sim\AdjacencyBuffs.lua`, `lua\sim\Buff.lua`,
      `units\BSB2402\BSB2402_Script.lua.original`. `unitdescription.lua` von zehn auf
      drei Eintraege gekuerzt.
- [ ] **`DarknessEffect` existiert nicht** - `SRB4402_script.lua` Z. 76 ruft
      `Buff.ApplyBuff(v, 'DarknessEffect')` auf. In BrewLAN gesucht und in keiner der
      plausiblen Dateien gefunden; der Aufruf laeuft also schon im Original ins Leere.
      Der einzige Darkness-Bezug in BrewLAN ist die **Kategorie** `DARKNESSIMMUNE`
      (`BrewLAN_LOUD\hook\lua\system\Blueprints.lua` Z. 239).
      **Entscheidung 2026-08-15: nicht geaendert**, Zeile bleibt wie im Original.
      Offen bleibt: (1) was `ApplyBuff` mit unbekanntem Namen tut - `Buffs[buffName]`
      waere `nil`, das kann still nichts tun oder einen Sim-Fehler ausloesen; im
      Testlauf mit gebautem Darkness am Log ablesbar. (2) Ein vollstaendiger
      Negativbeweis braucht ein Suchskript in `doc.claude\tools\` - bisher wurden nur
      die plausiblen Kandidaten gelesen (`CLAUDE.md` Abschnitt 4).
- [x] **`DarknessEffect` existiert nicht** - **RICHTIGSTELLUNG 2026-08-16:** der Buff ist
      sehr wohl definiert, und zwar **LOUD-eigen** in
      `gamedata\lua\lua\sim\buffdefinitions.lua` Z. 217. Der frühere Befund war falsch -
      es wurde nur nach BrewLANs Namen `DarknessOmniNerf` gesucht, nie nach
      `DarknessEffect`. Der Darkness funktioniert.
- [x] **Warum schaltet sich das Panopticon ab?** Geklaert 2026-08-16 durch vier
      Testlaeufe: LOUDs `IntelWatchThread` vergleicht den gespeicherten Energievorrat
      gegen den Sekundenverbrauch und ignoriert das Einkommen. Siehe
      `mods\BasegameBugfixes.md` **B-03**. Nicht behoben, Behelf: genug Energiespeicher.
- [ ] **Vier Verhaltensabweichungen aus `UEF_trans_men` - Entscheidung offen:**
      `SEB3404` Radar- statt Omni-Radius und Mauern/Minen nicht mehr ausgenommen
      (`SEB3404_Script.lua` Z. 72); `SRB4402` ohne `sab2306` in der Ausnahmeliste, also
      Darkness trifft Aeons Aria mit (Z. 74); `SRB4402` toter `BrewLANPath`-Aufruf (Z. 5).
      Jeweils zurueck aufs Original oder behalten?
- [ ] **Sieben Beschreibungstexte nach `t4add` uebernehmen** - liegen in
      `_Altlasten\DynamicGameplay\unitdescription.lua.vollstaendig`. **Achtung:** die
      Texte zu `ual0402` und `urs0304` sind interne Scherze und erscheinen so im Spiel.

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
