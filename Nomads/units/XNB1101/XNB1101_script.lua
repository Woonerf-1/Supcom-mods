local NEnergyCreationUnit = import('/mods/nomads/lua/nomadsunits.lua').NEnergyCreationUnit

--- Tech 1 Power Generator
---@class XNB1101 : NEnergyCreationUnit
XNB1101 = Class(NEnergyCreationUnit) {
    ActiveEffectBone = 'exhaust',
    ActiveEffectTemplateName = 'T1PGAmbient',
}
TypeClass = XNB1101