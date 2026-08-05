# 10 — Vorlagen

Copy-Paste-Gerüste. Alle Pfade beziehen sich auf `usermods\<Modname>\`.

---

## 1. Minimaler Sim-Mod (Hook)

```
usermods\MeinMod\
├── mod_info.lua
├── icons\
│   └── MeinMod.bmp
└── hook\
    └── lua\
        └── sim\
            └── Unit.lua
```

### `mod_info.lua`

```lua
name        = "Mein Mod"
version     = 1.0
description = "Was der Mod im Spiel bewirkt — erscheint im Mod-Manager."
author      = "..."
copyright   = "none"

-- PFLICHT: frische GUID, per PowerShell:  [guid]::NewGuid()
uid = "00000000-0000-0000-0000-000000000000"

icon = "/mods/meinmod/icons/meinmod.bmp"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false      -- true NUR bei reinen Interface-Mods
```

### `hook\lua\sim\Unit.lua`

```lua
--[[
    Mod:      MeinMod
    Hookt:    /lua/sim/Unit.lua
    Zweck:    <ein Satz>
    Original: gamedata.entpackt\lua\lua\sim\Unit.lua
    Risiken:  <z. B. läuft bei jedem Treffer>
    Stand:    JJJJ-MM-TT
]]

local DEBUG = false

local OldOnStopBeingBuilt = Unit.OnStopBeingBuilt

function Unit:OnStopBeingBuilt(builder, layer)

    -- Original zuerst: die Einheit muss vollständig initialisiert sein
    local result = OldOnStopBeingBuilt(self, builder, layer)

    local bp = self:GetBlueprint()

    -- defensiv: Blueprints fremder Pakete haben nicht alle Felder
    if bp and bp.Defense and bp.Defense.MaxHealth then
        if DEBUG then
            LOG("MEINMOD: " .. self:GetUnitId() .. " HP=" .. bp.Defense.MaxHealth)
        end
    end

    return result
end
```

---

## 2. Balance-Änderung per Blueprint-Merge

```
usermods\MeinBalance\
├── mod_info.lua
└── units\
    └── UEL0001\
        └── UEL0001_unit.bp
```

### `units\UEL0001\UEL0001_unit.bp`

```lua
UnitBlueprint {
    Merge       = true,
    BlueprintId = 'uel0001',        -- klein!

    Defense = {
        Health    = 15000,          -- Original: 12000
        MaxHealth = 15000,          -- Original: 12000
        RegenRate = 15,             -- Original: 10
    },

    Economy = {
        BuildCostMass   = 12000,    -- Original: <Wert aus $SRC eintragen>
        BuildCostEnergy = 240000,   -- Original: <Wert aus $SRC eintragen>
    },
}
```

> Vor dem Schreiben die Originalwerte in
> `gamedata.entpackt\units\units\UEL0001\UEL0001_unit.bp` nachschlagen und als Kommentar
> festhalten. **Listen (`Categories`, `Weapon`) nicht per Merge kürzen** — siehe
> `03_BLUEPRINTS.md` §4.

### Gezielt einen Waffenwert ändern

Merge greift bei `Weapon` indexweise. Nur den Index bis zur Zielwaffe nachbilden:

```lua
UnitBlueprint {
    Merge       = true,
    BlueprintId = 'uel0001',

    Weapon = {
        {                       -- Waffe 1
            Damage    = 250,    -- Original: 200
            RateOfFire = 1.5,   -- Original: 1.0
        },
        -- Waffe 2 unverändert: leere Tabelle als Platzhalter
        {},
        {                       -- Waffe 3
            MaxRadius = 40,     -- Original: 30
        },
    },
}
```

---

## 3. Massenänderung per `ModBlueprints()`

```
usermods\MeinGlobalBalance\
├── mod_info.lua
└── hook\
    └── lua\
        └── system\
            └── Blueprints.lua
```

```lua
--[[
    Mod:      MeinGlobalBalance
    Hookt:    ModBlueprints() aus /lua/system/Blueprints.lua
    Zweck:    Massenänderung über viele Einheiten
    Stand:    JJJJ-MM-TT
]]

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_bps)

    -- andere Mods nicht abwürgen
    OldModBlueprints(all_bps)

    LOG("MEINGLOBALBALANCE: ModBlueprints läuft")

    local count = 0

    for id, bp in all_bps.Unit do

        if bp.Categories and bp.Economy and bp.Economy.BuildCostMass then

            -- Beispiel: alle Experimentals 25 % teurer
            local istExperimental = false
            for _, cat in bp.Categories do
                if cat == 'EXPERIMENTAL' then
                    istExperimental = true
                    break
                end
            end

            if istExperimental then
                bp.Economy.BuildCostMass = bp.Economy.BuildCostMass * 1.25
                count = count + 1
            end
        end
    end

    LOG("MEINGLOBALBALANCE: " .. count .. " Blueprints angepasst")
