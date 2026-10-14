-- ============================================================================
-- TacticalMissileUpgrades
--
-- Ordner:   LOUD\usermods\TacticalMissileUpgrades\
-- VFS-Pfad: /mods/tacticalmissileupgrades/
-- Doku:     doc.claude\mods\TacticalMissileUpgrades.md
--
-- Extrakt aus UEF_trans_men: Colins Ausbauketten fuer taktische Raketenwerfer
-- und Raketenabwehr. Basiseinheiten als Merge, Ausbaustufen als Kopie.
-- ============================================================================

name        = "Tactical Missile Upgrades"
version     = 1.0
description = "Ausbauketten von Colin: Serpentine -> Purifier (Aeon-Raketenwerfer), Volcano -> Purger (Aeon-Raketenabwehr), Buzzkill -> Protector (UEF-Raketenabwehr). Quellen: Basisspiel, BlackOps, BattlePack."
author      = "Colin"
copyright   = "none"

-- Bausymbol der Purifier (BAB2308), liegt in LOUDs Texturen.
icon = "/textures/ui/common/icons/units/BAB2308_icon.dds"

uid = "D1FA8784-0E8B-4F25-9578-AF5B0E3D23CC"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'

-- Die Pakete liefern dieselben IDs als Vollblueprint.
-- conflicts wirkt in beide Richtungen (mods.lua, GetDependencies, Zeile 396 ff.).
conflicts = {
    "9e8ea941-c306-4751-b367-a11000000502",    -- BlackOps Unleashed for LOUD  (BAB2308, BAB4307)
    "9a9C61C0-1787-10DF-A0AD-BATTLEPACK002",   -- Wyvern Battle Pack for LOUD  (WEB4301)
}

-- Siehe doc.claude\02_MODSYSTEM.md Abschnitt 5.