-- Nomads: Capacitor-Rueckrufe, siehe doc.claude\mods\Nomads.md (Abschnitt Hooks).
-- LOUD verteilt Rueckrufe nur ueber die lokale Tabelle Callbacks (lua/SimCallbacks.lua Z. 8-17,
-- Aufruf fn(data, units)); globale Funktionen wie im alten Hook erreicht DoCallback nicht.

Callbacks.ActivateCapacitor = function(data, units)
    for _, unit in units or {} do
        if unit and not unit.Dead and unit.ActivateCapacitor then
            unit:ActivateCapacitor()
        end
    end
end

Callbacks.AutoCapacitor = function(data, units)
    local auto = (data and data.auto) or false
    for _, unit in units or {} do
        if unit and not unit.Dead and unit.SetAutoCapacitor then
            unit:SetAutoCapacitor(auto)
        end
    end
end