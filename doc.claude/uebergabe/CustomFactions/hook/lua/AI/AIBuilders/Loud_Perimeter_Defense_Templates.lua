-- Custom Factions: KI-Basis-Layouts fuer Fraktionen ab Index 5. Siehe README.md (Abschnitt Layouts).
-- LOUDs Layout-Tabellen haben genau 4 Eintraege und werden mit [factionIndex] gelesen (platoon.lua Z. 7301/7805/7962).
-- Sie nennen Gebaeude-Typen ('T1LandFactory' ...), keine IDs; die IDs kommen aus BuildingTemplates. Eine Zusatzfraktion
-- nutzt daher das Layout einer LOUD-Fraktion: Feld LayoutFallback im Fraktionseintrag (Vorgabe 1 = UEF).
do
    for _, name in { 'PerimeterDefenseTemplates', 'NavalPerimeterDefenseTemplate', 'PerimeterDefenseExpansionTemplates' } do
        local t = getfenv(1)[name]
        if type(t) == 'table' then
            for index, faction in import('/lua/factions.lua').Factions do
                if index > 4 and t[index] == nil then
                    t[index] = t[faction.LayoutFallback or 1]
                end
            end
        end
    end
end