-- Custom Factions: Fraktionsfilter im Einheiten-Erzeugen-Dialog. Siehe README.md (Abschnitt Dialoge).
-- LOUD fuehrt die Filter lokal in lua/ui/dialogs/createunit.lua (nameFilters, Fraktion = Eintrag 2, Z. 117-150).
-- Jede Fraktion ab Index 5 bekommt einen Eintrag ueber ihre Kategorie (Feld Category).
do
    for index, faction in import('/lua/factions.lua').Factions do
        if index > 4 and faction.Category then
            local category = faction.Category
            table.insert(nameFilters[2].choices, {
                title = LOC(faction.DisplayName or faction.Key),
                key = faction.Key,
                sortFunc = function(unitID)
                    return table.find(__blueprints[unitID].Categories, category)
                end,
            })
        end
    end
end