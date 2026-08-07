# KI-Stellschrauben - was steuert die LOUD-KI

Zurueck: [CustomAI.md](CustomAI.md) - [..\17_UNITLISTE.md](../17_UNITLISTE.md)

Referenz fuer die Arbeit an eigenen KIs. **Alles aus dem Quellcode gelesen, Stand
2026-08-07.** Was nicht belegt ist, ist als ungeprueft gekennzeichnet.

Der Einstieg in den Mod steht in [CustomAI.md](CustomAI.md) Abschnitt 4.

---

## Uebersicht: vier Ebenen

| Ebene | Was | Aufwand | Risiko |
|---|---|---|---|
| 1 | **Basisplan waehlen** (`Source`) | eine Zeile | keins |
| 2 | **Zahlen in `BaseSettings`** | wenige Zeilen | gering |
| 3 | **BuilderGroups zu-/abschalten** | Listenarbeit | Tippfehler meldet die Engine |
| 4 | **Einzelne Builder** - Prioritaeten, Bedingungen | hoch | KI kann verklemmen |

Empfohlene Reihenfolge: 2, dann 3, dann 1 bei Bedarf, 4 zuletzt.

---

## Ebene 1: die 14 Basisplaene

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBaseTemplates\
```

| Datei | Verwendung |
|---|---|
| `Loud_Main_Standard.lua` | Hauptbasis, grosse Karten ab 20k, hohe Einheitenlimits |
| `Loud_Main_Small.lua` | Hauptbasis, kleinere Karten |
| `Loud_Main_Smaller.lua` | Hauptbasis, sehr klein |
| `Loud_Naval_Large.lua` | Marinebasis gross |
| `Loud_Naval_Small.lua` | Marinebasis klein |
| `Loud_Naval_Tiny.lua` | Marinebasis sehr klein |
| `Loud_Naval_DP.lua` | Marine-Verteidigungspunkt |
| `Loud_Expansion_Standard.lua` | Aussenposten Standard |
| `Loud_Expansion_Small.lua` | Aussenposten klein |
| `Loud_Expansion_Tiny.lua` | Aussenposten sehr klein |
| `Loud_Expansion_Island.lua` | Aussenposten auf Inseln |
| `Loud_Expansion_DP.lua` | Aussenposten Verteidigungspunkt |
| `Loud_DP_Standard.lua` | Verteidigungspunkt |
| `Loud_DP_Small.lua` | Verteidigungspunkt klein |

**Nur die `Loud_Main_*` kommen als `Source` fuer eine eigene KI infrage** - die uebrigen
werden von der KI im Spielverlauf selbst gewaehlt, ueber ihre `ExpansionFunction`.

### Wie LOUD den Plan waehlt

`FirstBaseFunction` in `Loud_Main_Standard.lua`, Zeilen 159-220. Vier Kriterien:

| Kriterium | Quelle |
|---|---|
| Abstand zum Kartenrand | `aiBrain:GetArmyStartPos()`, `GetMapSize()` |
| Kartengroesse | `mapSizeX`, `mapSizeZ` |
| Wasseranteil | `aiBrain:GetMapWaterRatio()` |
| Einheitenlimit | `GetArmyUnitCap(aiBrain.ArmyIndex)` |

Rueckgabewerte: 10 (Notnagel), `Random(10,60)`, `Random(50,100)`, 100.
**Unsere Fabrik gibt 200 zurueck und gewinnt damit sicher** - siehe
[CustomAI.md](CustomAI.md) Abschnitt 4.

---

## Ebene 2: `BaseSettings` - die verstaendlichsten Hebel

Aus `Loud_Main_Standard.lua`:

```lua
BaseSettings = {

    -- Obergrenze der Ingenieure an dieser Basis.
    -- Wird mit dem Cheat-Multiplikator multipliziert und steigt bei
    -- Einheitenlimits ab 1000 zusaetzlich an - berechnet in
    -- BelowEngineerCapCheck.
    EngineerCount = {
        Tech1 = 7,
        Tech2 = 9,
        Tech3 = 8,
        SCU   = 12,
    },

    -- Obergrenze der Fabriken an dieser Basis
    FactoryCount = {
        LAND = 7,
        AIR  = 8,
        SEA  = 0,
        GATE = 1,
    },

    -- Wieviel Masse-Einkommen die KI je Fabrik haben will.
    -- Steuert, ab wann sie neue Fabriken und neue Basen anfaengt.
    MassToFactoryValues = {
        T1Value = 7.5,
        T2Value = 14,
        T3Value = 20,
    },

    -- Radius, in dem Sammelpunkte um die Basis erzeugt werden
    RallyPointRadius = 42,
}
```

### Wirkung

| Feld | Erhoehen bewirkt | Senken bewirkt |
|---|---|---|
| `EngineerCount.*` | mehr Bautempo, mehr Massverbrauch | schlankere Wirtschaft |
| `FactoryCount.LAND` | Landmacht | |
| `FactoryCount.AIR` | Luftmacht | |
| `FactoryCount.SEA` | auf `0` bei Landkarten - Standard | |
| `MassToFactoryValues.*` | vorsichtigere Expansion | schnellere Expansion, mehr Risiko |
| `RallyPointRadius` | weiter verteilte Sammelpunkte | kompaktere Basis |

**`SEA = 0` im Standardplan** - Marinefabriken entstehen ueber die
`Engineer Construction - Naval Base`-Gruppe und eigene Marinebasen, nicht hier.

`MassToFactoryValues` ist der wirksamste Einzelhebel fuer den Spielstil: kleine Werte
ergeben eine expansive KI, grosse eine, die erst ihre Wirtschaft ausbaut.

---

## Ebene 3: die 64 BuilderGroups des Standardplans

Vollstaendige Liste aus `Loud_Main_Standard.lua`, thematisch geordnet.

### ACU (2)
`ACU Tasks - Start Game` - `ACU Tasks`

### Fabrikbau (2)
`Engineer Factory Construction` - `Engineer Quantum Gate Construction`

### Ingenieurarbeit (3)
`Engineer Tasks` - `Engineer Tasks - Reclaim Old Structures` - `Engineer Transfers`

`Engineer Transfers` schickt Ingenieure von der Hauptbasis zu den Aussenposten.

### Wirtschaft (9)
`Engineer Energy Builders` - `Engineer Mass Builders` -
`Engineer T4 Economy Construction` - `Engineer Eng Station Construction` -
`Engineer Mass Energy Construction` - `Engineer Mass Storage Construction` -
`Engineer Energy Storage Construction` - `Engineer T4 Economy Defense Construction` -
`Engineer T4 Economy Defense Construction - LOUD IS`

### Expansion (4)
`Engineer Construction - Land Base` - `Engineer Construction - Land DP` -
`Engineer Construction - Naval Base` - `Engineer Construction - Naval DP`

### Verteidigung (8)
`Engineer Base Defense Construction - Core` - `- Perimeter` - `- Picket Line` -
`Engineer Mass Point Defense Construction` - `Engineer Misc Construction` -
`Engineer Shield Construction` - `Engineer Shield Construction - LOUD_IS` -
`Engineer T4 Shield Construction` - `Engineer Perimeter Shield Augmentation`

### Angriffswaffen (4)
`Engineer Artillery Construction T3` - `Engineer Artillery Construction T4` -
`Engineer Nuke Construction` - `Engineer Optics Construction`

### Experimentaleinheiten (3)
`Engineer T4 Construction Land` - `Engineer T4 Construction Air - Land Map` -
`Engineer T4 Construction Air - Water Map`

### Fabrikproduktion (9)
`Factory Production - Engineers` - `Factory Production Land` -
`Factory Production Land - Land Only Map` - `Factory Production Land - Water Map` -
`Factory Production Air - Scouts` - `- Fighters` - `- Bombers` - `- Gunships` -
`- Transports` - `- Torpedo Bombers`

### Verbandsbildung Land (9)
`Land Formations - Scouts` - `- Point Guards` - `- Base Guards` - `- Reinforcement` -
`- Artillery` - `- Nukes` - `- Experimentals` - `- Land Only Map` - `- Amphibious` -
`- Water Map`

### Verbandsbildung Luft (6)
`Air Formations - Scouts` - `- Bombers` - `- Fighters` - `- Gunships` -
`- Experimentals` - `- Water Map`

### ACU-Ausbau (2)
`ACU Upgrades LOUD` - `BO ACU Upgrades LOUD`

`BO ACU Upgrades LOUD` betrifft die BlackOps-Kommandanten.

### Es gibt mehr als diese 64

Die Builder-Dateien definieren weitere Gruppen, die im Standardplan nicht verwendet
werden - etwa `Engineer Base Defense Construction - Naval`,
`- Core - Expansions`, `Engineer Misc Construction - Small`,
`Engineer Defenses DP Standard`. Allein
`Loud_AI_Engineer_Defense_Builders.lua` definiert **21 Gruppen**.

Die vollstaendige Auswahl steht in:

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBuilders\
```

