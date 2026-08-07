-- ============================================================================
-- Basegame Bugfixes
--
-- Ordner:   C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\BasegameBugfixes\
-- VFS-Pfad: /mods/basegamebugfixes/
-- Doku:     doc.claude\mods\BasegameBugfixes.md
--
-- Vorlage - noch ohne Inhalt.
-- ============================================================================

name        = "Basegame Bugfixes"
version     = 1.0
description = "Behebt Fehler in den Basiseinheiten des Spiels."
author      = "Paul"
copyright   = "none"

-- PFLICHT. Ohne diese Angabe waere die uid der volle Dateipfad
-- (mods.lua, LoadModInfo, Zeile 239) - dann aendert sie sich beim Umbenennen
-- des Ordners und der Mod ist nicht referenzierbar.
uid = "EFD7502E-1682-4DC2-BBA7-CC4243E74B71"

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
