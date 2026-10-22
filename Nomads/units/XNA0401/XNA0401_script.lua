local Explosion = import('/lua/defaultexplosions.lua')
local NomadsEffectTemplate = import('/mods/nomads/lua/nomadseffecttemplate.lua')
local NExperimentalAirTransportUnit = import('/mods/nomads/lua/nomadsunits.lua').NExperimentalAirTransportUnit
local DarkMatterWeapon1 = import('/mods/nomads/lua/nomadsweapons.lua').DarkMatterWeapon1
local MissileWeapon1 = import('/mods/nomads/lua/nomadsweapons.lua').MissileWeapon1


--- Experimental Air Transport
---@class XNA0401 : NExperimentalAirTransportUnit
XNA0401 = Class(NExperimentalAirTransportUnit) {

    BeamExhaustCruise = '/effects/emitters/transport_thruster_beam_01_emit.bp',
    BeamExhaustIdle = '/effects/emitters/transport_thruster_beam_02_emit.bp',


    Weapons = {
        ChainGun01 = Class(DarkMatterWeapon1) {},
        ChainGun02 = Class(DarkMatterWeapon1) {},
        ChainGun03 = Class(DarkMatterWeapon1) {},
        ChainGun04 = Class(DarkMatterWeapon1) {},
        SAM01 = Class(MissileWeapon1) {},
        SAM02 = Class(MissileWeapon1) {},
    },

    -- don't blow up in air when killed
    DestroyNoFallRandomChance = 1.1,

    -- engine bones that tilt side to side, and forwards/backwards
    EngineThrustControllerBones = {
        EngineArmRotatorLeft02 = false,
        EngineArmRotatorLeft01 = false,
        EngineArmRotatorRight01 = false,
        EngineArmRotatorRight02 = false,

        --the actual engines
        EngineRotatorRight01 = true,
        EngineRotatorRight02 = true,
        EngineRotatorRight03 = true,
        EngineRotatorRight04 = true,
        EngineRotatorLeft01 = true,
        EngineRotatorLeft02 = true,
        EngineRotatorLeft03 = true,
        EngineRotatorLeft04 = true
    },
	
    ---@param self AirTransport
    ReduceTransportSpeed = function(self)
		--no speed reduction from picking up units
    end,
	
    ---@param self XNA0401
    ---@param builder Unit
    ---@param layer Layer
    OnStopBeingBuilt = function(self, builder, layer)
        NExperimentalAirTransportUnit.OnStopBeingBuilt(self, builder, layer)

        local bp = self.Blueprint

        -- set up the thrusting arcs for the engines
        for boneName, tiltForwards in self.EngineThrustControllerBones do
            local controller = CreateThrustController(self, "thruster", boneName)
            if tiltForwards == true then
                --                      XMAX,XMIN,YMAX,YMIN,ZMAX,ZMIN, TURNMULT, TURNSPEED
                controller:SetThrustingParam(-0.0, 0.0, -0.75, 0.75, -0.2, 0.2, 1.0, 0.08)
            elseif tiltForwards == false then
                controller:SetThrustingParam(-0.15, 0.15, -1.0, 1.0, -0.0, 0.0, 1.0, 0.08)
            end
        end

        self.LandingAnimManip = CreateAnimator(self)
        self.LandingAnimManip:SetPrecedence(0)
        self.Trash:Add(self.LandingAnimManip)

        local landAnim = bp.Display.AnimationLand
        if landAnim then
            local manip = self.LandingAnimManip:PlayAnim(landAnim)
            if manip then
                manip:SetRate(0)
            else
                WARN('XNA0401: PlayAnim failed for AnimationLand: ' .. landAnim)
            end
        else
            WARN('XNA0401: bp.Display.AnimationLand is nil')
        end

        self.HolderArmManip = CreateAnimator(self)
        self.HolderArmManip:SetPrecedence(1)
        self.Trash:Add(self.HolderArmManip)

        local holderAnim = bp.Display.AnimationHolder
        if holderAnim then
            local manip = self.HolderArmManip:PlayAnim(holderAnim)
            if manip then
                manip:SetRate(0.5)
            else
                WARN('XNA0401: PlayAnim failed for AnimationHolder: ' .. holderAnim)
            end
        else
            WARN('XNA0401: bp.Display.AnimationHolder is nil')
        end
    end,

    ---@param self XNA0401
    ---@param attachBone Bone
    ---@param unit Unit
    OnTransportAttach = function(self, attachBone, unit)
        NExperimentalAirTransportUnit.OnTransportAttach(self, attachBone, unit)
        if EntityCategoryContains(categories.NAVAL + categories.EXPERIMENTAL, unit) and self.HolderArmManip then
            self.HolderArmManip:SetRate(-1)
        end
    end,

    ---@param self XNA0401
    ---@param attachBone Bone
    ---@param unit Unit
    OnTransportDetach = function(self, attachBone, unit)
        NExperimentalAirTransportUnit.OnTransportDetach(self, attachBone, unit)
        if EntityCategoryContains(categories.NAVAL + categories.EXPERIMENTAL, unit) and self.HolderArmManip then
            self.HolderArmManip:SetRate(0.5)
        end
    end,

    ---@param self XNA0401
    ---@param new VerticalMovementState
    ---@param old VerticalMovementState
    OnMotionVertEventChange = function(self, new, old)
        NExperimentalAirTransportUnit.OnMotionVertEventChange(self, new, old)
        if (new == 'Hover') then
            self.LandingAnimManip:SetRate(1)
        elseif (new == 'Up') then
            self.LandingAnimManip:SetRate(-1)
        end
    end,

    --TODO: redo the crashing thread so its just as awesome but also makes sense with the new model:
    --[[
    option 1:
    1. create a rotator to tilt the transport to one side, randomly
    2. create explosions at the engine bones on that side.
    3. as the engines explode, the transport begins tilting towards that side.
    
    option 2 (superior):
    1. create 2 or more animations and put them in an anim block
    2. create explosions at the engine bones that correspond to the anim block (work out how to do this)
    3. add parts falling from the transport, and engines being displaced, ect. as the transport crashes
    --]]

    

    
}
TypeClass = XNA0401