| Datei | Inhalt |
|---|---|
| `Loud_AI_ACU_Builders.lua` | ACU-Verhalten und Ausbau |
| `Loud_AI_Engineer_Artillery_Builders.lua` | Artillerie |
| `Loud_AI_Engineer_Defense_Builders.lua` | Verteidigung, Schilde |
| `Loud_AI_Engineer_Energy_Builders.lua` | Energie |
| `Loud_AI_Engineer_Expansion_Builders.lua` | Aussenposten |
| `Loud_AI_Engineer_Experimental_Builders.lua` | Experimentaleinheiten |
| `Loud_AI_Engineer_Factory_Builders.lua` | Fabriken |
| `Loud_AI_Engineer_Intel_Builders.lua` | Radar, Optik |
| `Loud_AI_Engineer_Mass_Builders.lua` | Masse |
| `Loud_AI_Engineer_Task_Builders.lua` | Reparieren, Recyceln, Assistieren |
| `Loud_AI_Factory_Air_Builders.lua` | Luftproduktion |
| `Loud_AI_Factory_Engineer_Builders.lua` | Ingenieurproduktion |
| `Loud_AI_Factory_Land_Builders.lua` | Landproduktion |
| `Loud_AI_Factory_Naval_Builders.lua` | Marineproduktion |
| `Loud_AI_Formations_Air.lua` | Luftverbaende |
| `Loud_AI_Formations_Land.lua` | Landverbaende |
| `Loud_AI_Formations_Naval.lua` | Marineverbaende |
| `Loud_MAIN_base_templates.lua` | Gebaeudeanordnung Hauptbasis |
| `Loud_Expansion_Base_Templates.lua` | Gebaeudeanordnung Aussenposten |
| `Loud_Perimeter_Defense_Templates.lua` | Anordnung der Perimeterverteidigung |
| `Loud_DP_Templates.lua` | Anordnung Verteidigungspunkte |

