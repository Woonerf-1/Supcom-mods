-- ============================================================================
-- CustomAI.lua - Tooltips fuer die Lobby
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\lua\AI\CustomAITooltips\CustomAI.lua
--
-- ZWECK
-- Beschreibungstext, der in der Lobby erscheint, wenn die Maus ueber dem
-- KI-Eintrag steht. Ohne diese Datei meldet der Log je Anzeige:
--
--   warning: No tooltip in table for key: aitype_customai_aeon_air
--
-- WIE ES GELESEN WIRD
-- enhancedlobby.lua Z. 287-300 durchsucht jeden aktiven Mod nach
--   <mod>/lua/AI/CustomAITooltips/*.lua
-- und uebernimmt aus jeder Datei die Tabelle `Tooltips` in die Tooltipliste
-- der Lobby.
--
-- SCHLUESSEL
-- 'aitype_' plus der Key aus AIDefinitions.lua. Aufbau wie bei LOUDs eigenen
-- Eintraegen in gamedata.entpackt\lua\lua\ui\help\tooltips.lua Z. 770:
--
--   aitype_loud = { title = "LOUD AI", description = "..." }
--
-- ACHTUNG: dieser Pfad liegt UNTER lua\AI\, nicht unter hook\. Die Datei wird
-- importiert, nicht gehookt - sie darf deshalb nur Daten enthalten.
--
-- BEI EINER NEUEN KI hier einen Eintrag ergaenzen, sonst erscheint die Warnung
-- wieder. Die Texte sind bewusst kurz gehalten; das Tooltipfenster in der Lobby
-- bricht lange Zeilen nicht sauber um.
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 4bb
-- ============================================================================

Tooltips = {

    aitype_customai_aeon_air = {

        title = "Aeon Airforce",

        description = "Reine Luftwaffe mit Phasenplan nach der No-Rush-Einstellung. "
                      .."Bis 35 Prozent der Frist nur Wirtschaft und Tech, dann "
                      .."Flugabwehr, ab 55 Prozent minimale Bodenabwehr, ab 75 Prozent "
                      .."Truppen und Aufklaerung. Keine T1-Einheiten, keine "
                      .."T1-Verteidigung, hoechstens 8 Luftfabriken und keine "
                      .."Landfabriken. Schwerpunkt auf Quantentor und SCU. "
                      .."Bei No Rush 'Off' spielt sie wie die normale LOUD-KI.",
    },
}
