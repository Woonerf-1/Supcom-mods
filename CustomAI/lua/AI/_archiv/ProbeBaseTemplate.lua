-- ============================================================================
-- Sonden-Basistemplate - reiner Messaufbau, veraendert das Spiel NICHT
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\lua\AI\ProbeBaseTemplate.lua
--
-- Zweck: klaeren, ob
--   (a) ein Mod ueberhaupt ein eigenes BaseBuilderTemplate registrieren kann,
--   (b) FirstBaseFunction aufgerufen wird,
--   (c) der in der Lobby gewaehlte KI-Key dort noch ankommt.
--
-- WARUM DAS UNGEFAEHRLICH IST:
--   FirstBaseFunction gibt immer 0 zurueck. GetBestBasePlan startet mit
--   returnVal = 10 und uebernimmt einen Plan nur bei baseVal > returnVal
--   (aiarchetype-managerloader.lua Zeile 88-111). Dieses Template kann also
--   nie gewinnen - es beobachtet nur.
--   Builders ist leer, damit keine 'Invalid BuilderGroup'-Warnungen entstehen.
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 7
-- ============================================================================

-- Merker fuer die Hooks, damit nicht doppelt importiert wird
_G.CUSTOMAI_TEMPLATE_LOADED = true

LOG("CUSTOMAI: ProbeBaseTemplate.lua wird geladen")

BaseBuilderTemplate {

    BaseTemplateName = 'CustomAI_Probe',

    -- leer: keine BuilderGroups, also keine Warnungen beim Registrieren
    Builders = {},

    -- Pflichtfeld laut GlobalBaseTemplate.lua - sonst wird das Template verworfen
    BaseSettings = {},

    -- kann nie als Expansion gewaehlt werden
    ExpansionFunction = function(aiBrain, location, markerType)
        return 0
    end,

    -- Der eigentliche Messpunkt
    FirstBaseFunction = function(aiBrain)

        local key = 'NICHT VORHANDEN'

        if ScenarioInfo and ScenarioInfo.ArmySetup and ScenarioInfo.ArmySetup[aiBrain.Name] then
            key = tostring(ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality)
        end

        LOG("CUSTOMAI: FirstBaseFunction fuer "..tostring(aiBrain.Nickname)
            .." - ArmySetup.AIPersonality = "..key
            .." - aiBrain.Personality = "..tostring(aiBrain.Personality))

        -- immer 0: dieses Template gewinnt nie
        return 0
    end,
}
