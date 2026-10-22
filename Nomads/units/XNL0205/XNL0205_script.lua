-- mobile t2 anti air

local NLandUnit = import('/mods/nomads/lua/nomadsunits.lua').NLandUnit
local RocketWeapon1 = import('/mods/nomads/lua/nomadsweapons.lua').RocketWeapon1

XNL0205 = Class(NLandUnit) {
    Weapons = {
        AAGun = Class(RocketWeapon1) {},
    },
}

TypeClass = XNL0205