**Ein Gruppenname, den es nicht gibt, meldet die Engine beim Registrieren:**
`Invalid BuilderGroup named - <name>`. Das ist die billigste Kontrolle beim Umbau
einer Bauliste.

---

## Ebene 4: der einzelne Builder

Beispiel aus `Loud_AI_Engineer_Defense_Builders.lua` Zeile 138, gekuerzt:

```lua
Builder {BuilderName = 'T1 Base Defense - PD',

    PlatoonTemplate = 'EngineerBuilder',
    InstanceCount   = 1,
    Priority        = 750,

    PriorityFunction = function(builder, aiBrain, unit, manager)
        if not BaseInPlayableArea( aiBrain, manager.LocationType ) then
            return 0, false
        end
        if aiBrain.CycleTime > 1500 then          -- nach 25 Minuten einstellen
            return 0, false
        end
        if not GreaterThanEnergyIncome( aiBrain, 550 ) then
            return 10, true                        -- fast abschalten
        end
        if aiBrain.LandRatio < 1 and aiBrain.LandRatio > .011 and aiBrain.CycleTime > 360 then
            return (builder.OldPriority or builder.Priority) + 50, true
        end
        local threat = GetThreatAtPosition( aiBrain, GetPosition(unit), ... , 'AntiSurface' )
        if threat > 125 then
            return (builder.OldPriority or builder.Priority) + 100, true
        elseif threat < 25 then
            return (builder.OldPriority or builder.Priority) - 50, true
        end
        return (builder.OldPriority or builder.Priority)
    end,

    BuilderConditions = {
        { EBC,  'GreaterThanEconStorageCurrent', { 300, 3600 }},
        { EBC,  'GreaterThanEnergyTrend', { 15 }},
        { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 18, PD, 30, 50}},
    },

    BuilderType = { 'T1' },

    BuilderData = {
        Construction = {
            Radius                   = 36,
            NearBasePerimeterPoints  = true,
            ThreatMax                = 50,
            BasePerimeterOrientation = 'FRONT',
            BasePerimeterSelection   = true,
            BaseTemplateFile         = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
            BaseTemplate             = 'PerimeterDefenseTemplates',
        },
    },
}
```

