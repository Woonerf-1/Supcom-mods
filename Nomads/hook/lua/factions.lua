-- Nomads als Fraktion anhaengen (Spiel: Sitzung, Ladebildschirm, Sim), siehe doc.claude\mods\Nomads.md Abschnitt 3
-- Gleicher Inhalt wie hook_frontend\lua\factions.lua; der Sitzungs-State sieht die Front-End-Hooks nicht.
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
