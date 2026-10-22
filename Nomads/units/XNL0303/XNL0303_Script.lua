local NLandUnit = import('/mods/nomads/lua/nomadsunits.lua').NLandUnit
local AnnihilatorCannon1 = import('/mods/nomads/lua/nomadsweapons.lua').AnnihilatorCannon1
local RocketWeapon1 = import('/mods/nomads/lua/nomadsweapons.lua').RocketWeapon1

---@class XNL0303 : NLandUnit
XNL0303 = Class(NLandUnit) {
    Weapons = {
        MainGun = Class(AnnihilatorCannon1) {},
        Rocket = Class(RocketWeapon1) {},
    },

    OnCmdrUpgradeFinished = function(self)
    end,

    ---@param self XNL0303
    ---@param enh string
    CreateEnhancement = function(self, enh)
        NLandUnit.CreateEnhancement(self, enh)
        if enh == 'Shield' then
            local bp = self:GetBlueprint().Enhancements.Shield
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:CreateShield(bp)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive(true)
            self:EnableShield()
        elseif enh == 'ShieldRemove' then
            self:DestroyShield()
            self:SetMaintenanceConsumptionActive(false)
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
        end
    end,
}
TypeClass = XNL0303