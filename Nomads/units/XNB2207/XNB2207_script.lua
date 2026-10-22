local AddLights = import('/mods/nomads/lua/nomadsutils.lua').AddLights
local NStructureUnit = import('/mods/nomads/lua/nomadsunits.lua').NStructureUnit
local UnderwaterRailgunWeapon1 = import('/mods/nomads/lua/nomadsweapons.lua').UnderwaterRailgunWeapon1

NStructureUnit = AddLights(NStructureUnit)

--- Tech 2 Underwater Railgun
---@class XNB2207 : NStructureUnit
XNB2207 = Class(NStructureUnit) {
    Weapons = {
        MainGun = Class(UnderwaterRailgunWeapon1) {},
    },
    LightBones = {
        { 'flashlight.001', },
        { 'flashlight.002', },
        { 'flashlight.003', },
        { 'flashlight.004', },
    },
}
TypeClass = XNB2207