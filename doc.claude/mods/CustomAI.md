# Mod: Custom AI

| | |
|---|---|
| **Ordner** | `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\` |
| **VFS-Pfad** | `/mods/customai/` |
| **uid** | `72568B0A-993B-49D4-B2AB-55E68B5C3BE5` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Status** | **Grundgeruest steht und ist im Spiel bestaetigt** |
| **Angelegt** | 2026-08-06 |

---

## 0. Einstieg fuer eine neue Sitzung

**Diese drei Dateien reichen, um sofort an einer neuen KI zu arbeiten:**

| Reihenfolge | Datei | Wofuer |
|---|---|---|
| 1 | `..\CLAUDE.md` | Arbeitsregeln, Schreibzone, Pfadkonventionen |
| 2 | diese Datei | Aufbau des Mods, Abschnitte 3, 4 und 4b |
| 3 | `CustomAI_Stellschrauben.md` | was sich aendern laesst und wo es steht |

Dazu bei Bedarf `..\04_LUA_SIM.md` Abschnitt 2 (strikte Globals - haeufigste
Absturzursache) und `..\15_LOG.md` (Logauswertung).

### Der Stand in einem Absatz

Der Mod registriert KIs ueber `lua\AI\CustomAIs_v2\CustomAI.lua` in der Lobby und erzeugt
fuer jede einen eigenen Basisplan, der von einem LOUD-Template erbt. Zwei Hooks bringen
das in den Sim: `simInit.lua` laedt die Definitionen, `aibrain.lua` schreibt zusaetzlich
`Personality` auf `'loud'`, damit das Cheat-System vollstaendig greift. Alles davon ist
im Spiel bestaetigt (Testlauf 4, siehe Abschnitt 7).

### Was eine neue KI kostet

Ein Eintrag in `lua\AI\AIDefinitions.lua`, optional eine Datei nach dem Muster von
`lua\AI\AIs\_VORLAGE.lua`. **Die Mechanik ist erledigt** - ab hier ist es Inhaltsarbeit.

### Die vier Regeln, an denen es scheitert

1. `Name` muss `AI: LOUD` enthalten, sonst tritt LOUD zurueck und die KI bleibt untaetig
2. `Key` muss eindeutig sein - die Duplikatspruefung der Engine greift nicht
3. In `CustomAIs_v2\` darf nur liegen, was eine globale `AI`-Tabelle definiert
4. In `Apply()` niemals `BaseTemplateName` oder `FirstBaseFunction` anfassen

---

## 1. Zweck

Zusaetzliche KI-Gegner, die in der Lobby zur Auswahl stehen - **mehrere, nicht eine**.

Der Mod ist als **Fabrik** gebaut: eine zentrale Liste, aus der sowohl die
Lobby-Eintraege als auch die Basistemplates entstehen. Eine neue KI kostet einen Eintrag
plus optional eine Datei mit den Verhaltensaenderungen.

**Grundverhalten ist identisch mit LOUD.** Die erste KI (`customai_standard`) ist eine
unveraenderte Kopie von `Loud_Main_Standard` - das Referenzverhalten, gegen das alle
spaeteren Aenderungen gemessen werden. Aufbau in Abschnitt 4, Anleitung in Abschnitt 4b.

## 2. Wie die Lobby-Registrierung funktioniert

**Geprueft am 2026-08-06** in
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\enhancedlobby.lua
```
Funktion `GetAIList()`, Zeile 172. Aufgerufen ueber `lua\ui\lobby\aitypes.lua`.

Die Funktion liest aus zwei Quellen:

```lua
DiskFindFiles('/lua/AI/CustomAIs_v2', '*.lua')                    -- global, Zeile 176
DiskFindFiles(mod.location..'/lua/AI/CustomAIs_v2', '*.lua')      -- je aktivem Mod, Zeile 248
```

**Der zweite Zweig ist fuer Mods gedacht** - er sucht relativ zum echten Modordner. Es
genuegt also:

```
usermods\CustomAI\lua\AI\CustomAIs_v2\<name>.lua
```

Kein `shadow`, keine eigenen Mounts noetig.

### Aufbau der Registrierungsdatei

Muster von LOUD selbst
(`gamedata.entpackt\lua\lua\AI\CustomAIs_v2\ExtrasAI.lua`):

```lua
AI = {
    Name = "AI Patch LOUD",
    Version = "8.15",
    AIList = {
        { key = 'loud', name = "AI: LOUD" },
    },
}
```

| Tabelle | Bedeutung |
|---|---|
| `AIList` | normale KIs |
| `CheatAIList` | schummelnde KIs - wird ebenso gelesen |

Erklaertexte fuer die Lobby kommen aus einem Zwilling:
`<mod>\lua\AI\CustomAITooltips\*.lua` mit einer `Tooltips`-Tabelle
(`enhancedlobby.lua` Zeile 289).

### Drei Fallstricke im Code

1. **Die Duplikatspruefung greift nicht.** `if not aitypes[tAIData.key]` - `aitypes`
   wird mit `table.insert` gefuellt, hat also numerische Indizes; die Abfrage mit einem
   String-Key trifft nie. **Zwei Mods mit demselben `key` erzeugen zwei Eintraege.**
   Eindeutige Keys sind Pflicht.
2. **Jede Datei im Ordner muss eine globale `AI`-Tabelle definieren.** Der Code greift
   direkt auf `import(v).AI.AIList` zu - eine Hilfsdatei ohne `AI` laesst das Laden mit
   einem Fehler abbrechen. In diesen Ordner gehoeren nur Registrierungsdateien.
3. **`AIFilesold` ist toter Code** - immer leer, die beiden "old style"-Schleifen laufen
   ins Leere.

## 3. GEKLAERT: so uebergibt LOUD an eine eigene KI

**Testlauf 2026-08-06.** Der Mechanismus ist ein anderer als vermutet - und er ist
ausdruecklich vorgesehen.

### Der Schaltpunkt steht in `aibrain.lua`, nicht im Basistemplate

`gamedata.entpackt\lua\lua\aibrain.lua`, `OnCreateAI`, rund um Zeile 950:

```lua
local bCheckForLoud = false
local tsLOUDNicknames = {[1] = 'AI: LOUD'}
local tExtrasAI = import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.AIList

if tExtrasAI then
    for iEntry, tAIInfo in tExtrasAI do
        if tAIInfo.name and not(tsLOUDNicknames[1] == tAIInfo.name) then
            table.insert(tsLOUDNicknames, tAIInfo.name)
        end
    end
end

-- hat IRGENDEIN aktiver Mod einen Ordner lua/AI/CustomAIs_v2 ?
if activeMods then
    for k, mod in activeMods do
        local AIFiles = DiskFindFiles(mod.location..'/lua/AI/CustomAIs_v2', '*.lua')
        if AIFiles then
            bCheckForLoud = true
            break
        end
    end
end

if not(bCheckForLoud) or not(self.Nickname) or IsNicknameALoudNickname(self.Nickname) then
    ForkThread( import('/lua/ai/aiarchetype-managerloader.lua').ExecutePlan, self )
end
```

### Was das bedeutet

1. **Sobald ein aktiver Mod einen `CustomAIs_v2`-Ordner hat**, schaltet LOUD in den
   Pruefmodus (`bCheckForLoud = true`).
2. Dann startet LOUD seinen eigenen Plan **nur noch**, wenn der **Nickname** der KI einen
   der bekannten LOUD-Namen enthaelt. Die Liste stammt ausschliesslich aus der globalen
   `ExtrasAI.lua` - also praktisch nur `AI: LOUD`.
3. Heisst eine KI anders, **tritt LOUD zurueck und startet gar nichts.**

**Nicht der Key entscheidet, sondern der Name.** `AIPersonality` spielt fuer die
Uebergabe keine Rolle - die frueher vermutete Auswertung im Basistemplate ist der falsche
Ansatzpunkt.

### Beleg aus dem Testlauf

Die Sonde hiess `AI: Sonde (Test)`, enthaelt also nicht `AI: LOUD`:

| Logzeile | Bedeutung |
|---|---|
| `*AI DEBUG Processing AI Mod "/mods/customai"` | Mod-Zweig hat den Mod gefunden |
| `No tooltip in table for key: aitype_customai_probe` | **der Key wurde in der Lobby ausgewaehlt** |
| `CUSTOMAI: ProbeBaseTemplate.lua wird geladen` | eigenes Basistemplate registriert |
| *(keine)* `*AI DEBUG ... Selected ...` | **`ExecutePlan` lief nie** |
| *(keine)* `CUSTOMAI: FirstBaseFunction ...` | folgerichtig - `GetBestBasePlan` wurde nie aufgerufen |

Die KI stand im Spiel und tat **nichts**. Genau das ist das erwartete Verhalten, wenn
LOUD zurueckgetreten ist und kein eigener Plan uebernimmt.

### GEKLAERT: der Lobby-Key kommt in `FirstBaseFunction` an

**Testlauf 3, 2026-08-07.** Sonde umbenannt in `AI: LOUD Sonde (Test)`, damit LOUDs
Namenspruefung greift. Ergebnis:

```
CUSTOMAI: FirstBaseFunction fuer Sletir (AI: LOUD Sonde (Test))
  - ArmySetup.AIPersonality = customai_probe
  - aiBrain.Personality     = customai_probe
*AI DEBUG Sletir (AI: LOUD Sonde (Test)) Selected "Loud_Main_Standard"
```

