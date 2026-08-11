TableCat = import('/lua/utilities.lua').TableCat

EmtBpPath = '/effects/emitters/'
EmitterTempEmtBpPath = '/effects/emitters/temp/'

local EffectTemplate = import('/lua/EffectTemplates.lua')

EmtBpPathAlt = '/mods/t4add/effects/emitters/'




NPlasmaProjectileMuzzleFlash = {
   	EmtBpPathAlt .. 'plasmaprojectile_muzzle_flash_01_emit.bp',
    EmtBpPath .. 'cannon_muzzle_flash_01_emit.bp',
	EmtBpPathAlt .. 'plasmaprojectile_hitunit_05_emit.bp',
}

NPlasmaProjectilePolyTrails = {
	EmtBpPathAlt .. 'plasmaprojectile_polytrail_02_emit.bp',
}

NPlasmaProjectileHit02 = {
    EmtBpPathAlt .. 'plasmaprojectile_hit_01_emit.bp',
    EmtBpPathAlt .. 'plasmaprojectile_hit_02_emit.bp',
    EmtBpPathAlt .. 'plasmaprojectile_hit_03_emit.bp',
    EmtBpPathAlt .. 'plasmaprojectile_hit_04_emit.bp',
    EmtBpPathAlt .. 'plasmaprojectile_hit_05_emit.bp',
    EmtBpPathAlt .. 'plasmaprojectile_hitunit_05_emit.bp',
    EmtBpPathAlt .. 'plasmaprojectile_glow_emit.bp',
}

NPlasmaProjectileShieldHit01 = {
    EmtBpPathAlt .. 'plasmaprojectile_hit_03_emit.bp',
    EmtBpPathAlt .. 'plasmaprojectile_hitunit_05_emit.bp',
    EmtBpPathAlt .. 'plasmaprojectile_glow_emit.bp',
}

NPlasmaProjectileHit03 = {
    EmtBpPathAlt .. 'plasmaprojectile_hitunit_05_emit.bp',
}

NPlasmaProjectileHit04 = {
    EmtBpPathAlt .. 'plasmaprojectile_hitunit_05_emit.bp',
}

NPlasmaProjectileHit01 = TableCat( NPlasmaProjectileHit02, NPlasmaProjectileHit03, NPlasmaProjectileMuzzleFlash )
NPlasmaProjectileHitUnit01 = TableCat( NPlasmaProjectileHit02, NPlasmaProjectileHit04, EffectTemplate.UnitHitShrapnel01 )


