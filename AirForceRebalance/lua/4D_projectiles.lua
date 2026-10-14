-- Auszug aus 4th Dimension Units for LOUD, siehe lua\README.md

local SingleCompositeEmitterProjectile = import('/lua/sim/defaultprojectiles.lua').SingleCompositeEmitterProjectile

local EffectTemplate = import('/lua/EffectTemplates.lua')

ArrowMissileProjectile = Class(SingleCompositeEmitterProjectile) {

    PolyTrail = '/effects/emitters/serpentine_missile_trail_emit.bp',
    BeamName = '/effects/emitters/serpentine_missle_exhaust_beam_01_emit.bp',
    PolyTrailOffset = -0.05,

    FxAirUnitHitScale = 3.0,

    FxImpactUnit = EffectTemplate.AMissileHit01,

    OnCreate = function(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
        SingleCompositeEmitterProjectile.OnCreate(self)
    end,
}
