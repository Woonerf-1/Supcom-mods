-- ============================================================================
-- LoadAIs.lua - laeuft die Definitionsliste durch und registriert jede KI
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\lua\AI\LoadAIs.lua
-- Aufgerufen von: hook\lua\simInit.lua
--
-- Diese Datei ist der einzige Einstiegspunkt in den Sim. Sie enthaelt keine
-- Logik ausser der Schleife - was zu tun ist, steht in AIDefinitions.lua,
-- wie es getan wird in AIFactory.lua.
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 4
-- ============================================================================

-- Merker gegen doppeltes Laden.
-- ACHTUNG: rawget ist Pflicht - ein direkter Zugriff auf eine nicht gesetzte
-- globale Variable ist im Sim ein FEHLER, kein nil (config.lua Z. 94-96).
-- Ein solcher Fehler in einer per import geladenen Datei laesst den gesamten
-- Sim-Start scheitern; das Spiel haengt dann im Ladeschirm.
-- Genau so passiert in Testlauf 1, siehe doc.claude\04_LUA_SIM.md Abschnitt 2.
_G.CUSTOMAI_TEMPLATE_LOADED = true

local definitions = import('/mods/customai/lua/AI/AIDefinitions.lua').Definitions
local RegisterAI  = import('/mods/customai/lua/AI/AIFactory.lua').RegisterAI

local count = 0
local total = 0

for i, def in definitions do

    total = total + 1

    if RegisterAI(def) then
        count = count + 1
    end
end

LOG("CUSTOMAI: "..count.." von "..total.." KIs registriert")
