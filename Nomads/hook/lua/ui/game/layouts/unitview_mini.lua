-- Nomads: Capacitor-Symbol und -Balken in der Einheitenansicht (mini), siehe doc.claude\mods\Nomads.md (Abschnitt Hooks).
-- Umgebaut: SetBG des alten Hooks (FAF-Fassung) entfernt, LOUDs SetBG bleibt. Symbol an der Schild-Position
-- (LOUD iconPositions[6] = {Left = 130, Top = 70}); Schild und Capacitor schliessen sich aus (hook\lua\ui\game\unitview.lua).
-- Texturen absolut im Mod, weil UIUtil.UIFile nur /textures/ui/<skin> durchsucht (uiutil.lua Z. 357-402).
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')

table.insert(iconPositions, {Left = 130, Top = 70})
table.insert(iconTextures, '/mods/nomads/textures/ui/common/game/unit_view_icons/capacitor.dds')

local function CapacitorBarTexture()
    local skin = UIUtil.currentSkin and UIUtil.currentSkin() or 'nomads'
    local path = '/mods/nomads/textures/ui/' .. skin .. '/game/unit-build-over-panel/capacitorbar.dds'
    if DiskGetFileInfo(path) then
        return path
    end
    return '/mods/nomads/textures/ui/nomads/game/unit-build-over-panel/capacitorbar.dds'
end

local oldSetLayout = SetLayout
function SetLayout()
    oldSetLayout()

    local controls = import('/lua/ui/game/unitview.lua').controls
    if not controls.capacitorBar then
        return
    end
    LayoutHelpers.Below(controls.capacitorBar, controls.fuelBar)
    controls.capacitorBar.Width:Set(188)
    controls.capacitorBar.Height:Set(2)
    controls.capacitorBar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_bg.dds'))
    controls.capacitorBar._bar:SetTexture(CapacitorBarTexture())
end