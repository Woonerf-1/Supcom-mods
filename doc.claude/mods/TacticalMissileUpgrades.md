# Mod: TacticalMissileUpgrades

| | |
|---|---|
| **Ordner** | `LOUD\usermods\TacticalMissileUpgrades\` |
| **VFS-Pfad** | `/mods/tacticalmissileupgrades/` |
| **Anzeigename** | Tactical Missile Upgrades |
| **uid** | `D1FA8784-0E8B-4F25-9578-AF5B0E3D23CC` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Autor** | Colin (Idee und Werte), Extrakt und Korrekturen 2026-10-14 |
| **Icon** | `/textures/ui/common/icons/units/BAB2308_icon.dds` - Bausymbol der Purifier (LOUD-Texturen) |
| **Status** | **angelegt 2026-10-14, im Spiel ungeprueft** |
| **Umfang** | 6 Einheiten, 48 Dateien, 5,4 MB |

Uebergeordnet: [18_ABLEITUNG.md](../18_ABLEITUNG.md). Alle Pfade relativ zu `$FA`.

---

## 1. Zweck

Siebter Extrakt aus Colins Sammelmod `UEF_trans_men`: drei T2-Gebaeude lassen sich an Ort
und Stelle zur staerkeren Stufe ausbauen, wie Massenextraktoren.

| Basis (T2, Basisspiel) | Ausbau | Fraktion | Was |
|---|---|---|---|
| UAB2108 Serpentine | BAB2308 Purifier (BlackOps) | Aeon | taktischer Raketenwerfer; Purifier-Rakete teilt sich ueber dem Ziel |
| UAB4201 Volcano | BAB4307 Purger (BlackOps) | Aeon | Raketenabwehr; Purger zusaetzlich mit Torpedo-/Raketenabwehr im Nahbereich |
| UEB4201 Buzzkill | WEB4301 Protector (BattlePack) | UEF | Raketenabwehr; Protector mit Strahlwaffe |

Die Ausbaustufen bleiben auch direkt von Ingenieuren baubar.

## 2. Bestand

```
LOUD\usermods\TacticalMissileUpgrades\
  mod_info.lua
  units\UAB2108\, UAB4201\, UEB4201\      Merge (nur Ausbau-Felder)
  units\BAB2308\, BAB4307\, WEB4301\      Vollkopien aus Colins Fassung
  projectiles\MirvSerpentine01\, MirvSerpentineVChild01\   Purifier-Rakete (BlackOps)
  effects\Emitters\                       9 Treffereffekte der Purifier (BlackOps, unveraendert)
  lua\BlackOps_projectiles.lua            Auszug: MIRVChild01Projectile
  lua\CustomUnits\TacticalMissileUpgrades.lua   KI: Purger, Protector
  lua\README.md
  hook\lua\ui\help\unitdescription.lua    3 Beschreibungstexte
