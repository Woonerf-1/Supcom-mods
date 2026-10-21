-- ============================================================================
-- AdjacencyRebalance
--
-- Ordner:   LOUD\usermods\AdjacencyRebalance\
-- VFS-Pfad: /mods/adjacencyrebalance/
-- Doku:     doc.claude\mods\AdjacencyRebalance.md
--
-- Herausgeloest aus nomads-4-loud (shadow\lua\sim\AdjacencyBuffs.lua): staerkere
-- Nachbarschaftsboni der Energie- und Experimental-Speicher. Nur die 24
-- geaenderten Werte, per Hook - kein Vollersatz der LOUD-Datei.
-- ============================================================================

name        = "Adjacency Rebalance"
version     = 1.0
description = "Staerkere Nachbarschaftsboni fuer Energiespeicher T1-T3 und Experimental-Speicher (Energie- und Masseproduktion, Schildleben, Schildregeneration). Werte aus Nomads for LOUD."
author      = "Nomads for LOUD"
copyright   = "none"

-- Bausymbol des UEF-Energiespeichers T3 (UEB3105), liegt in LOUDs Texturen.
icon = "/textures/ui/common/icons/units/UEB3105_icon.dds"

uid = "1F3048D7-78B5-476D-8EFE-D5EA42111D9E"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'

conflicts = {}

-- Siehe doc.claude\02_MODSYSTEM.md Abschnitt 5.
