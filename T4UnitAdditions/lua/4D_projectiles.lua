-- Auszug aus 4th Dimension Units for LOUD, siehe lua\README.md

local MultiPolyTrailProjectile = import('/lua/sim/defaultprojectiles.lua').MultiPolyTrailProjectile

local EffectTemplate = import('/lua/EffectTemplates.lua')

Over_ChargeProjectile = Class(MultiPolyTrailProjectile) {

    PolyTrails = {
        '/effects/emitters/laserturret_munition_trail_01_emit.bp',
        '/effects/emitters/default_polytrail_06_emit.bp',
    },

    BeamName = '/effects/emitters/laserturret_munition_beam_03_emit.bp',
    FxImpactUnit = EffectTemplate.TCommanderOverchargeHit01,
    FxImpactProp = EffectTemplate.TCommanderOverchargeHit01,
    FxImpactLand = EffectTemplate.TCommanderOverchargeHit01,
    FxImpactAirUnit = EffectTemplate.TCommanderOverchargeHit01,

}