### Die Felder

| Feld | Bedeutung |
|---|---|
| `Priority` | Grundprioritaet. Hoeher = wird eher ausgefuehrt. |
| `PriorityFunction` | passt die Prioritaet zur Laufzeit an. Rueckgabe `(wert, aktiv)`. `0, false` schaltet den Builder ab. |
| `BuilderConditions` | Vorbedingungen. Alle muessen erfuellt sein. |
| `BuilderType` | fuer welche Techstufe der Bauer gilt |
| `InstanceCount` | wieviele Trupps gleichzeitig daran arbeiten |
| `BuilderData.Construction` | wo und wie gebaut wird |

`BasePerimeterSelection = true` laesst die KI **eine** zufaellige Position aus den
verfuegbaren waehlen statt alle auf einmal zu bebauen - das bremst teure Bauten.
Ausnahme laut Quellkommentar: Schilde werden bei erfuellten Bedingungen an allen
Positionen gebaut.

---

## Die Bedingungsbibliotheken

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\editor\
```

| Kuerzel | Datei | Thema |
|---|---|---|
| `EBC` | `EconomyBuildConditions.lua` | Wirtschaft, Masse, Energie, Bauplaetze |
| `UCBC` | `UnitCountBuildConditions.lua` | Einheitenzahlen nach Kategorie und Ort |
| `TBC` | `ThreatBuildConditions.lua` | Bedrohungslage |
| `MIBC` | `MiscBuildConditions.lua` | Sonstiges, u. a. `BaseInPlayableArea` |
| `LUTL` | `..\loudutilities.lua` | LOUD-eigene Hilfsfunktionen |

### Wirtschaftsbedingungen (`EBC`) - alle 27

**Vorraete und Lager**
`GreaterThanEconStorageCurrent(mStorage, eStorage)` -
`LessThanEconEnergyStorageCurrent(eStorage)` - `LessThanEconEnergyStorageRatio` -
`GreaterThanEconEnergyStorageCurrent` - `GreaterThanEconEnergyStorageRatio` -
`LessThanEconMassStorageCurrent` - `LessThanEconMassStorageRatio` -
`GreaterThanEconMassStorageRatio`

**Trends und Einkommen**
`LessThanEnergyTrend` - `LessThanEnergyTrendOverTime` - `GreaterThanEnergyTrend` -
`GreaterThanEnergyTrendOverTime` - `GreaterThanEnergyIncome` - `LessThanMassTrend` -
`LessThanMassTrendOverTime` - `GreaterThanMassTrend` - `GreaterThanMassIncome`

**Effizienz**
`GreaterThanEconEfficiency` - `LessThanEconEfficiency` -
`GreaterThanEconEfficiencyOverTime` - `LessThanEconEfficiencyOverTime` -
`GreaterThanEconTrendEfficiencyOverTime`

**Bauplaetze und Bedrohung**
`CanBuildOnMassAtRange` - `CanBuildOnHydroLessThanDistance` -
`ReclaimablesInAreaMass` - `ThreatCloserThan` - `MassToFactoryRatioBaseCheck`

Der Unterschied `...OverTime` gegen die Sofortvariante: die eine mittelt ueber einen
Zeitraum, die andere nimmt den Momentanwert. Fuer stabile Entscheidungen ist die
gemittelte Variante die richtige.

---

## Was die KI zur Laufzeit ueber sich weiss

Diese Werte an `aiBrain` treiben die `PriorityFunction`s. Haeufigkeit gezaehlt ueber
`loudutilities.lua`, `aibrain.lua` und die Builder-Dateien.

| Wert | Vorkommen | Bedeutung |
|---|---:|---|
| `LandRatio` | 85 | eigene Landstaerke gegen die des Gegners |
| `AirRatio` | 40 | dasselbe fuer die Luft |
| `NavalRatio` | 20 | dasselbe fuer die See |
| `CycleTime` | 40 | verstrichene Spielzeit in KI-Zyklen |
| `BuilderManagers` | 79 | die Manager je Basis |
| `IL` | 17 | Intel-Liste - `HiPri`, `LowPri`, `MustScout` |
| `AirBias` | 9 | Verhaeltnis Boden- zu Luftbedrohung |
| `EcoData` | 11 | Wirtschaftsverlauf |
| `AttackPlan` | 8 | aktueller Angriffsplan |
| `PrimaryLandAttackBase` | 19 | von wo aus angegriffen wird |
| `PrimarySeaAttackBase` | 18 | dasselbe zur See |
| `CheatValue` | | Cheat-Multiplikator, z. B. 1.1 = 10 Prozent |
| `Adaptive` | 5 | 1 fest, 2 Rueckkopplung, 3 Zeit, 4 beides |
| `MassPointShare` | 4 | Massepunkte je Spieler |
| `TeamSize` | 5 | Groesse des Teams |

### Die Ratio-Werte im Detail

Berechnet in `loudutilities.lua` um Zeile 5465:

```lua
aiBrain.AirBias  = LOUDMIN( 2, LOUDMAX( 0.02, (totalThreatSurface/totalThreatAir) ) )
aiBrain.AirRatio = LOUDMAX( LOUDMIN( (totalThreat / oldthreat), 10 ), 0.011)
aiBrain.AirRatio = aiBrain.AirRatio * OutnumberedFactor
```

Wertebereich **0.011 bis 10**. Kleiner als 1 heisst unterlegen, groesser als 1 ueberlegen.
Die Grenzwerte 0.011 und 10 sind Sonderfaelle - `.011` steht fuer "praktisch nichts
vorhanden". Deshalb prueft der Originalcode oft auf `> .011`, um diesen Fall
auszuschliessen:

```lua
if aiBrain.LandRatio < 1 and aiBrain.LandRatio > .011 then ... end
```

`CycleTime` in den gesehenen Vergleichen: `> 360` und `> 1500`. Der Quellkommentar nennt
1500 "nach 25 Minuten" - also **1 Zyklus = 1 Sekunde**. Ungeprueft, aber konsistent.

---

## Was hier NICHT steht

- **Platoon-Templates** (`gamedata.entpackt\lua\lua\AI\PlatoonTemplates\`) - welche
  Einheiten einen Verband bilden. Noch nicht gelesen.
- **Die Manager** - `EngineerManager`, `FactoryManager`, `PlatoonFormManager`.
  Sie fuehren die Builder aus; ihre Arbeitsweise ist noch nicht untersucht.
- **`AttackPlan`** - wie die KI Angriffsziele waehlt.
- **Gebaeudeanordnung** - `Loud_MAIN_base_templates.lua` und Geschwister bestimmen, wo
  welches Gebaeude relativ zur Basis steht.

Steht in `..\TODO.md`.
