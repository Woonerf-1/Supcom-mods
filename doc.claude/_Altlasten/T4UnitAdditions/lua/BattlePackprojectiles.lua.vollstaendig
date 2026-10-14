local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')

local EmitterProjectile                  = DefaultProjectileFile.EmitterProjectile
local MultiPolyTrailProjectile           = DefaultProjectileFile.MultiPolyTrailProjectile 
local SingleCompositeEmitterProjectile   = DefaultProjectileFile.SingleCompositeEmitterProjectile

DefaultProjectileFile = nil

local EffectTemplate = import('/lua/EffectTemplates.lua')
local BattlePackEffectTemplate = import('/mods/t4add/lua/BattlePackEffectTemplates.lua')


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
        '/mods/t4add/effects/emitters/napalm_fire_emit_2.bp',
        '/effects/emitters/napalm_01_emit.bp',
    },
    FxImpactProp = {
        '/mods/t4add/effects/emitters/napalm_fire_emit_2.bp',
        '/effects/emitters/napalm_01_emit.bp',
    },
    FxImpactLand = {
        '/mods/t4add/effects/emitters/napalm_fire_emit_2.bp',
        '/effects/emitters/napalm_01_emit.bp',
    },
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,

	FxLandHitScale = 2,
    FxPropHitScale = 2,
    FxUnitHitScale = 2,
	FxImpactWaterScale = 2,
}

----------------------
--  NETHER ENERGY BOLT
----------------------
NEnergy = Class(MultiPolyTrailProjectile) {

    FxTrails = {
        '/mods/t4add/effects/emitters/plasmaprojectile_trail_03_emit.bp',
        '/mods/t4add/effects/emitters/NapalmDistort.bp',
	},

    PolyTrails = BattlePackEffectTemplate.NPlasmaProjectilePolyTrails,
    FxImpactUnit = BattlePackEffectTemplate.NPlasmaProjectileHitUnit01,
    FxImpactProp = BattlePackEffectTemplate.NPlasmaProjectileHitUnit01,
    FxImpactLand = BattlePackEffectTemplate.NPlasmaProjectileHit01,
    FxImpactWater = BattlePackEffectTemplate.NPlasmaProjectileHit01,
    FxImpactShield = BattlePackEffectTemplate.NPlasmaProjectileShieldHit01,
    FxImpactNone = BattlePackEffectTemplate.NPlasmaProjectileShieldHit01,
}

