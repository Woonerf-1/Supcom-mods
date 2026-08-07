-- ============================================================================
-- PlayTest
--
-- Ordner:   C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\PlayTest\
-- VFS-Pfad: /mods/playtest/
-- Doku:     doc.claude\mods\PlayTest.md
--
-- Vorlage - noch ohne Inhalt.
-- ============================================================================

name        = "PlayTest"
version     = 1.0
description = "Testmod zum Ausprobieren. Nicht fuer den regulaeren Spielbetrieb."
author      = "Paul"
copyright   = "none"

-- PFLICHT. Ohne diese Angabe waere die uid der volle Dateipfad
-- (mods.lua, LoadModInfo, Zeile 239) - dann aendert sie sich beim Umbenennen
-- des Ordners und der Mod ist nicht referenzierbar.
uid = "3786F645-B959-44F1-9C52-E3B3C5CA09AA"

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
