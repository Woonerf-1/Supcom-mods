-- ============================================================================
-- AirForceRebalance
--
-- Ordner:   LOUD\usermods\AirForceRebalance\
-- VFS-Pfad: /mods/airforcerebalance/
-- Doku:     doc.claude\mods\AirForceRebalance.md
--
-- Extrakt aus UEF_trans_men: Colins Luftwaffen-Rebalancing (22 Flugzeuge) plus
-- vier Flugabwehr-Einheiten. Basiseinheiten als Merge, Paketeinheiten als Kopie.
-- ============================================================================

name        = "Air Force Rebalance"
version     = 1.0
description = "Luftwaffen-Rebalancing von Colin: Jaeger, Torpedobomber, Gunships, Penetration Fighter, Sonderflugzeuge und Flugabwehr, 26 Einheiten aller Fraktionen. Quellen: Basisspiel, BrewLAN, BlackOps, 4DC."
author      = "Colin"
copyright   = "none"

-- Bausymbol des Tomcat (SEA0313), liegt in LOUDs textures.scd.
icon = "/textures/ui/common/icons/units/SEA0313_icon.dds"

uid = "58FA781C-DB8D-4060-BABF-26248D292D6C"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'

-- Die drei Pakete liefern dieselben IDs als Vollblueprint.
-- conflicts wirkt in beide Richtungen (mods.lua, GetDependencies, Zeile 396 ff.).
conflicts = {
    "25D57D85-7D84-27HT-A501-BR3WL4N000079",   -- BrewLAN for LOUD             (10 Einheiten)
    "9e8ea941-c306-4751-b367-a11000000502",    -- BlackOps Unleashed           (BSA0310, BSLK004)
    "454af309-5afb-458b-bf5b-a00000000007",    -- 4th Dimension Units for LOUD (UAL0310)
}

-- Siehe doc.claude\02_MODSYSTEM.md Abschnitt 5.
