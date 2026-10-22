local NStructureUnit = import('/lua/defaultunits.lua').StructureUnit

local FxAmbient = import('/lua/effecttemplates.lua').AResourceGenAmbient

local RemoteViewing = import('/lua/RemoteViewing.lua').RemoteViewing

NStructureUnit = RemoteViewing( NStructureUnit )

SSB3301 = Class( NStructureUnit ) {

    OnStopBeingBuilt = function(self, builder, layer)
    
        self.EmitterEffects = {}
        self:SetMaintenanceConsumptionActive()
        NStructureUnit.OnStopBeingBuilt(self,builder,layer)
        
    end,
 
    OnTargetLocation = function(self, location) 

        local aiBrain = self:GetAIBrain()            



        -- find a target unit 
        local targettable = aiBrain:GetUnitsAroundPoint(categories.MOBILE-categories.HIGHALTAIR, location, 10)
        local targetunit = targettable[1]

        if table.getn(targettable) > 1 then

            local dist = 100

            for i, target in targettable do    

                if IsUnit(target) then

                    local cdist = VDist2Sq(target:GetPosition()[1], target:GetPosition()[3], location[1], location[3])

                    if cdist < dist then
                        dist = cdist
                        targetunit = target
                    end
                end
            end   
        end

        if targetunit and IsUnit(targetunit) then

            self.RemoteViewingData.VisibleLocation = location
            self.RemoteViewingData.TargetUnit = targetunit

            self:CreateVisibleEntity()
        else
            
            self.RemoteViewingData.VisibleLocation = false

        end

    end,

    RechargeEmitter = function(self)
    
        for _,key in self.EmitterEffects do
            key:Destroy()
        end
    
        NStructureUnit.RechargeEmitter(self)
        
        for k,v in FxAmbient do
            table.insert( self.EmitterEffects, CreateAttachedEmitter( self, 'B01', self:GetArmy(), v ):ScaleEmitter(.25) )
        end
    
    end,
}

TypeClass = SSB3301
