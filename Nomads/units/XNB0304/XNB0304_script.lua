local NomadsEffectTemplate = import('/mods/nomads/lua/nomadseffecttemplate.lua')
local AddLights = import('/mods/nomads/lua/nomadsutils.lua').AddLights
local Entity = import('/lua/sim/Entity.lua').Entity
local NSCUFactoryUnit = import('/mods/nomads/lua/nomadsunits.lua').NSCUFactoryUnit

NSCUFactoryUnit = AddLights(NSCUFactoryUnit)

--- Tech 3 Quantum Gate
---@class XNB0304 : NSCUFactoryUnit
XNB0304 = Class(NSCUFactoryUnit) {

OnStopBeingBuilt = function(self, builder, layer)
    
        
        
        CreateTractorBeamFx = function(self)
        self.TractorBeamBag:Add( AttachBeamEntityToEntity(self, 'Tractor1', self, 'TractorFocus', self.Army, NomadsEffectTemplate.SCUFactoryBeam) )
        self.TractorBeamBag:Add( AttachBeamEntityToEntity(self, 'Tractor2', self, 'TractorFocus', self.Army, NomadsEffectTemplate.SCUFactoryBeam) )
        self.TractorBeamBag:Add( AttachBeamEntityToEntity(self, 'Tractor3', self, 'TractorFocus', self.Army, NomadsEffectTemplate.SCUFactoryBeam) )
        self.TractorBeamBag:Add( AttachBeamEntityToEntity(self, 'Tractor4', self, 'TractorFocus', self.Army, NomadsEffectTemplate.SCUFactoryBeam) )

        for k, v in NomadsEffectTemplate.SCUFactoryBeamOrigin do
            self.TractorBeamBag:Add( CreateEmitterAtBone(self, 'Tractor1', self.Army, v) )
            self.TractorBeamBag:Add( CreateEmitterAtBone(self, 'Tractor2', self.Army, v) )
            self.TractorBeamBag:Add( CreateEmitterAtBone(self, 'Tractor3', self.Army, v) )
            self.TractorBeamBag:Add( CreateEmitterAtBone(self, 'Tractor4', self.Army, v) )
        end
        for k, v in NomadsEffectTemplate.SCUFactoryBeamEnd do
            self.TractorBeamBag:Add( CreateEmitterAtBone(self, 'TractorFocus', self.Army, v) )
        end
    end,
        
        NSCUFactoryUnit.OnStopBeingBuilt(self, builder, layer)
    end,
}

TypeClass = XNB0304