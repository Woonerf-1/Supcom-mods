-- T3 tank - XNL0305 Slugger
local NLandUnit = import('/mods/nomads/lua/nomadsunits.lua').NLandUnit
local PlasmaCannon = import('/mods/nomads/lua/nomadsweapons.lua').PlasmaCannon
local CleanupEffectBag = import('/lua/EffectUtilities.lua').CleanupEffectBag

-- ===========================================================================
-- Cloak helpers (module-local, take self = unit)
-- ===========================================================================
local function SetCloakState(self, state)
    if state then
        self:EnableUnitIntel('Cloak')
        self:EnableUnitIntel('RadarStealth')
        self:SetMaintenanceConsumptionActive()
        if self.IntelEffects and not self.IntelFxOn then
            local bp = self:GetBlueprint()
            if bp.Audio.Cloak then self:PlaySound(bp.Audio.Cloak) end
            self.IntelFxOn = true
            self.IntelEffectsBag = {}
            self.CreateTerrainTypeEffects(self, self.IntelEffects, 'FXIdle', self:GetCurrentLayer(), nil, self.IntelEffectsBag)
        end
    else
        self:DisableUnitIntel('Cloak')
        self:SetMaintenanceConsumptionInactive()
        if self.IntelFxOn then
            local bp = self:GetBlueprint()
            if bp.Audio.Decloak then self:PlaySound(bp.Audio.Decloak) end
            self.IntelFxOn = nil
            CleanupEffectBag(self, 'IntelEffectsBag')
        end
    end
    self:RequestRefreshUI()
end

local function EvaluateCloakEligibility(self)
    if not self.CloakUpgradeActive then return end
    local atFullHealth = self:GetHealth() >= self:GetBlueprint().Defense.MaxHealth
    local canCloak = atFullHealth and not self.FiredRecently
    if canCloak and not self.IntelFxOn then
        SetCloakState(self, true)
    elseif not canCloak and self.IntelFxOn then
        SetCloakState(self, false)
    end
end

-- ===========================================================================
-- Unit class
-- ===========================================================================
---@class XNL0305 : NLandUnit
XNL0305 = Class(NLandUnit) {

    -- The weapon is defined INSIDE the unit class so self.unit is valid
    -- and we can call unit methods directly.
    Weapons = {
        MainGun = Class(PlasmaCannon) {
            CreateProjectileAtMuzzle = function(self, muzzle)
                local unit = self.unit
                -- If the upgrade is active, reset the 30-second cooldown
                if unit and unit.CloakUpgradeActive then
                    unit:OnFiredWeapon()
                end
                PlasmaCannon.CreateProjectileAtMuzzle(self, muzzle)
            end,
        },
    },

    IntelEffects = {
        {
            Bones  = { 0 },
            Offset = { 0, 0, 0 },
            Type   = 'Jammer01',
        },
    },

    -- -------------------------------------------------------------------------
    -- Lifecycle
    -- -------------------------------------------------------------------------
    OnCreate = function(self)
        NLandUnit.OnCreate(self)
        self.FiredRecently      = false
        self.CloakUpgradeActive = false
        self.IntelFxOn          = nil
        self.FireCooldownThread = nil
        self.HealthWatchThread  = nil
        self:RemoveToggleCap('RULEUTC_CloakToggle')
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        NLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:DisableUnitIntel('Cloak')
        self:DisableUnitIntel('RadarStealth')
        self:DisableUnitIntel('SonarStealth')
        self.CloakUpgradeActive = false
        self:RemoveToggleCap('RULEUTC_CloakToggle')
    end,

    OnDestroy = function(self)
        if self.FireCooldownThread then KillThread(self.FireCooldownThread) end
        if self.HealthWatchThread  then KillThread(self.HealthWatchThread)  end
        NLandUnit.OnDestroy(self)
    end,

    -- -------------------------------------------------------------------------
    -- Called by the weapon every time a projectile is created.
    -- Decloaks immediately and restarts the 30-second cooldown.
    -- -------------------------------------------------------------------------
    OnFiredWeapon = function(self)
        -- Kill any existing cooldown so burst fire can't sneak through
        if self.FireCooldownThread then
            KillThread(self.FireCooldownThread)
            self.FireCooldownThread = nil
        end
        -- Decloak immediately
        self.FiredRecently = true
        if self.IntelFxOn then
            SetCloakState(self, false)
        end
        -- Start fresh 30-second wait
        self.FireCooldownThread = ForkThread(self.FireCooldownThread_fn, self)
    end,

    FireCooldownThread_fn = function(self)
        WaitSeconds(30)
        self.FiredRecently = false
        self.FireCooldownThread = nil
        EvaluateCloakEligibility(self)
    end,

    -- -------------------------------------------------------------------------
    -- Damage breaks cloak immediately
    -- -------------------------------------------------------------------------
    OnDamage = function(self, instigator, amount, vector, damageType)
        NLandUnit.OnDamage(self, instigator, amount, vector, damageType)
        if self.CloakUpgradeActive then
            EvaluateCloakEligibility(self)
        end
    end,

    -- Polls every second so regen can re-trigger cloaking automatically
    HealthWatchingThread = function(self)
        while not self.Dead do
            WaitSeconds(1)
            if self.CloakUpgradeActive then
                EvaluateCloakEligibility(self)
            end
        end
    end,

    -- -------------------------------------------------------------------------
    -- Enhancement dispatcher
    -- -------------------------------------------------------------------------
    OnCmdrUpgradeFinished = function(self)
    end,

    ---@param self XNL0305
    ---@param enh string
    CreateEnhancement = function(self, enh)
        NLandUnit.CreateEnhancement(self, enh)

        if enh == 'AdaptiveCamouflage' then
            local bp = self:GetBlueprint().Enhancements.AdaptiveCamouflage
            self.CloakUpgradeActive = true
            self:AddToggleCap('RULEUTC_CloakToggle')
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            if not self.HealthWatchThread then
                self.HealthWatchThread = ForkThread(self.HealthWatchingThread, self)
            end
            EvaluateCloakEligibility(self)
            

        elseif enh == 'AdaptiveCamouflageRemove' then
            self.CloakUpgradeActive = false
            SetCloakState(self, false)
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_CloakToggle')
            if self.HealthWatchThread then
                KillThread(self.HealthWatchThread)
                self.HealthWatchThread = nil
            end
            if self.FireCooldownThread then
                KillThread(self.FireCooldownThread)
                self.FireCooldownThread = nil
            end
            self.FiredRecently = false
        end
    end,

    -- -------------------------------------------------------------------------
    -- Toggle (bit 8 = CloakToggle in FA convention)
    -- -------------------------------------------------------------------------
    OnScriptBitClear = function(self, bit) -- toggle ON
        if bit == 8 then
            if self.CloakUpgradeActive then EvaluateCloakEligibility(self) end
        else
            NLandUnit.OnScriptBitClear(self, bit)
        end
    end,

    OnScriptBitSet = function(self, bit) -- toggle OFF
        if bit == 8 then
            SetCloakState(self, false)
        end
        NLandUnit.OnScriptBitSet(self, bit)
    end,
}

TypeClass = XNL0305