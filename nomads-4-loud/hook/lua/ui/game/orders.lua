function AddAbilityButtons(standardOrdersTable, availableOrders, units)
    -- Look for units in the selection that have special ability buttons
    -- If any are found, add the ability information to the standard order table
    if units and categories.ABILITYBUTTON and EntityCategoryFilterDown(categories.ABILITYBUTTON, units) then
        for index, unit in units do
            local tempBP = UnitData[unit:GetEntityId()]
            if tempBP.Abilities then
                for abilityIndex, ability in tempBP.Abilities do
                    if ability.Active ~= false then
                        table.insert(availableOrders, abilityIndex)
                        standardOrdersTable[abilityIndex] = table.merged(ability, import("/lua/abilitydefinition.lua").abilities[abilityIndex])
                        standardOrdersTable[abilityIndex].behavior = AbilityButtonBehavior
                    end
                end
            end
        end
    end
end

-- Creates the buttons for the alt orders, placing them as possible
local function CreateAltOrders(availableOrders, availableToggles, units)
    -- TODO? it would indeed be easier if the alt orders slot was in the blueprint, but for now try
    -- to determine where they go by using preferred slots
    AddAbilityButtons(standardOrdersTable, availableOrders, units)

    local assistingUnitList = {}

    --- Pods
    local podUnits = {}
    local podStagingPlatforms = EntityCategoryFilterDown(categories.PODSTAGINGPLATFORM, units)
    local pods = EntityCategoryFilterDown(categories.POD, units)
    if not table.empty(units) and (not table.empty(podStagingPlatforms) or not table.empty(pods)) then
        local assistingUnits = {}
        if not table.empty(pods) then
            for _, pod in pods do
                table.insert(assistingUnits, pod:GetCreator())
            end
            podUnits['DroneL'] = pods
        elseif not table.empty(podStagingPlatforms) then
            assistingUnits = GetAssistingUnitsList(podStagingPlatforms)
            podUnits['DroneL'] = assistingUnits
        end

        
        if not table.empty(assistingUnits) then
            if table.getn(podStagingPlatforms) == 1 and table.empty(pods) then
                table.insert(availableOrders, 'DroneL')
                assistingUnitList['DroneL'] = {assistingUnits[1]}
                if table.getn(assistingUnits) > 1 then
                    table.insert(availableOrders, 'DroneR')
                    assistingUnitList['DroneR'] = {assistingUnits[2]}
                    podUnits['DroneL'] = {assistingUnits[1]}
                    podUnits['DroneR'] = {assistingUnits[2]}
                end
            else
                table.insert(availableOrders, 'DroneL')
                assistingUnitList['DroneL'] = assistingUnits
            end
        end
    end

    --- External factories
    local exFacs = EntityCategoryFilterDown(categories.EXTERNALFACTORY + categories.EXTERNALFACTORYUNIT, units)
    if not table.empty(exFacs) and table.getn(exFacs) == table.getn(units) then
        -- make sure we've selected all external factories, or all external factory units
        if table.getn(EntityCategoryFilterDown(categories.EXTERNALFACTORY, exFacs)) == table.getn(units) or
           table.getn(EntityCategoryFilterDown(categories.EXTERNALFACTORYUNIT, exFacs)) == table.getn(units) then
            assistingUnitList['ExFac'] = {}
            -- finally, make sure our units are all of the same type
            local bp = exFacs[1]:GetUnitId()
            if table.getn(EntityCategoryFilterDown(categories[bp], exFacs)) == table.getn(exFacs) then
                for _, exFac in exFacs do
                    table.insert(assistingUnitList['ExFac'], exFac:GetCreator())
                end
                table.insert(availableOrders, 'ExFac')
            end
        end
    end

    -- Determine what slots to put alt orders
    -- We first want a table of slots we want to fill, and what orders want to fill them
    local desiredSlot = {}
    local usedSpecials = {}
    for index, availOrder in availableOrders do
        if standardOrdersTable[availOrder] then
            local preferredSlot = standardOrdersTable[availOrder].preferredSlot
            if not desiredSlot[preferredSlot] then
                desiredSlot[preferredSlot] = {}
            end
            table.insert(desiredSlot[preferredSlot], availOrder)
        else
            if specialOrdersTable[availOrder] ~= nil then
                specialOrdersTable[availOrder].behavior()
                usedSpecials[availOrder] = true
            end
        end
    end

    for index, availToggle in availableToggles do
        if standardOrdersTable[availToggle] then
            local preferredSlot = standardOrdersTable[availToggle].preferredSlot
            if not desiredSlot[preferredSlot] then
                desiredSlot[preferredSlot] = {}
            end
            table.insert(desiredSlot[preferredSlot], availToggle)
        else
            if specialOrdersTable[availToggle] ~= nil then
                specialOrdersTable[availToggle].behavior()
                usedSpecials[availToggle] = true
            end
        end
    end

    for i, specialOrder in specialOrdersTable do
        if not usedSpecials[i] and specialOrder.notAvailableBehavior then
            specialOrder.notAvailableBehavior()
        end
    end

    -- Now go through that table and determine what doesn't fit and look for slots that are empty
    -- Since this is only alt orders, just deal with slots 7-12
    local orderInSlot = {}

    -- Go through first time and add all the first entries to their preferred slot
    for slot = firstAltSlot, numSlots do
        if desiredSlot[slot] then
            orderInSlot[slot] = desiredSlot[slot][1]
        end
    end

    -- Now put any additional entries wherever they will fit
    for slot = firstAltSlot, numSlots do
        if desiredSlot[slot] and table.getn(desiredSlot[slot]) > 1 then
            for index, item in desiredSlot[slot] do
                if index > 1 then
                    local foundFreeSlot = false
                    for newSlot = firstAltSlot, numSlots do
                        if not orderInSlot[newSlot] then
                            orderInSlot[newSlot] = item
                            foundFreeSlot = true
                            break
                        end
                    end
                    if not foundFreeSlot then
                        SPEW("No free slot for order: " .. item)
                        -- Could break here, but don't, then you'll know how many extra orders you have
                    end
                end
            end
        end
    end

    -- Now map it the other direction so it's order to slot
    local slotForOrder = {}
    for slot, order in orderInSlot do
        slotForOrder[order] = slot
    end

    -- Create the alt order buttons
    for index, availOrder in availableOrders do
        if not standardOrdersTable[availOrder] then continue end -- Skip any orders we don't have in our table
        if not commonOrders[availOrder] and slotForOrder[availOrder] ~= nil then
            local orderInfo = standardOrdersTable[availOrder] or AbilityInformation[availOrder]
            local orderCheckbox = AddOrder(orderInfo, slotForOrder[availOrder], true)

            orderCheckbox._order = availOrder

            if standardOrdersTable[availOrder].script then
                orderCheckbox._script = standardOrdersTable[availOrder].script
            end

            if standardOrdersTable[availOrder].cursor then
                orderCheckbox._cursor = standardOrdersTable[availOrder].cursor
            end

            if assistingUnitList[availOrder] then
                orderCheckbox._unit = assistingUnitList[availOrder]
            end

            if podUnits[availOrder] then
                orderCheckbox._pod = podUnits[availOrder]
            end

            if orderInfo.initialStateFunc then
                orderInfo.initialStateFunc(orderCheckbox, currentSelection)
            end

            orderCheckboxMap[availOrder] = orderCheckbox
        end
    end

    for index, availToggle in availableToggles do
        if not standardOrdersTable[availToggle] then continue end -- Skip any orders we don't have in our table
        if not commonOrders[availToggle] and slotForOrder[availToggle] ~= nil then
            local orderInfo = standardOrdersTable[availToggle] or AbilityInformation[availToggle]
            local orderCheckbox = AddOrder(orderInfo, slotForOrder[availToggle], true)

            orderCheckbox._order = availToggle

            if standardOrdersTable[availToggle].script then
                orderCheckbox._script = standardOrdersTable[availToggle].script
            end

            if assistingUnitList[availToggle] then
                orderCheckbox._unit = assistingUnitList[availToggle]
            end

            if orderInfo.initialStateFunc then
                orderInfo.initialStateFunc(orderCheckbox, currentSelection)
            end

            orderCheckboxMap[availToggle] = orderCheckbox
        end
    end
end

function GetCurrentSelection()
    return currentSelection
end


local oldAddAbilityButtons = AddAbilityButtons
function AddAbilityButtons(standardOrdersTable, availableOrders, units)
    oldAddAbilityButtons(standardOrdersTable, availableOrders, units)
    
    
    if units and categories.ABILITYBUTTON and EntityCategoryFilterDown(categories.ABILITYBUTTON, units) then
        for index, unit in units do
            local tempBP = UnitData[unit:GetEntityId()]
            if tempBP.Abilities then
                for abilityIndex, ability in tempBP.Abilities do
                    if not standardOrdersTable[abilityIndex] then
                        continue
                    end
                    local merge = table.merged(ability, import('/lua/abilitydefinition.lua').abilities[abilityIndex])
                    if merge.behavior then
                        standardOrdersTable[abilityIndex].behavior = merge.behavior
                    end
                        
                    if standardOrdersTable[abilityIndex].AbilityRequirement and not standardOrdersTable[abilityIndex].AbilityRequirement(unit) then
                        standardOrdersTable[abilityIndex] = nil
                    end
                end
            end
        end
    end
end