end
```

> **Pfad bestätigt (05.08.2026):** `hook\lua\system\Blueprints.lua`. Beleg im `LOUD.log`
> durch den LOUD-eigenen Mod `Enhanced Resources`, siehe `15_LOG.md` §4.1.
> Der abweichende Hinweis im Kopfkommentar von `Blueprints.lua` ist irreführend.

---

## 4. Neue Einheit

```
usermods\MeineEinheit\
├── mod_info.lua
├── icons\
│   └── units\
│       └── mel0101_icon.dds        -- optional, wird automatisch gefunden
└── units\
    └── MEL0101\
        ├── MEL0101_unit.bp
        ├── MEL0101_script.lua
        ├── MEL0101_lod0.scm
        ├── MEL0101_lod1.scm
        ├── MEL0101_Albedo.dds
        ├── MEL0101_NormalsTS.dds
        └── MEL0101_SpecTeam.dds
```

Ablauf:
1. Nächstliegende Einheit aus `gamedata.entpackt\units\units\` kopieren.
2. Alle Dateien auf die neue ID umbenennen (Präfix `M` für eigene Einheiten).
3. Im `.bp` anpassen: `Display.Mesh`-Pfade, `General.UnitName`, `Interface.HelpText`,
   `StrategicIconName`, `Categories`.
4. Im `_script.lua` Klassennamen und `import`-Pfade anpassen.
5. Baubarkeit herstellen (Bauer-`BuildableCategory` bzw. LOUDs `lua\CustomUnits\`).
6. **ID-Freiheit prüfen:** `search_files` über `gamedata.entpackt` **und** `usermods`.

### `MEL0101_script.lua` (Gerüst)

```lua
--[[
    Mod:  MeineEinheit
    Einheit: MEL0101
    Vorlage: gamedata.entpackt\units\units\<QUELLE>\<QUELLE>_script.lua
]]

local TLandUnit = import('/lua/terranunits.lua').TLandUnit

MEL0101 = Class(TLandUnit) {

    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        TLandUnit.OnStopBeingBuilt(self, builder, layer)
    end,
}

TypeClass = MEL0101
```

> Basisklasse und Waffenklasse müssen zur Quelleinheit passen — beides in der
> Originaldatei nachschlagen, nicht raten.

---

## 5. UI-Mod

```
usermods\MeinUIMod\
├── mod_info.lua                     -- ui_only = true
└── hook\
    └── lua\
        └── ui\
            └── game\
                └── <originaldatei>.lua
```

```lua
--[[
    Mod:      MeinUIMod
    Hookt:    /lua/ui/game/<datei>.lua
    Zweck:    <ein Satz>
    Stand:    JJJJ-MM-TT
]]

local OldFunktion = Funktion        -- Name aus der Originaldatei

function Funktion(...)
    local result = OldFunktion(unpack(arg))
    -- eigene Anpassung
    return result
end
```

---

## 6. Mod mit Abhängigkeit / Konflikt

```lua
-- mod_info.lua
requires = {
    "A0BC6CD8-2F26-4D3D-96EA-EB6A8B34A8F1",   -- Escalating Build Costs
}
requiresNames = {
    ["A0BC6CD8-2F26-4D3D-96EA-EB6A8B34A8F1"] = "Escalating Build Costs 1.0",
}

conflicts = {
    "12345678901234567890test21000",          -- TEST21000 (ersetzt UEL0001 vollständig)
}

after = {
    "A0BC6CD8-2F26-4D3D-96EA-EB6A8B34A8F1",   -- läuft NACH diesem Mod
}
```

---

## 7. GUID erzeugen

PowerShell:
```powershell
[guid]::NewGuid()
```

Ergebnis in Großbuchstaben, als String in `uid` eintragen, und in
`08_BESTANDSAUFNAHME.md` vermerken.

---

## 8. Thread mit Aufräumen

```lua
local OldOnCreate = Unit.OnCreate

function Unit:OnCreate()
    OldOnCreate(self)

    if EntityCategoryContains(categories.STRUCTURE, self) then
        self.MeinThread = self:ForkThread(self.MeineSchleife)
    end
end

function Unit:MeineSchleife()
    while not self.Dead do
        WaitSeconds(5)
        -- periodische Logik
    end
end
```

- `ForkThread` bindet den Thread an die Lebensdauer der Einheit.
- Erzeugte Effekte/Entities in `self.Trash:Add(obj)` legen.
- **Nie** eine Schleife ohne `WaitSeconds`/`WaitTicks` — das friert die Simulation ein.
