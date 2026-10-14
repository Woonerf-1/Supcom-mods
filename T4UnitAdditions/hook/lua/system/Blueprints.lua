-- Alle T4-Landeinheiten transportierbar, siehe doc.claude\mods\T4UnitAdditions.md Abschnitt 11.6

do
    local OldModBlueprints = ModBlueprints

    function ModBlueprints(all_blueprints)

        local geaendert = {}

        for id, bp in all_blueprints.Unit do

            local cats = bp.Categories

            if cats
                and table.find(cats, 'EXPERIMENTAL')
                and table.find(cats, 'LAND')
                and table.find(cats, 'MOBILE')
                and table.find(cats, 'SELECTABLE')
            then
                bp.Transport = bp.Transport or {}

                local tc = bp.Transport.TransportClass

                if tc == nil or tc == 10 then
                    bp.Transport.TransportClass = 4
                    tc = 4
                end

                if tc == 4 then
                    bp.Transport.CanFireFromTransport = false
                    bp.General = bp.General or {}
                    bp.General.CommandCaps = bp.General.CommandCaps or {}
                    bp.General.CommandCaps.RULEUCC_CallTransport = true
                    table.insert(geaendert, id)
                end
            end
        end

        LOG('T4UnitAdditions: '..table.getn(geaendert)..' T4-Landeinheiten transportierbar: '..table.concat(geaendert, ' '))

        OldModBlueprints(all_blueprints)
    end
end
