-- Custom Factions: Tarmacs fuer unbekannte Fraktionen. Siehe README.md (Abschnitt Tarmacs).
-- LOUD bestimmt den Fraktionsindex aus dem 2. Zeichen der Blueprint-ID (defaultunits.lua Z. 576-578,
-- {e=1, a=2, r=3, s=4}); fuer andere Buchstaben ist er nil, und TarmacTable[nil][...] bricht ab (tarmacs.lua Z. 71).
-- Unbekannte Fraktion -> kein Terrain-Zusatz (LOUDs eigener Rueckfall '').
function GetTarmacType(factionIdx, terrainType, tarmacLayer)
    local t = TarmacTable[factionIdx]
    return (t and t[terrainType]) or ''
end