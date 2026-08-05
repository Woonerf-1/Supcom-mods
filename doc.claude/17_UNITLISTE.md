# 17 — Einheitenverzeichnis

Vollständige Liste aller Einheiten über alle Pakete, Mods und Fraktionen.

**Stand: 2026-08-05.** Erhoben durch Auflisten der Blueprint-Verzeichnisse unter
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\
```

---

## Lesehilfe: die ID-Systematik

**Pfadfinderregel:** Fraktion und Domäne sind zunächst aus der Unit-ID abgeleitet.
Wo Belege aus den Blueprints oder Lokalisierungsdateien vorliegen, stehen sie **statt**
der Ableitung — und werden bei Gelegenheit weiter ergänzt.

Stand der Ergänzung:

| Bereich | Namen | Fraktion belegt |
|---|---|---|
| `usermods\nomads-4-loud` | ✅ aus Lokalisierung | ✅ |
| `usermods\NOMADS-try_b4_ur_BI` | ✅ aus Blueprints | ✅ |
| `usermods\commanders` | — (kein `UnitName` im Blueprint) | ✅ |
| `usermods\test21000` | — | ✅ |
| `usermods\UEF_trans_men` | ⬜ offen (97 Blueprints) | ⬜ |
| `TotalMayhem` | ⬜ offen | ✅ (Stichproben) |
| alle übrigen Pakete | ⬜ offen | ⬜ abgeleitet |

Schema `[Set][Fraktion][Domäne][Nummer]`:

| Position | Zeichen | Bedeutung |
|---|---|---|
| 1 | `U` | Original Supreme Commander |
| | `X` | Forged Alliance |
| | `B` `D` `S` `L` `V` `W` | LOUD- und Mod-Ergänzungen |
| 2 | `A` | Aeon |
| | `E` | UEF |
| | `R` | Cybran |
| | `S` | Seraphim |
| 3 | `L` | Land |
| | `A` | Luft |
| | `S` | See |
| | `B` | Gebäude |
| | `M` | Sonstiges (selten, Bedeutung ungeklärt) |

⚠️ Die Ableitung ist eine **Konvention, keine Garantie.** Maßgeblich ist immer
`Categories` im Blueprint. Bei Einheiten aus Mod-Paketen weicht die Systematik gelegentlich
ab — im Zweifel die `<ID>_unit.bp` lesen.

⚠️ **Auf der Platte vorhanden ≠ im Spiel geladen.** Blueprints eines Mods werden nur
eingelesen, wenn der Mod in der Partie aktiv ist (`02_MODSYSTEM.md` §4, `15_LOG.md` R-01).

---

## Inhaltsverzeichnis

| Paket | Mod | Pfad |
|---|---|---|
| `units` | — | `gamedata.entpackt\units\units\` |
| `civ_units` | — | `gamedata.entpackt\civ_units\units\` |
| `blackops` | BlackOpsUnleashed, BlackopsACUs | `gamedata.entpackt\blackops\mods\<Mod>\units\` |
| `brewlan` | BrewLAN_Units, BrewLAN_LOUD, BrewLAN_Plenae, BrewLAN_RNG | `gamedata.entpackt\brewlan\mods\<Mod>\units\` |
| `TotalMayhem` | TotalMayhem | `gamedata.entpackt\TotalMayhem\mods\TotalMayhem\units\` |
| `WyvernBattlePack` | BattlePack | `gamedata.entpackt\WyvernBattlePack\mods\BattlePack\units\` |
| `loud_units` | LOUD Unit Additions | `gamedata.entpackt\loud_units\mods\LOUD Unit Additions\units\` |
| `4D-CompatibilityPack` | 4DC | `gamedata.entpackt\4D-CompatibilityPack\mods\4DC\units\` |
| `usermods` | (eigene Mods) | `usermods\<Mod>\units\` |

---

# Paket `units` — Basiseinheiten

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\units\units\
```

404 Einheiten. Vanilla-Bestand plus LOUD-Ergänzungen mit den Präfixen `B`, `D`, `S`.
Der Unterordner `Seraphim\` ist keine Einheit.

Namen aus
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loc_US\loc\US\strings_db.lua`
(514 Einträge, davon 385 hier zugeordnet). „—" = kein Eintrag.

⚠️ = **Blueprint wird von einem Mod überschrieben** — im Spiel gilt dann nicht dieser
Stand. Vollständige Aufstellung im Abschnitt „Überschreibungen" am Dateiende.

## Aeon

**Luft (18)**

| ID | Name | ID | Name |
|---|---|---|---|
| `BAA0001` | — | `UAA0302` | Seer |
| `BAA0309` | — | `UAA0303` | Corona ⚠️ |
| `DAA0206` | Mercy | `UAA0304` | Shocker |
| `UAA0101` | Mirage | `UAA0310` | CZAR |
| `UAA0102` | Conservator | `XAA0002` | — |
| `UAA0103` | Shimmer | `XAA0202` | Swift Wind |
| `UAA0104` | Aluminar | `XAA0305` | Restorer ⚠️ |
| `UAA0107` | Chariot | `XAA0306` | Solace ⚠️ |
| `UAA0203` | Specter | | |
| `UAA0204` | Skimmer ⚠️ | | |

**Land (21)**

| ID | Name | ID | Name |
|---|---|---|---|
| `DAL0310` | Absolver | `UAL0303` | Harbinger Mark IV |
| `UAL0001` | Armored Command Unit ⚠️ | `UAL0304` | Serenity |
| `UAL0101` | Spirit | `UAL0307` | Asylum |
| `UAL0103` | Fervor | `UAL0308` | — |
| `UAL0104` | Thistle | `UAL0309` | Engineer |
| `UAL0105` | Engineer | `UAL0401` | Galactic Colossus |
| `UAL0106` | Flare | `XAL0203` | Blaze |
| `UAL0111` | Evensong | `XAL0305` | Sprite Striker |
| `UAL0201` | Aurora | | |
| `UAL0202` | Obsidian | | |
| `UAL0205` | Ascendant | | |
| `UAL0208` | Engineer | | |
| `UAL0301` | Support Armored Command Unit ⚠️ | | |

**See (12)**

| ID | Name | ID | Name |
|---|---|---|---|
| `UAS0102` | Shard | `UAS0304` | Silencer ⚠️ |
| `UAS0103` | Beacon Class | `UAS0305` | Sonar Platform |
| `UAS0201` | Exodus Class | `UAS0401` | Tempest |
| `UAS0202` | Infinity Class | `XAS0204` | Vesper |
| `UAS0203` | Sylph ⚠️ | `XAS0306` | Torrent Class ⚠️ |
| `UAS0302` | Omen Class | | |
| `UAS0303` | Keefer Class | | |

**Gebäude (55)**

