-- Nomads: Capacitor in der Einheitenansicht, siehe doc.claude\mods\Nomads.md (Abschnitt Hooks).
-- statFuncs[6] (Schild) zeigt bei Capacitor-Einheiten nichts, neue statFuncs fuer den Capacitor (LOUD unitview.lua Z. 209-216,
-- Gruppen ueber LOUDGETN(statFuncs) Z. 682). Entfernt: zweite Anlage von controls.abilityBG (macht LOUD schon, Z. 700-710).
do

statFuncs[6] = function(info, bp)
    if not bp.Abilities.Capacitor and info.shieldRatio > 0 then
        return string.format('%d%%', math.floor(info.shieldRatio*100))
    else
        return false
    end
end
table.insert(statFuncs, function(info, bp)
    if bp.Abilities.Capacitor and info.shieldRatio > 0 then
        return string.format('%d%%', math.floor(info.shieldRatio*100))
    else
        return false
    end
end)

local oldUpdateWindow = UpdateWindow
function UpdateWindow(info)
    oldUpdateWindow(info)


    controls.capacitorBar:Hide()
    if info.blueprintId ~= 'unknown' then
        local bp = __blueprints[info.blueprintId]
        controls.shieldBar:Hide()
        if info.shieldRatio > 0 then
            if bp.Abilities.Capacitor then
                controls.capacitorBar:Show()
                controls.capacitorBar:SetValue(info.shieldRatio)
            else
                controls.shieldBar:Show()
                controls.shieldBar:SetValue(info.shieldRatio)
            end
        end
    end
end



local oldCreateUI = CreateUI
function CreateUI()
    oldCreateUI()
    controls.capacitorBar = StatusBar(controls.bg, 0, 1, false, false, nil, nil, true)


end

end
