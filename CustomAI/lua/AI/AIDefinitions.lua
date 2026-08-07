-- ============================================================================
-- AIDefinitions.lua - die zentrale Liste aller KIs dieses Mods
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\lua\AI\AIDefinitions.lua
--
-- DIES IST DIE EINZIGE DATEI, DIE FUER EINE NEUE KI ZWINGEND ZU AENDERN IST.
-- Ein Eintrag hier bewirkt beides:
--   - die KI erscheint in der Lobby-Auswahlliste
--     (gelesen von CustomAIs_v2\CustomAI.lua)
--   - sie bekommt ein eigenes Basistemplate
--     (erzeugt von AIFactory.lua, angestossen von LoadAIs.lua)
--
-- Diese Datei wird von BEIDEN Seiten gelesen - UI (Lobby) und Sim.
-- Sie darf deshalb nichts tun ausser Daten zurueckzugeben: keine LOGs,
-- keine Engine-Aufrufe, keine globalen Variablen.
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 4
-- ============================================================================

-- ----------------------------------------------------------------------------
-- FELDER EINES EINTRAGS
--
--   Key          Pflicht. Eindeutige Kennung, klein geschrieben, mit Praefix
--                'customai_'. Landet in aiBrain.Personality und ist das
--                Unterscheidungsmerkmal im Basistemplate.
--                ACHTUNG: Die Duplikatspruefung der Engine funktioniert nicht -
--                zwei gleiche Keys erzeugen zwei Lobby-Eintraege.
--
--   Name         Pflicht. Anzeigename in der Lobby.
--                MUSS 'AI: LOUD' ENTHALTEN. Sonst tritt LOUD zurueck und
--                startet gar keinen Plan - die KI steht dann untaetig im Spiel.
--                Siehe aibrain.lua OnCreateAI, doc.claude\mods\CustomAI.md
--                Abschnitt 3.
--
--   Source       Pflicht. Name des LOUD-Basistemplates, von dem geerbt wird.
--                Verfuegbar sind die 14 Templates aus
--                gamedata.entpackt\lua\lua\AI\AIBaseTemplates\.
--                'Loud_Main_Standard' ist der grosse Standardaufbau.
--
--   Value        Optional, Vorgabe 200. Rueckgabewert der FirstBaseFunction,
--                wenn der Key passt. Muss ueber allen LOUD-Werten liegen -
--                Loud_Main_Standard gibt bis zu 100 zurueck. 200 gewinnt sicher.
--
--   Customize    Optional. Voller VFS-Pfad zu einer Datei mit
--                  function Apply(template, definition)
--                Dort wird das geerbte Template veraendert. Fehlt das Feld,
--                bleibt es eine unveraenderte Kopie - Verhalten wie LOUD.
--
--   Description  Optional. Nur fuer die Doku, wird nicht angezeigt.
-- ----------------------------------------------------------------------------

Definitions = {

    {
        Key    = 'customai_standard',
        Name   = 'AI: LOUD Standard (Custom)',
        Source = 'Loud_Main_Standard',
        Value  = 200,

        -- Keine Customize-Datei: das Template ist eine unveraenderte Kopie.
        -- Diese KI verhaelt sich damit exakt wie LOUD - das ist der
        -- Ausgangszustand, gegen den alle spaeteren Aenderungen gemessen werden.
        Customize = nil,

        Description = "Unveraenderte Kopie von Loud_Main_Standard. Referenzverhalten.",
    },

    -- --------------------------------------------------------------------
    -- VORLAGE fuer eine weitere KI - Kopieren, umbenennen, einkommentieren:
    --
    -- {
    --     Key       = 'customai_turtle',
    --     Name      = 'AI: LOUD Turtle (Custom)',
    --     Source    = 'Loud_Main_Standard',
    --     Value     = 200,
    --     Customize = '/mods/customai/lua/AI/AIs/Turtle.lua',
    --     Description = "Baut mehr Verteidigung, greift spaeter an.",
    -- },
    -- --------------------------------------------------------------------
}