| ID | Name | ID | Name |
|---|---|---|---|
| `UAB0101` | Land Factory | `UAB2303` | Miasma |
| `UAB0102` | Air Factory | `UAB2304` | Transcender |
| `UAB0103` | Naval Factory | `UAB2305` | Apocalypse |
| `UAB0201` | Land Factory | `UAB3101` | Radar System |
| `UAB0202` | Air Factory | `UAB3102` | Sonar System |
| `UAB0203` | Naval Factory | `UAB3104` | Oculus |
| `UAB0301` | Land Factory | `UAB3105` | — |
| `UAB0302` | Air Factory | `UAB3106` | — |
| `UAB0303` | Naval Factory | `UAB3201` | Radar System |
| `UAB0304` | Portal | `UAB3202` | Sonar System |
| `UAB0305` | — | `UAB3304` | — |
| `UAB1101` | Power Generator | `UAB4201` | Volcano ⚠️ |
| `UAB1102` | Hydrocarbon Power Plant | `UAB4202` | Shield of Light |
| `UAB1103` | Mass Extractor | `UAB4203` | Veil |
| `UAB1104` | Mass Fabricator | `UAB4301` | Radiance |
| `UAB1105` | Energy Storage | `UAB4302` | Patron |
| `UAB1106` | Mass Storage | `UAB5101` | Wall Section |
| `UAB1201` | Power Generator | `UAB5102` | Aeon Transport Beacon |
| `UAB1202` | Mass Extractor | `UAB5103` | Aeon Quantum Gate Beacon |
| `UAB1301` | Quantum Reactor | `UAB5202` | Cradle |
| `UAB1302` | Mass Extractor ⚠️ | `XAB1401` | Paragon |
| `UAB1303` | Mass Fabricator | `XAB2307` | Salvation |
| `UAB2101` | Erupter | `XAB3301` | Eye of Rhianne ⚠️ |
| `UAB2104` | Seeker | | |
| `UAB2105` | — | | |
| `UAB2106` | — | | |
| `UAB2108` | Serpentine ⚠️ | | |
| `UAB2109` | Tide | | |
| `UAB2204` | Marr | | |
| `UAB2205` | Wave Break | | |
| `UAB2301` | Oblivion | | |
| `UAB2302` | Emissary | | |

**Sonstiges (1)**
`UAM0004` — ⚠️

## UEF

**Luft (17)**

| ID | Name | ID | Name |
|---|---|---|---|
| `DEA0202` | Janus | `UEA0302` | SR90 Blackbird |
| `UEA0001` | C-D1 „Rover" | `UEA0303` | Wasp ⚠️ |
| `UEA0003` | C-D2 „Rover" | `UEA0304` | Ambassador |
| `UEA0101` | Hummingbird | `UEA0305` | Broadsword ⚠️ |
| `UEA0102` | Cyclone | `XEA0002` | Recon Satellite ⚠️ |
| `UEA0103` | Scorcher | `XEA0306` | Continental |
| `UEA0104` | C14 Star Lifter | `XEA3204` | C-D2 „Rover-2" |
| `UEA0107` | C-6 Courier | | |
| `UEA0203` | Stinger | | |
| `UEA0204` | Stork ⚠️ | | |

**Land (24)**

| ID | Name | ID | Name |
|---|---|---|---|
| `DEL0204` | Mongoose | `UEL0303` | Titan |
| `UEL0001` | Armored Command Unit ⚠️ | `UEL0304` | Demolisher |
| `UEL0003` | — | `UEL0307` | Parashield |
| `UEL0101` | Snoop | `UEL0308` | — |
| `UEL0103` | Lobo | `UEL0309` | Engineer |
| `UEL0104` | Archer | `UEL0401` | Fatboy ⚠️ |
| `UEL0105` | Engineer | `XEL0209` | Sparky |
| `UEL0106` | Mech Marine | `XEL0305` | Percival |
| `UEL0111` | Flapjack | `XEL0306` | Spearhead |
| `UEL0201` | MA12 Striker | | |
| `UEL0202` | Pillar | | |
| `UEL0203` | Riptide | | |
| `UEL0205` | Sky Boxer ⚠️ | | |
| `UEL0208` | Engineer | | |
| `UEL0301` | Support Armored Command Unit | | |

**See (11)**

| ID | Name | ID | Name |
|---|---|---|---|
| `UES0103` | Thunderhead Class | `UES0401` | Atlantis ⚠️ |
| `UES0201` | Valiant Class | `XES0102` | Cooper ⚠️ |
| `UES0202` | Governor Class | `XES0205` | Bulwark |
| `UES0203` | Tigershark ⚠️ | `XES0307` | Neptune Class |
| `UES0302` | Summit Class | | |
| `UES0304` | Ace ⚠️ | | |
| `UES0305` | SP3 - 3000 | | |

**Gebäude (58)**

| ID | Name | ID | Name |
|---|---|---|---|
| `SEB1401` | — | `UEB2303` | Klink Hammer |
| `UEB0101` | Land Factory | `UEB2304` | Flayer |
| `UEB0102` | Air Factory | `UEB2305` | Stonager |
| `UEB0103` | Naval Factory | `UEB2401` | Mavor |
| `UEB0201` | Land Factory | `UEB3101` | SA1 - 1000 |
| `UEB0202` | Air Factory | `UEB3102` | SP1 - 1000 |
| `UEB0203` | Naval Factory | `UEB3104` | SA3 - Omni |
| `UEB0301` | Land Factory | `UEB3105` | — |
| `UEB0302` | Air Factory | `UEB3106` | — ⚠️ |
| `UEB0303` | Naval Factory | `UEB3201` | SA2 - 2000 |
| `UEB0304` | QGW R-32 | `UEB3202` | SP2 - 2000 |
| `UEB0305` | — | `UEB3304` | — |
| `UEB1101` | Power Generator | `UEB4201` | Buzzkill ⚠️ |
| `UEB1102` | HCPP - X1000 | `UEB4202` | SD - Pulse |
| `UEB1103` | Mass Pump 1 | `UEB4203` | Scattershield |
| `UEB1104` | Mass Fabricator | `UEB4301` | HSD Pulse |
| `UEB1105` | Energy Storage | `UEB4302` | Nuke Eliminator |
| `UEB1106` | Mass Storage | `UEB5101` | Calcicrete |
| `UEB1201` | EG - 200 Fusion Reactor | `UEB5102` | UEF Transport Beacon |
| `UEB1202` | Mass Pump 2 | `UEB5103` | UEF Quantum Gate Beacon |
| `UEB1301` | EG 900 Fusion Reactor | `UEB5202` | Refuel & Repair |
| `UEB1302` | Mass Pump 3 ⚠️ | `XEB0104` | The Kennel |
| `UEB1303` | Mass Fabricator | `XEB0204` | The Kennel |
| `UEB2101` | DM1 Plasma Cannon | `XEB2306` | Ravager |
| `UEB2104` | DA1 Railgun | | |
| `UEB2105` | — | | |
| `UEB2106` | — | | |
| `UEB2108` | Aloha | | |
| `UEB2109` | DN1 | | |
| `UEB2204` | Air Cleaner | | |
| `UEB2205` | Tsunami | | |
| `UEB2301` | Triad | | |
| `UEB2302` | Duke | | |

**Sonstiges (1)**
`UEM0006` — ⚠️

## Cybran

**Luft (16)**

| ID | Name | ID | Name |
|---|---|---|---|
| `BRA0309` | — | `URA0302` | Spook |
| `DRA0202` | Corsair | `URA0303` | Gemini ⚠️ |
| `URA0001` | Build Bot Effect | `URA0304` | Revenant |
| `URA0101` | Flying Eyes | `URA0401` | Soul Ripper |
| `URA0102` | Prowler | `XRA0105` | Jester |
| `URA0103` | Zeus | `XRA0305` | Wailer ⚠️ |
| `URA0104` | Dragon Fly | | |
| `URA0107` | Skyhook | | |
| `URA0203` | Renegade | | |
| `URA0204` | Cormorant ⚠️ | | |

**Land (30)**

