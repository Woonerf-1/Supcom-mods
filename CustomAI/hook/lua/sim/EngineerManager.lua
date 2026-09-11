-- ============================================================================
-- hook\lua\sim\EngineerManager.lua
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\hook\lua\sim\EngineerManager.lua
--
-- ZWECK
-- Die Wartezeit kuerzen, die ein Techniker einlegt, wenn er gerade keine
-- Aufgabe bekommt.
--
-- Doku: doc.claude\mods\CustomAI.md
-- ============================================================================

-- ----------------------------------------------------------------------------
-- WIE LOUD DIE WARTEZEIT BERECHNET
--
-- EngineerManager.lua Z. 391-399:
--
--   DelayAssignEngineerTask = function( self, unit, aiBrain )
--       local delay = LOUDMIN( 101, 14 + ((unit.failedbuilds or 0) * 5))
--       ...
--       WaitTicks( delay )
--
-- `failedbuilds` waechst um 1, sooft kein Auftrag gefunden wurde (Z. 304 und
-- Z. 379), und wird auf 0 zurueckgesetzt, sobald einer gefunden ist (Z. 316).
--
-- Grundwert sind 14 Ticks, also 1,4 Sekunden. Nach rund 18 vergeblichen
-- Anlaeufen sind es 101 Ticks - **gut zehn Sekunden**. Genau so lange steht ein
-- Techniker dann noch herum, nachdem wieder etwas zu tun waere.
--
-- Bei dieser KI faellt das besonders auf, weil viele Bauauftraege an
-- Bedingungen haengen: der Techniker findet reihenweise nichts, `failedbuilds`
-- klettert auf den Hoechstwert, und wenn eine Sperre faellt, merkt er es erst
-- zehn Sekunden spaeter.
--
-- ACHTUNG: die Wartezeit ist Absicht. Der Kommentar im Original lautet
-- "Delays him before seeking a new task to avoid thrashing the EM".
-- Kuerzere Wartezeiten heissen mehr Suchlaeufe und damit mehr Rechenzeit.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- DER EINGRIFF
--
-- Statt die Funktion nachzubauen, wird nur `failedbuilds` gedeckelt, bevor das
-- Original laeuft. Die Formel bleibt LOUDs, das Ergebnis ist begrenzt:
--
--   Deckel 0  ->  14 Ticks  (1,4 s)
--   Deckel 2  ->  24 Ticks  (2,4 s)
--   Deckel 6  ->  44 Ticks  (4,4 s)
--
-- `failedbuilds` wird sonst nirgends gelesen - geprueft in EngineerManager.lua
-- und aibehaviors.lua -, der Deckel hat also keine Nebenwirkung.
--
-- ZEITABHAENGIG
--
-- Der Deckel gilt nur bis zu einem Zeitpunkt, danach laeuft LOUDs Original
-- unveraendert. Begruendung des Nutzers: solange die No-Rush-Frist laeuft, hat
-- die KI wenige Einheiten und wenige Basen - da kostet haeufiges Suchen nichts.
-- Spaeter, mit vielen Technikern und Aussenposten, ist LOUDs Bremse berechtigt.
--
-- Wert 'NoRush' bindet die Grenze an die Lobbyeinstellung; eine Zahl gilt als
-- Spielsekunden.
-- ----------------------------------------------------------------------------

local Deckel = false
local Grenze = false

-- Der Import passiert beim ersten Aufruf, nicht beim Laden der Datei.
local function EinstellungHolen(key)

    if not Deckel then

        Deckel = {}
        Grenze = {}

        local ok, modul = pcall(import, '/mods/customai/lua/AI/AIDefinitions.lua')

        if ok and modul and modul.Definitions then

            for i, d in modul.Definitions do

                if d.Key and d.TechnikerWartezeitFehlschlaege then

                    Deckel[d.Key] = d.TechnikerWartezeitFehlschlaege

                    local bis = d.TechnikerWartezeitBis

                    if bis == 'NoRush' then

                        local wert = false
                        local SI    = rawget(_G, 'ScenarioInfo')

                        if SI and SI.Options then
                            wert = SI.Options.NoRushOption
                        end

                        bis = (tonumber(wert) or 0) * 60
                    end

                    Grenze[d.Key] = bis or 0

                    LOG("CUSTOMAI Techniker: "..d.Key.." - failedbuilds gedeckelt auf "
                        ..d.TechnikerWartezeitFehlschlaege
                        .." (Wartezeit hoechstens "
                        ..(14 + d.TechnikerWartezeitFehlschlaege * 5)
                        .." Ticks), gueltig bis Sekunde "..Grenze[d.Key])
                end
            end
        else
            WARN("CUSTOMAI Techniker: AIDefinitions.lua nicht ladbar - Hook wirkungslos")
        end
    end

    return Deckel[key], Grenze[key]
end

local altEngineerManager = EngineerManager

EngineerManager = Class(altEngineerManager) {

    DelayAssignEngineerTask = function( self, unit, aiBrain )

        if aiBrain and unit then

            local key = aiBrain.CustomAIKey

            if key then

                local n, bis = EinstellungHolen(key)

                -- CycleTime ist die Spielzeit in Sekunden.
                -- bis = 0 heisst: kein Deckel (etwa bei No-Rush 'Off').
                if n and bis and bis > 0 and aiBrain.CycleTime < bis then

                    if (unit.failedbuilds or 0) > n then
                        unit.failedbuilds = n
                    end
                end
            end
        end

        return altEngineerManager.DelayAssignEngineerTask( self, unit, aiBrain )
    end,
}
