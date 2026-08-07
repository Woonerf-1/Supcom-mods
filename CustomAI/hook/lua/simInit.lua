-- ============================================================================
-- Hook auf /lua/simInit.lua - Einstiegspunkt des Mods in den Sim
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\hook\lua\simInit.lua
-- Hookt: /lua/simInit.lua
--
-- WARUM UEBERHAUPT EIN HOOK:
-- simInit.lua laedt AI-Templates nur aus /lua/ai/... (Zeilen 353-363), ohne
-- Schleife ueber aktive Mods - anders als GetAIList() in enhancedlobby.lua.
-- Ein Mod muss seine eigenen Templates deshalb selbst nachziehen.
--
-- WARUM DIESE STELLE:
-- Der Hook laeuft nach dem Original im selben Environment. Zu diesem Zeitpunkt
-- sind der Konstruktor BaseBuilderTemplate{} (simInit Z. 54) und alle
-- LOUD-Basistemplates (Z. 363) bereits vorhanden. Die Fabrik kann also von
-- ihnen erben. Belegt durch Testlauf 2, 2026-08-07.
--
-- REIHENFOLGE:
-- Dieser Hook laeuft vor dem Hook auf aibrain.lua - ebenfalls in Testlauf 2
-- belegt. Der aibrain-Hook ist nur Rueckfallebene.
--
-- ACHTUNG - STRIKTE GLOBALS:
-- Der Zugriff auf eine NICHT gesetzte globale Variable ist im Sim ein FEHLER,
-- nicht nil (gamedata.entpackt\lua\lua\system\config.lua Z. 94-96). Merker
-- deshalb immer mit rawget(_G, '<name>') pruefen. Ein Fehler an dieser Stelle
-- laesst den gesamten Sim-Start scheitern - das Spiel haengt im Ladeschirm.
-- Siehe doc.claude\04_LUA_SIM.md Abschnitt 2.
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 4
-- ============================================================================

LOG("CUSTOMAI: Hook auf simInit.lua greift")

if not rawget(_G, 'CUSTOMAI_TEMPLATE_LOADED') then

    import('/mods/customai/lua/AI/LoadAIs.lua')

else

    LOG("CUSTOMAI: KIs waren schon geladen")

end
