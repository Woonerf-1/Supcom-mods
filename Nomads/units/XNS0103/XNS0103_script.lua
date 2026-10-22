-- T1 frigate

local NSeaUnit = import('/mods/nomads/lua/nomadsunits.lua').NSeaUnit
local NDFRotatingAutocannonWeapon = import('/mods/nomads/lua/nomadsweapons.lua').NDFRotatingAutocannonWeapon
local NAMFlakWeapon = import('/mods/nomads/lua/nomadsweapons.lua').NAMFlakWeapon

XNS0103 = Class(NSeaUnit) {
    Weapons = {
        MainGun = Class(NDFRotatingAutocannonWeapon) {
            FxMuzzleScale = 2.25,
        },
        TMD01 = Class(NAMFlakWeapon) {
            TMDEffectBones = {'TMD_Targeter01','TMD_Targeter02',},
            SalvoReloadTime = 1.4, --Change this to the correct amount for the weapon.
        },
    },
}

TypeClass = XNS0103