| ID | Name | ID | Name |
|---|---|---|---|
| `DRL0204` | Hoplite | `URL0401` | Scathis |
| `URL0001` | Armored Command Unit ⚠️ | `URL0402` | Monkeylord |
| `URL0101` | Mole | `XRL0002` | Crab Egg (Engineer) |
| `URL0103` | Medusa | `XRL0003` | Crab Egg (Brick) |
| `URL0104` | Sky Slammer | `XRL0004` | Crab Egg (Flak) |
| `URL0105` | Engineer | `XRL0005` | Crab Egg (Artillery) |
| `URL0106` | Hunter | `XRL0201` | — |
| `URL0107` | Mantis | `XRL0302` | Fire Beetle |
| `URL0111` | Viper | `XRL0305` | The Brick |
| `URL0202` | Rhino | `XRL0403` | Megalith |
| `URL0203` | Wagner | `XRL0404` | — |
| `URL0205` | Banger | | |
| `URL0208` | Engineer | | |
| `URL0301` | Support Armored Command Unit | | |
| `URL0303` | Loyalist | | |
| `URL0304` | Trebuchet | | |
| `URL0306` | Deceiver | | |
| `URL0307` | — | | |
| `URL0309` | Engineer | | |

**See (10)**

| ID | Name | ID | Name |
|---|---|---|---|
| `URS0103` | Trident Class | `URS0304` | Plan B ⚠️ |
| `URS0201` | Salem Class | `URS0305` | Flood XR |
| `URS0202` | Siren Class | `XRS0204` | Barracuda |
| `URS0203` | Sliver ⚠️ | `XRS0205` | CI:18 Mermaid |
| `URS0302` | Galaxy Class | | |
| `URS0303` | Command Class | | |

**Gebäude (64)**

| ID | Name | ID | Name |
|---|---|---|---|
| `SRB1401` | — | `URB2305` | Liberator |
| `URB0101` | Land Factory | `URB3101` | Magno |
| `URB0102` | Air Factory | `URB3102` | Noah |
| `URB0103` | Naval Factory | `URB3104` | Olympus |
| `URB0201` | Land Factory | `URB3105` | — |
| `URB0202` | Air Factory | `URB3106` | — |
| `URB0203` | Naval Factory | `URB3201` | Magno XR |
| `URB0301` | Land Factory | `URB3202` | Flood |
| `URB0302` | Air Factory | `URB3302` | — |
| `URB0303` | Naval Factory | `URB3304` | — |
| `URB0304` | Summoner | `URB4201` | Zapper |
| `URB0305` | — | `URB4202` | ED1 |
| `URB0401` | — | `URB4203` | Twilight ⚠️ |
| `URB1101` | Power Generator | `URB4204` | ED2 |
| `URB1102` | Hydrocarbon Power Plant | `URB4205` | ED3 |
| `URB1103` | Mass Extractor | `URB4206` | ED4 |
| `URB1104` | Mass Fabricator | `URB4207` | ED5 |
| `URB1105` | Energy Storage | `URB4301` | — |
| `URB1106` | Mass Storage | `URB4302` | Guardian |
| `URB1201` | Power Generator | `URB5101` | Wall Section |
| `URB1202` | Mass Extractor | `URB5102` | Cybran Transport Beacon |
| `URB1301` | Ion Reactor | `URB5103` | — |
| `URB1302` | Mass Extractor ⚠️ | `URB5202` | Air Staging Facility |
| `URB1303` | Mass Fabricator | `XRB0104` | The Hive |
| `URB2101` | Auto Gun | `XRB0204` | The Hive |
| `URB2104` | Tracer | `xrb0304` | The Hive |
| `URB2105` | — | `XRB2308` | HARMS |
| `URB2106` | — | `XRB3301` | Soothsayer |
| `URB2108` | TML-4 | | |
| `URB2109` | Scuttle | | |
| `URB2204` | Burst Master | | |
| `URB2205` | Nanite Torpedo Array | | |
| `URB2301` | Cerberus | | |
| `URB2302` | Disruptor | | |
| `URB2303` | Gunther | | |
| `URB2304` | Myrmidon | | |

**Sonstiges (1)**
`URM0004` — ⚠️

## Seraphim

**Luft (13)**

| ID | Name | ID | Name |
|---|---|---|---|
| `BSA0309` | — | `XSA0203` | Vulthoo |
| `XSA0101` | Sele-istle | `XSA0204` | Uosioz ⚠️ |
| `XSA0102` | Ia-atha | `XSA0302` | Iaselen |
| `XSA0103` | Sinnve | `XSA0303` | Iazyne ⚠️ |
| `XSA0104` | Vishala | `XSA0304` | Sinntha |
| `XSA0107` | Vish | `XSA0402` | Ahwassa ⚠️ |
| `XSA0202` | Notha | | |

**Land (19)**

| ID | Name | ID | Name |
|---|---|---|---|
| `XSL0001` | Armored Command Unit ⚠️ | `XSL0301` | — |
| `XSL0101` | Selen | `XSL0303` | Othuum |
| `XSL0103` | Zthuee | `XSL0304` | Suthanus |
| `XSL0104` | Ia-istle | `XSL0305` | Usha-Ah |
| `XSL0105` | Iya-istle | `XSL0307` | Athanah |
| `XSL0111` | Ythisah | `XSL0309` | Iyathuum |
| `XSL0201` | Thaam | `XSL0401` | Ythotha |
| `XSL0202` | Ilshavoh | `XSL0402` | Othuy ⚠️ |
| `XSL0203` | Yenzyne | | |
| `XSL0205` | Iashavoh | | |
| `XSL0208` | Iya | | |

`XSL0301` = Support Armored Command Unit (Eintrag unter anderem Schlüssel).

**See (8)**

| ID | Name | ID | Name |
|---|---|---|---|
| `XSS0103` | Hau-esel | `XSS0302` | Hauthuum ⚠️ |
| `XSS0201` | Uashavoh | `XSS0303` | Iavish ⚠️ |
| `XSS0202` | Ithalua | `XSS0304` | Yathsou ⚠️ |
| `XSS0203` | Sou-istle ⚠️ | `XSS0305` | — |

**Gebäude (53)**

| ID | Name | ID | Name |
|---|---|---|---|
| `SSB1401` | — | `XSB2304` | Iathu-ioz |
| `XSB0101` | Hethiya | `XSB2305` | Hastue |
| `XSB0102` | Ia-iya | `XSB2401` | Yolona Oss |
| `XSB0103` | Uosiya | `XSB3101` | Esel |
| `XSB0201` | Hethiya | `XSB3102` | Shou |
| `XSB0202` | Ia-iya | `XSB3104` | Aezesel |
| `XSB0203` | Uosiya | `XSB3105` | — |
| `XSB0301` | Hethiya | `XSB3106` | — |
| `XSB0302` | Ia-iya | `XSB3201` | Sele-esel |
| `XSB0303` | Uosiya | `XSB3202` | Shou-esel |
| `XSB0304` | Aezthu-uhthe | `XSB3304` | — |
| `XSB0305` | — | `XSB4201` | Ythisatha |
| `XSB1101` | Uya-iya | `XSB4202` | Atha |
| `XSB1102` | Uya-atoh | `XSB4203` | Sele-ioz |
| `XSB1103` | Hyalatoh | `XSB4301` | Athanuhthe |
| `XSB1104` | Hyaliya | `XSB4302` | Ythisioz |
| `XSB1105` | Vishuyal | `XSB5101` | Haas |
| `XSB1106` | Vishyal | `XSB5102` | Seraphim Transport Beacon |
| `XSB1201` | Uya-iya | `XSB5202` | Iathu-uhthe |
| `XSB1202` | Hyalatoh | | |
| `XSB1301` | Uya-iya | | |
| `XSB1302` | Hyalatoh ⚠️ | | |
| `XSB1303` | Hyaliya | | |
| `XSB2101` | Uttaus | | |
| `XSB2104` | Ialla | | |
| `XSB2105` | — | | |
| `XSB2106` | — | | |
| `XSB2108` | Ythis | | |
| `XSB2109` | Sou-atha | | |
| `XSB2204` | Sinnatha | | |
| `XSB2205` | Uosthu | | |
| `XSB2301` | Uttaushala | | |
| `XSB2302` | Hovatham | | |
| `XSB2303` | Zthuthaam | | |

