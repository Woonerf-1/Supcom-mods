-- Custom Factions: KI-Sprueche der Fraktionen ab Index 5. Siehe README.md (Abschnitt Sprueche).
-- AITaunts ist in LOUDs sorianutilities.lua lokal (Z. 27) und wird mit aiBrain.FactionIndex gelesen (Z. 86-97);
-- Eintrag daher direkt am Fraktionsindex. Gleiche Nummernregel wie hook\lua\ui\game\taunt.lua.
do
    -- Nummern: LOUD belegt 1-64 (lua/ui/game/taunt.lua, 64 Eintraege ab Z. 8). Jede Fraktion ab Index 5 mit Feld
    -- TauntsFile bekommt einen fortlaufenden Block dahinter, in der Reihenfolge von Factions. Oberflaeche und Sim
    -- rechnen getrennt, aber gleich; die Factions-Reihenfolge ist bei Host und Gast gleich (Bootstrap sortiert).
    local nextNumber = 65
    local blocks = {}
    for index, faction in import('/lua/factions.lua').Factions do
        if index > 4 and faction.TauntsFile then
            local entries = import(faction.TauntsFile).Taunts or {}
            blocks[index] = { first = nextNumber, entries = entries }
            nextNumber = nextNumber + table.getn(entries)
        end
    end    for index, faction in import('/lua/factions.lua').Factions do
        if index > 4 and not AITaunts[index] then
            local block = blocks[index]
            if block and table.getn(block.entries) > 0 then
                local numbers = {}
                for i = 1, table.getn(block.entries) do
                    table.insert(numbers, block.first + i - 1)
                end
                AITaunts[index] = numbers
            else
                -- ohne eigene Sprueche: LOUD wuerde in AIRandomizeTaunt (Z. 89) an nil scheitern
                AITaunts[index] = AITaunts[1]
            end
        end
    end
end