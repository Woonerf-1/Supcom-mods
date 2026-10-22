-- Custom Factions: Sprueche der Fraktionen ab Index 5. Siehe README.md (Abschnitt Sprueche).
-- taunts ist in LOUDs taunt.lua lokal (Z. 8); Aufloesung ueber taunts[nummer] (Z. 81, 100, 114).
-- Gleiche Nummernregel wie hook\lua\AI\sorianutilities.lua - beide Stellen nur gemeinsam aendern.
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
    end    for index, block in blocks do
        for i, entry in block.entries do
            local n = block.first + i - 1
            if taunts[n] then
                WARN('Custom Factions: Spruch '..n..' ist schon belegt ('..tostring(taunts[n].cue)..'), Fraktion '..index..' ueberschreibt ihn')
            end
            taunts[n] = entry
        end
    end
end