**Sonstiges (1)**
`XSM0001` — ⚠️

---

# Paket `civ_units` — Zivileinheiten

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\civ_units\units\
```

117 Einheiten. Hier steht das 3. Zeichen **`C` für Civilian**, nicht für eine Domäne.
Dazu fünf Objekte mit sprechendem Namen statt ID-Systematik.

**Aeon (1)**
`UAC1301`

**UEF (62)**
`UEC0001` `UEC1101` `UEC1201` `UEC1301` `UEC1401` `UEC1501` `UEC1901` `UEC1902`
`UEC1903` `UEC1904` `UEC1905` `UEC1906` `UEC1907` `XEC1301` `XEC1401` `XEC1501`
`XEC1908` `XEC1909`
`XEC8001` `XEC8002` `XEC8003` `XEC8004` `XEC8005` `XEC8006` `XEC8007` `XEC8008`
`XEC8009` `XEC8010` `XEC8011` `XEC8012` `XEC8013` `XEC8014` `XEC8015` `XEC8016`
`XEC8017` `XEC8018` `XEC8019` `XEC8020`
`XEC9001` `XEC9002` `XEC9003` `XEC9004` `XEC9005` `XEC9006` `XEC9007` `XEC9008`
`XEC9009` `XEC9010` `XEC9011`
`XEC9203` `XEC9204` `XEC9205` `XEC9206` `XEC9207` `XEC9208`
`XEC9301` `XEC9302` `XEC9303` `XEC9901` `XEC9902` `XEC9903`

**Cybran (47)**
`URC1902` `XRC1101` `XRC1502` `XRC2101` `XRC2201` `XRC2301` `XRC2401`
`XRC8001` `XRC8002` `XRC8003` `XRC8004` `XRC8005` `XRC8006` `XRC8007` `XRC8008`
`XRC8009` `XRC8010` `XRC8011` `XRC8012` `XRC8013` `XRC8014` `XRC8015` `XRC8016`
`XRC8017` `XRC8018` `XRC8019` `XRC8020`
`XRC8101` `XRC8102` `XRC8103` `XRC8104` `XRC8105` `XRC8106` `XRC8107` `XRC8108`
`XRC8109` `XRC8110` `XRC8111` `XRC8112` `XRC8113` `XRC8114` `XRC8115` `XRC8116`
`XRC8117` `XRC8118` `XRC8119` `XRC8120`

**Seraphim (3)**
`XSC1301` `XSC8001` `XSC9002`

**Ohne ID-Systematik (5)** — Straßenmöblierung
`UEF_Bus` `UEF_Car1` `UEF_Fence` `UEF_Streetlight_01` `UEF_truck`

---

# Paket `loud_units` — Mod `LOUD Unit Additions`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loud_units\mods\LOUD Unit Additions\units\
```

26 Einheiten. Set-Präfixe `L`, `V`, `W` sind LOUD-eigen.

**Aeon (7)**
`LAB2320` `UAB8765` `UABSSG01` `UABSSG02` `UALX401` `VAB2302` `WAB0201`

**UEF (6)**
`LEB2320` `UEB8765` `UEBSSG01` `UEBSSG02` `VEB2302` `WEL0405`

**Cybran (6)**
`LRB2320` `URB8765` `URBSSG01` `URBSSG02` `VRB2302` `WRL0404`

**Seraphim (7)**
`LSB2320` `VSB2302` `WSB0104` `XSB8765` `XSBSSG01` `XSBSSG02` `XSS0403`

---

# Paket `4D-CompatibilityPack` — Mod `4DC`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\4D-CompatibilityPack\mods\4DC\units\
```

15 Einheiten. Kompatibilitätsschicht zwischen den Paketen.

**Aeon (6)**
`UAA0206` (Luft) · `UAB2306` (Gebäude) · `UAL0108` `UAL0204` `UAL0310` `UAL0402` (Land)

**UEF (6)**
`UEB2306` (Gebäude) · `UEL0107` `UEL0108` `UEL0402` `XEL0308` (Land) · `UES0206` (See)

**Cybran (2)**
`URB2306` (Gebäude) · `URL0305` (Land)

**Seraphim (1)**
`XSA0201` (Luft)

---

# Paket `WyvernBattlePack` — Mod `BattlePack`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\WyvernBattlePack\mods\BattlePack\units\
```

25 Einheiten, durchgängig Set-Präfix `W`.

**Aeon (3)**
`WAL0401` `WAL4404` (Land) · `WAS0332` (See)

**UEF (12)**
`WEB0404` `WEB4301` (Gebäude)
`WEL0207` `WEL0302` `WEL0304` `WEL03041` `WEL0305` `WEL0309` `WEL0401` `WEL0416`
`WEL4404` (Land)
`WES0303` (See)

**Cybran (6)**
`WRA0401` (Luft) · `WRL0207` `WRL0301` `WRL0305` `WRL0309` `WRL1466` (Land)

**Seraphim (4)**
`WSL0202` `WSL0205` `WSL0308` `WSL0404` (Land)

---

# Paket `blackops` — Mod `BlackopsACUs`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackopsACUs\units\
```

9 Einheiten, Set-Präfix `E`. Alternative Kommandanten.

**Aeon (1)** `EAL0001`
**UEF (1)** `EEL0001`
**Cybran (1)** `ERL0001`
**Seraphim (6)** `ESB0001` `ESB0002` `ESB0003` `ESB0004` `ESB0005` `ESL0001`

---

# Paket `blackops` — Mod `BlackOpsUnleashed`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\units\
```

84 Einheiten, überwiegend Set-Präfix `B`. Enthält die Teleport-Jammer `*B4209`
aus `15_LOG.md` R-01.

## Aeon (16)

**Gebäude (9)**
`BAB1106` `BAB1202` `BAB1302` `BAB2303` `BAB2306` `BAB2308` `BAB4209` `BAB4307`
`BAB4309`

**Land (6)**
`BAL0110` `BAL0206` `BAL0310` `BAL0401` `BAL0402` `BAL0403`

**Sonstiges (1)** — `K`-Kennung außerhalb der Systematik
`BALK003`

## UEF (13)

**Luft (2)** `BEA0402` `BEA0403`

**Gebäude (5)** `BEB1106` `BEB1202` `BEB1302` `BEB2303` `BEB4209` `BEB4309`

**Land (5)** `BEL0211` `BEL0307` `BEL0308` `BEL0402` `XEL0307`

**See (1)** `BES0402`

**Sonstiges (1)** `BELK002`

## Cybran (23)

**Luft (1)** `BRA0409`

**Gebäude (8)**
`BRB1106` `BRB1202` `BRB1302` `BRB2303` `BRB2306` `BRB4209` `BRB4309` `BRB4401`

**Land (10)**
`BRL0006` `BRL0007` `BRL0008` `BRL0009` `BRL0010` `BRL0011` `BRL0205` `BRL0307`
`BRL0401`

**See (4)** `BRS0304` `BRS0305` `BRS0402` `XRS0402`

