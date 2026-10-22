-- Nomads: Ingenieur-Ausbauten des Kommandanten, siehe doc.claude\mods\Nomads.md (Abschnitt Hooks).
-- Nur die ACU_T*_Engineering_NMD-Buffs (genutzt von units\XNL0001\XNL0001_script.lua); die Capacitor-Buffs
-- definiert XNL0001 zur Laufzeit selbst. AdjBuffFuncs und auto_reload hat LOUDs Datei schon.

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

