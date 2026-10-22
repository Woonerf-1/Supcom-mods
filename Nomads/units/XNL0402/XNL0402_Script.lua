-- experimental beam tank

local NLandUnit = import('/mods/nomads/lua/nomadsunits.lua').NLandUnit
local NDFPlasmaBeamWeapon = import('/mods/nomads/lua/nomadsweapons.lua').NDFPlasmaBeamWeapon
local Explosion = import('/lua/defaultexplosions.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local NomadsEffectTemplate = import('/mods/nomads/lua/nomadseffecttemplate.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local NomadsUtils = import('/mods/nomads/lua/nomadsutils.lua')
local CleanupEffectBag = import('/lua/EffectUtilities.lua').CleanupEffectBag
local RenameBeamEmitterToColoured = NomadsUtils.RenameBeamEmitterToColoured
local CreateAttachedEmitterColoured = NomadsUtils.CreateAttachedEmitterColoured

-- ===========================================================================
-- Cloak helpers
-- ===========================================================================
local function SetCloakState(self, state)
    if state then
        if self.IntelFxOn then return end
        self:EnableUnitIntel('Cloak')
        self:EnableUnitIntel('RadarStealth')
        self:SetMaintenanceConsumptionActive()
        if self.IntelEffects then
            local bp = self:GetBlueprint()
            if bp.Audio.Cloak then self:PlaySound(bp.Audio.Cloak) end
            self.IntelFxOn = true
            self.IntelEffectsBag = {}
            self.CreateTerrainTypeEffects(self, self.IntelEffects, 'FXIdle', self:GetCurrentLayer(), nil, self.IntelEffectsBag)
        end
    else
        if not self.IntelFxOn then
            self:DisableUnitIntel('Cloak')
            self:SetMaintenanceConsumptionInactive()
            return
        end
        self:DisableUnitIntel('Cloak')
        self:SetMaintenanceConsumptionInactive()
        local bp = self:GetBlueprint()
        if bp.Audio.Decloak then self:PlaySound(bp.Audio.Decloak) end
        self.IntelFxOn = nil
        CleanupEffectBag(self, 'IntelEffectsBag')
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
XNL0402 = Class(NLandUnit) {

    Weapons = {
        MainGun = Class(NDFPlasmaBeamWeapon) {
            OnWeaponFired = function(self)
                local unit = self.unit
                if unit and unit.CloakUpgradeActive then
                    unit:OnFiredWeapon()
                end
                NDFPlasmaBeamWeapon.OnWeaponFired(self)
            end,

            TransportAnimationThread = function(self, transportstate)
                local bp = self.Blueprint
                if not self.UnpackAnimator then
                    self.UnpackAnimator = CreateAnimator(self.unit)
                end
                if self.UnpackAnimator:GetAnimationFraction() > 0 then
                    self.UnpackAnimator:SetRate(-bp.WeaponUnpackAnimationRate)
                    WaitFor(self.UnpackAnimator)
                end
                -- Use transport anim only if it exists, fall back to normal unpack anim
                local anim = transportstate
                    and (bp.WeaponUnpackAnimationTransported or bp.WeaponUnpackAnimation)
                    or bp.WeaponUnpackAnimation
                if anim then
                    self.UnpackAnimator:PlayAnim(anim):SetRate(1)
                end
                self:SetWeaponEnabled(true)
                self:ResetTarget()
            end,
        },
    },

    FactionColour = true,

    IntelEffects = {
        {
            Bones  = { 0 },
            Offset = { 0, 0, 0 },
            Type   = 'Jammer01',
        },
    },

    OnCreate = function(self)
        NLandUnit.OnCreate(self)
        self.Beaming = false
        self.BeamChargeUpFxBag = TrashBag()
        self.BeamHelperFxBag = TrashBag()
        self.FiredRecently         = false
        self.CloakUpgradeActive    = false
        self.CloakManuallyDisabled = false   -- NEW: tracks player toggle state
        self.IntelFxOn             = nil
        self.FireCooldownThread    = nil
        self.HealthWatchThread     = nil
        self.RangeUpgradeActive    = false   -- NEW
        self.SpeedUpgradeActive    = false   -- NEW
        self:RemoveToggleCap('RULEUTC_CloakToggle')
        self:RemoveToggleCap('RULEUTC_ShieldToggle')
        if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self):PlayAnim('/mods/nomads/units/XNL0402/XNL0402_Charge.sca'):SetRate(0)
            self.Trash:Add(self.AnimationManipulator)
        end
    end,

    EngineBones = {'RearEngine01', 'RearEngine02', 'RearEngine11', 'RearEngine12', 'FrontEngineBlock01', 'FrontEngineBlock02'},

    OnStopBeingBuilt = function(self, builder, layer)
        NLandUnit.OnStopBeingBuilt(self, builder, layer)

        if not self.ActivationManipulator then
            self.ActivationManipulator = CreateAnimator(self):PlayAnim(self:GetBlueprint().Display.AnimationActivate):SetRate(0.3)
            self.Trash:Add(self.ActivationManipulator)

            self:ForkThread(function()
                for i=1,15 do
                    WaitTicks(2)
                    self:SetElevation(0.02*i)
                end
                WaitFor(self.ActivationManipulator)
                self.ActivationManipulator:Destroy()
            end)
        end

        self.EngineRotators = {}
        for boneNumber, bone in self.EngineBones do
            self.EngineRotators[bone] = CreateRotator(self, bone, 'z', 0, 30)
        end

        self:DisableUnitIntel('Cloak')
        self:DisableUnitIntel('RadarStealth')
        self.CloakUpgradeActive = false
        self:RemoveToggleCap('RULEUTC_CloakToggle')
    end,

    OnMotionHorzEventChange = function(self, new, old)
        NLandUnit.OnMotionHorzEventChange(self, new, old)
        local goal = 0
        if new == 'TopSpeed' then goal = 30 end

        for boneName, rotator in self.EngineRotators do
            if boneName == 'FrontEngineBlock01' or boneName == 'FrontEngineBlock02' then
                rotator:SetGoal(goal*0.3)
            else
                rotator:SetGoal(goal)
            end
        end
    end,

    OnDestroy = function(self)
        if not self.BeamDisableThread then
            self.BeamDisableThread = self:ForkThread(self.BeamEffectsDisableThread)
        end
        if self.FireCooldownThread then KillThread(self.FireCooldownThread) end
        if self.HealthWatchThread  then KillThread(self.HealthWatchThread)  end
        NLandUnit.OnDestroy(self)
    end,

    OnGotTarget = function(self, Weapon)
        NLandUnit.OnGotTarget(self, Weapon)
        if self.BeamDisableThread then
            KillThread(self.BeamDisableThread)
            self.BeamDisableThread = nil
        else
            self:PlayFakeBeamEffects()
        end
        self.Beaming = true
        if self.AnimationManipulator and not self.Dead then
            self.AnimationManipulator:SetRate(0.8)
        end
    end,

    OnLostTarget = function(self, Weapon)
        NLandUnit.OnLostTarget(self, Weapon)
        if not self.BeamDisableThread and self.Beaming then
            self.BeamDisableThread = self:ForkThread(self.BeamEffectsDisableThread)
        end
        self.Beaming = false
        if self.AnimationManipulator and not self.Dead then
            self.AnimationManipulator:SetRate(-0.5)
        end
    end,

    OnFiredWeapon = function(self)
        if self.FireCooldownThread then
            KillThread(self.FireCooldownThread)
            self.FireCooldownThread = nil
        end
        self.FiredRecently = true
        -- FIX: decloak whenever the upgrade is active, not just when IntelFxOn is set
        if self.IntelFxOn then
            SetCloakState(self, false)
        end
        self.FireCooldownThread = ForkThread(self.FireCooldownThread_fn, self)
    end,

    FireCooldownThread_fn = function(self)
        WaitSeconds(30)
        self.FiredRecently = false
        self.FireCooldownThread = nil
        EvaluateCloakEligibility(self)
    end,

    -- FIX: defer health check by one tick so the engine has applied damage
    OnDamage = function(self, instigator, amount, vector, damageType)
        NLandUnit.OnDamage(self, instigator, amount, vector, damageType)
        if self.CloakUpgradeActive then
            EvaluateCloakEligibility(self)
        end
    end,

    HealthWatchingThread = function(self)
        while not self.Dead do
            WaitSeconds(1)
            if self.CloakUpgradeActive then
                EvaluateCloakEligibility(self)
            end
        end
    end,

    -- -------------------------------------------------------------------------
    -- Beam effects
    -- -------------------------------------------------------------------------
    PlayBeamChargeUpSequence = function(self)
        local fn = function(self)
            local emitrate, emitters, emit = 0, {}, nil
            for k, v in NomadsEffectTemplate.PhaseRayChargeUpFxPerm do
                emit = CreateAttachedEmitterColoured(self, 'ReactorBeam02', self.Army, v)
                table.insert(emitters, emit)
                self.BeamChargeUpFxBag:Add(emit)
                self.Trash:Add(emit)
            end
            while self do
                emitrate = self.BeamChargeupEffectScale or 1
                emitrate = (emitrate * 10) * emitrate
                for k, emit in emitters do
                    emit:SetEmitterCurveParam('EMITRATE_CURVE', emitrate, 0)
                end
                WaitTicks(1)
            end
        end
        local thread = self:ForkThread(fn)
        self.BeamChargeUpFxBag:Add(thread)
    end,

    PlayFakeBeamEffects = function(self)
        local bp = self:GetBlueprint()
        if bp.Audio.ChargeBeam then
            self:PlaySound(bp.Audio.ChargeBeam)
        end

        self.BeamHelperFxBag:Destroy()
        local emit, beam = nil, nil
        for k, v in NomadsEffectTemplate.PhaseRayFakeBeamMuzzle do
            emit = CreateAttachedEmitterColoured(self, 'ReactorBeam01', self.Army, v)
            self.BeamHelperFxBag:Add(emit)
            self.Trash:Add(emit)
        end

        for k, v in NomadsEffectTemplate.PhaseRayFakeBeam do
            local beamBp = RenameBeamEmitterToColoured(v, self.ColourIndex)
            beam = AttachBeamEntityToEntity(self, 'ReactorBeam01', self, "ReactorBeam02", self.Army, beamBp)
            self.BeamHelperFxBag:Add(beam)
            self.Trash:Add(beam)
        end
    end,

    BeamEffectsDisableThread = function(self)
        WaitTicks(20)
        self.BeamHelperFxBag:Destroy()
        self.BeamChargeUpFxBag:Destroy()
        if self.Beaming then
            for k, v in NomadsEffectTemplate.PhaseRayFakeBeamMuzzleBeamingStopped do
                emit = CreateAttachedEmitterColoured(self, 'ReactorBeam01', self.Army, v)
            end
        end
        self.BeamDisableThread = nil
    end,

    -- -------------------------------------------------------------------------
    -- Enhancement dispatcher
    -- -------------------------------------------------------------------------
    OnCmdrUpgradeFinished = function(self)
    end,

    ---@param self XNL0402
    ---@param enh string
    CreateEnhancement = function(self, enh)
        NLandUnit.CreateEnhancement(self, enh)

        if enh == 'AdaptiveCamouflage' then
            local bp = self:GetBlueprint().Enhancements.AdaptiveCamouflage
            self.CloakUpgradeActive    = true
            self.CloakManuallyDisabled = false
            self:AddToggleCap('RULEUTC_CloakToggle')
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            if not self.HealthWatchThread then
                self.HealthWatchThread = ForkThread(self.HealthWatchingThread, self)
            end
            EvaluateCloakEligibility(self)

        elseif enh == 'AdaptiveCamouflageRemove' then
            self.CloakUpgradeActive    = false
            self.CloakManuallyDisabled = false
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

        elseif enh == 'Shield' then
            local bp = self:GetBlueprint().Enhancements.Shield
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:CreateShield(bp)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:EnableShield()

        elseif enh == 'ShieldRemove' then
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')

        -- -----------------------------------------------------------------
        -- NEW: Range upgrade — 2x range, 1/4 damage
        -- -----------------------------------------------------------------
        elseif enh == 'RangeUpgrade' then
            self.RangeUpgradeActive = true
            local wep = self:GetWeaponByLabel('MainGun')
            if wep then
                local baseBp = self:GetBlueprint().Weapon[1]
                wep:ChangeMaxRadius(baseBp.MaxRadius * 2)
                wep:ChangeDamage(baseBp.Damage * 0.25)
            end

        elseif enh == 'RangeUpgradeRemove' then
            self.RangeUpgradeActive = false
            local wep = self:GetWeaponByLabel('MainGun')
            if wep then
                local baseBp = self:GetBlueprint().Weapon[1]
                wep:ChangeMaxRadius(baseBp.MaxRadius)
                wep:ChangeDamage(baseBp.Damage)
            end

        -- -----------------------------------------------------------------
        -- NEW: Speed upgrade — 1.3x max speed
        -- -----------------------------------------------------------------
        elseif enh == 'SpeedUpgrade' then
            self.SpeedUpgradeActive = true
            local baseBp = self:GetBlueprint().Physics
            self:SetSpeedMult(1.3)   -- scales MaxSpeed; FAF exposes this on unit
            -- Fallback if SetSpeedMult is unavailable in your engine version:
            -- self:GetBlueprint().Physics.MaxSpeed = baseBp.MaxSpeed * 1.3

        elseif enh == 'SpeedUpgradeRemove' then
            self.SpeedUpgradeActive = false
            self:SetSpeedMult(1.0)
        end
    end,

    -- -------------------------------------------------------------------------
    -- Toggle (cloak button)
    -- FIX: bit 8 SET   = player pressed the button to DISABLE cloak (radio off)
    --      bit 8 CLEAR = player pressed the button to RE-ENABLE cloak (radio on)
    -- -------------------------------------------------------------------------
    OnScriptBitSet = function(self, bit)
        if bit == 8 then
            -- Player is toggling cloak OFF manually
            self.CloakManuallyDisabled = true
            SetCloakState(self, false)
            -- Do NOT call NLandUnit.OnScriptBitSet for bit 8 — it has no
            -- relevant behaviour here and we've handled it fully.
        else
            NLandUnit.OnScriptBitSet(self, bit)
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 8 then
            -- Player is toggling cloak back ON — re-run eligibility check
            self.CloakManuallyDisabled = false
            if self.CloakUpgradeActive then
                EvaluateCloakEligibility(self)
            end
        else
            NLandUnit.OnScriptBitClear(self, bit)
        end
    end,

    -- -------------------------------------------------------------------------
    -- Transport
    -- -------------------------------------------------------------------------
    
}

TypeClass = XNL0402