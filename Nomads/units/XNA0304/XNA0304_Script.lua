local NAirUnit = import('/mods/nomads/lua/nomadsunits.lua').NAirUnit
local EnergyBombWeapon = import('/mods/nomads/lua/nomadsweapons.lua').EnergyBombWeapon

--- Tech 3 Strategic Bomber
---@class XNA0304 : NAirUnit
XNA0304 = Class(NAirUnit) {
    Weapons = {
        Bomb = Class(EnergyBombWeapon) {},
    },
}
TypeClass = XNA0304