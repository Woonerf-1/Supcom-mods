# T4UnitAdditions - lua\

Auszuege aus drei LOUD-Paketen. Enthalten ist **nur, was die Einheiten dieses Mods
tatsaechlich benutzen** (gekuerzt 2026-10-14). Die vollstaendigen Fassungen liegen unter
`doc.claude\_Altlasten\T4UnitAdditions\lua\*.vollstaendig`.

| Datei | Quelle in `LOUD\gamedata.entpackt\` | enthaelt | benutzt von |
|---|---|---|---|
| `BlackOpsweapons.lua` | `blackops\mods\BlackOpsUnleashed\lua\` | `CitadelHVMWeapon`, `CitadelPlasmaGatlingCannonWeapon`, `RailGunWeapon02` | `MKT0409_script.lua` |
| `BlackOpsprojectiles.lua` | ebenda | `RailGun01Projectile` | `projectiles\RailGun01\` |
| `BlackOpsEffectTemplates.lua` | ebenda | `JuggPlasmaGatlingCannon*`, `RailGun*`, `UnitHitShrapnel01` | die beiden oberen |
| `BattlePackprojectiles.lua` | `WyvernBattlePack\mods\BattlePack\lua\` | `NapalmMissile` | `projectiles\BPNapalmMissile\` |
| `4D_projectiles.lua` | `4D-CompatibilityPack\mods\4DC\lua\` | `Over_ChargeProjectile` | `projectiles\over_charge\` |
| `CustomUnits\T4UnitAdditions.lua` | neu, Eintraege aus den Quellpaketen | KI-Registrierung | `loudutilities.lua` Z. 2670 ff. |

Klassenrumpfe unveraendert aus der Quelle; geaendert sind nur Importpfade
(`/mods/BlackOpsUnleashed/` usw. -> `/mods/t4unitadditions/`). Einzige inhaltliche Kuerzung:
`CitadelHVMWeapon` ohne den auskommentierten Block (BlackOps Z. 190-308).

Wer eine weitere Klasse braucht: aus der `.vollstaendig`-Fassung holen und ihre
Abhaengigkeiten (Templates, Emitter unter `effects\Emitters\`) mitnehmen.
