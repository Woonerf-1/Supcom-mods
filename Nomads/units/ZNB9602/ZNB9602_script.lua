-- T3 air factory (support, non HQ)

local NAirFactoryUnit = import('/mods/nomads/lua/nomadsunits.lua').NAirFactoryUnit


ZNB9602 = Class(NAirFactoryUnit) {

    OnCreate = function(self)
        NAirFactoryUnit.OnCreate(self)

        -- hide bones
    end,
}

TypeClass = ZNB9602
