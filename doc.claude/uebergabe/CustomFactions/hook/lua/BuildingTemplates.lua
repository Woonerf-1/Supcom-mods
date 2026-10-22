-- Custom Factions: KI-Bauvorlagen fuer Fraktionen ab Index 5. Siehe README.md (Abschnitt Bauvorlagen).
-- LOUD fuehrt BuildingTemplates/RebuildStructuresTemplate je Fraktionsindex 1-4 (lua/BuildingTemplates.lua).
-- Feld BuildingTemplatesFile im Fraktionseintrag: Datei mit BuildingTemplates (und optional RebuildStructuresTemplate).
do
    for index, faction in import('/lua/factions.lua').Factions do
        if index > 4 and faction.BuildingTemplatesFile then
            local data = import(faction.BuildingTemplatesFile)
            BuildingTemplates[index] = data.BuildingTemplates
            RebuildStructuresTemplate[index] = data.RebuildStructuresTemplate or {}
        end
    end
end