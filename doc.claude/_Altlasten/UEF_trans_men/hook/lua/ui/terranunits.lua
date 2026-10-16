---   /lua/terranunits.lua
--**  Author(s): John Comes, Dave Tomandl, Gordon Duclos
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.

-- TERRAN DEFAULT UNITS

local DefaultUnitsFile = import('defaultunits.lua')

local ConstructionUnit          = DefaultUnitsFile.ConstructionUnit
local FactoryUnit               = DefaultUnitsFile.FactoryUnit
local MassCollectionUnit        = DefaultUnitsFile.MassCollectionUnit
local MobileUnit                = DefaultUnitsFile.MobileUnit
local RadarJammerUnit           = DefaultUnitsFile.RadarJammerUnit
local ShieldStructureUnit       = DefaultUnitsFile.StructureUnit
local StructureUnit             = DefaultUnitsFile.StructureUnit

DefaultUnitsFile = nil

local StructureUnitOnCreate         = StructureUnit.OnCreate

local FactoryUnitOnStartBuild      = FactoryUnit.OnStartBuild
local StructureUnitOnStartBuild    = StructureUnit.OnStartBuild

local ConstructionUnitOnStopBuild   = ConstructionUnit.OnStopBuild
local FactoryUnitOnStopBuild        = FactoryUnit.OnStopBuild
local StructureUnitOnStopBuild      = StructureUnit.OnStopBuild

local CreateBuildCubeThread = import('effectutilities.lua').CreateBuildCubeThread
local CreateDefaultBuildBeams = import('effectutilities.lua').CreateDefaultBuildBeams
local CreateUEFBuildSliceBeams = import('effectutilities.lua').CreateUEFBuildSliceBeams

local CreateRotator = CreateRotator

local ChangeState = ChangeState

local EntityCategoryContains = EntityCategoryContains
local ForkThread = ForkThread
local KillThread = KillThread
local WaitTicks = coroutine.yield

local LOUDWARP = Warp

local HideBone = moho.unit_methods.HideBone
local ScaleEmitter = moho.IEffect.ScaleEmitter
local SetMesh = moho.entity_methods.SetMesh

local TrashAdd = TrashBag.Add
local TrashDestroy = TrashBag.Destroy

TAirFactoryUnit = Class(FactoryUnit) {
    
    CreateBuildEffects = function( self, unitBeingBuilt, order )

        TrashAdd( self.BuildEffectsBag, self:ForkThread( CreateDefaultBuildBeams, unitBeingBuilt, __blueprints[self.BlueprintID].General.BuildBones.BuildEffectBones, self.BuildEffectsBag ) )
		
    end,
   
    OnPaused = function(self)

        FactoryUnit.OnPaused(self)

        self:StopArmsMoving()
    end,
    
    OnUnpaused = function(self)

        FactoryUnit.OnUnpaused(self)

        if self:GetNumBuildOrders(categories.ALLUNITS) > 0 and not self:IsUnitState('Upgrading') then
            self:StartArmsMoving()
        end
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )

        FactoryUnitOnStartBuild(self, unitBeingBuilt, order )

        if order != 'Upgrade' then
            self:StartArmsMoving()
        end
    end,
   
    OnStopBuild = function(self, unitBuilding)

        if self.BuildProjectile then
        
            for _, v in self.BuildProjectile do
           
                ScaleEmitter( v.Emitter, .1)
                ScaleEmitter( v.Sparker, .1)

                LOUDWARP( v, self.CachePosition )
            end
        end

        FactoryUnitOnStopBuild(self, unitBuilding)

        self:StopArmsMoving()
    end,

    OnFailedToBuild = function(self)
        FactoryUnit.OnFailedToBuild(self)
        self:StopArmsMoving()
    end,
   
    StartArmsMoving = function(self)
        self.ArmsThread = self:ForkThread(self.MovingArmsThread)
    end,

    MovingArmsThread = function(self)
    end,
    
    StopArmsMoving = function(self)
        if self.ArmsThread then
            KillThread(self.ArmsThread)
            self.ArmsThread = nil
        end
    end,
}

TLandFactoryUnit = Class(FactoryUnit) {

    CreateBuildEffects = function( self, unitBeingBuilt, order )
    
        if order != 'Upgrade' then

            -- the projectile used to attach the beam to, is permanently created - for each bone
            -- this process creates the sparks on the bone and the projectile, and creates the beam between them
            -- then launches a thread to move the particle about while the unit is being built
            TrashAdd( self.BuildEffectsBag, self:ForkThread( CreateDefaultBuildBeams, unitBeingBuilt, __blueprints[self.BlueprintID].General.BuildBones.BuildEffectBones, self.BuildEffectsBag ) )
        end
        
    end,

    OnStopBuild = function(self, unitBeingBuilt)

        if self.BuildProjectile then
        
            for _, v in self.BuildProjectile do
           
                ScaleEmitter( v.Emitter, .1)
                ScaleEmitter( v.Sparker, .1)
                
                -- return projectile to source
                LOUDWARP( v, self.CachePosition )
            end
        end
        
        FactoryUnitOnStopBuild( self, unitBeingBuilt )
    end,

}

