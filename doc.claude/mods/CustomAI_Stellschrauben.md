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

## Ebene 3: die BuilderGroups des Standardplans

### KORREKTUR 2026-08-08: es sind sieben Listen, nicht eine

Die thematische Liste unten fasst alle BuilderGroups zusammen, die im Standardplan
vorkommen. **Sie stehen aber nicht alle in `template.Builders`.** Ein Basistemplate hat
sieben getrennte Listen - belegt in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBaseTemplates\Loud_Main_Standard.lua`
Z. 71-110 und ausgewertet in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\aiaddbuildertable.lua`:

| Feld | wird geladen wenn |
|---|---|
| `Builders` | immer |
| `WaterMapBuilders` | die Karte hat einen Marker `Naval Area` oder `Naval Defensive Point` |
| `LandOnlyBuilders` | sonst - in allen `Loud_Main_*` **leer** |
| `StandardCommanderUpgrades` | nur an `MAIN` und nur ohne BlackOps-ACU |
| `BOACUCommanderUpgrades` | nur an `MAIN` und nur mit `ScenarioInfo.BOACU_Installed` |
| `LOUD_IS_Installed_Builders` | `ScenarioInfo.LOUD_IS_Installed` |
| `LOUD_IS_Not_Installed_Builders` | sonst |

**Folge fuer `Apply()`:** Naval Base, Torpedobomber, Amphibisch, alle Schild-Builder,
die Storage-Builder und die ACU-Ausbaugruppen sind ueber `template.Builders`
**nicht erreichbar**. Wer sie aendern will, muss die passende der sieben Listen anfassen.

**Zweite Folge:** `GlobalBaseTemplate.lua` prueft beim Registrieren nur `Builders` auf
gueltige Gruppennamen (Z. 33-37). Ein Tippfehler in `WaterMapBuilders` wird **nicht**
gemeldet - die Gruppe fehlt dann still.

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

`CycleTime` in den gesehenen Vergleichen: `> 360` und `> 1500`.
**Belegt** in `BrainConditionsMonitor.lua` Zeile 111: `aiBrain.CycleTime =
GetGameTimeSeconds()` - es ist die **Spielzeit in Sekunden**. `> 1500` sind also exakt
25 Minuten.

---

## Ebene 3b: Platoon-Templates - woraus ein Verband besteht

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\PlatoonTemplates\
```

| Datei | Inhalt |
|---|---|
| `Loud_AI_Formation_Platoons.lua` | Kampfverbaende Luft, Land, See - 925 Zeilen |
| `Loud_AI_Factory_Platoons.lua` | was Fabriken produzieren |
| `Loud_AI_Engineer_Platoons.lua` | Ingenieurtrupps |
| `StructurePlatoonTemplates.lua` | Gebaeude als Verband |

Die Builder verweisen ueber `PlatoonTemplate = '<Name>'` darauf. Der Kommentar in
`Loud_AI_Formation_Platoons.lua` Zeile 3 sagt es direkt: *determines the composition of
platoons built by the Platoon Manager*.

### Aufbau

```lua
PlatoonTemplate { Name = 'FighterAttack',
    GlobalSquads = {
        { AIRFIGHTER - categories.EXPERIMENTAL, 18, 36, 'Unassigned', 'AttackFormation' },
    }
}
```

Die fuenf Werte je Eintrag:

| Position | Bedeutung |
|---|---|
| 1 | Kategorie-Ausdruck - welche Einheiten infrage kommen |
| 2 | **Mindestzahl** - darunter bildet sich kein Verband |
| 3 | **Hoechstzahl** |
| 4 | Rolle: `Unassigned`, `Attack`, `Support`, `Guard`, `Scout` |
| 5 | Formation: `AttackFormation`, `GrowthFormation`, `none` |

Optional `Plan = 'ReinforceAirAI'` - welches Verhaltensskript der Verband ausfuehrt.

Mehrere Zeilen in `GlobalSquads` ergeben einen gemischten Verband:

```lua
PlatoonTemplate { Name = 'FighterReinforce',
    Plan = 'ReinforceAirAI',
    GlobalSquads = {
        { AIRFIGHTER, 3, 45, 'Attack', 'none' },
        { AIRSCOUT,   0, 4,  'Support', 'none' },
    }
}
```

Mindestzahl `0` beim Aufklaerer heisst: mitnehmen wenn vorhanden, aber nicht darauf
warten.

### Groessenstufen

LOUD staffelt viele Verbaende: `FighterAttack Small` (2-12), `FighterAttack` (18-36),
`FighterAttack Large` (24-48), bei Bombern zusaetzlich `Super` (36-60). Welche Stufe
verwendet wird, entscheidet der jeweilige Builder in
`Loud_AI_Formations_Air.lua` und Geschwistern.

**Das ist ein wirksamer Hebel:** eine KI, die kleinere Verbaende frueher losschickt,
spielt aggressiver; eine mit groesseren sammelt laenger.

---

## Ebene 3c: Gebaeudeanordnung

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBuilders\Loud_MAIN_base_templates.lua
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBuilders\Loud_Expansion_Base_Templates.lua
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBuilders\Loud_Perimeter_Defense_Templates.lua
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBuilders\Loud_DP_Templates.lua
```

Bestimmen, **wo** ein Gebaeude relativ zur Basis steht. Angesprochen werden sie aus
`BuilderData.Construction`:

```lua
BuilderData = {
    Construction = {
        BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
        BaseTemplate     = 'PerimeterDefenseTemplates',
        Radius                   = 36,
        NearBasePerimeterPoints  = true,
        BasePerimeterOrientation = 'FRONT',
        BasePerimeterSelection   = true,
        ThreatMax                = 50,
    },
}
```

| Feld | Bedeutung |
|---|---|
| `BaseTemplateFile` / `BaseTemplate` | welche Anordnungsvorlage gilt |
| `Radius` | Umkreis um den Bezugspunkt |
| `NearBasePerimeterPoints` | am Rand der Basis statt im Kern |
| `BasePerimeterOrientation` | `FRONT`, `BACK`, `LEFT`, `RIGHT` - Ausrichtung zum Gegner |
| `BasePerimeterSelection` | **eine** zufaellige Position statt aller auf einmal |
| `ThreatMax` | oberhalb dieser Bedrohung wird dort nicht gebaut |

`BasePerimeterSelection = true` ist LOUDs Bremse gegen Verschwendung - laut Quellkommentar
gilt sie fuer alles ausser Schilden, die bei erfuellten Bedingungen an allen Positionen
entstehen.

---

## Ebene 4b: Manager und Angriffsplanung

### Der Einstieg

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\aiarchetype-managerloader.lua
```

Zeile 1-2, Originalkommentar: *This is essentially the entry point for any AI - and it is
initiated in the OnCreateAI function*.

`ExecutePlan(aiBrain)` waehlt ueber `GetBestBasePlan` den Basisplan, meldet ihn mit
`AddGlobalBaseTemplate(aiBrain, 'MAIN', base)` an und startet die Manager.

### `aiBrain.BuilderManagers`

Angelegt in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\aibrain.lua`
Zeile 843 und 856:

```lua
self.BuilderManagers = {}
self.BuilderManagers['MAIN'] = { Position = self:GetStartVector3f() }
```

**Ein Eintrag je Basis**, benannt nach ihrem `LocationType` - `MAIN` fuer die Hauptbasis,
weitere fuer Aussenposten. In den `PriorityFunction`s taucht der Manager als Parameter
auf; `manager.LocationType` ist der Basisname. Mit 79 Vorkommen die meistgenutzte
Struktur ueberhaupt.

