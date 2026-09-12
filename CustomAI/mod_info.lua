-- ============================================================================
-- Custom AI
--
-- Ordner:   C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\
-- VFS-Pfad: /mods/customai/
-- Doku:     doc.claude\mods\CustomAI.md
--
-- Vorlage - noch ohne Inhalt.
--
-- Registrierung der KI erfolgt ueber
--   lua\AI\CustomAIs_v2\<name>.lua   (in DIESEM Modordner, nicht im Spielordner)
-- Das ist der einzige AI-Erweiterungspunkt, den die Engine ausdruecklich
-- pro Mod durchsucht - enhancedlobby.lua, GetAIList(), Zeile 248.
-- ============================================================================

name        = "Custom AI"
version     = 1.0
description = "Zusaetzliche KI-Gegner zur Auswahl in der Lobby."
author      = "Paul"
copyright   = "none"

-- Mod-Bild im Mod-Manager. Der Wert geht unveraendert an Bitmap:SetTexture()
-- (modmanager.lua Z. 1131 und 1365). Darstellung 36x36 in der Liste,
-- 70x70 in der Detailansicht - deshalb quadratisch zuschneiden.
icon = "/mods/customai/customai.png"

-- PFLICHT. Ohne diese Angabe waere die uid der volle Dateipfad
-- (mods.lua, LoadModInfo, Zeile 239) - dann aendert sie sich beim Umbenennen
-- des Ordners und der Mod ist nicht referenzierbar.
uid = "72568B0A-993B-49D4-B2AB-55E68B5C3BE5"

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
