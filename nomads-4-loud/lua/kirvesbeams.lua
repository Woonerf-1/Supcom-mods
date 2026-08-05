local CollisionBeam = import("/lua/sim/collisionbeam.lua").CollisionBeam
local EffectTemplate = import("/lua/effecttemplates.lua")
local SCCollisionBeam = import("/lua/defaultcollisionbeams.lua").SCCollisionBeam
local Util = import("/lua/utilities.lua")

---@class EmptyCollisionBeam : CollisionBeam
EmptyCollisionBeam = Class(CollisionBeam) {
    FxImpactUnit = { },
    FxImpactLand = { },--EffectTemplate.DefaultProjectileLandImpact,
    FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
    FxImpactUnderWater = EffectTemplate.DefaultProjectileUnderWaterImpact,
    FxImpactAirUnit = { },
    FxImpactProp = { },
    FxImpactShield = { },
    FxImpactNone = { },
}

---@class TargetingCollisionBeam : EmptyCollisionBeam
TargetingCollisionBeam = Class(EmptyCollisionBeam) {
    FxBeam = {
        '/effects/emitters/targetting_beam_01_emit.bp'
    },
}

---@class TargetingCollisionBeamInvisible : EmptyCollisionBeam
TargetingCollisionBeamInvisible = Class(EmptyCollisionBeam) {
    FxBeam = {
        '/effects/emitters/targeting_beam_invisible.bp'
    },
}