TSeaFactoryUnit = Class(TAirFactoryUnit) {}

TConstructionUnit = Class(ConstructionUnit) {

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        TrashAdd( self.BuildEffectsBag, self:ForkThread( CreateUEFBuildSliceBeams, unitBeingBuilt, __blueprints[self.BlueprintID].General.BuildBones.BuildEffectBones, self.BuildEffectsBag ) )
    end,
    
    OnStopBuild = function(self, unitBeingBuilt)
        ConstructionUnitOnStopBuild(self, unitBeingBuilt)
    end,

    OnLayerChange = function(self, new, old)
	
        ConstructionUnit.OnLayerChange(self, new, old)
		
        if __blueprints[self.BlueprintID].Display.AnimationWater then
		
            if self.TerrainLayerTransitionThread then
                self.TerrainLayerTransitionThread:Destroy()
                self.TerrainLayerTransitionThread = nil
            end
			
            if (new == 'Land') and (old != 'None') then
                self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, false)
            elseif (new == 'Water') then
                self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, true)
            end
        end
    end,

    TransformThread = function(self, water)
        
        if not self.TransformManipulator then
            self.TransformManipulator = CreateAnimator(self)
            TrashAdd( self.Trash, self.TransformManipulator )
        end

        if water then
            self.TransformManipulator:PlayAnim(__blueprints[self.BlueprintID].Display.AnimationWater)
            self.TransformManipulator:SetRate(1)
            self.TransformManipulator:SetPrecedence(0)
        else
            self.TransformManipulator:SetRate(-1)
            self.TransformManipulator:SetPrecedence(0)
            WaitFor(self.TransformManipulator)
            self.TransformManipulator:Destroy()
            self.TransformManipulator = nil
        end
    end,
}

TConstructionStructureUnit = Class(StructureUnit) {
   
    OnCreate = function(self)
        -- Structure stuff
        StructureUnitOnCreate(self)

        local bp = __blueprints[self.BlueprintID]
		
        if bp.General.BuildBones then
            self:SetupBuildBones()
        end

        if bp.Display.AnimationBuild then
            self.BuildingOpenAnim = bp.Display.AnimationBuild
        end

        if self.BuildingOpenAnim then
            self.BuildingOpenAnimManip = CreateAnimator(self)
            self.BuildingOpenAnimManip:SetPrecedence(1)
            self.BuildingOpenAnimManip:PlayAnim(self.BuildingOpenAnim, false):SetRate(0)
            
            if self.BuildArmManipulator then
                self.BuildArmManipulator:Disable()
            end
            
        end
        self.BuildingUnit = false
    end,
    
    OnStartBuild = function(self, unitBeingBuilt, order )
       
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order
        self.BuildingUnit = true

        StructureUnitOnStartBuild(self,unitBeingBuilt, order)
    end,
    
    OnStopBeingBuilt = function(self,builder,layer)
    
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
        
        -- If created with F2 on land, then play the transform anim.
        if(self:GetCurrentLayer() == 'Water') then
            self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, true)
        end
    end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        
        TrashAdd( self.BuildEffectsBag, self:ForkThread( CreateUEFBuildSliceBeams, unitBeingBuilt, __blueprints[self.BlueprintID].General.BuildBones.BuildEffectBones, self.BuildEffectsBag ) )    

    end,
    
    -- This will only be called if not in StructureUnit's upgrade state
    OnStopBuild = function(self, unitBeingBuilt)
    
        if self.BuildBots then

            for _, bot in self.BuildBots do

                if bot.BuildProjectile then
                
                    for _,v in bot.BuildProjectile do

                        TrashDestroy( v.BuildEffectsBag )
                        
                        if v.Detached then
                            v:AttachTo( bot, v.Name )
                        end
                        
                        v.Detached = false                        
        
                        v.Emitter:ScaleEmitter(0.01)
                        v.Sparker:ScaleEmitter(0.01)
                    end
                end    
        
                TrashDestroy( bot.BuildEffectsBag )
                
                IssueClearCommands( {bot} )
                
                bot:AttachTo( self, 0 )
                bot.Detached = false

            end
            
            for _, emitter in self.BuildEmitter do
                emitter:ScaleEmitter( 0.01 )
            end

        end

        self.UnitBeingBuilt = nil
        self.UnitBuildOrder = nil

        TrashDestroy( self.BuildEffectsBag )
   
        if self.BuildingOpenAnimManip and self.BuildArmManipulator then
        
            self.StoppedBuilding = true
            
        elseif self.BuildingOpenAnimManip then
        
            self.BuildingOpenAnimManip:SetRate(-1)
            
        end

        self.BuildingUnit = false
    
        StructureUnitOnStopBuild(self, unitBeingBuilt)
       
    end,
    
    OnPaused = function(self)

        StructureUnit.OnPaused(self)
		
        if self.BuildingUnit then
            StructureUnit.StopBuildingEffects(self, self.UnitBeingBuilt)
        end    
    end,
    
    OnUnpaused = function(self)
	
        if self.BuildingUnit then
            StructureUnit.StartBuildingEffects(self, self.UnitBeingBuilt, self.UnitBuildOrder)
        end
		
        StructureUnit.OnUnpaused(self)
    end,

    WaitForBuildAnimation = function(self, enable)
        if self.BuildArmManipulator then
            WaitFor(self.BuildingOpenAnimManip)
            if (enable) then
                self.BuildArmManipulator:Enable()
            end
        end
    end,

}

