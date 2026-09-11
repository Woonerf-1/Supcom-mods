# CustomAI - Bedingungen und Schwellen

Vollstaendige Aufstellung der `BuilderConditions` aller Bauer, die
`customai_aeon_air` steuert. Stand 2026-08-08.

**Erhebungsmethode:** maschinell aus `lua\AI\AIBuilders\Loud_AI_*.lua` extrahiert.
Das Muster erfasst die Form `{ MODUL, 'Name', { Argumente }}`. **Nicht erfasst** sind
Bedingungen mit abweichender Schreibweise (etwa `{ ... } }` mit Leerzeichen) sowie
Bedingungen der Form `{ <Funktion>, { Argumente } }`. Die Liste ist damit
**nicht garantiert vollstaendig** - bei `Sub Commander` fehlt zum Beispiel das
belegte `BelowEngineerCapCheck`.

---

## 1. Sind die Schwellen fix?

**Nein, es sind drei verschiedene Arten** - das ist bei jeder Anpassung zu beachten.

### Absolut und fix

```lua
function GreaterThanEconStorageCurrent(aiBrain, mStorage, eStorage)
    if GetEconomyStored( aiBrain, 'MASS') >= mStorage then
        return GetEconomyStored( aiBrain, 'ENERGY') >= eStorage
    end
    return false
end
```

Keine Skalierung, keine Anpassung an Spielstand oder Cheatwert. Das ist die
haeufigste Bedingung - und die, die eine sparsame Eroeffnung regelmaessig blockiert.

### Absolut, aber cheat-skaliert

```lua
function GreaterThanEconEnergyStorageCurrent(aiBrain, eStorage)
    return GetEconomyStored( aiBrain, 'ENERGY') >= (eStorage * (1/LOUDMAX( 1, aiBrain.CheatValue)))
end
```

**Der Wert wird durch den Cheatwert geteilt.** Bei 1.3 werden aus 2500 also 1923.
Nur diese eine Funktion tut das.

### Relativ - skaliert von selbst

```lua
function LessThanEconMassStorageRatio(aiBrain, mStorageRatio)
    return (GetEconomyStoredRatio( aiBrain, 'MASS' ) *100) < mStorageRatio
end
```

Prozent der Lagerkapazitaet. Waechst die Kapazitaet, waechst die Schwelle mit -
diese Bedingungen brauchen in aller Regel keine Anpassung.

Ebenso relativ: `GreaterThanEnergyTrendOverTime` und
`GreaterThanEconTrendEfficiencyOverTime` arbeiten auf
`aiBrain.EcoData['OverTime']` - Trends, keine Bestaende.

**Faustregel:** `...StorageCurrent` ist absolut und muss geprueft werden,
`...Ratio` und `...Trend...` sind relativ und koennen meist bleiben.

---

## 2. Die Bedingungen im Einzelnen

Legende: **fix** = absolute Zahl ohne Skalierung, **cheat** = durch CheatValue
geteilt, **rel** = relativ zu Lager oder Trend.

### Wirtschaft - Extraktoren und Speicher

| Bauer | Bedingung | Wert | Art |
|---|---|---|---|
| `Mass Extractor T1 - 250` | `LessThanEconMassStorageRatio` | 90 | rel |
| | `GreaterThanEconStorageCurrent` | 60, 500 | **fix** |
| | `CanBuildOnMassAtRange` | 0, 250, -9999, 20, 0 | - |
| | `NoBaseAlert` | - | - |
| `Mass Storage 600` | `MassExtractorInRangeHasLessThanStorage` | 20, 600, 4 | - |
| | `GreaterThanEconEnergyStorageCurrent` | 2500 | **cheat** |
| | `GreaterThanEnergyTrendOverTime` | 20 | rel |
| | `NoBaseAlert` | - | - |

### Wirtschaft - Kraftwerke

| Bauer | Bedingung | Wert | Art |
|---|---|---|---|
| `T1 Power Template` | `GreaterThanEconStorageCurrent` | 150, 0 | **fix** |
| | `LessThanEconEnergyStorageRatio` | 75 | rel |
| | `LessThanEnergyTrendOverTime` | 45 | rel |
| `T2 Power Template` | `GreaterThanEconStorageCurrent` | 200, 2600 | **fix** |
| | `LessThanEnergyTrendOverTime` | 60 | rel |
| `T3 Power Template` | `LessThanEnergyTrendOverTime` | 260 | rel |
| | `BuildingLessAtLocation` | 1, ENERGYT3 | - |

