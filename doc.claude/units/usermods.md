# Usermods - eigene Mods

Zurueck: [README.md](README.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [basegame.md](basegame.md) - [mods.md](mods.md) - [ueberschreibungen.md](ueberschreibungen.md)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\<Mod>\units\
```

**218 Blueprint-Ordner** in fuenf Mods.

Eingefroren, siehe `../08_BESTANDSAUFNAHME.md`. `AcidPools` enthaelt keine Einheiten.

Geprueft am 2026-08-05: alle fuenf Verzeichnislisten abgeglichen, Summe stimmt.

| Mod | Einheiten | ersetzt basegame | Namen |
|---|---:|---:|---|
| [nomads-4-loud](#mod-nomads-4-loud) | 107 | 1 | 98 von 107 |
| [UEF_trans_men](#mod-uef_trans_men) | 97 | 39 | offen |
| [NOMADS-try_b4_ur_BI](#mod-nomads-try_b4_ur_bi) | 9 | 1 | vollstaendig |
| [commanders](#mod-commanders) | 4 | 4 | kein `UnitName` im Blueprint |
| [test21000](#mod-test21000) | 1 | 1 | kein `UnitName` im Blueprint |
| **Summe** | **218** | **45** | |

Die Spalte "ersetzt basegame" zaehlt IDs, die auch in `gamedata.entpackt\units\units\`
vorkommen - geprueft. Wie viele IDs zusaetzlich Blueprints aus den **mod-Paketen**
ersetzen, ist noch nicht ermittelt ([ueberschreibungen.md](ueberschreibungen.md)).

`UEL0001` kommt in `commanders` **und** `test21000` vor - die einzige Kollision
innerhalb der Usermods.

---

## Mod `nomads-4-loud`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\nomads-4-loud\units\
```

107 Einheiten. **Fuenfte Fraktion:** das 2. Zeichen `N` steht fuer Nomads und ist in der
Grundsystematik nicht vorgesehen.

Namen aus
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\nomads-4-loud\loc\US\nomads_strings_core.lua
```
126 Eintraege, davon 98 hier zugeordnet.

### Luft - `XNA` (14)

| ID | Name | Ueberschreibt |
|---|---|---|
| `XNA0001` | Meteor | - |
| `XNA0101` | Peeper | - |
| `XNA0102` | Falcon | - |
| `XNA0103` | Phoenix | - |
| `XNA0104` | Scalestor | - |
| `XNA0105` | Golem | - |
| `XNA0107` | Diligence | - |
| `XNA0202` | Spitfire | - |
| `XNA0203` | Vanguard | - |
| `XNA0302` | Beholder | - |
| `XNA0303` | Thunder | - |
| `XNA0304` | Red Rage | - |
| `XNA0305` | Hornet | - |
| `XNA0401` | Altas | - |

### Gebaeude - `XNB` (47)

| ID | Name | Ueberschreibt |
|---|---|---|
| `XNB0101` | Land Factory | - |
| `XNB0102` | Air Factory | - |
| `XNB0103` | Naval Factory | - |
| `XNB0304` | Chop Shop | - |
| `XNB1101` | Power Generator | - |
| `XNB1102` | Hydrocarbon Power Plant | - |
| `XNB1103` | Mass Extractor | - |
| `XNB1104` | Mass Fabricator | - |
| `XNB1105` | Energy Storage | - |
| `XNB1106` | Mass Storage | - |
| `XNB1201` | Antimatter Reactor | - |
| `XNB1202` | Mass Extractor | - |
| `XNB1301` | Advanced Antimatter Reactor | - |
| `XNB1302` | Mass Extractor | - |
| `XNB1303` | Mass Fabricator | - |
| `XNB2101` | Scatterer | - |
| `XNB2102` | Slicer | - |
| `XNB2105` | - | - |
| `XNB2106` | - | - |
| `XNB2109` | Sea Needle | - |
| `XNB2202` | Skythorn | - |
| `XNB2207` | Harpoon | - |
| `XNB2208` | Bowcaster | - |
| `XNB2301` | Piercer | - |
| `XNB2302` | Countdown | - |
| `XNB2303` | Fire Slinger | - |
| `XNB2305` | Devourer | - |
| `XNB3101` | Sibyl 1 | - |
| `XNB3102` | Echo 1 | - |
| `XNB3105` | - | - |
| `XNB3106` | - | - |
| `XNB3201` | Sibyl 2 | - |
| `XNB3202` | Echo 2 | - |
| `XNB3301` | Sibyl 3 | - |
| `XNB3302` | Echo 3 | - |
| `XNB3303` | Arbalast | - |
| `XNB4201` | Vindicator | - |
| `XNB4202` | Surge Shield | - |
| `XNB4204` | Arc Aegis | - |
| `XNB4205` | Trickster | - |
| `XNB4301` | Wave Shield | - |
| `XNB4302` | Protector | - |
| `XNB4305` | Illusionist | - |
| `XNB5101` | Wall | - |
| `XNB5202` | Oasis | - |
| `XNB9001` | NC1001A | - |
| `XNB9002` | - | - |

### Land - `XNL` (23)

| ID | Name | Ueberschreibt |
|---|---|---|
| `XNL0001` | Armored Command Unit | - |
| `XNL0101` | Silhouette | - |
| `XNL0103` | Barrager | - |
| `XNL0105` | Engineer | - |
| `XNL0106` | Grasshopper | - |
| `XNL0107` | Marksman | - |
| `XNL0111` | Avalanche | - |
| `XNL0201` | Eclipse | - |
| `XNL0202` | Brute | - |
| `XNL0203` | Rogue | - |
| `XNL0205` | Skyshell | - |
| `XNL0208` | Engineer | - |
| `XNL0209` | Scarab | - |
| `XNL0301` | Support Armored Command Unit | - |
| `XNL0302` | Watchman | - |
| `XNL0303` | Nova | - |
| `XNL0304` | Mauler | - |
| `XNL0305` | Slugger | - |
| `XNL0306` | Dominator | - |
| `XNL0309` | Engineer | - |
| `XNL0401` | Bullfrog | - |
| `XNL0402` | Beamer | - |
| `XNL0403` | Jericho | - |

`XNL0301` hat 15 Preset-Varianten ueber denselben Blueprint: Regular, Combat,
Fast Combat, Engineer, RAS, Sniper, Rambo, Gunslinger, Trooper, Heavy Trooper,
Rocket Launcher, Energy Rocket Launcher, Amphibious, Anti-Naval, Producer.

### See - `XNS` (9)

| ID | Name | Ueberschreibt |
|---|---|---|
| `XNS0102` | Defender Class | - |
| `XNS0103` | Lance Class | - |
| `XNS0201` | Firestorm Class | - |
| `XNS0202` | Mercenary Class | - |
| `XNS0203` | Buccaneer Class | - |
| `XNS0205` | Whaler Class | - |
| `XNS0302` | Juggernaut Class | - |
| `XNS0303` | Mastodon Class | - |
| `XNS0304` | Leviathan Class | - |

### Sonstige Domaenenkennungen (7)

`XNC` = Civilian. Die Kennungen `XNO` und `XNY` sind ungeklaert.

| ID | Name | Ueberschreibt |
|---|---|---|
| `XNC0001` | Planetary Operations Support Ship | - |
| `XNC0002` | Orbital Cruiser | - |
| `XNC0003` | - | - |
| `XNC2302` | - | - |
| `XNO0001` | Surface Operations Support | - |
| `XNO2302` | Deadline | - |
| `XNY0001` | - | - |

### Ergaenzungen - `ZNB` (6)

| ID | Name | Ueberschreibt |
|---|---|---|
| `ZNB9501` | Land Factory | - |
| `ZNB9502` | Air Factory | - |
| `ZNB9503` | Naval Factory | - |
| `ZNB9601` | Land Factory | - |
| `ZNB9602` | Air Factory | - |
| `ZNB9603` | Naval Factory | - |

### Ueberschreibung (1)

| ID | Name | Ueberschreibt |
|---|---|---|
| `XSS0302` | - | basegame: Hauthuum (Seraphim-U-Boot) |

Die einzige ID dieses Mods ausserhalb des Nomads-Namensraums.

### Karteileichen in der Lokalisierung

Namen ohne zugehoerigen Blueprint-Ordner: `xnb0201` `xnb0202` `xnb0203` `xnb0301`
`xnb0302` `xnb0303` (Factory HQ), `xnb0401` (Dropoff), `xnb2304` (Big Bertha),
`xnb4203` (Trickster), `xnb4303` (Fire Control), `xna2101` (Fanatic), `xnl9001`
(Armadillo), `xnl9002` (NC1001B). Zwei sind auskommentiert: `xnl0109` (Spotter),
`xnl0300` (Goliath).

---

## Mod `UEF_trans_men`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\UEF_trans_men\units\
```

97 Einheiten, davon **39 Ueberschreibungen von basegame** (geprueft). Wie viele der
uebrigen 58 Blueprints aus mod-Paketen ersetzen, ist nicht ermittelt.

Der Mod hat keine eigene Lokalisierungsdatei; Namen stuenden einzeln in den 97
Blueprints. Nachtrag bei Gelegenheit, siehe `../TODO.md`.

### Ueberschreibt basegame (39)

| ID | Original |
|---|---|
| `UAA0204` | Skimmer |
| `UAA0303` | Corona |
| `UAB1302` | Mass Extractor |
| `UAB2108` | Serpentine |
| `UAB4201` | Volcano |
| `UAL0301` | Support Armored Command Unit |
| `UAS0203` | Sylph |
| `UAS0304` | Silencer |
| `UEA0204` | Stork |
| `UEA0303` | Wasp |
| `UEA0305` | Broadsword |
| `UEB1302` | Mass Pump 3 |
| `UEB3106` | - |
| `UEB4201` | Buzzkill |
| `UEL0205` | Sky Boxer |
| `UEL0401` | Fatboy |
| `UES0203` | Tigershark |
| `UES0304` | Ace |
| `UES0401` | Atlantis |
| `URA0204` | Cormorant |
| `URA0303` | Gemini |
| `URB1302` | Mass Extractor |
| `URB4203` | Twilight |
| `URS0203` | Sliver |
| `URS0304` | Plan B |
| `XAA0305` | Restorer |
| `XAA0306` | Solace |
| `XAB3301` | Eye of Rhianne |
| `XAS0306` | Torrent Class |
| `XES0102` | Cooper |
| `XRA0305` | Wailer |
| `XSA0204` | Uosioz |
| `XSA0303` | Iazyne |
| `XSA0402` | Ahwassa |
| `XSB1302` | Hyalatoh |
| `XSL0402` | Othuy |
| `XSS0203` | Sou-istle |
| `XSS0303` | Iavish |
| `XSS0304` | Yathsou |

### Uebrige 58

Herkunft nicht geprueft. Praefixe deuten auf `blackops` (`B...`), `brewlan` (`S...`),
`loud_units` (`V...`), `WyvernBattlePack` (`W...`).

`BAB1202` `BAB1302` `BAB2308` `BAB4307` `BAL0310` `BEB1202` `BEB1302` `BRB1202`
`BRB1302` `BSA0310` `BSB1202` `BSB1302` `BSB2402` `BSB4205` `BSL0005` `BSLK004`
`MKT0409` `SAA0306` `SAA0313` `SAB0104` `SAB1312` `SEA0310` `SEA0313` `SEB1312`
`SEB3404` `SEL0324` `SES0319` `SRA0201` `SRA0313` `SRA4212` `SRB1312` `SRB2221`
`SRB4313` `SRB4402` `SRB5383` `SRL0319` `SRL0320` `SSA0001` `SSA0313` `SSA0314`
`SSB1312` `SSL0324` `SSL0403` `UABSSG01` `UAL0310` `UAL0402` `UEBSSG01` `UEL0402`
`UES0206` `URBSSG01` `VEB2302` `WEB0404` `WEB4301` `WEL0401` `WRL0404` `WSB0104`
`WSL0404` `XSBSSG01`

`MKT0409` folgt keiner bekannten Systematik und hat vermutlich kein Gegenstueck.

---

## Mod `NOMADS-try_b4_ur_BI`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\NOMADS-try_b4_ur_BI\units\
```

9 Einheiten. Namen und Fraktion aus `General.UnitName` bzw. `General.FactionName` der
Blueprints. Daneben eine Liste `units.txt` im Modwurzelverzeichnis.

| ID | Fraktion | Name | Ueberschreibt |
|---|---|---|---|
| `CAS0401` | Aeon | Deluge Class | - (neu, Praefix `C`) |
| `CNB1202` | Nomads | Eckard | - (neu, Praefix `C`) |
| `CNB1302` | Nomads | Guenter | - (neu, Praefix `C`) |
| `SAB4401` | Aeon | Pillar of Prominence | mod: BrewLAN_LOUD (ungeprueft) |
| `SEA0106` | UEF | Seagull | mod: BrewLAN_LOUD (ungeprueft) |
| `SEA0401` | UEF | AC-500 Centurion | mod: BrewLAN_LOUD (ungeprueft) |
| `SSB3301` | Seraphim | Eye of pifpuff | mod: BrewLAN_LOUD (ungeprueft) |
| `WAB0201` | Aeon | Saviour | mod: loud_units (ungeprueft) |
| `XEA0002` | UEF | - (kein `UnitName`) | basegame: Recon Satellite |

`Eckard`, `Guenter` und `Eye of pifpuff` sind keine Originalnamen - der Mod ist
erkennbar ein Spielplatz, keine ernsthafte Erweiterung.

---

## Mod `commanders`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\commanders\units\
```

4 Einheiten - die vier ACUs, jeweils **Vollersatz** des Originals aus basegame.

| ID | Fraktion | Name | Ueberschreibt |
|---|---|---|---|
| `UAL0001` | Aeon | - | basegame: Armored Command Unit |
| `UEL0001` | UEF | - | basegame: Armored Command Unit |
| `URL0001` | Cybran | - | basegame: Armored Command Unit |
| `XSL0001` | Seraphim | - | basegame: Armored Command Unit |

Geprueft: **keiner dieser Blueprints enthaelt ein `UnitName`-Feld.** Der Anzeigename
kommt ueber die Lokalisierung aus der ID. `General.FactionName` ist gesetzt.
1285 Zeilen (Original: 1282), mit `Enhancements`-Bloecken.

`UEL0001` kollidiert zusaetzlich mit `test21000`.

---

## Mod `test21000`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\test21000\units\
```

| ID | Fraktion | Name | Ueberschreibt |
|---|---|---|---|
| `UEL0001` | UEF | - | basegame: Armored Command Unit |

Vollersatz des UEF-ACU mit acht geaenderten Feldern, alle in `Economy`
(`../08_BESTANDSAUFNAHME.md`). Als Merge waeren es rund 12 Zeilen statt 1283 plus
16 unveraenderte Asset-Kopien.

---

## Pruefstand

| Was | Stand |
|---|---|
| Verzeichnislisten aller fuenf Mods | geprueft 2026-08-05, Summe 218 |
| Ueberschreibungen von basegame | geprueft, 45 IDs |
| Ueberschreibungen von mod-Paketen | **ungeprueft** |
| Namen `nomads-4-loud` | aus Lokalisierung, 98 von 107 |
| Namen `UEF_trans_men` | offen |