TMassCollectionUnit = Class(MassCollectionUnit) {

    StartBeingBuiltEffects = function(self, builder, layer)
	
		SetMesh( self, __blueprints[self.BlueprintID].Display.BuildMeshBlueprint, true)
		
        if __blueprints[self.BlueprintID].General.UpgradesFrom != builder.BlueprintID then
        
			HideBone( self, 0, true)        
            TrashAdd( self.OnBeingBuiltEffectsBag, self:ForkThread( CreateBuildCubeThread, builder, self.OnBeingBuiltEffectsBag ))
            
        end
		
    end,    
}

TMobileFactoryUnit = Class(MobileUnit) {

    StartBeingBuiltEffects = function(self, builder, layer)
	
		SetMesh( self, __blueprints[self.BlueprintID].Display.BuildMeshBlueprint, true)
		
        if __blueprints[self.BlueprintID].General.UpgradesFrom != builder.BlueprintID then
        
			HideBone( self, 0, true)        
            TrashAdd( self.OnBeingBuiltEffectsBag, self:ForkThread( CreateBuildCubeThread, builder, self.OnBeingBuiltEffectsBag ))
            
        end
    end,   
}

TShieldStructureUnit = Class(ShieldStructureUnit) {

    StartBeingBuiltEffects = function(self,builder,layer)
	
    	SetMesh( self, __blueprints[self.BlueprintID].Display.BuildMeshBlueprint, true)
		
        if builder and EntityCategoryContains(categories.MOBILE, builder) then
		
            HideBone( self, 0, true)
            TrashAdd( self.OnBeingBuiltEffectsBag, self:ForkThread( CreateBuildCubeThread, builder, self.OnBeingBuiltEffectsBag )	)	
			
        end
		
    end,
}

TRadarJammerUnit = Class(RadarJammerUnit) {

    OnIntelEnabled = function(self,intel)
        if not self.MySpinner then
            self.MySpinner = CreateRotator(self, 'Spinner', 'y', nil, 0, 45, 180)
            TrashAdd( self.Trash, self.MySpinner )
        end
        RadarJammerUnit.OnIntelEnabled(self,intel)
        self.MySpinner:SetTargetSpeed(180)
    end,
    
    OnIntelDisabled = function(self,intel)
        RadarJammerUnit.OnIntelDisabled(self,intel)
        self.MySpinner:SetTargetSpeed(0)
    end,
}
local ConstructionStructureUnit = DefaultUnitsFile.ConstructionStructureUnit

TConstructionStructureUnit = Class(ConstructionStructureUnit) {
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom
        --If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom ~= 'none' and self:IsUnitState('Guarding'))then
            EffectUtil.CreateDefaultBuildBeams( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag )
        else
            EffectUtil.CreateUEFBuildSliceBeams( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag )
        end
    end,
}

