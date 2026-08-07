-- ============================================================================
-- Registrierung aller KIs dieses Mods in der Lobby-Auswahlliste
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\lua\AI\CustomAIs_v2\CustomAI.lua
--
-- Gelesen von: gamedata.entpackt\lua\lua\enhancedlobby.lua, GetAIList(),
--              Mod-Zweig: DiskFindFiles(mod.location..'/lua/AI/CustomAIs_v2', '*.lua')
--
-- HIER IST NICHTS ZU AENDERN. Die Eintraege stammen aus
--   ..\AIDefinitions.lua
-- Diese Datei baut daraus nur die von der Engine erwartete Struktur.
--
-- ZWEI REGELN FUER DIESEN ORDNER:
--   1. Jede Datei hier MUSS eine globale Tabelle 'AI' definieren. Der Lesecode
--      greift ungeprueft auf import(v).AI.AIList zu - eine Hilfsdatei ohne 'AI'
--      bricht das Laden der gesamten Liste ab.
--      Deshalb liegen AIDefinitions.lua, AIFactory.lua und LoadAIs.lua eine
--      Ebene hoeher und nicht hier.
--   2. Keys muessen eindeutig sein. Die Duplikatspruefung der Engine greift
--      nicht (Abfrage mit String-Key auf einer Array-Tabelle).
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 4
-- ============================================================================

local definitions = import('/mods/customai/lua/AI/AIDefinitions.lua').Definitions

local list = {}

for i, def in definitions do

    table.insert(list, { key = def.Key, name = def.Name })

end

AI = {

    Name = "Custom AI",

    Version = "0.2",

    AIList = list,

    -- Schummelnde Varianten wuerden hier stehen und ebenso gelesen.
    -- Sie brauchen eigene Keys - siehe Regel 2 oben.
    -- CheatAIList = { ... },
}
