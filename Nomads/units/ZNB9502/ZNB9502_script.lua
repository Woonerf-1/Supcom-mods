-- T2 air factory (support, non HQ)

local NAirFactoryUnit = import('/mods/nomads/lua/nomadsunits.lua').NAirFactoryUnit


ZNB9502 = Class(NAirFactoryUnit) {

    OnCreate = function(self)
        NAirFactoryUnit.OnCreate(self)

        -- Hide bones
    end,
}

TypeClass = ZNB9502