**Beide Felder tragen den Lobby-Key.** Die aus der Aufrufreihenfolge abgeleitete
Vermutung ist damit belegt:

1. `aibrain.lua` Z. 893 schreibt den Lobby-Key nach `self.Personality`
2. `GetBestBasePlan` ruft jede `FirstBaseFunction` - **der Key steht noch**
3. erst danach ueberschreibt `SetupMainBase` Z. 47 `AIPersonality` mit dem `baseType`

**Damit traegt der Ansatz.** Ein eigenes `BaseBuilderTemplate` kann anhand des Keys
entscheiden, ob es gewinnen will. Die Sonde gab wie vorgesehen 0 zurueck, deshalb hat
LOUDs `Loud_Main_Standard` gewonnen - genau das erwartete Verhalten.

### Zwei Wege stehen damit offen

| Weg | Name der KI | LOUDs Plan | eigener Einstiegspunkt noetig |
|---|---|---|---|
| **A - aufsetzen** | enthaelt `AI: LOUD` | laeuft | nein |
| **B - uebernehmen** | beliebig | tritt zurueck | ja, Hook auf `OnCreateAI` |

**Weg A** ist der billige: LOUDs komplette KI bleibt aktiv, das eigene Basistemplate
konkurriert ueber `FirstBaseFunction` um die Basiswahl. Damit lassen sich Bauprogramm
und Basisaufbau aendern, ohne die gesamte KI nachzubauen.

**Weg B** ist der grosse: LOUD startet gar nichts, der Mod muss den vollstaendigen Plan
selbst forken und alle Strukturen anlegen, die LOUDs Threads erwarten.

### Folgefehler - Ursache offen

```
warning: loudutilities.lua(5291): attempt to loop over field `HiPri' (a nil value)
```

`ParseIntelThread` (beginnt Zeile 4578) greift in Zeile 5291 auf `aiBrain.IL.HiPri` zu.
Angelegt wird die Struktur erst spaeter, in einer anderen Funktion derselben Datei:

```lua
-- loudutilities.lua Zeile 5987-5989
if not self.IL then
    self.IL = { ['HiPri'] = {}, ['LowPri'] = {}, ... }
```

Es sieht nach einem **Wettlauf beim Start** aus: der Intel-Thread laeuft an, bevor die
Struktur existiert.

**Zunaechst hatte ich vermutet, das liege daran, dass LOUD zurueckgetreten ist.**
Das ist widerlegt - der Fehler erscheint in Testlauf 2 (LOUD zurueckgetreten) **und** in
Testlauf 3 (LOUDs Plan lief normal, `Selected "Loud_Main_Standard"`). Er tritt in beiden
Faellen unmittelbar nach der Basiswahl auf.

**Ob der Fehler ueberhaupt mit diesem Mod zu tun hat, ist ungeprueft.** Kontrolllauf
noetig: dieselbe Karte ohne `CustomAI`. Steht in `..\TODO.md`.

### Konsequenz fuer diesen Mod

Eine eigene KI besteht aus **zwei** Teilen:

1. **Registrierung** in `lua\AI\CustomAIs_v2\` - erledigt und bestaetigt.
2. **Eigener Einstiegspunkt**, der den Plan startet. LOUD tut es nicht mehr, sobald der
   Name abweicht.

Fuer Teil 2 ist ein Hook auf `aibrain.lua` noetig, der `OnCreateAI` erweitert und fuer
den eigenen Nickname einen eigenen `ExecutePlan` forkt.

**Der einfachste erste Schritt** ist aber ein anderer: die eigene KI so benennen, dass
`string.find(self.Nickname, 'AI: LOUD')` greift - etwa `AI: LOUD Sonde`. Dann laeuft
LOUDs Plan weiter, das eigene Basistemplate wird trotzdem geprueft, und
`FirstBaseFunction` meldet sich. Damit laesst sich klaeren, ob der Weg ueber eigene
Basistemplates ueberhaupt traegt - ohne gleich einen kompletten KI-Einstiegspunkt bauen
zu muessen.

### Zwei Auffaelligkeiten im Code

1. **`IsNicknameALoudNickname(sNickname)` ignoriert seinen Parameter** und prueft
   stattdessen `self.Nickname`. Funktioniert hier, weil beide gleich sind.
2. **Die Funktion wird global definiert** (kein `local`) - sie landet also im globalen
   Namensraum der Sim.

---

## 3b. Wo das Verhalten definiert ist

Die Registrierung ist ein Dutzend Zeilen. Das Verhalten steckt woanders - und dort wird
es unbequem.

### Geklaert: der Lobby-Key wird nicht ausgewertet

**Geprueft am 2026-08-06** in
`gamedata.entpackt\lua\lua\AI\AIBaseTemplates\Loud_Main_Standard.lua`, Zeilen 159-220.

`FirstBaseFunction(aiBrain)` entscheidet **allein nach Kartendaten**:

| Kriterium | Quelle |
|---|---|
| Startposition am Kartenrand | `aiBrain:GetArmyStartPos()`, `GetMapSize()` |
| Kartengroesse | `mapSizeX`, `mapSizeZ` |
| Wasseranteil | `aiBrain:GetMapWaterRatio()` |
| Einheitenlimit | `GetArmyUnitCap(aiBrain.ArmyIndex)` |

Alle acht Rueckgabepfade liefern denselben festverdrahteten `baseType`:

```lua
return 10, 'loud'
return Random(50,100), 'loud'
return 100, 'loud'
```

**Der in der Lobby gewaehlte Key wird nirgends gelesen.** `SetupMainBase()` schreibt
anschliessend `'loud'` in `AIPersonality` - unabhaengig davon, was der Spieler ausgewaehlt
hat. Solange nur LOUDs Basisplaene registriert sind, spielt **jede** KI als `loud`.

**Ein Mod, der nur einen Key registriert, aendert also gar nichts.** Er taucht in der
Liste auf und verhaelt sich wie LOUD.

### Der Ansatzpunkt: die Reihenfolge in `SetupMainBase()`

```lua
-- aiarchetype-managerloader.lua, Zeile 43-47
local base, returnVal, baseType = GetBestBasePlan(aiBrain)   -- ruft FirstBaseFunction
if base then
    ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality = baseType   -- ueberschreibt DANACH
