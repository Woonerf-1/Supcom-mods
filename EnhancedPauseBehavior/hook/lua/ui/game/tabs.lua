--[[
    Mod:      EnhancedPauseBehavior
    Hookt:    /lua/ui/game/tabs.lua
    Zweck:    Bereit-Abfrage einhaengen (Create), Pause-Knopf nach abgefangenem
              Fortsetzen gedrueckt halten (CommonLogic), Abfrage bei Fortsetzen
              schliessen (OnPause)
    Original: LOUD\gamedata\lua.scd -> lua/ui/game/tabs.lua
              (Create Z. 358, CommonLogic Z. 412-497, OnPause Z. 741)
    Stand:    2026-10-31
]]

local EPB_ReadyCheck = import('/mods/enhancedpausebehavior/modules/readycheck.lua')

local EPB_OldCreate = Create
function Create(parent)
    EPB_ReadyCheck.Init()
    return EPB_OldCreate(parent)
end

local EPB_OldCommonLogic = CommonLogic
function CommonLogic()
    EPB_OldCommonLogic()
    for _, tab in controls.tabs do
        if tab.Data.pause and not tab.EPB_Wrapped then
            tab.EPB_Wrapped = true
            local oldOnCheck = tab.OnCheck
            tab.OnCheck = function(self, checked)
                EPB_ReadyCheck.ClearBlocked()
                oldOnCheck(self, checked)
                if not checked and EPB_ReadyCheck.TakeBlocked() then
                    self:SetCheck(true, true)
                    self:SetGlowState(true)
                end
            end
        end
    end
end

local EPB_OldOnPause = OnPause
function OnPause(state, pausedBy, lTimeoutsRemaining, isOwner)
    EPB_OldOnPause(state, pausedBy, lTimeoutsRemaining, isOwner)
    if not state then
        EPB_ReadyCheck.OnGameResumed()
    end
end
