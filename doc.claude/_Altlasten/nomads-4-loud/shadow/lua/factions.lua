LOG("Loading Factions From Nomads Override")

local OriginalFactions = import('/loud/lua/factions.lua').Factions
local CustomFactions = import('/mods/nomads-4-loud/shadow/lua/CustomFactions/Nomads.lua').FactionList

local MergedFactions = {}

for i, v in ipairs(OriginalFactions) do
	table.insert(MergedFactions, v)
end
for i, v in ipairs(CustomFactions) do
	table.insert(MergedFactions, v)
end

Factions = MergedFactions

FactionIndexMap = {}
FactionDesToKey = {}

for index, value in Factions do
    FactionIndexMap[value.Key] = index
    FactionDesToKey[value.CampaignFileDesignator] = value.Key
end

function GetFactions(something)
	return Factions
end