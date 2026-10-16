-- Yathsou (XSS0304) ohne Flak, siehe doc.claude\mods\NavyRebalance.md Abschnitt 5.3

do
    local OldModBlueprints = ModBlueprints

    function ModBlueprints(all_blueprints)

        local bp = all_blueprints.Unit['xss0304']

        if bp then

            -- Ein Merge kann keine Listeneintraege loeschen, deshalb hier.
            -- Waffen werden ueberall per Label gesucht (Unit.lua DoDeathWeapon), die
            -- Position in der Liste ist gleichgueltig.
            for i = table.getn(bp.Weapon or {}), 1, -1 do
                if bp.Weapon[i].Label == 'AA' then
                    table.remove(bp.Weapon, i)
                end
            end

            local ab = bp.Display and bp.Display.Abilities
            if ab then
                for i = table.getn(ab), 1, -1 do
                    if ab[i] == '<LOC ability_aa>Anti-Air' then
                        table.remove(ab, i)
                    end
                end
            end

            LOG('NavyRebalance: Yathsou ohne Flak, Waffen: '..table.getn(bp.Weapon))
        end

        OldModBlueprints(all_blueprints)
    end
end
