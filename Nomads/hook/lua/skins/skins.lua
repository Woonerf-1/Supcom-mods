-- Nomads-Skin, siehe doc.claude\mods\Nomads.md (Abschnitt Hooks). Genutzt im Spiel ueber DefaultSkin (gamemain.lua Z. 201).
-- Pfade absolut im Mod; Rueckfall auf den UEF-Skin; doppeltes dialogColumnColor (FFAD976E) entfernt, gilt FFC1782A.
do

skins = table.merged( skins, {

    nomads = {
        default = "uef",            -- wie LOUDs Fraktions-Skins (skins.lua Z. 46/77/107)
        texturesPath = "/mods/nomads/textures/ui/nomads",
        imagerMesh = "/mods/nomads/meshes/game/map-border_squ_nomads_mesh",
        imagerMeshHorz = "/mods/nomads/meshes/game/map-border_hor_nomads_mesh",
        buttonFont = "Zeroes Three",
        factionFont = "Zeroes Three",
        bodyFont = "Arial",
        fixedFont = "Arial",
        titleFont = "Zeroes Three",
        bodyColor = "FFC1782A",
        factionFontOverColor = "FFff0000",
        factionFontDownColor = "FFFFFFFF",
        factionTextColor = "FFFC8F00",
        factionBackColor = "FFD68E00",
        fontOverColor = "FFFFFFFF",
        fontDownColor = "FF513923",
        fontColor = "FFFC8F00",
        dialogCaptionColor = "FFD6C6BC",
        dialogButtonColor = "FF4EAA7F",
        dialogButtonFont = "Zeroes Three",
        highlightColor = "FFA59075",
        disabledColor = "FF3D3630",
        tooltipBorderColor = "FFAF886D",
        tooltipTitleColor = "FF3F1700",
        tooltipBackgroundColor = "FF000000",
        dialogColumnColor = "FFC1782A",
        menuFontSize = 18,
        layouts = {
            "bottom",
            "left",
            "right"
        },
    },
})



end
