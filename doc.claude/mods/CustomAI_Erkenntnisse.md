# CustomAI - Erkenntnisse

Gesammelte Sachkenntnis aus der Entwicklung von `customai_aeon_air`
(Testlaeufe 1 bis 25, Stand 2026-08-08).

Diese Datei ist die Grundlage fuer `AI: LOUD Aeon Airforce 2` und fuer jede weitere
KI. Sie enthaelt **Fakten ueber LOUD** und **methodische Lehren** - keine
Designentscheidungen. Die Bauordnung selbst steht in `CustomAI.md`.

---

## 1. Wo Entscheidungen fallen

Drei Ebenen bestimmen, was am Ende gebaut wird. Sie greifen an verschiedenen Stellen,
und eine Aenderung auf der falschen Ebene bleibt wirkungslos.

| Ebene | bestimmt | wann geprueft |
|---|---|---|
| `BuilderConditions` | **ob** ein Auftrag beginnt | einmal, vor dem Auftrag |
| `Priority` / `PriorityFunction` | **welcher** Auftrag gewinnt | bei jeder Auswahl |
| `PlatoonTemplate` | **wie viele** Einheiten der Auftrag umfasst | beim Auftrag |

**Eine Obergrenze auf Ebene 1 kann eine Stueckzahl auf Ebene 3 nicht korrigieren.**
`T1BuildEngineerInitial` (`lua\AI\PlatoonTemplates\Loud_AI_Factory_Platoons.lua` Z. 27)
steht auf `{ <blueprint>, 1, 3, ... }` - der Builder erzeugt drei Techniker auf einen
Schlag, egal was die Bedingung sagt.

### `GetHighestBuilder` prueft nur das oberste Prioritaetsband

`sim\BuilderManager.lua`. Wer niedriger steht, kommt erst dran, wenn oben nichts uebrig
ist. Das macht Prioritaetsbaender zum wirksamsten Ordnungsmittel - und erklaert, warum
ein Boden von 852 gegen einen Extraktorbauer bei 850 den Unterschied macht.

### `LoopBuild` umgeht die Auswahl vollstaendig

`platoon.lua` Z. 8872-8898, am Ende von `ProcessBuildCommand`:

```lua
if self.PlatoonData.Construction.LoopBuild and self.PlanName then
    if GetEconomyStored(aiBrain,'MASS') >= LoopMass ... then
        self:SetAIPlan( self.PlanName, aiBrain )
        return
```

Das Platoon startet denselben Builder erneut, **ohne** ueber `GetHighestBuilder` zu
gehen. Ein Techniker mit `LoopBuild` fragt nie wieder, was zu tun waere. Jede
Prioritaetsaenderung ist fuer ihn wirkungslos.

Im `EngineerDialog` erkennbar an der **Abwesenheit** weiterer `adding "..."`-Zeilen.

---

## 2. Codepfade, die Werte ignorieren

### Massextraktoren laufen nicht ueber den Normalpfad

Bei `IsResource(buildingType)` reicht `AIBuildBaseTemplateOrdered` an
`AIExecuteBuildStructure` weiter (`aibuildstructures.lua` Z. 43). Dort ab Z. 97:

```lua
if testtype == 'Mass' and aiBrain.StartingMassPointList[1] then
    location = LOUDREMOVE(aiBrain.StartingMassPointList, 1)
    if CanBuildStructureAt( aiBrain, testunit, location ) then
        constructionData.MaxRange = 1500
```

Solange die Liste nicht leer ist, nimmt der Techniker stur den naechsten
**Listeneintrag**. `MaxChoices` wird gar nicht gelesen, `MaxRange` sogar aktiv
ueberschrieben.

### `StartingMassPointList`

Entsteht in `InitializeArmies` (`ScenarioUtilities.lua` Z. 1036-1075), also **nach**
`OnCreateAI`. Jede KI bekommt `MassPointShare` Punkte zugeteilt (Z. 954:
`min( 12 + PlayerCount, floor(NumMassPoints/PlayerCount) - 1 )`), sortiert nach der
**Startposition der Armee** - nicht nach der Fabrik, an der die Techniker stehen.

### `UpgradeIssuedLimit`

`ScenarioUtilities.lua` Z. 970 setzt **1**, mehr nur bei Unterzahl. `SelfUpgradeThread`
prueft das vor jedem Aufstieg (`aibehaviors.lua` Z. 8732). Armeeweit laeuft also nur ein
Selbstaufstieg zur Zeit - Extraktoren, Fabriken und Speicher in derselben Schlange.