```

## 3. Mechanik

Ausbau wie bei LOUDs Massenextraktoren (Vorbild
`LOUD\gamedata.entpackt\units\units\UAB1202\UAB1202_unit.bp` Z. 74-98):

- Basis: `Economy.BuildRate` (Ausbaugeschwindigkeit), `Economy.BuildableCategory = {'<ausbau>'}`,
  `General.UpgradesTo = '<ausbau>'`.
- Ausbaustufe: `General.UpgradesFrom = '<basis>'`, Bauflaeche passend zur Basis.

Die drei Basen sind Basisspiel-Einheiten, kein anderer Mod oder LOUD-Paket ueberschreibt sie
(geprueft 2026-10-14) - deshalb **Merge**. Die Ausbaustufen stammen aus BlackOps bzw.
BattlePack und sind **Kopien**; der Mod hat `conflicts` gegen beide Pakete (wie
AirForceRebalance gegen BlackOps, NavyRebalance gegen BattlePack).

Alle Script-Abhaengigkeiten liegen in LOUDs Basis-Lua (`aeonweapons.lua` Z. 53/166,
`defaultantiprojectile.lua` Z. 488, `terranweapons.lua` Z. 162, `aeonprojectiles.lua`
Z. 364), ausser dem Teilgeschoss der Purifier - dafuer der Auszug in `lua\`.

## 4. Werte (LOUD -> Colin -> jetzt)

### 4.1 Basen (Merge)

| Einheit | Feld | LOUD | Colin | jetzt |
|---|---|---|---|---|
| UAB2108 Serpentine | `BuildRate` | 25 | 25 | 25 (LOUD, fuer Raketen) |
| | `BuildableCategory` | - | `{'uab2108','bab2308'}` | `{'bab2308'}` |
| | `UpgradesTo` | - | `bab2308` | `bab2308` |
| UAB4201 Volcano | `BuildRate` | - | `Buildrate = 20` (wirkungslos) | **20** |
| | `BuildableCategory` | - | `{'uab4201','bab4307'}` | `{'bab4307'}` |
| | `UpgradesTo` | - | `bab4307` | `bab4307` |
| UEB4201 Buzzkill | `BuildRate` | - | 10 | 10 |
| | `BuildableCategory` | - | `{'ueb4201','web4301'}` | `{'web4301'}` |
| | `UpgradesTo` | - | `web4301` | `web4301` |

### 4.2 Ausbaustufen (Kopie)

| Einheit | Feld | Paket | Colin = jetzt |
|---|---|---|---|
| BAB2308 Purifier | Masse / Energie | 7400 / 125500 | **1200 / 25500** |
| | Schaden Rakete | 2000 | 1500 |
| | Raketen beim Bau | 0 | 2 |
| | Groesse (`SizeX/Z`, Bauflaeche) | 3 x 3 | 0,45 x 1 (Serpentine-Groesse, damit der Ausbau passt) |
| | `UpgradesFrom` | - | `uab2108` |
| BAB4307 Purger | Masse | 1800 | 1200 |
| | Abwehrgeschoss | `SIMAntiMissile01` | `AAAFizz01` (wie Volcano) |
| | `UpgradesFrom` | - | `uab4201` |
| | `BuildTime` | 1800 | Colin 120 -> **jetzt 1800** (Paul) |
| WEB4301 Protector | Masse | 950 | 650 |
| | `UpgradesFrom`, `RebuildBonusIds` | - / `web4301` | `ueb4201` / `ueb4201, web4301` |

## 5. Korrekturen durch uns

1. **Volcano konnte nicht ausbauen.** Colin schrieb `Buildrate` (kleines r). Das Feld wird in
   LOUD nirgends gelesen (Volltextsuche `gamedata.entpackt`, 0 Treffer); ohne `BuildRate`
   laeuft ein Ausbau nicht. Jetzt `BuildRate = 20`. Das ebenso wirkungslose `Buildrate` beim
   Purger ist entfernt.
2. **Purger-Bauzeit** zurueck auf LOUDs 1800 (Entscheidung Paul) - mit Colins 120 stand sie,
   direkt gebaut, fast sofort.
3. **Basen bauen sich nicht selbst:** Colin trug jede Basis in ihre eigene
   `BuildableCategory` ein; LOUDs Ausbauketten listen nur die Ausbaustufe.
4. Alle Pfade `/mods/UEF_trans_men/...` auf `/mods/tacticalmissileupgrades/...`; das
   Teilgeschoss importiert den eigenen Auszug statt Colins Kopie von `BlackOpsprojectiles.lua`.

## 6. Beschreibungen und KI

- Beschreibungen wortgleich aus BlackOps (`bab2308`, `bab4307`) und BattlePack (`web4301`).
- KI: Purger und Protector als `T3MissileDefense`, wortgleich aus BlackOps bzw. BattlePack.
  Die Purifier steht auch bei BlackOps nicht in der KI-Liste (dort auskommentiert) - nicht
  aufgenommen. Ob die KI Ausbauketten bei Gebaeuden nutzt, ist ungeprueft (TODO).

## 7. Tests

| Datum | Was | Ergebnis |
|---|---|---|
| 2026-10-14 | 23 Pfadliterale + 9 Effekte + 14 Partikeltexturen gegen das VFS | alle loesen auf |
| 2026-10-14 | ASCII, Restverweise auf `UEF_trans_men`/Pakete | sauber (nur Kommentare) |
| | **Testlauf im Spiel** | **ausstehend** |

**Pruefliste:**

1. Mod-Manager: "Tactical Missile Upgrades" mit Purifier-Bild; Konfliktmeldung bei BlackOps
   und BattlePack.
2. Log: `Hooked /lua/ui/help/unitdescription.lua with /mods/tacticalmissileupgrades/...`,
   kein Fehler mit `tacticalmissileupgrades` im Pfad.
3. Serpentine bauen, auswaehlen: Ausbau-Schaltflaeche zur Purifier? Ausbau laeuft durch.
4. Purifier feuern: Rakete teilt sich, Treffereffekt sichtbar, kein Lua-Fehler.
5. Volcano -> Purger: Ausbau laeuft (Korrektur 1), dauert spuerbar.
6. Buzzkill -> Protector: Ausbau laeuft, Strahl faengt Raketen.

## 8. Offene Punkte

- [ ] Testlauf, Abschnitt 7
- [ ] Nutzt LOUDs KI Ausbauketten bei Verteidigungsgebaeuden? (ungeprueft)

## 9. Quellen

- `LOUD\usermods\UEF_trans_men\units\` (UAB2108, UAB4201, UEB4201, BAB2308, BAB4307, WEB4301), `...\projectiles\MirvSerpentine*`
- `LOUD\gamedata.entpackt\units\units\`
- `LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\` (Einheiten, `lua\BlackOpsprojectiles.lua`, `lua\BlackOpsEffectTemplates.lua`, `effects\Emitters\`, `lua\CustomUnits\BO_Buildings.lua`)
- `LOUD\gamedata.entpackt\WyvernBattlePack\mods\BattlePack\` (WEB4301, `lua\CustomUnits\Wyvern_Units.lua`)
