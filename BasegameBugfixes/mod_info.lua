-- ============================================================================
-- BasegameBugfixes
--
-- Ordner:   LOUD\usermods\BasegameBugfixes\
-- VFS-Pfad: /mods/basegamebugfixes/
-- Doku:     doc.claude\mods\BasegameBugfixes.md
--
-- Behebt Fehler in LOUDs eigenem Code und Basismaterial. Je Fehler eine
-- Fundstelle B-xx in der Doku. Keine Balance-Aenderungen.
-- ============================================================================

name        = "Basegame Bugfixes"
version     = 1.0
description = "Behebt Fehler in LOUDs eigenem Code. Derzeit: unsichtbare Fatboys bei sehr schnellem Bau (B-04)."
author      = "Paul"
copyright   = "none"

-- Reparatur-Befehlssymbol aus dem Basisspiel (textures.scd), reiner VFS-Pfad.
icon = "/textures/ui/common/game/orders/repair_btn_up.dds"

-- Neue GUID. Die in der Doku frueher vorgesehene uid EFD7502E-... traegt
-- inzwischen BasegameRevamp.
uid = "4046F209-C6D2-4881-BACF-E434940CDACA"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'

-- Siehe doc.claude\02_MODSYSTEM.md Abschnitt 5.
