--------------------------------------------------------------------------------
-- Shield Bubble Projection Unit (Stable Multi-Version)
--------------------------------------------------------------------------------

local AShieldStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local CreateFlash = import('/lua/defaultexplosions.lua').CreateFlash
local EffectTemplate = import('/lua/EffectTemplates.lua')

SAB4401 = Class(AShieldStructureUnit) {

    ShieldEffects = {
        '/effects/Entities/Shield05/Shield05_emit.bp',
        '/effects/Entities/Shield05/Shield05b_emit.bp',
    },

    --------------------------------------------------------------------------------
    -- Construction
    --------------------------------------------------------------------------------

    OnStopBeingBuilt = function(self, builder, layer)

        AShieldStructureUnit.OnStopBeingBuilt(self, builder, layer)

        self.ProjectedUnits = {}
        self.ShieldEffectsBag = {}
        self.ShieldProjectionEnabled = false

        self.Manipulators = {
            {'Ring_1', 'z', 45},
            {'Ring_3', 'z', 45},
            {'Gem', 'z', 45},
            {'Orb', 'x', 45},
            {'Orb', 'z', 45},
        }

        self:ForkThread(function()
            WaitTicks(2)
            self:ShieldProjectionThread()
        end)
    end,

    --------------------------------------------------------------------------------
    -- Shield Events
    --------------------------------------------------------------------------------

    OnShieldIsUp = function(self)

        self.ShieldProjectionEnabled = true

        if not self.Manipulators[1][4] then
            for _, v in ipairs(self.Manipulators) do
                v[4] = CreateRotator(self, v[1], v[2], nil, 0, v[3], v[3])
                self.Trash:Add(v[4])
            end
        end

        for _, v in ipairs(self.Manipulators) do
            v[4]:SetTargetSpeed(v[3])
        end

        if not self.ShieldEffectsBag or table.getn(self.ShieldEffectsBag) == 0 then
            for _, v in ipairs(self.ShieldEffects) do
                table.insert(self.ShieldEffectsBag,
                    CreateAttachedEmitter(self, 0, self:GetArmy(), v):ScaleEmitter(1.17)
                )
            end
        end

        AShieldStructureUnit.OnShieldIsUp(self)
    end,

    OnShieldIsDown = function(self)

        self.ShieldProjectionEnabled = false
        self:ClearShieldProjections()

        AShieldStructureUnit.OnShieldIsDown(self)
    end,

    --------------------------------------------------------------------------------
    -- Projection Thread
    --------------------------------------------------------------------------------

    ShieldProjectionThread = function(self)

        local aiBrain = self:GetAIBrain()
        local radius = self:GetBlueprint().Defense.Shield.ShieldProjectionRadius or 60
        local radiusSq = radius * radius

        while not self.Dead do

            if self.ShieldProjectionEnabled
            and self:ShieldIsOn()
            and not self:IsBeingBuilt() then

                local myPos = self:GetPosition()

                ----------------------------------------------------------------
                -- Remove shields from units that left radius
                ----------------------------------------------------------------
                for id, unit in pairs(self.ProjectedUnits) do
                    if unit and not unit.Dead then

                        local uPos = unit:GetPosition()
                        local distSq = VDist2Sq(myPos[1], myPos[3], uPos[1], uPos[3])

                        if distSq > radiusSq then
                            self:RemoveProjectionFromUnit(unit)
                            self.ProjectedUnits[id] = nil
                        end
                    else
                        self.ProjectedUnits[id] = nil
                    end
                end

                ----------------------------------------------------------------
                -- Add shields to fully completed units only
                ----------------------------------------------------------------
                local targetunits = aiBrain:GetUnitsAroundPoint(
                    categories.ALLUNITS - categories.WALL,
                    myPos,
                    radius,
                    'Ally'
                )

                for _, unit in pairs(targetunits) do

                    if unit ~= self
                    and not unit.Dead
                    and not unit:IsBeingBuilt()
                    and not unit:IsUnitState('Building')
                    and not unit:IsUnitState('Upgrading')
                    and unit:GetFractionComplete() >= 1 then

                        local id = unit:GetEntityId()

                        if not self.ProjectedUnits[id] then
                            self:CreateProjectedShieldBubble(unit)
                        end
                    end
                end

            else
                self:ClearShieldProjections()
            end

            WaitTicks(15)
        end
    end,

    --------------------------------------------------------------------------------
    -- Shield Creation
    --------------------------------------------------------------------------------

    CreateProjectedShieldBubble = function(self, target)

        if not target or target.Dead then return end
        if target:IsBeingBuilt() then return end
        if target:IsUnitState('Building') then return end
        if target.MyShield then return end

        local shieldbp = self:GetBlueprint().Defense.TargetShield
        if not shieldbp then return end

        target:CreateProjectedShield(shieldbp)

        target.Projectors = target.Projectors or {}
        target.Projectors[self:GetEntityId()] = self
        self.ProjectedUnits[target:GetEntityId()] = target
    end,

    --------------------------------------------------------------------------------
    -- Remove Shield From Unit
    --------------------------------------------------------------------------------

    RemoveProjectionFromUnit = function(self, unit)

        if not unit or unit.Dead then return end
        if not unit.Projectors then return end

        unit.Projectors[self:GetEntityId()] = nil

        local keepshield = false
        for _, pillar in pairs(unit.Projectors) do
            if pillar and not pillar.Dead then
                keepshield = true
                break
            end
        end

        if not keepshield and unit.MyShield then
            unit:DestroyShield()
        end
    end,

    --------------------------------------------------------------------------------
    -- Clear All Projections
    --------------------------------------------------------------------------------

    ClearShieldProjections = function(self)

        for id, unit in pairs(self.ProjectedUnits) do
            self:RemoveProjectionFromUnit(unit)
        end

        self.ProjectedUnits = {}

        if self.Manipulators then
            for _, v in ipairs(self.Manipulators) do
                if v[4] then
                    v[4]:SetTargetSpeed(0)
                end
            end
        end

        if self.ShieldEffectsBag then
            for _, v in pairs(self.ShieldEffectsBag) do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
    end,

    --------------------------------------------------------------------------------
    -- Death
    --------------------------------------------------------------------------------

    DeathThread = function(self, overkillRatio, instigator)

        local army = self:GetArmy()
        local pos = self:GetPosition()

        self:ClearShieldProjections()

        CreateFlash(self, 'Ring_1', 4.5, army)

        for i = 1, 3 do
            DamageArea(self, pos, 10, 1, 'Force', true)
            self:HideBone('Ring_' .. i, false)

            for _, v in ipairs(EffectTemplate.ExplosionDebrisLrg01) do
                CreateAttachedEmitter(self, 'Base', army, v)
            end
        end

        self:CreateWreckage(overkillRatio)
        self:Destroy()
    end,

    OnDestroy = function(self)
        self:ClearShieldProjections()
        AShieldStructureUnit.OnDestroy(self)
    end,
}

TypeClass = SAB4401