**Die Manager selbst sind noch nicht untersucht** - wie sie Builder auswaehlen und
ausfuehren, ist offen.

### `aiBrain.AttackPlan`

Verwaltet in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\loudutilities.lua`
ab Zeile 1368.

| Feld | Bedeutung |
|---|---|
| `AttackPlan.Pending` | Planung laeuft - andere Threads warten darauf |
| `AttackPlan.Goal` | Zielposition |
| `AttackPlan.Method` | `"Land"` oder See |

Aus dem Ziel und den vorhandenen Basen bestimmt die KI ihre **Angriffsbasis**:
`aiBrain.PrimaryLandAttackBase` und `PrimarySeaAttackBase`, jeweils mit
`Last...`-Vorgaenger. Die Wegfindung dorthin laeuft ueber
`PlatoonGenerateSafePathToLOUD(..., 'Amphibious', v.Position, goal, 10000, 250)`.

Eine Basis kann dabei den Modus wechseln - im Log als
`AttackPlan <basis> PRIMARY - switching Land mode to <modus>`.

**Nicht untersucht:** wie das Ziel selbst gewaehlt wird.

### Die Einheitenlimit-Bremse

`UnitCapWatchThread` in `aiarchetype-managerloader.lua` Zeile 121 - fuer das Verstaendnis
spaeten Spielverhaltens wichtig:

- startet **50 Minuten** nach Spielbeginn (`WaitSeconds(3000)`)
- prueft alle **3 Minuten**
- wenn `GetArmyUnitCostTotal > 600`: **die KI toetet eigene Einheiten**, reihum je 40
  T1-Land, 40 T1-Luft, dann alle T1-Punktverteidigungen

Das ist Absicht - alte T1-Einheiten blockieren sonst das Einheitenlimit. Wer sich wundert,
warum die KI im Spaetspiel eigene Einheiten sprengt: hier steht es.

---

## Debug-Schalter - 31 Stueck

Der wertvollste Fund fuer die Arbeit an eigenen KIs. Alle Schalter stehen in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\aibrain.lua`
ab Zeile 7 und sind **standardmaessig `false`**.

| Bereich | Schalter |
|---|---|
| Ingenieure | `NameEngineers`, `EngineerDialog`, `DisplayFactoryBuilds` |
| Ausbau | `ACUEnhanceDialog`, `SCUEnhanceDialog`, `FactoryEnhanceDialog`, `StructureUpgradeDialog` |
| Basen | `DisplayBaseNames`, `BaseMonitorDialog`, `DisplayBaseMonitors`, `BaseDistressResponseDialog`, `DeadBaseMonitorDialog`, `DisplayPingAlerts` |
| Angriff | `DisplayAttackPlans`, `AttackPlanDialog`, `ReportRatios` |
| Aufklaerung | `IntelDialog`, `DisplayIntelPoints` |
| Verbaende | `PlatoonDialog`, `DisplayPlatoonMembership`, `DisplayPlatoonPlans`, `DistressResponseDialog`, `PlatoonMergeDialog` |
| Transport | `TransportDialog`, `DisplayTransportPaths`, `PathFindingDialog` |
| Streitkraefte | `AirForceDialog`, `AmphibForceDialog`, `LandForceDialog`, `NavalForceDialog`, `NavalBombardDialog`, `GuardPointDialog` |
| Sonstiges | `NukeDialog`, `ShieldDialog`, `PriorityDialog`, `InstanceDialog`, `BuffDialog`, `UnitDialog`, `WeaponDialog` |

### Zwei Wege, sie einzuschalten

**Dauerhaft** - im Mod, per Hook auf `aibrain.lua`:

```lua
ScenarioInfo.AttackPlanDialog = true
ScenarioInfo.ReportRatios     = true
```

**Zur Laufzeit** - `SetAIDebug(data)` in `aibrain.lua` Zeile 291, laut Kommentar
*this function will bring debug switch settings into the SIM from the UI*. Sie prueft
gegen eine Liste erlaubter Namen und lehnt alles andere ab:
`SETAIDEBUG: Illegal Var passed, returning`.

**`ReportRatios` und `AttackPlanDialog` sind die beiden nuetzlichsten** - sie zeigen die
Ratio-Werte und die Angriffsplanung, also genau die Groessen, an denen die
`PriorityFunction`s haengen.

⚠️ Alle 31 Schalter erzeugen Logausgaben in einer Schleife. `LOUD.log` waechst dann
schnell - vor einem laengeren Spiel wieder abschalten.

---

## Ebene 4c: Wie die Manager auswaehlen - der Kern

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\BuilderManager.lua
```

`GetHighestBuilder(unit, aiBrain)` ab Zeile 199 - hier entscheidet sich, **was ein
Ingenieur oder eine Fabrik als naechstes tut**. Der Ablauf je Aufruf:

### 1. Sortieren

```lua
LOUDSORT( self.BuilderData[BuilderType].Builders, function(a,b) return a.Priority > b.Priority end )
```

Absteigend nach `Priority`. Nur bei gesetztem `NeedSort` - also nach Prioritaetsaenderungen.

### 2. `PriorityFunction` auswerten

```lua
newPri, temporary = Builders[TaskName]:PriorityFunction( aiBrain, unit, self )
```

Liefert sie einen anderen Wert, wird er gesetzt und eine Neusortierung vorgemerkt.
`temporary = true` merkt sich den alten Wert in `OldPriority`, sodass
`ResetPriority` ihn spaeter wiederherstellen kann.

### 3. Die entscheidende Schwelle

```lua
if Priority > 100 and (task.InstanceAvailable > 0 or ManagerType == 'FBM') and continuesearching then
```

**Prioritaet 100 oder darunter wird nie ausgefuehrt.** Das erklaert die Rueckgabewerte in
den `PriorityFunction`s des Originalcodes:

| Rueckgabe | Wirkung |
|---|---|
| `0, false` | Aufgabe wird **entfernt** - dauerhaft, sofern kein `OldPriority` gesetzt ist |
| `10, true` | faktisch abgeschaltet, aber die Aufgabe bleibt in der Liste |
| `> 100` | kommt in die Auswahl |

`return 10, true` im Originalcode ist also kein "niedrige Prioritaet", sondern
**"vorlaeufig aus"**.

### 4. Nur das oberste Prioritaetsband konkurriert

```lua
elseif found and Priority < found then
    continuesearching = false
end
```

Sobald eine niedrigere Prioritaet als die bereits gefundene erreicht wird, bricht die
Suche ab. **Nur Aufgaben mit dem hoechsten Wert kommen infrage** - der Rest wird gar
nicht mehr geprueft.

### 5. Bedingungen und Zufall

```lua
if GetBuilderStatus( task.BuilderConditions ) then
    if BuilderParamCheck(self, task, unit) then
        found = Priority
        counter = counter + 1
        possibleBuilders[counter] = k
    end
end
...
if counter > 0 then
    return TaskList[ possibleBuilders[ Random(1, counter) ] ]
