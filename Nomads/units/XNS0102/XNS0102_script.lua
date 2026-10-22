-- T1 frigate

local NSeaUnit = import('/mods/nomads/lua/nomadsunits.lua').NSeaUnit
local NTogglingUnit = import('/mods/nomads/lua/nomadsunits.lua').NTogglingUnit
local RocketWeapon1 = import('/mods/nomads/lua/nomadsweapons.lua').RocketWeapon1


XNS0102 = Class(NSeaUnit, NTogglingUnit) {
    Weapons = {

        
        AAGun1 = Class(RocketWeapon1) {},
        AAGun2 = Class(RocketWeapon1) {},
        ArtilleryGun1 = Class(RocketWeapon1) {},
        ArtilleryGun2 = Class(RocketWeapon1) {},
    },
    
    OnCreate = function(self)
        NSeaUnit.OnCreate(self)
        self:SetScriptBit('RULEUTC_SpecialToggle', true)
        self:SetWeaponAAMode(false)
    end,
    
    EnableSpecialToggle = NTogglingUnit.EnableSpecialToggle,
    DisableSpecialToggle = NTogglingUnit.DisableSpecialToggle,
    --specify how many weapons there are that need toggling - usually its just one pair.
    ToggleWeaponPairs = {{'ArtilleryGun1','AAGun1'},{'ArtilleryGun2','AAGun2'},},
}

TypeClass = XNS0102