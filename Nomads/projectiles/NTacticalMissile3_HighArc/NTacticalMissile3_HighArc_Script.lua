local NIFArtilleryMissile = import('/mods/nomads/lua/nomadsprojectiles.lua').NIFArtilleryMissile

NTacticalMissile3 = Class(NIFArtilleryMissile) {
    
    OnCreate = function(self, inWater)
        NIFArtilleryMissile.OnCreate(self, inWater)
    end,
}

TypeClass = NTacticalMissile3
