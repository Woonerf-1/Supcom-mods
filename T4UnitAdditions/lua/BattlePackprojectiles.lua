-- Auszug aus Wyvern Battle Pack, siehe lua\README.md

local SingleCompositeEmitterProjectile = import('/lua/sim/defaultprojectiles.lua').SingleCompositeEmitterProjectile

local EffectTemplate = import('/lua/EffectTemplates.lua')

--------------------------
--  TERRAN NAPALM MISSILES
--------------------------
NapalmMissile = Class(SingleCompositeEmitterProjectile) {
    FxInitial = {},
    TrailDelay = 0,
    FxTrails = {'/effects/emitters/missile_sam_munition_trail_01_emit.bp',},

    PolyTrail = '/effects/emitters/default_polytrail_01_emit.bp',
    BeamName = '/effects/emitters/rocket_iridium_exhaust_beam_01_emit.bp',
    FxImpactUnit = {
        '/mods/t4unitadditions/effects/emitters/napalm_fire_emit_2.bp',
        '/effects/emitters/napalm_01_emit.bp',
    },
    FxImpactProp = {
        '/mods/t4unitadditions/effects/emitters/napalm_fire_emit_2.bp',
        '/effects/emitters/napalm_01_emit.bp',
    },
    FxImpactLand = {
        '/mods/t4unitadditions/effects/emitters/napalm_fire_emit_2.bp',
        '/effects/emitters/napalm_01_emit.bp',
    },
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,

	FxLandHitScale = 2,
    FxPropHitScale = 2,
    FxUnitHitScale = 2,
	FxImpactWaterScale = 2,
}