TEngineeringResourceStructureUnit = Class(TConstructionStructureUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        TConstructionStructureUnit.OnStopBeingBuilt(self,builder,layer)
        if __blueprints[self.BpId].Economy.NaturalProducer
        and __blueprints[self.BpId].Economy.MaintenanceConsumptionPerSecondEnergy
        and __blueprints[self.BpId].Economy.MaintenanceConsumptionPerSecondEnergy > 0 then
            self:ForkThread(self.WatchProductionThread)
        end
        ChangeState(self, self.ActiveState)
    end,

    WatchProductionThread = function(self)
        --This fixes the issue NaturalProducer causes; which is that it stops paying attention to the maintenance
        local massProduction = __blueprints[self.BpId].Economy.ProductionPerSecondMass or 0
        --local energyProduction = __blueprints[self.BpId].Economy.ProductionPerSecondEnergy or 0
        while not self.Dead do
            coroutine.yield(11)
            local r = self:GetResourceConsumed()
            self:SetProductionPerSecondMass(massProduction * (self.MassProdAdjMod or 1) * r)
            --self:SetProductionPerSecondEnergy(energyProduction * (self.EnergyProdAdjMod or 1) * r)
        end
    end,

    OnDamage = function(self, instigator, amount, vector, damageType)
        TConstructionStructureUnit.OnDamage(self, instigator, amount, vector, damageType)

        self:PlaySound(self:GetBlueprint().Audio.PanicLoop)
        if instigator then
            if instigator and IsUnit(instigator) then
                local layer = instigator:GetCurrentLayer()
                local bp = self:GetBlueprint()
                local distance = util.GetDistanceBetweenTwoEntities(self, instigator)
                if distance > bp.Intel.VisionRadius * 3 then
                    --LOG("Shit that's far: ".. distance)
                    return
                elseif layer == 'Land' or self.AlternateWater  then
                    self.BuildThis = bp.Economy.BuildWhenAttackedByLand or 'ueb2101'
                elseif layer == 'Air' then
                    self.BuildThis = bp.Economy.BuildWhenAttackedByAir or 'ueb2104'
                elseif layer == 'Seabed' or layer == 'Sub' or layer == 'Water' then
                    self.BuildThis = bp.Economy.BuildWhenAttackedBySub or 'ueb2109'
                    if layer == 'Water' and not self.AlternateWater then
                        self.AlternateWater = true
                    elseif layer == 'Water' then
                        self.AlternateWater = false
                    end
                else
                    return --what are we fighting here I dont even.
                end
                --LOG("Instigator layer: ".. layer)
                ChangeState(self, self.PanicState)
            end
        end
    end,

    PanicState = State {
        Main = function(self)
            local pos = self:GetPosition()
            local aiBrain = self:GetAIBrain()

            local bp = self:GetBlueprint()
            local x = bp.Physics.SkirtSizeX / 2 + 1
            local z = bp.Physics.SkirtSizeZ / 2 + 1
            local sign = -1 + 2 * math.random(0, 1)

            if math.random(0, 1) > 0 then
                self.BuildGoalX = sign * x
                self.BuildGoalZ = math.random(-z, z)
            else
                self.BuildGoalX = math.random(-x, x)
                self.BuildGoalZ = sign * z
            end

            LOG( "Help, help, I'm being repressed!" )
            aiBrain:BuildStructure(self, self.BuildThis or 'ueb2101', {pos[1]+self.BuildGoalX, pos[3]+self.BuildGoalZ, 0})
        end,

        OnStopBuild = function(self, unitBuilding)
            TConstructionStructureUnit.OnStopBuild(self, unitBuilding)
            ChangeState(self, self.ActiveState)
        end,

        OnFailedToBuild = function(self)
            TConstructionStructureUnit.OnFailedToBuild(self)
            ChangeState(self, self.ActiveState)
        end,
    },

    ActiveState = State {
        Main = function(self)
        end,

        OnInActive = function(self)
            ChangeState(self, self.InActiveState)
        end,
    },

    InActiveState = State {
        Main = function(self)
        end,

        OnActive = function(self)
            ChangeState(self, self.ActiveState)
        end,
    },
}
local ResearchFactoryUnit = import('/lua/defaultunits.lua').ResearchFactoryUnit

TResearchFactoryUnit = Class(ResearchFactoryUnit) {

    StartBuildFx = function(self, unitBeingBuilt)
        local bp = self:GetBlueprint()
        local EffectUtil = import('/lua/effectutilities.lua')
        WaitTicks(1)
        for k, v in bp.General.BuildBones.BuildEffectBones do
            self.BuildEffectsBag:Add( CreateAttachedEmitter( self, v, self:GetArmy(), '/effects/emitters/flashing_blue_glow_01_emit.bp' ) )
            self.BuildEffectsBag:Add( self:ForkThread( EffectUtil.CreateDefaultBuildBeams, unitBeingBuilt, {v}, self.BuildEffectsBag ) )
        end
        if ResearchFactoryUnit.StartBuildFx then
            ResearchFactoryUnit.StartBuildFx(self, unitBeingBuilt)
        end
    end,

}
