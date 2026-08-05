--   /lua/sim/buffdefinition.lua

local AdjBuffFuncs = import('/lua/sim/adjacencybufffunctions.lua')

-- Add at the top of your script file or in a separate buffs file
BuffBlueprint {
    Name = 'CapacitorEngineering',
    DisplayName = 'Capacitor Engineering Boost',
    BuffType = 'CAPACITORENG',
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        BuildRate = {
            Add = 0,
            Mult = 2.0,
        },
    },
}

BuffBlueprint {
    Name = 'CapacitorIntel',
    DisplayName = 'Capacitor Intel Boost',
    BuffType = 'CAPACITORINTEL',
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        VisionRadius = {
            Add = 15,
            Mult = 1.0,
        },
        RadarRadius = {
            Add = 15,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'CapacitorRegen',
    DisplayName = 'Capacitor Regen Boost',
    BuffType = 'CAPACITORREGEN',
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        Regen = {
            Add = 150,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'CapacitorROF',
    DisplayName = 'Capacitor ROF Boost',
    BuffType = 'CAPACITORROF',
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        RateOfFire = {
            Add = 0,
            Mult = 1.5,
        },
    },
}

BuffBlueprint { Name = 'ACU_T2_Engineering_NMD',
    BuffType = 'ACUBUILDRATE',
	ParsedEntityCategory = categories.COMMAND,
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        BuildRate = {
            Add =  0,
            Mult = 3.5,       -- from 10 to 35
		},
        MaxHealth = {
            Add = 0,
            Mult = 1.35,
        },
        SpeedMult = {
			Add = 0,
			Mult = 1.07,
		},  
        Regen = {
            Add = 0,
            Mult = 3.0,     -- from 10 to 30
        },
	},

}

BuffBlueprint { Name = 'ACU_T3_Engineering_NMD',
    BuffType = 'ACUBUILDRATE',
	ParsedEntityCategory = categories.COMMAND,
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        BuildRate = {
            Add =  0,
            Mult = 10,       -- from 10 to 100
        },
        MaxHealth = {
            Add = 0,
            Mult = 1.65,
        },
        SpeedMult = {
			Add = 0,
			Mult = 1.14,
		},
        Regen = {
            Add = 0,
            Mult = 6.0,     -- from 10 to 60
        },
    },
}

BuffBlueprint { Name = 'ACU_T4_Engineering_NMD',
    BuffType = 'ACUBUILDRATE',
	ParsedEntityCategory = categories.COMMAND,
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        BuildRate = {
            Add =  0,
            Mult = 18,      -- from 10 to 180
        },
        MaxHealth = {
            Add = 0,
            Mult = 2.0,
        },
		SpeedMult = {
			Add = 0,
			Mult = 1.4,
		},
        AccelMult = {
            Add = 0,
            Mult = 1.16,
        },
        TurnMult = {
            Add = 0,
            Mult = 1.16,
        },
        Regen = {
            Add = 0,
            Mult = 10.0,     -- from 10 to 100
        },
    },
}

if __moduleinfo then
    __moduleinfo.auto_reload = true
end
