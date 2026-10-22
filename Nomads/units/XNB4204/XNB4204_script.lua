local NStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local NAMFlakWeapon = import('/lua/cybranweapons.lua').CAMZapperWeapon


--- Tech 2 Tactical Missle Defense
---@class XNB4204 : NStructureUnit
XNB4204 = Class(NStructureUnit) {
    Weapons = {
        Turret01 = Class(NAMFlakWeapon) {
            TMDEffectBones = {'RadarDish',},
            SalvoReloadTime = 1.4, --Change this to the correct amount for the weapon.
        },
    },


}
TypeClass = XNB4204