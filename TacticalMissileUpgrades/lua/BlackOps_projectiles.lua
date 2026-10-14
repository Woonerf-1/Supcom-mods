-- Auszug aus BlackOpsUnleashed, siehe lua\README.md

local SingleCompositeEmitterProjectile = import('/lua/sim/defaultprojectiles.lua').SingleCompositeEmitterProjectile

local EmtBpPathAlt = '/mods/tacticalmissileupgrades/effects/emitters/'

-- BlackOpsEffectTemplates.lua Z. 10-20
local Aeon_MirvHit = {
	EmtBpPathAlt .. 'aeon_mirv_hit_03_emit.bp',	# fast ring
	EmtBpPathAlt .. 'aeon_mirv_hit_04_emit.bp',	# plasma
	EmtBpPathAlt .. 'aeon_mirv_hit_05_emit.bp',	# flash lines
	EmtBpPathAlt .. 'aeon_mirv_hit_06_emit.bp',	# darkening molecular
	EmtBpPathAlt .. 'aeon_mirv_hit_07_emit.bp',	# little dot glows
	EmtBpPathAlt .. 'aeon_mirv_hit_08_emit.bp',	# slow ring
	EmtBpPathAlt .. 'aeon_mirv_hit_09_emit.bp',	# darkening
	EmtBpPathAlt .. 'aeon_mirv_hit_10_emit.bp',	# radial rays
	EmtBpPathAlt .. 'aeon_mirv_cloud_01_emit.bp',
}

-- BlackOpsprojectiles.lua Z. 356-364
MIRVChild01Projectile           = Class(SingleCompositeEmitterProjectile) {
    PolyTrail = '/effects/emitters/serpentine_missile_trail_emit.bp',
    BeamName = '/effects/emitters/serpentine_missle_exhaust_beam_01_emit.bp',
    PolyTrailOffset = -0.05,

    FxImpactUnit = Aeon_MirvHit,
    FxImpactProp = Aeon_MirvHit,
    FxImpactLand = Aeon_MirvHit,
}
