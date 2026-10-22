local NomadsEffectTemplate = import('/mods/nomads/lua/nomadseffecttemplate.lua')
local NEnergyCreationUnit = import('/mods/nomads/lua/nomadsunits.lua').NEnergyCreationUnit


--- CNB1302 - verbessertes Hydrocarbon-Kraftwerk (Script wie XNB1102). Aktiv nur mit ImprovedHydrocarbonPowerPlants,
--- siehe hook\lua\system\Blueprints.lua und doc.claude\mods\Nomads.md.
---@class CNB1302 : NEnergyCreationUnit
CNB1302 = Class(NEnergyCreationUnit) {

    ActiveEffectBone = 'exhaust.001',
    ActiveEffectTemplateName = 'T1HydroPowerPlantSurface1',

    DestructionPartsHighToss = { 'exhaust.001', },
    DestructionPartsLowToss = {'exhaust.001', 'exhaust.002', 'exhaust.003', 'exhaust.004', 'exhaust.005', },
    DestructionPartsChassisToss = { 0 },

    ---@param self CNB1302
    PlayActiveEffects = function(self)
        -- adding additional effects on top of the regular active effects

        local effectTemplate = NomadsEffectTemplate.T1HydroPowerPlantSurface2
        local bones = { 'exhaust.002', 'exhaust.003', 'exhaust.004', 'exhaust.005', }

        -- different effects when we're under water
        if self:GetCurrentLayer() == 'Seabed' then
            self.ActiveEffectTemplateName = 'T1HydroPowerPlantSubmerged1'
            effectTemplate = NomadsEffectTemplate.T1HydroPowerPlantSubmerged2
        end

        -- create the emitters
        local emit
        for k, v in effectTemplate do
            for _, bone in bones do
                emit = CreateAttachedEmitter(self, bone, self.Army, v)
                self.ActiveEffectsBag:Add( emit )
                self.Trash:Add( emit )
            end
        end

        return NEnergyCreationUnit.PlayActiveEffects(self)
    end,
}
TypeClass = CNB1302