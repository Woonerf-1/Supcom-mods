local NomadsEffectTemplate = import('/lua/nomadseffecttemplate.lua')
local AddLights = import('/lua/nomadsutils.lua').AddLights
local NAirTransportUnit = import('/lua/nomadsunits.lua').NAirTransportUnit
local DummyWeapon = import('/lua/aeonweapons.lua').AAASonicPulseBatteryWeapon
local Buff = import('/lua/sim/Buff.lua')

NAirTransportUnit = AddLights(NAirTransportUnit)

-- Tech 2 Air Transport
---@class XNA0104 : NAirTransportUnit
XNA0104 = Class(NAirTransportUnit) {

    DestructionTicks = 250,

    LightBones = { { 'Antenna01' }, },
    ThrusterBurnBones = { 'Engine1', 'Engine2' },
    RocketLauncherBone = 'RocketLauncherArm',

    Weapons = {
        GuidanceSystem = Class(DummyWeapon) {},
    },

    --------------------------------------------------------------------------
    -- Creation
    --------------------------------------------------------------------------

    OnCreate = function(self)
        NAirTransportUnit.OnCreate(self)

        self:HideBone(self.RocketLauncherBone, true)

        self.ThrusterEffectsBag = TrashBag()
        self.ThrusterBurnEffectsBag = TrashBag()

        self.UnfoldAnim = CreateAnimator(self)
        self.Trash:Add(self.UnfoldAnim)

        self.UnfoldAnim:PlayAnim('/units/XNA0104/XNA0104_Unfold.sca')
        self.UnfoldAnim:SetRate(0)
        self:AddBuildRestriction( categories.NOMADS * (categories.BUILTBYTIER1ENGINEER + categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER) )
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        NAirTransportUnit.OnStopBeingBuilt(self, builder, layer)

        if self.UnfoldAnim then
            self.UnfoldAnim:SetRate(1)
        end

        self:PlayThrusterEffects()
    end,

    --------------------------------------------------------------------------
    -- Death
    --------------------------------------------------------------------------

    OnKilled = function(self, instigator, damageType, overkillRatio)

        if self.UnfoldAnim then
            self.UnfoldAnim:SetRate(0)
        end

        self:DestroyThrusterEffects()
        self:DestroyThrusterBurnEffects()

        NAirTransportUnit.OnKilled(self, instigator, damageType, overkillRatio)

        self:TransportDetachAllUnits(true)
    end,

    OnDestroy = function(self)
        self:DestroyThrusterEffects()
        self:DestroyThrusterBurnEffects()
        NAirTransportUnit.OnDestroy(self)
    end,

    --------------------------------------------------------------------------
    -- Vertical Motion Handling
    --------------------------------------------------------------------------

    OnMotionVertEventChange = function(self, new, old)



        NAirTransportUnit.OnMotionVertEventChange(self, new, old)

        if new == 'Top' then

            self:DestroyThrusterBurnEffects()
            self:PlayThrusterEffects()

        elseif new == 'Down' then

            self:DestroyThrusterEffects()
            self:DestroyThrusterBurnEffects()
            self:PlayThrusterBurnEffects()

        elseif new == 'Hover' then

            if old ~= 'Down' then
                self:DestroyThrusterEffects()
                self:DestroyThrusterBurnEffects()
                self:PlayThrusterBurnEffects()
            end

        elseif new == 'Up' then

            if old ~= 'Hover' then
                self:DestroyThrusterEffects()
                self:DestroyThrusterBurnEffects()
                self:PlayThrusterBurnEffects()
            end

        elseif new == 'Bottom' then

            self:DestroyThrusterEffects()
            self:DestroyThrusterBurnEffects()
            self:PlayThrusterBurnEffects()
            self:DelayDestroyThrusterBurnEffects(2)
        end
    end,

    --------------------------------------------------------------------------
    -- Thruster Effects
    --------------------------------------------------------------------------

    PlayThrusterEffects = function(self)

        if self:GetFractionComplete() < 1 then return end

        for _, v in pairs(NomadsEffectTemplate.T2TransportThrusters) do
            for _, bone in ipairs(self.ThrusterBurnBones) do
                local emit = CreateAttachedEmitter(self, bone, self.Army, v)
                self.ThrusterEffectsBag:Add(emit)
                self.Trash:Add(emit)
            end
        end
    end,

    DestroyThrusterEffects = function(self)
        if self.ThrusterEffectsBag then
            self.ThrusterEffectsBag:Destroy()
            self.ThrusterEffectsBag = TrashBag()
        end
    end,

    --------------------------------------------------------------------------

    PlayThrusterBurnEffects = function(self)

        if self:GetFractionComplete() < 1 then return end

        for _, v in pairs(NomadsEffectTemplate.T2TransportThrusterBurn) do
            for _, bone in ipairs(self.ThrusterBurnBones) do
                local emit = CreateAttachedEmitter(self, bone, self.Army, v)
                self.ThrusterBurnEffectsBag:Add(emit)
                self.Trash:Add(emit)
            end
        end
    end,

    DestroyThrusterBurnEffects = function(self)
        if self.ThrusterBurnEffectsBag then
            self.ThrusterBurnEffectsBag:Destroy()
            self.ThrusterBurnEffectsBag = TrashBag()
        end
    end,

    --------------------------------------------------------------------------

    DelayDestroyThrusterBurnEffects = function(self, delay)

    if self.DelayBurnThread then
        KillThread(self.DelayBurnThread)
        self.DelayBurnThread = nil
    end

    self.DelayBurnThread = self:ForkThread(function()

        WaitSeconds(delay)

        if not self.Dead then
            self:DestroyThrusterBurnEffects()
        end

        self.DelayBurnThread = nil
    end)
    end,
    CreateEnhancement = function(self, enh)
	
        NAirTransportUnit.CreateEnhancement(self, enh)
		
        local bp = __blueprints[self.BlueprintID].Enhancements[enh]


        if enh =='T1Engineering' then
		
            local bp = self:GetBlueprint().Enhancements[enh]
			
            if not bp then return end
			
            local cat = ParseEntityCategory(bp.BuildableCategoryAdds)
			
            self:RemoveBuildRestriction(cat)
			
            if not Buffs['NOMADSACUT1BuildRate'] then
                BuffBlueprint {
                    Name = 'NOMADSACUT1BuildRate',
                    DisplayName = 'NOMADSACUT1BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end

            Buff.ApplyBuff(self, 'NOMADSACUT1BuildRate')
			
        elseif enh =='T1EngineeringRemove' then
		
            local bp = self:GetBlueprint().Economy.BuildRate
			
            if not bp then return end
			
            self:RestoreBuildRestrictions()
			
            self:AddBuildRestriction( categories.NOMADS * (categories.BUILTBYTIER1ENGINEER + categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER) )
			
            if Buff.HasBuff( self, 'ACU_T2_Engineering' ) then
                Buff.RemoveBuff( self, 'ACU_T2_Engineering' )
            end
        --t2 engineering
        elseif enh =='T2Engineering' then
		
            local bp = self:GetBlueprint().Enhancements[enh]
			
            if not bp then return end
			
            local cat = ParseEntityCategory(bp.BuildableCategoryAdds)
			
            self:RemoveBuildRestriction(cat)

			if not Buffs['NOMADSACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'NOMADSACUT2BuildRate',
                    DisplayName = 'NOMADSACUT2BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end

            Buff.ApplyBuff(self, 'NOMADSACUT2BuildRate')
			
        elseif enh =='T2EngineeringRemove' then
		
            local bp = self:GetBlueprint().Economy.BuildRate
			
            if not bp then return end
			
            self:RestoreBuildRestrictions()
			
            self:AddBuildRestriction( categories.NOMADS * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER) )
			
            if Buff.HasBuff( self, 'ACU_T2_Engineering' ) then
                Buff.RemoveBuff( self, 'ACU_T2_Engineering' )
            end
			
        -- T3 Engineering
        elseif enh =='T3Engineering' then
		
            local bp = self:GetBlueprint().Enhancements[enh]
			
            if not bp then return end
			
            local cat = ParseEntityCategory(bp.BuildableCategoryAdds)
			
            self:RemoveBuildRestriction(cat)

            if not Buffs['NOMADSACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'NOMADSACUT3BuildRate',
                    DisplayName = 'NOMADSACUT3BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
			
            Buff.ApplyBuff(self, 'NOMADSACUT3BuildRate')
			
        elseif enh =='T3EngineeringRemove' then
		
            local bp = self:GetBlueprint().Economy.BuildRate
			
            if not bp then return end
			
            self:RestoreBuildRestrictions()
			
            self:AddBuildRestriction( categories.NOMADS * ( categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER) )
			
            if Buff.HasBuff( self, 'ACU_T3_Engineering' ) then
                Buff.RemoveBuff( self, 'ACU_T3_Engineering' )
            end

        -- T4 Engineering
        elseif enh =='T4Engineering' then
		
            local bp = self:GetBlueprint().Enhancements[enh]
			
            if not bp then return end
			
            local cat = ParseEntityCategory(bp.BuildableCategoryAdds)
			
            self:RemoveBuildRestriction(cat)

            if not Buffs['NOMADSACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'NOMADSACUT4BuildRate',
                    DisplayName = 'NOMADSACUT4BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end

            Buff.ApplyBuff(self, 'NOMADSACUT4BuildRate')
			
        elseif enh =='T4EngineeringRemove' then
		
            local bp = self:GetBlueprint().Economy.BuildRate
			
            if not bp then return end
			
            self:RestoreBuildRestrictions()
			
            self:AddBuildRestriction( categories.NOMADS * ( categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER) )
			
            if Buff.HasBuff( self, 'ACU_T4_Engineering' ) then
                Buff.RemoveBuff( self, 'ACU_T4_Engineering' )
            end
        elseif enh == 'AltEngineeringBoost' then

            local bp = self:GetBlueprint().Enhancements[enh]
            if not bp then return end

            if not Buffs['NOMADSALTBUILDRATE'] then
                BuffBlueprint {
                    Name = 'NOMADSALTBUILDRATE',
                    DisplayName = 'NOMADSALTBUILDRATE',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add = bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end

            Buff.ApplyBuff(self, 'NOMADSALTBUILDRATE')

        elseif enh == 'AltEngineeringBoostRemove' then

            self:RestoreBuildRestrictions()

            if Buff.HasBuff(self, 'NOMADSALTBUILDRATE') then
                Buff.RemoveBuff(self, 'NOMADSALTBUILDRATE')
            end
        end
    end,
}

TypeClass = XNA0104