local AddLights = import('/mods/nomads/lua/nomadsutils.lua').AddLights
local NLandUnit = import('/mods/nomads/lua/nomadsunits.lua').NLandUnit

NLandUnit = AddLights(NLandUnit)

--- Civilian Vehicle
---@class XNC0003 : NLandUnit
XNC0003 = Class(NLandUnit) {
    LightBones = { {'Antenna',}, },
}
TypeClass = XNC0003