**Sonstiges (2)** `BRLK001` `BRLK005`

## Seraphim (32)

**Luft (3)** `BSA0003` `BSA0004` `BSA0310`

**Gebäude (9)**
`BSB0405` `BSB1106` `BSB1202` `BSB1302` `BSB2306` `BSB2402` `BSB4205` `BSB4209`
`BSB4309`

**Land (15)**
`BSL0003` `BSL0004` `BSL0005` `BSL0007` `BSL0008` `BSL0009` `BSL0010` `BSL0106`
`BSL0206` `BSL0306` `BSL0310` `BSL0401` `BSL0403` `BSL0404` `BSL0406`

**See (3)** `BSS0206` `BSS0306` `BSS0401`

**Sonstiges (1)** `BSLK004`

---

# Paket `TotalMayhem` — Mod `TotalMayhem`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\TotalMayhem\mods\TotalMayhem\units\
```

62 Einheiten. Der Ordner `SeraphimTexture\` ist keine Einheit.

> ⚠️ **Eigene ID-Systematik.** Total Mayhem folgt dem Schema `[Set][Fraktion][Domäne]…`
> **nicht**. Alle IDs beginnen mit `BR`; die Fraktion steckt im **3. Zeichen**.
> Die Zuordnung wurde aus `Categories` in vier Stichproben-Blueprints bestimmt:
>
> | Präfix | Fraktion | Beleg |
> |---|---|---|
> | `BRM` | **Cybran** | `BRMT1PD_unit.bp` → `'CYBRAN'` |
> | `BRN` | **UEF** | `BRNT1HPD_unit.bp` → `'UEF'` |
> | `BRO` | **Aeon** | `BROT1BT_unit.bp` → `'AEON'` |
> | `BRP` | **Seraphim** | `BRPT1PD_unit.bp` → `'SERAPHIM'` |
>
> Die restlichen Zeichen kodieren Techstufe (`T1`…`T3`, `EX` für Experimental) und
> Einheitentyp (`PD` Point Defense, `BT` Bot, `BM` Bomber, `HT` Heavy Tank …).
> Domänen sind daraus **nicht** verlässlich ableitbar — dafür das Blueprint lesen.

**Cybran — `BRM` (18)**
`BRMST3BOM` `BRMT1BT` `BRMT1EXM1` `BRMT1EXPD` `BRMT1EXPDT2` `BRMT1PD` `BRMT2EPD`
`BRMT2HT` `BRMT2MEDM` `BRMT2PD` `BRMT3AVA` `BRMT3BM2` `BRMT3BT` `BRMT3LZT`
`BRMT3MCM2` `BRMT3PD` `BRMT3PDRO` `BRMT3VUL`

**UEF — `BRN` (13)**
`BRNT1EXPD` `BRNT1HPD` `BRNT2BM` `BRNT2EPD` `BRNT2MT` `BRNT2PD2` `BRNT3ABB`
`BRNT3BLASP` `BRNT3BT` `BRNT3PDRO` `BRNT3SHBM` `BRNT3SHPD` `BRNT3WT`

**Aeon — `BRO` (14)**
`BROT1BT` `BROT1EXM1` `BROT1EXPD` `BROT1HPD` `BROT1ML` `BROT1MT` `BROT2ASB`
`BROT2EPD` `BROT3BT` `BROT3HM` `BROT3NCM` `BROT3PDRO` `BROT3SHBM` `BROT3SHPD`

**Seraphim — `BRP` (17)**
`BRPAT2BOMBER` `BRPAT2FIGBO` `BRPEXBOT` `BRPEXBTBOT` `BRPEXHVBOT` `BRPEXPD`
`BRPEXSHBM` `BRPEXTANK` `BRPT1EXM1` `BRPT1HT` `BRPT1PD` `BRPT2BTBOT` `BRPT2PD`
`BRPT3BOT` `BRPT3BT` `BRPT3ML` `BRPT3PD`

---

# Paket `brewlan`

> ⚠️ **Verschachtelte Untermods.** Anders als die übrigen Pakete hat `BrewLAN_Units`
> keinen eigenen `units\`-Ordner, sondern enthält weitere Mods (`BrewIntel`,
> `BrewResearch`), die je einen haben. Set-Präfix durchgängig `S`.

## Mod `BrewLAN_Units\BrewIntel`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_Units\BrewIntel\units\
```

5 Einheiten.

**Aeon (1)** `SAB3301`
**UEF (2)** `SEB3301` `SEL3401`
**Cybran (1)** `SRB3301`
**Seraphim (1)** `SSB3302`

## Mod `BrewLAN_Units\BrewResearch`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_Units\BrewResearch\units\
```

20 Einheiten, alle Gebäude, gleichmäßig auf vier Fraktionen verteilt.

**Aeon (5)** `SAB1101` `SAB1201` `SAB9101` `SAB9201` `SAB9301`
**UEF (5)** `SEB1101` `SEB1201` `SEB9101` `SEB9201` `SEB9301`
**Cybran (5)** `SRB1101` `SRB1201` `SRB9101` `SRB9201` `SRB9301`
**Seraphim (5)** `SSB1101` `SSB1201` `SSB9101` `SSB9201` `SSB9301`

## Mod `BrewLAN_LOUD`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_LOUD\units\
```

149 Einheiten — das größte Einzelpaket nach `units`.

### Aeon (28)

**Luft (6)** `SAA0106` `SAA0201` `SAA0211` `SAA0306` `SAA0313` `SAA0314`

**Gebäude (12)**
`SAB0401` `SAB2103` `SAB2220` `SAB2221` `SAB2222` `SAB2306` `SAB2308` `SAB2311`
`SAB4401` `SAB5104` `SAB5210` `SAB5301`

**Land (8)**
`SAL0209` `SAL0311` `SAL0319` `SAL0320` `SAL0321` `SAL0323` `SAL0324` `SAL0401`

**See (2)** `SAS0401` `SAS3324`

### UEF (40)

**Luft (10)**
`SEA0106` `SEA0201` `SEA0211` `SEA0212` `SEA0307` `SEA0310` `SEA0313` `SEA0314`
`SEA0401` `SEA3101`

**Gebäude (21)**
`SEB0401` `SEB2103` `SEB2211` `SEB2220` `SEB2221` `SEB2222` `SEB2308` `SEB2311`
`SEB2320` `SEB2401` `SEB2402` `SEB2404` `SEB3303` `SEB3404` `SEB4303` `SEB4401`
`SEB5104` `SEB5210` `SEB5310` `SEB5311` `SEB5381`

**Land (5)** `SEL0119` `SEL0319` `SEL0320` `SEL0321` `SEL0324`

**See (4)** `SES0204` `SES0219` `SES0319` `SES3324`

### Cybran (41)

**Luft (10)**
`SRA0106` `SRA0201` `SRA0211` `SRA0212` `SRA0306` `SRA0307` `SRA0313` `SRA0314`
`SRA0315` `SRA3101`

**Gebäude (17)**
`SRB0401` `SRB2103` `SRB2220` `SRB2221` `SRB2222` `SRB2306` `SRB2311` `SRB2391`
`SRB2402` `SRB4401` `SRB4402` `SRB5104` `SRB5210` `SRB5310` `SRB5311` `SRB5312`
`SRB5380`

**Land (11)**
`SRL0000` `SRL0209` `SRL0310` `SRL0311` `SRL0312` `SRL0316` `SRL0319` `SRL0320`
`SRL0321` `SRL0324` `SRL0401`

**See (3)** `SRS0219` `SRS0319` `SRS3324`

