local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

local RadarRestricted =
    type(ScenarioInfo.Options.RestrictedCategories) == 'table' and
    table.find(ScenarioInfo.Options.RestrictedCategories, 'INTEL')

SEL0324 = Class(TLandUnit) {

    Weapons = {
        MissileRack01 = Class(TSAMLauncher) {},
    },

    ------------------------------------------------------------------
    -- Creation
    ------------------------------------------------------------------
    OnCreate = function(self)
        TLandUnit.OnCreate(self)

        self.Intel = false
        self.Loaded = false
        self.IntelDrain = 0
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TLandUnit.OnStopBeingBuilt(self, builder, layer)

        -- save base intel
        self.BaseRadarRadius = self:GetIntelRadius('Radar')
        self.BaseOmniRadius  = self:GetIntelRadius('Omni')

        self:RequestRefreshUI()
    end,

    ------------------------------------------------------------------
    -- Radar animation
    ------------------------------------------------------------------
    RadarThread = function(self)
        self.mount = CreateRotator(self, 'Satellite', 'x', 0, 15, 0)
        self.dish  = CreateRotator(self, 'Dish', 'z', 0, 30, 0)
        self.dish2 = CreateRotator(self, 'Dish', 'y', nil, 0, 15, 90)

        local rotate = 30

        while not self.Dead do
            if not self.Loaded then
                if self.Intel then
                    rotate = -rotate
                    self.mount:SetGoal(rotate - 20)
                    self.dish:SetGoal(rotate)
                    self.dish2:SetSpinDown(false)
                else
                    self.mount:SetGoal(-20)
                    self.dish:SetGoal(0)
                    self.dish2:SetSpinDown(true)
                end
                WaitFor(self.mount)
            end
            coroutine.yield(Random(3, 16))
        end
    end,

    ------------------------------------------------------------------
    -- Enhancements (THIS IS THE FIX)
    ------------------------------------------------------------------
    CreateEnhancement = function(self, enh)
        TLandUnit.CreateEnhancement(self, enh)

        local bp = self:GetBlueprint().Enhancements[enh]

        if enh == 'OmniSensor' then
            -- store drain amount
            self.IntelDrain = bp.MaintenanceConsumptionPerSecondEnergy or 0

            self:SetIntelRadius('Radar', bp.NewRadarRadius)

            self:SetIntelRadius('Omni', bp.NewOmniRadius)


            self:SetEnergyMaintenanceConsumptionOverride(self.IntelDrain)
            self:SetMaintenanceConsumptionActive()

            self:RequestRefreshUI()


        elseif enh == 'OmniSensorRemove' then
            -- stop drain
            self.IntelDrain = 0
            self:SetMaintenanceConsumptionInactive()
            self:SetMaintenanceConsumptionPerSecondEnergy(0)

            -- restore intel
            Buff.ApplyBuff(self, 'ACU_T2_Intel_Package')

            self:RequestRefreshUI()
        end
    end,

    ------------------------------------------------------------------
    -- Intel toggle (controls drain)
    ------------------------------------------------------------------
    OnIntelEnabled = function(self, intel)
        TLandUnit.OnIntelEnabled(self, intel)
        self.Intel = true

        if self.IntelDrain > 0 then
            self:SetMaintenanceConsumptionPerSecondEnergy(self.IntelDrain)
            self:SetMaintenanceConsumptionActive()
        end
    end,

    OnIntelDisabled = function(self, intel)
        TLandUnit.OnIntelDisabled(self, intel)
        self.Intel = false

        self:SetMaintenanceConsumptionInactive()
        self:SetMaintenanceConsumptionPerSecondEnergy(0)
    end,

}

TypeClass = SEL0324
