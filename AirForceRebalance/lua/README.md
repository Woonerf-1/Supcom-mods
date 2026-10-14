# AirForceRebalance - lua\

| Datei | Quelle in `LOUD\gamedata.entpackt\` | enthaelt | benutzt von |
|---|---|---|---|
| `4D_weapons.lua` | `4D-CompatibilityPack\mods\4DC\lua\` | `ArrowMissileWeapon`, `LaserPhalanxWeapon` | `units\UAL0310\UAL0310_script.lua` |
| `4D_projectiles.lua` | ebenda | `ArrowMissileProjectile` | `projectiles\ArrowMissile\` |
| `CustomUnits\AirForceRebalance.lua` | neu, Eintraege aus `BREW_Units.lua`, `BO_AirUnits.lua`, `BO_LandUnits.lua`, `4D_Custom Units.lua` | KI-Registrierung der Paketeinheiten | `loudutilities.lua` Z. 2670 ff. |

Klassenrumpfe wortgleich aus 4DC, nur auf das Benoetigte gekuerzt. Damit haengt der Mod
nicht am 4DC-Paket, das per `conflicts` ausgeschlossen ist.
