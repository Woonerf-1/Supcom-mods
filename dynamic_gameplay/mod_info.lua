-- ============================================================================
-- dynamic_gameplay
--
-- Ordner:   C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\dynamic_gameplay\
-- VFS-Pfad: /mods/dynamic_gameplay/
-- Doku:     doc.claude\mods\dynamic_gameplay.md
--
-- Vorlage - noch ohne Inhalt.
-- ============================================================================

name        = "Dynamic Gameplay"
version     = 1.0
description = "Adds more dynamic gameplay options in the shape of experimental units"
author      = "Colin"
copyright   = "none"

-- PFLICHT. Ohne diese Angabe waere die uid der volle Dateipfad
-- (mods.lua, LoadModInfo, Zeile 239) - dann aendert sie sich beim Umbenennen
-- des Ordners und der Mod ist nicht referenzierbar.
uid = "Dynamic_gameplay_Version01"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'

-- Keine Abhaengigkeiten. Falls spaeter noetig:
--   requires  = { "<uid>" }   -- Mod muss vorhanden sein  (regelt KEINE Reihenfolge)
--   conflicts = { "<uid>" }   -- Mod darf nicht gleichzeitig aktiv sein
--   before    = { "<uid>" }   -- dieser Mod wird VOR dem genannten angewandt
--   after     = { "<uid>" }   -- ... NACH dem genannten
-- Siehe doc.claude\02_MODSYSTEM.md Abschnitt 5.
