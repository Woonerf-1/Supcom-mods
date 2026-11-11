-- Faction Template: Warhammer 40K
-- Lobby-only template: adds the factions Imperium, Orks, Eldar, Necrons, Tyranids, Chaos to the faction list of the lobby.
-- No units, no game hooks - selecting one of these factions and launching a game does not work.
-- Replace the PNG files under textures\ with your own icons (same names, same sizes).

name        = "Faction Template: Warhammer 40K"
version     = 1
description = "Template for Custom Factions: makes Imperium, Orks, Eldar, Necrons, Tyranids, Chaos selectable in the lobby. Icons and names only, not playable."
author      = ""
copyright   = ""
icon        = "/mods/factiontemplate_w40k/mod_icon.png"
uid         = "468E37CB-22BA-4199-BCDF-0EB47AC4CA8B"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

-- front-end hooks, applied by Custom Factions in the main menu and the lobby
frontend_hookdir = '/hook_frontend'

requires      = { 'custom-factions' }
requiresNames = { ['custom-factions'] = 'Custom Factions' }