local UnitOld = Unit
Unit = Class(UnitOld) {
    OnStopBeingBuilt = function(self, ...)
        UnitOld.OnStopBeingBuilt(self, unpack(arg))
        self:ForkThread(self.AcidThread)
    end,
    AcidThread = function(self)
        local bp = self:GetBlueprint()
        -- Skip acid damage for naval units, naval factories, torpedo launchers, and T1/T2 sonar
        local navalStructures = categories.NAVAL * categories.FACTORY
                              + categories.ANTINAVY * categories.STRUCTURE
                              + categories.SONAR * categories.TECH1 * categories.STRUCTURE
                              + categories.SONAR * categories.TECH2 * categories.STRUCTURE
                              + categories.ENGINEER
        if bp.Physics.MotionType == 'RULEUMT_Water' or
           bp.Physics.MotionType == 'RULEUMT_SurfacingSub' or
           EntityCategoryContains(navalStructures, self) then
            return
        end

        local damage = 0
        while not self.Dead do
            local layer = self:GetCurrentLayer()
            if layer == 'Water' or layer == 'Seabed' or layer == 'Sub' then
                if damage == 0 then
                    damage = GetGameTimeSeconds()
                end
                self:OnDamage(self, GetGameTimeSeconds() - damage, Vector(0,0,0), 'normal')
                WaitTicks(1)
            else
                damage = 0
                WaitSeconds(2)
            end
        end
    end,
}