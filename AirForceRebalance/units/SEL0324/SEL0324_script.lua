-- Colins Omni-Sensor-Ausbau, repariert, siehe SEL0324_script.md

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

local RadarRestricted =
    type(ScenarioInfo.Options.RestrictedCategories) == 'table' and
    table.find(ScenarioInfo.Options.RestrictedCategories, 'INTEL')

SEL0324 = Class(TLandUnit) {

    Weapons = {
        MissileRack01 = Class(TSAMLauncher) {},
    },

    OnCreate = function(self)
        TLandUnit.OnCreate(self)

        self.Intel = false
        self.Loaded = false
        self.IntelDrain = 0
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TLandUnit.OnStopBeingBuilt(self, builder, layer)

        self.BaseRadarRadius = self:GetIntelRadius('Radar')
        self.BaseOmniRadius  = self:GetIntelRadius('Omni')

        self.RadarRadius = self.BaseRadarRadius
        self.OmniRadius  = self.BaseOmniRadius

        self:SetMaintenanceConsumptionInactive()

        self:SetScriptBit('RULEUTC_IntelToggle', true)

        if RadarRestricted then
            self:RemoveToggleCap('RULEUTC_IntelToggle')
        else
            self:SetScriptBit('RULEUTC_IntelToggle', false)
            self:ForkThread(self.RadarThread)
        end

        self:RequestRefreshUI()
    end,

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

    CreateEnhancement = function(self, enh)
        TLandUnit.CreateEnhancement(self, enh)

        local bp = self:GetBlueprint().Enhancements[enh]

        if enh == 'OmniSensor' then

            self.IntelDrain = bp.MaintenanceConsumptionPerSecondEnergy or 0

            self.RadarRadius = bp.NewRadarRadius
            self.OmniRadius  = bp.NewOmniRadius

            self:SetIntelRadius('Radar', self.RadarRadius)
            self:SetIntelRadius('Omni', self.OmniRadius)

            self:SetEnergyMaintenanceConsumptionOverride(self.IntelDrain)

            if self.Intel then
                self:SetMaintenanceConsumptionActive()
            end

        elseif enh == 'OmniSensorRemove' then

            self.IntelDrain = 0

            self:SetEnergyMaintenanceConsumptionOverride(0)
            self:SetMaintenanceConsumptionInactive()

            self.RadarRadius = self.BaseRadarRadius
            self.OmniRadius  = self.BaseOmniRadius

            self:SetIntelRadius('Radar', self.RadarRadius)
            self:SetIntelRadius('Omni', self.OmniRadius)
        end

        self:RequestRefreshUI()
    end,

    OnIntelEnabled = function(self, intel)
        TLandUnit.OnIntelEnabled(self, intel)
        self.Intel = true

        if self.IntelDrain > 0 then
            self:SetMaintenanceConsumptionActive()
        end
    end,

    OnIntelDisabled = function(self, intel)
        TLandUnit.OnIntelDisabled(self, intel)
        self.Intel = false

        self:SetMaintenanceConsumptionInactive()
    end,

    TransportAnimation = function(self, rate)
        TLandUnit.TransportAnimation(self, rate)

        if not self.Loaded then

            if self.Intel then
                self.mount:SetGoal(-20)
                self.dish:SetGoal(0)
                self.dish2:SetSpinDown(true)

                self:SetIntelRadius('Radar', 0)
                self:SetIntelRadius('Omni', 0)
            end

            self.Loaded = true

        else

            self:SetIntelRadius('Radar', self.RadarRadius)
            self:SetIntelRadius('Omni', self.OmniRadius)

            self.Loaded = nil
        end
    end,
}

TypeClass = SEL0324