end
```

Alle Aufgaben gleicher Hoechstprioritaet, deren `BuilderConditions` erfuellt sind,
landen in einer Liste - **eine davon wird zufaellig gewaehlt**.

**Das ist der wichtigste Hebel ueberhaupt:** Wer zwei Aufgaben dieselbe Prioritaet gibt,
erzeugt eine 50:50-Entscheidung. Wer eine um 1 hoeher setzt, macht sie ausschliesslich.

### Zusammenfassung der Auswahl

```
sortieren (absteigend)
  -> PriorityFunction je Aufgabe
    -> nur Priority > 100
      -> nur InstanceAvailable > 0   (ausser FactoryBuilderManager)
        -> nur das hoechste Prioritaetsband
          -> nur mit erfuellten BuilderConditions
            -> davon eine zufaellig
```

---

## `InstanceCount` - wieviele gleichzeitig

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\Builder.lua
```

Zeilen 231-241:

```lua
builder.InstanceCount = {}
builder.InstanceAvailable = 0

while num <= ( data.InstanceCount or 1 ) do
    builder.InstanceCount[num] = false
    builder.InstanceAvailable = builder.InstanceAvailable + 1
    num = num + 1
end
```

**Vorgabe ist 1.** Jede Instanz ist ein Platz; laeuft eine Aufgabe, sinkt
`InstanceAvailable`. Bei 0 wird die Aufgabe uebersprungen - siehe Schritt 3 oben.

**Ausnahme `ManagerType == 'FBM'`** - der FactoryBuilderManager ignoriert die
Instanzgrenze. Fabriken duerfen dieselbe Aufgabe beliebig oft ausfuehren.

`InstanceCount = 3` bei einem Verteidigungsbauer heisst also: bis zu drei Ingenieurtrupps
koennen gleichzeitig daran arbeiten.

## `BuilderType` - wer darf die Aufgabe

`BuilderData` ist nach `BuilderType` gegliedert:

```lua
aiBrain.BuilderManagers[factory.LocationType]['FactoryManager']['BuilderData'][factory.BuilderType]
```

Die Aufgabenliste ist also **je Bauertyp getrennt**. Ein Ingenieur mit `BuilderType`
`'T1'` sieht nur Aufgaben mit `BuilderType = { 'T1' }`. Vorgabe beim Anlegen ist `'Any'`
(`BuilderManager.lua` Zeile 95).

---

## Die drei Manager

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\BuilderManager.lua
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\EngineerManager.lua
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\FactoryBuilderManager.lua
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\PlatoonFormManager.lua
```

`BuilderManager.lua` ist die gemeinsame Basisklasse mit `GetHighestBuilder`,
`SetBuilderPriority`, `AddBuilder`, `SortBuilderList`. Die drei anderen erben davon.

Im Log erscheinen sie als `ManagerType` - `FBM` fuer den FactoryBuilderManager.

**Noch nicht im Einzelnen gelesen:** die drei abgeleiteten Klassen.

---

## Angriffsplanung - Zielauswahl

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\loudutilities.lua
```

### Gegnerwahl - ab Zeile 6270

Ein neuer Gegner wird gesucht, wenn einer dieser Faelle eintritt:

- es gibt noch keinen
- der aktuelle erzeugt keine Bedrohung mehr
- der aktuelle ist besiegt
- **seine `Strength` faellt unter 35**

Die Auswahl selbst ist denkbar einfach:

```lua
if not enemy or v.TotalStrength > enemyStrength then
    enemyPosition = v.Position
    enemyStrength = v.TotalStrength
    enemy = ArmyBrains[v.Brain]
end
```

**Die KI greift immer den staerksten Gegner an**, nicht den schwaechsten oder naechsten.
Verbuendete werden uebersprungen (`if not v.Enemy then continue end`).

Die Zielposition ist der **gemittelte Schwerpunkt** aller gegnerischen Einheiten, nicht
ihre Basis:

```lua
x1 = LOUDFLOOR(x1/counter)
x3 = LOUDFLOOR(x3/counter)
newPosition = { x1, 0, x3 }
```

### Neuplanung - Zeile 6377

```lua
if self.CurrentEnemyIndex and ( (not self.AttackPlanGoal) or VDist3(self.AttackPlan.Goal, newPosition) > 100 ) then
    self:ForkThread( CreateAttackPlan, newPosition)
end
```

**Erst ab 100 Karteneinheiten Abweichung** wird neu geplant. Kleinere Verschiebungen des
gegnerischen Schwerpunkts loesen nichts aus - das haelt die KI ruhig.

### `CreateAttackPlan` - ab Zeile 6416

Baut aus Wegpunkten eine Kette von Etappen zwischen eigener und gegnerischer Basis:

```lua
local stagesize    = 300 + (ScenarioInfo.IMAPSize/4)
local minstagesize = (stagesize * .45) * (stagesize * .45)
local maxstagesize = (stagesize + 10) * (stagesize + 10)
```

Die Etappengroesse haengt an der Kartengroesse (`IMAPSize`). Wegfindung ueber
`PlatoonGenerateSafePathToLOUD` in den Ebenen `Land`, `Amphibious` und `Water`.

Bei gesetztem `DeliverStatus` kuendigt die KI den Plan im Verbuendetenchat an.

---

## `SkirmishStrategyList` - totes Erbe

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\SkirmishStrategyList.lua
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\Strategy-Test.lua
```

Die Liste enthaelt genau einen Eintrag: `Strategy-Test.lua`, im Original bezeichnet als
*N00b Strategy - Easily Beaten AI*. Der Quellkommentar sagt selbst:

> *This needs to be fleshed out to do something useful ... Again, a work in (very early)
> progress*

`ExecuteFunction` gibt schlicht `true` zurueck, `EvaluateFunction` liest eine globale
Variable `Priority`, die es gar nicht gibt.

**Fuer eigene KIs uninteressant.** Ein unfertiges GPG-Rudiment, das LOUD nicht nutzt -
die Steuerung laeuft vollstaendig ueber Basistemplates und Builder.

---

## Die zweite Pruefstufe: `BuilderParamCheck`

Jeder Manager bringt eine eigene Version mit. Sie laeuft **nach** den
`BuilderConditions` und prueft, ob die konkrete Einheit die Aufgabe uebernehmen kann.

### EngineerManager

```lua
-- EngineerManager.lua
BuilderParamCheck = function( self, builder, unit )
    if not unit.Dead and builder.InstanceAvailable > 0 then
        return true
    end
    return false
end,
```

Lebt die Einheit noch, und ist ein Instanzplatz frei?

### FactoryBuilderManager

```lua
-- FactoryBuilderManager.lua
BuilderParamCheck = function( self, builder, factory )
    if factory.Upgrading then
        return false
    end
    return true
end,
```

**Eine aufruestende Fabrik bekommt keine Auftraege** - sonst nichts. Das erklaert die
Ausnahme `ManagerType == 'FBM'` in `GetHighestBuilder`: Instanzgrenzen gelten hier nicht.

### PlatoonFormManager

Hat **keine** eigene `BuilderParamCheck`. Er arbeitet anders - siehe unten.

---

## Die drei Manager im Einzelnen

### EngineerManager - 1961 Zeilen

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\EngineerManager.lua
```

Enthaelt neben der Bauauftragsvergabe das **Basis-Alarmsystem**
(`BaseMonitorSetup`). Die Kennzahlen stehen dort fest verdrahtet:

```lua
self.BaseMonitor = {
    BaseMonitorInterval = 6,     -- Bedrohungspruefung alle 6 Sekunden
    AlertLevel          = 2,     -- ab dieser Bedrohung gilt Alarm
    AlertTimeout        = 12,    -- Alarm verfaellt nach 12 Sekunden
    AlertResponseTime   = 11,    -- Wartezeit bis zur naechsten Verstaerkung
    AlertRange = math.min( math.floor(self.Radius * 1.2), 150 ),
    ActiveAlerts = 0,
    AlertsTable  = {},
}
```

