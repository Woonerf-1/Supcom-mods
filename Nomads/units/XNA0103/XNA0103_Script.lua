local NAirUnit = import('/mods/nomads/lua/nomadsunits.lua').NAirUnit
local RocketWeapon1Bomber = import('/mods/nomads/lua/nomadsweapons.lua').RocketWeapon1Bomber

--- Tech 1 Bomber
---@class XNA0103 : NAirUnit
XNA0103 = Class(NAirUnit) {
    Weapons = {
        Rocket1 = Class(RocketWeapon1Bomber) {},
    },
}
TypeClass = XNA0103