---

## 3. Ableitungsfallen in `defaultunits.lua`

**Die Basisklasse zu umhuellen reicht nie.** `defaultunits.lua` leitet siebzehn Klassen
von `StructureUnit` ab (Z. 2046 bis 4911), alle beim Laden der Datei - also **vor**
jedem Hook. Sie zeigen danach weiter auf die alte Klasse.

| Klasse | Zeile | enthaelt |
|---|---:|---|
| `FactoryUnit` | 2046 | Fabriken |
| `MassCollectionUnit` | 3146 | Extraktoren |
| `EnergyCreationUnit` | 3110 | Kraftwerke |
| `MassFabricationUnit` | 3253 | Fabrikatoren |
| `EnergyStorageUnit` | 3127 | Energiespeicher |
| `AirStagingPlatformUnit` | 2974 | |
| `RadarUnit`, `SonarUnit`, `ShieldStructureUnit` | 3324, 3424, 3446 | |

**Was erst in den Einheitenskripten entsteht, bekommt die Umhuellung.** Massespeicher
gehoeren dazu - `units\units\UAB1106\UAB1106_script.lua` Z. 1 importiert `StructureUnit`
direkt, und das passiert nach dem Hook.

**Mobile Einheiten sind nicht erreichbar:** die Unterklassen von `MobileUnit` stehen
ebenfalls vor dem Hook fest.

---

## 4. Strikte Globals

Ein Name, der weder Parameter noch weiter oben deklariertes Local ist, ist ein
**Global** - und ein nicht gesetztes Global wirft (`lua\system\config.lua`), es ergibt
kein `nil`.

Drei Faelle in dieser Entwicklung:

| Name | tatsaechlich |
|---|---|
| `IsUnitState` | `moho.unit_methods.IsUnitState` - in LOUDs Dateien nur eine dateilokale Kopie |
| `LOUDFLOOR` | dasselbe, richtig ist `math.floor` |
| `NoRushDauer` | eigene Funktion, aber **nach** der Aufrufstelle definiert |

**Die Reihenfolge im Quelltext zaehlt, nicht die der Aufrufe zur Laufzeit.** Eine Datei
mit einer grossen Bedingungstabelle in der Mitte ist besonders anfaellig: alles, was die
Tabelle aufruft, muss darueber stehen. Vorwaertsdeklaration (`local Name` vor der
Tabelle, Zuweisung danach) loest das.

Fuer moeglicherweise ungesetzte Globale: `rawget(_G, 'Name')`.

---

## 5. Zaehlweisen

| Aufruf | zaehlt |
|---|---|
| `aiBrain:GetCurrentUnits( cat )` | nur **fertige** Einheiten |
| `aiBrain:GetListOfUnits( cat, false, false )` | einschliesslich angefangener Bauten |
| `aiBrain:GetNumUnitsAroundPoint( cat, pos, r, 'Ally' )` | einschliesslich Baustellen |
| `unit:GetFractionComplete() == 1` | die einzige zuverlaessige Fertigkeitspruefung |

**Regel:** Untergrenzen zaehlen fertige Einheiten (ein aufsteigender Extraktor foerdert
noch nicht), Obergrenzen zaehlen angefangene mit (sonst wird die Grenze um eins
ueberschritten, weil die Fabrik das ueberzaehlige Stueck laengst begonnen hat).

---

## 6. Wiederholungsversuche

**Ein aufgeschobener Aufstieg wird nicht von selbst nachgeholt.**
`FactoryBuilderManager.lua` Z. 617-636 ruft `LaunchUpgradeThread` nur, wenn die Fabrik
gerade eine Einheit **fertig gebaut** hat. Eine Fabrik, die nichts produziert, fragt nie
wieder. Ein Hook, der `return` macht, braucht deshalb einen eigenen Wartethread.

**Untaetige Techniker warten immer laenger.** `EngineerManager.lua` Z. 391-399:
`min( 101, 14 + failedbuilds * 5 )` Ticks. Nach rund 18 vergeblichen Anlaeufen sind es
zehn Sekunden - so lange steht ein Techniker noch herum, nachdem wieder etwas zu tun
waere.

**`10, true` gegen `0, false`:** `SetPriority` (`sim\Builder.lua` Z. 253-256) loescht bei
`temporary = false` die `OldPriority`. Fuer eine Sperre auf Zeit ist nur `10, true`
richtig - und sie braucht **immer einen aktiven Rueckweg**. Wer nur den Hinweg baut,
merkt es erst, wenn die Bedingung tatsaechlich umschlaegt.

