local WeaponFile = import("/lua/sim/defaultweapons.lua")
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local CollisionBeamFile = import("/lua/kirvesbeams.lua")

---@class TargetingLaser : DefaultBeamWeapon
TargetingLaser = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.TargetingCollisionBeam,
    FxMuzzleFlash = {'/effects/emitters/particle_cannon_muzzle_01_emit.bp'},
    FxBeamEndPointScale = 0.01,
}

---@class TargetingLaserInvisible : TargetingLaser
TargetingLaserInvisible = Class(TargetingLaser) {
    BeamType = CollisionBeamFile.TargetingCollisionBeamInvisible,
    FxMuzzleFlash = { },
}