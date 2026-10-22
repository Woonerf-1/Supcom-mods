local NStructureUnit = import('/mods/nomads/lua/nomadsunits.lua').NStructureUnit
local KineticCannon1 = import('/mods/nomads/lua/nomadsweapons.lua').KineticCannon1

--- Tech 2 Point Defense
---@class XNB2301: NStructureUnit
XNB2301 = Class(NStructureUnit) {
    Weapons = {
        MainGun = Class(KineticCannon1) {
            FxMuzzleScale = 1,
        },
    },
}
TypeClass = XNB2301