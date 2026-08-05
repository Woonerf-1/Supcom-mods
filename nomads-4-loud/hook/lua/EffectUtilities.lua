--	/lua/EffectUtilities.lua

-- This file is responsible for a lot of the faction specific visuals

local import = import

local util = import('utilities.lua')

local Random = Random

local Entity = import('/lua/sim/Entity.lua').Entity

local EffectTemplate = import('/lua/EffectTemplates.lua')

local ReclaimBeams              = EffectTemplate.ReclaimBeams
local ReclaimObjectAOE          = EffectTemplate.ReclaimObjectAOE
local ReclaimObjectEnd          = EffectTemplate.ReclaimObjectEnd
local AeonBuildBeams01          = EffectTemplate.AeonBuildBeams01
local AeonBuildBeams02          = EffectTemplate.AeonBuildBeams02
local CybranBuildSparks01       = EffectTemplate.CybranBuildSparks01
local CybranBuildFlash01        = EffectTemplate.CybranBuildFlash01
local CybranBuildUnitBlink01    = EffectTemplate.CybranBuildUnitBlink01
local SeraphimBuildBeams01      = EffectTemplate.SeraphimBuildBeams01

local LOUDCOPY      = table.copy
local LOUDFLOOR     = math.floor	
local LOUDGETN      = table.getn
local LOUDINSERT    = table.insert
local LOUDREMOVE    = table.remove
local LOUDSORT      = table.sort
local LOUDWARP      = Warp

local EntityMethods = moho.entity_methods

local AttachBoneToEntityBone    = EntityMethods.AttachBoneToEntityBone
local BeenDestroyed             = EntityMethods.BeenDestroyed
local CreateProjectile          = EntityMethods.CreateProjectile
local GetFractionComplete       = EntityMethods.GetFractionComplete
local GetPosition               = EntityMethods.GetPosition
local SetMesh                   = EntityMethods.SetMesh

local GetAIBrain    = moho.unit_methods.GetAIBrain
local HideBone      = moho.unit_methods.HideBone
local IsBeingBuilt  = moho.unit_methods.IsBeingBuilt

local ScaleEmitter = moho.IEffect.ScaleEmitter

local SetVelocity = moho.projectile_methods.SetVelocity

local WaitTicks = coroutine.yield
local VDist3Sq = VDist3Sq

local CreateLightParticle   = CreateLightParticle

local LOUDEMITONENTITY      = CreateEmitterOnEntity
local LOUDEMITATENTITY      = CreateEmitterAtEntity
local LOUDEMITATBONE        = CreateEmitterAtBone
local LOUDATTACHEMITTER     = CreateAttachedEmitter
local LOUDATTACHBEAMENTITY  = AttachBeamEntityToEntity

local TrashBag      = TrashBag
local TrashAdd      = TrashBag.Add
local TrashDestroy  = TrashBag.Destroy

local ALLBPS = __blueprints

-- credit to Jip for this re-use technique
-- modified to use simple table rather than Vector
local VectorCached = { 0, 0, 0 }
local VecExtCached = { {}, {}, {}, {} }

-- TODO: go through this
function CreateAdjacencyBeams( unit, adjacentUnit )

	local LOUDINSERT = LOUDINSERT
    local LOUDATTACHBEAMENTITY = LOUDATTACHBEAMENTITY
	local LOUDATTACHEMITTER = CreateAttachedEmitter
    local TrashAdd = TrashAdd

	local info = { Unit = adjacentUnit.EntityID, Trash = TrashBag(), }
    
    local army = unit.Army
    local faction = __blueprints[unit.BlueprintID].General.FactionName

    -- Determine which effects we will be using	-- default to Cybran
    beamEffect = '/effects/emitters/nomads_adjacency_beam.bp'

    if faction == 'Aeon' then
    
        beamEffect = '/effects/emitters/adjacency_aeon_beam_01_emit.bp'
		
    elseif faction == 'UEF' then
    
        beamEffect = '/effects/emitters/adjacency_uef_beam_01_emit.bp'	

    end    

    if beamEffect then

        if ScenarioInfo.UnitDialog then
            LOG("*AI DEBUG UNIT "..GetAIBrain(unit).Nickname.." "..unit.EntityID.." "..unit.BlueprintID.." CreateAdjacencyBeam to "..adjacentUnit.EntityID.." "..adjacentUnit.BlueprintID.." on tick "..GetGameTick())
        end
    
        local beam = LOUDATTACHBEAMENTITY( unit, -1, adjacentUnit, -1, army, beamEffect )
        
        TrashAdd( info.Trash, beam )
        TrashAdd( unit.Trash, beam )
    end

	LOUDINSERT( unit.AdjacencyBeamsBag, info)

end