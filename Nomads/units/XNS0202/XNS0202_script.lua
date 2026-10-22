-- T2 cruiser

local AddNavalLights = import('/mods/nomads/lua/nomadsutils.lua').AddNavalLights
local NSeaUnit = import('/mods/nomads/lua/nomadsunits.lua').NSeaUnit
local RocketWeapon1 = import('/mods/nomads/lua/nomadsweapons.lua').RocketWeapon1
local EnergyCannon1 = import('/mods/nomads/lua/nomadsweapons.lua').EnergyCannon1

NSeaUnit = AddNavalLights(NSeaUnit)

XNS0202 = Class(NSeaUnit) {
    Weapons = {
        AATurret = Class(RocketWeapon1) {},
        GunTurret = Class(EnergyCannon1) {},
    },

    LightBone_Left = 'Light2',
    LightBone_Right = 'Light1',
    DestructionTicks = 200,
}

TypeClass = XNS0202