```

**`GetBestBasePlan` laeuft vor dem Ueberschreiben.** Innerhalb einer eigenen
`FirstBaseFunction` steht der Lobby-Key also noch zur Verfuegung - in
`ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality` und in `aiBrain.Personality`
(gesetzt in `aibrain.lua` Zeile 893, vor `ExecutePlan`).

Das ist der Hebel: Ein eigenes `BaseBuilderTemplate` liest dort den Key und gibt einen
hohen Wert zurueck, wenn er zum eigenen Mod passt - sonst 0. Damit gewinnt der eigene
Basisplan genau dann, wenn der Spieler die eigene KI gewaehlt hat.

**Ungeprueft:** ob der Key zu diesem Zeitpunkt tatsaechlich noch den Lobby-Wert enthaelt.
Aus der Aufrufreihenfolge abgeleitet, nicht im Spiel getestet.

### Wo das Verhalten definiert ist

```
gamedata.entpackt\lua\lua\AI\AIBaseTemplates\    14 Basisplaene (Loud_Main_*, Loud_Naval_*, ...)
gamedata.entpackt\lua\lua\AI\AIBuilders\         Bauauftraege
gamedata.entpackt\lua\lua\AI\PlatoonTemplates\   Verbandszusammenstellungen
```

Ein Basistemplate ist eine Liste von BuilderGroups:

```lua
BaseBuilderTemplate {
    BaseTemplateName = 'Loud_Main_Standard',
    Builders = {
        'ACU Tasks - Start Game',
        'Engineer Factory Construction',
        'Factory Production Land',
        ...
    },
    ExpansionFunction = function(aiBrain, location, markerType) ... end,
    FirstBaseFunction = function(aiBrain) ... end,
    BaseSettings = { ... },
}
```

`GlobalBaseTemplate.lua` verlangt `BaseTemplateName`, `Builders`, `ExpansionFunction`
und `BaseSettings` - fehlt eines, wird das Template mit einer Warnung verworfen.

### Das Problem: kein Mod-Zweig beim Laden

`lua\simInit.lua`, Zeilen 353-363:

```lua
for k,file in DiskFindFiles('/lua/ai/platoontemplates', '*.lua') do import(file) end
for k,file in DiskFindFiles('/lua/ai/aibuilders',      '*.lua') do import(file) end
for k,file in DiskFindFiles('/lua/ai/aibasetemplates', '*.lua') do import(file) end
```

**Anders als `GetAIList()` gibt es hier keine Schleife ueber aktive Mods.** Ein Mod kann
seine Basistemplates und Builder nicht einfach in seinen eigenen Ordner legen.

### Geklaert: wie Nomads es loest

Die Vermutung, `shadow\` mache neue Dateien fuer `DiskFindFiles` auffindbar, **hat sich
nicht bestaetigt.** Nomads geht einen anderen Weg. Seine geshadowte `factions.lua`
(`usermods\nomads-4-loud\shadow\lua\factions.lua`, 26 Zeilen) enthaelt:

```lua
local OriginalFactions = import('/loud/lua/factions.lua').Factions
local CustomFactions   = import('/mods/nomads-4-loud/shadow/lua/CustomFactions/Nomads.lua').FactionList
```

Zwei Dinge daran:

1. **Das Original wird ueber `/loud/...` geholt** - den Ersatzpfad, den
   `mount_nomads.lua` anlegt (`..\11_DATAPATH.md` Abschnitt 4). Ohne den waere es
   unerreichbar, weil `shadow` es verdeckt.
2. **Die eigene Datei wird ueber den vollen `/mods/...`-Pfad importiert**, nicht ueber
   einen Wurzelpfad. Nomads verlaesst sich also **nicht** darauf, dass Shadow-Dateien
   per `DiskFindFiles` auffindbar werden.

Damit gibt es in dieser Installation **kein Beispiel** fuer Weg A - und ein Gegenbeispiel.

### Wichtig: es gibt kein Vorbild in dieser Installation

**Kein einziger Mod hier fuegt eine zusaetzliche waehlbare KI hinzu.** Der Mod-Zweig in
`GetAIList()` (Kommentar im Code: `--Support for custom AIs via mods`) ist ausdruecklich
dafuer gedacht, wird aber von nichts genutzt.

Die einzige Registrierungsdatei im ganzen Bestand ist
`gamedata.entpackt\lua\lua\AI\CustomAIs_v2\ExtrasAI.lua` mit dem einen Key `loud`.
**LOUD hat genau eine KI.**

Auch `nomads-4-loud` ist **kein** Vorbild. Der Mod bringt eine Fraktion mit und passt die
KI daran an - er fuegt aber keine waehlbare KI hinzu:

| Datei im Mod | Was sie tut |
|---|---|
| `shadow\lua\ui\lobby\aiNames.lua` | Namensliste fuer KI-Spieler, ergaenzt um Nomads-Namen |
| `shadow\lua\CustomFactions\NomadsAIFiles\BaseTemplates.lua` | Gebaeude-Platzierungsvorlage, **kein** `BaseBuilderTemplate` |
| `shadow\lua\factions.lua` | Fraktionsliste, ergaenzt um Nomads |

Ein Ordner `lua\AI\CustomAIs_v2` existiert in `nomads-4-loud` nicht.

**Konsequenz:** Der gesamte Weg unten ist aus dem Code gelesen, nicht an einem
funktionierenden Beispiel abgeschaut. Der erste Testlauf muss klaeren, ob die Kette
ueberhaupt haelt.

### Uebertragbar ist nur das Lademuster

Was Nomads zeigt, ist **wie ein Mod eigene Lua-Dateien in den Sim bekommt**, wenn der
automatische Ladeweg fehlt - naemlich durch expliziten Import mit vollem Pfad. Das laesst
sich uebernehmen. Es beweist aber **nicht**, dass eine zusaetzliche KI funktioniert -
nur, dass eigene Dateien ladbar sind.

### Der vermutete Weg

**Vollstaendig ungeprueft.** Aus dem Code abgeleitet:

1. **Key registrieren** in `usermods\CustomAI\lua\AI\CustomAIs_v2\<name>.lua` -
   dafuer gibt es den Mod-Zweig in `GetAIList()`.
2. **Eigenes `BaseBuilderTemplate`** anlegen, dessen `FirstBaseFunction` den Lobby-Key
   aus `ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality` liest und nur dann einen
   hohen Wert zurueckgibt, wenn er passt - sonst 0.
3. **Per Hook importieren**, mit vollem Pfad:
   ```lua
   -- usermods\CustomAI\hook\lua\simInit.lua
   import('/mods/customai/lua/AI/MeineBasis.lua')
   ```
   Die Registrierung geschieht beim Import ueber den globalen Konstruktor
   `BaseBuilderTemplate{...}`, der zu diesem Zeitpunkt bereits existiert
   (`simInit.lua` Zeile 54 laedt `GlobalBaseTemplate.lua`).

**Jeder der drei Schritte kann scheitern.** Testreihenfolge in Abschnitt 7.

### Registrierung ist ueberschreibbar

`lua\system\GlobalBaseTemplate.lua`: bei gleichem `BaseTemplateName` wird der alte
Eintrag **feldweise ergaenzt oder ueberschrieben**, mit einer Warnung im Log
(`Duplicate BaseBuilderTemplate detected`). Ein Mod kann also einen LOUD-Basisplan
gezielt erweitern, statt einen eigenen danebenzustellen.

Die Datei prueft ausserdem beim Registrieren, ob jede genannte BuilderGroup existiert,
und warnt sonst: `Invalid BuilderGroup named - <name>`. Diese Warnung im `LOUD.log` ist
beim Entwickeln das erste Kontrollsignal.

## 4. Aufbau des Mods

**Entwurfsentscheidung 2026-08-07: Weg A.** LOUDs KI laeuft vollstaendig weiter, wir
stellen nur ein eigenes Basistemplate daneben. Grundverhalten ist deshalb **identisch mit
LOUD** - Aenderungen kommen schrittweise dazu.

**Zweite Entscheidung: mehrere KIs, nicht eine.** Der Mod ist als Fabrik gebaut. Eine
neue KI kostet einen Eintrag in einer Liste plus optional eine Datei.

### Dateien

```
usermods\CustomAI\
+-- mod_info.lua
+-- lua\AI\
|   +-- AIDefinitions.lua              DIE LISTE - hier wird eingetragen
|   +-- AIFactory.lua                  erzeugt Templates, erbt von LOUD
|   +-- LoadAIs.lua                    Einstiegspunkt, laeuft die Liste durch
|   +-- CustomAIs_v2\CustomAI.lua      Lobby-Registrierung, liest die Liste
|   +-- AIs\_VORLAGE.lua               Kopiervorlage fuer Verhaltensaenderungen
|   +-- _archiv\ProbeBaseTemplate.lua  Messsonde der Sondierung, ausser Betrieb
+-- hook\lua\
    +-- simInit.lua                    regulaerer Einstieg in den Sim
    +-- aibrain.lua                    Rueckfallebene
```

### Wie es zusammenspielt

```
AIDefinitions.lua  (eine Liste, zwei Leser)
        |
        +--> CustomAIs_v2\CustomAI.lua  --> Lobby-Auswahlliste        [UI]
        |
        +--> LoadAIs.lua --> AIFactory.lua --> BaseBuilderTemplate{}  [Sim]
                                    |
                                    +--> AIs\<Name>.lua  Apply()
```

**Eine Quelle fuer beide Seiten.** Key und Name koennen nicht auseinanderlaufen, weil
Lobby und Sim dieselbe Datei lesen.

### Warum geerbt und nicht kopiert wird

`AIFactory.lua` holt das LOUD-Template zur Laufzeit aus der globalen Tabelle
`BaseBuilderTemplates` und legt eine **tiefe Kopie** an:

```lua
local source   = BaseBuilderTemplates[def.Source]   -- z. B. 'Loud_Main_Standard'
local template = DeepCopy(source)
template.BaseTemplateName = 'CustomAI_'..def.Key
```

Drei Gruende:

1. **Ueberlebt LOUD-Updates.** Ein von Hand nachgebautes Template waere nach dem
   naechsten Update veraltet; die Kopie zieht automatisch nach.
2. **Kein Ueberschreiben.** Der eigene `BaseTemplateName` sorgt dafuer, dass das
   Template **neben** LOUDs steht. Bei gleichem Namen wuerde `GlobalBaseTemplate.lua`
   feldweise ergaenzen und eine Warnung schreiben.
3. **Tiefe Kopie ist Pflicht.** Bei einer flachen wuerde eine Aenderung an
   `template.Builders` LOUDs Original mitveraendern - und damit auch die LOUD-KI.

Der Zeitpunkt passt: `simInit.lua` laedt die LOUD-Templates in Zeile 363, unser Hook
laeuft danach.

### Wie die Basiswahl gesteuert wird

Die Fabrik ersetzt die geerbte `FirstBaseFunction`:

```lua
if personality == key then
    return value, 'loud'   -- value = 200, gewinnt sicher
