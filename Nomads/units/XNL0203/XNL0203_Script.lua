-- T2 fast attack tank

local NHoverLandUnit = import('/mods/nomads/lua/nomadsunits.lua').NHoverLandUnit
local DarkMatterWeapon1 = import('/mods/nomads/lua/nomadsweapons.lua').DarkMatterWeapon1
local SlowHover = import('/lua/defaultunits.lua').MobileUnit

XNL0203 = Class(NHoverLandUnit, SlowHover) {
    Weapons = {
        MainGun = Class(DarkMatterWeapon1) {},
    },
}

TypeClass = XNL0203
