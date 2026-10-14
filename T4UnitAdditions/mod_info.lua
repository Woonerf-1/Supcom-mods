-- ============================================================================
-- T4UnitAdditions
--
-- Ordner:   LOUD\usermods\T4UnitAdditions\
-- VFS-Pfad: /mods/t4unitadditions/
-- Doku:     doc.claude\mods\T4UnitAdditions.md
--
-- Extrakt aus UEF_trans_men: neun Experimentaleinheiten, transportierbar
-- gemacht, plus der Traeger MKT0409. Herkunft je Einheit in der Doku.
-- ============================================================================

name        = "T4 Unit Additions"
version     = 1.0
description = "Transportierbare Experimentaleinheiten und die Acclamator als Traeger. Aus 4DC, Wyvern Battle Pack, BrewLAN, LOUD Unit Additions und Basisspiel; Acclamator von Colin."
author      = "Colin"
copyright   = "none"

-- Bausymbol der Acclamator, liegt im Mod.
icon = "/mods/t4unitadditions/textures/ui/common/icons/units/MKT0409_icon.dds"

-- PFLICHT. Ohne diese Angabe waere die uid der volle Dateipfad
-- (mods.lua, LoadModInfo, Zeile 239).
uid = "A0B5C51C-A8F7-47E0-BAEF-DE1FFCC63805"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'

-- Die vier Pakete liefern dieselben IDs als Vollblueprint.
-- conflicts wirkt in beide Richtungen (mods.lua, GetDependencies, Zeile 396 ff.).
conflicts = {
    "25D57D85-7D84-27HT-A501-BR3WL4N000079",   -- BrewLAN for LOUD             (SSL0403, SSA0001)
    "454af309-5afb-458b-bf5b-a00000000007",    -- 4th Dimension Units for LOUD (UAL0402, UEL0402)
    "9a9C61C0-1787-10DF-A0AD-BATTLEPACK002",   -- Wyvern Battle Pack for LOUD  (WEL0401, WSL0404)
    "fffffffe-6e98-4864-9599-4133236eea7a",    -- LOUD Unit Additions          (VEB2302)
}

-- Siehe doc.claude\02_MODSYSTEM.md Abschnitt 5.
