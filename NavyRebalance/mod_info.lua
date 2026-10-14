-- ============================================================================
-- NavyRebalance
--
-- Ordner:   LOUD\usermods\NavyRebalance\
-- VFS-Pfad: /mods/navyrebalance/
-- Doku:     doc.claude\mods\NavyRebalance.md
--
-- Extrakt aus UEF_trans_men: Colins Marine-Rebalancing. Basiseinheiten als
-- Merge, Paketeinheiten (BattlePack, BrewLAN, 4DC) als Kopie.
-- ============================================================================

name        = "Navy Rebalance"
version     = 1.0
description = "Marine-Rebalancing von Colin: U-Boote, Raketen-U-Boote, U-Jagd, Traeger, Torpedoboot, Seefestung, Reparaturschiff und Seemine, 14 Einheiten aller Fraktionen. Quellen: Basisspiel, BattlePack, BrewLAN, 4DC."
author      = "Colin"
copyright   = "none"

-- Bausymbol der Atlantis (UES0401), liegt in LOUDs Texturen.
icon = "/textures/ui/common/icons/units/UES0401_icon.dds"

uid = "169A779C-26F9-4C48-8E3F-A66EC806F33A"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'

-- Die Pakete liefern dieselben IDs als Vollblueprint.
-- conflicts wirkt in beide Richtungen (mods.lua, GetDependencies, Zeile 396 ff.).
conflicts = {
    "9a9C61C0-1787-10DF-A0AD-BATTLEPACK002",   -- Wyvern Battle Pack for LOUD  (WEB0404)
    "25D57D85-7D84-27HT-A501-BR3WL4N000079",   -- BrewLAN for LOUD             (SES0319)
    "454af309-5afb-458b-bf5b-a00000000007",    -- 4th Dimension Units for LOUD (UES0206)
}

-- Siehe doc.claude\02_MODSYSTEM.md Abschnitt 5.