`AlertRange` liegt damit **zwischen 108 und 150** - abhaengig vom Basisradius, aber
gedeckelt. Der Quellkommentar zum Thread: die Pruefung laeuft im Ruhezustand alle 8
Sekunden, und **je Minute ohne Bedrohung waechst der Abstand um 1 Sekunde**, bis zu 20
Sekunden zusaetzlich. Eine ruhige Basis prueft also seltener.

Dieses System entscheidet, wann eine Basis Verstaerkung anfordert - `NoBaseAlert` und
`BaseInLandMode` aus `loudutilities.lua` fragen es ab.

### FactoryBuilderManager - 894 Zeilen

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\FactoryBuilderManager.lua
```

Besonderheit `SetRallyPoint`: LOUD verlaesst sich **nicht** auf gesetzte
Rally-Point-Marker der Karte.

```lua
rally = AIGetClosestMarkerLocation( self, rallyType, position[1], position[3] )

if not rally or VDist3( rally, position ) > 100 then
    position = RandomLocation(position[1],position[3])
    rally = position
end
```

Ist kein Marker vorhanden oder weiter als 100 entfernt, **erzeugt die KI sich selbst
einen**. Marinefabriken bekommen `'Naval Rally Point'`. Anschliessend laeuft ein
`TrafficControlThread` - LOUDs Stauvermeidung vor Fabriken.

### PlatoonFormManager - 248 Zeilen

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\PlatoonFormManager.lua
```

Der kleinste der drei. Kern ist `ManagerLoopBody`:

```lua
local template = self.GetPlatoonTemplate( self, Builder.PlatoonTemplate, aiBrain )

if template and CanFormPlatoon( aiBrain.ArmyPool, template, 1, Location, Radius) then
    local hndl = FormPlatoon( aiBrain.ArmyPool, template, 1, Location, Radius)
    ...
    hndl:SetAIPlan( PlatoonAIPlan, aiBrain)
end
```

Er zieht Einheiten aus `aiBrain.ArmyPool` **im Radius der Basis** und bildet daraus einen
Verband nach dem Platoon-Template. Vier Felder des Builders steuern, was der Verband
danach tut:

| Feld | Wirkung |
|---|---|
| `PlatoonAIPlan` | Hauptverhalten, z. B. `AirForceAILOUD` |
| `PlatoonAddPlans` | zusaetzliche Plaene |
| `PlatoonAddFunctions` | zusaetzliche Funktionen |
| `PlatoonAddBehaviors` | zusaetzliche Verhaltensweisen |

Das ist der Anknuepfungspunkt zwischen Builder und Verhaltensskript.

---

## Bedingungen: zwischengespeichert oder sofort

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\BrainConditionsMonitor.lua
```

`GetBuilderStatus` in `BuilderManager.lua` Zeile 229 unterscheidet zwei Sorten:

```lua
if not ResultTable[value].Instant then
    if not ResultTable[value].Status then return false end   -- zwischengespeichert
else
    if not ResultTable[value]:GetStatus(aiBrain) then return false end   -- sofort
end
```

| Sorte | Auswertung |
|---|---|
| normal | vom `ConditionMonitorThread` periodisch berechnet, gelesen wird nur `Status` |
| `Instant` | bei jedem Zugriff frisch berechnet |

### Der Rhythmus des Monitors

```lua
self.ThreadWaitDuration = LOUDMAX(
    LOUDCEIL( numResults * 2 ) + playerfactor + (aiBrain.NumBases * 5),
    minimumcycletime )     -- minimumcycletime = 120 Ticks
```

Die Zykluszeit waechst mit der Zahl der Bedingungen, der Spieler (`ArmyBrains * 5`) und
der Basen (`NumBases * 5`) - mindestens aber 120 Ticks.

**Praktische Folge:** Bei vielen Basen und Spielern werden Bedingungen **seltener**
neu berechnet. Eine KI mit vielen Aussenposten reagiert traeger. Wer sofortige Reaktion
braucht, muss eine `Instant`-Bedingung verwenden - die kostet dafuer bei jedem Zugriff.

### `CycleTime` ist belegt

```lua
aiBrain.CycleTime = GetGameTimeSeconds()
```

`BrainConditionsMonitor.lua` Zeile 111 und 161. **`CycleTime` ist die Spielzeit in
Sekunden** - die frueher als "ungeprueft" markierte Annahme stimmt. `CycleTime > 1500`
sind exakt 25 Minuten.

---

## Verhaltensskripte - `aibehaviors.lua`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\aibehaviors.lua
```

**10.265 Zeilen, 52 Funktionen** - die groesste Einzeldatei der KI. Hier steht, was ein
Verband tut, nachdem er gebildet wurde. Angesprochen ueber `PlatoonAIPlan` im Builder.

### Kommandant (7)

| Funktion | Aufgabe |
|---|---|
| `CommanderThread` | Hauptschleife des ACU |
| `LifeThread` | Ueberlebensueberwachung |
| `CDROverCharge` | Overcharge-Einsatz |
| `CDRRunAway` | Rueckzug bei Gefahr |
| `CDRReturnHome` | Heimkehr |
| `CDRHideBehavior` | Verstecken |
| `CDREnhance` | Ausbaustufen waehlen |

### Aufklaerung (3)

`AirScoutingAI` - `LandScoutingAI` - `NavalScoutingAI`

### Luftstreitkraefte (4)

`AirForceAILOUD` (Zeile 2933, allgemein) - `AirForceAI_Bomber_LOUD` -
`AirForceAI_Torpedo_LOUD` - `AirForceAI_Gunship_LOUD`

Jede rund 500-700 Zeilen. Das sind die vier Verhaltensweisen, die den Luftkrieg
bestimmen.

### Marine (2)

`NavalForceAILOUD` - `NavalBombardAILOUD`

### Zielsuche und Prioritaeten (6)

`FindExperimentalTarget` - `FindLandExperimentalTargetLOUD` -
`FindNavalExperimentalTargetLOUD` - `AssignArtilleryPriorities` -
`AssignExperimentalPriorities` - `ProsecuteTarget`

### Einzelne Einheiten (9)

`FatBoyAI` / `FatBoyThread` / `FatBoyBehavior` / `FatBoyBuildCheck` /
`FatboyChildBehavior` - `BehemothBehavior` - `CarrierThread` /
`AtlantisCarrierThread` / `CzarCarrierThread` - `EyeBehavior` - `RiftGateBehavior` -
`TMLThread` - `NukeAI`

**Experimentaleinheiten haben eigenes Verhalten** - Fatboy und die drei Traeger sind
namentlich ausprogrammiert.

### Selbstausbau (4)

`SCUSelfEnhanceThread` - `FactorySelfEnhanceThread` - `SelfUpgradeThread` -
`SelfUpgradeDelay`

`SelfUpgradeThread` nimmt Schwellwerte entgegen:
`(masslowtrigger, energylowtrigger, masshightrigger, energyhightrigger, checkperiod,
initialdelay, bypassecon, notify)` - **direkt parametrierbar**.

### Sonstiges (6)

`RetreatAI` - `SetLoiterPosition` - `EngineerTransferAI` - `AirLandToggle` /
`AirLandToggleThread` - `BroadcastPlatoonPlan` - `PlatoonWatchPrimarySeaAttackBase` -
`CheckBlockingTerrain` - `InWaterCheck` - `GetThreatOfUnits` - `WeaponFired`

