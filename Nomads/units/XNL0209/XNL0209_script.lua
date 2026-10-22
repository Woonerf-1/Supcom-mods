-- T2 field engineer

local NomadsEffectTemplate = import('/mods/nomads/lua/nomadseffecttemplate.lua')
local NConstructionUnit = import('/mods/nomads/lua/nomadsunits.lua').NConstructionUnit
local NAMFlakWeapon = import('/lua/cybranweapons.lua').CAMZapperWeapon

XNL0209 = Class(NConstructionUnit) {
    Weapons = {
        MainGun = Class(NAMFlakWeapon) {
            SalvoReloadTime = 1.4, --Change this to the correct amount for the weapon.
            TMDEffectBones = { 'TMD_Fx1', 'TMD_Fx2', },
        },
    },
}

TypeClass = XNL0209