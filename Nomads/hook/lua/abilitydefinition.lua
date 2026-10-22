-- Nomads-Faehigkeiten, siehe doc.claude\mods\Nomads.md (Abschnitt Hooks).
-- Ergaenzt LOUDs Tabelle abilities (lua/abilitydefinition.lua), statt sie neu zuzuweisen: LOUDs eigene
-- Eintraege (TargetLocation, EXScryTarget) bleiben. Slots nach LOUDs orders.lua (Z. 923-965, Verteilung
-- Z. 1265-1299). Capacitor-Rueckrufe ueber SimCallback({Func, Args}, true): die Auswahl kommt als
-- zweiter Parameter in SimCallbacks (lua/SimCallbacks.lua Z. 10-17).
-- FAF-Felder (UISlot, usage, UIBehavior*, GetAllUnitsFile, AbilityRequirement, MouseDecal) liest LOUD nicht;
-- sie bleiben fuer den Nomads-Faehigkeitenpanel (lua\ui\ability_panel) stehen.

local NomadsAbilities = {

    -- TODO: active ability decals for most

    LaunchNuke = {
        UIBitmapId = 'nuke',
        cursor = 'RULEUCC_Tactical',
        enabled = true,
        ExtraInfo = {},
        UIHelpText = 'specabil_launch_nuke',
        UISlot = 1,
        preferredSlot = 12,
        script = 'LaunchNuke',
        usage = 'Event',

        UIBehaviorSingleClick = {
            AllowDraging = true,
            AllowMaxSpread = true,
            DragDelta = 0,
            UseSelected = true,
        },
        UIBehaviorDoubleClick = {
            AllowDraging = true,
            AllowMaxSpread = true,
            AllReticulesAtStart = true,
            DragDelta = 2,
            UseSelected = true,
        },

        GetAllUnitsFile = '/mods/nomads/lua/user/tasks/Tasks.lua',
    },

    LaunchTacMissile = {
        UIBitmapId = 'tactical',
        cursor = 'RULEUCC_Tactical',
        enabled = true,
        ExtraInfo = {
            DoRangeCheck = true,
            NumReticules = 1,
        },
        UIHelpText = 'specabil_launch_tacmissile',
        UISlot = 2,
        preferredSlot = 12,
        script = 'LaunchTacMissile',
        usage = 'Event',

        UIBehaviorSingleClick = {
            DragDelta = 0,
            UseSelected = true,
        },
        UIBehaviorDoubleClick = {
            AllReticulesAtStart = true,
            DragDelta = 1,
            UseSelected = true,
        },

        GetAllUnitsFile = '/mods/nomads/lua/user/tasks/Tasks.lua',
    },

    NomadsAreaBombardment = {
        UIBitmapId = 'area-assist',
        cursor = 'RULEUCC_SpecialAction',
        enabled = true,
        ExtraInfo = {
            DoRangeCheck = true,
            NumReticules = 1,
        },
        UIHelpText = 'specabil_areabombardment',
        UISlot = 3,
        preferredSlot = 9,
        script = 'NomadsAreaBombardment',
        usage = 'Event',

        UIBehaviorSingleClick = {
            DragDelta = 1,
            UseSelected = true,
        },
        UIBehaviorDoubleClick = {
            AllowDraging = true,
            AllowMaxSpread = true,
            AllReticulesAtStart = true,
            DragDelta = 2,
            UseSelected = true,
        },

--        SoundReady = 'OrbitalStrikeReady',
--        SoundLaunched = 'OrbitalStrikeLaunched',

        GetAllUnitsFile = '/mods/nomads/lua/user/tasks/Tasks.lua',
    },

    NomadsIntelProbe = {
        UIBitmapId = 'intelprobe',
        cursor = 'RULEUCC_SpecialAction',
        enabled = true,
        ExtraInfo = {
            DoRangeCheck = false,
            Lifetime = 60,
        },
        UIHelpText = 'specabil_intelprobe',
        ActiveDecal = {
            enabled = false,
        },
        UISlot = 4,
        preferredSlot = 10,
        script = 'NomadsIntelProbe',
        usage = 'Event',

        SoundReady = 'IntelProbeReady',
        SoundLaunched = 'IntelProbeLaunched',

        UIBehaviorSingleClick = {
            AllowDraging = false,
            AllowMaxSpread = false,
            AllReticulesAtStart = false,
            DragDelta = 0,
            ReticuleSizeOverride = 70,
            UseSelected = true,
        },

        GetAllUnitsFile = '/mods/nomads/lua/user/tasks/Tasks.lua',
        
        -- THE FIX IS HERE
        AbilityRequirement = function(unit)
            local id = unit:GetEntityId()
            if UnitData[id] then
                return UnitData[id].HasIntelProbeAbility or false
            end
            return false
        end,
    },

    NomadsIntelProbeAdvanced = {
        UIBitmapId = 'intelprobe',
        cursor = 'RULEUCC_SpecialAction',
        enabled = true,
        ExtraInfo = {
            DoRangeCheck = false,
            Lifetime = 30,
        },
        UIHelpText = 'specabil_intelprobe',
        ActiveDecal = {
            enabled = false, 
        },
        UISlot = 4,
        preferredSlot = 10,
        script = 'NomadsIntelProbeAdvanced',
        usage = 'Event',

        SoundReady = 'IntelProbeReady',
        SoundLaunched = 'IntelProbeLaunched',

        UIBehaviorSingleClick = {
            AllowDraging = false,
            AllowMaxSpread = false,
            AllReticulesAtStart = false,
            DragDelta = 0,
            ReticuleSizeOverride = 35,
            UseSelected = true,
        },

        GetAllUnitsFile = '/mods/nomads/lua/user/tasks/Tasks.lua',
        
        -- THE FIX IS HERE
        AbilityRequirement = function(unit)
            local id = unit:GetEntityId()
            if UnitData[id] then
                return UnitData[id].HasIntelProbeAdvancedAbility or false
            end
            return false
        end,
    },

    Capacitor = {
        preferredSlot = 9,
        onframe = function (self, deltaTime)
            local UIUtil = import('/lua/ui/uiutil.lua')
            
            --ask what state the capacitors are in
            local CapacitorState = false
            local selection = import('/lua/ui/game/orders.lua').GetCurrentSelection()

            if selection then
                for i, unit in ipairs(selection) do
                    if unit and not unit.Dead then
                        CapacitorState = UnitData[unit:GetEntityId()].CapacitorState
                    end
                end
            end

            
            --capacitor switches icon to a disabled icon when discharging
            if CapacitorState == 'Discharging' and not self:IsDisabled()then 
                self:Disable()
            elseif CapacitorState ~= 'Discharging' and self:IsDisabled() then
                self:Enable()
            end
            
            --setting textures is a bit of a mess. There are 4 states but toggle buttons have two. So we need to mess with them a bit.
            
            local bitmapId = CapacitorState or "unfilled"
            local button_prefix = "/game/orders/" .. bitmapId .. "_btn_"
            local textures = {
                button_prefix .. "up.dds",
                button_prefix .. "up_sel.dds",
                button_prefix .. "over.dds",
                button_prefix .. "over.dds",
                button_prefix .. "dis.dds",
                button_prefix .. "dis.dds",
            }
            --make the discharging capacitor icon green, even though its disabled
            if CapacitorState == "Discharging" then
                textures[6] = textures[2]
            end
            
            self:SetNewTextures(
                    UIUtil.SkinnableFile(textures[1], true),
                    UIUtil.SkinnableFile(textures[2], true),
                    UIUtil.SkinnableFile(textures[3], true),
                    UIUtil.SkinnableFile(textures[4], true),
                    UIUtil.SkinnableFile(textures[5], true),
                    UIUtil.SkinnableFile(textures[6], true))
            
            if self._isAutoMode then
                self.autoModeIcon:SetAlpha(1)
            else
                self.autoModeIcon:SetAlpha(0)
            end
            
            --when unchecked, the icon shows a full battery, shown during charging
            self:SetCheck(CapacitorState ~= 'Charging')
        end,
        
        behavior = function(self, modifiers)
            local controls = import('/mods/nomads/lua/ui/controls.lua').Get()
            if modifiers.Left then
                -- THIS IS THE IMPORTANT PART - it calls the SimCallback
                local cb = { Func = 'ActivateCapacitor', Args = {} }
                SimCallback(cb, true)
            elseif modifiers.Right then
                self._curHelpText = self._data.helpText
                
                --toggle the autocapacitor mode
                self._isAutoMode = not self._isAutoMode
                
                if controls.mouseoverDisplay.text then
                    controls.mouseoverDisplay.text:SetText(self._curHelpText)
                end
                
                local cb = { Func = 'AutoCapacitor', Args = { auto = self._isAutoMode == true } }
                SimCallback(cb, true)
            end
            
            --update icon
            if self._isAutoMode then
                self.autoModeIcon:SetAlpha(1)
            else
                self.autoModeIcon:SetAlpha(0)
            end
        end,
        
        initialStateFunc = function(control, unitList)
            local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
            local UIUtil = import('/lua/ui/uiutil.lua')
            local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
            
            if not control.autoModeIcon then
                control.autoModeIcon = Bitmap(control, UIUtil.UIFile('/game/orders/autocast_green.dds'))
                LayoutHelpers.AtCenterIn(control.autoModeIcon, control)
                control.autoModeIcon:DisableHitTest()
                control.autoModeIcon:SetAlpha(0)
                control.autoModeIcon.OnHide = function(self, hidden)
                    if not hidden and control:IsDisabled() then
                        return true
                    end
                end
            end

            if not control.mixedModeIcon then
                control.mixedModeIcon = Bitmap(control.autoModeIcon, UIUtil.UIFile('/game/orders-panel/question-mark_bmp.dds'))
                LayoutHelpers.AtRightTopIn(control.mixedModeIcon, control)
                control.mixedModeIcon:DisableHitTest()
                control.mixedModeIcon:SetAlpha(0)
                control.mixedModeIcon.OnHide = function(self, hidden)
                    if not hidden and control:IsDisabled() then
                        return true
                    end
                end
            end

            control._isAutoMode = UnitData[unitList[1]:GetEntityId()].AutoCapacitor == true

            control._curHelpText = control._data.helpText
            if control._isAutoMode then
                control.autoModeIcon:SetAlpha(1)
            else
                control.autoModeIcon:SetAlpha(0)
            end

            -- needs to override this to prevent call to self:DisableHitTest()
            control.Disable = function(self)
                self._isDisabled = true
                self:OnDisable()
            end
        end,
        
        AbilityRequirement = function(unit)
            return UnitData[unit:GetEntityId()].HasCapacitorAbility
        end,
    }
}

for name, data in NomadsAbilities do
    if not abilities[name] then
        abilities[name] = data
    end
end