-- Nomads: Faehigkeiten-Verwaltung der Armee (Orbital-Schlaege, Sonden, Kondensator).
-- Siehe doc.claude\mods\Nomads.md (Abschnitt Hooks). Umgebaut gegen LOUD lua.scd, lua/aibrain.lua:
-- LOUD hat kein CreateBrainShared; die Tabellen entstehen bei Bedarf (EnsureAbilities).
-- Der Vorab-Bau fuer Zusatzfraktionen (Feld PreBuildUnits) gehoert Custom Factions (Uebergabe, aibrain.lua).

local oldAIBrain = AIBrain

AIBrain = Class(oldAIBrain) {

    -- ================================================================================================================
    -- FAEHIGKEITEN (Task-Skripte, Faehigkeiten-Leiste)
    -- BrainSpecialAbilities[Name] = { AvailableNow = n, ... }
    -- UnitSpecialAbilities[EntityID][Name] = { AvailableNowUnit = n, Enabled = bool, ... }
    -- ================================================================================================================

    EnsureAbilities = function(self)
        if not self.BrainSpecialAbilities then
            self.BrainSpecialAbilities = {}
            self.UnitSpecialAbilities = {}
            self.SpecialAbilities = {}
            self:ForkThread(self.AbilityPanelUpdateThread)
        end
    end,

    SetSpecialAbility = function(self, abilityName, data)
        self:EnsureAbilities()
        if data == 'Remove' and self.BrainSpecialAbilities[abilityName] then
            self.BrainSpecialAbilities[abilityName] = nil
        elseif type(data) == 'table' then
            if not self.BrainSpecialAbilities[abilityName] then
                self.BrainSpecialAbilities[abilityName] = data
            else
                for key, value in data do
                    self.BrainSpecialAbilities[abilityName][key] = value
                end
            end
        else
            WARN('Nomads: SetSpecialAbility: malformed data for '..repr(abilityName)..' ('..repr(data)..')')
        end
        self.QueueAbilityPanelUpdate = true
    end,

    -- brain:SetUnitSpecialAbility(unit, 'OrbitalBombardment', {AvailableNowUnit = 1,})
    SetUnitSpecialAbility = function(self, unit, abilityName, data)
        self:EnsureAbilities()
        if not unit or unit.Dead or not abilityName then
            return
        end
        local unitId = unit:GetEntityId()
        if not unitId then
            return
        end
        if data == 'Remove' then
            local entry = self.UnitSpecialAbilities[unitId]
            if entry and entry[abilityName] then
                entry[abilityName] = nil
                if next(entry) == nil then
                    self.UnitSpecialAbilities[unitId] = nil
                end
            end
        elseif type(data) == 'table' then
            if not self.UnitSpecialAbilities[unitId] then
                self.UnitSpecialAbilities[unitId] = {}
            end
            self.UnitSpecialAbilities[unitId][abilityName] = table.merged(self.UnitSpecialAbilities[unitId][abilityName] or {}, data)
        else
            return
        end
        self.QueueAbilityPanelUpdate = true
    end,

    -- hoechstens eine Aktualisierung der Leiste je Tick
    AbilityPanelUpdateThread = function(self)
        local army = self:GetArmyIndex()
        while not self:IsDefeated() do
            WaitTicks(1)
            if self.QueueAbilityPanelUpdate then
                self:CheckAbilities()
                UpdateSpecialAbilityUI(army, self.BrainSpecialAbilities, self.UnitSpecialAbilities)
                self.QueueAbilityPanelUpdate = false
            end
        end
    end,

    -- gleicht die Armee-Liste mit den Einheiten ab
    CheckAbilities = function(self)
        self:EnsureAbilities()
        local queue = {}
        for unitID, abilityTypes in self.UnitSpecialAbilities do
            local unit = GetEntityById(unitID)
            if not unit or unit:BeenDestroyed() then
                self.UnitSpecialAbilities[unitID] = nil
            else
                for name, ability in abilityTypes do
                    if ability.Enabled ~= false then
                        queue[name] = queue[name] or 0
                        if (ability.AvailableNowUnit or 0) > 0 then
                            queue[name] = queue[name] + 1
                        end
                    end
                end
            end
        end
        for name, data in self.BrainSpecialAbilities do
            if queue[name] then
                data.AvailableNow = queue[name]
                queue[name] = nil
            else
                self.BrainSpecialAbilities[name] = nil
            end
        end
        for name, count in queue do
            self.BrainSpecialAbilities[name] = self.BrainSpecialAbilities[name] or {}
            self.BrainSpecialAbilities[name].AvailableNow = count
        end
    end,

    -- EntityIDs der Einheiten, die die Faehigkeit jetzt nutzen koennen (KI)
    GetUnitsWithAbility = function(self, AbilityName)
        self:EnsureAbilities()
        local list = {}
        for unitID, abilityTypes in self.UnitSpecialAbilities do
            local a = abilityTypes[AbilityName]
            if a and (a.AvailableNowUnit or 0) > 0 and a.Enabled ~= false then
                table.insert(list, unitID)
            end
        end
        return list
    end,

    -- alte Schnittstelle, genutzt von shadow\lua\sim\tasks\NomadsIntelProbeAdvanced.lua
    GetSpecialAbilityParam = function(self, type, param1, param2)
        self:EnsureAbilities()
        local t = self.SpecialAbilities[type]
        if type and param1 and t and t[param1] then
            if param2 and t[param1][param2] then
                return t[param1][param2]
            end
            return t[param1]
        end
        return nil
    end,
}
