-- ============================================================================
-- ImprovedHydrocarbonPowerPlants - Einstellungen fuer den Mod-Manager
--
-- Datei: usermods\ImprovedHydrocarbonPowerPlants\config.lua
-- Doku:  doc.claude\mods\ImprovedHydrocarbonPowerPlants.md
--
-- Gelesen von mods.lua, AllMods() (Z. 277-292). Die gewaehlten Werte landen
-- im Spielerprofil (Prefs, Schluessel 'modConfig'), NICHT im Mod. Sie sind zur
-- Laufzeit ueber __active_mods[i].config[<key>] erreichbar - so liest es der
-- Hook in hook\lua\system\Blueprints.lua.
--
-- 'default' ist ein 1-basierter INDEX in die values-Liste, kein Schluessel.
-- 'key' ist der Wert, der spaeter ankommt - immer eine Zeichenkette, im Hook
-- ggf. mit tonumber() umzuwandeln.
--
-- Achtung: einmal gewaehlte Werte bleiben im Profil stehen. Eine Aenderung der
-- Vorgabe hier wirkt nur fuer Spieler, die den Mod noch nie eingestellt haben
-- (mods.lua Z. 285: nur wenn noch kein Wert gespeichert ist).
-- ============================================================================

config = {

    -- ------------------------------------------------------------------
    -- Selbstreparatur
    -- ------------------------------------------------------------------
    -- Im BlackOps-Original uneinheitlich: T2 = 1/-/2/2, T3 = 2/2/4/3
    -- (UEF/Aeon/Cybran/Seraphim); Aeon T2 hatte gar keinen Eintrag.
    -- Hier fuer alle vier Fraktionen gleich.

    {   key     = 'RegenRateT2',
        label   = "Selbstreparatur Stufe 2",
        default = 3,                       -- Index 3 = '2'
        values = {
            { text = "0 - keine",           key = '0'  },
            { text = "1",                   key = '1'  },
            { text = "2 (Vorgabe)",         key = '2'  },
            { text = "3",                   key = '3'  },
            { text = "4",                   key = '4'  },
            { text = "5",                   key = '5'  },
            { text = "6",                   key = '6'  },
            { text = "7",                   key = '7'  },
            { text = "8",                   key = '8'  },
            { text = "9",                   key = '9'  },
            { text = "10",                  key = '10' },
        },
    },

    {   key     = 'RegenRateT3',
        label   = "Selbstreparatur Stufe 3",
        default = 5,                       -- Index 5 = '4'
        values = {
            { text = "0 - keine",           key = '0'  },
            { text = "1",                   key = '1'  },
            { text = "2",                   key = '2'  },
            { text = "3",                   key = '3'  },
            { text = "4 (Vorgabe)",         key = '4'  },
            { text = "5",                   key = '5'  },
            { text = "6",                   key = '6'  },
            { text = "7",                   key = '7'  },
            { text = "8",                   key = '8'  },
            { text = "9",                   key = '9'  },
            { text = "10",                  key = '10' },
        },
    },

    -- ------------------------------------------------------------------
    -- Nachbarschaftsboni
    -- ------------------------------------------------------------------
    -- WICHTIG: wirkt nur auf das, was das Kraftwerk seinen Nachbarn GIBT,
    -- nicht auf das, was es bekommt (defaultunits.lua, StructureUnit
    -- OnAdjacentTo, Z. 969-984: ApplyBuff(adjacentUnit, v, self)).
    -- Bei einem Ring aus Energiespeichern ist die Einstellung wirkungslos -
    -- Speicher bauen nichts und verbrauchen keine Wartungsenergie.
    -- Sie greift nur bei Nachbarn, die Energie verbrauchen: Fabriken,
    -- Schilde, Massefabrikatoren, Verteidigung.
    --
    -- Werte aus gamedata.entpackt\lua\lua\sim\AdjacencyBuffs.lua:
    --   'HydrocarbonAdjacencyBuffs'       Z.  623   24 Eintraege
    --   'T2PowerGeneratorAdjacencyBuffs'  Z.  655   24, inhaltlich identisch
    --   'T3PowerGeneratorAdjacencyBuffs'  Z. 1078   20, rund Faktor 1,5-2,0

    {   key     = 'AdjacencyT2',
        label   = "Nachbarschaftsboni Stufe 2",
        default = 2,
        values = {
            {   text = "Hydrocarbon - wie das T1-Kraftwerk",
                key  = 'HydrocarbonAdjacencyBuffs',
            },
            {   text = "T2-Kraftwerk (Vorgabe) - inhaltlich gleich",
                key  = 'T2PowerGeneratorAdjacencyBuffs',
            },
            {   text = "T3-Kraftwerk - rund doppelt so stark",
                key  = 'T3PowerGeneratorAdjacencyBuffs',
            },
        },
    },

    {   key     = 'AdjacencyT3',
        label   = "Nachbarschaftsboni Stufe 3",
        default = 3,
        values = {
            {   text = "Hydrocarbon - wie das T1-Kraftwerk",
                key  = 'HydrocarbonAdjacencyBuffs',
            },
            {   text = "T2-Kraftwerk - inhaltlich gleich wie Hydrocarbon",
                key  = 'T2PowerGeneratorAdjacencyBuffs',
            },
            {   text = "T3-Kraftwerk (Vorgabe) - rund doppelt so stark",
                key  = 'T3PowerGeneratorAdjacencyBuffs',
            },
        },
    },
}
