-- ============================================================================
-- DynamicGameplay
--
-- Ordner:   C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\DynamicGameplay\
-- VFS-Pfad: /mods/dynamicgameplay/
-- Doku:     doc.claude\mods\DynamicGameplay.md
--
-- Bis 2026-08-15 hiess der Ordner "dynamic_gameplay".
--
-- Extrakt aus zwei LOUD-eigenen Paketen:
--   SEB3404 (Panopticon) und SRB4402 (Darkness)  aus BrewLAN_LOUD
--   BSL0005 (Hala Othuum) und BSB2402 (Rift Gate) aus BlackOpsUnleashed
-- ============================================================================

name        = "Dynamic Gameplay"
version     = 1.0
description = "Vier Experimentaleinheiten fuer mehr Bewegung im Spiel: Aufklaerungsanlage, Omni-Stoersender, Elite-Belagerungspanzer und Quantentor (Herkunft: BrewLAN, BlackOps)"
author      = "Colin"
copyright   = "none"

-- Mod-Bild im Mod-Manager. Der Wert wird unveraendert an Bitmap:SetTexture()
-- gereicht (modmanager.lua Z. 1131 und 1365), ist also ein reiner VFS-Pfad -
-- keine Datei im Mod noetig. Verwendet wird das Bausymbol des Panopticon.
-- Geprueft: gamedata.entpackt\textures\textures\ui\common\icons\units\SEB3404_icon.dds
icon = "/textures/ui/common/icons/units/SEB3404_icon.dds"

-- PFLICHT. Ohne diese Angabe waere die uid der volle Dateipfad
-- (mods.lua, LoadModInfo, Zeile 239) - dann aendert sie sich beim Umbenennen
-- des Ordners und der Mod ist nicht referenzierbar.
uid = "8837F2BC-7C07-4CCF-8F80-34F545858442"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'

-- Beide Quellpakete liefern dieselben Blueprint-IDs als Vollblueprint.
-- Gleichzeitig aktiv waere die Reihenfolge unbestimmt (mods.lua ModComp faellt
-- auf den alphabetischen uid-Vergleich zurueck). Deshalb harte Sperre.
-- conflicts wirkt in beide Richtungen - es genuegt, dass EIN Mod den anderen
-- nennt (mods.lua, GetDependencies, Zeile 396 ff.).
conflicts = {
    "25D57D85-7D84-27HT-A501-BR3WL4N000079",   -- BrewLAN for LOUD  (SEB3404, SRB4402)
    "9e8ea941-c306-4751-b367-a11000000502",    -- BlackOps Unleashed (BSL0005, BSB2402)
}

-- Keine weiteren Abhaengigkeiten. Falls spaeter noetig:
--   requires  = { "<uid>" }   -- Mod muss vorhanden sein  (regelt KEINE Reihenfolge)
--   before    = { "<uid>" }   -- dieser Mod wird VOR dem genannten angewandt
--   after     = { "<uid>" }   -- ... NACH dem genannten
-- Siehe doc.claude\02_MODSYSTEM.md Abschnitt 5.
