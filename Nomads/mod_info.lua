-- ============================================================================
-- Nomads
--
-- Ordner:   LOUD\usermods\Nomads\
-- VFS-Pfad: /mods/nomads/
-- Doku:     doc.claude\mods\Nomads.md
--
-- Neuaufbau der Nomads-Fraktion aus nomads-4-loud (archiviert in doc.claude\_Altlasten).
-- Stand 2026-10-22: vollstaendig (Fraktion, Einheiten, Skin, Faehigkeiten, Texte), im Spiel ungetestet.
-- Fraktionsneutrales (Vorlagen, KI-Vorlagen, Sprueche ...) liefert Custom Factions.
-- ============================================================================

name        = "Nomads"
version     = 0.1
description = "Nomads-Fraktion fuer LOUD (benoetigt Custom Factions)."
author      = "Nomads for LOUD"
copyright   = "none"

-- Abzeichen aus dem Fraktions-Logo (textures\particles\nomadslogo.dds, 442 x 494): Goldverlauf auf dunklem
-- Sechseck mit Goldrand, 64 x 64 A8R8G8B8 unkomprimiert (Mod-Manager zeigt 36 x 36, modmanager.lua Z. 795).
icon = "/mods/nomads/Nomads.dds"

uid = "B1CD51F1-6724-40D6-9B2B-639E24AB11DF"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'

-- Front-End- und Lobby-Hooks; angewendet von Custom Factions (schook/lua/userInit.lua).
frontend_hookdir = '/hook_frontend'

-- Custom Factions liefert den Front-End-Bootstrap und den Eintrag "Zufall".
-- uid bestaetigt: LOUD.log 2026-10-22 01:00, Mod-Liste 'Custom Factions (custom-factions)'.
requires      = { 'custom-factions' }
requiresNames = { ['custom-factions'] = 'Custom Factions' }

-- Kein conflicts gegen nomads-4-loud (Paul, 2026-10-22).
conflicts = {}

-- Siehe doc.claude\02_MODSYSTEM.md Abschnitt 5.