### Seraphim (38)

**Luft (10)**
`SSA0001` `SSA0002` `SSA0106` `SSA0201` `SSA0211` `SSA0305` `SSA0306` `SSA0307`
`SSA0313` `SSA0314`

**Gebäude (16)**
`SSB0401` `SSB2103` `SSB2121` `SSB2220` `SSB2221` `SSB2222` `SSB2306` `SSB2311`
`SSB2380` `SSB2404` `SSB3301` `SSB4401` `SSB5104` `SSB5210` `SSB5301` `SSB5401`

**Land (10)**
`SSL0001` `SSL0219` `SSL0311` `SSL0319` `SSL0320` `SSL0321` `SSL0324` `SSL0403`
`SSL0404` `SSL0405`

**See (2)** `SSS0306` `SSS3324`

### Ohne Fraktionskennung (2)
`ZZZ2220` `ZZZ5301`

## Mod `BrewLAN_Plenae\CityGeneration`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_Plenae\CityGeneration\units\
```

8 Einheiten. Stadtgenerierung; `C` steht wie in `civ_units` für Civilian.
Daneben zwei Sammel-Blueprints im Modwurzelverzeichnis: `UEC_UCivs.bp`, `UEF_XCivs.bp`.

**UEF (6)** `SEB5101` `SEC0103` `SEC1101` `SEC1201` `SEC1202` `SEC1203`
**Ohne Fraktionskennung (2)** `ZZCITYBLOCK9` `ZZCITYBLOCK9W`

## Mod `BrewLAN_Plenae\Spomeniki`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_Plenae\Spomeniki\units\
```

2 Einheiten (Denkmäler).

**Seraphim (1)** `SSB23SN`
**Ohne Fraktionskennung (1)** `SNLMER1`

Der dritte Untermod `BrewLAN_Plenae\Logger` enthält keine Einheiten.

## Mod `BrewLAN_RNG\CrateDrop`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_RNG\CrateDrop\units\
```

1 Einheit: `ZZCRATE` (Beutekiste, fraktionslos).

---

# `usermods` — eigener Bestand

❄️ Eingefroren, siehe `08_BESTANDSAUFNAHME.md`. Die Mods `AcidPools` und
`EscalatingBuildCosts` enthalten keine Einheiten.

## Mod `nomads-4-loud`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\nomads-4-loud\units\
```

107 Einheiten. **Fünfte Fraktion:** das 2. Zeichen `N` steht für **Nomads** und ist in der
Grundsystematik nicht vorgesehen.

Namen aus
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\nomads-4-loud\loc\US\nomads_strings_core.lua`
(128 Einträge). „—" = kein Eintrag in der Lokalisierung.

**Luft (14)**

| ID | Name | ID | Name |
|---|---|---|---|
| `XNA0001` | Meteor | `XNA0203` | Vanguard |
| `XNA0101` | Peeper | `XNA0302` | Beholder |
| `XNA0102` | Falcon | `XNA0303` | Thunder |
| `XNA0103` | Phoenix | `XNA0304` | Red Rage |
| `XNA0104` | Scalestor | `XNA0305` | Hornet |
| `XNA0105` | Golem | `XNA0401` | Altas |
| `XNA0107` | Diligence | `XNA0202` | Spitfire |

**Gebäude (47)**

| ID | Name | ID | Name |
|---|---|---|---|
| `XNB0101` | Land Factory | `XNB2303` | Fire Slinger |
| `XNB0102` | Air Factory | `XNB2305` | Devourer |
| `XNB0103` | Naval Factory | `XNB3101` | Sibyl 1 |
| `XNB0304` | Chop Shop | `XNB3102` | Echo 1 |
| `XNB1101` | Power Generator | `XNB3105` | — |
| `XNB1102` | Hydrocarbon Power Plant | `XNB3106` | — |
| `XNB1103` | Mass Extractor | `XNB3201` | Sibyl 2 |
| `XNB1104` | Mass Fabricator | `XNB3202` | Echo 2 |
| `XNB1105` | Energy Storage | `XNB3301` | Sibyl 3 |
| `XNB1106` | Mass Storage | `XNB3302` | Echo 3 |
| `XNB1201` | Antimatter Reactor | `XNB3303` | Arbalast |
| `XNB1202` | Mass Extractor | `XNB4201` | Vindicator |
| `XNB1301` | Advanced Antimatter Reactor | `XNB4202` | Surge Shield |
| `XNB1302` | Mass Extractor | `XNB4204` | Arc Aegis |
| `XNB1303` | Mass Fabricator | `XNB4205` | Trickster |
| `XNB2101` | Scatterer | `XNB4301` | Wave Shield |
| `XNB2102` | Slicer | `XNB4302` | Protector |
| `XNB2105` | — | `XNB4305` | Illusionist |
| `XNB2106` | — | `XNB5101` | Wall |
| `XNB2109` | Sea Needle | `XNB5202` | Oasis |
| `XNB2202` | Skythorn | `XNB9001` | NC1001A |
| `XNB2207` | Harpoon | `XNB9002` | — |
| `XNB2208` | Bowcaster | | |
| `XNB2301` | Piercer | | |
| `XNB2302` | Countdown | | |

**Land (23)**

| ID | Name | ID | Name |
|---|---|---|---|
| `XNL0001` | Armored Command Unit | `XNL0209` | Scarab |
| `XNL0101` | Silhouette | `XNL0301` | Support Armored Command Unit |
| `XNL0103` | Barrager | `XNL0302` | Watchman |
| `XNL0105` | Engineer | `XNL0303` | Nova |
| `XNL0106` | Grasshopper | `XNL0304` | Mauler |
| `XNL0107` | Marksman | `XNL0305` | Slugger |
| `XNL0111` | Avalanche | `XNL0306` | Dominator |
| `XNL0201` | Eclipse | `XNL0309` | Engineer |
| `XNL0202` | Brute | `XNL0401` | Bullfrog |
| `XNL0203` | Rogue | `XNL0402` | Beamer |
| `XNL0205` | Skyshell | `XNL0403` | Jericho |
| `XNL0208` | Engineer | | |

`XNL0301` hat 15 Preset-Varianten (Combat, Engineer, RAS, Sniper, Rambo, Gunslinger …),
alle über denselben Blueprint.

**See (9)**

| ID | Name | ID | Name |
|---|---|---|---|
| `XNS0102` | Defender Class | `XNS0205` | Whaler Class |
| `XNS0103` | Lance Class | `XNS0302` | Juggernaut Class |
| `XNS0201` | Firestorm Class | `XNS0303` | Mastodon Class |
| `XNS0202` | Mercenary Class | `XNS0304` | Leviathan Class |
| `XNS0203` | Buccaneer Class | | |

**Civilian / Sonstiges (7)**

| ID | Name |
|---|---|
| `XNC0001` | Planetary Operations Support Ship |
| `XNC0002` | Orbital Cruiser |
| `XNC0003` | — |
| `XNC2302` | — |
| `XNO0001` | Surface Operations Support |
| `XNO2302` | Deadline |
| `XNY0001` | — |

**Ergänzungen (7)** — Set-Präfix `Z`, dazu eine Seraphim-Überschreibung

| ID | Name | ID | Name |
|---|---|---|---|
| `ZNB9501` | Land Factory | `ZNB9601` | Land Factory |
| `ZNB9502` | Air Factory | `ZNB9602` | Air Factory |
| `ZNB9503` | Naval Factory | `ZNB9603` | Naval Factory |
| `XSS0302` | — (Seraphim) | | |

In der Lokalisierung stehen zusätzlich Namen ohne zugehörigen Ordner — u. a.
`xnb0201`/`0202`/`0203` und `xnb0301`/`0302`/`0303` (Factory HQ), `xnb0401` (Dropoff),
`xnb2304` (Big Bertha), `xnb4203` (Trickster), `xnb4303` (Fire Control), `xna2101`
(Fanatic), `xnl9001` (Armadillo), `xnl9002` (NC1001B). Zwei sind auskommentiert
(`xnl0109` Spotter, `xnl0300` Goliath).

## Mod `NOMADS-try_b4_ur_BI`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\NOMADS-try_b4_ur_BI\units\
```

