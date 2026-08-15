-- ============================================================================
-- ImprovedHydrocarbonPowerPlants
--
-- Ordner:   C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\ImprovedHydrocarbonPowerPlants\
-- VFS-Pfad: /mods/improvedhydrocarbonpowerplants/
-- Doku:     doc.claude\mods\ImprovedHydrocarbonPowerPlants.md
--
-- Bis 2026-08-15 hiess der Ordner "HCPP" und der Mod "MoreHydro".
--
-- Acht verbesserte Hydrocarbon-Kraftwerke (T2 und T3 fuer vier Fraktionen),
-- Herkunft: BlackOpsUnleashed.
-- ============================================================================

name        = "Improved Hydrocarbon PowerPlants"
version     = 1.0
description = "Fuegt erweiterte Hydrocarbon-Kraftwerke der Stufen 2 und 3 fuer alle vier Fraktionen hinzu (Herkunft: BlackOpsUnleashed)"
author      = "Colin"
copyright   = "none"

-- Mod-Bild im Mod-Manager. Der Wert wird unveraendert an Bitmap:SetTexture()
-- gereicht (modmanager.lua Z. 1131 und 1365), ist also ein reiner VFS-Pfad -
-- keine Datei im Mod noetig. Verwendet wird das Bausymbol der UEF-Stufe 3.
-- Darstellung: 36x36 in der Liste, 70x70 in der Detailansicht.
icon = "/textures/ui/common/icons/units/BEB1302_icon.dds"

-- PFLICHT. Ohne diese Angabe waere die uid der volle Dateipfad
-- (mods.lua, LoadModInfo, Zeile 239) - dann aendert sie sich beim Umbenennen
-- des Ordners und der Mod ist nicht referenzierbar.
uid = "AD88F006-304B-42E6-8612-E63918A7BE22"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'

-- Beide Mods liefern beb1202/1302, bab1202/1302, brb1202/1302 und bsb1202/1302 als
-- Vollblueprint. Gleichzeitig aktiv waere die Reihenfolge unbestimmt (mods.lua ModComp
-- faellt auf den alphabetischen uid-Vergleich zurueck). Deshalb harte Sperre.
-- conflicts wirkt in beide Richtungen - es genuegt, dass EIN Mod den anderen nennt
-- (mods.lua, GetDependencies, Zeile 396 ff.).
conflicts = {
    "9e8ea941-c306-4751-b367-a11000000502",   -- BlackOps Unleashed Units for LOUD
}

-- Keine weiteren Abhaengigkeiten. Falls spaeter noetig:
--   requires  = { "<uid>" }   -- Mod muss vorhanden sein  (regelt KEINE Reihenfolge)
--   before    = { "<uid>" }   -- dieser Mod wird VOR dem genannten angewandt
--   after     = { "<uid>" }   -- ... NACH dem genannten
-- Siehe doc.claude\02_MODSYSTEM.md Abschnitt 5.
