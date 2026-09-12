-- PlayTest - SCU-Werte hochsetzen. NUR FUER TESTPARTIEN.
-- Erlaeuterung: siehe ..\hooks.md

local FAKTOR = 1000

local FAKTOR_SPEICHER = 100

local SCUS = { 'uel0301', 'ual0301', 'url0301', 'xsl0301' }

local FELDER = {
    'BuildRate',
    'ProductionPerSecondEnergy',
    'ProductionPerSecondMass',
}

local SPEICHERFELDER = {
    'StorageMass',
}


do
    local OldModBlueprints = ModBlueprints

    function ModBlueprints(all_blueprints)

        OldModBlueprints(all_blueprints)

        local gesetzt = 0

        for _, id in SCUS do

            local bp = all_blueprints.Unit[id]

            if not bp then
                WARN('PLAYTEST: Blueprint "'..id..'" nicht gefunden')
            elseif not bp.Economy then
                WARN('PLAYTEST: "'..id..'" hat keinen Economy-Abschnitt')
            else
                for _, feld in FELDER do

                    local alt = bp.Economy[feld]

                    if alt then
                        bp.Economy[feld] = alt * FAKTOR
                    else
                        -- ProductionPerSecondMass fehlt bei manchen Fassungen
                        bp.Economy[feld] = FAKTOR
                    end
                end

                for _, feld in SPEICHERFELDER do

                    local alt = bp.Economy[feld]

                    if alt then
                        bp.Economy[feld] = alt * FAKTOR_SPEICHER
                    else
                        -- SCUs haben im Original keinen eigenen Speicher
                        bp.Economy[feld] = FAKTOR_SPEICHER
                    end
                end

                gesetzt = gesetzt + 1

                LOG('PLAYTEST: '..id..' - BuildRate '..tostring(bp.Economy.BuildRate)
                    ..', Energie '..tostring(bp.Economy.ProductionPerSecondEnergy)
                    ..', Masse '..tostring(bp.Economy.ProductionPerSecondMass)
                    ..', Massespeicher '..tostring(bp.Economy.StorageMass))
            end
        end

        LOG('PLAYTEST: '..gesetzt..' von 4 SCUs versehen - Produktion x'..FAKTOR
            ..', Massespeicher x'..FAKTOR_SPEICHER)
    end
end
