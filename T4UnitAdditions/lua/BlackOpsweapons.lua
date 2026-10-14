-- Auszug aus BlackOps Unleashed, siehe lua\README.md

local DefaultProjectileWeapon = import('/lua/sim/defaultweapons.lua').DefaultProjectileWeapon

local EffectTemplate = import('/lua/EffectTemplates.lua')
local BlackOpsEffectTemplate = import('/mods/t4unitadditions/lua/BlackOpsEffectTemplates.lua')

CitadelHVMWeapon                            = Class(DefaultProjectileWeapon) { FxMuzzleFlash = EffectTemplate.TAAMissileLaunch,
}

CitadelPlasmaGatlingCannonWeapon            = Class(DefaultProjectileWeapon) { FxMuzzleFlash = BlackOpsEffectTemplate.JuggPlasmaGatlingCannonMuzzleFlash,
	FxShellEject  = BlackOpsEffectTemplate.JuggPlasmaGatlingCannonShells,
	FxMuzzleFlashScale = 0.5,

    PlayFxMuzzleSequence = function(self, muzzle)
		DefaultProjectileWeapon.PlayFxMuzzleSequence(self, muzzle)
		for k, v in self.FxShellEject do
            CreateAttachedEmitter(self.unit, 'Gat_Shells', self.unit:GetArmy(), v):ScaleEmitter(0.5)
        end
    end,

}

RailGunWeapon02                             = Class(DefaultProjectileWeapon) { FxMuzzleFlash = {'/mods/t4unitadditions/effects/emitters/xcannon_cannon_muzzle_01_emit.bp',--#large redish flash
		'/mods/t4unitadditions/effects/emitters/x_cannon_fire_test_01_emit.bp',--barrel lightning effect
		'/mods/t4unitadditions/effects/emitters/jugg_rail_cannon_muzzle_07_emit.bp',-- small redish flash, double quick
		'/mods/t4unitadditions/effects/emitters/jugg_rail_cannon_muzzle_08_emit.bp',-- small redish double flash
	},
    FxChargeMuzzleFlash = {
		'/mods/t4unitadditions/effects/emitters/x_cannon_charge_test_01_emit.bp',--#lightning
    },

	FxMuzzleFlashScale = 0.75,
	FxChargeMuzzleFlashScale = 0.75,
}
