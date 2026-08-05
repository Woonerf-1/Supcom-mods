local BLCCBuffTypes = {
    FiringRandomness = function(unit, buffName)
        for i = 1, unit:GetWeaponCount() do
            local wep = unit:GetWeapon(i)
            local wepfr = wep:GetBlueprint().FiringRandomness
            local val = BuffCalculate(unit, buffName, 'FiringRandomness', 1)
            wep:SetFiringRandomness( wepfr * val )
        end
    end,

    ShieldRegeneration = function(unit, buffName)
        if not unit.MyShield then return end

        unit.MyShield:SetShieldRegenRate(
            BuffCalculate(unit, buffName, 'ShieldRegeneration', 1) *
            (unit:GetBlueprint().Defense.Shield.ShieldRegenRate or 1)
        )
    end,

	ShieldSize = function(unit, buffName)
        if not unit.MyShield then return end

        unit.MyShield:SetSize(
            BuffCalculate(unit, buffName, 'ShieldSize', 1) *
            (unit:GetBlueprint().Defense.Shield.ShieldSize or 1)
        )

        if unit.MyShield:IsOn() then
            unit.MyShield:RemoveShield()
            unit.MyShield:CreateShieldMesh()
        end
    end,

    ShieldHealth = function(unit, buffName)
        local shield = unit.MyShield
        if not shield then return end

        SetMaxHealth( shield,
            BuffCalculate(unit, buffName, 'ShieldHealth', 1) *
            (unit:GetBlueprint().Defense.Shield.ShieldMaxHealth or 1)
        )
        SetShieldRatio( shield.Owner, shield:GetHealth() / shield:GetMaxHealth() )

        if shield.RegenThread then
            KillThread(shield.RegenThread)
        end
        shield.RegenThread = shield:ForkThread( shield.RegenStartThread )
        TrashAdd( shield.Owner.Trash, shield.RegenThread )
        --shield.Owner is probably the same as unit, but not nessessarily
    end,

}

do
    local OldBuffAffectUnit = BuffAffectUnit

    function BuffAffectUnit(unit, buffName, instigator, afterRemove)

        local buffDef = Buffs[buffName]
        local buffAffects = buffDef.Affects

        local fType, fVals = next(buffAffects)
        local sType, sVals = next(buffAffects, fType)

        if not fType then
            return
        end

        if sType or not BLCCBuffTypes[fType] then
            return OldBuffAffectUnit(unit, buffName, instigator, afterRemove)
        end

        -- New stuff
        if buffDef.OnBuffAffect and not afterRemove then
            buffDef:OnBuffAffect(unit, instigator)
        end

        BLCCBuffTypes[fType](unit, buffName)
    end
end
local Buff = import('/lua/sim/Buff.lua')
do
    local OldBuffAffectUnit = BuffAffectUnit
    function BuffAffectUnit(unit, buffName, instigator, afterRemove)
        local VersionIsFAF = import(import( '/lua/game.lua' ).BrewLANPath .. '/lua/legacy/VersionCheck.lua').VersionIsFAF()
        if buffName == 'DarknessOmniNerf' and not VersionIsFAF then
            local buffDef = Buffs[buffName]
            local buffAffects = buffDef.Affects
            if buffDef.OnBuffAffect and not afterRemove then
                buffDef:OnBuffAffect(unit, instigator)
            end
            for atype, vals in buffAffects do
                if atype == 'OmniRadius' then
                    local val = BuffCalculate(unit, buffName, 'OmniRadius', unit:GetBlueprint().Intel.OmniRadius or 0)
                    if not unit:IsIntelEnabled('Omni') then
                        unit:InitIntel(unit:GetArmy(),'Omni', val)
                        unit:EnableIntel('Omni')
                    else
                        unit:SetIntelRadius('Omni', val)
                        unit:EnableIntel('Omni')
                    end

                    if val <= 0 then
                        unit:DisableIntel('Omni')
                    end
                end
            end
        else
            OldBuffAffectUnit(unit, buffName, instigator, afterRemove)
        end
    end
end
