# TacticalMissileUpgrades - lua\

| Datei | Quelle | enthaelt | benutzt von |
|---|---|---|---|
| `BlackOps_projectiles.lua` | `LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\lua\BlackOpsprojectiles.lua` Z. 356-364, `...\BlackOpsEffectTemplates.lua` Z. 10-20 | `MIRVChild01Projectile` (Teilgeschoss der Purifier) mit Treffereffekt `Aeon_MirvHit` | `projectiles\MirvSerpentineVChild01\MirvSerpentineVChild01_script.lua` |
| `CustomUnits\TacticalMissileUpgrades.lua` | `...\BlackOpsUnleashed\lua\CustomUnits\BO_Buildings.lua` Z. 26-28, `LOUD\gamedata.entpackt\WyvernBattlePack\mods\BattlePack\lua\CustomUnits\Wyvern_Units.lua` Z. 4 | KI-Eintraege fuer Purger und Protector | LOUD-KI |

Wortgleich, nur gekuerzt; Effektpfade zeigen auf `effects\Emitters\` dieses Mods (9 Dateien,
unveraendert aus BlackOps). Die Purifier steht auch bei BlackOps nicht in der KI-Liste
(dort auskommentiert, `BO_Buildings.lua` Z. 55-59).
