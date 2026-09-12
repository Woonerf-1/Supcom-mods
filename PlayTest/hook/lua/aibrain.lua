-- PlayTest - Debug-Schalter. NUR FUER TESTPARTIEN.
-- Erlaeuterung: siehe hooks.md

ScenarioInfo.MMDialog = true

LOG('MM: Debug-Ausgaben unserer Mods sind AN (ScenarioInfo.MMDialog)')


if not ScenarioInfo.norushradius then

    ScenarioInfo.norushradius = 0

    LOG('MM: ScenarioInfo.norushradius war nicht gesetzt - auf 0 gesetzt')
end


-- LOUD-eigene Schalter, einzeln einkommentieren.
-- Vollstaendige Liste: gamedata\lua\lua\aibrain.lua ab Z. 185

--ScenarioInfo.IntelDialog            = true
--ScenarioInfo.UnitDialog             = true
--ScenarioInfo.BuffDialog             = true
--ScenarioInfo.ShieldDialog           = true
--ScenarioInfo.StructureUpgradeDialog = true
--ScenarioInfo.EngineerDialog         = true
--ScenarioInfo.PlatoonDialog          = true

-- im LOUD-Quelltext als "VERY COSTLY" gekennzeichnet
--ScenarioInfo.ProjectileDialog       = true
--ScenarioInfo.WeaponDialog           = true
--ScenarioInfo.WeaponStateDialog      = true
