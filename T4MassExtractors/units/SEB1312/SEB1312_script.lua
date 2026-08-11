local TMassCollectionUnit = import('/lua/terranunits.lua').TMassCollectionUnit
local TConstructionStructureUnit = import('/lua/terranunits.lua').TConstructionStructureUnit

UEB1302 = Class(TConstructionStructureUnit) {

    -- Called when unit is created
    OnCreate = function(self)
        TConstructionStructureUnit.OnCreate(self)

        -- Ensure maintenance can run when enabled
        self:SetMaintenanceConsumptionActive(true)
    end,

    -- Play mass extractor animation
    PlayActiveAnimation = function(self)
        TMassCollectionUnit.PlayActiveAnimation(self)

        if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end

        self.AnimationManipulator:PlayAnim(
            self:GetBlueprint().Display.AnimationOpen,
            true
        )
    end,

    -- When construction starts
    OnStartBuild = function(self, unitBeingBuilt, order)
        -- Allow construction system to initialize
        TConstructionStructureUnit.OnStartBuild(self, unitBeingBuilt, order)

        -- Pause animation and maintenance
        if self.AnimationManipulator then
            self.AnimationManipulator:SetRate(0)
        end

        self:SetMaintenanceConsumptionActive(false)
    end,

    -- When construction stops
    OnStopBuild = function(self, unitBeingBuilt)
        -- Clean up construction state
        TConstructionStructureUnit.OnStopBuild(self, unitBeingBuilt)

        -- Resume maintenance and animation
        self:SetMaintenanceConsumptionActive(true)

        if self.AnimationManipulator then
            self.AnimationManipulator:SetRate(1)
        else
            self:PlayActiveAnimation()
        end
    end,

    -- Economy pause (player pauses production)
    OnProductionPaused = function(self)
        TMassCollectionUnit.OnProductionPaused(self)

        self:SetMaintenanceConsumptionActive(false)

        if self.AnimationManipulator then
            self.AnimationManipulator:SetRate(0)
        end
    end,

    -- Economy unpause
    OnProductionUnpaused = function(self)
        TMassCollectionUnit.OnProductionUnpaused(self)

        self:SetMaintenanceConsumptionActive(true)

        if self.AnimationManipulator then
            self.AnimationManipulator:SetRate(1)
        end
    end,
}

TypeClass = UEB1302
