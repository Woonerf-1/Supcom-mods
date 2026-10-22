-- Lobby-Einheitenbeschraenkung "keine Nomads", siehe doc.claude\mods\Nomads.md.
-- LOUD liest lua/CustomUnitRestrictions/*.lua aktiver Mods (enhancedlobby.lua Z. 109-125) und uebernimmt
-- UnitRestrictions[Schluessel]. Ersetzt den FAF-Hook UnitsRestrictions.lua der Quelle (in LOUD nicht vorhanden).
UnitRestrictions = {
    NOMADS = {
        categories = {"NOMADS"},
        name = "No Nomads",
        tooltip = "restricted_units_nomads",
    },
}