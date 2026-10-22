

AbilityDefinition = import('/lua/abilitydefinition.lua').abilities
TasksFile = import( '/lua/user/tasks/Tasks.lua' )
VerifyScriptCommand2 = TasksFile.VerifyScriptCommand
MapReticulesToUnitIdsScript = TasksFile.MapReticulesToUnitIdsScript
GetAvailableAbilityUnits = TasksFile.GetAvailableAbilityUnits


local OldVerifyScriptCommand = VerifyScriptCommand

function VerifyScriptCommand(data)

    local mode = CM.GetCommandMode()
    if not mode or not mode[2] then
        return OldVerifyScriptCommand(data)
    end

    local modeData = mode[2]
    local TaskName = modeData.TaskName

    -- If this is NOT your custom ability, use default behavior
    if not AbilityDefinition[TaskName]
    or not AbilityDefinition[TaskName].CustomReticuleMapping then
        return OldVerifyScriptCommand(data)
    end

    --------------------------------------------------------------------
    -- Only custom abilities below this point
    --------------------------------------------------------------------

    local abilDef = AbilityDefinition[TaskName]

    local result = {
        Behaviour = modeData.Behaviour or 1,
        ExtraInfo = abilDef.ExtraInfo or {},
        Location = data.Target.Position,
        TaskName = TaskName,
        Units = {},
        UnitIds = {},
        UserValidated = false,
    }

    if abilDef.GetAllUnitsFile then
        result.UnitIds = GetAvailableAbilityUnits(TaskName, true)
        for k, id in result.UnitIds do
            table.insert(result.Units, GetUnitById(id))
        end
    elseif modeData.SelectedUnits then
        result.UnitIds = modeData.SelectedUnits
        for k, id in result.UnitIds do
            table.insert(result.Units, GetUnitById(id))
        end
    end

    -- Reticule mapping
    local ReticulePositions
    local views = import('/lua/ui/game/worldview.lua').GetWorldViews()

    for k, view in views do
        if view:GetAbilityData('Name') == TaskName then
            ReticulePositions = view:GetTargetLocations()
            break
        end
    end

    if ReticulePositions then

        local map = MapReticulesToUnitIdsScript(
            TaskName,
            ReticulePositions,
            result.Units,
            result.UnitIds
        )

        if map then
            result.UnitIds = {}
            result.Units = {}
            result.ExtraInfo.Targets = {}

            for RetId, UId in map do
                table.insert(result.ExtraInfo.Targets, {
                    Position = ReticulePositions[RetId],
                    ReticuleId = RetId,
                    UnitId = UId,
                })

                if not table.find(result.UnitIds, UId) then
                    table.insert(result.UnitIds, UId)
                    table.insert(result.Units, GetUnitById(UId))
                end
            end
        end
    end

    result = VerifyScriptCommand2(result)

    if result.Units then
        result.Units = nil
    end

    return result
end