---

## 7. Templates und Datenstrukturen

### Ein Basistemplate hat sieben Builder-Listen

`Builders`, `WaterMapBuilders`, `LandOnlyBuilders`, `StandardCommanderUpgrades`,
`BOACUCommanderUpgrades`, `LOUD_IS_Installed_Builders`, `LOUD_IS_Not_Installed_Builders`
(`AI\aiaddbuildertable.lua`). Nur `Builders` wird beim Registrieren auf gueltige
Gruppennamen geprueft.

### `BaseSettings` gilt je Basis

`FactoryCapCheck` und `BelowEngineerCapCheck` lesen
`aiBrain.BuilderManagers[locationType].BaseSettings`. Unsere Werte gelten also nur fuer
`MAIN`; Aussenposten bringen ihre eigenen mit.

`BelowEngineerCapCheck` rechnet zusaetzlich: `max( n, floor(n * CheatValue^2) )` plus
`min( 1 + floor((Limit - 1000) / 300), 10 )` ab Einheitenlimit 1000.

### Aussenposten unterscheidet LOUD selbst

| Markertyp | Template | Inhalt |
|---|---|---|
| `Large Expansion Area` | `Loud_Expansion_Standard` | volle Basis, EngineerCount 2/3/4/9 |
| `Expansion Area` | `Loud_Expansion_Small` / `_Tiny` | je eine Fabrik, EngineerCount 1/2/2/2 |
| `Defensive Point` | `Loud_DP_Standard` / `_Small` | nur Verteidigung und Extraktoren, Tech1 = 0 |

### Weitere Fundorte

| Was | wo |
|---|---|
| No-Rush-Radius der Karte | `ScenarioInfo.norushradius` in `<karte>_scenario.lua` - **optional**, nicht jede Karte hat es |
| No-Rush-Dauer | `ScenarioInfo.Options.NoRushOption`, Zeichenkette in Minuten |
| Speicherplaetze am Extraktor | `MassAdjacency` in `Loud_MAIN_base_templates.lua` Z. 2739: `{-2,0}, {2,0}, {0,-2}, {0,2}` |
| Blueprint je Fraktion | `BuildingTemplates[FactionIndex]` in `lua\buildingTemplates.lua` - **nie feste IDs eintragen** |
| Spielzeit in Sekunden | `aiBrain.CycleTime` |

### `BuildStructures` ist systematisch benannt

```
T1EnergyProduction / T2EnergyProduction / T3EnergyProduction
T1Resource / T2Resource
T1HydroCarbon
T1LandFactory / T1AirFactory
T2MassCreation / T3MassCreation
```

**Damit lassen sich Regeln ueber Gebaeudetypen formulieren statt ueber Buildernamen.**
Grundlage fuer die regelbasierte KI.

---

## 8. Wirtschaftsschwellen sind die haeufigste unsichtbare Bremse

LOUDs Bauer tragen durchweg Energieschwellen, die auf eine KI mit breiter
Kraftwerksbasis zugeschnitten sind. Eine KI, die in der Eroeffnung bewusst wenig Strom
baut, laeuft regelmaessig dagegen:

| Bauer | Bedingung | Folge |
|---|---|---|
| `Assist Mass` | `GreaterThanEconStorageCurrent { 150, 2500 }` | keine Unterstuetzung beim T1->T2-Aufstieg |
| `Mass Storage 600` | `GreaterThanEconEnergyStorageCurrent { 2500 }` | Speicher kommen viel zu spaet |
| `Quantum Gate` | `GreaterThanEnergyIncome { 12600 }` | Tor setzt faktisch T3-Kraftwerke voraus |

**2500 gelagerte Energie ist der wiederkehrende Wert.** Bei jedem Bauer, der nicht
anlaeuft, zuerst die `BuilderConditions` auf Energieschwellen pruefen.

Weitere Reichweitenfallen:

| Bauer | Wert | Folge |
|---|---|---|
| `Assist Mass` | `BuildingGreaterAtLocationAtRange { ..., 120 }` und `Assist.AssistRange = 120` | unterstuetzt nur im Umkreis 120 um den Basispunkt |
| `Mass Extractor T1 - 250` | `MaxChoices` **nicht gesetzt** | LOUDs Vorgabe ist nicht 1, der Techniker nimmt nicht den naechsten Punkt |

---

