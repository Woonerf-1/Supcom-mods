
-- Add our custom callbacks
function ActivateCapacitor(data)
    local units = data.selection or {}
    for _, unitId in units do
        local unit = GetEntityById(unitId)
        if unit and not unit.Dead and unit.ActivateCapacitor then
            unit:ActivateCapacitor()
        end
    end
end

function AutoCapacitor(data)
    local auto = data.Args and data.Args.auto or false
    local units = data.selection or {}
    for _, unitId in units do
        local unit = GetEntityById(unitId)
        if unit and not unit.Dead and unit.SetAutoCapacitor then
            unit:SetAutoCapacitor(auto)
        end
    end
end

