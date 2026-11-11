-- Faction Template: StarCraft
-- Lobby-only template: adds the factions Zerg, Protoss, Terran to the faction list of the lobby.
-- No units, no game hooks - selecting one of these factions and launching a game does not work.
-- Replace the PNG files under textures\ with your own icons (same names, same sizes).

name        = "Faction Template: StarCraft"
version     = 1
description = "Template for Custom Factions: makes Zerg, Protoss, Terran selectable in the lobby. Icons and names only, not playable."
author      = ""
copyright   = ""
icon        = "/mods/factiontemplate_starcraft/mod_icon.png"
uid         = "E7112B35-0BDF-43D0-BA05-EB93CAD3F050"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

-- front-end hooks, applied by Custom Factions in the main menu and the lobby
frontend_hookdir = '/hook_frontend'

requires      = { 'custom-factions' }
requiresNames = { ['custom-factions'] = 'Custom Factions' }