### Fuer eigene KIs

Diese Funktionen werden ueber `PlatoonAIPlan = '<Funktionsname>'` im Builder zugewiesen.
Eine eigene KI kann:

- **andere Plaene zuweisen** - etwa Bomber mit `AirForceAILOUD` statt
  `AirForceAI_Bomber_LOUD` fuehren
- **eigene Funktionen schreiben** und im eigenen Builder eintragen

**Nicht gelesen:** der Inhalt der einzelnen Funktionen. Die Namensliste steht, die
Arbeitsweise nicht.

---

## KI-Key und Personality - zwei verschiedene Dinge

**Das ist die wichtigste Unterscheidung fuer eigene KIs.** Es gibt **zwei** Felder, die
aehnlich heissen und sich unterschiedlich verhalten.

| | `aiBrain.Personality` | `ScenarioInfo.ArmySetup[<Armee>].AIPersonality` |
|---|---|---|
| Gesetzt | einmal in `OnCreateAI` | in der Lobby, dann ueberschrieben |
| Quelle | der Lobby-Key | erst Lobby-Key, dann `baseType` |
| Danach | **wird nie wieder geaendert** | von `SetupMainBase` ueberschrieben |
| Gelesen von | Cheat-System | `FirstBaseFunction` |

### Der Ablauf

```
1. Lobby            ScenarioInfo.ArmySetup[x].AIPersonality = 'customai_standard'

2. OnCreateAI       aiBrain.Personality = 'customai_standard'
   aibrain.lua Z.893                     ^^^ ab hier unveraenderlich

3. GetBestBasePlan  FirstBaseFunction liest ScenarioInfo...AIPersonality
                    -> steht noch 'customai_standard'   [belegt, Testlauf 3]

4. SetupMainBase    ScenarioInfo.ArmySetup[x].AIPersonality = baseType
   aml.lua Z.47     -> jetzt 'loud'
                    aiBrain.Personality bleibt 'customai_standard'
```

**Nur das ScenarioInfo-Feld wird ueberschrieben, nicht das Feld am Brain.**
Belegt: `aiBrain.Personality` kommt im gesamten Code genau **einmal** auf der linken
Seite einer Zuweisung vor - `aibrain.lua` Zeile 893.

### ⚠️ Folge: eine eigene KI verliert die halben Cheats

Das Cheat-System prueft **`aiBrain.Personality`** - also den Lobby-Key, der dauerhaft
stehenbleibt:

```lua
-- aiutilities.lua Z.842, in SetupAICheat
if aiBrain.Personality != 'loud' then
    ...
    return
end

-- aiutilities.lua Z.1025, in ApplyCheatBuffs
if aiBrain.Personality == 'loud' then
    ApplyBuff(unit, 'CheatIntel'..ArmyIndex)
    ApplyBuff(unit, 'CheatALL'..ArmyIndex)
    ApplyBuff(unit, 'CheatMOBILE')
    if LOUDENTITY( categories.ENGINEER, unit) then
        ApplyBuff(unit, 'CheatENG')
        ...
    end
end
```

**Der Rueckgabewert `'loud'` aus unserer `FirstBaseFunction` hilft dagegen nicht** - er
landet nur im ScenarioInfo-Feld, nicht am Brain.

Einer KI mit eigenem Key fehlen damit:

| Fehlt | Wirkung |
|---|---|
| `VeterancyMult` | kein Veteranenbonus |
| `MinorCheatModifier`, `MajorCheatModifier` | keine abgestuften Boni |
| `BuildRateModifier` | keine Anpassung bei Unterlegenheit |
| `CheatIntel`, `CheatALL`, `CheatMOBILE` | keine Aufklaerungs- und Einheitenboni |
| `CheatENG` | Ingenieure ohne Bonus |
| `CheatCDROmni`, `CheatCDR*Storage` | ACU ohne Omni und Startvorrat |
| `OutnumberedRatio`-Ausgleich | kein Ausgleich bei Unterzahl |

**Was bleibt:** nur `CheatIncome` und `CheatBuildRate` - Ressourcen und Baurate.

Bei einer AIx-Partie waere unsere KI also **deutlich schwaecher** als eine LOUD-KI mit
demselben Multiplikator. Bei einer Partie ohne Cheats (`CheatValue = 1`) spielt es keine
Rolle.

### Loesungsweg

Ein Hook auf `OnCreateAI` kann den Lobby-Key beiseitelegen und `Personality` auf `'loud'`
setzen:

```lua
-- Skizze, UNGEPRUEFT
local oldAIBrain = AIBrain

AIBrain = Class(oldAIBrain) {

    OnCreateAI = function(self, planName)

        oldAIBrain.OnCreateAI(self, planName)

        -- eigenen Key merken, bevor wir Personality umschreiben
        if self.Personality and string.find(self.Personality, 'customai_') then
            self.CustomAIKey = self.Personality
            self.Personality = 'loud'
        end
    end,
}
```

`AIBrain` ist definiert als `Class(moho.aibrain_methods)` in `aibrain.lua` Zeile 827 -
das Ableiten im Hook ist also das uebliche Muster.

**Die `FirstBaseFunction` bleibt davon unberuehrt**, weil sie das ScenarioInfo-Feld liest,
nicht das Brain-Feld.

**Ungeprueft:**
- ob der Hook vor `SetupAICheat` greift
- ob `Personality = 'loud'` anderswo unerwuenschte Wirkung hat
- ob `ApplyCheatBuffs` je Einheit spaeter laeuft und den geaenderten Wert sieht

Steht in `..\TODO.md`.

### Was "Personality" NICHT ist

In anderen SupCom-KIs (Sorian) bezeichnet "Personality" einen Spielstil - aggressiv,
defensiv, Turtle. **Bei LOUD gibt es das nicht.** `Personality` ist hier nur der
Lobby-Key, und der einzige vorgesehene Wert ist `'loud'`. Der Spielstil steckt
vollstaendig in Basistemplates und Buildern.

Der einzige Rest dieser alten Bedeutung ist eine auskommentierte Zeile in
`loudutilities.lua` Zeile 7413:

```lua
--if brain.BrainType == "AI" and string.sub( brain.Personality, 1, 1) == 'm' then
```

---

## Bedingungsbibliotheken - vollstaendig

