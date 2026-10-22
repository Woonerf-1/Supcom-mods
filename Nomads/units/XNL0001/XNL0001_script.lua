-- Nomads ACU

local Entity = import('/lua/sim/Entity.lua').Entity
local Buff = import('/lua/sim/Buff.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Utilities = import('/lua/utilities.lua')
local NomadsEffectUtil = import('/mods/nomads/lua/nomadseffectutilities.lua')

local NUtils = import('/mods/nomads/lua/nomadsutils.lua')
local Utils = import('/lua/utilities.lua')
local CreateOrbitalUnit = NUtils.CreateOrbitalUnit

local AddCapacitorAbility = NUtils.AddCapacitorAbility
local AddCapacitorAbilityToWeapon = NUtils.AddCapacitorAbilityToWeapon

local NWeapons = import('/mods/nomads/lua/nomadsweapons.lua')
local APCannon1 = NWeapons.APCannon1
local APCannon1_Overcharge = NWeapons.APCannon1_Overcharge
local DeathNuke = NWeapons.DeathNuke
local NIFTargetFinderWeapon = import('/mods/nomads/lua/nomadsweapons.lua').NIFTargetFinderWeapon

APCannon1 = AddCapacitorAbilityToWeapon(APCannon1)
APCannon1_Overcharge = AddCapacitorAbilityToWeapon(APCannon1_Overcharge)

local ACUUnit = import('/lua/defaultunits.lua').WalkingLandUnit
-- local ACUUnit = import('/lua/defaultunits.lua').WalkingLandUnit

-- replace the commented out line with:
local ACUUnit = AddCapacitorAbility(import('/lua/defaultunits.lua').WalkingLandUnit)


--LOUD SHIT
local AWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local AWeapons = import('/lua/aeonweapons.lua')
local AeonBuffField = import('/lua/aeonweapons.lua').AeonBuffField


local TrashBag = TrashBag
local TrashAdd = TrashBag.Add
local TrashDestroy = TrashBag.Destroy


local ADFOverchargeWeapon       = AWeapons.ADFOverchargeWeapon
local ADFDisruptorCannonWeapon  = AWeapons.ADFDisruptorCannonWeapon
local ADFChronoDampener         = AWeapons.ADFChronoDampener
local AIFCommanderDeathWeapon   = AWeapons.AIFCommanderDeathWeapon

AWeapons = nil

local EffectTemplate    = import('/lua/EffectTemplates.lua')
local EffectUtil        = import('/lua/EffectUtilities.lua')

local CreateAeonCommanderBuildingEffects = EffectUtil.CreateAeonCommanderBuildingEffects



XNL0001 = Class(ACUUnit) {

    BuffFields = {
        DamageField1  = Class(AeonBuffField) { OnCreate = function(self) AeonBuffField.OnCreate(self) end },
        DamageField2 = Class(AeonBuffField) { OnCreate = function(self) AeonBuffField.OnCreate(self) end },
        DamageField3 = Class(AeonBuffField) { OnCreate = function(self) AeonBuffField.OnCreate(self) end },
    }, 

    Weapons = {
        MainGun = Class(APCannon1) {
            CreateProjectileAtMuzzle = function(self, muzzle)
                if self.unit.DoubleBarrels then
                    APCannon1.CreateProjectileAtMuzzle(self, 'Muzzle2')
                end
                return APCannon1.CreateProjectileAtMuzzle(self, muzzle)
            end,

            CapGetWepAffectingEnhancementBP = function(self)
                if self.unit:HasEnhancement('DoubleGuns') then
                    return self.unit:GetBlueprint().Enhancements['DoubleGuns']
                elseif self.unit:HasEnhancement('GunUpgrade') then
                    return self.unit:GetBlueprint().Enhancements['GunUpgrade']
                else
                    return {}
                end
            end,
        },


        DeathWeapon = Class(DeathNuke) {},
        TargetFinder = Class(NIFTargetFinderWeapon) {},
    },

    init = function(self)
        ACUUnit.init(self, 'MainGun')
    end,

    -- =====================================================================================================================
    -- CREATION AND FIRST SECONDS OF GAMEPLAY

    CapFxBones = { 'CapacitorL', 'CapacitorR', },
    


    OnCreate = function(self)
        ACUUnit.OnCreate(self)
        --if the acu is spawned in, find an orbital unit that works.
        self:GetOrbitalUnit()
        
        self.NukeEntity = 1 --leave a value for the death explosion entity to use later.

        --create capacitor sliders:
        self.CapSliders = {}
        table.insert(self.CapSliders, CreateSlider(self, 'CapacitorL'))
        table.insert(self.CapSliders, CreateSlider(self, 'CapacitorR'))
        for number,slider in self.CapSliders do
            slider:SetGoal(0, -1, 0 )
            slider:SetSpeed(1)
        end

        local bp = self:GetBlueprint()

        -- TODO: Remove once related change gets released in the game patch
        self.BuildEffectBones = bp.General.BuildBones.BuildEffectBones

        -- vars
        self.DoubleBarrels = false
        self.DoubleBarrelOvercharge = false
        self.EnhancementBoneEffectsBag = {}
        self.HeadRotationEnabled = false -- disable head rotation to prevent initial wrong rotation
        self.AllowHeadRotation = false
        self.UseRunWalkAnim = false
        self.MaelstromFieldName = false
        self.MaelstromFieldOn = false
        self.MaelstromFieldRadius = 1
        self.wcChrono01 = false
        self.wcChrono02 = false
        self.EnergyConsumption = { Total = 0, Back = 0, Command = 0, LCH = 0, RCH = 0 }

        -- model
        self:HideBone('IntelProbe1', true)
        self:HideBone('IntelProbe2', true)
        self:HideBone('Gun2', true)
        self:HideBone('PowerArmor', true)
        self:HideBone('Locomotion', true)
        self:HideBone('Orbital Bombardment', true)
        self:HideBone('BuildArm2', true)
        self:HideBone('BuildArm3', true)--these need to be updated in the other list as well, maybe add a function for this?

        self.HeadRotManip = CreateRotator(self, 'Head', 'y', nil):SetCurrentAngle(0)
        self.Trash:Add(self.HeadRotManip)

        -- properties
        self:SetCapturable(false)
        self:SetupBuildBones()

        -- enhancements
        self:RemoveToggleCap('RULEUTC_SpecialToggle')
        self:AddBuildRestriction( categories.NOMADS * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER) )
        

        
        self.Sync.Abilities = self:GetBlueprint().Abilities

        self.MassProduction = bp.Economy.ProductionPerSecondMass
        self.EnergyProduction = bp.Economy.ProductionPerSecondEnergy
        self.RASMassProductionLow = bp.Enhancements.ResourceAllocation.ProductionPerSecondMassLow
        self.RASEnergyProductionLow = bp.Enhancements.ResourceAllocation.ProductionPerSecondEnergyLow
        self.RASMassProductionHigh = bp.Enhancements.ResourceAllocation.ProductionPerSecondMassHigh
        self.RASEnergyProductionHigh = bp.Enhancements.ResourceAllocation.ProductionPerSecondEnergyHigh
        
    end,
    -- Add to OnStopBeingBuilt
    OnStopBeingBuilt = function(self, builder, layer)
        ACUUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetWeaponEnabledByLabel('MainGun', true)
        self:SetWeaponEnabledByLabel('TargetFinder', false)
        self:ForkThread(self.GiveInitialResources)
        self:ForkThread(self.HeadRotationThread)
        self.AllowHeadRotation = true
        
        -- Initialize capacitor state
        self.CapChargeFraction = 0
        self.CapChargeEnergy = 0
        self.Sync.CapacitorState = 'unfilled'
        self.CapacitorActive = false
        self.CapChargeThread = nil
        self.CapActiveThread = nil
        self.Sync.AutoCapacitor = false
        
        self.SpysatEnabled = false
        self.IntelPackage = false
        self.IntelPackageOn = false
        self:RemoveToggleCap('RULEUTC_IntelToggle')
        self:RemoveToggleCap('RULEUTC_SpecialToggle')
        self.CapChargingEnabled = false
        self.AutoRefill = false
    end,

    -- Duration of capacitor buff
    CapacitorActiveThread = function(self)

        local bp = self:GetBlueprint().Abilities.Capacitor

        local duration = bp.Duration or 20
        local decayTime = bp.DecayTime or 8

        self.Sync.CapacitorState = 'filled'

        local tick = 0.1
        local steps = duration / tick
        local drainPerStep = 1 / steps

        while self.CapChargeFraction > 0 and self.CapacitorActive do

            self.CapChargeFraction = math.max(
                0,
                self.CapChargeFraction - drainPerStep
            )

            self:UpdateCapacitorFraction()

            WaitSeconds(tick)
        end

        for _, buffName in ipairs(bp.Buffs or {}) do
            Buff.RemoveBuff(self, buffName)
        end

        self.CapacitorActive = false

        self.Sync.CapacitorState = 'discharging'

        WaitSeconds(decayTime)

        self.CapChargeFraction = 0
        self.CapChargeEnergy = 0

        self:UpdateCapacitorFraction()

        self.Sync.CapacitorState = 'unfilled'

        self.CapActiveThread = nil

    end,

    -- Activate capacitor - apply buffs
    ActivateCapacitor = function(self)

        if self.Sync.CapacitorState ~= 'Filled' then
            return
        end

        if self.CapDischargeThread then
            KillThread(self.CapDischargeThread)
        end

        self.Sync.CapacitorState = 'Discharging'
        self.CapacitorSwitchStates['Filled'](self)
    end,

    
    CapacitorDecayThread = function(self)

        while self.CapChargeFraction > 0 do

            self.CapChargeFraction = self.CapChargeFraction - (0.1 / self.CapacitorDecayTime)

            if self.CapChargeFraction < 0 then
                self.CapChargeFraction = 0
            end

            self:UpdateCapacitorFraction()

            WaitTicks(1)
        end

        self.CapChargeFraction = 0

        self:UpdateCapacitorFraction()

        self.Sync.CapacitorState = 'Unfilled'
    end,


    CapacitorMonitorThread = function(self)

        local GetEconomyIncome    = moho.aibrain_methods.GetEconomyIncome
        local GetEconomyRequested = moho.aibrain_methods.GetEconomyRequested
        local aiBrain             = self:GetAIBrain()

        local buffsApplied = false

        while self.Sync.HasCapacitorAbility and not self.Dead do

            local state = self.Sync.CapacitorState

            -- Apply buffs whenever Filled or Discharging, remove otherwise
            if (state == 'Filled' or state == 'Discharging') then
                if not buffsApplied then
                    Buff.ApplyBuff(self, 'CapacitorEngineering')
                    Buff.ApplyBuff(self, 'CapacitorIntel')
                    Buff.ApplyBuff(self, 'CapacitorRegen')
                    Buff.ApplyBuff(self, 'CapacitorROF')
                    buffsApplied = true
                end
            else
                if buffsApplied then
                    if Buff.HasBuff(self, 'CapacitorEngineering') then Buff.RemoveBuff(self, 'CapacitorEngineering') end
                    if Buff.HasBuff(self, 'CapacitorIntel')       then Buff.RemoveBuff(self, 'CapacitorIntel')       end
                    if Buff.HasBuff(self, 'CapacitorRegen')       then Buff.RemoveBuff(self, 'CapacitorRegen')       end
                    if Buff.HasBuff(self, 'CapacitorROF')         then Buff.RemoveBuff(self, 'CapacitorROF')         end
                    buffsApplied = false
                end
            end

            -- Discharge trigger — only when Filled and genuinely out of power
            if state == 'Filled' then
                local overflow = GetEconomyIncome(aiBrain, 'ENERGY')
                            - GetEconomyRequested(aiBrain, 'ENERGY')

                if overflow < 1 then
                    self:ForkThread(self.CapacitorDischargeThread)

                    while self.Sync.CapacitorState ~= 'Unfilled'
                        and self.Sync.HasCapacitorAbility
                        and not self.Dead do
                        WaitTicks(10)
                    end
                end
            end

            WaitTicks(10)
        end

        -- Clean up if enhancement removed while active
        if buffsApplied then
            if Buff.HasBuff(self, 'CapacitorEngineering') then Buff.RemoveBuff(self, 'CapacitorEngineering') end
            if Buff.HasBuff(self, 'CapacitorIntel')       then Buff.RemoveBuff(self, 'CapacitorIntel')       end
            if Buff.HasBuff(self, 'CapacitorRegen')       then Buff.RemoveBuff(self, 'CapacitorRegen')       end
            if Buff.HasBuff(self, 'CapacitorROF')         then Buff.RemoveBuff(self, 'CapacitorROF')         end
        end
    end,
    


    -- =========================================================================
    -- ENERGY STALL — exact same trigger the engine uses for shields/intel
    -- =========================================================================
    OnEnergyDepleted = function(self)
        if ACUUnit.OnEnergyDepleted then
            ACUUnit.OnEnergyDepleted(self)
        end

        if self.Sync.HasCapacitorAbility
        and self.Sync.CapacitorState == 'Filled'
        and not self.Dead then
            self:ForkThread(self.CapacitorDischargeThread)
        end
    end,

    OnEnergyRestored = function(self)
        if ACUUnit.OnEnergyRestored then
            ACUUnit.OnEnergyRestored(self)
        end
        -- charge thread restarts naturally after discharge completes
        -- nothing extra needed here
    end,

    ApplyCapacitorBuffs = function(self)

        -- =========================================================================
        -- CAPACITOR BUFF DEFINITIONS
        -- =========================================================================
        BuffBlueprint {
            Name = 'CapacitorEngineering',
            DisplayName = 'Capacitor Engineering Boost',
            BuffType = 'CAPACITORENG',
            Stacks = 'REPLACE',
            Duration = -1,
            Affects = {
                BuildRate = {
                    Add = 0,
                    Mult = 2.5,
                },
            },
        }

        BuffBlueprint {
            Name = 'CapacitorIntel',
            DisplayName = 'Capacitor Intel Boost',
            BuffType = 'CAPACITORINTEL',
            Stacks = 'REPLACE',
            Duration = -1,
            Affects = {
                VisionRadius = {
                    Add = 0,
                    Mult = 1.5,
                },
                RadarRadius = {
                    Add = 0,
                    Mult = 1.5,
                },
                OmniRadius = {
                    Add = 0,
                    Mult = 1.5,
                },
            },
        }

        BuffBlueprint {
            Name = 'CapacitorRegen',
            DisplayName = 'Capacitor Regen Boost',
            BuffType = 'CAPACITORREGEN',
            Stacks = 'REPLACE',
            Duration = -1,
            Affects = {
                Regen = {
                    Add = 150,
                    Mult = 1.0,
                },
            },
        }

        BuffBlueprint {
            Name = 'CapacitorROF',
            DisplayName = 'Capacitor ROF Boost',
            BuffType = 'CAPACITORROF',
            Stacks = 'REPLACE',
            Duration = -1,
            Affects = {
                RateOfFire = {
                    Add = 0,
                    Mult = 1.5,
                },
            },
        }

        Buff.ApplyBuff(self, 'CapacitorEngineering')
        Buff.ApplyBuff(self, 'CapacitorIntel')
        Buff.ApplyBuff(self, 'CapacitorRegen')
        Buff.ApplyBuff(self, 'CapacitorROF')
    end,

    RemoveCapacitorBuffs = function(self)
        if Buff.HasBuff(self, 'CapacitorEngineering') then Buff.RemoveBuff(self, 'CapacitorEngineering') end
        if Buff.HasBuff(self, 'CapacitorIntel')       then Buff.RemoveBuff(self, 'CapacitorIntel')       end
        if Buff.HasBuff(self, 'CapacitorRegen')        then Buff.RemoveBuff(self, 'CapacitorRegen')        end
        if Buff.HasBuff(self, 'CapacitorROF')          then Buff.RemoveBuff(self, 'CapacitorROF')          end
    end,

    -- =========================================================================
    -- CAPACITOR — Filled: apply buffs immediately, no energy pumping yet
    -- =========================================================================
    Filled = function(self)
        self:PlayCapEffects(self.CapFxBeingUsedTemplate)
        self:PlayUnitSound('CapacitorStartBeingUsed')
        self.Sync.CapacitorState = 'Filled'
        self:ApplyCapacitorBuffs()
    end,


    RemoveCapacitorBuffs = function(self)
        local bp = __blueprints[self.BlueprintID].Abilities.Capacitor

        for _, buffName in ipairs(bp.Buffs or {}) do
            if Buff.HasBuff(self, buffName) then
                Buff.RemoveBuff(self, buffName)
            end
        end

        -- restore intel radii to blueprint defaults
        local ibp = self:GetBlueprint().Intel
        self:SetIntelRadius('Vision', ibp.VisionRadius or 0)
        self:SetIntelRadius('Radar',  ibp.RadarRadius     or 0)
        self:SetIntelRadius('Omni',   ibp.OmniRadius      or 0)
    end,


    CapacitorChargeThread = function(self)
        local bp         = __blueprints[self.BlueprintID].Abilities.Capacitor
        local chargeTime = bp.ChargeTime or 240
        local chargeStep = 1.0 / chargeTime

        -- Set charge costs
        self:SetEnergyMaintenanceConsumptionOverride(10000)
        self:SetMaintenanceConsumptionActive()
        self:SetConsumptionPerSecondMass(25)   -- ADD THIS LINE
        
        self.Sync.CapacitorState = 'Charging'

        while self.Sync.HasCapacitorAbility and not self.Dead
            and self.Sync.CapacitorState == 'Charging' do

            self.CapChargeFraction = math.min(1, self.CapChargeFraction + chargeStep)
            self:UpdateCapacitorFraction()

            if self.CapChargeFraction >= 1 then
                self.CapChargeFraction = 1
                self:UpdateCapacitorFraction()
                self:SetMaintenanceConsumptionInactive()
                self:SetConsumptionPerSecondMass(0)   -- AND THIS LINE
                self.Sync.CapacitorState = 'Filled'

                if self.CapacitorSwitchStates and self.CapacitorSwitchStates['Charging'] then
                    self.CapacitorSwitchStates['Charging'](self)
                end

                return
            end

            WaitSeconds(1)
        end

        self:SetMaintenanceConsumptionInactive()
        self:SetConsumptionPerSecondMass(0)   -- AND THIS LINE for the cancelled-charge case
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        ACUUnit.OnStartBuild(self, unitBeingBuilt, order)

        if self.Sync.HasCapacitorAbility
        and self.Sync.CapacitorState == 'Filled'
        and not self.Dead then
            self:ForkThread(self.CapacitorDischargeThread)
        end
    end,

    CapacitorDischargeThread = function(self)
        local bp         = __blueprints[self.BlueprintID].Abilities.Capacitor
        local drainTime  = bp.Duration or 60
        local drainStep  = 1.0 / drainTime

        local baseProd      = __blueprints[self.BlueprintID].Economy.ProductionPerSecondEnergy
        local basemassProd  = __blueprints[self.BlueprintID].Economy.ProductionPerSecondMass

        self.Sync.CapacitorState = 'Discharging'

        -- Apply buffs
        Buff.ApplyBuff(self, 'CapacitorEngineering')
        Buff.ApplyBuff(self, 'CapacitorIntel')
        Buff.ApplyBuff(self, 'CapacitorRegen')
        Buff.ApplyBuff(self, 'CapacitorROF')

        -- Pump resources into economy
        self:SetProductionPerSecondEnergy(baseProd + 5000)
        self:SetProductionPerSecondMass(basemassProd + 330)

        while self.CapChargeFraction > 0
            and self.Sync.HasCapacitorAbility
            and not self.Dead do

            self.CapChargeFraction = math.max(0, self.CapChargeFraction - drainStep)
            self:UpdateCapacitorFraction()

            WaitSeconds(1)
        end

        self.CapChargeFraction = 0
        self:UpdateCapacitorFraction()

        -- Stop resource pumping
        self:SetProductionPerSecondEnergy(baseProd)
        self:SetProductionPerSecondMass(basemassProd)

        -- Remove buffs
        if Buff.HasBuff(self, 'CapacitorEngineering') then Buff.RemoveBuff(self, 'CapacitorEngineering') end
        if Buff.HasBuff(self, 'CapacitorIntel')       then Buff.RemoveBuff(self, 'CapacitorIntel')       end
        if Buff.HasBuff(self, 'CapacitorRegen')       then Buff.RemoveBuff(self, 'CapacitorRegen')       end
        if Buff.HasBuff(self, 'CapacitorROF')         then Buff.RemoveBuff(self, 'CapacitorROF')         end

        self.Sync.CapacitorState = 'Unfilled'

        if self.CapacitorSwitchStates and self.CapacitorSwitchStates['Discharging'] then
            self.CapacitorSwitchStates['Discharging'](self)
        end

        -- Auto restart charge
        if self.Sync.HasCapacitorAbility and not self.Dead then
            self.CapChargeThread = self:ForkThread(self.CapacitorChargeThread)
        end
    end,
    



    -- Toggle auto-capacitor mode
    SetAutoCapacitor = function(self, auto)
        self.Sync.AutoCapacitor = auto
        
        -- If auto mode just turned on and capacitor is full, activate it
        if auto and self.CapChargeFraction >= 1 and not self.CapacitorActive then
            self:ActivateCapacitor()
        end
    end,

    GetOrbitalUnit = function(self)
        if self.OrbitalUnit then return end

        local pos = self:GetPosition()
        local r = 500
        local rect = Rect(pos[1]-r, pos[3]-r, pos[1]+r, pos[3]+r)
        local units = GetUnitsInRect(rect) or {}

        LOG('XNL0001: GetOrbitalUnit searching, found '..tostring(table.getn(units))..' units nearby')

        for _, unit in units do
            if not unit.Dead 
                and unit.Army == self.Army 
                and unit.BlueprintID == 'xno0001' 
                and not unit.AssignedUnit then
                self.OrbitalUnit = unit
                LOG('XNL0001: Found existing orbital unit')
                break
            end
        end

        if not self.OrbitalUnit then
            LOG('XNL0001: Creating new orbital unit')
            self.OrbitalUnit = CreateOrbitalUnit(self)
            LOG('XNL0001: Orbital unit created: '..tostring(self.OrbitalUnit ~= nil))
        end
    end,

    -- =====================================================================================================================
    -- UNIT DEATH

    OnKilled = function(self, instigator, type, overkillRatio)
        self:SetOrbitalBombardEnabled(false)
        if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
            self.Satellite:Kill()
			self.Satellite = nil
        end
        if self.OrbitalUnit then self.OrbitalUnit.AssignedUnit = nil end
        ACUUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    CreateBuildEffects = function(self, unitBeingBuilt, order)
        NomadsEffectUtil.CreateNomadsBuildSliceBeams(self, unitBeingBuilt, __blueprints[self.BlueprintID].General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,

    CreateReclaimEffects = function(self, target)
        NomadsEffectUtil.PlayNomadsReclaimEffects(self, target, self.BuildEffectBones, self.ReclaimEffectsBag)
    end,

    CreateReclaimEndEffects = function(self, target)
        NomadsEffectUtil.PlayNomadsReclaimEndEffects(self, target, self.ReclaimEffectsBag)
    end,

    -- =====================================================================================================================
    -- GENERIC

    OnMotionHorzEventChange = function( self, new, old )
        if old == 'Stopped' and self.UseRunWalkAnim then
            local bp = self:GetBlueprint()
            if bp.Display.AnimationRun then
                if not self.Animator then
                    self.Animator = CreateAnimator(self, true)
                end
                self.Animator:PlayAnim(bp.Display.AnimationRun, true)
                self.Animator:SetRate(bp.Display.AnimationRunRate or 1)
            else
                ACUUnit.OnMotionHorzEventChange(self, new, old)
            end
        else
            ACUUnit.OnMotionHorzEventChange(self, new, old)
        end
    end,


    -- Adjust position of the capacitor sliders to match the charge.
    UpdateCapacitorFraction = function(self)
        ACUUnit.UpdateCapacitorFraction(self)  -- this calls the mixin version, good
        for number,slider in self.CapSliders do
            slider:SetGoal(0, self.CapChargeFraction-1, 0)
            slider:SetSpeed(1)
        end
    end,

    -- =====================================================================================================================
    -- EFFECTS AND ANIMATIONS

    -------- INITIAL ANIM --------

    DoMeteorAnim = function(self)  -- part of initial dropship animation
        if not self.OrbitalUnit then
            self.OrbitalUnit = CreateOrbitalUnit(self)
        end

        self.PlayCommanderWarpInEffectFlag = false
        self:HideBone(0, true)
        self:SetWeaponEnabledByLabel('MainGun', false)

        local meteor = self:CreateProjectile('/mods/nomads/effects/Entities/NomadsACUDropMeteor/NomadsACUDropMeteor_proj.bp')
        self.Trash:Add(meteor)
        meteor:Start(self:GetPosition(), 2) 

        WaitTicks(23) -- Landing Animation

        self:ShowBone(0, true)
        self:HideBone('IntelProbe1', true)
        self:HideBone('IntelProbe2', true)
        self:HideBone('Gun2', true)
        self:HideBone('PowerArmor', true)
        self:HideBone('Locomotion', true)
        self:HideBone('Orbital Bombardment', true)
        self:HideBone('BuildArm2', true)
        self:HideBone('BuildArm3', true)--these need to be updated in the other list as well, maybe add a function for this?

        local totalBones = self:GetBoneCount() - 1
        for k, v in EffectTemplate.UnitTeleportSteam01 do
            for bone = 1, totalBones do
                CreateAttachedEmitter(self, bone, self.Army, v)
            end
        end


        WaitTicks(7)  -- Sync With Other ACUs

        self:SetWeaponEnabledByLabel('MainGun', true)
        self:SetUnSelectable(false)
        self:SetBusy(false)
        self:SetBlockCommandQueue(false)
    end,

    PlayCommanderWarpInEffect = function(self)  -- part of initial dropship animation
        self:SetUnSelectable(true)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self.PlayCommanderWarpInEffectFlag = true
        self:ForkThread(self.DoMeteorAnim)
    end,

    EXSatSpawn = function(self)

        while self.SpysatEnabled and self.IntelPackageOn and not self.Dead do
	
			local location = self:GetPosition('IntelProbe1')
			
			self.Satellite = CreateUnitHPR('XEA0002', self:GetArmy(), location[1], location[2], location[3], 0,0,0 )

			self.Satellite:AttachTo(self, 'IntelProbe1')
			
			TrashAdd( self.Trash, self.Satellite )
			
			self.Satellite.Parent = self
			self.Satellite:SetParent(self, 'SpySat')
			
			self:PlayUnitSound('LaunchSat')
			
			self.Satellite:DetachFrom()
			self.Satellite:Open()
            
			-- for respawns --
			while not self.Satellite.Dead and self.IntelPackageOn do
				WaitTicks(100)
			end
	
        end
    end,

    HeadRotationThread = function(self)
        -- keeps the head pointed at the current target (position)
        local nav = self:GetNavigator()
        local maxRot = self:GetBlueprint().Display.MovementEffects.HeadRotationMax or 10
        local wep = self:GetWeaponByLabel('MainGun')
        local GoalAngle = 0
        local target, torsoDir, torsoX, torsoY, torsoZ, MyPos

        
    end,

    AddEnhancementEmitterToBone = function(self, add, bone)

        -- destroy effect, if any
        if self.EnhancementBoneEffectsBag[ bone ] then
            self.EnhancementBoneEffectsBag[ bone ]:Destroy()
        end

        -- add the effect if desired
        if add then
            local emitBp = self:GetBlueprint().Display.EnhancementBoneEmitter
            local emit = CreateAttachedEmitter( self, bone, self.Army, emitBp )
            self.EnhancementBoneEffectsBag[ bone ] = emit
            self.Trash:Add( self.EnhancementBoneEffectsBag[ bone ] )
        end
    end,

    UpdateMovementEffectsOnMotionEventChange = function( self, new, old )
        self.HeadRotationEnabled = self.AllowHeadRotation
        ACUUnit.UpdateMovementEffectsOnMotionEventChange( self, new, old )
    end,

    -- =====================================================================================================================
    -- ORBITAL ENHANCEMENTS

    OrbitalStrikeTargets = function(self, targetPositions)
        -- TODO:Make the acu actually have ammo. Also check if removing ammo for every shot is sane, or if it should be per function call
        local heavyBombardment = self:HasEnhancement( 'OrbitalBombardmentHeavy' )
        
        if self.OrbitalUnit then
            for _, location in targetPositions do
                if self:GetTacticalSiloAmmoCount() > 0 then
                    self:RemoveTacticalSiloAmmo(1)
                    self.OrbitalUnit:OnGivenNewTarget(location, heavyBombardment)
                else
                    WARN('Nomads: Ordered Orbital Bombardment ability on unit with no ammo in storage - aborting launch.')
                end
            end
        end
    end,
    
    SetOrbitalBombardEnabled = function(self, condition)
        -- remove the brain:SetUnitSpecialAbility calls entirely
        self.Sync.OrbitalBombardEnabled = (true == condition)
        if condition then
            self.OrbitalUnit:SetMovementTarget(self)
        else

        end
    end,




    OnScriptBitClear = function(self, bit)
        if bit == 0 then -- RULEUTC_SpecialToggle
            if self.HasCapacitorAbility then
                if self.CapChargeFraction >= 1 then
                    self:ActivateCapacitor()
                end
            end
        
        elseif bit == 3 and self.IntelPackage and not self.IntelPackageOn then    -- Radar & Rhianne Intel

            -- add command slot consumption when radar turned on
            self.EnergyConsumption['Total'] = self.EnergyConsumption['Total'] + self.EnergyConsumption['Command']

            self:EnableUnitIntel('Radar')
            self:EnableUnitIntel('Sonar')
            self:EnableUnitIntel('Omni')
         
            -- self.RadarDish1:SetTargetSpeed(32)

            self.IntelPackageOn = true
            
            if self.SpysatEnabled then
                self:ForkThread(self.EXSatSpawn)
            end
        

        elseif bit == 4 then
            self:SetProductionPerSecondMass(self.RASMassProductionHigh)
            self:SetProductionPerSecondEnergy(self.RASEnergyProductionLow)
        elseif bit == 7 then
            if self.MaelstromFieldName and self.MaelstromFieldOn then
                self:SetIntelRadius('RadarStealth', 1)
                self:SetIntelRadius('RadarStealthField', 1)
                self:SetIntelRadius('SonarStealth', 1)
                self:SetIntelRadius('SonarStealthField', 1)

                self:DisableUnitIntel('RadarStealthField')
                self:DisableUnitIntel('SonarStealthField')

                self:GetBuffFieldByName(self.MaelstromFieldName):Disable()

                self.EnergyConsumption['Total'] = self.EnergyConsumption['Total'] - self.EnergyConsumption['Back']
                self.MaelstromFieldOn = false
            end
            self:SetEnergyMaintenanceConsumptionOverride(self.EnergyConsumption['Total'])
            if self.EnergyConsumption['Total'] > 0 then
                self:SetMaintenanceConsumptionActive()
            else
                self:SetMaintenanceConsumptionInactive()
            end
        else
            ACUUnit.OnScriptBitClear(self, bit)
        end
    end,


    OnScriptBitSet = function(self, bit)
        if bit == 0 then

            if not self.Sync.HasCapacitorAbility then
                return
            end

            LOG('*Capacitor: bit0 clicked. State = ' .. tostring(self.Sync.CapacitorState))

            local state = self.Sync.CapacitorState

            if state == 'Filled' then
                -- Activate: start discharging and apply buffs
                self.CapacitorSwitchStates['Filled'](self)

            elseif state == 'Unfilled' then
                -- Toggle charging on
                self.CapChargingEnabled = not self.CapChargingEnabled
                if self.CapChargingEnabled then
                    self.CapacitorSwitchStates['Unfilled'](self)
                end

            elseif state == 'Charging' then
                -- Cancel charging, begin decay
                self.CapChargingEnabled = false
                self.CapacitorSwitchStates['Charging'](self)

            elseif state == 'Discharging' then
                -- Can't cancel discharge - do nothing
                return

            else
                ACUUnit.OnScriptBitSet(self, bit)
        end

        elseif bit == 3 and self.IntelPackage and self.IntelPackageOn then

            self.EnergyConsumption['Total'] = self.EnergyConsumption['Total'] - self.EnergyConsumption['Command']

            self:DisableUnitIntel('Radar')
            self:DisableUnitIntel('Sonar')
            self:DisableUnitIntel('Omni')
         
            -- self.RadarDish1:SetTargetSpeed(0) 

            self.IntelPackageOn = false
            
            if self.SpysatEnabled and self.Satellite then
                self.Satellite:Kill()
                self.Satellite = nil
            end

        elseif bit == 4 then
            self:SetProductionPerSecondMass(self.RASMassProductionLow)
            self:SetProductionPerSecondEnergy(self.RASEnergyProductionHigh)
        
        elseif bit == 7 then
            if self.MaelstromFieldName and not self.MaelstromFieldOn then
                self:SetIntelRadius('RadarStealth', self.MaelstromFieldRadius)
                self:SetIntelRadius('RadarStealthField', self.MaelstromFieldRadius)
                self:SetIntelRadius('SonarStealth', self.MaelstromFieldRadius)
                self:SetIntelRadius('SonarStealthField', self.MaelstromFieldRadius)

                self:EnableUnitIntel('RadarStealthField')
                self:EnableUnitIntel('SonarStealthField')

                self:GetBuffFieldByName(self.MaelstromFieldName):Enable()

                self.EnergyConsumption['Total'] = self.EnergyConsumption['Total'] + self.EnergyConsumption['Back']
                self.MaelstromFieldOn = true
            end
            self:SetEnergyMaintenanceConsumptionOverride(self.EnergyConsumption['Total'])
            if self.EnergyConsumption['Total'] > 0 then
                self:SetMaintenanceConsumptionActive()
            else
                self:SetMaintenanceConsumptionInactive()
            end
        else
            ACUUnit.OnScriptBitSet(self, bit)
        end
    end,
    -- =====================================================================================================================
    -- ENHANCEMENTS
    
    
    
    
    --General note: Nomads ACU has capacitor, which uses buffs. So acu upgrades must use buffs so they stack with capacitor correctly.

    --a much more sensible way of doing enhancements, and more moddable too!
    --change the behaviours here and dont touch the CreateEnhancement table.
    --call with: self.EnhancementBehaviours[enh](self, bp)
    -- EnhancementTable = {
        -- IntelProbe = function(self, bp)
            -- self:AddEnhancementEmitterToBone( true, 'IntelProbe1' )
            -- self:SetIntelProbe( 'IntelProbe' )
        -- end,
    -- },
    EnhancementBehaviours = {
        Intel = function(self, bp)
            
            self.IntelPackage = true
            self.IntelPackageOn = true  -- the existing intel will already be On

            self:AddToggleCap('RULEUTC_IntelToggle')    -- add the toggle

            self:SetScriptBit('RULEUTC_IntelToggle', true )   -- turn off the basic intel
            
            self.EnergyConsumption[bp.Slot] = bp.ConsumptionPerSecondEnergy
			
            Buff.ApplyBuff(self, 'ACU_T2_Intel_Package')    -- add the buff 
            
            self:SetScriptBit('RULEUTC_IntelToggle', false )   -- turn intel back on

            self:ShowBone('IntelProbe1',true)

        end,

        IntelRemove = function(self, bp)
            self.StealthEnh = false

            if self.IntelPackageOn then
                self:SetScriptBit('RULEUTC_IntelToggle', true )   -- turn off existing intel
            end

			self.SpysatEnabled = false
			
			if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
				self.Satellite:Kill()
			end
			
			self.Satellite = nil
			
            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end
        end,
        
        IntelProbeAdv = function(self, bp)


            self:SetScriptBit('RULEUTC_IntelToggle', true )   -- turn off existing intel

            self.EnergyConsumption[bp.Slot] = bp.ConsumptionPerSecondEnergy
            Buff.ApplyBuff(self, 'ACU_T3_Intel_Package')

			self.SpysatEnabled = true
			self.Satellite = false

            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end

            self.StealthEnh = true      -- this should allow a visual effect
            
            self:SetScriptBit('RULEUTC_IntelToggle', false )   -- turn intel back on

            self:ShowBone('IntelProbe2',true)
        end,

        IntelProbeAdvRemove = function(self, bp)
            self.StealthEnh = false

            if self.IntelPackageOn then
                self:SetScriptBit('RULEUTC_IntelToggle', true )   -- turn off existing intel
            end

			self.SpysatEnabled = false
			
			if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
				self.Satellite:Kill()
			end
			
			self.Satellite = nil
			
            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end
        end,
        

        GunUpgrade = function(self, bp)
            local wep = self:GetWeaponByLabel('MainGun')
            local wbp = wep:GetBlueprint()

            -- adjust main gun
            wep:AddDamageRadiusMod(bp.NewDamageRadius or 3)
            wep:ChangeMaxRadius(bp.NewMaxRadius or wbp.MaxRadius)

            -- adjust overcharge gun
            local oc = self:GetWeaponByLabel('OverCharge')
            oc:ChangeMaxRadius( bp.NewMaxRadius or wbp.MaxRadius )
            local oca = self:GetWeaponByLabel('AutoOverCharge')
            oca:ChangeMaxRadius( bp.NewMaxRadius or wbp.MaxRadius )
        end,
        
        GunUpgradeRemove = function(self, bp)
            -- adjust main gun
            local ubp = self:GetBlueprint()
            local wep = self:GetWeaponByLabel('MainGun')
            local wbp = wep:GetBlueprint()
            wep:AddDamageRadiusMod(-ubp.Enhancements['GunUpgrade'].NewDamageRadius)
            wep:ChangeMaxRadius(wbp.MaxRadius)

            -- adjust overcharge gun
            local oc = self:GetWeaponByLabel('OverCharge')
            oc:ChangeMaxRadius( wbp.MaxRadius )
            local oca = self:GetWeaponByLabel('AutoOverCharge')
            oca:ChangeMaxRadius( bp.NewMaxRadius or wbp.MaxRadius )
        end,
        
        DoubleGuns = function(self, bp)
            -- this one should not change weapon damage, range, etc. The weapon script can't cope with that.
            self.DoubleBarrels = true
            self.DoubleBarrelOvercharge = bp.OverchargeIncluded
        end,
        
        DoubleGunsRemove = function(self, bp)
            self.DoubleBarrels = false
            self.DoubleBarrelOvercharge = false

            -- adjust main gun
            local ubp = self:GetBlueprint()
            local wep = self:GetWeaponByLabel('MainGun')
            local wbp = wep:GetBlueprint()
            wep:AddDamageRadiusMod(-ubp.Enhancements['GunUpgrade'].NewDamageRadius)
            wep:ChangeMaxRadius(wbp.MaxRadius)

            -- adjust overcharge gun
            local oc = self:GetWeaponByLabel('OverCharge')
            oc:ChangeMaxRadius( wbp.MaxRadius )
            local oca = self:GetWeaponByLabel('AutoOverCharge')
            oca:ChangeMaxRadius( bp.NewMaxRadius or wbp.MaxRadius )
        end,

        EXMaelstromQuantum = function(self, bp)
            self.EnergyConsumption['Total'] = self.EnergyConsumption['Total'] - self.EnergyConsumption[bp.Slot]
            self.EnergyConsumption[bp.Slot] = bp.ConsumptionPerSecondEnergy

            self.MaelstromFieldName = 'AeonMaelstromBuffField'
            self.MaelstromFieldOn = false
            self.MaelstromFieldRadius = 24

            self:AddToggleCap('RULEUTC_SpecialToggle')
            self:SetScriptBit('RULEUTC_SpecialToggle', true)

            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)

            self.wcChrono01 = false
            self.wcChrono02 = false
        end,

        EXMaelstromQuantumRemove = function(self, bp)
            if self.MaelstromFieldOn then
                self:SetScriptBit('RULEUTC_SpecialToggle', false)
            end

            self.EnergyConsumption[bp.Slot] = 0

            self.MaelstromFieldName = false
            self.MaelstromFieldOn = false
            self.MaelstromFieldRadius = 1

            self:RemoveToggleCap('RULEUTC_SpecialToggle')

            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)

            self.wcChrono01 = false
            self.wcChrono02 = false
        end,

        EXMaelstromFieldExpander = function(self, bp)
            if self.MaelstromFieldOn then
                self:SetScriptBit('RULEUTC_SpecialToggle', false)
            end

            self.EnergyConsumption[bp.Slot] = bp.ConsumptionPerSecondEnergy

            self.MaelstromFieldName = 'AeonMaelstromBuffField2'
            self.MaelstromFieldRadius = 32

            self:SetScriptBit('RULEUTC_SpecialToggle', true)

            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)

            self.wcChrono01 = true
            self.wcChrono02 = false
        end,

        EXMaelstromFieldExpanderRemove = function(self, bp)
            if self.MaelstromFieldOn then
                self:SetScriptBit('RULEUTC_SpecialToggle', false)
            end

            self.EnergyConsumption[bp.Slot] = 0

            self.MaelstromFieldName = false
            self.MaelstromFieldOn = false
            self.MaelstromFieldRadius = 1

            self:RemoveToggleCap('RULEUTC_SpecialToggle')

            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)

            self.wcChrono01 = false
            self.wcChrono02 = false
        end,

        EXMaelstromQuantumInstability = function(self, bp)
            Buff.ApplyBuff(self, 'MobilityPenalty')

            if self.MaelstromFieldOn then
                self:SetScriptBit('RULEUTC_SpecialToggle', false)
            end

            self.EnergyConsumption[bp.Slot] = bp.ConsumptionPerSecondEnergy

            self.MaelstromFieldName = 'AeonMaelstromBuffField3'
            self.MaelstromFieldRadius = 40

            self:SetScriptBit('RULEUTC_SpecialToggle', true)

            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)

            self.wcChrono01 = false
            self.wcChrono02 = true
        end,

        EXMaelstromQuantumInstabilityRemove = function(self, bp)
            if self.MaelstromFieldOn then
                self:SetScriptBit('RULEUTC_SpecialToggle', false)
            end

            self.EnergyConsumption[bp.Slot] = 0

            self.MaelstromFieldName = false
            self.MaelstromFieldOn = false
            self.MaelstromFieldRadius = 1

            self:RemoveToggleCap('RULEUTC_SpecialToggle')

            if Buff.HasBuff(self, 'MobilityPenalty') then
                Buff.RemoveBuff(self, 'MobilityPenalty')
            end

            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)

            self.wcChrono01 = false
            self.wcChrono02 = true
        end,
        
                
        Capacitor = function(self, bp)
            self.Sync.HasCapacitorAbility = true
            self.CapChargeFraction = 0
            self.Sync.CapacitorState = 'Unfilled'
            self.CapChargeThread = self:ForkThread(self.CapacitorChargeThread)
        end,

        CapacitorRemove = function(self, bp)
            self.Sync.HasCapacitorAbility = false
            if self.CapChargeThread then KillThread(self.CapChargeThread) end
            self:SetMaintenanceConsumptionInactive()
            self:SetProductionPerSecondEnergy(self:GetBlueprint().Economy.ProductionPerSecondEnergy)
            self:SetProductionPerSecondMass(self:GetBlueprint().Economy.ProductionPerSecondMass)
            if Buff.HasBuff(self, 'CapacitorEngineering') then Buff.RemoveBuff(self, 'CapacitorEngineering') end
            if Buff.HasBuff(self, 'CapacitorIntel')       then Buff.RemoveBuff(self, 'CapacitorIntel')       end
            if Buff.HasBuff(self, 'CapacitorRegen')       then Buff.RemoveBuff(self, 'CapacitorRegen')       end
            if Buff.HasBuff(self, 'CapacitorROF')         then Buff.RemoveBuff(self, 'CapacitorROF')         end
            self.Sync.CapacitorState = 'Unfilled'
            self.CapChargeFraction = 0
            self:UpdateCapacitorFraction()
        end,
        
        ResourceAllocation = function(self, bp)
            self:AddToggleCap('RULEUTC_ProductionToggle')
            self:SetProductionPerSecondEnergy(self.RASEnergyProductionLow)
            self:SetProductionPerSecondMass(self.RASMassProductionHigh)
            self:SetScriptBit('RULEUTC_ProductionToggle', false)
        end,
        
        ResourceAllocationRemove = function(self, bp)
            self:SetScriptBit('RULEUTC_ProductionToggle', true)
            self:RemoveToggleCap('RULEUTC_ProductionToggle')
            self:SetProductionPerSecondEnergy(self.EnergyProduction)
            self:SetProductionPerSecondMass(self.MassProduction)
        end,

        MovementSpeedIncrease = function(self, bp)
            
            if not Buffs['MovementSpeed'] then
               BuffBlueprint {
                    Name = 'MovementSpeed',
                    DisplayName = 'MovementSpeed',
                    BuffType = 'NACUUPGRADEMS',
                    Stacks = 'ALWAYS',
                    Duration = -1,
                    Affects = {
                        SpeedMult = {
                            Add = bp.AddSpeed,
                            Mult = 1,
                        },
                        AccelMult = {
                            Add = bp.AddAcc,
                            Mult = 1,
                        },
                    },
                }
            end
            if Buff.HasBuff( self, 'MovementSpeed' ) then
                Buff.RemoveBuff( self, 'MovementSpeed' )
            end
            Buff.ApplyBuff(self, 'MovementSpeed')
        end,

       

        MovementSpeedIncreaseRemove = function(self, bp)

            if Buff.HasBuff( self, 'MovementSpeed' ) then
                Buff.RemoveBuff( self, 'MovementSpeed' )
            end
        end,
        
        PowerArmor = function(self, bp)

            if not Buffs['NomadsACUPowerArmor'] then
               BuffBlueprint {
                    Name = 'NomadsACUPowerArmor',
                    DisplayName = 'NomadsACUPowerArmor',
                    BuffType = 'NACUUPGRADEHP',
                    Stacks = 'ALWAYS',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.AddHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.AddRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            if Buff.HasBuff( self, 'NomadsACUPowerArmor' ) then
                Buff.RemoveBuff( self, 'NomadsACUPowerArmor' )
            end
            Buff.ApplyBuff(self, 'NomadsACUPowerArmor')

            if bp.Mesh then
                self:SetMesh( bp.Mesh, true)
            end
        end,
        
        PowerArmorRemove = function(self, bp)

            local ubp = self:GetBlueprint()
            if bp.Mesh then
                self:SetMesh( ubp.Display.MeshBlueprint, true)
            end
            if Buff.HasBuff( self, 'NomadsACUPowerArmor' ) then
                Buff.RemoveBuff( self, 'NomadsACUPowerArmor' )
            end


        end,
        
        AdvancedEngineering = function(self, bp)

            -- new build FX bone available
            table.insert(self.BuildEffectBones, 'BuildBeam2')

            -- make new structures available
            local cat = ParseEntityCategory(bp.BuildableCategoryAdds)
            self:RemoveBuildRestriction(cat)

            -- add buff



            Buff.ApplyBuff(self, 'ACU_T2_Engineering_NMD')

        end,
        
        AdvancedEngineeringRemove = function(self, bp)


            -- remove extra build bone
            table.removeByValue(self.BuildEffectBones, 'BuildBeam2')

            -- buffs
            if Buff.HasBuff( self, 'ACU_T2_Engineering_NMD' ) then
                Buff.RemoveBuff( self, 'ACU_T2_Engineering_NMD' )
            end

            -- restore build restrictions
            self:RestoreBuildRestrictions()

            self:AddBuildRestriction( categories.NOMADS * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER) )

        end,
        
        T3Engineering = function(self, bp)

            -- new build FX bone available
            table.insert(self.BuildEffectBones, 'BuildBeam3')
            -- make new structures available
            local cat = ParseEntityCategory(bp.BuildableCategoryAdds)
            self:RemoveBuildRestriction(cat)

            -- add buff

            Buff.ApplyBuff(self, 'ACU_T3_Engineering_NMD')

        end,
        -- lets pray this LOUD implimentation works
        T4Engineering = function(self, bp)


            table.insert(self.BuildEffectBones, 'BuildBeam3')
            -- make new structures available
            local cat = ParseEntityCategory(bp.BuildableCategoryAdds)
            self:RemoveBuildRestriction(cat)

            -- add buff

            Buff.ApplyBuff(self, 'ACU_T4_Engineering_NMD')

            
            
        end,

        T3EngineeringRemove = function(self, bp)

            -- remove extra build bone
            table.removeByValue(self.BuildEffectBones, 'BuildBeam3')
            table.removeByValue(self.BuildEffectBones, 'BuildBeam2')
            -- remove buff
            if Buff.HasBuff( self, 'ACU_T3_Engineering_NMD' ) then
                Buff.RemoveBuff( self, 'ACU_T3_Engineering_NMD' )
            end

            -- reset build restrictions
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction( categories.NOMADS * ( categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER) )

        end,

        T4EngineeringRemove = function(self, bp)

            -- remove extra build bone
            table.removeByValue(self.BuildEffectBones, 'BuildBeam3')
            table.removeByValue(self.BuildEffectBones, 'BuildBeam2')
            -- remove buff
            if Buff.HasBuff( self, 'ACU_T3_Engineering_NMD' ) then
                Buff.RemoveBuff( self, 'ACU_T3_Engineering_NMD' )
            end

            -- reset build restrictions
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction( categories.NOMADS * ( categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER) )

        end,
        
        OrbitalBombardment = function(self, bp)
            self:SetOrbitalBombardEnabled(true)
            self:AddCommandCap('RULEUCC_Tactical')
            self:AddEnhancementEmitterToBone( true, 'Orbital Bombardment' )
            self:AddCommandCap('RULEUCC_SiloBuildTactical')
            self:SetWeaponEnabledByLabel('TargetFinder', true)
        end,
        
        OrbitalBombardmentRemove = function(self, bp)
            self:SetOrbitalBombardEnabled(false)
            self:AddEnhancementEmitterToBone( false, 'Orbital Bombardment' )
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
            self:SetWeaponEnabledByLabel('TargetFinder', false)
            local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
            self:StopSiloBuild()
        end,
        
        OrbitalBombardmentHeavy = function(self, bp)
            self:SetOrbitalBombardEnabled(true)
            self:AddEnhancementEmitterToBone( true, 'Orbital Bombardment' )
            self:AddCommandCap('RULEUCC_Tactical')
            self:AddCommandCap('RULEUCC_SiloBuildTactical')
            self:SetWeaponEnabledByLabel('TargetFinder', true)
            self:GetWeaponByLabel('TargetFinder'):ChangeProjectileBlueprint('/mods/nomads/projectiles/NIFOrbitalMissile02/NIFOrbitalMissile02_proj.bp')
        end,
        
        OrbitalBombardmentHeavyRemove = function(self, bp)
            self:SetOrbitalBombardEnabled(false)
            self:AddEnhancementEmitterToBone( false, 'Orbital Bombardment' )
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
            self:SetWeaponEnabledByLabel('TargetFinder', false)
            self:GetWeaponByLabel('TargetFinder'):ChangeProjectileBlueprint('/mods/nomads/projectiles/NIFOrbitalMissile01/NIFOrbitalMissile01_proj.bp')
            local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
            self:StopSiloBuild()
        end,
        
        Generic = function(self, bp)
        end,
    },
    
    CreateEnhancement = function(self, enh)
        ACUUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end

        if self.EnhancementBehaviours[enh] then
            self.EnhancementBehaviours[enh](self, bp)
        else
            WARN('Nomads: Enhancement '..repr(enh)..' has no script support.')
        end
    end,
    


}

TypeClass = XNL0001
