-- append the template factions to the faction list (main menu, lobby)

do
    for _, faction in import('/mods/factiontemplate_w40k/lua/TemplateFactions.lua').Factions do
        if not FactionIndexMap[faction.Key] then
            table.insert(Factions, faction)
            FactionIndexMap[faction.Key] = table.getn(Factions)
            FactionDesToKey[faction.CampaignFileDesignator] = faction.Key
        end
    end
end