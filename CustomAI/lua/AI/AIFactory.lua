-- ============================================================================
-- AIFactory.lua - erzeugt aus einem Eintrag der Definitionsliste ein
--                 BaseBuilderTemplate, das von einem LOUD-Template erbt
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\lua\AI\AIFactory.lua
-- Laeuft im Sim. Aufgerufen von LoadAIs.lua, das per Hook auf simInit.lua
-- angestossen wird.
--
-- GRUNDGEDANKE - WEG A ("aufsetzen"):
-- LOUDs KI laeuft vollstaendig weiter. Wir stellen lediglich ein eigenes
-- Basistemplate daneben, das die Basiswahl gewinnt, wenn der Spieler unsere
-- KI ausgewaehlt hat. Alles andere - Builder, Platoons, Manager - bleibt LOUDs.
--
-- WARUM ERBEN STATT KOPIEREN:
-- Ein von Hand nachgebautes Template waere nach dem naechsten LOUD-Update
-- veraltet. Stattdessen wird zur Laufzeit die bereits registrierte
-- LOUD-Fassung aus der globalen Tabelle BaseBuilderTemplates geholt und
-- tief kopiert. Aenderungen betreffen nur die Kopie.
--
-- ZEITPUNKT:
-- simInit.lua laedt die LOUD-Templates in den Zeilen 353-363. Unser Hook
-- laeuft danach - die Quelle ist also vorhanden. Belegt durch Testlauf 2
-- (2026-08-07).
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 4
-- ============================================================================

local LOG = LOG
local WARN = WARN

-- ----------------------------------------------------------------------------
-- Tiefe Kopie. Eigene Umsetzung statt table.copy, damit keine Annahme ueber
-- vorhandene Hilfsfunktionen noetig ist.
-- Achtung FA-Lua: 'for k,v in t do' ohne pairs(), siehe 04_LUA_SIM.md.
-- ----------------------------------------------------------------------------
local function DeepCopy(orig)

    if type(orig) != 'table' then
        return orig
    end

    local copy = {}

    for k, v in orig do
        copy[k] = DeepCopy(v)
    end

    return copy
end

-- ----------------------------------------------------------------------------
-- Erzeugt und registriert das Basistemplate fuer eine Definition.
-- Rueckgabe: true bei Erfolg, false sonst.
-- ----------------------------------------------------------------------------
function RegisterAI(def)

    -- --- Pflichtfelder pruefen -------------------------------------------
    if not def or not def.Key or not def.Name or not def.Source then
        WARN("CUSTOMAI: Definition unvollstaendig - Key, Name und Source sind Pflicht")
        return false
    end

    -- --- Weg-A-Bedingung pruefen -----------------------------------------
    -- Ohne 'AI: LOUD' im Namen startet LOUD keinen Plan und die KI bleibt
    -- untaetig. Das ist der haeufigste Fehler - deshalb hier eine Warnung
    -- statt eines stillen Fehlverhaltens.
    if not string.find(def.Name, 'AI: LOUD') then
        WARN("CUSTOMAI: Name \""..def.Name.."\" enthaelt nicht 'AI: LOUD'. "
             .."LOUD wird keinen Plan starten und die KI bleibt untaetig. "
             .."Siehe doc.claude\\mods\\CustomAI.md Abschnitt 3.")
    end

    -- --- Quelltemplate holen ---------------------------------------------
    local source = BaseBuilderTemplates[def.Source]

    if not source then
        WARN("CUSTOMAI: Quelltemplate \""..def.Source.."\" nicht gefunden - "
             ..def.Key.." wird uebersprungen")
        return false
    end

    -- --- Kopie anlegen ----------------------------------------------------
    local template = DeepCopy(source)

    -- Eigener Name, sonst wuerde die Registrierung das LOUD-Template
    -- ueberschreiben statt danebenzustehen (GlobalBaseTemplate.lua ergaenzt
    -- bei gleichem Namen feldweise).
    template.BaseTemplateName = 'CustomAI_'..def.Key

    -- --- Basiswahl steuern ------------------------------------------------
    local key   = def.Key
    local value = def.Value or 200

    -- Gewinnt genau dann, wenn dieser Spieler unsere KI ausgewaehlt hat.
    --
    -- Der Lobby-Key steht zu diesem Zeitpunkt noch in AIPersonality:
    -- GetBestBasePlan ruft FirstBaseFunction VOR dem Ueberschreiben in
    -- SetupMainBase Zeile 47. Belegt durch Testlauf 3 (2026-08-07).
    --
    -- Rueckgabe 'loud' als baseType, nicht der eigene Key: alle LOUD-Templates
    -- geben 'loud' zurueck, und der Wert landet anschliessend in
    -- AIPersonality. Ob nachgelagerte LOUD-Logik darauf prueft, ist ungeprueft -
    -- 'loud' ist die sichere Wahl. Siehe doc.claude\TODO.md.
    template.FirstBaseFunction = function(aiBrain)

        local personality = nil

        if ScenarioInfo and ScenarioInfo.ArmySetup and ScenarioInfo.ArmySetup[aiBrain.Name] then
            personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        end

        if personality == key then

            LOG("CUSTOMAI: "..tostring(aiBrain.Nickname).." verwendet Template "
                ..template.BaseTemplateName)

            return value, 'loud'
        end

        -- fremde KI: nicht bewerben
        return 0
    end

    -- --- Anpassung durch die jeweilige KI ---------------------------------
    if def.Customize then

        local ok, mod = pcall(import, def.Customize)

        if ok and mod and mod.Apply then

            mod.Apply(template, def)

            LOG("CUSTOMAI: Anpassung angewandt fuer "..def.Key
                .." aus "..def.Customize)
        else
            WARN("CUSTOMAI: Customize-Datei \""..def.Customize
                 .."\" fehlt oder hat keine Funktion Apply(template, definition) - "
                 ..def.Key.." bleibt unveraendert")
        end
    end

    -- --- Registrieren -----------------------------------------------------
    -- Der globale Konstruktor stammt aus
    -- gamedata.entpackt\lua\lua\system\GlobalBaseTemplate.lua und prueft
    -- Pflichtfelder sowie alle genannten BuilderGroups.
    BaseBuilderTemplate(template)

    LOG("CUSTOMAI: registriert "..template.BaseTemplateName
        .." (Key "..def.Key..", Quelle "..def.Source..", Wert "..value..")")

    return true
end