end
return 0                   -- fremde KI: nicht bewerben
```

`Loud_Main_Standard` gibt hoechstens 100 zurueck, `GetBestBasePlan` nimmt den hoechsten
Wert - **200 gewinnt zuverlaessig**, aber nur fuer den Spieler, der diese KI ausgewaehlt
hat. Alle anderen KIs im Spiel bekommen 0 und behalten LOUDs Auswahl.

Der zweite Rueckgabewert ist `'loud'`, nicht der eigene Key. Alle LOUD-Templates geben
`'loud'` zurueck, und der Wert landet anschliessend in `AIPersonality`. Ob nachgelagerte
LOUD-Logik darauf prueft, ist **ungeprueft** - `'loud'` ist die sichere Wahl.

---

## 4b. Eine neue KI anlegen

**Welche Stellschrauben es gibt, steht in
[CustomAI_Stellschrauben.md](CustomAI_Stellschrauben.md)** - Basisplaene, `BaseSettings`,
alle 64 BuilderGroups, Bedingungsbibliotheken und die Laufzeitwerte der KI.

### Fall 1: Verhalten wie LOUD, nur eigener Eintrag

Ein Eintrag in `lua\AI\AIDefinitions.lua` genuegt:

```lua
{
    Key    = 'customai_beispiel',
    Name   = 'AI: LOUD Beispiel (Custom)',
    Source = 'Loud_Main_Standard',
},
```

### Fall 2: mit eigenem Verhalten

1. `lua\AI\AIs\_VORLAGE.lua` kopieren, z. B. nach `AIs\Turtle.lua`
2. `Apply(template, definition)` fuellen
3. In `AIDefinitions.lua` eintragen, mit `Customize`:

```lua
{
    Key       = 'customai_turtle',
    Name      = 'AI: LOUD Turtle (Custom)',
    Source    = 'Loud_Main_Standard',
    Customize = '/mods/customai/lua/AI/AIs/Turtle.lua',
},
```

### Die vier Regeln

| Regel | Grund |
|---|---|
| **`Name` muss `AI: LOUD` enthalten** | sonst tritt LOUD zurueck und die KI bleibt untaetig (Abschnitt 3) |
| **`Key` muss eindeutig sein** | die Duplikatspruefung der Engine greift nicht |
| **Nichts ausser `AI`-Tabellen in `CustomAIs_v2\`** | der Lesecode greift ungeprueft auf `import(v).AI.AIList` zu |
| **`BaseTemplateName` und `FirstBaseFunction` in `Apply()` nicht anfassen** | beide steuert die Fabrik |

Die erste Regel prueft `AIFactory.lua` und warnt im Log - sie ist der haeufigste Fehler.

### Was `Apply()` veraendern kann

| Feld | Inhalt | Gueltige Werte |
|---|---|---|
| `template.Builders` | Liste von BuilderGroup-Namen | `gamedata.entpackt\lua\lua\AI\AIBuilders\` |
| `template.BaseSettings` | Einstellungen, u. a. `RallyPointRadius` | siehe Quelldatei |
| `template.ExpansionFunction` | Bewertung fuer Aussenposten | |

Tippfehler in `Builders` meldet die Engine beim Registrieren:
`Invalid BuilderGroup named - <name>`.

---

## 4bb. Registrierte KIs (Stand 2026-08-08)

| Key | Lobbyname | Source | Customize |
|---|---|---|---|
| `customai_aeon_air` | `AI: LOUD Aeon Airforce` | `Loud_Main_Standard` | `AIs\NoRush.lua` |

**Stand 2026-08-08: nur noch eine KI.** Die drei Testeintraege `customai_standard`,
`customai_small` und `customai_smaller` sind entfallen - sie hatten ihren Zweck erfuellt
(Beleg, dass `Source` umschaltbar ist und mehrere KIs gleichzeitig laufen, Testlauf 5).

Der Phasenplan, der Kraftwerksplan, die Builder-Kopien und die SCU-Ausrichtung bleiben
als **Grundlage** fuer alle weiteren KIs erhalten - `Phasenplan()` ist eine Funktion in
`AIDefinitions.lua` und kann von jeder weiteren Definition aufgerufen werden.

### Die NoRush-Grundlage

**Eine KI fuer alle vier Lobbyeinstellungen.**
Vier Phasen, gesteuert ueber Zeitsperren auf einzelnen Buildern - **nicht** ueber
`template.Builders`. Wie das funktioniert, steht in
`CustomAI_Stellschrauben.md` Ebene 5.

| Phase | ab | Inhalt |
|---|---|---|
| 1 | 0 % | Wirtschaft: Extraktoren, Kraftwerke, Ingenieure, Techaufstieg. **Nur die eine Startfabrik des ACU.** |
| 2 | 35 % | stationaere Flugabwehr (alle `* AA *`-Builder) |
| 3 | 55 % | minimale Bodenabwehr **und erst ab hier neue Fabriken** |
| 4 | 75 % | mobile Truppen, **Aufklaerung**, Artillerie, Nukes, Optik, Experimentaleinheiten, T3/T4-PD |

Prozent der **No-Rush-Dauer aus der Lobby**, nicht feste Sekunden:

| `NoRushOption` | Phase 2 | Phase 3 | Phase 4 |
|---|---|---|---|
| `Off` | - | - | - (keine Sperre, spielt wie LOUD) |
| `5` | 1:45 | 2:45 | 3:45 |
| `10` | 3:30 | 5:30 | 7:30 |
| `20` | 7:00 | 11:00 | 15:00 |

### Fabriken: gesperrt bis Phase 3, danach dauerhaft hinter der Wirtschaft

Acht Bauer sind betroffen - vier an `MAIN`, drei an Aussenposten, einer fuer Marine
(`Loud_AI_Engineer_Factory_Builders.lua` ab Z. 106). Sie bekommen nicht nur eine
Zeitsperre, sondern zusaetzlich einen **dauerhaften Prioritaetsdeckel von 745**.

Das wirkt, weil `GetHighestBuilder` nur das **oberste Prioritaetsband** prueft
(`CustomAI_Stellschrauben.md` Ebene 4c). Wer niedriger steht, kommt erst dran, wenn oben
nichts uebrig ist. Die Werte an `MAIN`:

| Prioritaet | Bauer |
|---:|---|
| 900 | T2 Power Template |
| 851 | T3 Power Template |
| 850 | Mass Extractor T1 - 250, Mass Fab T3 |
| 846 / 845 | Mass Extractor T1 - 750 (BuildClose / Loop) |
| 840 | Mass Extractor T2 - 750, T3 Power - Perimeter |
| 800 | Mass Fab T2 |
| 762 | Mass Energy Adjacency |
| 761 | T1 Power Template |
| 760 / 755 | Mass Extractor T1 - 1500 - Loop (+ Extra) |
| 750 | Hydrocarbon, Mass Storage 600 |
| **745** | **Fabriken (unser Deckel)** |
| 740 | Mass Storage 1024 |
| 700 | Energy Storage - HydroCarbon |

Im Original stehen die Fabrikbauer bei **800/801** - also ueber T1-Kraftwerken, ueber den
entfernteren Massextraktoren und ueber Hydrokarbon. Mit 745 rutschen sie unter alles
davon; oberhalb bleiben nur die beiden Speicherbauten.

**Der Deckel wirkt nur nach unten.** Gibt LOUDs Originalfunktion 0 (dauerhaft aus) oder
10 (vorlaeufig aus) zurueck, bleibt das unberuehrt.

#### Was ausgenommen bleibt

| | Grund |
|---|---|
| `ACU Tasks - Start Game` | baut die **erste** Fabrik (`Loud_AI_ACU_Builders.lua` ab Z. 126). Ohne sie keine Ingenieure und kein Techaufstieg. |
| `Quantum Gate` | produziert SCUs, also Ingenieure. Zaehlt hier als Wirtschaft. |
| `Land/Air Factory Rebuild` | siehe Warnung unten - **die Ausnahme ist fragwuerdig** |

#### ⚠️ KORREKTUR 2026-08-08: "Rebuild" heisst nicht "nur ersetzen"

Die urspruengliche Begruendung fuer die Ausnahme lautete: Originalprioritaet 10, sie
ersetzen nur zerstoerte Fabriken, der Deckel greift dort ohnehin nicht. **Das war falsch.**

`Land Factory Rebuild` und `Air Factory Rebuild` haben zwar `Priority = 10`, aber auch
`PriorityFunction = HaveZeroLandFactories` bzw. `HaveZeroAirFactories`
(`Loud_AI_Engineer_Factory_Builders.lua` Z. 54-82):

```lua
local HaveZeroLandFactories = function( self, aiBrain )
    if aiBrain.CycleTime > 60 then
        if LOUDGETN( GetListOfUnits( aiBrain, FACTORY * LAND, false, true )) < 1 then
            return 990, true
        end
    end
    return 10, true
end
```

**Sie sind kein Ersatzbauer, sondern eine Garantie: mindestens je eine Land- und eine
Luftfabrik.** Nach 60 Sekunden feuern sie mit Prioritaet 990 und schlagen damit alles.

#### Folge: die KI hat immer zwei Fabriken, nicht eine

Auf einer Karte ueber 1024 greift `CDR Initial Large Map` (`MapGreaterThan 1024`) und der
ACU baut eine **Luftfabrik**. Danach hat die KI null Landfabriken - und `Land Factory
Rebuild` baut ab Sekunde 60 eine dazu. Auf kleineren Karten umgekehrt.

Beobachtet in Testlauf 6 (Karte 2048): die NoRush-KI baute trotz aller Sperren eine
zweite Fabrik.

**Ob das ein Problem ist, haengt am Ziel.** Zwei Fabriken heissen: beide Linien steigen
ab Minute 1 auf, die KI hat zu Phase 4 T3-Land **und** T3-Luft. Werden auch die
Rebuild-Bauer gesperrt, startet die zweite Linie erst in Phase 3 bei T1.

**Der Ingenieurnachschub haengt nicht daran.** Geprueft in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\units\units\UEB0102\UEB0102_unit.bp`
Z. 94-99: die Luftfabrik hat `BUILTBYTIER1FACTORY UEF MOBILE LAND CONSTRUCTION` in ihrer
`BuildableCategory`, kann also Ingenieure bauen. Eine KI mit nur einer Luftfabrik ist
nicht handlungsunfaehig.

Entscheidung offen, steht in `..\TODO.md`.

### Quantentor und SCU

