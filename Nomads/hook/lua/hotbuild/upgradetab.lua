-- Nomads: Ausbau per Tastenkuerzel (Hotbuild), siehe doc.claude\mods\Nomads.md (Abschnitt Hooks).
-- LOUD erwartet Zeichenketten (lua/hotbuild/upgradetab.lua); Werte aus UpgradesTo der Nomads-Blueprints.
-- Nicht aufgenommen: xnb1102 -> cnb1202 -> cnb1302 (Hydrocarbon). LOUDs Tabelle fuehrt fuer keine Fraktion einen Hydrocarbon-Ausbau,
-- auch nicht ueb1102 -> beb1202 (lua/hotbuild/upgradetab.lua); Nomads bekommt nicht mehr als die anderen.

upgradeTab['xnb0101'] = 'znb9501'
upgradeTab['xnb0102'] = 'znb9502'
upgradeTab['xnb0103'] = 'znb9503'
upgradeTab['znb9501'] = 'znb9601'
upgradeTab['znb9502'] = 'znb9602'
upgradeTab['znb9503'] = 'znb9603'
upgradeTab['xnb1103'] = 'xnb1202'
upgradeTab['xnb1202'] = 'xnb1302'
upgradeTab['xnb1105'] = 'xnb2105'
upgradeTab['xnb2105'] = 'xnb3105'
upgradeTab['xnb1106'] = 'xnb2106'
upgradeTab['xnb2106'] = 'xnb3106'
upgradeTab['xnb3101'] = 'xnb3201'
upgradeTab['xnb3201'] = 'xnb3301'
upgradeTab['xnb3102'] = 'xnb3202'
upgradeTab['xnb3202'] = 'xnb3302'
upgradeTab['xnb4202'] = 'xnb4205'
upgradeTab['xnb4205'] = 'xnb4301'
upgradeTab['xnb4301'] = 'xnb4305'
