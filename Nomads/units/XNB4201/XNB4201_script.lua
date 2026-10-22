local AddLights = import('/mods/nomads/lua/nomadsutils.lua').AddLights
local NStructureUnit = import('/mods/nomads/lua/nomadsunits.lua').NStructureUnit
local MissileWeapon1 = import('/mods/nomads/lua/nomadsweapons.lua').MissileWeapon1

NStructureUnit = AddLights(NStructureUnit)

--- Tech 3 SAM
---@class XNB4201 : NStructureUnit
XNB4201 = Class(NStructureUnit) {
    Weapons = {
        MainGun = Class(MissileWeapon1) {},
    },

    LightBones = { {'blinklight.001',}, },
}

TypeClass = XNB4201