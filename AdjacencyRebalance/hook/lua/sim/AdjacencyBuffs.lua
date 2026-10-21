-- Nachbarschaftsboni, siehe doc.claude\mods\AdjacencyRebalance.md

do
    -- Werte wie nomads-4-loud\shadow\lua\sim\AdjacencyBuffs.lua.
    -- Die Buffs sind oben im Original per BuffBlueprint{} registriert; ein zweites
    -- BuffBlueprint{} mit gleichem Namen wuerde LOUD als Duplikat abweisen
    -- (BuffBlueprints.lua Z. 41-43), deshalb werden die Eintraege in der globalen
    -- Tabelle Buffs direkt geaendert.
    local Werte = {
        T1EnergyStorageEnergyProductionBonusSize4  = { EnergyProduction = { Add = 0.17 } },
        T1EnergyStorageEnergyProductionBonusSize12 = { EnergyProduction = { Add = 0.075 } },
        T1EnergyStorageEnergyProductionBonusSize16 = { EnergyProduction = { Add = 0.07 } },
        T1EnergyStorageShieldHealthBonusSize12     = { ShieldHealth = { Add = 0.015 } },
        T1EnergyStorageShieldHealthBonusSize16     = { ShieldHealth = { Add = 0.01 } },

        T2EnergyStorageEnergyProductionBonusSize4  = { EnergyProduction = { Add = 0.3 } },
        T2EnergyStorageEnergyProductionBonusSize12 = { EnergyProduction = { Add = 0.15 } },
        T2EnergyStorageEnergyProductionBonusSize16 = { EnergyProduction = { Add = 0.15 } },
        T2EnergyStorageShieldHealthBonusSize12     = { ShieldHealth = { Add = 0.045 } },
        T2EnergyStorageShieldHealthBonusSize16     = { ShieldHealth = { Add = 0.03 } },

        T3EnergyStorageEnergyProductionBonusSize4  = { EnergyProduction = { Add = 0.5, Mult = 1.1 } },
        T3EnergyStorageEnergyProductionBonusSize12 = { EnergyProduction = { Add = 0.25 } },
        T3EnergyStorageEnergyProductionBonusSize16 = { EnergyProduction = { Add = 0.16 } },
        T3EnergyStorageShieldHealthBonusSize12     = { ShieldHealth = { Add = 0.13 } },
        T3EnergyStorageShieldHealthBonusSize16     = { ShieldHealth = { Add = 0.1, Mult = 1.01 } },

        ExperimentalMassStorageProductionBonus     = { MassProduction = { Add = 0.3 } },
        ExperimentalEnergyStorageProductionBonus   = { EnergyProduction = { Add = 0.6 } },
        ExperimentalPowerRateOfFireBonus           = { RateOfFire = { Add = -0.16 } },
        ExperimentalEnergyStorageShieldRegenBonus  = { ShieldRegeneration = { Add = 0.1, Mult = 1.1 },
                                                       ShieldHealth       = { Add = 0.13, Mult = 1.1 } },
    }

    local gesetzt, fehlend = 0, {}

    for name, affects in Werte do
        local buff = Buffs[name]
        if buff and buff.Affects then
            for affect, felder in affects do
                buff.Affects[affect] = buff.Affects[affect] or { Add = 0, Mult = 1.0 }
                for feld, wert in felder do
                    buff.Affects[affect][feld] = wert
                    gesetzt = gesetzt + 1
                end
            end
        else
            table.insert(fehlend, name)
        end
    end

    LOG('AdjacencyRebalance: '..gesetzt..' Werte gesetzt')

    if table.getn(fehlend) > 0 then
        WARN('AdjacencyRebalance: Buff nicht gefunden: '..repr(fehlend))
    end
end
