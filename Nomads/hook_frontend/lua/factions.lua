-- Nomads als Fraktion anhaengen (Front-End/Lobby), siehe doc.claude\mods\Nomads.md Abschnitt 3
-- Den Eintrag "Zufall" haengt Custom Factions an, nicht dieser Hook.

do
    local Nomads = import('/mods/nomads/lua/NomadsFaction.lua').Faction

    if not FactionIndexMap[Nomads.Key] then
        table.insert(Factions, Nomads)
        local index = table.getn(Factions)
        FactionIndexMap[Nomads.Key] = index
        FactionDesToKey[Nomads.CampaignFileDesignator] = Nomads.Key
        LOG('Nomads: Fraktion angehaengt, Index '..index)
    end
end
