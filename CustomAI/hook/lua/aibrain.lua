-- ============================================================================
-- Hook auf /lua/aibrain.lua - Rueckfallebene
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\hook\lua\aibrain.lua
-- Hookt: /lua/aibrain.lua
--
-- Der Hook auf simInit.lua ist der regulaere Einstiegspunkt und hat in allen
-- bisherigen Testlaeufen gegriffen. Dieser Hook springt nur ein, falls das
-- einmal nicht so sein sollte - erkennbar am Merker CUSTOMAI_TEMPLATE_LOADED.
--
-- Die Zeile im Log sagt zugleich, welcher Weg geladen hat:
--   "KIs waren schon geladen"  -> simInit-Hook hat geladen (Regelfall)
--   "lade KIs ueber aibrain"   -> simInit-Hook hat NICHT gegriffen
--
-- ACHTUNG - STRIKTE GLOBALS:
-- Merker immer mit rawget(_G, '<name>') pruefen. Ein Fehler ist hier besonders
-- teuer: aibrain.lua wird per import geladen, ein Fehler bricht den Import ab
-- und damit den gesamten Sim-Start (Sim::Create() crashed) - das Spiel haengt
-- im Ladeschirm. Genau so passiert in Testlauf 1, 2026-08-06.
-- Siehe doc.claude\04_LUA_SIM.md Abschnitt 2.
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 4
-- ============================================================================

if not rawget(_G, 'CUSTOMAI_TEMPLATE_LOADED') then

    LOG("CUSTOMAI: lade KIs ueber aibrain-Hook"
        .." - der simInit-Hook hat also NICHT gegriffen")

    import('/mods/customai/lua/AI/LoadAIs.lua')

else

    LOG("CUSTOMAI: KIs waren schon geladen - simInit-Hook hat gegriffen")

end