9 Einheiten. Ausschließlich **Überschreibungen** vorhandener IDs aus anderen Paketen —
keine eigenen. Daneben eine Liste `units.txt` im Modwurzelverzeichnis.
Namen und Fraktion aus `General.UnitName` bzw. `General.FactionName` der Blueprints.

| Unit-ID | Fraktion | Name | Herkunft der ID |
|---|---|---|---|
| `CAS0401` | Aeon | **Deluge Class** | neu, Set-Präfix `C` |
| `CNB1202` | Nomads | **Eckard** | neu, Set-Präfix `C` |
| `CNB1302` | Nomads | **Günter** | neu, Set-Präfix `C` |
| `SAB4401` | Aeon | Pillar of Prominence | `BrewLAN_LOUD` |
| `SEA0106` | UEF | Seagull | `BrewLAN_LOUD` |
| `SEA0401` | UEF | AC-500 Centurion | `BrewLAN_LOUD` |
| `SSB3301` | Seraphim | **Eye of pifpuff** | `BrewLAN_LOUD` |
| `WAB0201` | Aeon | Saviour | `LOUD Unit Additions` |
| `XEA0002` | UEF | — (kein `UnitName`) | `units` |

**Fett** = offensichtlich eigene Umbenennungen. `Eckard`, `Günter` und `Eye of pifpuff`
sind keine Originalnamen der Ursprungspakete — der Mod ist erkennbar ein Spielplatz.

## Mod `commanders`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\commanders\units\
```

4 Einheiten — die vier ACUs, jeweils **Vollersatz** des Originals aus `units`.

| Unit-ID | Fraktion | Name |
|---|---|---|
| `UAL0001` | Aeon | — |
| `UEL0001` | UEF | — |
| `URL0001` | Cybran | — |
| `XSL0001` | Seraphim | — |

Geprüft: **keiner dieser Blueprints enthält ein `UnitName`-Feld.** Der Anzeigename kommt
über die Lokalisierung aus der ID. `General.FactionName` ist dagegen gesetzt.
Die Blueprints haben 1285 Zeilen (Original: 1282) und enthalten `Enhancements`-Blöcke.

⚠️ `UEL0001` kollidiert mit `test21000`.

## Mod `test21000`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\test21000\units\
```

1 Einheit: `UEL0001` (UEF) — Vollersatz des UEF-ACU.
Analyse in `08_BESTANDSAUFNAHME.md`: nur 8 geänderte Felder.