| Bauer | Original | neu | wo |
|---|---:|---:|---|
| `Quantum Gate` (+ `- Small Base`, `- Expansion`) | 850 | **855** | Prioritaetsboden |
| `Sub Commander - Extra` | 650 | **905** | Prioritaetsboden |
| `Sub Commander` | 900 | 900 | unveraendert |
| `BaseSettings.EngineerCount.SCU` | 12 | **20** | Templateaenderung |

**Die Prioritaet war beim SCU nicht der Engpass.** `Sub Commander` liegt schon bei 900,
wird aber von `BelowEngineerCapCheck('SCU')` begrenzt. Die Rechnung steht in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\editor\UnitCountBuildConditions.lua`
Z. 699-743:

```
Grundwert    BaseSettings.EngineerCount.SCU
mal Cheat    max( Grundwert, floor(Grundwert * CheatValue^2) )
ab Limit 1000  + min( 1 + floor((Limit - 1000) / 300), 10 )
```

LOUDs 12 ergeben bei Einheitenlimit 5000 und Cheat 1 also **22** SCUs. Mit 20 werden
daraus **30**. Oberhalb der Grenze baut nur noch `Sub Commander - Extra`, und der verlangt
`GreaterThanEconTrendEfficiencyOverTime { 2, 60, 1.02, 1.04 }` - eine sehr gute
Wirtschaft.

Beide SCU-Bauer haben `BuilderType = {'Gate'}`, brauchen also das Quantentor. Deshalb der
Boden auf dem Tor.

### Das Ressourcen-Upgrade der SCU braucht keinen Eingriff

`SCUSelfEnhanceThread` in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\aibehaviors.lua`
Z. 8162 laeuft je SCU und arbeitet eine Liste ab. `EngineerManager.lua` Z. 225 startet
ihn, sobald eine SCU dem Manager zugeht.

| Fraktionsindex | Reihenfolge |
|---|---|
| 1 UEF | **ResourceAllocation**, AdvancedCoolingUpgrade, Shield, ShieldGeneratorField |
| 2 Aeon | **ResourceAllocation**, EngineeringFocusingModule, Shield, ShieldHeavy |
| 3 Cybran | **ResourceAllocation**, Switchback, StealthGenerator |
| 4 Seraphim | EngineeringThroughput, Shield, Teleporter |

`ResourceAllocation` steht bei drei von vier Fraktionen an **erster** Stelle. Der Thread
verlangt dafuer `MassTrend`/`EnergyTrend` ueber dem Bedarf sowie 450 Masse und 4500
Energie im Lager.

**Seraphim ist die Ausnahme - und das ist kein Fehler von LOUD.** Geprueft in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\units\units\XSL0301\XSL0301_unit.bp`:
die Seraphim-SCU hat ueberhaupt kein `ResourceAllocation`. Verfuegbar sind nur
`DamageStabilization`, `EngineeringThroughput`, `EnhancedSensors`, `Missile`,
`Overcharge`, `Shield`, `Teleporter`.

### Wie die Default-KI unberuehrt bleibt

**Anforderung des Nutzers (2026-08-08): keine Aenderungen an der Default-KI.**
Drei Stellen greifen global, alle drei sind ueber `aiBrain.CustomAIKey` abgesichert:

| Stelle | Absicherung |
|---|---|
| `Builders[<n>].PriorityFunction` (umhuellt) | Weiche im Inneren; ohne Key laeuft LOUDs Original |
| `hook\lua\defaultunits.lua` (`FactoryUnit`) | dito |
| `template.BaseSettings` | betrifft nur unser tief kopiertes Template |

#### Der Sonderfall, der beinahe durchgerutscht waere

Builder **ohne** eigene `PriorityFunction`: ohne Umhuellung ueberspringt
`BuilderManager.lua` Z. 316 den ganzen Zweig. Mit Umhuellung wird plotzlich eine Funktion
aufgerufen, wo vorher keine war.

Z. 327 lautet `if newPri and newPri != Priority` - **ein Rueckgabewert `false` laesst die
Zuweisung aus.** Genau das liefert die Umhuellung jetzt fuer fremde KIs, wenn kein
Original vorhanden ist. Damit ist sie ein echter Leerlauf.

**`self.Priority` waere hier falsch gewesen.** Der Aufruf lautet
`Builders[TaskName]:PriorityFunction( aiBrain, unit, self )` - `self` ist also die
**globale** Tabelle `Builders[name]`, nicht das Builder-Objekt des Managers. `self.Priority`
ist der urspruengliche, statische Wert. Haette der Manager die Aufgabe gerade
voruebergehend auf 10 gesetzt (Z. 170), haetten wir sie ungefragt wiederhergestellt.

Nebenbefund: aus demselben Grund ist `self.OldPriority` in einer `PriorityFunction`
**immer nil** - `SetPriority` schreibt es auf das Objekt des Managers. LOUDs verbreitetes
`return (self.OldPriority or self.Priority), true` ist damit effektiv nur
`return self.Priority, true`.

### Woher die Einstellung kommt

Die Option ist definiert in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\ui\lobby\lobbyOptions.lua`
Z. 91-118: `key = 'NoRushOption'`, Werte `'Off'`, `'5'`, `'10'`, `'20'` - Zeichenketten,
Einheit Minuten. LOUDs eigene Lobbyerweiterung
`gamedata.entpackt\lua\lua\LEMLobbyOptions.lua` fasst sie nicht an.

Optionen dieser Tabelle landen unter ihrem `key` in `ScenarioInfo.Options`. **Belegt an
zwei Nachbarn derselben Tabelle:**

| Fundstelle | liest |
|---|---|
| `gamedata.entpackt\lua\lua\simInit.lua` Z. 208 | `ScenarioInfo.Options.TeamLock == 'locked'` |
| `gamedata.entpackt\lua\lua\loudutilities.lua` Z. 5996 | `ScenarioInfo.Options.TeamSpawn == 'fixed'` |

`TeamSpawn` und `TeamLock` stehen in `lobbyOptions.lua` unmittelbar **vor**
`NoRushOption`, im selben Tabellenliteral.

**Ungeprueft:** ob der Schluessel auch dann gesetzt ist, wenn die Option in der Lobby nie
angefasst wurde. `NoRush.lua` faengt das ab - `tonumber(nil)` ergibt `nil`, daraus
0 Sekunden, daraus keine Sperre. Der Fehlschlag geht also in die harmlose Richtung: die
KI spielt wie LOUD, statt sich selbst lahmzulegen.

**Die Auswertung passiert zur Laufzeit**, beim ersten Aufruf einer umhuellten
`PriorityFunction` - nicht beim Laden. Damit stellt sich die Frage nach der
Verfuegbarkeit von `ScenarioInfo.Options` im simInit-Hook gar nicht erst.

Feste Sekunden bleiben moeglich: statt `Anteil` in einer Phase `Zeit` setzen. Damit
liesse sich eine KI bauen, die die Lobbyoption ignoriert.

**Phase 1 braucht keinen Eintrag fuer "Tech".** Fabrikaufstieg laeuft ueber
`LaunchUpgradeThread` und `FactorySelfEnhanceThread`, gestartet von
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\FactoryBuilderManager.lua`
Z. 630-645, sobald die Bauschlange einer Fabrik leer ist. Genau das erzeugt Phase 1 -
der Aufstieg beschleunigt sich also von selbst. **Mit der Fabriksperre ab 2026-08-08 ist
das der einzige Weg, wie die KI in Phase 1 an Tech kommt**: die eine Startfabrik des ACU
steigt auf, statt dass daneben neue T1-Fabriken entstehen.

**Aufklaerung faellt in Phase 4** (Entscheidung 2026-08-08). Waehrend des
No-Rush-Zeitraums gibt es nichts aufzuklaeren, und die Wirtschaft haengt nicht daran:
die `BuilderConditions` in `Loud_AI_Engineer_Mass_Builders.lua` und
`Loud_AI_Engineer_Energy_Builders.lua` sind ausschliesslich `EBC`-Lagerverhaeltnisse
(`LessThanEconMassStorageRatio`, `LessThanEconEnergyStorageRatio`) - **keine**
`LandRatio` oder `AirRatio`.

**Der Preis:** die KI startet Phase 4 ohne jedes Feindwissen. Bedrohungskarte,
Gegnerwahl (`loudutilities.lua` ab Z. 6270) und Angriffsplan bauen sich erst danach auf.
Deshalb liegt Phase 4 bei 75 Prozent und nicht bei 100 - bei 20 Minuten No-Rush also
fuenf Minuten vor der Freigabe. Ob das reicht, ist **ungeprueft**.

Die Verbandsbildung (`Land Formations - Scouts`, `Air Formations - Scouts`) bleibt in
allen Phasen frei - ohne gebaute Aufklaerer bildet sie ohnehin nichts.

**Nebenwirkung, ungeprueft:** ohne Truppenproduktion staut sich Masse. `MassToFactoryValues`
steuert, ab wann die KI neue Fabriken und Basen anfaengt - die Schwelle wird in Phase 1
vermutlich sehr frueh gerissen. Ob daraus "viele Basen" oder "viele leere Fabriken" wird,
zeigt erst der Testlauf.

**Nur diese drei LOUD-Templates kommen als `Source` in Frage.** Die uebrigen elf in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBaseTemplates\`
sind Aussenposten-, Marine- und Verteidigungsplaene. Beleg gegen `Loud_Naval_Large.lua`
Z. 7: `Builders = {}` - der gesamte Inhalt steht in `WaterMapBuilders`, und es gibt keine
`ACU Tasks - Start Game`-Gruppe. Als Startbasis gewaehlt haette die KI auf einer
Landkarte eine leere Aufgabenliste.

### Was die drei unterscheiden

| | Standard | Small | Smaller |
|---|---|---|---|
| `FactoryCount` LAND / AIR | 7 / 8 | 5 / 6 | 5 / 6 |
| `EngineerCount` T1 / T2 / T3 | 7 / 9 / 8 | 6 / 8 / 6 | 6 / 8 / 6 |
| `RallyPointRadius` | 42 | 42 | 40 |
| `Engineer Base Defense Construction - Picket Line` | ja | - | - |
| `Engineer Base Defense Construction - Perimeter` | ja | ja | - |
| Paragon (`Engineer T4 Economy Construction`) | volle Fassung | `- Small Base` | - |
| `Engineer Misc Construction` | volle Fassung | `- Small` | `- Small` |
| `Engineer Perimeter Shield Augmentation` | ja | - | - |

`MassToFactoryValues` ist in allen dreien gleich (7.5 / 14 / 20).

**Der eigentliche Effekt entsteht durch unsere Fabrik.** Weil sie `FirstBaseFunction`
ersetzt, spielt `customai_small` sein kompaktes Layout auf **jeder** Kartengroesse -
auch auf 40k, wo LOUD selbst nie darauf kaeme. Die Fehlpaarung ist Absicht: sie erzeugt
eine andere Wirtschaftsform und prueft zugleich, ob `Source` ueberhaupt umschaltbar ist.

### Wichtig: die Grenzwerte gelten je Basis, nicht je Armee

`FactoryCapCheck` und `BelowEngineerCapCheck` in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\editor\UnitCountBuildConditions.lua`
Z. 656 und 699 lesen `aiBrain.BuilderManagers[locationType].BaseSettings` - also die
Einstellungen **der jeweiligen Basis**. Die 5 Land- und 6 Luftfabriken betreffen nur
`MAIN`; Aussenposten bringen ihre eigenen Werte aus den `Loud_Expansion_*`-Templates mit.

