# Mod-Pakete - Detaillisten

Zurueck: [README.md](README.md) - [mods.md](mods.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [basegame.md](basegame.md) - [usermods.md](usermods.md) - [ueberschreibungen.md](ueberschreibungen.md)

Alle Pakete aus `gamedata.entpackt\` ausser dem Basispaket `units`.

**525 Einheiten in 13 Paketen.** Geprueft am 2026-08-05 gegen die Verzeichnislisten.

Spalte "Ueberschrieben von": der Usermod, der diesen Blueprint ersetzt. `-` heisst nicht
ueberschrieben. **Namen sind hier noch nicht erfasst** - Fraktion und Domaene aus der ID
abgeleitet.

| Abschnitt | Einheiten | ueberschrieben |
|---|---:|---:|
| [civ_units](#civ_units) | 117 | 0 |
| [BrewLAN_LOUD](#brewlan_loud) | 149 | 22 |
| [BlackOpsUnleashed](#blackopsunleashed) | 86 | 16 |
| [TotalMayhem](#totalmayhem) | 62 | 0 |
| [LOUD Unit Additions](#loud-unit-additions) | 26 | 8 |
| [BattlePack](#battlepack-wyvern) | 25 | 4 |
| [BrewResearch](#brewresearch) | 20 | 0 |
| [4DC](#4dc) | 15 | 4 |
| [BlackopsACUs](#blackopsacus) | 9 | 0 |
| [CityGeneration](#citygeneration) | 8 | 0 |
| [BrewIntel](#brewintel) | 5 | 0 |
| [Spomeniki](#spomeniki) | 2 | 0 |
| [CrateDrop](#cratedrop) | 1 | 0 |
| **Summe** | **525** | **54** |

**Die Pakete kollidieren untereinander nicht** - jede ID kommt in `gamedata` nur einmal
vor. Alle 54 Ueberschreibungen kommen aus `usermods\`.

---

## civ_units

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\civ_units\units\
```

117 Einheiten, keine ueberschrieben. Das 3. Zeichen `C` steht fuer **Civilian**, nicht
fuer eine Domaene. Dazu fuenf Objekte mit sprechendem Namen statt ID-Systematik.

**Aeon (1)** `UAC1301`

**UEF (62)**
`UEC0001` `UEC1101` `UEC1201` `UEC1301` `UEC1401` `UEC1501` `UEC1901` `UEC1902`
`UEC1903` `UEC1904` `UEC1905` `UEC1906` `UEC1907` `XEC1301` `XEC1401` `XEC1501`
`XEC1908` `XEC1909` `XEC8001` `XEC8002` `XEC8003` `XEC8004` `XEC8005` `XEC8006`
`XEC8007` `XEC8008` `XEC8009` `XEC8010` `XEC8011` `XEC8012` `XEC8013` `XEC8014`
`XEC8015` `XEC8016` `XEC8017` `XEC8018` `XEC8019` `XEC8020` `XEC9001` `XEC9002`
`XEC9003` `XEC9004` `XEC9005` `XEC9006` `XEC9007` `XEC9008` `XEC9009` `XEC9010`
`XEC9011` `XEC9203` `XEC9204` `XEC9205` `XEC9206` `XEC9207` `XEC9208` `XEC9301`
`XEC9302` `XEC9303` `XEC9901` `XEC9902` `XEC9903`

**Cybran (47)**
`URC1902` `XRC1101` `XRC1502` `XRC2101` `XRC2201` `XRC2301` `XRC2401` `XRC8001`
`XRC8002` `XRC8003` `XRC8004` `XRC8005` `XRC8006` `XRC8007` `XRC8008` `XRC8009`
`XRC8010` `XRC8011` `XRC8012` `XRC8013` `XRC8014` `XRC8015` `XRC8016` `XRC8017`
`XRC8018` `XRC8019` `XRC8020` `XRC8101` `XRC8102` `XRC8103` `XRC8104` `XRC8105`
`XRC8106` `XRC8107` `XRC8108` `XRC8109` `XRC8110` `XRC8111` `XRC8112` `XRC8113`
`XRC8114` `XRC8115` `XRC8116` `XRC8117` `XRC8118` `XRC8119` `XRC8120`

**Seraphim (3)** `XSC1301` `XSC8001` `XSC9002`

**Ohne ID-Systematik (5)** - Strassenmoeblierung
`UEF_Bus` `UEF_Car1` `UEF_Fence` `UEF_Streetlight_01` `UEF_truck`

---

## BrewLAN_LOUD

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_LOUD\units\
```

149 Einheiten - das groesste Einzelpaket nach `units`. 22 werden ueberschrieben.

### Ueberschrieben (22)

| ID | Ueberschrieben von |
|---|---|
| `SAA0306` | UEF_trans_men |
| `SAA0313` | UEF_trans_men |
| `SAB4401` | NOMADS-try_b4_ur_BI |
| `SEA0106` | NOMADS-try_b4_ur_BI |
| `SEA0310` | UEF_trans_men |
| `SEA0313` | UEF_trans_men |
| `SEA0401` | NOMADS-try_b4_ur_BI |
| `SEB3404` | UEF_trans_men |
| `SEL0324` | UEF_trans_men |
| `SES0319` | UEF_trans_men |
| `SRA0201` | UEF_trans_men |
| `SRA0313` | UEF_trans_men |
| `SRB2221` | UEF_trans_men |
| `SRB4402` | UEF_trans_men |
| `SRL0319` | UEF_trans_men |
| `SRL0320` | UEF_trans_men |
| `SSA0001` | UEF_trans_men |
| `SSA0313` | UEF_trans_men |
| `SSA0314` | UEF_trans_men |
| `SSB3301` | NOMADS-try_b4_ur_BI |
| `SSL0324` | UEF_trans_men |
| `SSL0403` | UEF_trans_men |

### Aeon (28)

`SAA0106` `SAA0201` `SAA0211` `SAA0306` `SAA0313` `SAA0314` `SAB0401` `SAB2103`
`SAB2220` `SAB2221` `SAB2222` `SAB2306` `SAB2308` `SAB2311` `SAB4401` `SAB5104`
`SAB5210` `SAB5301` `SAL0209` `SAL0311` `SAL0319` `SAL0320` `SAL0321` `SAL0323`
`SAL0324` `SAL0401` `SAS0401` `SAS3324`

### UEF (40)

`SEA0106` `SEA0201` `SEA0211` `SEA0212` `SEA0307` `SEA0310` `SEA0313` `SEA0314`
`SEA0401` `SEA3101` `SEB0401` `SEB2103` `SEB2211` `SEB2220` `SEB2221` `SEB2222`
`SEB2308` `SEB2311` `SEB2320` `SEB2401` `SEB2402` `SEB2404` `SEB3303` `SEB3404`
`SEB4303` `SEB4401` `SEB5104` `SEB5210` `SEB5310` `SEB5311` `SEB5381` `SEL0119`
`SEL0319` `SEL0320` `SEL0321` `SEL0324` `SES0204` `SES0219` `SES0319` `SES3324`

### Cybran (41)

`SRA0106` `SRA0201` `SRA0211` `SRA0212` `SRA0306` `SRA0307` `SRA0313` `SRA0314`
`SRA0315` `SRA3101` `SRB0401` `SRB2103` `SRB2220` `SRB2221` `SRB2222` `SRB2306`
`SRB2311` `SRB2391` `SRB2402` `SRB4401` `SRB4402` `SRB5104` `SRB5210` `SRB5310`
`SRB5311` `SRB5312` `SRB5380` `SRL0000` `SRL0209` `SRL0310` `SRL0311` `SRL0312`
`SRL0316` `SRL0319` `SRL0320` `SRL0321` `SRL0324` `SRL0401` `SRS0219` `SRS0319`
`SRS3324`

### Seraphim (38)

`SSA0001` `SSA0002` `SSA0106` `SSA0201` `SSA0211` `SSA0305` `SSA0306` `SSA0307`
`SSA0313` `SSA0314` `SSB0401` `SSB2103` `SSB2121` `SSB2220` `SSB2221` `SSB2222`
`SSB2306` `SSB2311` `SSB2380` `SSB2404` `SSB3301` `SSB4401` `SSB5104` `SSB5210`
`SSB5301` `SSB5401` `SSL0001` `SSL0219` `SSL0311` `SSL0319` `SSL0320` `SSL0321`
`SSL0324` `SSL0403` `SSL0404` `SSL0405` `SSS0306` `SSS3324`

### Ohne Fraktionskennung (2)

`ZZZ2220` `ZZZ5301`

---

## BlackOpsUnleashed

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\units\
```

**86 Einheiten** (fruehere Angabe 84 war falsch). 16 werden ueberschrieben, alle von
`UEF_trans_men`.

Enthaelt die Teleport-Jammer `BAB4209` `BEB4209` `BRB4209` `BSB4209`. Auf sie verweist
`BuildingTemplates.lua` - der Grund fuer 15.041 Warnungen, wenn dieser Mod **nicht aktiv**
ist (`../15_LOG.md` R-01).

### Ueberschrieben von UEF_trans_men (16)

`BAB1202` `BAB1302` `BAB2308` `BAB4307` `BAL0310` `BEB1202` `BEB1302` `BRB1202`
`BRB1302` `BSA0310` `BSB1202` `BSB1302` `BSB2402` `BSB4205` `BSL0005` `BSLK004`

### Aeon (16)

`BAB1106` `BAB1202` `BAB1302` `BAB2303` `BAB2306` `BAB2308` `BAB4209` `BAB4307`
`BAB4309` `BAL0110` `BAL0206` `BAL0310` `BAL0401` `BAL0402` `BAL0403` `BALK003`

### UEF (14)

`BEA0402` `BEA0403` `BEB1106` `BEB1202` `BEB1302` `BEB2303` `BEB4209` `BEB4309`
`BEL0211` `BEL0307` `BEL0308` `BEL0402` `BELK002` `BES0402` `XEL0307`

### Cybran (23)

`BRA0409` `BRB1106` `BRB1202` `BRB1302` `BRB2303` `BRB2306` `BRB4209` `BRB4309`
`BRB4401` `BRL0006` `BRL0007` `BRL0008` `BRL0009` `BRL0010` `BRL0011` `BRL0205`
`BRL0307` `BRL0401` `BRLK001` `BRLK005` `BRS0304` `BRS0305` `BRS0402` `XRS0402`

### Seraphim (32)

`BSA0003` `BSA0004` `BSA0310` `BSB0405` `BSB1106` `BSB1202` `BSB1302` `BSB2306`
`BSB2402` `BSB4205` `BSB4209` `BSB4309` `BSL0003` `BSL0004` `BSL0005` `BSL0007`
`BSL0008` `BSL0009` `BSL0010` `BSL0106` `BSL0206` `BSL0306` `BSL0310` `BSL0401`
`BSL0403` `BSL0404` `BSL0406` `BSLK004` `BSS0206` `BSS0306` `BSS0401`

Die `K`-Kennung (`BALK003` `BELK002` `BRLK001` `BRLK005` `BSLK004`) folgt keiner
bekannten Systematik. `XEL0307` und `XRS0402` tragen Basisspiel-Praefixe, liegen aber
hier - sie kollidieren nicht mit basegame.

---

## TotalMayhem

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\TotalMayhem\mods\TotalMayhem\units\
```

62 Einheiten, keine ueberschrieben. Der Ordner `SeraphimTexture\` ist keine Einheit.

**Eigene ID-Systematik.** Alle IDs beginnen mit `BR`; die Fraktion steckt im **3. Zeichen**.
Zuordnung aus `Categories` in vier Stichproben-Blueprints:

| Praefix | Fraktion | Beleg |
|---|---|---|
| `BRM` | Cybran | `BRMT1PD_unit.bp` -> `'CYBRAN'` |
| `BRN` | UEF | `BRNT1HPD_unit.bp` -> `'UEF'` |
| `BRO` | Aeon | `BROT1BT_unit.bp` -> `'AEON'` |
| `BRP` | Seraphim | `BRPT1PD_unit.bp` -> `'SERAPHIM'` |

Die restlichen Zeichen kodieren Techstufe (`T1`...`T3`, `EX` fuer Experimental) und
Einheitentyp (`PD` Point Defense, `BT` Bot, `BM` Bomber, `HT` Heavy Tank, `ML` Mobile
Launcher, `SHBM`/`SHPD` Shielded). Domaenen sind daraus **nicht** verlaesslich ableitbar.

**Cybran - `BRM` (18)**
`BRMST3BOM` `BRMT1BT` `BRMT1EXM1` `BRMT1EXPD` `BRMT1EXPDT2` `BRMT1PD` `BRMT2EPD`
`BRMT2HT` `BRMT2MEDM` `BRMT2PD` `BRMT3AVA` `BRMT3BM2` `BRMT3BT` `BRMT3LZT`
`BRMT3MCM2` `BRMT3PD` `BRMT3PDRO` `BRMT3VUL`

**UEF - `BRN` (13)**
`BRNT1EXPD` `BRNT1HPD` `BRNT2BM` `BRNT2EPD` `BRNT2MT` `BRNT2PD2` `BRNT3ABB`
`BRNT3BLASP` `BRNT3BT` `BRNT3PDRO` `BRNT3SHBM` `BRNT3SHPD` `BRNT3WT`

**Aeon - `BRO` (14)**
`BROT1BT` `BROT1EXM1` `BROT1EXPD` `BROT1HPD` `BROT1ML` `BROT1MT` `BROT2ASB`
`BROT2EPD` `BROT3BT` `BROT3HM` `BROT3NCM` `BROT3PDRO` `BROT3SHBM` `BROT3SHPD`

**Seraphim - `BRP` (17)**
`BRPAT2BOMBER` `BRPAT2FIGBO` `BRPEXBOT` `BRPEXBTBOT` `BRPEXHVBOT` `BRPEXPD`
`BRPEXSHBM` `BRPEXTANK` `BRPT1EXM1` `BRPT1HT` `BRPT1PD` `BRPT2BTBOT` `BRPT2PD`
`BRPT3BOT` `BRPT3BT` `BRPT3ML` `BRPT3PD`

---

## LOUD Unit Additions

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loud_units\mods\LOUD Unit Additions\units\
```

26 Einheiten, **8 ueberschrieben** - der hoechste Anteil aller Pakete (31 Prozent).
Set-Praefixe `L`, `V`, `W`; dazu `UAB8765` und Geschwister mit Basisspiel-Praefix.

| ID | Ueberschrieben von |
|---|---|
| `UABSSG01` | UEF_trans_men |
| `UEBSSG01` | UEF_trans_men |
| `URBSSG01` | UEF_trans_men |
| `VEB2302` | UEF_trans_men |
| `WAB0201` | NOMADS-try_b4_ur_BI |
| `WRL0404` | UEF_trans_men |
| `WSB0104` | UEF_trans_men |
| `XSBSSG01` | UEF_trans_men |

**Aeon (7)** `LAB2320` `UAB8765` `UABSSG01` `UABSSG02` `UALX401` `VAB2302` `WAB0201`
**UEF (6)** `LEB2320` `UEB8765` `UEBSSG01` `UEBSSG02` `VEB2302` `WEL0405`
**Cybran (6)** `LRB2320` `URB8765` `URBSSG01` `URBSSG02` `VRB2302` `WRL0404`
**Seraphim (7)** `LSB2320` `VSB2302` `WSB0104` `XSB8765` `XSBSSG01` `XSBSSG02` `XSS0403`

---

## BattlePack (Wyvern)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\WyvernBattlePack\mods\BattlePack\units\
```

25 Einheiten, durchgaengig Set-Praefix `W`. 4 ueberschrieben, alle von `UEF_trans_men`:
`WEB0404` `WEB4301` `WEL0401` `WSL0404`

**Aeon (3)** `WAL0401` `WAL4404` `WAS0332`
**UEF (12)** `WEB0404` `WEB4301` `WEL0207` `WEL0302` `WEL0304` `WEL03041` `WEL0305`
`WEL0309` `WEL0401` `WEL0416` `WEL4404` `WES0303`
**Cybran (6)** `WRA0401` `WRL0207` `WRL0301` `WRL0305` `WRL0309` `WRL1466`
**Seraphim (4)** `WSL0202` `WSL0205` `WSL0308` `WSL0404`

`WEL03041` ist fuenfstellig und faellt aus der Systematik.

---

## BrewResearch

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_Units\BrewResearch\units\
```

20 Einheiten, alle Gebaeude, gleichmaessig auf vier Fraktionen verteilt. Keine
ueberschrieben.

**Aeon (5)** `SAB1101` `SAB1201` `SAB9101` `SAB9201` `SAB9301`
**UEF (5)** `SEB1101` `SEB1201` `SEB9101` `SEB9201` `SEB9301`
**Cybran (5)** `SRB1101` `SRB1201` `SRB9101` `SRB9201` `SRB9301`
**Seraphim (5)** `SSB1101` `SSB1201` `SSB9101` `SSB9201` `SSB9301`

---

## 4DC

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\4D-CompatibilityPack\mods\4DC\units\
```

15 Einheiten. **Kompatibilitaetsschicht zwischen den Paketen** - 4 werden von
`UEF_trans_men` ueberschrieben: `UAL0310` `UAL0402` `UEL0402` `UES0206`.

Das ist besonders heikel: wird die Vermittlungsschicht ersetzt, kann genau die Funktion
ausfallen, fuer die sie gedacht ist.

Trotz Basisspiel-Praefixen kollidiert **keine** dieser IDs mit basegame - es sind eigene
Einheiten.

**Aeon (6)** `UAA0206` (Luft) - `UAB2306` (Gebaeude) - `UAL0108` `UAL0204` `UAL0310`
`UAL0402` (Land)
**UEF (6)** `UEB2306` (Gebaeude) - `UEL0107` `UEL0108` `UEL0402` `XEL0308` (Land) -
`UES0206` (See)
**Cybran (2)** `URB2306` (Gebaeude) - `URL0305` (Land)
**Seraphim (1)** `XSA0201` (Luft)

---

## BlackopsACUs

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackopsACUs\units\
```

9 Einheiten, Set-Praefix `E`. Alternative Kommandanten. Keine ueberschrieben.

**Aeon (1)** `EAL0001`
**UEF (1)** `EEL0001`
**Cybran (1)** `ERL0001`
**Seraphim (6)** `ESB0001` `ESB0002` `ESB0003` `ESB0004` `ESB0005` `ESL0001`

---

## CityGeneration

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_Plenae\CityGeneration\units\
```

8 Einheiten, keine ueberschrieben. `C` steht wie in `civ_units` fuer Civilian.
Daneben zwei Sammel-Blueprints im Modwurzelverzeichnis: `UEC_UCivs.bp`, `UEF_XCivs.bp`.

**UEF (6)** `SEB5101` `SEC0103` `SEC1101` `SEC1201` `SEC1202` `SEC1203`
**Ohne Fraktionskennung (2)** `ZZCITYBLOCK9` `ZZCITYBLOCK9W`

---

## BrewIntel

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_Units\BrewIntel\units\
```

5 Einheiten, keine ueberschrieben.

**Aeon (1)** `SAB3301`
**UEF (2)** `SEB3301` `SEL3401`
**Cybran (1)** `SRB3301`
**Seraphim (1)** `SSB3302`

---

## Spomeniki

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_Plenae\Spomeniki\units\
```

2 Einheiten (Denkmaeler), keine ueberschrieben.

**Seraphim (1)** `SSB23SN`
**Ohne Fraktionskennung (1)** `SNLMER1`

Der dritte Untermod `BrewLAN_Plenae\Logger` enthaelt keine Einheiten.

---

## CrateDrop

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_RNG\CrateDrop\units\
```

1 Einheit: `ZZCRATE` (Beutekiste, fraktionslos).

---

## Ablagemuster

```
gamedata.entpackt\<Archiv>\units\<ID>\<ID>_unit.bp                       civ_units
gamedata.entpackt\<Archiv>\mods\<Mod>\units\<ID>\<ID>_unit.bp            die meisten
gamedata.entpackt\brewlan\mods\<Mod>\<Untermod>\units\<ID>\<ID>_unit.bp  brewlan
```

`brewlan` ist tiefer verschachtelt: `BrewLAN_Units`, `BrewLAN_Plenae` und `BrewLAN_RNG`
haben keinen eigenen `units\`-Ordner, sondern enthalten weitere Mods, die je einen haben.

## Pruefstand

| Was | Stand |
|---|---|
| Verzeichnislisten aller 13 Pakete | geprueft 2026-08-05, Summe 525 |
| Kollisionen untereinander | geprueft: keine |
| Ueberschreibungen durch Usermods | geprueft: 54 |
| Namen | offen - zuerst nach `loc`-Ordnern in den Paketen sehen |
| Fraktionszuordnung | aus der ID abgeleitet, ausser TotalMayhem (4 Stichproben) |
