-- Custom Factions (optional): Baubedingung ueber die Fraktions-Kategorie statt der Indexnummer.
-- Siehe README.md (Abschnitt KI). LOUD kennt nur FactionIndex(aiBrain, n1, n2, n3) (Z. 17), also feste Nummern.
-- Herkunft: nomads-4-loud\hook\lua\editor\MiscBuildConditions.lua; in LOUD derzeit von keinem Builder genutzt.
function IsFactionCat(aiBrain, FactionCategory1, FactionCategory2, FactionCategory3)
    local faction = import('/lua/factions.lua').Factions[aiBrain:GetFactionIndex()]
    local facCat = faction and faction.Category
    return (facCat == FactionCategory1 or facCat == FactionCategory2 or facCat == FactionCategory3)
end