local AddLights = import('/mods/nomads/lua/nomadsutils.lua').AddLights
local NStructureUnit = import('/mods/nomads/lua/nomadsunits.lua').NStructureUnit
local GattlingWeapon1 = import('/mods/nomads/lua/nomadsweapons.lua').GattlingWeapon1

NStructureUnit = AddLights(NStructureUnit)

--- Civillian Structure with Gun
---@class XNB9001 : NStructureUnit
XNB9001 = Class(NStructureUnit) {
    Weapons = {
        MainGun = Class(GattlingWeapon1) {
            Rotates = false,
        },
    },
    LightBones = { {'Light1', 'Light2', }, {}, {}, {'Light3', 'Light4', }, },
}
TypeClass = XNB9001