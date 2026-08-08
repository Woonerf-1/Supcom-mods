-- ============================================================================
-- Hook auf /lua/aibrain.lua
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\hook\lua\aibrain.lua
-- Hookt: /lua/aibrain.lua
--
-- ZWEI AUFGABEN:
--   1. Personality auf 'loud' setzen, damit die eigene KI die vollen Cheats
--      bekommt (siehe unten)
--   2. Rueckfallebene fuer das Laden der KI-Definitionen, falls der Hook auf
--      simInit.lua einmal nicht greifen sollte
--
-- ---------------------------------------------------------------------------
-- WARUM AUFGABE 1
--
-- Es gibt ZWEI aehnlich benannte Felder mit verschiedenem Verhalten:
--
--   aiBrain.Personality
--     gesetzt in aibrain.lua Z. 893 aus dem Lobby-Key
--     danach NIE wieder geaendert
--     -> hier steht dauerhaft z. B. 'customai_standard'
--
--   ScenarioInfo.ArmySetup[<Armee>].AIPersonality
--     erst der Lobby-Key, dann von SetupMainBase (aiarchetype-managerloader.lua
--     Z. 47) mit dem baseType ueberschrieben
--     -> hier steht spaeter 'loud'
--
-- Das Cheat-System prueft aiBrain.Personality:
--
--   aiutilities.lua Z. 842  SetupAICheat:    if Personality != 'loud' then return end
--   aiutilities.lua Z.1025  ApplyCheatBuffs: if Personality == 'loud' then ... end
--
-- Ohne diesen Hook fehlen einer eigenen KI: VeterancyMult, MinorCheatModifier,
-- MajorCheatModifier, BuildRateModifier, CheatIntel, CheatALL, CheatMOBILE,
-- CheatENG, CheatCDROmni, die ACU-Startvorraete und der Ausgleich bei
-- Unterzahl. Uebrig blieben nur CheatIncome und CheatBuildRate.
--
-- Der Rueckgabewert 'loud' aus unserer FirstBaseFunction hilft dagegen NICHT -
-- er landet nur im ScenarioInfo-Feld.
--
-- Der urspruengliche Key wird in self.CustomAIKey aufbewahrt.
-- Die FirstBaseFunction bleibt unberuehrt: sie liest das ScenarioInfo-Feld,
-- das zu ihrem Zeitpunkt noch den Lobby-Key traegt.
--
-- ACHTUNG - STRIKTE GLOBALS:
-- Merker immer mit rawget(_G, '<name>') pruefen. Ein direkter Zugriff auf eine
-- nicht gesetzte globale Variable ist im Sim ein FEHLER, nicht nil
-- (system\config.lua Z. 94-96). Ein Fehler hier bricht den Import von
-- aibrain.lua ab und damit den gesamten Sim-Start - das Spiel haengt dann im
-- Ladeschirm. Genau so passiert in Testlauf 1.
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 4
--       doc.claude\mods\CustomAI_Stellschrauben.md, Abschnitt
--       "KI-Key und Personality"
-- ============================================================================

-- --- Aufgabe 2: Rueckfallebene -------------------------------------------

if not rawget(_G, 'CUSTOMAI_TEMPLATE_LOADED') then

    LOG("CUSTOMAI: lade KIs ueber aibrain-Hook"
        .." - der simInit-Hook hat also NICHT gegriffen")

    import('/mods/customai/lua/AI/LoadAIs.lua')

else

    LOG("CUSTOMAI: KIs waren schon geladen - simInit-Hook hat gegriffen")

end


-- --- Aufgabe 1: Personality umschreiben ----------------------------------

local oldAIBrain = AIBrain

AIBrain = Class(oldAIBrain) {

    OnCreateAI = function(self, planName)

        -- zuerst das Original, es setzt self.Personality und self.CheatValue
        oldAIBrain.OnCreateAI(self, planName)

        local personality = self.Personality

        if personality and string.find( personality, 'customai_' ) then

            -- Key aufbewahren - fuer eigene Auswertungen zur Laufzeit
            self.CustomAIKey = personality

            self.Personality = 'loud'

            LOG("CUSTOMAI: "..tostring(self.Nickname)
                .." - Personality von '"..personality.."' auf 'loud' gesetzt"
                .." (CustomAIKey = '"..personality.."', CheatValue = "
                ..tostring(self.CheatValue)..")")
        end
    end,
}