### `UCBC` - Einheitenzahlen, 68 Funktionen

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\editor\UnitCountBuildConditions.lua
```

Die mit Abstand groesste Bibliothek. Nach Themen:

**Globale Zaehlungen**
`HaveGreaterThanUnitsWithCategory` - `HaveLessThanUnitsWithCategory` -
`HaveLessThanUnitsAsPercentageOfUnitCap` - `HaveLessThanUnitsForMapSize` -
`HaveLessThanUnitsInCategoryBeingBuilt` - `HaveGreaterThanUnitsWithCategoryAndAlliance` -
`HaveLessThanUnitsWithCategoryAndAlliance` -
`HaveLessThanUnitsWithCategoryAndAllianceInRange`

**An einem Ort**
`UnitsLessAtLocation` - `UnitsGreaterAtLocation` - `UnitsLessAtLocationInRange` -
`UnitsGreaterAtLocationInRange` - `PoolLessAtLocation` - `PoolGreaterAtLocation` -
`EngineerLessAtLocation` - `EngineerGreaterAtLocation` - `FactoryLessAtLocation` -
`FactoryGreaterAtLocation` - `BuildingLessAtLocation` - `BuildingGreaterAtLocation` -
`BuildingGreaterAtLocationAtRange`

**Fabrikverhaeltnisse** - fuer die Balance Land/Luft/See
`FactoryRatioEqualAtLocation` - `FactoryRatioGreaterAtLocation` -
`FactoryRatioLessAtLocation` - `FactoryRatioGreaterOrEqualAtLocation` -
`FactoriesGreaterThan` - `FactoriesLessThan` -
`LocationFactoriesBuildingLess` - `LocationFactoriesBuildingGreater`

**Obergrenzen** - hier greifen die `BaseSettings` aus Ebene 2
`FactoryCapCheck` - `BelowEngineerCapCheck` - `AboveEngineerCapCheck` -
`UnitCapCheckGreater` - `UnitCapCheckLess`

**Expansionsplaetze**
`BaseAreaForExpansion` - `BaseAreaForDP` - `DefensivePointForExpansion` -
`NavalAreaForExpansion` - `DefensivePointNeedsStructure` -
`NavalDefensivePointNeedsStructure` - `ExpansionPointNeedsStructure` -
`StartingPointNeedsStructure` - `BasePointNeedsStructure`

**Massextraktoren** - fuer Ausbau und Absicherung
`MassExtractorHasStorageAndLessDefense` - `MassExtractorInRangeHasLessThanStorage` -
`MassExtractorInRangeHasLessThanEnergy` - `MassExtractorInRangeHasLessThanDefense`

**Basenzahl**
`BaseCount` - `ExpansionBaseCount` - `NavalBaseCount` - `IsBaseExpansionUnderway` -
`PreBuiltBase` - `NotPreBuilt`

**Sonstiges**
`ACUNeedsUpgrade` - `ACUHasUpgrade` - `ArmyNeedsTransports` -
`DamagedStructuresInArea` - `UnfinishedUnits` - `GetGuards` - `ShieldDamaged` -
`AdjacencyCheck` - `CheckUnitRange` -
`LocationEngineerNeedsBuildingAssistanceInRange` -
`ExistingBasesHaveGreaterThanFactory` - `PoolLess` - `PoolGreater` - `CompareBody`

### `TBC` - Bedrohung, 3 Funktionen

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\editor\ThreatBuildConditions.lua
```

`ThreatCloserThan( aiBrain, locationType, distance, threatcutoff, threattype)` -
`ThreatCloserThanOrArtillery(...)` -
`ThreatFurtherThan( aiBrain, locationType, distance, threattype, threatcutoff)`

Nur drei - die Bedrohungsauswertung steckt groesstenteils in den `PriorityFunction`s
ueber `GetThreatAtPosition`.

### `MIBC` - Sonstiges, 11 Funktionen

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\editor\MiscBuildConditions.lua
```

| Funktion | Nutzen fuer eigene KIs |
|---|---|
| `RandomNumber(aiBrain, higherThan, lowerThan, minNumber, maxNumber)` | **Zufallsentscheidung** - laesst eine KI unberechenbar wirken |
| `GreaterThanGameTime(aiBrain, num)` / `LessThanGameTime` | **Zeitfenster** - Bauphasen nach Spielzeit trennen |
| `FactionIndex(aiBrain, factionNum, otherFactionNum, thirdFacNum)` | fraktionsabhaengiges Verhalten |
| `IsIsland` / `IsWaterMap` | Kartentyp |
| `MapGreaterThan(aiBrain, size)` / `MapLessThan` | Kartengroesse |
| `ReclaimablesInArea` / `ReclaimablesInAreaEnergy` | Wrackverwertung |
| `BaseInPlayableArea( aiBrain, locationType )` | Basis noch im Spielfeld |

**`RandomNumber` und `GreaterThanGameTime` sind die interessantesten** fuer eine eigene
KI - damit lassen sich Eroeffnungen variieren, ohne eine Zeile Verhaltenscode zu
schreiben.

---

## `platoon.lua` - die Verbandsklasse

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\platoon.lua
```

**10.798 Zeilen.** Enthaelt die Verbandsklasse und **weitere Verhaltensplaene**, die
ebenfalls per `PlatoonAIPlan` zugewiesen werden koennen - sie stehen also nicht nur in
`aibehaviors.lua`.

**Verwaltung**
`OnCreate` - `SetPlatoonData` - `SetAIPlan` - `StopAI` - `OnUnitsAddedToPlatoon` -
`OnDestroy` - `PlatoonDisband` - `WatchPlatoonSize` - `AddDestroyCallback` -
`DoDestroyCallbacks` - `ForkThread` - `ForkAIThread`

**Kampfplaene**
`LandForceAILOUD` - `AmphibForceAILOUD` - `AttackForceAI_Bomber` -
`AttackForceAI_Gunship` - `AttackForceAI_Torpedo` - `SatelliteAI` -
`ExperimentalAIHub` - `ScoutingAI`

**Bewachung**
`GuardPoint` - `GuardPointAir` - `GuardPointAmphibious` - `GuardPointNaval` -
`GuardPlatoonAI` - `PlatoonPatrolPointAI`

**Verstaerkung** - alle sechs sind gueltige `PlatoonAIPlan`-Werte
`ReinforceAirAI` - `ReinforceAirLandAI` - `ReinforceAirNavalAI` - `ReinforceAmphibAI` -
`ReinforceLandAI` - `ReinforceNavalAI`

**Ingenieure**
`EngineerBuildAI` - `EngineerAssistAI` - `EngineerReclaimAI` - `EngineerAssistShield` -
`EngineerBuildMassAdjacencyAI` - `EngineerBuildMassDefenseAdjacencyAI` -
`ProcessBuildCommand`

**Not und Zusammenschluss**
`PlatoonCallForHelpAI` - `DistressResponseAI` - `MergeWithNearbyPlatoons` -
`MergeIntoNearbyPlatoons`

**Zielsuche**
`PlatoonFindTarget`

`DummyAI` tut nichts - nuetzlich zum Stilllegen eines Verbandstyps.

---

## Hilfsbibliotheken

### `aiattackutilities.lua` - 11 Funktionen, 1195 Zeilen

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\aiattackutilities.lua
```

Wegfindung und Zielsuche:
`GetPathGraphs` - `GetClosestPathNodeInRadiusByLayer` - `CanGraphTo` -
`GetMostRestrictiveLayer` - `GetNavalPlatoonMaxRange` - `FindTargetInRange` -
`AIFindTargetInRangeInCategoryWithThreatFromPosition` - `FindPointMeetsConditions` -
`AIFindNumberOfUnitsBetweenPoints` - `InWaterCheck` - `LocationInWaterCheck`

`FindPointMeetsConditions` nimmt **23 Parameter** - die zentrale Suchfunktion fuer
Orte, die bestimmte Bedingungen erfuellen.

### `aiutilities.lua` - 25 Funktionen, 1306 Zeilen

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\aiutilities.lua
```

**Marker und Orte**
`AIGetMarkerLocations` - `AIGetMarkerLocationsEx` - `AIGetMarkersAroundLocation` -
`AIGetClosestMarkerLocation` - `AIGetClosestThreatMarkerLoc` -
`AISortMarkersFromLastPosWithThreatCheck` - `AIFindMarkerNeedsEngineer` -
`AIFindDefensivePointNeedsStructureFromPoint` - `AIFilterAlliedBases` -
`RandomLocation`