`T3 Power Template` hat **keine** absolute Schwelle - der Aufstieg auf T3-Strom ist
also nicht durch Lagerbestaende gebremst, sondern nur durch `BuilderType`
(`T3`/`SubCommander`).

### Unterstuetzung

| Bauer | Bedingung | Wert | Art |
|---|---|---|---|
| `Assist Mass` | `BuildingGreaterAtLocationAtRange` | 0, MASSPRODUCTION-TECH1, ENGINEER+MASSPRODUCTION, **120** | Radius |
| | `LessThanEconMassStorageRatio` | 60 | rel |
| | `GreaterThanEconStorageCurrent` | 150, **2500** | **fix** |
| `Assist Energy` | `LessThanEnergyTrendOverTime` | 260 | rel |
| | `LessThanEconEnergyStorageRatio` | 75 | rel |
| | `GreaterThanEconStorageCurrent` | 250, 500 | **fix** |
| | `BuildingGreaterAtLocationAtRange` | ..., **105** | Radius |
| `Assist ACU SACU` | `GreaterThanEconStorageCurrent` | 300, 5000 | **fix** |
| | `LocationEngineerNeedsBuildingAssistanceInRange` | ENGINEER, ENGINEER, **100** | Radius |

### Fabriken und Tor

| Bauer | Bedingung | Wert | Art |
|---|---|---|---|
| `Air Factory Balance` | `FactoryCapCheck` | 'AIR' | BaseSettings |
| | `GreaterThanEconStorageCurrent` | 300, 3600 | **fix** |
| | `BuildingLessAtLocation` | 1, FACTORY | - |
| | `GreaterThanEconTrendEfficiencyOverTime` | 0.3, 3, 1.002, 1.002 | rel |
| `Quantum Gate` | `GreaterThanEnergyIncome` | **12600** | **fix** |
| | `GreaterThanEconStorageCurrent` | 400, 5000 | **fix** |
| | `GreaterThanEconTrendEfficiencyOverTime` | 0.8, 15, 1.002, 1.002 | rel |
| | `NoBaseAlert` | - | - |

### Techniker

| Bauer | Bedingung | Wert |
|---|---|---|
| `Engineer T1 - Initial` | `LocationFactoriesBuildingLess` | 1, MOBILE*ENGINEER |
| | **`EngineerLessAtLocation`** | **3**, ENGINEER-TECH3-SUBCOMMANDER-COMMAND |
| `Engineer T1 - Standard` | `PoolLessAtLocation` | 1, MOBILE*ENGINEER |
| | `LocationFactoriesBuildingLess` | 1, MOBILE*ENGINEER |
| `Engineer T2 - Standard` | `PoolLessAtLocation` | 1, MOBILE*ENGINEER*TECH2 |
| | `GreaterThanEconTrendEfficiencyOverTime` | 0.6, 6, 1, 1 |
| | `LocationFactoriesBuildingLess` | 1, MOBILE*ENGINEER |
| `Engineer T3 - Standard` | `PoolLessAtLocation` | 1, MOBILE*ENGINEER*TECH3-SUBCOMMANDER |
| | `GreaterThanEconTrendEfficiencyOverTime` | 0.6, 6, 1, 1 |
| | `LocationFactoriesBuildingLess` | 1, MOBILE*ENGINEER*TECH3 |
| `Sub Commander` | `PoolLessAtLocation` | 2, SUBCOMMANDER |
| | `BelowEngineerCapCheck` | 'SCU' (Regex-Luecke, aus dem Quelltext belegt) |

**`LocationFactoriesBuildingLess { 1, MOBILE*ENGINEER }`** steht bei jedem
Technikerbauer: hoechstens **eine** Fabrik baut gleichzeitig Techniker. Bei einer
reinen Luftwaffe mit einer Fabrik heisst das: immer nur einer zur Zeit.

**`EngineerLessAtLocation { 3, ... }`** bei `Engineer T1 - Initial` - LOUD begrenzt
den Anfangsbau selbst auf drei.

### Kommandant

| Bauer | Bedingung | Wert | Art |
|---|---|---|---|
| `CDR - T1 Power` | `GreaterThanEconStorageCurrent` | 150, 0 | **fix** |
| | `LessThanEnergyTrendOverTime` | 45 | rel |
| | `UnitsLessAtLocation` | 1, ENERGYPRODUCTION*STRUCTURE*TECH3 | - |
| | `UnitsLessAtLocationInRange` | **76**, ENERGY*TECH1, 0, 33 | - |
| `CDR - Mass Extractor` | `GreaterThanEconStorageCurrent` | 75, 500 | **fix** |
| | `CanBuildOnMassAtRange` | 0, **35**, -9999, 35, 0 | Radius |
| `CDR Assist Mass` | `LessThanEconMassStorageRatio` | 75 | rel |
| | `GreaterThanEconStorageCurrent` | 150, **2500** | **fix** |
| | `BuildingGreaterAtLocationAtRange` | ..., **36** | Radius |

