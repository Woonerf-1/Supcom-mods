local NAirTransportUnit = import('/mods/nomads/lua/nomadsunits.lua').NAirTransportUnit
local DummyWeapon = import('/lua/aeonweapons.lua').AAASonicPulseBatteryWeapon
local Buff = import('/lua/sim/Buff.lua')
--- Tech 1 Air Transport
---@class XNA0107 : NAirTransportUnit
XNA0107 = Class(NAirTransportUnit) {

    Weapons = {
        GuidanceSystem = Class(DummyWeapon) {},
    },

    DestructionPartsLowToss = {0},
    DestroySeconds = 7.5,

    ---@param self XNA0107
    ---@param instigator Unit
    ---@param damageType DamageType
    ---@param overkillRatio number

    OnCreate = function(self)
        self:AddBuildRestriction( categories.NOMADS * (categories.BUILTBYTIER1ENGINEER + categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER) )
    end,

    OnKilled = function(self, instigator, damageType, overkillRatio)
        self:TransportDetachAllUnits(false)
        NAirTransportUnit.OnKilled(self, instigator, damageType, overkillRatio)
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
        end
    end,
}

TypeClass = XNA0107