**Einheiten im Umkreis**
`GetOwnUnitsAroundPoint` - `GetOwnUnfinishedUnitsAroundPoint` -
`GetAlliedUnitsAroundPoint` - `GetOwnUnitsAroundPointWithThreatCheck` -
`GetNumberOfOwnUnitsAroundPoint` - `AIFindBrainTargetAroundPoint`

**Sonstiges**
`AIAddMustScoutArea` - `AIGetReclaimablesAroundLocation` - `CheckUnitPathingEx` -
`GetThreatDistance` - `AIFindBrainNukeTargetInRangeSorian`

**Cheat-System** - siehe unten
`SetupAICheat` - `SetupAICheatUnitCap` - `ApplyCheatBuffs` - `SetArmyPoolBuff`

---

## Das Cheat-System - mit einer Falle fuer eigene KIs

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\aiutilities.lua
```

`SetupAICheat(aiBrain)` ab Zeile 809. `aiBrain.CheatValue` kommt aus der Lobby
(`ScenarioInfo.ArmySetup[...].Mult`), begrenzt auf **0.1 bis 99**
(`aibrain.lua` Zeile 896-903).

### Zwei Stufen

**Stufe 1 - fuer jede KI:**

```lua
newbuff.Affects.EnergyProduction.Mult = aiBrain.CheatValue
newbuff.Affects.MassProduction.Mult   = aiBrain.CheatValue
newbuff.Affects.BuildRate.Mult        = LOUDMAX( 1.0, aiBrain.CheatValue )
```

**Stufe 2 - nur bei `Personality == 'loud'`:**

```lua
if aiBrain.Personality != 'loud' then
    ...
    return          -- <<< hier steigt der Code aus
end

aiBrain.VeterancyMult      = LOUDMAX( 1, aiBrain.CheatValue)
aiBrain.MinorCheatModifier = (LOUDMAX( 0, aiBrain.CheatValue - 1.0 ) * 0.34) + 1.0
aiBrain.MajorCheatModifier = (LOUDMAX( -0.2, aiBrain.CheatValue - 1.0 ) * 0.65) + 1.0
aiBrain.BuildRateModifier  = LOUDMAX( 1, aiBrain.CheatValue)
```

### ⚠️ Warum das fuer unseren Mod wichtig ist

**Eine KI mit fremder `Personality` bekommt nur die halbe Cheat-Behandlung.** Ihr fehlen
Veteranenbonus, die beiden Modifikatoren und die Unterlegenheitsanpassung
(`OutnumberedRatio`).

Unsere Fabrik in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\lua\AI\AIFactory.lua`
gibt aus der `FirstBaseFunction` **`'loud'`** als `baseType` zurueck. `SetupMainBase`
schreibt diesen Wert nach `AIPersonality`. **Ob `SetupAICheat` davor oder danach
laeuft, ist ungeprueft** - davon haengt ab, ob unsere KI die vollen Cheat-Werte bekommt.

Zu pruefen im Log: die Zeilen `Standard Cheat is ...`, `Resource mult is ...` und
`BuildRate mult is ...`. **Erscheint `BuildRate mult is`, ist der Code in den
fremden Zweig gelaufen** - dann fehlt Stufe 2. Steht in `..\TODO.md`.

### `Adaptive` - die Cheat-Anpassung

`aibrain.lua` Zeile 905: `self.Adaptive = ScenarioInfo.ArmySetup[self.Name].ACT`

| Wert | Bedeutung |
|---|---|
| 1 | fest |
| 2 | Rueckkopplung (`FeedbackCheat`) |
| 3 | Zeit (`TimeCheat`) |
| 4 | beides |

Zivilisten sind grundsaetzlich ausgenommen: `self.CheatingAI = false`.

---

## Ebene 5: Zeitsteuerung - Builder pro KI ein- und ausschalten

**Gelesen 2026-08-08.** Antwort auf die Frage "kann die KI die ersten X Minuten nur
Wirtschaft bauen?" - ja, aber nicht ueber `template.Builders`.

### Warum das Basistemplate dafuer nicht reicht

Die BuilderGroups werden **einmal** geladen, beim Anlegen der Basis
(`aiaddbuildertable.lua`, `AddGlobalBaseTemplate`). Danach aendert sich die Liste nie
wieder. Eine Gruppe aus `template.Builders` zu streichen schaltet sie **dauerhaft** ab,
nicht auf Zeit.

Dynamisch ist nur die **Prioritaet**. Die Zeitsteuerung muss also im Builder sitzen.

### Die drei globalen Tabellen

Alle drei liegen in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\system\`
und funktionieren identisch: ein Konstruktor traegt in eine globale Tabelle ein, Schluessel
ist der Name.

| Konstruktor | Tabelle | Datei |
|---|---|---|
| `BaseBuilderTemplate{}` | `BaseBuilderTemplates` | `GlobalBaseTemplate.lua` |
| `BuilderGroup{}` | `BuilderGroups` | `GlobalBuilderGroup.lua` |
| `Builder{}` | `Builders` | `GlobalBuilderTemplate.lua` |

**Wichtig:** `Builder{...}` gibt nur den `BuilderName` zurueck. Eine BuilderGroup enthaelt
deshalb keine Builder-Tabellen, sondern **Namen**:

```lua
BuilderGroups['Factory Production Land'] = {
    BuilderGroupName = 'Factory Production Land',
    BuildersType     = 'FactoryBuilder',
    [1] = 'Land Scout', [2] = 'T1 Bots', [3] = 'T1 Tanks', ...
}
```

`Builders['T1 Tanks']` ist die eigentliche Definition - **global und von allen KIs
geteilt.** Sie einfach zu aendern trifft auch LOUDs KI.

### Der Hebel: `PriorityFunction` ist brainbewusst

`Builder:Create` in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\Builder.lua`
Z. 209-224 legt **je Brain und je Manager ein eigenes Builder-Objekt** an und kopiert
`Priority`, `PriorityFunction`, `BuilderName`; `BuilderConditions` werden tief kopiert.

Die `PriorityFunction` selbst bleibt eine geteilte Funktion - aber sie bekommt den Brain
als Parameter (`BuilderManager.lua` Z. ~215:
`Builders[TaskName]:PriorityFunction( aiBrain, unit, self )`).

**Daraus folgt das Muster:** die Funktion einmal global umhuellen und im Inneren nach der
KI unterscheiden.

```lua
-- laeuft im simInit-Hook, nach Z. 357 (LOUDs Builder sind geladen)
-- und vor der ersten Basisanlage
local orig = Builders[name].PriorityFunction

Builders[name].PriorityFunction = function(self, aiBrain, unit, manager)

    -- nur fuer unsere KI und nur vor dem Zeitpunkt
    if aiBrain.CustomAIKey == key and aiBrain.CycleTime < 900 then
        return 10, true          -- vorlaeufig aus, bleibt in der Liste
    end

    if orig then
        return orig(self, aiBrain, unit, manager)
    end

    return (self.OldPriority or self.Priority), true
end
```

`aiBrain.CustomAIKey` setzt unser Hook auf `OnCreateAI`
(`usermods\CustomAI\hook\lua\aibrain.lua`). Fuer jede fremde KI ist das Feld `nil`, die
Bedingung faellt durch, LOUDs Original laeuft unveraendert.

### `10, true` statt `0, false`

`GetHighestBuilder` fuehrt nur Aufgaben mit `Priority > 100` aus. Beide Werte schalten
also ab - aber:

| Rueckgabe | Folge |
|---|---|
| `0, false` | **permanent**: `SetPriority` loescht `OldPriority` (`Builder.lua` Z. 253-256). Der Builder kommt nie zurueck. |
| `10, true` | temporaer: `OldPriority` bleibt gespeichert, `ResetPriority` kann ihn wiederherstellen |

Fuer ein Zeitfenster, nach dem der Builder wieder anlaufen soll, ist **nur `10, true`
richtig.**

LOUD nutzt beide Formen selbst, nachzulesen in
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBuilders\Loud_AI_Factory_Land_Builders.lua`
Z. 23-58: `AboveUnitCap85` gibt `10, true` (soll zurueckkommen), `First30Minutes` gibt
`0, false` (soll nicht).

### Zeitquelle

`aiBrain.CycleTime` = Spielzeit in Sekunden (`BrainConditionsMonitor.lua` Z. 111).
15 Minuten = `900`. LOUD selbst vergleicht gegen `1800` und `2700`.

Alternative als `BuilderCondition`: `{ MIBC, 'GreaterThanGameTime', { 900 }}` - im
Original verwendet bei `Land Scout` mit `180`. Das laeuft ueber den
ConditionsMonitor und wird nur periodisch neu berechnet; die `PriorityFunction` ist
bei jedem Auswahldurchlauf frisch.

### Was gedrosselt werden sollte - und was nicht

Die Truppenproduktion sitzt in den `Factory Production ...`-Gruppen. **Nicht** drosseln:

| Gruppe | Grund |
|---|---|
| `Factory Production - Engineers` | ohne Ingenieure kein Wirtschaftsaufbau |
| `Factory Production Air - Scouts` | ohne Aufklaerung keine Bedrohungsdaten, die halbe KI haengt daran |
| `Land Formations - *`, `Air Formations - *` | das sind PlatoonFormBuilder - sie bilden Verbaende aus **vorhandenen** Einheiten. Drosseln laesst nur Einheiten im Pool liegen. |

**Der Techtree braucht keinen Eingriff.** Fabrik- und Gebaeudeaufstieg laufen ueber
`FactorySelfEnhanceThread` und `SelfUpgradeThread` in `aibehaviors.lua`, nicht ueber das
Basistemplate. Faellt die Truppenproduktion weg, staut sich Masse und der Aufstieg
beschleunigt sich von selbst.

**Nebenwirkung beachten:** `MassToFactoryValues` steuert, ab welchem Masse-Einkommen die
KI neue Fabriken und Basen anfaengt. Ohne Truppenproduktion wird diese Schwelle sehr
frueh gerissen - die KI baut dann Fabriken, die nichts produzieren. Wer Wirtschaft
will, sollte die Werte gleichzeitig anheben.

---

## OFFEN: die globalen Tabellen werden nach der ersten Basis geleert

`aiaddbuildertable.lua`, letzte Zeilen von `AddGlobalBaseTemplate`:

```lua
-- get rid of the data sets that we build this from - they get reloaded if needed
BaseBuilderTemplates = nil
BuilderGroups = nil
```

`Builders` bleibt bestehen (wird zur Laufzeit von `Builder:GetBuilderData` gebraucht) -
aber die beiden anderen sind danach `nil`.

Das ist unvereinbar mit zwei Stellen, die sie **spaeter** lesen:

- `aiarchetype-managerloader.lua` `GetBestBasePlan` Z. ~88 - laeuft fuer **jede** KI
- `aibuildstructures.lua` Z. 456 `AINewExpansionBase` - laeuft bei **jedem** Aussenposten

Und `_G` hat ein `__index`, das bei nicht vorhandenen Globalen einen Fehler wirft
(`lua\system\config.lua` Z. ~150). Ein Lesezugriff nach dem Loeschen muesste also
`access to nonexistent global variable` erzeugen.

**Wo der angekuendigte Reload stattfindet, ist nicht gefunden.** Durchsucht wurden
`loudutilities.lua`, `aibrain.lua`, `simInit.lua`, `aibuildstructures.lua` - keine
Stelle setzt die Tabellen neu. Moeglich sind: eine neuere Fassung in `gamedata\`, die
von `gamedata.entpackt\` abweicht; oder ein echter LOUD-Fehler, der nur bei mehreren
KIs bzw. bei Expansionen auffaellt.

**Der bisherige Testlauf beweist nichts:** `LOUD.log` von Testlauf 4 endet bei Zeile 965,
unmittelbar nach `Selected` - es gab weder eine zweite KI noch einen Aussenposten.

**Fuer unseren Mod folgt daraus zweierlei:**

1. Alles, was in `BuilderGroups` oder `BaseBuilderTemplates` eingetragen werden soll,
   muss im **simInit-Hook** passieren - vor der ersten Basisanlage. Das tut die Fabrik
   bereits.
2. Der naechste Testlauf sollte **zwei KIs auf einer Karte mit Expansionsmoeglichkeit**
   fahren und den Log auf `nonexistent global variable` pruefen.

Steht in `..\TODO.md`.

---

## Vollstaendigkeit

Damit sind alle KI-Dateien mindestens strukturell erfasst:

| Datei | Zeilen | Erfassungsgrad |
|---|---:|---|
| `AIBaseTemplates\Loud_Main_Standard.lua` | 220 | vollstaendig gelesen |
| `sim\BuilderManager.lua` | 680 | Auswahllogik vollstaendig |
| `sim\Builder.lua` | 463 | Instanzen und Prioritaeten |
| `sim\BrainConditionsMonitor.lua` | 349 | Auswertungsrhythmus |
| `sim\EngineerManager.lua` | 1961 | Struktur, Alarmsystem |
| `sim\FactoryBuilderManager.lua` | 894 | Struktur, Rally Points |
| `sim\PlatoonFormManager.lua` | 248 | vollstaendig |
| `editor\EconomyBuildConditions.lua` | - | alle 27 Funktionen |
| `editor\UnitCountBuildConditions.lua` | 1210 | alle 68 Funktionen |
| `editor\ThreatBuildConditions.lua` | 158 | alle 3 Funktionen |
| `editor\MiscBuildConditions.lua` | 137 | alle 11 Funktionen |
| `AI\aiarchetype-managerloader.lua` | 180 | vollstaendig |
| `AI\aibehaviors.lua` | 10265 | 52 Funktionsnamen, Inhalte nicht |
| `AI\aiattackutilities.lua` | 1195 | 11 Funktionsnamen |
| `AI\aiutilities.lua` | 1306 | 25 Funktionsnamen, Cheat-System gelesen |
| `platoon.lua` | 10798 | 48 Methodennamen, Inhalte nicht |
| `loudutilities.lua` | 7500+ | Angriffsplanung, Ratios, Intel |
| `aibrain.lua` | 1993 | Uebergabe, Cheat-Setup, Debug-Schalter |

**Nicht gelesen bleiben die Funktionsrumpfe** von `aibehaviors.lua` (10.265 Zeilen) und
`platoon.lua` (10.798 Zeilen). Wer ein bestimmtes Verhalten aendern will, liest die
betreffende Funktion gezielt nach - fuer die Auswahl der Stellschrauben reicht die
Namensliste.

Ebenfalls nicht gelesen: `altaiutilities.lua`, `Transportutilities.lua`,
`sorianutilities.lua`, `aiaddbuildertable.lua`, `aibuildstructures.lua`.
