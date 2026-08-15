-- ============================================================================
-- ImprovedHydrocarbonPowerPlants - zentrale Blueprint-Anpassungen
--
-- Datei:     usermods\ImprovedHydrocarbonPowerPlants\hook\lua\system\Blueprints.lua
-- Wirkt auf: /lua/system/Blueprints.lua
-- Original:  gamedata.entpackt\lua\lua\system\Blueprints.lua  (ModBlueprints, Z. 521)
-- Doku:      doc.claude\mods\ImprovedHydrocarbonPowerPlants.md
--
-- Zweck: EINE Stelle, an der die Werte aller acht Kraftwerke vereinheitlicht
-- werden - einstellbar im Mod-Manager ueber config.lua.
-- Die Werte in den einzelnen _unit.bp werden dadurch ueberschrieben; dort steht
-- bewusst weiterhin der BlackOps-Originalwert, damit ein Diff gegen das
-- Original sauber bleibt.
--
-- Mechanismus: ModBlueprints() wird von LoadBlueprints() nach dem Einlesen
-- ALLER Blueprints aufgerufen, aber vor RegisterAllBlueprints(). Aenderungen
-- hier gelten also fuer das fertig zusammengefuehrte Blueprint.
-- Belegt im LOUD.log durch die Zeile "Hooked /lua/system/Blueprints.lua with ...".
--
-- Vorbild fuer den Zugriff auf die Mod-Einstellungen:
-- gamedata.entpackt\loud_misc\mods\Enhanced Static HP\hook\lua\system\Blueprints.lua
-- ============================================================================


-- Rueckfallwerte, falls die Konfiguration nicht gelesen werden konnte.
-- Muessen mit den in config.lua per 'default' markierten Eintraegen
-- uebereinstimmen.
local Vorgabe = {
    RegenRateT2 = 2,
    RegenRateT3 = 4,
    AdjacencyT2 = 'T2PowerGeneratorAdjacencyBuffs',
    AdjacencyT3 = 'T3PowerGeneratorAdjacencyBuffs',
}

-- ----------------------------------------------------------------------------
-- Feste Vereinheitlichung - BEWUSST NICHT im Mod-Manager einstellbar
-- ----------------------------------------------------------------------------
--
-- Energiespeicher der Stufe 2: BEB1202, BAB1202 und BRB1202 tragen im
-- BlackOps-Original 200, BSB1202 hat den Eintrag gar nicht. Das ist eine
-- Luecke im Original, keine Fraktionseigenheit - die uebrigen Werte der vier
-- sind bis auf Modellmasse identisch.
-- Zum Vergleich die T1-Kraftwerke aus dem Basisspiel: UEB/UAB/URB1102 = 500,
-- XSB1102 = 600.
--
-- Stufe 3 bleibt unberuehrt: dort hat KEINES der vier einen Eintrag, die
-- Stufe ist also bereits einheitlich.
local StorageEnergyT2 = 200

-- Muss mit uid in mod_info.lua uebereinstimmen.
local MODUID = 'AD88F006-304B-42E6-8612-E63918A7BE22'

local KraftwerkeT2 = { 'beb1202', 'bab1202', 'brb1202', 'bsb1202' }
local KraftwerkeT3 = { 'beb1302', 'bab1302', 'brb1302', 'bsb1302' }


do
    local OldModBlueprints = ModBlueprints

    function ModBlueprints(all_blueprints)

        OldModBlueprints(all_blueprints)

        -- Eigene Einstellungen aus dem Mod-Manager holen.
        local Konfiguration = nil

        for _, mod in __active_mods do
            if mod.uid == MODUID then
                Konfiguration = mod.config
                break
            end
        end

        if not Konfiguration then
            Konfiguration = {}
            LOG('IHPP: keine Mod-Konfiguration gefunden, Vorgabewerte werden verwendet')
        end

        -- config.lua liefert immer Zeichenketten - tonumber kann nil ergeben,
        -- deshalb der zusaetzliche Rueckfall.
        local Werte = {
            [1] = {   -- Stufe 2
                Regen         = tonumber(Konfiguration['RegenRateT2']) or Vorgabe.RegenRateT2,
                Adjacency     = Konfiguration['AdjacencyT2'] or Vorgabe.AdjacencyT2,
                StorageEnergy = StorageEnergyT2,
                Liste         = KraftwerkeT2,
                Name          = 'T2',
            },
            [2] = {   -- Stufe 3
                Regen         = tonumber(Konfiguration['RegenRateT3']) or Vorgabe.RegenRateT3,
                Adjacency     = Konfiguration['AdjacencyT3'] or Vorgabe.AdjacencyT3,
                StorageEnergy = nil,   -- Stufe 3 hat keinen Speicher, siehe oben
                Liste         = KraftwerkeT3,
                Name          = 'T3',
            },
        }

        local Einheiten = all_blueprints.Unit
        local gesetzt = 0
        local fehlend = {}

        for _, stufe in Werte do

            for _, id in stufe.Liste do

                local bp = Einheiten[id]

                if bp then

                    bp.Adjacency = stufe.Adjacency

                    -- Defense existiert bei allen acht, wird aber vorsichtshalber
                    -- angelegt: BAB1202 hatte im BlackOps-Original gar keinen
                    -- RegenRate-Eintrag.
                    if not bp.Defense then
                        bp.Defense = {}
                    end

                    bp.Defense.RegenRate = stufe.Regen

                    -- Nur setzen, wo ein einheitlicher Wert vorgegeben ist.
                    -- Bei Stufe 3 bleibt das Feld unangetastet.
                    if stufe.StorageEnergy then

                        if not bp.Economy then
                            bp.Economy = {}
                        end

                        bp.Economy.StorageEnergy = stufe.StorageEnergy
                    end

                    gesetzt = gesetzt + 1
                else
                    table.insert(fehlend, id)
                end
            end

            LOG('IHPP: '..stufe.Name..' - RegenRate = '..stufe.Regen
                ..', Adjacency = '..stufe.Adjacency
                ..', StorageEnergy = '..tostring(stufe.StorageEnergy or 'unveraendert'))
        end

        LOG('IHPP: '..gesetzt..' von 8 Kraftwerken vereinheitlicht')

        -- Sollte nie auftreten: unser Mod liefert alle acht Blueprints selbst.
        -- Erscheint diese Zeile, wurden sie von einem anderen Mod verdraengt.
        if table.getn(fehlend) > 0 then
            WARN('IHPP: Blueprint nicht gefunden: '..repr(fehlend))
        end
    end
end