## 9. Cheat-Modus

Bei Personality `loud` und CheatValue 1.3 (`aiutilities.lua`):

| Buff | Wirkung |
|---|---|
| `CheatIncome` | Masse- und Energieproduktion x1.3 - fuer den ACU **zweimal** |
| `CheatBuildRate` | Baurate x1.3 |
| `CheatALL` | MaxHealth, Regeneration, Schildstaerke und -regeneration |
| `CheatIntel` | nur bei `loud` |

Abgeleitet: `VeterancyMult 1.3`, `MinorCheatModifier 1.102`, `MajorCheatModifier 1.195`.

**Eigene absolute Grenzen sind davon unberuehrt** - LOUDs Deckel skalieren mit
`CheatValue^2`, unsere nicht. Solange unsere strenger sind, binden sie.

---

## 10. Methodische Lehren

Jede davon steht fuer mindestens einen Fehlversuch in dieser Entwicklung.

**Den Codepfad bis zur Verwendung verfolgen**, nicht nur die Datenstruktur finden, in
der ein Feld steht. `MaxRange` und `MaxChoices` waren dreimal korrekt gesetzt und
wurden nie gelesen.

**Den vollstaendigen Verlauf lesen**, nicht die auffaellige Zeile deuten.
`calls for transport` sah nach Blockade aus - drei Zeilen weiter stand `orders build`.

**Erst pruefen, ob LOUD den Fall schon behandelt.** Zweimal war ein geplanter
Mechanismus schon vorhanden: die Vorabpruefung der Bauplaetze und die Unterscheidung der
Aussenposten nach Markertyp.

**Spielregel oder Bauregel?** Blueprint-Felder wie `UpgradesTo` sind nicht verhandelbar.
Alles in `BuilderConditions` ist LOUDs Meinung und darf geaendert werden. Beides wurde
je einmal verwechselt.

**Bei jedem Feld: was gilt, wenn es fehlt - und ist das brauchbar?** Ein fehlendes
`norushradius` liess `MaxRange` auf 250 stehen; ein fehlendes `MaxChoices` bedeutet
nicht 1.

**Bei jeder uebernommenen Sortierung: sortiert nach was?** LOUDs Massepunkte sind nach
der Startposition der Armee sortiert, nicht nach der Fabrik.

**Wechselseitige Kopplung ist ein Stillstand.** \"Ein Kraftwerk je zwei Techniker\" und
\"zwei Techniker je Kraftwerk\" halten sich gegenseitig fest. Mindestens eine Groesse
muss von aussen wachsen.

**Eine Notloesung faellt, sobald die Ursache behoben ist.** Sonst verdeckt sie, ob die
Behebung wirkt.

**Ein beobachtetes Muster ersetzt keine Absicht.** Das Referenzlog zeigt, *was* der
Spieler tut - nicht, ab wann er es fuer richtig haelt.

**Eine Prioritaet gegen ALLE Nachbarn pruefen**, nicht gegen einen. Das Quantentor stand
auf 855 - ueber den Extraktoren, aber unter den Kraftwerken.

**Eine auffaellige Zahlenreihe ist nicht automatisch ein Fehler.** Die gestaffelten
Aufstiege waren gewollt: ein Aufstieg finanziert den naechsten.

**Bei \"das geht nicht\" in den Code sehen.** Zweimal war die Annahme falsch - Speicher
haben einen Aufstieg, und der ACU fordert Unterstuetzung aktiv an.

---

## 11. Werkzeuge

| Schalter | zeigt | wo gesetzt |
|---|---|---|
| `EngineerDialog` | welcher Techniker welche Aufgabe bekommt - und wann keine | `DebugSchalter` in `AIDefinitions.lua` |
| `PriorityDialog` | jede Prioritaetsaenderung mit altem und neuem Wert | dito |
| `StructureUpgradeDialog` | jeder Aufstieg mit Ausloeser | dito |
| `NameEngineers` | benennt Techniker im Spiel | dito |
| `ReferenzLog` | **eigener Schalter**: was ein menschlicher Spieler wann baut | dito |

Das Referenzprotokoll (`hook\lua\defaultunits.lua`) erfasst nur **Strukturen** - mobile
Einheiten sind wegen der Ableitungsfalle nicht erreichbar.

**Die Debug-Schalter frueher einschalten.** Vier Ursachen wurden aus dem Quelltext
erraten, bevor ein einziger Lauf mit `EngineerDialog` die fuenfte in Minuten zeigte.