`CDR - T1 Power` stoppt von selbst bei **76** T1-Kraftwerken im Umkreis 33 oder
sobald ein T3-Kraftwerk steht. `CDR - Mass Extractor` sucht nur im Umkreis **35**.

---

## 3. Wiederkehrende Werte

| Wert | kommt vor bei | Wirkung |
|---|---|---|
| **2500 Energie** | `Assist Mass`, `Mass Storage 600`, `CDR Assist Mass` | blockiert Unterstuetzung und Speicher in der Eroeffnung |
| **150 Masse** | `T1 Power Template`, `Assist Mass`, `CDR - T1 Power`, `CDR Assist Mass` | unkritisch |
| **Radius 100-120** | alle Assist-Bauer | Unterstuetzung nur nahe der Basis |

**Bei jedem Bauer, der nicht anlaeuft, zuerst auf `...StorageCurrent` mit hohem
Energiewert pruefen.**

---

## 4. `PlatoonTemplate` - nur bei FactoryBuildern relevant

| Managertyp | was gelesen wird | Fundstelle |
|---|---|---|
| `EngineerBuilder` | **nur** `PlatoonTemplates[...].Plan` | `EngineerManager.lua` Z. 267 |
| `FactoryBuilder` | die Squadliste ueber `GetFactoryTemplate` | `FactoryBuilderManager.lua` Z. 275, 660-760 |

Beim Ingenieurmanager ist die Einheit bereits vorhanden und wird per
`AssignUnitsToPlatoon` zugewiesen; die Vorlage liefert nur den AI-Plan
(`EngineerBuildAI`). Die Squadliste (`{ cat, 1, 1, 'Support', 'none' }`) wird nie
ausgewertet.

**Folge:** `PlatoonMax` wirkt ausschliesslich bei `Gruppentyp = 'FactoryBuilder'`.
Bei einer Kopie eines EngineerBuilders waere es wirkungslos - und die Kopie der
Vorlage ueberfluessiger Ballast.

---

## 5. Builder getriggert pausieren

**Es gibt eine fertige API** - LOUD nutzt sie selbst.

```lua
-- sim\BuilderManager.lua Z. 136-163
SetBuilderPriority = function( manager, builderName, priority, temporary )
```

und der Anwendungsfall im selben Modul (Z. 165-181):

```lua
AssignTimeout = function( self, builderName, timeoutticks )
    WaitTicks(2)
    local builder = self:SetBuilderPriority( builderName, 10, true )
    local priority = self:GetBuilderPriority(builderName)
    if builder and priority then
        if timeoutticks then WaitTicks(timeoutticks) end
        builder:ResetPriority(self)
    end
end,
```

**Zugang von aussen:**

```lua
aiBrain.BuilderManagers[locationType].EngineerManager:SetBuilderPriority(name, 10, true)
aiBrain.BuilderManagers[locationType].FactoryManager:SetBuilderPriority(name, 10, true)
```

`priority == 0 and not temporary` entfernt den Builder **endgueltig** aus der Liste
(Z. 150-152) - fuer eine dauerhafte Sperre ist das der saubere Weg, aber
unumkehrbar.

### Vergleich mit der Umhuellung der `PriorityFunction`

| | Umhuellung | `SetBuilderPriority` |
|---|---|---|
| Reichweite | global, Weiche ueber `CustomAIKey` | je Manager, also je Basis |
| Zeitpunkt | bei jeder Auswahl geprueft | einmal gesetzt, gilt bis zum Zuruecksetzen |
| Aufwand | Wrapper um jede Funktion | ein Aufruf |
| Beobachtung | passiv - die Bedingung wird gefragt | aktiv - ein Thread muss den Ausloeser bemerken |
| Aussenposten | wirkt sofort auf neue Basen | muss je neuer Basis nachgezogen werden |
| Fremde KIs | Weiche noetig | unberuehrt, weil je Manager |

**Die Umhuellung ist fuer dauerhafte Regeln richtig** (\"nie T1-Einheiten\"), weil sie
auch fuer spaeter entstehende Basen gilt.

**`SetBuilderPriority` ist fuer Ereignisse richtig** (\"ab jetzt keine T1-Kraftwerke
mehr\"), weil kein Wrapper noetig ist und der Zustand explizit ist.
