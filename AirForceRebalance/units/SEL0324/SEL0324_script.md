# SEL0324 NG3 Longbow - Script

Grundlage: Colins Fassung aus `UEF_trans_men` (billige Flak mit optionalem Ausbau
"Omni Sensor", Radar 150 / Omni 70 fuer 750 Energie/s). Colins Kommentar dort: "THIS IS
THE FIX". Repariert am 2026-10-14 (Entscheidung Paul).

## Was in Colins Fassung nicht lief

| Stelle (UTM) | Fehler | jetzt |
|---|---|---|
| Z. 90, 107, 117 | `SetMaintenanceConsumptionPerSecondEnergy` existiert nicht - weder in LOUD noch in der Engine-Methodenliste `Repos\FAF\engine\Sim\Unit.lua`. Haette bei **jedem** Abschalten des Radars einen Lua-Fehler ausgeloest | Verbrauch nur noch ueber `SetEnergyMaintenanceConsumptionOverride` und `SetMaintenanceConsumption(In)Active`, wie in LOUD (`defaultunits.lua` Z. 412 ff.) |
| Z. 93 | `Buff.ApplyBuff(self, 'ACU_T2_Intel_Package')` - `Buff` nicht importiert, und der Buff ist der Intel-Ausbau des **ACU** | beim Entfernen des Ausbaus werden die gespeicherten Grundradien zurueckgesetzt |
| `OnStopBeingBuilt` | `RadarThread` wurde nie gestartet (Radar-Animation tot), Intel-Schalter nicht gesetzt | wie BrewLAN: Schalter setzen, `RadarThread` starten, Sperre "INTEL" beachten |
| `TransportAnimation` | entfernt - Radar lief im Transport weiter | aus BrewLAN uebernommen, stellt beim Ausladen den **aktuellen** Radius (mit oder ohne Ausbau) wieder her |

## Bekannte Grenze

Die Ausbau-Effekte verweisen auf Knochen `Back_Upgrade`, `Left_Arm_B01`,
`Right_Arm_B01`, die das Modell nicht hat (aus einem Kommandanten-Ausbau kopiert).
LOUD prueft jeden Knochen mit `IsValidBone` (`sim\Unit.lua` Z. 3908-3985) - kein Absturz,
nur keine sichtbaren Ausbau-Effekte.