**Folge:** Small und Smaller sparen keine Einheiten, sie **verlagern** sie. Die
Ueberschussmasse fliesst in Aussenposten statt in eine groessere Hauptbasis -
`MassToFactoryRatioBaseCheck` (`EconomyBuildConditions.lua` Z. 393) vergleicht das
Masseeinkommen gegen Fabrikzahl mal `MassToFactoryValues`, und bei weniger Fabriken faellt
die Pruefung frueher positiv aus.

**Ob dabei unterm Strich weniger Einheiten entstehen, ist ungeprueft** - gegenlaeufig
wirken die Bedingung `ExistingBasesHaveGreaterThanFactory` (alle gezaehlten Landbasen
brauchen 3 T3-Fabriken, bevor eine neue entsteht) und `AboveUnitCap65`, das den
Expansionsbauer ab 65 Prozent Einheitenlimit drosselt. Steht in `..\TODO.md`.

**Smaller hat einen Ueberschusskanal weniger:** kein Paragon-Bauer. Im langen Spiel
bleibt diese KI auf echte Masseextraktion angewiesen.

## 4c. Abhaengigkeiten und Konflikte

- **`requires`:** keine
- **`conflicts`:** keine
- **`before` / `after`:** keine

Andere Mods, die KIs registrieren, wuerden nebeneinander in der Liste erscheinen -
solange die Keys verschieden sind (siehe Fallstrick 1).

## 5. Performance

KI-Code laeuft dauernd und fuer jeden KI-Spieler. Der Referenzlauf zeigt, was passiert,
wenn eine KI-Schleife ins Leere laeuft: **15.041 Warnungen aus einem einzigen fehlenden
Bauziel** (`..\15_LOG.md` R-01). Bei eigenem KI-Code den Log nach jedem Testlauf pruefen.

## 6. Multiplayer

- Alle Spieler brauchen den Mod: **ja** (Sim-Mod)
- Determinismus: KI-Entscheidungen laufen in der Sim - `..\04_LUA_SIM.md` Abschnitt 5
  beachten, insbesondere kein `math.random` und keine unsortierten Tabellen als
  Entscheidungsgrundlage

## 7. Testaufbau - fertig vorbereitet

**Stand 2026-08-06: die Sonde ist gebaut.** Ein einziger Spielstart beantwortet alle
offenen Fragen. Der Aufbau veraendert das Spiel nicht.

### Angelegte Dateien

| Datei | Zweck |
|---|---|
| `lua\AI\CustomAIs_v2\CustomAI.lua` | registriert den Key `customai_probe` als "AI: Sonde (Test)" |
| `lua\AI\ProbeBaseTemplate.lua` | Basistemplate, das protokolliert und **nie gewinnt** |
| `hook\lua\simInit.lua` | laedt die Sonde nach; meldet, ob der Hook greift |
| `hook\lua\aibrain.lua` | Rueckfallebene, springt nur ein wenn der erste Hook versagt |

### Warum das ungefaehrlich ist

`FirstBaseFunction` der Sonde gibt **immer 0** zurueck. `GetBestBasePlan` startet mit
`returnVal = 10` und uebernimmt einen Plan nur bei `baseVal > returnVal`. Die Sonde kann
also nie gewaehlt werden - sie beobachtet nur. `Builders` ist leer, damit keine
`Invalid BuilderGroup`-Warnungen entstehen.

Die beiden Hooks sind ueber den Merker `_G.CUSTOMAI_TEMPLATE_LOADED` gegeneinander
gesperrt, sodass das Template genau einmal registriert wird.

### Durchfuehrung

1. LOUD starten
2. Im Mod-Manager **Custom AI** aktivieren
3. Skirmish, kleine Karte, **ein KI-Gegner**
4. In der Lobby beim KI-Gegner die Auswahlliste oeffnen
5. Falls vorhanden: **AI: Sonde (Test)** waehlen, sonst LOUD lassen
6. Partie starten, kurz laufen lassen, beenden
7. `LOUD\bin\LOUD.log` sichern - er wird beim naechsten Start ueberschrieben

### Auswertung

Alle eigenen Zeilen tragen das Praefix `CUSTOMAI:`. Filter:

```bash
grep -E 'CUSTOMAI:|Processing AI Mod|BaseBuilderTemplate|Invalid BuilderGroup|Selected' LOUD.log
```

| Beobachtung | Bedeutung |
|---|---|
| `*AI DEBUG Processing AI Mod .../customai` | Der Mod-Zweig in `GetAIList()` hat den Mod gefunden |
| "AI: Sonde (Test)" steht in der Lobby-Liste | **Registrierung funktioniert** - Kernfrage 1 beantwortet |
| `CUSTOMAI: Hook auf simInit.lua greift` | Hooks wirken auf `simInit.lua` |
| `CUSTOMAI: Hook auf aibrain.lua greift` | Hooks wirken auf `aibrain.lua` |
| `CUSTOMAI: lade ProbeBaseTemplate ueber ...` | dieser Weg hat das Template geladen |
| `CUSTOMAI: ProbeBaseTemplate.lua wird geladen` | Import und Registrierung liefen durch |
| `CUSTOMAI: FirstBaseFunction fuer ...` | **Kernfrage 2** - welcher Wert steht in `AIPersonality`? |
| `Invalid BuilderGroup named` | sollte **nicht** erscheinen |
| `Duplicate BaseBuilderTemplate detected` | sollte **nicht** erscheinen |

### Die entscheidende Zeile

```
CUSTOMAI: FirstBaseFunction fuer <Spielername> - ArmySetup.AIPersonality = <wert> - aiBrain.Personality = <wert>
```

| Wert | Folge |
|---|---|
| `customai_probe` | Der Lobby-Key kommt an. Der Ansatz aus Abschnitt 3 traegt - eine eigene KI laesst sich ueber ein eigenes Basistemplate umsetzen. |
| `loud` oder `nil` | Der Key kommt **nicht** an. Der Ansatz traegt nicht; es braucht einen anderen Einstiegspunkt, etwa einen Hook auf `SetupMainBase` selbst. |

Erscheint die Zeile gar nicht, wurde das Template nicht registriert - dann sagen die
Hook-Zeilen darueber, woran es lag.

### Wenn die KI nicht in der Liste auftaucht

Moegliche Ursachen, in dieser Reihenfolge pruefen:

1. Mod nicht aktiviert - `Mounting mod 'customai'` im Log suchen
2. Lua-Fehler in `CustomAI.lua` - nach `error:` und `Problem loading` suchen
3. `GetAIList()` bricht ab, weil eine andere Datei in einem `CustomAIs_v2`-Ordner keine
   globale `AI`-Tabelle hat

### Testlauf 4 - Grundgeruest und Cheat-Frage

**Ein Lauf beantwortet beides.** Wichtig: **mit Cheat-Multiplikator starten**, sonst
laesst sich Frage B nicht beantworten.

#### Durchfuehrung

1. Mod-Manager: **Custom AI** aktivieren
2. Skirmish, kleine Karte, **ein KI-Gegner**
3. In der Lobby **AI: LOUD Standard (Custom)** waehlen
4. **Cheat-Multiplikator auf einen Wert ueber 1 stellen** (z. B. 1.5), damit das
   Cheat-System ueberhaupt etwas tut
