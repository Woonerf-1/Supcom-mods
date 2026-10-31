-- ============================================================================
-- EnhancedPauseBehavior
--
-- Ordner:   LOUD\usermods\EnhancedPauseBehavior\
-- VFS-Pfad: /mods/enhancedpausebehavior/
-- Doku:     EnhancedPauseBehavior.md (neben dieser Datei)
--
-- Fortsetzen nach einer Pause nur mit Bereit-Abfrage aller menschlichen
-- Spieler und anschliessendem Countdown. Nur UI-Lua, keine Sim-Dateien.
-- ============================================================================

name        = "Enhanced Pause Behavior"
version     = 1.0
description = "Multiplayer: resuming a paused game requires all human players to be ready, followed by a countdown. Changes nothing else in the game."
author      = "Paul"
copyright   = "none"

-- Mod-Bild im Mod-Manager, 256x256 PNG wie PlayTest/CustomAI/CorrosiveOcean.
-- Der Wert geht unveraendert an Bitmap:SetTexture() (modmanager.lua).
icon = "/mods/enhancedpausebehavior/enhancedpausebehavior.png"

uid = "E9410707-B979-462F-B9E8-3DDB886DB31B"

selectable = true
enabled    = true
exclusive  = false

-- Absichtlich false, obwohl der Mod nur UI-Lua enthaelt: nur Game-Mods
-- gehen ueber gameInfo.GameMods an alle Clients, die Lobby prueft sie
-- (lobby.lua CheckIfHaveMods). Die Bereit-Abfrage braucht den Mod bei allen.
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'
