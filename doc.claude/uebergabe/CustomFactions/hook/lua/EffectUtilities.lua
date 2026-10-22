-- Custom Factions: Adjacency-Strahl je Fraktion. Siehe README.md (Abschnitt Adjacency-Strahl).
-- LOUDs CreateAdjacencyBeams (lua.scd, lua/EffectUtilities.lua Z. 1559-1608, Stand 2026-10-22) wortgleich; einzige
-- Aenderung: Fraktionen ausser Aeon/UEF nehmen den Strahl aus dem Feld AdjacencyBeam ihres Fraktionseintrags
-- (Abgleich ueber FactionInUnitBp = General.FactionName), Cybran und Fraktionen ohne Feld behalten LOUDs Vorgabe.
-- Bei LOUD-Updates gegen das Original abgleichen.
function CreateAdjacencyBeams( unit, adjacentUnit, BeamBagInfo )

	local LOUDINSERT = LOUDINSERT
    local LOUDATTACHBEAMENTITY = LOUDATTACHBEAMENTITY

    local TrashAdd = TrashAdd
    local info
    
    if BeamBagInfo then
        info = BeamBagInfo
    else
        info = { Unit = adjacentUnit.EntityID, Trash = TrashBag(), }
    end
    
    local army = unit.Army
    local faction = __blueprints[unit.BlueprintID].General.FactionName

    -- Determine which effects we will be using	-- default to Cybran
    local beamEffect = '/effects/emitters/adjacency_cybran_beam_01_emit.bp'

    if faction == 'Aeon' then
    
        beamEffect = '/effects/emitters/adjacency_aeon_beam_01_emit.bp'
		
    elseif faction == 'UEF' then
    
        beamEffect = '/effects/emitters/adjacency_uef_beam_01_emit.bp'	

    else

        -- Custom Factions: Strahl aus dem Fraktionseintrag (Feld AdjacencyBeam), sonst LOUDs Cybran-Vorgabe
        for _, f in import('/lua/factions.lua').Factions do
            if f.FactionInUnitBp == faction and f.AdjacencyBeam then
                beamEffect = f.AdjacencyBeam
                break
            end
        end

    end    

    if beamEffect then

        if ScenarioInfo.UnitDialog then
            LOG("*AI DEBUG UNIT "..GetAIBrain(unit).Nickname.." "..unit.EntityID.." "..unit.BlueprintID.." CreateAdjacencyBeam to "..adjacentUnit.EntityID.." "..adjacentUnit.BlueprintID.." on tick "..GetGameTick().." info is "..repr(info) )
        end
    
        local beam = LOUDATTACHBEAMENTITY( unit, -1, adjacentUnit, -1, army, beamEffect )
        
        info.Beam = beam
        
        TrashAdd( info.Trash, beam )
        TrashAdd( unit.Trash, beam )

    end

    if not BeamBagInfo then
        LOUDINSERT( unit.AdjacencyBeamsBag, info)
    end

end

