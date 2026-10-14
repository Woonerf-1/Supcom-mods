-- Auszug aus BlackOps Unleashed, siehe lua\README.md

local MultiPolyTrailProjectile = import('/lua/sim/defaultprojectiles.lua').MultiPolyTrailProjectile

local BlackOpsEffectTemplate = import('/mods/t4unitadditions/lua/BlackOpsEffectTemplates.lua')

RailGun01Projectile             = Class(MultiPolyTrailProjectile) {
	FxImpactWater = BlackOpsEffectTemplate.RailGunCannonHit,
    FxImpactLand = BlackOpsEffectTemplate.RailGunCannonHit,
    FxImpactNone = BlackOpsEffectTemplate.RailGunCannonHit,
    FxImpactProp = BlackOpsEffectTemplate.RailGunCannonUnitHit,
    FxImpactUnit = BlackOpsEffectTemplate.RailGunCannonUnitHit,

    FxTrails = BlackOpsEffectTemplate.RailGunFxTrails,
    PolyTrails = BlackOpsEffectTemplate.RailGunPolyTrails,

}
