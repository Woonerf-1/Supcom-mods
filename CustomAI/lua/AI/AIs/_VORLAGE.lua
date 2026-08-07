-- ============================================================================
-- _VORLAGE.lua - Kopiervorlage fuer eine KI-Anpassung
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\lua\AI\AIs\_VORLAGE.lua
--
-- SO LEGT MAN EINE NEUE KI AN:
--   1. Diese Datei kopieren, z. B. nach AIs\Turtle.lua
--   2. Die Funktion Apply() mit Inhalt fuellen
--   3. In ..\AIDefinitions.lua einen Eintrag ergaenzen:
--        {
--            Key       = 'customai_turtle',
--            Name      = 'AI: LOUD Turtle (Custom)',
--            Source    = 'Loud_Main_Standard',
--            Customize = '/mods/customai/lua/AI/AIs/Turtle.lua',
--        }
--   4. Spiel starten, Log auf 'CUSTOMAI:' pruefen
--
-- Der Dateiname mit fuehrendem Unterstrich haelt diese Vorlage aus jeder
-- alphabetischen Auflistung heraus. Sie wird nie importiert, solange sie in
-- keiner Definition steht.
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 4
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Apply(template, definition)
--
--   template    Tiefe Kopie des LOUD-Basistemplates aus definition.Source.
--               Aenderungen betreffen NUR diese Kopie - LOUDs Original bleibt
--               unberuehrt und steht weiter fuer die LOUD-KI bereit.
--
--   definition  Der Eintrag aus AIDefinitions.lua, falls Werte gebraucht werden.
--
-- Rueckgabewert wird nicht ausgewertet; das Template wird direkt veraendert.
--
-- NICHT ANFASSEN:
--   template.BaseTemplateName   von der Fabrik gesetzt, sonst wird LOUDs
--                               Template ueberschrieben statt ergaenzt
--   template.FirstBaseFunction  von der Fabrik gesetzt, steuert die Basiswahl
-- ----------------------------------------------------------------------------
function Apply(template, definition)

    -- ------------------------------------------------------------------
    -- BEISPIEL 1 - eine BuilderGroup entfernen
    --
    -- template.Builders ist eine Liste von BuilderGroup-Namen. Die gueltigen
    -- Namen stehen in
    --   gamedata.entpackt\lua\lua\AI\AIBuilders\
    -- GlobalBaseTemplate.lua prueft jeden Namen beim Registrieren und warnt
    -- bei Tippfehlern: 'Invalid BuilderGroup named - <name>'
    -- ------------------------------------------------------------------
    --
    -- local neu = {}
    -- for i, name in template.Builders do
    --     if name != 'Engineer Nuke Construction' then
    --         table.insert(neu, name)
    --     end
    -- end
    -- template.Builders = neu

    -- ------------------------------------------------------------------
    -- BEISPIEL 2 - eine BuilderGroup ergaenzen
    -- ------------------------------------------------------------------
    --
    -- table.insert(template.Builders, 'Engineer Base Defense Construction - Core')

    -- ------------------------------------------------------------------
    -- BEISPIEL 3 - eine Einstellung aendern
    --
    -- template.BaseSettings enthaelt u. a. RallyPointRadius. Welche Felder es
    -- gibt, zeigt die Quelldatei, z. B.
    --   gamedata.entpackt\lua\lua\AI\AIBaseTemplates\Loud_Main_Standard.lua
    -- ------------------------------------------------------------------
    --
    -- if template.BaseSettings then
    --     template.BaseSettings.RallyPointRadius = 60
    -- end

    LOG("CUSTOMAI: Apply() der Vorlage aufgerufen - keine Aenderung vorgenommen")

end
