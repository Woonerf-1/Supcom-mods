--------------------------------------------------------------------------------
--  Summary  :  Aeon Engineering Station Script
--  Author   :  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local AConstructionUnit = import('/lua/aeonunits.lua').AConstructionUnit

SAB0104 = Class(AConstructionUnit) {

    OnStartBuild = function(self, unitBeingBuilt, order)
        AConstructionUnit.OnStartBuild(self, unitBeingBuilt, order)
        self.PanelsOpen = true
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        AConstructionUnit.OnStopBuild(self, unitBeingBuilt)
        self.PanelsOpen = nil
    end,

    PlayAnimationThread = function(self, anim, rate)
        if anim == 'AnimationDeath' then
            if self.PanelsOpen then
                local bp = __blueprints.sab0104.Display[anim]
                self.DeathAnimManip = CreateAnimator(self)
                self.DeathAnimManip:PlayAnim(bp[1].Animation):SetRate(math.random(bp[1].AnimationRateMin, bp[1].AnimationRateMax))
                self.Trash:Add(self.DeathAnimManip)
                WaitFor(self.DeathAnimManip)
            end
        else
            AConstructionUnit.PlayAnimationThread(self, anim, rate)
        end
    end,
}

TypeClass = SAB0104
