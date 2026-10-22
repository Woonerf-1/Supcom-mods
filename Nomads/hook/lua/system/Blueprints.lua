-- Nomads: verbesserte Hydrocarbon-Kraftwerke CNB1202 Eckard (Stufe 2) und CNB1302 Guenter (Stufe 3) nur
-- zusammen mit ImprovedHydrocarbonPowerPlants. Siehe doc.claude\mods\Nomads.md (Abschnitt Hydrocarbon).
--
-- Herkunft: Colins NOMADS-try_b4_ur_BI (jetzt doc.claude\_Altlasten). XNB1102 Basic Hydrocarbon Power Plant
-- verweist von sich aus auf cnb1202 (UpgradesTo, BuildableCategory, RebuildBonusIds) - wie LOUDs eigene T1-Kraftwerke
-- auf die Einheiten aus ImprovedHydrocarbonPowerPlants (doc.claude\mods\ImprovedHydrocarbonPowerPlants.md Abschnitt 3).
--
-- Erkennung ueber die UEF-Gegenstuecke beb1202/beb1302, nicht ueber die uid: wer immer diese Einheiten liefert,
-- mit ihm sind auch die Nomads-Kraftwerke aktiv.
--  - fehlen sie: CNB1202/CNB1302 werden nicht registriert; XNB1102 hat dann keinen Ausbau (wie LOUD ohne den Mod).
--  - sind sie da: Adjacency, Defense.RegenRate und Economy.StorageEnergy - die Felder, die ImprovedHydrocarbonPowerPlants
--    nach seinen Mod-Manager-Einstellungen vereinheitlicht - werden vom Gegenstueck uebernommen.
--
-- Mechanismus: Wrapper um RegisterAllBlueprints (LOUD lua.scd, lua/system/Blueprints.lua Z. 499). LoadBlueprints ruft
-- es nach ModBlueprints auf (Z. 1335/1339), also nach allen Mod-Hooks auf ModBlueprints, unabhaengig von deren
-- Reihenfolge. Blueprint-Schluessel sind klein geschrieben (Z. 142-143).

do
    local Counterparts = {
        cnb1202 = 'beb1202',
        cnb1302 = 'beb1302',
    }

    local OldRegisterAllBlueprints = RegisterAllBlueprints

    function RegisterAllBlueprints(blueprints)

        local units = blueprints.Unit

        local active = true
        for own, ref in Counterparts do
            if not units[ref] then
                active = false
            end
        end

        for own, ref in Counterparts do
            local bp = units[own]
            if bp then
                if not active then
                    units[own] = nil
                else
                    local src = units[ref]
                    bp.Adjacency = src.Adjacency
                    if src.Defense and src.Defense.RegenRate then
                        bp.Defense = bp.Defense or {}
                        bp.Defense.RegenRate = src.Defense.RegenRate
                    end
                    bp.Economy = bp.Economy or {}
                    bp.Economy.StorageEnergy = src.Economy and src.Economy.StorageEnergy
                end
            end
        end

        if active then
            LOG('Nomads: verbesserte Hydrocarbon-Kraftwerke aktiv (Werte wie beb1202/beb1302)')
        else
            LOG('Nomads: verbesserte Hydrocarbon-Kraftwerke inaktiv (beb1202/beb1302 nicht geladen)')
        end

        OldRegisterAllBlueprints(blueprints)
    end
end
