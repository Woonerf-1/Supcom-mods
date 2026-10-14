-- Auszug aus 4th Dimension Units for LOUD, siehe lua\README.md

local DefaultProjectileWeapon = import('/lua/sim/defaultweapons.lua').DefaultProjectileWeapon

ArrowMissileWeapon          = Class(DefaultProjectileWeapon) { FxMuzzleFlash = {'/effects/emitters/aeon_missile_launch_02_emit.bp'} }

LaserPhalanxWeapon          = Class(DefaultProjectileWeapon) { FxMuzzleFlash = {'/effects/emitters/flash_04_emit.bp'} }
