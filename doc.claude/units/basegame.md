# BaseGame - Paket `units`

Zurueck: [README.md](README.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [mods.md](mods.md) - [loud_misc.md](loud_misc.md) - [usermods.md](usermods.md) - [ueberschreibungen.md](ueberschreibungen.md)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\units\units\
```

**425 Einheiten.** Alles in diesem Verzeichnis zaehlt als BaseGame - Kriterium ist der
Ablageort, nicht das ID-Praefix.

Stand 2026-08-06, erzeugt aus `_generiert\units.csv`. Gezaehlt werden `*_unit.bp`-Dateien.
Sieben Unterordner enthalten **kein** Blueprint und sind keine Einheiten:
`UEL0003` `URB0401` `URB3302` `URB4301` `XAA0002` `XRL0201` `XRL0404`.
Der Ordner `Seraphim\` ebenso.

| Kategorie | Ablageort | Datei |
|---|---|---|
| basegame | `gamedata.entpackt\units\units\` | diese Datei |
| mod | `gamedata.entpackt\<Archiv>\...` | [mods.md](mods.md), [pakete.md](pakete.md), [loud_misc.md](loud_misc.md) |
| usermod | `usermods\<Mod>\...` | [usermods.md](usermods.md) |

## Spalten

| Spalte | Bedeutung |
|---|---|
| ID | Blueprint-Kennung, entspricht dem Ordnernamen |
| Name | `UnitName` aus dem Blueprint, sonst `HelpText`, sonst `-` |
| Ersetzt durch | Mods, die dieselbe ID mitbringen. `-` heisst: nur hier. |

**120 der 425 Blueprints werden von mindestens einem Mod ersetzt** - fast jede dritte
Einheit. Steht in der dritten Spalte ein Modname, gilt im Spiel dessen Fassung, sofern
der Mod aktiv ist. Einzelheiten: [ueberschreibungen.md](ueberschreibungen.md).

Haeufigste Ersetzer: `LOUD Integrated Storage` (Lager in Gebaeude),
`ZLOUD Structure Enhancements` (Fabriken, Flak, Artillerie), `Enhanced Nukes`,
`Artillery` - alle vier sind **LOUD-eigene Mods** aus `loud_misc` und bei vielen Spielern
aktiv.

---

## Aeon

### Luft (14)

| ID | Name | Ersetzt durch |
|---|---|---|
| `UAA0101` | Mirage | - |
| `UAA0102` | Conservator | - |
| `UAA0103` | Shimmer | - |
| `UAA0104` | Aluminar | - |
| `UAA0107` | Chariot | - |
| `UAA0203` | Specter | - |
| `UAA0204` | Skimmer | UEF_trans_men |
| `UAA0302` | Seer | - |
| `UAA0303` | Corona | UEF_trans_men |
| `UAA0304` | Shocker | - |
| `UAA0310` | CZAR | - |
| `XAA0202` | Swift Wind | - |
| `XAA0305` | Restorer | UEF_trans_men |
| `XAA0306` | Solace | UEF_trans_men |

### Land (20)

| ID | Name | Ersetzt durch |
|---|---|---|
| `UAL0001` | Armored Command Unit | commanders |
| `UAL0101` | Spirit | - |
| `UAL0103` | Fervor | - |
| `UAL0104` | Thistle | - |
| `UAL0105` | T1 Engineer | - |
| `UAL0106` | Flare | - |
| `UAL0111` | Evensong | - |
| `UAL0201` | Aurora | - |
| `UAL0202` | Obsidian | - |
| `UAL0205` | Ascendant | - |
| `UAL0208` | T2 Engineer | - |
| `UAL0301` | Support Armored Command Unit | UEF_trans_men |
| `UAL0303` | Harbinger | - |
| `UAL0304` | Serenity | - |
| `UAL0307` | Asylum | - |
| `UAL0308` | Refuge | - |
| `UAL0309` | Engineer | - |
| `UAL0401` | Galactic Colossus | - |
| `XAL0203` | Blaze | - |
| `XAL0305` | Sprite Striker | - |

### See (12)

| ID | Name | Ersetzt durch |
|---|---|---|
| `UAS0102` | Shard | - |
| `UAS0103` | Beacon Class | - |
| `UAS0201` | Exodus Class | - |
| `UAS0202` | Infinity Class | - |
| `UAS0203` | Sylph | UEF_trans_men |
| `UAS0302` | Omen Class | - |
| `UAS0303` | Keefer Class | - |
| `UAS0304` | Silencer | Enhanced Nukes, UEF_trans_men |
| `UAS0305` | Mobile Sonar Platform | - |
| `UAS0401` | Tempest | - |
| `XAS0204` | Vesper | - |
| `XAS0306` | Torrent Class | UEF_trans_men |

### Gebaeude (55)

| ID | Name | Ersetzt durch |
|---|---|---|
| `UAB0101` | Basic Land Factory | - |
| `UAB0102` | Basic Air Factory | - |
| `UAB0103` | Basic Naval Factory | - |
| `UAB0201` | Improved Land Factory | - |
| `UAB0202` | Improved Air Factory | - |
| `UAB0203` | Improved Naval Factory | - |
| `UAB0301` | Advanced Land Factory | ZLOUD Structure Enhancements |
| `UAB0302` | Advanced Air Factory | ZLOUD Structure Enhancements |
| `UAB0303` | Advanced Naval Factory | ZLOUD Structure Enhancements |
| `UAB0304` | Quantum Gateway | - |
| `UAB0305` | Teleport Node | - |
| `UAB1101` | Basic Power Generator | - |
| `UAB1102` | Basic Hydrocarbon Power Plant | - |
| `UAB1103` | Basic Mass Extractor | LOUD Integrated Storage |
| `UAB1104` | Mass Fabricator | LOUD Integrated Storage |
| `UAB1105` | Basic Energy Storage | LOUD Integrated Storage |
| `UAB1106` | Basic Mass Storage | LOUD Integrated Storage |
| `UAB1201` | Improved Power Generator | LOUD Integrated Storage |
| `UAB1202` | Improved Mass Extractor | LOUD Integrated Storage |
| `UAB1301` | Advanced Power Generator | LOUD Integrated Storage |
| `UAB1302` | Advanced Mass Extractor | LOUD Integrated Storage, UEF_trans_men |
| `UAB1303` | Advanced Mass Fabricator | LOUD Integrated Storage |
| `UAB2101` | Erupter | - |
| `UAB2104` | Seeker | - |
| `UAB2105` | Improved Energy Storage | - |
| `UAB2106` | Improved Mass Storage | - |
| `UAB2108` | Serpentine | UEF_trans_men |
| `UAB2109` | Tide | - |
| `UAB2204` | Marr | ZLOUD Structure Enhancements |
| `UAB2205` | Wave Break | - |
| `UAB2301` | Oblivion | - |
| `UAB2302` | Emissary | - |
| `UAB2303` | Miasma | - |
| `UAB2304` | Transcender | ZLOUD Structure Enhancements |
| `UAB2305` | Apocalypse | Enhanced Nukes |
| `UAB3101` | Basic Radar System | - |
| `UAB3102` | Basic Sonar System | - |
| `UAB3104` | Oculus | - |
| `UAB3105` | Advanced Energy Storage | - |
| `UAB3106` | Advanced Mass Storage | - |
| `UAB3201` | Improved Radar System | - |
| `UAB3202` | Improved Sonar System | - |
| `UAB3304` | Marriss | ZLOUD Structure Enhancements |
| `UAB4201` | Volcano | UEF_trans_men |
| `UAB4202` | Shield of Light | - |
| `UAB4203` | Veil | ZLOUD Structure Enhancements |
| `UAB4301` | Radiance | LOUD Integrated Storage |
| `UAB4302` | Patron | - |
| `UAB5101` | Wall Section | - |
| `UAB5102` | Aeon Transport Beacon | - |
| `UAB5103` | Aeon Quantum Gate Beacon | - |
| `UAB5202` | Cradle | ZLOUD Structure Enhancements |
| `XAB1401` | Paragon | - |
| `XAB2307` | Salvation | Artillery |
| `XAB3301` | Eye of Rhianne | UEF_trans_men |

### Sonstiges (1)

| ID | Name | Ersetzt durch |
|---|---|---|
| `UAM0004` | - | - |

---

## UEF

### Luft (16)

| ID | Name | Ersetzt durch |
|---|---|---|
| `UEA0001` | C-D1 Rover | - |
| `UEA0003` | C-D2 Rover | - |
| `UEA0101` | Hummingbird | - |
| `UEA0102` | Cyclone | - |
| `UEA0103` | Scorcher | - |
| `UEA0104` | Star Lifter | - |
| `UEA0107` | Courier | - |
| `UEA0203` | Stinger | - |
| `UEA0204` | Stork | UEF_trans_men |
| `UEA0302` | Blackbird | - |
| `UEA0303` | Wasp | UEF_trans_men |
| `UEA0304` | Ambassador | - |
| `UEA0305` | Broadsword | UEF_trans_men |
| `XEA0002` | Recon Satellite | NOMADS-try_b4_ur_BI |
| `XEA0306` | Continental | - |
| `XEA3204` | C-D2 Rover-2 | - |

### Land (22)

| ID | Name | Ersetzt durch |
|---|---|---|
| `UEL0001` | Armored Command Unit | commanders, test21000 |
| `UEL0101` | Snoop | - |
| `UEL0103` | Lobo | - |
| `UEL0104` | Archer | - |
| `UEL0105` | Engineer | - |
| `UEL0106` | Mech Marine | - |
| `UEL0111` | Flapjack | - |
| `UEL0201` | Striker | - |
| `UEL0202` | Pillar | - |
| `UEL0203` | Riptide | - |
| `UEL0205` | Sky Boxer | UEF_trans_men |
| `UEL0208` | Engineer | - |
| `UEL0301` | Support Armored Command Unit | - |
| `UEL0303` | Titan | - |
| `UEL0304` | Demolisher | - |
| `UEL0307` | Parashield | - |
| `UEL0308` | Veloshield | - |
| `UEL0309` | Engineer | - |
| `UEL0401` | Fatboy | UEF_trans_men |
| `XEL0209` | Sparky | - |
| `XEL0305` | Percival | - |
| `XEL0306` | Spearhead | - |

### See (11)

| ID | Name | Ersetzt durch |
|---|---|---|
| `UES0103` | Thunderhead Class | - |
| `UES0201` | Valiant Class | - |
| `UES0202` | Governor Class | - |
| `UES0203` | Tigershark | UEF_trans_men |
| `UES0302` | Summit Class | - |
| `UES0304` | Ace | Enhanced Nukes, UEF_trans_men |
| `UES0305` | SP3 - 3000 | - |
| `UES0401` | Atlantis | UEF_trans_men |
| `XES0102` | Cooper | UEF_trans_men |
| `XES0205` | Bulwark | - |
| `XES0307` | Neptune Class | - |

### Gebaeude (56)

| ID | Name | Ersetzt durch |
|---|---|---|
| `UEB0101` | Basic Land Factory | - |
| `UEB0102` | Basic Air Factory | - |
| `UEB0103` | Basic Naval Factory | - |
| `UEB0201` | Improved Land Factory | - |
| `UEB0202` | Improved Air Factory | - |
| `UEB0203` | Improved Naval Factory | - |
| `UEB0301` | Advanced Land Factory | ZLOUD Structure Enhancements |
| `UEB0302` | Advanced Air Factory | ZLOUD Structure Enhancements |
| `UEB0303` | Advanced Naval Factory | ZLOUD Structure Enhancements |
| `UEB0304` | Quantum Gateway | - |
| `UEB0305` | Teleport Node | - |
| `UEB1101` | Basic Power Generator | - |
| `UEB1102` | Basic Hydrocarbon Power Plant | - |
| `UEB1103` | Basic Mass Extractor | LOUD Integrated Storage |
| `UEB1104` | Mass Fabricator | LOUD Integrated Storage |
| `UEB1105` | Basic Energy Storage | LOUD Integrated Storage |
| `UEB1106` | Basic Mass Storage | LOUD Integrated Storage |
| `UEB1201` | Improved Power Generator | LOUD Integrated Storage |
| `UEB1202` | Improved Mass Extractor | LOUD Integrated Storage |
| `UEB1301` | Advanced Power Generator | LOUD Integrated Storage |
| `UEB1302` | Advanced Mass Extractor | LOUD Integrated Storage, UEF_trans_men |
| `UEB1303` | Advanced Mass Fabricator | LOUD Integrated Storage |
| `UEB2101` | Plasma Cannon | - |
| `UEB2104` | Railgun | - |
| `UEB2105` | Improved Energy Storage | - |
| `UEB2106` | Improved Mass Storage | - |
| `UEB2108` | Aloha | - |
| `UEB2109` | DN1 | - |
| `UEB2204` | Air Cleaner | ZLOUD Structure Enhancements |
| `UEB2205` | Tsunami | - |
| `UEB2301` | Triad | - |
| `UEB2302` | Duke | - |
| `UEB2303` | Klink Hammer | - |
| `UEB2304` | Flayer | ZLOUD Structure Enhancements |
| `UEB2305` | Stonager | Enhanced Nukes |
| `UEB2401` | Mavor | Artillery |
| `UEB3101` | SA1 - 1000 | - |
| `UEB3102` | Basic Sonar System | - |
| `UEB3104` | SA3 - 3000 | - |
| `UEB3105` | Advanced Energy Storage | - |
| `UEB3106` | Advanced Mass Storage | UEF_trans_men |
| `UEB3201` | SA2 - 2000 | - |
| `UEB3202` | Improved Sonar System | - |
| `UEB3304` | Nailer | ZLOUD Structure Enhancements |
| `UEB4201` | Buzzkill | UEF_trans_men |
| `UEB4202` | SD - Pulse | - |
| `UEB4203` | Scattershield | ZLOUD Structure Enhancements |
| `UEB4301` | HSD Pulse | LOUD Integrated Storage |
| `UEB4302` | Nuke Eliminator | - |
| `UEB5101` | Calcicrete | - |
| `UEB5102` | UEF Transport Beacon | - |
| `UEB5103` | UEF Quantum Gate Beacon | - |
| `UEB5202` | Refuel & Repair | ZLOUD Structure Enhancements |
| `XEB0104` | Kennel | - |
| `XEB0204` | Kennel | - |
| `XEB2306` | Ravager | - |

### Sonstiges (1)

| ID | Name | Ersetzt durch |
|---|---|---|
| `UEM0006` | - | - |

---

## Cybran

### Luft (14)

| ID | Name | Ersetzt durch |
|---|---|---|
| `URA0001` | Build Bot | - |
| `URA0101` | Peeker | - |
| `URA0102` | Prowler | - |
| `URA0103` | Zeus | - |
| `URA0104` | Dragon Fly | - |
| `URA0107` | Skyhook | - |
| `URA0203` | Sky Spider | - |
| `URA0204` | Cormorant | UEF_trans_men |
| `URA0302` | Spook | - |
| `URA0303` | Gemini | UEF_trans_men |
| `URA0304` | Revenant | - |
| `URA0401` | Soul Ripper | - |
| `XRA0105` | Jester | - |
| `XRA0305` | Wailer | UEF_trans_men |

### Land (27)

| ID | Name | Ersetzt durch |
|---|---|---|
| `URL0001` | Armored Command Unit | commanders |
| `URL0101` | Mole | - |
| `URL0103` | Medusa | - |
| `URL0104` | Sky Slammer | - |
| `URL0105` | Engineer | - |
| `URL0106` | Hunter | - |
| `URL0107` | Mantis | - |
| `URL0111` | Viper | - |
| `URL0202` | Rhino | - |
| `URL0203` | Wagner | - |
| `URL0205` | Banger | - |
| `URL0208` | Engineer | - |
| `URL0301` | Support Armored Command Unit | - |
| `URL0303` | Loyalist | - |
| `URL0304` | Trebuchet | - |
| `URL0306` | Deceiver | - |
| `URL0307` | Deviator | - |
| `URL0309` | Engineer | - |
| `URL0401` | Scathis | Artillery |
| `URL0402` | Monkeylord | - |
| `XRL0002` | Crab Egg (Engineer) | - |
| `XRL0003` | Crab Egg (Brick) | - |
| `XRL0004` | Crab Egg (Flak) | - |
| `XRL0005` | Crab Egg (Artillery) | - |
| `XRL0302` | Fire Beetle | - |
| `XRL0305` | Brick | - |
| `XRL0403` | Megalith | - |

### See (10)

| ID | Name | Ersetzt durch |
|---|---|---|
| `URS0103` | Trident Class | - |
| `URS0201` | Salem Class | - |
| `URS0202` | Siren Class | - |
| `URS0203` | Sliver | UEF_trans_men |
| `URS0302` | Galaxy Class | - |
| `URS0303` | Command Class | - |
| `URS0304` | Plan B | Enhanced Nukes, UEF_trans_men |
| `URS0305` | Flood XR | - |
| `XRS0204` | Barracuda | - |
| `XRS0205` | Mermaid | - |

### Gebaeude (60)

| ID | Name | Ersetzt durch |
|---|---|---|
| `URB0101` | Basic Land Factory | - |
| `URB0102` | Basic Air Factory | - |
| `URB0103` | Basic Naval Factory | - |
| `URB0201` | Improved Land Factory | - |
| `URB0202` | Improved Air Factory | - |
| `URB0203` | Improved Naval Factory | - |
| `URB0301` | Advanced Land Factory | ZLOUD Structure Enhancements |
| `URB0302` | Advanced Air Factory | ZLOUD Structure Enhancements |
| `URB0303` | Advanced Naval Factory | ZLOUD Structure Enhancements |
| `URB0304` | Quantum Gateway | - |
| `URB0305` | Teleport Node | - |
| `URB1101` | Basic Power Generator | - |
| `URB1102` | Basic Hydrocarbon Power Plant | - |
| `URB1103` | Basic Mass Extractor | LOUD Integrated Storage |
| `URB1104` | Mass Fabricator | LOUD Integrated Storage |
| `URB1105` | Basic Energy Storage | LOUD Integrated Storage |
| `URB1106` | Basic Mass Storage | LOUD Integrated Storage |
| `URB1201` | Improved Power Generator | LOUD Integrated Storage |
| `URB1202` | Improved Mass Extractor | LOUD Integrated Storage |
| `URB1301` | Advanced Power Generator | LOUD Integrated Storage |
| `URB1302` | Advanced Mass Extractor | LOUD Integrated Storage, UEF_trans_men |
| `URB1303` | Advanced Mass Fabricator | LOUD Integrated Storage |
| `URB2101` | Auto Gun | - |
| `URB2104` | Tracer | - |
| `URB2105` | Improved Energy Storage | - |
| `URB2106` | Improved Mass Storage | - |
| `URB2108` | TML-4 | - |
| `URB2109` | Scuttle | - |
| `URB2204` | Sky Web | ZLOUD Structure Enhancements |
| `URB2205` | Tentacle | - |
| `URB2301` | Cerberus | - |
| `URB2302` | Disruptor | - |
| `URB2303` | Gunther | - |
| `URB2304` | Myrmidon | ZLOUD Structure Enhancements |
| `URB2305` | Liberator | Enhanced Nukes |
| `URB3101` | Basic Radar System | - |
| `URB3102` | Basic Sonar System | - |
| `URB3104` | Omni Sensor Array | - |
| `URB3105` | Advanced Energy Storage | - |
| `URB3106` | Advanced Mass Storage | - |
| `URB3201` | Improved Radar System | - |
| `URB3202` | Flood | - |
| `URB3304` | Sky Net | ZLOUD Structure Enhancements |
| `URB4201` | Zapper | - |
| `URB4202` | ED1 | - |
| `URB4203` | Twilight | ZLOUD Structure Enhancements, UEF_trans_men |
| `URB4204` | ED2 | - |
| `URB4205` | ED3 | - |
| `URB4206` | ED4 | - |
| `URB4207` | ED5 | LOUD Integrated Storage |
| `URB4302` | Guardian | - |
| `URB5101` | Wall Section | - |
| `URB5102` | Cybran Transport Beacon | - |
| `URB5103` | Quantum Gateway Node | - |
| `URB5202` | Air Staging Facility | ZLOUD Structure Enhancements |
| `XRB0104` | The Hive | - |
| `XRB0204` | Hive Mk. II | - |
| `XRB0304` | Hive Mk. III | - |
| `XRB2308` | HARMS | - |
| `XRB3301` | Soothsayer | - |

### Sonstiges (1)

| ID | Name | Ersetzt durch |
|---|---|---|
| `URM0004` | - | - |

---

## Seraphim

### Luft (12)

| ID | Name | Ersetzt durch |
|---|---|---|
| `XSA0101` | Sele-istle | - |
| `XSA0102` | Ia-atha | - |
| `XSA0103` | Sinnve | - |
| `XSA0104` | Vishala | - |
| `XSA0107` | Vish | - |
| `XSA0202` | Notha | - |
| `XSA0203` | Vulthoo | - |
| `XSA0204` | Uosioz | UEF_trans_men |
| `XSA0302` | Iaselen | - |
| `XSA0303` | Iazyne | UEF_trans_men |
| `XSA0304` | Sinntha | - |
| `XSA0402` | Ahwassa | UEF_trans_men |

### Land (19)

| ID | Name | Ersetzt durch |
|---|---|---|
| `XSL0001` | Armored Command Unit | commanders |
| `XSL0101` | Selen | - |
| `XSL0103` | Zthuee | - |
| `XSL0104` | Ia-istle | - |
| `XSL0105` | Engineer | - |
| `XSL0111` | Ythisah | - |
| `XSL0201` | Thaam | - |
| `XSL0202` | Ilshavoh | - |
| `XSL0203` | Yenzyne | - |
| `XSL0205` | Iashavoh | - |
| `XSL0208` | T2 Engineer | - |
| `XSL0301` | Support Armored Command Unit | - |
| `XSL0303` | Othuum | - |
| `XSL0304` | Suthanus | - |
| `XSL0305` | Usha-Ah | - |
| `XSL0307` | Athanah | - |
| `XSL0309` | Engineer | - |
| `XSL0401` | Ythotha | - |
| `XSL0402` | Incarna | UEF_trans_men |

### See (8)

| ID | Name | Ersetzt durch |
|---|---|---|
| `XSS0103` | Hau-esel | - |
| `XSS0201` | Uashavoh | - |
| `XSS0202` | Ithalua | - |
| `XSS0203` | Sou-istle | UEF_trans_men |
| `XSS0302` | Hauthuum | nomads-4-loud |
| `XSS0303` | Iavish | UEF_trans_men |
| `XSS0304` | Yathsou | UEF_trans_men |
| `XSS0305` | Aezhou | - |

### Gebaeude (52)

| ID | Name | Ersetzt durch |
|---|---|---|
| `XSB0101` | Basic Land Factory | - |
| `XSB0102` | Ia-iya | - |
| `XSB0103` | Basic Naval Factory | - |
| `XSB0201` | Improved Land Factory | - |
| `XSB0202` | Improved Air Factory | - |
| `XSB0203` | Uosiya | - |
| `XSB0301` | Advanced Land Factory | ZLOUD Structure Enhancements |
| `XSB0302` | Advanced Air Factory | ZLOUD Structure Enhancements |
| `XSB0303` | Uosiya | ZLOUD Structure Enhancements |
| `XSB0304` | Aezthu-uhthe | - |
| `XSB0305` | Teleport Node | - |
| `XSB1101` | Basic Power Generator | - |
| `XSB1102` | Basic Hydrocarbon Power Plant | - |
| `XSB1103` | Basic Mass Extractor | LOUD Integrated Storage |
| `XSB1104` | Mass Fabricator | LOUD Integrated Storage |
| `XSB1105` | Basic Energy Storage | LOUD Integrated Storage |
| `XSB1106` | Basic Mass Storage | LOUD Integrated Storage |
| `XSB1201` | Improved Power Generator | LOUD Integrated Storage |
| `XSB1202` | Improved Mass Extractor | LOUD Integrated Storage |
| `XSB1301` | Advanced Power Generator | LOUD Integrated Storage |
| `XSB1302` | Advanced Mass Extractor | LOUD Integrated Storage, UEF_trans_men |
| `XSB1303` | Advanced Mass Fabricator | LOUD Integrated Storage |
| `XSB2101` | Uttaus | - |
| `XSB2104` | Ialla | - |
| `XSB2105` | Improved Energy Storage | - |
| `XSB2106` | Improved Mass Storage | - |
| `XSB2108` | Ythis | - |
| `XSB2109` | Sou-atha | - |
| `XSB2204` | Sinnatha | ZLOUD Structure Enhancements |
| `XSB2205` | Uosthu | - |
| `XSB2301` | Uttaushala | - |
| `XSB2302` | Hovatham | - |
| `XSB2303` | Zthuthaam | - |
| `XSB2304` | Iathu-ioz | ZLOUD Structure Enhancements |
| `XSB2305` | Hastue | Enhanced Nukes |
| `XSB2401` | Yolona Oss | Enhanced Nukes |
| `XSB3101` | Esel | - |
| `XSB3102` | Basic Sonar System | - |
| `XSB3104` | Aezesel | - |
| `XSB3105` | Advanced Energy Storage | - |
| `XSB3106` | Advanced Mass Storage | - |
| `XSB3201` | Sele-esel | - |
| `XSB3202` | Improved Sonar System | - |
| `XSB3304` | Sinnatha Hu | ZLOUD Structure Enhancements |
| `XSB4201` | Ythisatha | - |
| `XSB4202` | Atha | - |
| `XSB4203` | Sele-ioz | ZLOUD Structure Enhancements |
| `XSB4301` | Heavy Shield Generator | LOUD Integrated Storage |
| `XSB4302` | Ythisioz | - |
| `XSB5101` | Haas | - |
| `XSB5102` | Seraphim Transport Beacon | - |
| `XSB5202` | Iathu-uhthe | ZLOUD Structure Enhancements |

### Sonstiges (1)

| ID | Name | Ersetzt durch |
|---|---|---|
| `XSM0001` | - | - |

---

## Abweichende Set-Praefixe (13)

Diese Eintraege liegen im selben Verzeichnis und gehoeren damit zum BaseGame, folgen aber
nicht den Praefixen `U` (Supreme Commander) oder `X` (Forged Alliance). Keiner von ihnen
wird ueberschrieben.

| ID | Name | Fraktion | Domaene |
|---|---|---|---|
| `BAA0001` | Tempest Defense Drone | Aeon | Luft |
| `BAA0309` | Illuminate | Aeon | Luft |
| `BRA0309` | Vanisher | Cybran | Luft |
| `BSA0309` | Vishathal-Atah | Seraphim | Luft |
| `DAA0206` | Mercy | Aeon | Luft |
| `DAL0310` | Absolver | Aeon | Land |
| `DEA0202` | Janus | UEF | Luft |
| `DEL0204` | Mongoose | UEF | Land |
| `DRA0202` | Talon | Cybran | Luft |
| `DRL0204` | Hoplite | Cybran | Land |
| `SEB1401` | Apotheosis | UEF | Gebaeude |
| `SRB1401` | Demiurge | Cybran | Gebaeude |
| `SSB1401` | Uyahyaliyaiya | Seraphim | Gebaeude |

Die `D`-Einheiten sind die aus Forged Alliance bekannten, hier unter `D` statt `X`.
Die vier `B`-Eintraege und die drei `S`-Gebaeude haben jetzt Namen: `*A0309` sind
Luftfahrzeuge je Fraktion, die `1401`-Gebaeude sind die Paragon-Gegenstuecke
(Apotheosis, Demiurge, Uyahyaliyaiya) zum Aeon-`XAB1401`.

---

## Bilanz

| Gruppe | Luft | Land | See | Gebaeude | Sonstiges | Summe |
|---|---:|---:|---:|---:|---:|---:|
| Aeon | 14 | 20 | 12 | 55 | 1 | 102 |
| UEF | 16 | 22 | 11 | 56 | 1 | 106 |
| Cybran | 14 | 27 | 10 | 60 | 1 | 112 |
| Seraphim | 12 | 19 | 8 | 52 | 1 | 92 |
| Abweichende Praefixe | | | | | | 13 |
| **Summe** | | | | | | **425** |

**120 davon werden von mindestens einem Mod ersetzt.** Vier Einheiten haben keinen Namen:
`UAM0004` `UEM0006` `URM0004` `XSM0001` - Zweck ungeklaert.