5. Partie starten, ein paar Minuten laufen lassen, beenden
6. `LOUD\bin\LOUD.log` sichern

#### Frage A - greift das Grundgeruest?

| # | Erwartete Logzeile | Bedeutung |
|---|---|---|
| 1 | `CUSTOMAI: Hook auf simInit.lua greift` | Einstieg |
| 2 | `CUSTOMAI: registriert CustomAI_customai_standard (Key customai_standard, Quelle Loud_Main_Standard, Wert 200)` | Vererbung und Registrierung |
| 3 | `CUSTOMAI: 1 von 1 KIs registriert` | Schleife vollstaendig |
| 4 | `AI: LOUD Standard (Custom)` in der Lobby-Liste | Registrierung UI |
| 5 | `CUSTOMAI: <name> bewirbt sich mit CustomAI_customai_standard (Wert 200, Key aus ..., Personality = ...)` | eigenes Template meldet sich |
| 6 | `*AI DEBUG <name> Selected "CustomAI_customai_standard"` | **eigenes Template gewinnt** |
| 7 | **kein** `Invalid BuilderGroup named` | geerbte Builder-Liste gueltig |
| 8 | **kein** `Duplicate BaseBuilderTemplate detected` | steht neben LOUD |

Dazu die Spielprobe: Die KI soll sich **wie LOUD verhalten** - Basis aufbauen,
expandieren, angreifen.

#### Frage B - bekommt die KI die vollen Cheats?

| Beobachtung | Bedeutung |
|---|---|
| `CUSTOMAI: <name> - Personality von 'customai_standard' auf 'loud' gesetzt (CustomAIKey = ..., CheatValue = ...)` | **der Hook hat gegriffen** |
| `Standard Cheat is <wert>` | LOUDs eigene Ausgabe aus `SetupAICheat` |
| `Resource mult is <wert>` | Stufe 1 - kommt immer |
| **`BuildRate mult is <wert>`** | **Warnzeichen** - diese Zeile erscheint **nur im fremden Zweig**. Sieht man sie, ist `Personality != 'loud'` gewesen und Stufe 2 fehlt. |

**Die entscheidende Reihenfolge im Log:** Steht
`CUSTOMAI: ... Personality ... auf 'loud' gesetzt` **vor** `Standard Cheat is`, hat der
Hook rechtzeitig gegriffen.

#### Zusatzfrage C - welche Quelle liefert den Key?

In Zeile 5 steht `Key aus CustomAIKey` oder `Key aus ScenarioInfo`:

| Wert | Bedeutung |
|---|---|
| `CustomAIKey` | der aibrain-Hook lief vor der Basiswahl - beide Wege funktionieren |
| `ScenarioInfo` | der Hook lief spaeter, der Rueckfall hat gegriffen |

Beides ist in Ordnung; interessant ist nur, **welcher** Weg traegt.

#### Auswertung

```bash
grep -E 'CUSTOMAI:|Cheat|Processing AI Mod|BaseBuilderTemplate|Invalid BuilderGroup|Selected' LOUD.log
```

#### Wenn etwas schiefgeht

| Symptom | Vermutliche Ursache |
|---|---|
| Ladeschirm haengt | Lua-Fehler im Hook - nach `access to nonexistent global` und `Error importing` suchen |
| KI fehlt in der Lobby | Datei in `CustomAIs_v2\` ohne globale `AI`-Tabelle |
| KI tut nichts | Name enthaelt nicht `AI: LOUD` |
| `Selected "Loud_Main_Standard"` statt unseres Templates | `FirstBaseFunction` hat 0 zurueckgegeben - Key stimmt nicht ueberein |

### Ergebnisse

| # | Test | Ergebnis |
|---|---|---|
| 1 | Mod erscheint im Mod-Manager | **ja** (Lauf 2) |
| 2 | KI erscheint in der Lobby-Liste | **ja** (Lauf 2) |
| 3 | Hook auf `simInit.lua` greift | **ja**, laeuft zuerst |
| 4 | Hook auf `aibrain.lua` greift | **ja**, Sperre funktioniert |
| 5 | Template wird registriert | **ja**, keine Warnungen |
| 6 | `FirstBaseFunction` wird aufgerufen | **ja** (Lauf 3, nach Umbenennung) |
| 7 | Lobby-Key kommt in `AIPersonality` an | **ja** - `customai_probe` |

**Die Sondierung ist abgeschlossen.** Alle sieben Fragen beantwortet.

### Testlauf 4 - Ergebnis: alles bestanden

**2026-08-07**, Cheat-Multiplikator 1.5.

| # | Test | Ergebnis |
|---|---|---|
| 8 | **Eigenes Template gewinnt die Basiswahl** | **ja**, Z. 960 |
| 9 | **Volle Cheats (Stufe 2)** | **ja**, Z. 801 |
| 10 | Keine `Invalid BuilderGroup` | bestaetigt |
| 11 | Keine `Duplicate BaseBuilderTemplate` | bestaetigt |
| 12 | Key aus `CustomAIKey` statt Rueckfall | bestaetigt |

#### Die belegenden Zeilen

```
684  CUSTOMAI: Hook auf simInit.lua greift
685  CUSTOMAI: registriert CustomAI_customai_standard
     (Key customai_standard, Quelle Loud_Main_Standard, Wert 200)
