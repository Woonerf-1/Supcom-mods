-- Corrosive Ocean: Wasser fuegt Landeinheiten Schaden zu.
-- Aenderungen gegenueber Balthazars Fassung: siehe Unit.md

local UnitOld = Unit

local WASSER = { Water = true, Seabed = true, Sub = true }

local AUSGENOMMEN = categories.NAVAL
                  + categories.ANTINAVY * categories.STRUCTURE
                  + categories.SONAR * categories.TECH1 * categories.STRUCTURE
                  + categories.SONAR * categories.TECH2 * categories.STRUCTURE
                  + categories.ENGINEER
                  + categories.AIR

local AUSGENOMMENE_BEWEGUNG = {
    RULEUMT_Water        = true,
    RULEUMT_SurfacingSub = true,
    RULEUMT_Air          = true,
}

Unit = Class(UnitOld) {

    AcidBetroffen = function(self)

        if self.AcidGeprueft ~= nil then
            return self.AcidGeprueft
        end

        local bp = self:GetBlueprint()

        self.AcidGeprueft =
            not AUSGENOMMENE_BEWEGUNG[bp.Physics.MotionType]
            and not EntityCategoryContains(AUSGENOMMEN, self)

        return self.AcidGeprueft
    end,

    AcidStart = function(self)

        if self.AcidLaeuft then
            return
        end

        self.AcidLaeuft = true
        self:ForkThread(self.AcidThread)
    end,

    AcidThread = function(self)

        local beginn = GetGameTimeSeconds()

        while not self.Dead and WASSER[self:GetCurrentLayer()] do
            self:OnDamage(self, GetGameTimeSeconds() - beginn, Vector(0,0,0), 'normal')
            WaitTicks(1)
        end

        self.AcidLaeuft = false
    end,

    OnStopBeingBuilt = function(self, ...)

        UnitOld.OnStopBeingBuilt(self, unpack(arg))

        if self:AcidBetroffen() and WASSER[self:GetCurrentLayer()] then
            self:AcidStart()
        end
    end,

    OnLayerChange = function(self, new, old)

        UnitOld.OnLayerChange(self, new, old)

        if WASSER[new] and self:AcidBetroffen() then
            self:AcidStart()
        end
    end,
}
