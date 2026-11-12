-- Nomads-Texte, siehe doc.claude\mods\Nomads.md
import('/mods/nomads/lua/NomadsLoc.lua').Install()

-- Name des aktuellen Skins fuer die Capacitor-Balken (hook\lua\ui\game\layouts\unitview_*.lua).
-- LOUD haelt ihn nur in der lokalen LazyVar currentSkin (uiutil.lua Z. 82), daher hier mitschreiben.
local nomadsSkinName = nil

local oldSetCurrentSkin = SetCurrentSkin
function SetCurrentSkin(skin)
    oldSetCurrentSkin(skin)
    if import('/lua/skins/skins.lua').skins[skin] == nil then
        skin = 'uef'
    end
    nomadsSkinName = skin
end

function GetCurrentSkinName()
    return nomadsSkinName
end
