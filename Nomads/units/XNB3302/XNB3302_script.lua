local NSonarUnit = import('/mods/nomads/lua/nomadsunits.lua').NSonarUnit
local NomadsEffectTemplate = import('/mods/nomads/lua/nomadseffecttemplate.lua')

--- Tech 3 Sonar
---@class XNB3302 : NSonarUnit
XNB3302 = Class(NSonarUnit) {
    IntelBoostFxBone = 0,
    OverchargeChargingFxBone = 0,
    OverchargeExplosionFxBone = 0,

    IntelBoostFx = NomadsEffectTemplate.T3SonarOvercharge,
    OverchargeRecoveryFx = NomadsEffectTemplate.T3SonarOverchargeRecovery,
    OverchargeChargingFx = NomadsEffectTemplate.T3SonarOverchargeCharging,
    OverchargeExplosionFx = NomadsEffectTemplate.T3SonarOverchargeExplosion,
}
TypeClass = XNB3302