686  CUSTOMAI: 1 von 1 KIs registriert
735  CUSTOMAI: KIs waren schon geladen - simInit-Hook hat gegriffen
736  CUSTOMAI: Zan-Iavow (AI: LOUD Standard (Custo) - Personality von
     'customai_standard' auf 'loud' gesetzt
     (CustomAIKey = 'customai_standard', CheatValue = 1.5)
798       Zan-Iavow ... Standard Cheat is 1.5
799       Zan-Iavow ...  Resource mult is 1.5
800       Zan-Iavow ... BuildRate mult is 1.5
801       Zan-Iavow ... Minor Cheat 1.1699999570847  Major Cheat is 1.3250000476837
806       Zan-Iavow ... Unit cap set to 7500 from 5000 based on cheat (1.5) & OutnumberedRatio
957  CUSTOMAI: Zan-Iavow ... bewirbt sich mit CustomAI_customai_standard
     (Wert 200, Key aus CustomAIKey, Personality = loud)
960  *AI DEBUG Zan-Iavow ... Selected "CustomAI_customai_standard"
```

#### Was daraus folgt

**Der Personality-Hook war noetig und wirkt.** Zeile 801 (`Minor Cheat` / `Major Cheat`)
stammt aus dem `loud`-Zweig von `SetupAICheat` - ohne den Hook waere sie nicht
erschienen. Auch die Anhebung des Einheitenlimits von 5000 auf 7500 in Z. 806 haengt
daran.

**Die Reihenfolge stimmt:** Z. 736 (Hook) liegt vor Z. 798 (Cheat-Setup).

**`CustomAIKey` traegt.** Der aibrain-Hook laeuft vor der Basiswahl - der
ScenarioInfo-Rueckfall wurde nicht gebraucht, bleibt aber als Absicherung.

**Das Grundgeruest steht.** Ab hier lassen sich Verhaltensaenderungen einbauen, ohne die
Mechanik erneut zu pruefen.

#### Korrektur einer frueheren Annahme

In der Vorbereitung stand, `BuildRate mult is` erscheine **nur** im fremden Zweig und sei
damit ein Warnzeichen. **Falsch** - die Zeile steht zweimal im Quelltext:
`aiutilities.lua` Z. 844 (fremder Zweig) und Z. 884 (`loud`-Zweig). Sie taugt nicht zur
Unterscheidung.

**Der richtige Beleg fuer Stufe 2 ist `Minor Cheat ... Major Cheat is ...`** (Z. 885) -
diese Zeile gibt es nur einmal, im `loud`-Zweig.

#### Nebenbefund: Nickname wird gekuerzt

Im Log erscheint **`AI: LOUD Standard (Custo`** statt `AI: LOUD Standard (Custom)`.
Der Nickname wird offenbar auf eine feste Laenge beschnitten. Fuer die Namenspruefung auf
`AI: LOUD` ohne Belang, weil der Praefix erhalten bleibt - bei laengeren Namen aber zu
bedenken. **Ungeprueft**, wo die Begrenzung sitzt.

### Testlauf 5 - 2026-08-08, vier eigene KIs gleichzeitig

Karte 2048 (20k), Wasseranteil 0, Einheitenlimit 5000, **Cheat 1**, Sandbox.
Vier KI-Gegner, je eine unserer vier Definitionen. Laufzeit kurz (Gesamtsitzung 6:45
einschliesslich Lobby und Ladezeit).

#### Ergebnis: alles Mechanische bestaetigt

| # | Test | Ergebnis | Beleg |
|---|---|---|---|
| 13 | Alle vier KIs registriert | **ja** | `CUSTOMAI: 4 von 4 KIs registriert` |
| 14 | Jede erbt von ihrer eigenen Quelle | **ja** | drei `registriert CustomAI_... (Quelle Loud_Main_Standard/Small/Smaller)` |
| 15 | Jede gewinnt **ihre eigene** Basiswahl | **ja** | vier `Selected "CustomAI_customai_<key>"`, kein Fehlgriff |
| 16 | `NoRushOption` kommt im Sim an | **ja** | `CUSTOMAI NoRush: Lobbyoption NoRushOption = 20 -> 1200 Sekunden` |
| 17 | `aiBrain.CustomAIKey` ist in der `PriorityFunction` gesetzt | **ja** | siehe unten |
| 18 | Sperren gesetzt | **ja** | `95 Sperren gesetzt` (8 + 7 + 80) |
| 19 | Keine `Invalid BuilderGroup` | bestaetigt | kein Treffer |
| 20 | Keine `Duplicate BaseBuilderTemplate` | bestaetigt | kein Treffer |
| 21 | Kein `access to nonexistent global variable` | bestaetigt | kein Treffer - **bei vier KIs** |
| 22 | `HiPri`-Fehler aus Lauf 2 und 3 | **nicht aufgetreten** | kein Treffer |

#### Wie Test 17 belegt ist

`NoRushDauer()` in `AIs\NoRush.lua` wird **nur innerhalb des Sperrzweigs** aufgerufen -
erst wenn `aiBrain.CustomAIKey` gesetzt **und** ein Sperreintrag fuer diesen Key gefunden
ist. Die Zeile `Lobbyoption NoRushOption = 20` kann also gar nicht erscheinen, wenn der
Key fehlt. Damit ist der letzte offene Punkt der Mechanik geschlossen.

#### Test 21 relativiert den offenen Befund

`AddGlobalBaseTemplate` setzt am Ende `BaseBuilderTemplates = nil` und
`BuilderGroups = nil`. **Vier KIs liefen nacheinander durch `GetBestBasePlan`, alle vier
erfolgreich** - der erwartete Fehler blieb aus. Entweder weicht die installierte Fassung
von `gamedata.entpackt\lua\lua\AI\aiaddbuildertable.lua` ab, oder es gibt doch einen
Reload. **Offen bleibt der Fall Aussenposten** - in diesem kurzen Lauf entstand keiner
(kein `Creating new base` im Log).

#### Was der Lauf NICHT beantwortet

**Die KIs sahen im Spiel gleich aus.** Das ist bei dieser Laufzeit zu erwarten:

- LOUDs Eroeffnung ist fuer alle identisch - ACU baut Landfabrik, dann Ingenieure,
  Massextraktoren, Kraftwerke. Kampfeinheiten kaemen ohnehin spaeter.
- Die NoRush-Sperren betreffen Truppen, Aufklaerung und Verteidigung. In den ersten
  Minuten haette LOUD davon nichts gebaut - **die Sperre kann sich noch gar nicht
  zeigen**. Bei `NoRushOption = 20` liegt die erste Phasengrenze bei 7:00.
- Small und Smaller unterscheiden sich erst bei 5 statt 7 Landfabriken - eine Grenze,
  die so frueh nicht erreicht wird.

**Der Log zeigt keine Bautaetigkeit.** Ohne die Debug-Schalter `DisplayFactoryBuilds`
und `EngineerDialog` (`aibrain.lua` ab Z. 7) steht nicht im Log, was gebaut wurde.
Fuer die naechste Runde einschalten.

#### Die zweite Fabrik ist Absicht, kein Fehler

`Engineer Factory Construction` steht **nicht** in den NoRush-Sperren. Der Grund steht in
Abschnitt 4bb: der Techaufstieg laeuft in LOUD ueber Fabrikaufstiege, also braucht die KI
Fabriken. Die Gruppe enthaelt an `MAIN` vier Bauer fuer **neue** Fabriken
(`Loud_AI_Engineer_Factory_Builders.lua` ab Z. 106):

```
Land Factory Balance                       Z. 175
Air Factory Balance                        Z. 219
Land Factory - High Air Production Ratio   Z. 268
Air Factory - Land Ratio High              Z. 317
```

dazu `Land Factory Rebuild` und `Air Factory Rebuild` fuer zerstoerte Fabriken.

**Wer den Fabrikbau in Phase 1 unterbinden will**, sperrt die vier oberen und laesst die
beiden Rebuild-Bauer frei. Preis: weniger Fabriken heisst weniger Ingenieurproduktion und
damit langsamerer Wirtschaftsaufbau. Steht als Entscheidung in `..\TODO.md`.

#### Nebenbefund: 22 Tooltip-Warnungen

```
warning: No tooltip in table for key: aitype_customai_standard   (7x)
warning: No tooltip in table for key: aitype_customai_small      (6x)
warning: No tooltip in table for key: aitype_customai_smaller    (5x)
warning: No tooltip in table for key: aitype_customai_norush     (4x)
```

Harmlos, aber vermeidbar: `enhancedlobby.lua` Z. 289 liest
`<mod>\lua\AI\CustomAITooltips\*.lua` mit einer `Tooltips`-Tabelle. Damit bekaemen die
vier Eintraege in der Lobby auch eine Beschreibung - die `Description`-Felder aus
`AIDefinitions.lua` liegen bereits vor. Steht in `..\TODO.md`.

### Verlauf der Testlaeufe

| Lauf | Datum | Ergebnis |
|---|---|---|
| 1 | 2026-08-06 | Sim-Absturz, Ladeschirm haengt. Ursache: `_G.FOO`-Zugriff auf nicht gesetzte Globale. Behoben mit `rawget`, Regel in `..\04_LUA_SIM.md` Abschnitt 2. |
| 2 | 2026-08-07 | Sim startet. Registrierung und Hooks belegt. KI steht im Spiel, tut aber nichts - Uebergabemechanismus ueber den **Nickname** gefunden. |
| 3 | 2026-08-07 | Nach Umbenennung in `AI: LOUD Sonde (Test)`: LOUDs Plan laeuft, `FirstBaseFunction` meldet den Lobby-Key. |
| 4 | 2026-08-07 | Fabrik statt Sonde, Personality-Hook eingebaut, Cheat 1.5. **Eigenes Template gewinnt, volle Cheats.** Grundgeruest bestaetigt. |
| 5 | 2026-08-08 | Vier eigene KIs gleichzeitig. Alle registriert, jede gewinnt ihre eigene Basiswahl. `NoRushOption` kommt im Sim an, `CustomAIKey` ist in der `PriorityFunction` gesetzt. Keine Warnung. **Verhaltensunterschiede noch nicht sichtbar** - Laufzeit zu kurz. |

Log-Praefix fuer eigene Ausgaben: `CUSTOMAI:`

## 8. Offene Punkte

- [ ] Kein Icon hinterlegt - es gilt das generische Standardsymbol.
- [x] **Wie wirkt der Lobby-Key auf das Verhalten?** LOUDs eigene Basistemplates werten
      ihn nicht aus. Ein **eigenes** Basistemplate kann ihn in `FirstBaseFunction` lesen -
      belegt in Lauf 3.
- [x] **Kann ein Mod eigene AIBaseTemplates laden?** Ja, per Import mit vollem
      `/mods/...`-Pfad aus einem Hook. Belegt in Lauf 2 und 3.
- [x] **Greift ein Hook auf `simInit.lua`?** Ja - und er laeuft vor dem Hook auf
      `aibrain.lua`.
- [x] **Enthaelt `AIPersonality` in `FirstBaseFunction` noch den Lobby-Key?** Ja.
- [x] **Wie uebergibt LOUD an eine eigene KI?** Ueber den Nickname, nicht den Key.
- [ ] **Kontrolllauf ohne den Mod** - erscheint der `HiPri`-Fehler auch dann?
- [ ] **Weg waehlen: A (aufsetzen) oder B (uebernehmen)?**
- [ ] **Ziel festlegen:** Was soll die KI anders machen?

## 9. Quellen

Stellschrauben und Referenz: [CustomAI_Stellschrauben.md](CustomAI_Stellschrauben.md)

| Datei | Was steht dort |
|---|---|
| `gamedata.entpackt\lua\lua\enhancedlobby.lua` | `GetAIList()` Z. 172, Mod-Zweig Z. 248, Tooltips Z. 289 |
| `gamedata.entpackt\lua\lua\ui\lobby\aitypes.lua` | Einstiegspunkt der Lobby |
| `gamedata.entpackt\lua\lua\AI\CustomAIs_v2\ExtrasAI.lua` | Muster einer Registrierungsdatei |
| `gamedata.entpackt\lua\lua\aibrain.lua` | Z. 893 - `self.Personality` |
| `gamedata.entpackt\lua\lua\AI\aiarchetype-managerloader.lua` | Z. 43-50 `SetupMainBase`, Z. 88 `GetBestBasePlan` |
| `gamedata.entpackt\lua\lua\system\GlobalBaseTemplate.lua` | Registrierung, Duplikatsverhalten, Pruefungen |
| `gamedata.entpackt\lua\lua\simInit.lua` | Z. 353-363 - Laden der AI-Templates, **ohne Mod-Zweig** |
| `gamedata.entpackt\lua\lua\AI\AIBaseTemplates\Loud_Main_Standard.lua` | `FirstBaseFunction` Z. 159-220 - wertet nur Kartendaten aus |
| `usermods\nomads-4-loud\shadow\lua\factions.lua` | Lademuster: Original ueber `/loud/...`, eigene Datei ueber `/mods/...` |
| `usermods\nomads-4-loud\shadow\lua\ui\lobby\aiNames.lua` | nur KI-Spielernamen - **keine** KI-Registrierung |
