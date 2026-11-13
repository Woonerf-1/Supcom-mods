-- Nomads: Ingenieur-Ausbauten des Kommandanten, siehe doc.claude\mods\Nomads.md (Abschnitt Hooks).
-- ACU_T*_Engineering_NMD-Buffs und die vier Capacitor-Buffs (genutzt von units\XNL0001\XNL0001_script.lua).
-- Die Capacitor-Buffs muessen hier stehen: CapacitorDischargeThread wendet sie an, ohne dass
-- ApplyCapacitorBuffs (das sie zur Laufzeit erneut definiert) vorher gelaufen sein muss.
-- Werte wie in ApplyCapacitorBuffs, damit beide Wege gleich wirken.
-- AdjBuffFuncs und auto_reload hat LOUDs Datei schon.

BuffBlueprint {
    Name = 'CapacitorEngineering',
    DisplayName = 'Capacitor Engineering Boost',
    BuffType = 'CAPACITORENG',
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        BuildRate = {
            Add = 0,
            Mult = 2.5,
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
            Add = 0,
            Mult = 1.5,
        },
        RadarRadius = {
            Add = 0,
            Mult = 1.5,
        },
        OmniRadius = {
            Add = 0,
            Mult = 1.5,
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

