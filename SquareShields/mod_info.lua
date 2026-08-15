-- ============================================================================
-- SquareShields
--
-- Ordner:   C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\SquareShields\
-- VFS-Pfad: /mods/squareshields/
-- Doku:     doc.claude\mods\SquareShields.md
--
-- Extrakt aus "LOUD Unit Additions": nur die vier Squareshields der Stufe 01,
-- ohne Aufstieg auf die Stufe 02 und ohne die uebrigen 22 Einheiten des Pakets.
-- ============================================================================

name        = "SquareShields"
version     = 1.0
description = "Bee there Orr Bee A Rectangular Thyng - CMOT Dibbler"
author      = "Colin"
copyright   = "none"

-- PFLICHT. Ohne diese Angabe waere die uid der volle Dateipfad
-- (mods.lua, LoadModInfo, Zeile 239) - dann aendert sie sich beim Umbenennen
-- des Ordners und der Mod ist nicht referenzierbar.
uid = "D5F66739-FD09-4166-8D73-A5D496772B7C"

selectable = true
enabled    = true
exclusive  = false
ui_only    = false

hookdir   = '/hook'
shadowdir = '/shadow'

-- Beide Mods liefern uabssg01, uebssg01, urbssg01 und xsbssg01 als Vollblueprint.
-- Gleichzeitig aktiv waere die Reihenfolge unbestimmt (mods.lua ModComp faellt auf
-- den alphabetischen uid-Vergleich zurueck). Deshalb harte Sperre.
-- conflicts wirkt in beide Richtungen - es genuegt, dass EIN Mod den anderen nennt
-- (mods.lua, GetDependencies, Zeile 396 ff.).
conflicts = {
    "fffffffe-6e98-4864-9599-4133236eea7a",   -- LOUD Unit Additions
}

-- requiresNames waere hier wirkungslos: die Tabelle ordnet ausschliesslich uids aus
-- 'requires' einen Klartextnamen zu, damit die Meldung ueber einen FEHLENDEN Mod
-- lesbar ist (mods.lua Zeile 86-91). Fuer 'conflicts' wird sie nicht gelesen.

-- Keine weiteren Abhaengigkeiten. Falls spaeter noetig:
--   requires  = { "<uid>" }   -- Mod muss vorhanden sein  (regelt KEINE Reihenfolge)
--   before    = { "<uid>" }   -- dieser Mod wird VOR dem genannten angewandt
--   after     = { "<uid>" }   -- ... NACH dem genannten
-- Siehe doc.claude\02_MODSYSTEM.md Abschnitt 5.
