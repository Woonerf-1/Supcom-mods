-- Custom Factions: Vorab-Bau fuer Fraktionen ab Index 5. Siehe README.md (Abschnitt Vorab-Bau).
-- LOUD baut vorab nur fuer Index 1-4 (lua/aibrain.lua OnSpawnPreBuiltUnits, Z. 1004 ff., Listen Z. 1077-1101).
-- Feld PreBuildUnits = { MassExtractors = {ids}, Regular = {ids} } im Fraktionseintrag. multoverride wird
-- durchgereicht; der Zusatz greift nur ohne multoverride, wie LOUDs eigener Vorab-Bau.

local CFOldAIBrain = AIBrain

AIBrain = Class(CFOldAIBrain) {

    OnSpawnPreBuiltUnits = function(self, multoverride)
        CFOldAIBrain.OnSpawnPreBuiltUnits(self, multoverride)

        local index = self.FactionIndex or self:GetFactionIndex()
        local faction = import('/lua/factions.lua').Factions[index]
        if multoverride or index <= 4 or not faction or not faction.PreBuildUnits then
            return
        end

        local posX, posY = self:GetArmyStartPos()

        for _, id in faction.PreBuildUnits.MassExtractors or {} do
            local unit = self:CreateResourceBuildingNearest(id, posX, posY)
            if unit ~= nil and unit:GetBlueprint().Physics.FlattenSkirt then
                unit:CreateTarmac(true, true, true, false, false)
            end
        end

        for _, id in faction.PreBuildUnits.Regular or {} do
            local unit = self:CreateUnitNearSpot(id, posX, posY)
            if unit ~= nil and unit:GetBlueprint().Physics.FlattenSkirt then
                unit:CreateTarmac(true, true, true, false, false)
            end
        end
    end,
}