## Mod `UEF_trans_men`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\UEF_trans_men\units\
```

97 Einheiten. **Fast durchweg Überschreibungen** von IDs aus `units`, `blackops`,
`brewlan`, `LOUD Unit Additions` und `WyvernBattlePack`. Einzige neue ID: `MKT0409`.

ℹ️ **Namen noch offen.** Der Mod hat keine eigene Lokalisierungsdatei; die Namen stünden
einzeln in den 97 Blueprints. Da fast alles Überschreibungen sind, gelten überwiegend die
Namen der Ursprungspakete — abweichende Umbenennungen sind aber möglich (vgl.
`NOMADS-try_b4_ur_BI`). Nachtrag bei Gelegenheit, siehe `TODO.md`.

### Aeon (24)
`BAB1202` `BAB1302` `BAB2308` `BAB4307` `BAL0310` `SAA0306` `SAA0313` `SAB0104`
`SAB1312` `UAA0204` `UAA0303` `UAB1302` `UAB2108` `UAB4201` `UABSSG01` `UAL0301`
`UAL0310` `UAL0402` `UAS0203` `UAS0304` `XAA0305` `XAA0306` `XAB3301` `XAS0306`

### UEF (27)
`BEB1202` `BEB1302` `SEA0310` `SEA0313` `SEB1312` `SEB3404` `SEL0324` `SES0319`
`UEA0204` `UEA0303` `UEA0305` `UEB1302` `UEB3106` `UEB4201` `UEBSSG01` `UEL0205`
`UEL0401` `UEL0402` `UES0203` `UES0206` `UES0304` `UES0401` `VEB2302` `WEB0404`
`WEB4301` `WEL0401` `XES0102`

### Cybran (21)
`BRB1202` `BRB1302` `SRA0201` `SRA0313` `SRA4212` `SRB1312` `SRB2221` `SRB4313`
`SRB4402` `SRB5383` `SRL0319` `SRL0320` `URA0204` `URA0303` `URB1302` `URB4203`
`URBSSG01` `URS0203` `URS0304` `WRL0404` `XRA0305`

### Seraphim (24)
`BSA0310` `BSB1202` `BSB1302` `BSB2402` `BSB4205` `BSL0005` `BSLK004` `SSA0001`
`SSA0313` `SSA0314` `SSB1312` `SSL0324` `SSL0403` `WSB0104` `WSL0404` `XSA0204`
`XSA0303` `XSA0402` `XSB1302` `XSBSSG01` `XSL0402` `XSS0203` `XSS0303` `XSS0304`

### Neu, ohne ID-Systematik (1)
`MKT0409`

---

# Überschreibungen

**Der wichtigste Abschnitt dieser Datei.** Mods ändern nicht nur eigene Einheiten — sie
**ersetzen Blueprints vorhandener Einheiten**. Steht dieselbe Unit-ID in zwei Paketen,
gilt im Spiel nur eine: die des zuletzt angewandten aktiven Mods
(`02_MODSYSTEM.md` §5, Ladereihenfolge alphabetisch nach `uid`, sofern kein
`before`/`after`).

**98 IDs kommen in mehr als einem Paket vor.** Ermittelt durch Abgleich aller
ID-Listen dieser Datei.

## Übersicht nach überschreibendem Mod

| Mod | überschreibt IDs aus | Anzahl |
|---|---|---:|
| `UEF_trans_men` | `units`, `blackops`, `BrewLAN_LOUD`, `loud_units`, `WyvernBattlePack`, `4D-CompatibilityPack` | 86 |
| `NOMADS-try_b4_ur_BI` | `BrewLAN_LOUD`, `loud_units`, `units` | 5 |
| `commanders` | `units` (die vier ACUs) | 4 |
| `4D-CompatibilityPack` | — (wird selbst von `UEF_trans_men` überschrieben) | 0 |
| `test21000` | `units` (`UEL0001`) | 1 |
| `nomads-4-loud` | `units` (`XSS0302`) | 1 |

## Dreifachbelegung

| ID | Pakete |
|---|---|
| `UEL0001` | `units` → `commanders` → `test21000` |

⚠️ Welcher der beiden Mods gewinnt, entscheidet die alphabetische uid-Sortierung:
`12345678901234567890test21000` vor `THISoneIS4myBOImax` → **`commanders` wird zuletzt
angewandt und gewinnt.** Nicht geprüft, nur aus der Regel abgeleitet.

## Vollständige Liste

### `UEF_trans_men` überschreibt

**aus `units` (49)**
`UAA0204` `UAA0303` `UAB1302` `UAB2108` `UAB4201` `UAL0301` `UAM0004` `UAS0203`
`UAS0304` `UEA0204` `UEA0303` `UEA0305` `UEB1302` `UEB3106` `UEB4201` `UEL0205`
`UEL0401` `UEM0006` `UES0203` `UES0304` `UES0401` `URA0204` `URA0303` `URB1302`
`URB4203` `URM0004` `URS0203` `URS0304` `XAA0305` `XAA0306` `XAB3301` `XAS0306`
`XES0102` `XRA0305` `XSA0204` `XSA0303` `XSA0402` `XSB1302` `XSL0402` `XSM0001`
`XSS0203` `XSS0303` `XSS0304`

**aus `blackops` (15)**
`BAB1202` `BAB1302` `BAB2308` `BAB4307` `BAL0310` `BEB1202` `BEB1302` `BRB1202`
`BRB1302` `BSA0310` `BSB1202` `BSB1302` `BSB2402` `BSB4205` `BSL0005`

**aus `BrewLAN_LOUD` (14)**
`SAA0306` `SAA0313` `SEA0310` `SEA0313` `SEB3404` `SEL0324` `SES0319` `SRA0201`
`SRA0313` `SRB2221` `SRB4402` `SRL0319` `SRL0320` `SSA0001` `SSA0313` `SSA0314`
`SSL0324` `SSL0403`

**aus `loud_units` (3)**
`VEB2302` `WRL0404` `WSB0104`

**aus `WyvernBattlePack` (4)**
`WEB0404` `WEB4301` `WEL0401` `WSL0404`

**aus `4D-CompatibilityPack` (4)**
`UAL0310` `UAL0402` `UEL0402` `UES0206`

### `NOMADS-try_b4_ur_BI` überschreibt

| ID | aus | neuer Name |
|---|---|---|
| `SAB4401` | `BrewLAN_LOUD` | Pillar of Prominence |
| `SEA0106` | `BrewLAN_LOUD` | Seagull |
| `SEA0401` | `BrewLAN_LOUD` | AC-500 Centurion |
| `SSB3301` | `BrewLAN_LOUD` | **Eye of pifpuff** |
| `WAB0201` | `loud_units` | Saviour |
| `XEA0002` | `units` | — (Original: Recon Satellite) |

### `commanders` überschreibt

`UAL0001` `UEL0001` `URL0001` `XSL0001` — die vier ACUs aus `units`, jeweils als
**Vollersatz**, nicht als Merge.

### `test21000` überschreibt

`UEL0001` aus `units` — Vollersatz mit acht geänderten Feldern (`08_BESTANDSAUFNAHME.md`).

### `nomads-4-loud` überschreibt

`XSS0302` aus `units` (Original: Hauthuum).

## Was daraus folgt

1. **Ein Name in dieser Liste ist der Stand des jeweiligen Pakets, nicht zwingend der im
   Spiel.** Bei ⚠️-markierten IDs hängt es davon ab, welche Mods aktiv sind.
2. **Vor jeder Blueprint-Änderung prüfen, ob die ID mehrfach belegt ist.** Sonst wird
   die eigene Änderung von einem anderen Mod verdeckt — oder verdeckt dessen Änderung.
3. **`Merge = true` entschärft das Problem nicht.** Auch ein Merge wird von einem später
   angewandten Vollersatz verdrängt.
4. **Für den Neuschnitt** (`12_NEUSCHNITT.md`): `UEF_trans_men` überschreibt 86 fremde
   IDs, größtenteils ohne erkennbaren Zweck. Das ist der erste Kandidat fürs
   Aufräumen.

## Methodischer Hinweis

Die Liste ist aus den Verzeichnisnamen abgeleitet. Sie erfasst **Blueprint-Dateien**,
nicht andere Wege, Einheiten zu verändern:

- `ModBlueprints()`-Hooks ändern Blueprints **programmatisch**, ohne eigene Datei
  (`03_BLUEPRINTS.md` §5). Solche Änderungen tauchen hier nicht auf.
- `hook\lua\sim\Unit.lua` und verwandte Hooks ändern **Verhalten**, nicht Blueprints.
- Nicht-Unit-Blueprints (Projektile, Props, Meshes) sind hier nicht erfasst.

---

# Gesamtübersicht

| Paket | Mod | Einheiten |
|---|---|---:|
| `units` | — | 404 |
| `brewlan` | BrewLAN_LOUD | 149 |
| `civ_units` | — | 117 |
| `usermods` | nomads-4-loud | 107 |
| `usermods` | UEF_trans_men | 97 |
| `blackops` | BlackOpsUnleashed | 84 |
| `TotalMayhem` | TotalMayhem | 62 |
| `loud_units` | LOUD Unit Additions | 26 |
| `WyvernBattlePack` | BattlePack | 25 |
| `brewlan` | BrewLAN_Units\BrewResearch | 20 |
| `4D-CompatibilityPack` | 4DC | 15 |
| `blackops` | BlackopsACUs | 9 |
| `usermods` | NOMADS-try_b4_ur_BI | 9 |
| `brewlan` | BrewLAN_Plenae\CityGeneration | 8 |
| `brewlan` | BrewLAN_Units\BrewIntel | 5 |
| `usermods` | commanders | 4 |
| `brewlan` | BrewLAN_Plenae\Spomeniki | 2 |
| `brewlan` | BrewLAN_RNG\CrateDrop | 1 |
| `usermods` | test21000 | 1 |
| **Summe** | | **1145** |

Die Summe zählt Blueprint-Ordner, **nicht** eindeutige Einheiten: `UEF_trans_men`,
`NOMADS-try_b4_ur_BI`, `commanders` und `test21000` überschreiben überwiegend IDs, die
schon in anderen Paketen vorkommen.

## Abweichungen von der ID-Systematik

| Paket / Mod | Abweichung |
|---|---|
| `TotalMayhem` | eigenes Schema `BR[MNOP]…`, Fraktion im 3. Zeichen |
| `civ_units`, `CityGeneration` | 3. Zeichen `C` = Civilian statt Domäne |
| `nomads-4-loud` | 2. Zeichen `N` = Nomads, fünfte Fraktion |
| `BlackOpsUnleashed` | `K`-Kennung (`BALK003`, `BELK002`, `BRLK001`, `BRLK005`, `BSLK004`) |
| `brewlan` | `ZZZ…`, `ZZCITYBLOCK…`, `ZZCRATE`, `SNLMER1` ohne Fraktionskennung |
| `units` | `…M…` als 3. Zeichen (`UAM0004`, `UEM0006`, `URM0004`, `XSM0001`) |
| `civ_units` | `UEF_Bus`, `UEF_Car1`, `UEF_Fence`, `UEF_Streetlight_01`, `UEF_truck` |
| `UEF_trans_men` | `MKT0409` |
| `nomads-4-loud` | `XNO…`, `XNY…` als Domänenkennung ungeklärt |

## Freie Set-Präfixe für eigene Einheiten

Belegt sind: `U` `X` `B` `D` `S` `L` `V` `W` `E` `Z` `C` `M` `N`

Für eigene Einheiten bleiben u. a. `F` `G` `H` `I` `J` `K` `P` `Q` `T` `Y` —
vor Vergabe hier gegenprüfen (`07_KONVENTIONEN.md` §3).

## Aktualität

Nach jedem LOUD-Update neu erheben, zusammen mit `gamedata.entpackt\`
(`01_ARCHITEKTUR.md` §2). Ebenso nach jeder Ergänzung eigener Einheiten.
