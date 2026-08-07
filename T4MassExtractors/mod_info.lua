-- ============================================================================
-- T4 Mass Extractors
--
-- Ordner:   C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\T4MassExtractors\
-- VFS-Pfad: /mods/t4massextractors/
-- Doku:     doc.claude\mods\T4MassExtractors.md
--
-- Vorlage - noch ohne Inhalt.
-- ============================================================================

name        = "T4 Mass Extractors"
version     = 1.0
description = "Fuegt Massextraktoren der Experimental-Stufe hinzu."
author      = "Paul"
copyright   = "none"

-- PFLICHT. Ohne diese Angabe waere die uid der volle Dateipfad
-- (mods.lua, LoadModInfo, Zeile 239) - dann aendert sie sich beim Umbenennen
-- des Ordners und der Mod ist nicht referenzierbar.
uid = "F778CB9A-FA72-413F-99A1-80AE74CFE37B"

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
