# BaseGame - Paket `units`

Zurueck: [README.md](README.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [mods.md](mods.md) - [usermods.md](usermods.md) - [ueberschreibungen.md](ueberschreibungen.md)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\units\units\
```

**432 Einheiten.** Alles in diesem Verzeichnis zaehlt als BaseGame - Kriterium ist der
Ablageort, nicht das ID-Praefix. Der Unterordner `Seraphim\` ist keine Einheit.

| Kategorie | Ablageort | Datei |
|---|---|---|
| basegame | `gamedata.entpackt\units\units\` | diese Datei |
| mod | `gamedata.entpackt\<Archiv>\...\units\` | [mods.md](mods.md) |
| usermod | `usermods\<Mod>\units\` | [usermods.md](usermods.md) |

Geprueft am 2026-08-05 gegen das Dateisystem: kein Eintrag fehlt, keiner ist erfunden.
Die Tabellenzeilen wurden maschinell aus der Verzeichnisliste und der Lokalisierung
erzeugt, nicht abgetippt.

## Spalten

| Spalte | Bedeutung |
|---|---|
| ID | Blueprint-Kennung, entspricht dem Ordnernamen |
| Name | `UnitName` laut Lokalisierung, `-` wenn kein Eintrag |
| Ueberschrieben von | Mod, der diesen Blueprint ersetzt. `-` heisst: nicht ueberschrieben. |

Steht in der dritten Spalte ein Modname, **gilt im Spiel dessen Fassung**, nicht die aus
diesem Verzeichnis - vorausgesetzt der Mod ist aktiv. Vollstaendige Aufstellung in
[ueberschreibungen.md](ueberschreibungen.md).

Namen aus
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loc_US\loc\US\strings_db.lua
```

---

## Aeon

### Luft (15)

| ID | Name | Ueberschrieben von |
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
| `XAA0002` | - | - |
| `XAA0202` | Swift Wind | - |
| `XAA0305` | Restorer | UEF_trans_men |
| `XAA0306` | Solace | UEF_trans_men |

### Land (20)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `UAL0001` | Armored Command Unit | commanders |
| `UAL0101` | Spirit | - |
| `UAL0103` | Fervor | - |
| `UAL0104` | Thistle | - |
| `UAL0105` | Engineer | - |
| `UAL0106` | Flare | - |
| `UAL0111` | Evensong | - |
| `UAL0201` | Aurora | - |
| `UAL0202` | Obsidian | - |
| `UAL0205` | Ascendant | - |
| `UAL0208` | Engineer | - |
| `UAL0301` | Support Armored Command Unit | UEF_trans_men |
| `UAL0303` | Harbinger Mark IV | - |
| `UAL0304` | Serenity | - |
| `UAL0307` | Asylum | - |
| `UAL0308` | - | - |
| `UAL0309` | Engineer | - |
| `UAL0401` | Galactic Colossus | - |
| `XAL0203` | Blaze | - |
| `XAL0305` | Sprite Striker | - |

### See (12)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `UAS0102` | Shard | - |
| `UAS0103` | Beacon Class | - |
| `UAS0201` | Exodus Class | - |
| `UAS0202` | Infinity Class | - |
| `UAS0203` | Sylph | UEF_trans_men |
| `UAS0302` | Omen Class | - |
| `UAS0303` | Keefer Class | - |
| `UAS0304` | Silencer | UEF_trans_men |
| `UAS0305` | Sonar Platform | - |
| `UAS0401` | Tempest | - |
| `XAS0204` | Vesper | - |
| `XAS0306` | Torrent Class | UEF_trans_men |

### Gebaeude (55)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `UAB0101` | Land Factory | - |
| `UAB0102` | Air Factory | - |
| `UAB0103` | Naval Factory | - |
| `UAB0201` | Land Factory | - |
| `UAB0202` | Air Factory | - |
| `UAB0203` | Naval Factory | - |
| `UAB0301` | Land Factory | - |
| `UAB0302` | Air Factory | - |
| `UAB0303` | Naval Factory | - |
| `UAB0304` | Portal | - |
| `UAB0305` | - | - |
| `UAB1101` | Power Generator | - |
| `UAB1102` | Hydrocarbon Power Plant | - |
| `UAB1103` | Mass Extractor | - |
| `UAB1104` | Mass Fabricator | - |
| `UAB1105` | Energy Storage | - |
| `UAB1106` | Mass Storage | - |
| `UAB1201` | Power Generator | - |
| `UAB1202` | Mass Extractor | - |
| `UAB1301` | Quantum Reactor | - |
| `UAB1302` | Mass Extractor | UEF_trans_men |
| `UAB1303` | Mass Fabricator | - |
| `UAB2101` | Erupter | - |
| `UAB2104` | Seeker | - |
| `UAB2105` | - | - |
| `UAB2106` | - | - |
| `UAB2108` | Serpentine | UEF_trans_men |
| `UAB2109` | Tide | - |
| `UAB2204` | Marr | - |
| `UAB2205` | Wave Break | - |
| `UAB2301` | Oblivion | - |
| `UAB2302` | Emissary | - |
| `UAB2303` | Miasma | - |
| `UAB2304` | Transcender | - |
| `UAB2305` | Apocalypse | - |
| `UAB3101` | Radar System | - |
| `UAB3102` | Sonar System | - |
| `UAB3104` | Oculus | - |
| `UAB3105` | - | - |
| `UAB3106` | - | - |
| `UAB3201` | Radar System | - |
| `UAB3202` | Sonar System | - |
| `UAB3304` | - | - |
| `UAB4201` | Volcano | UEF_trans_men |
| `UAB4202` | Shield of Light | - |
| `UAB4203` | Veil | - |
| `UAB4301` | Radiance | - |
| `UAB4302` | Patron | - |
| `UAB5101` | Wall Section | - |
| `UAB5102` | Aeon Transport Beacon | - |
| `UAB5103` | Aeon Quantum Gate Beacon | - |
| `UAB5202` | Cradle | - |
| `XAB1401` | Paragon | - |
| `XAB2307` | Salvation | - |
| `XAB3301` | Eye of Rhianne | UEF_trans_men |

### Sonstiges (1)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `UAM0004` | - | - |

---

## UEF

### Luft (16)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `UEA0001` | C-D1 "Rover" | - |
| `UEA0003` | C-D2 "Rover" | - |
| `UEA0101` | Hummingbird | - |
| `UEA0102` | Cyclone | - |
| `UEA0103` | Scorcher | - |
| `UEA0104` | C14 Star Lifter | - |
| `UEA0107` | C-6 Courier | - |
| `UEA0203` | Stinger | - |
| `UEA0204` | Stork | UEF_trans_men |
| `UEA0302` | SR90 Blackbird | - |
| `UEA0303` | Wasp | UEF_trans_men |
| `UEA0304` | Ambassador | - |
| `UEA0305` | Broadsword | UEF_trans_men |
| `XEA0002` | Recon Satellite | NOMADS-try_b4_ur_BI |
| `XEA0306` | Continental | - |
| `XEA3204` | C-D2 "Rover-2" | - |

### Land (23)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `UEL0001` | Armored Command Unit | commanders, test21000 |
| `UEL0003` | - | - |
| `UEL0101` | Snoop | - |
| `UEL0103` | Lobo | - |
| `UEL0104` | Archer | - |
| `UEL0105` | Engineer | - |
| `UEL0106` | Mech Marine | - |
| `UEL0111` | Flapjack | - |
| `UEL0201` | MA12 Striker | - |
| `UEL0202` | Pillar | - |
| `UEL0203` | Riptide | - |
| `UEL0205` | Sky Boxer | UEF_trans_men |
| `UEL0208` | Engineer | - |
| `UEL0301` | Support Armored Command Unit | - |
| `UEL0303` | Titan | - |
| `UEL0304` | Demolisher | - |
| `UEL0307` | Parashield | - |
| `UEL0308` | - | - |
| `UEL0309` | Engineer | - |
| `UEL0401` | Fatboy | UEF_trans_men |
| `XEL0209` | Sparky | - |
| `XEL0305` | Percival | - |
| `XEL0306` | Spearhead | - |

### See (11)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `UES0103` | Thunderhead Class | - |
| `UES0201` | Valiant Class | - |
| `UES0202` | Governor Class | - |
| `UES0203` | Tigershark | UEF_trans_men |
| `UES0302` | Summit Class | - |
| `UES0304` | Ace | UEF_trans_men |
| `UES0305` | SP3 - 3000 | - |
| `UES0401` | Atlantis | UEF_trans_men |
| `XES0102` | Cooper | UEF_trans_men |
| `XES0205` | Bulwark | - |
| `XES0307` | Neptune Class | - |

### Gebaeude (56)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `UEB0101` | Land Factory | - |
| `UEB0102` | Air Factory | - |
| `UEB0103` | Naval Factory | - |
| `UEB0201` | Land Factory | - |
| `UEB0202` | Air Factory | - |
| `UEB0203` | Naval Factory | - |
| `UEB0301` | Land Factory | - |
| `UEB0302` | Air Factory | - |
| `UEB0303` | Naval Factory | - |
| `UEB0304` | QGW R-32 | - |
| `UEB0305` | - | - |
| `UEB1101` | Power Generator | - |
| `UEB1102` | HCPP - X1000 | - |
| `UEB1103` | Mass Pump 1 | - |
| `UEB1104` | Mass Fabricator | - |
| `UEB1105` | Energy Storage | - |
| `UEB1106` | Mass Storage | - |
| `UEB1201` | EG - 200 Fusion Reactor | - |
| `UEB1202` | Mass Pump 2 | - |
| `UEB1301` | EG 900 Fusion Reactor | - |
| `UEB1302` | Mass Pump 3 | UEF_trans_men |
| `UEB1303` | Mass Fabricator | - |
| `UEB2101` | DM1 Plasma Cannon | - |
| `UEB2104` | DA1 Railgun | - |
| `UEB2105` | - | - |
| `UEB2106` | - | - |
| `UEB2108` | Aloha | - |
| `UEB2109` | DN1 | - |
| `UEB2204` | Air Cleaner | - |
| `UEB2205` | Tsunami | - |
| `UEB2301` | Triad | - |
| `UEB2302` | Duke | - |
| `UEB2303` | Klink Hammer | - |
| `UEB2304` | Flayer | - |
| `UEB2305` | Stonager | - |
| `UEB2401` | Mavor | - |
| `UEB3101` | SA1 - 1000 | - |
| `UEB3102` | SP1 - 1000 | - |
| `UEB3104` | SA3 - Omni | - |
| `UEB3105` | - | - |
| `UEB3106` | - | UEF_trans_men |
| `UEB3201` | SA2 - 2000 | - |
| `UEB3202` | SP2 - 2000 | - |
| `UEB3304` | - | - |
| `UEB4201` | Buzzkill | UEF_trans_men |
| `UEB4202` | SD - Pulse | - |
| `UEB4203` | Scattershield | - |
| `UEB4301` | HSD Pulse | - |
| `UEB4302` | Nuke Eliminator | - |
| `UEB5101` | Calcicrete | - |
| `UEB5102` | UEF Transport Beacon | - |
| `UEB5103` | UEF Quantum Gate Beacon | - |
| `UEB5202` | Refuel & Repair | - |
| `XEB0104` | The Kennel | - |
| `XEB0204` | The Kennel | - |
| `XEB2306` | Ravager | - |

### Sonstiges (1)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `UEM0006` | - | - |

---

## Cybran

### Luft (14)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `URA0001` | Build Bot Effect | - |
| `URA0101` | Flying Eyes | - |
| `URA0102` | Prowler | - |
| `URA0103` | Zeus | - |
| `URA0104` | Dragon Fly | - |
| `URA0107` | Skyhook | - |
| `URA0203` | Renegade | - |
| `URA0204` | Cormorant | UEF_trans_men |
| `URA0302` | Spook | - |
| `URA0303` | Gemini | UEF_trans_men |
| `URA0304` | Revenant | - |
| `URA0401` | Soul Ripper | - |
| `XRA0105` | Jester | - |
| `XRA0305` | Wailer | UEF_trans_men |

### Land (29)

| ID | Name | Ueberschrieben von |
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
| `URL0307` | - | - |
| `URL0309` | Engineer | - |
| `URL0401` | Scathis | - |
| `URL0402` | Monkeylord | - |
| `XRL0002` | Crab Egg (Engineer) | - |
| `XRL0003` | Crab Egg (Brick) | - |
| `XRL0004` | Crab Egg (Flak) | - |
| `XRL0005` | Crab Egg (Artillery) | - |
| `XRL0201` | - | - |
| `XRL0302` | Fire Beetle | - |
| `XRL0305` | The Brick | - |
| `XRL0403` | Megalith | - |
| `XRL0404` | - | - |

### See (10)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `URS0103` | Trident Class | - |
| `URS0201` | Salem Class | - |
| `URS0202` | Siren Class | - |
| `URS0203` | Sliver | UEF_trans_men |
| `URS0302` | Galaxy Class | - |
| `URS0303` | Command Class | - |
| `URS0304` | Plan B | UEF_trans_men |
| `URS0305` | Flood XR | - |
| `XRS0204` | Barracuda | - |
| `XRS0205` | CI:18 Mermaid | - |

### Gebaeude (63)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `URB0101` | Land Factory | - |
| `URB0102` | Air Factory | - |
| `URB0103` | Naval Factory | - |
| `URB0201` | Land Factory | - |
| `URB0202` | Air Factory | - |
| `URB0203` | Naval Factory | - |
| `URB0301` | Land Factory | - |
| `URB0302` | Air Factory | - |
| `URB0303` | Naval Factory | - |
| `URB0304` | Summoner | - |
| `URB0305` | - | - |
| `URB0401` | - | - |
| `URB1101` | Power Generator | - |
| `URB1102` | Hydrocarbon Power Plant | - |
| `URB1103` | Mass Extractor | - |
| `URB1104` | Mass Fabricator | - |
| `URB1105` | Energy Storage | - |
| `URB1106` | Mass Storage | - |
| `URB1201` | Power Generator | - |
| `URB1202` | Mass Extractor | - |
| `URB1301` | Ion Reactor | - |
| `URB1302` | Mass Extractor | UEF_trans_men |
| `URB1303` | Mass Fabricator | - |
| `URB2101` | Auto Gun | - |
| `URB2104` | Tracer | - |
| `URB2105` | - | - |
| `URB2106` | - | - |
| `URB2108` | TML-4 | - |
| `URB2109` | Scuttle | - |
| `URB2204` | Burst Master | - |
| `URB2205` | Nanite Torpedo Array | - |
| `URB2301` | Cerberus | - |
| `URB2302` | Disruptor | - |
| `URB2303` | Gunther | - |
| `URB2304` | Myrmidon | - |
| `URB2305` | Liberator | - |
| `URB3101` | Magno | - |
| `URB3102` | Noah | - |
| `URB3104` | Olympus | - |
| `URB3105` | - | - |
| `URB3106` | - | - |
| `URB3201` | Magno XR | - |
| `URB3202` | Flood | - |
| `URB3302` | - | - |
| `URB3304` | - | - |
| `URB4201` | Zapper | - |
| `URB4202` | ED1 | - |
| `URB4203` | Twilight | UEF_trans_men |
| `URB4204` | ED2 | - |
| `URB4205` | ED3 | - |
| `URB4206` | ED4 | - |
| `URB4207` | ED5 | - |
| `URB4301` | - | - |
| `URB4302` | Guardian | - |
| `URB5101` | Wall Section | - |
| `URB5102` | Cybran Transport Beacon | - |
| `URB5103` | - | - |
| `URB5202` | Air Staging Facility | - |
| `XRB0104` | The Hive | - |
| `XRB0204` | The Hive | - |
| `XRB0304` | The Hive | - |
| `XRB2308` | HARMS | - |
| `XRB3301` | Soothsayer | - |

### Sonstiges (1)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `URM0004` | - | - |

---

## Seraphim

### Luft (12)

| ID | Name | Ueberschrieben von |
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

| ID | Name | Ueberschrieben von |
|---|---|---|
| `XSL0001` | Armored Command Unit | commanders |
| `XSL0101` | Selen | - |
| `XSL0103` | Zthuee | - |
| `XSL0104` | Ia-istle | - |
| `XSL0105` | Iya-istle | - |
| `XSL0111` | Ythisah | - |
| `XSL0201` | Thaam | - |
| `XSL0202` | Ilshavoh | - |
| `XSL0203` | Yenzyne | - |
| `XSL0205` | Iashavoh | - |
| `XSL0208` | Iya | - |
| `XSL0301` | Support Armored Command Unit | - |
| `XSL0303` | Othuum | - |
| `XSL0304` | Suthanus | - |
| `XSL0305` | Usha-Ah | - |
| `XSL0307` | Athanah | - |
| `XSL0309` | Iyathuum | - |
| `XSL0401` | Ythotha | - |
| `XSL0402` | Othuy | UEF_trans_men |

### See (8)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `XSS0103` | Hau-esel | - |
| `XSS0201` | Uashavoh | - |
| `XSS0202` | Ithalua | - |
| `XSS0203` | Sou-istle | UEF_trans_men |
| `XSS0302` | Hauthuum | nomads-4-loud |
| `XSS0303` | Iavish | UEF_trans_men |
| `XSS0304` | Yathsou | UEF_trans_men |
| `XSS0305` | - | - |

### Gebaeude (52)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `XSB0101` | Hethiya | - |
| `XSB0102` | Ia-iya | - |
| `XSB0103` | Uosiya | - |
| `XSB0201` | Hethiya | - |
| `XSB0202` | Ia-iya | - |
| `XSB0203` | Uosiya | - |
| `XSB0301` | Hethiya | - |
| `XSB0302` | Ia-iya | - |
| `XSB0303` | Uosiya | - |
| `XSB0304` | Aezthu-uhthe | - |
| `XSB0305` | - | - |
| `XSB1101` | Uya-iya | - |
| `XSB1102` | Uya-atoh | - |
| `XSB1103` | Hyalatoh | - |
| `XSB1104` | Hyaliya | - |
| `XSB1105` | Vishuyal | - |
| `XSB1106` | Vishyal | - |
| `XSB1201` | Uya-iya | - |
| `XSB1202` | Hyalatoh | - |
| `XSB1301` | Uya-iya | - |
| `XSB1302` | Hyalatoh | UEF_trans_men |
| `XSB1303` | Hyaliya | - |
| `XSB2101` | Uttaus | - |
| `XSB2104` | Ialla | - |
| `XSB2105` | - | - |
| `XSB2106` | - | - |
| `XSB2108` | Ythis | - |
| `XSB2109` | Sou-atha | - |
| `XSB2204` | Sinnatha | - |
| `XSB2205` | Uosthu | - |
| `XSB2301` | Uttaushala | - |
| `XSB2302` | Hovatham | - |
| `XSB2303` | Zthuthaam | - |
| `XSB2304` | Iathu-ioz | - |
| `XSB2305` | Hastue | - |
| `XSB2401` | Yolona Oss | - |
| `XSB3101` | Esel | - |
| `XSB3102` | Shou | - |
| `XSB3104` | Aezesel | - |
| `XSB3105` | - | - |
| `XSB3106` | - | - |
| `XSB3201` | Sele-esel | - |
| `XSB3202` | Shou-esel | - |
| `XSB3304` | - | - |
| `XSB4201` | Ythisatha | - |
| `XSB4202` | Atha | - |
| `XSB4203` | Sele-ioz | - |
| `XSB4301` | Athanuhthe | - |
| `XSB4302` | Ythisioz | - |
| `XSB5101` | Haas | - |
| `XSB5102` | Seraphim Transport Beacon | - |
| `XSB5202` | Iathu-uhthe | - |

### Sonstiges (1)

| ID | Name | Ueberschrieben von |
|---|---|---|
| `XSM0001` | - | - |

---

## Abweichende Praefixe (13)

Diese Eintraege liegen im selben Verzeichnis und gehoeren damit zum BaseGame, folgen aber
nicht den Set-Praefixen `U` (Supreme Commander) oder `X` (Forged Alliance). Vermutlich
spaetere LOUD-Ergaenzungen im Basispaket - Herkunft ungeprueft.

### Praefix D (6)

Die aus Forged Alliance bekannten Einheiten, hier unter `D` statt `X`.

| ID | Name | Fraktion | Domaene |
|---|---|---|---|
| `DAA0206` | Mercy | Aeon | Luft |
| `DAL0310` | Absolver | Aeon | Land |
| `DEA0202` | Janus | UEF | Luft |
| `DEL0204` | Mongoose | UEF | Land |
| `DRA0202` | Corsair | Cybran | Luft |
| `DRL0204` | Hoplite | Cybran | Land |

### Praefix B (4)

Kein Eintrag in der Lokalisierung. Die dreifache `*A0309`-Kennung ueber drei Fraktionen
deutet auf eine zusammengehoerige Einheitenreihe. Zweck ungeklaert.

| ID | Name | Fraktion | Domaene |
|---|---|---|---|
| `BAA0001` | - | Aeon | Luft |
| `BAA0309` | - | Aeon | Luft |
| `BRA0309` | - | Cybran | Luft |
| `BSA0309` | - | Seraphim | Luft |

### Praefix S (3)

Kein Eintrag in der Lokalisierung. Die `1401`-Kennung entspricht hier dem Aeon-Paragon
(`XAB1401`) - also vermutlich Gegenstuecke fuer die anderen drei Fraktionen. Ungeprueft.
`S` ist auch BrewLAN-Praefix, die Dateien liegen aber in `units\units\`.

| ID | Name | Fraktion | Domaene |
|---|---|---|---|
| `SEB1401` | - | UEF | Gebaeude |
| `SRB1401` | - | Cybran | Gebaeude |
| `SSB1401` | - | Seraphim | Gebaeude |

---

## Bilanz

| Gruppe | Luft | Land | See | Gebaeude | Sonstiges | Summe |
|---|---:|---:|---:|---:|---:|---:|
| Aeon | 15 | 20 | 12 | 55 | 1 | 103 |
| UEF | 16 | 23 | 11 | 56 | 1 | 107 |
| Cybran | 14 | 29 | 10 | 63 | 1 | 117 |
| Seraphim | 12 | 19 | 8 | 52 | 1 | 92 |
| Abweichende Praefixe | | | | | | 13 |
| **Summe** | | | | | | **432** |

Entspricht dem Verzeichnisinhalt: 432 Einheiten plus den Ordner `Seraphim\`.

45 dieser Blueprints werden von Usermods ueberschrieben - siehe dritte Spalte und
[ueberschreibungen.md](ueberschreibungen.md). Diese 45 wurden am 2026-08-05 gegen die
Verzeichnislisten der ueberschreibenden Mods geprueft.
