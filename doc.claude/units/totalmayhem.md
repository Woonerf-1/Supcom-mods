# Paket `TotalMayhem`

Zurueck: [README.md](README.md) - [pakete.md](pakete.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\TotalMayhem\mods\TotalMayhem\units\
```

**62 Einheiten, keine einzige wird ueberschrieben** - und der Mod ersetzt selbst nichts.
Ein reines Inhaltspaket.

Stand 2026-08-06 aus `_generiert\units.csv`. Der Ordner `SeraphimTexture\` ist keine
Einheit.

## Eigene ID-Systematik

Alle IDs beginnen mit `BR`; die **Fraktion steckt im 3. Zeichen**:

| Praefix | Fraktion | Beleg |
|---|---|---|
| `BRM` | Cybran | `BRMT1PD_unit.bp` -> `'CYBRAN'` |
| `BRN` | UEF | `BRNT1HPD_unit.bp` -> `'UEF'` |
| `BRO` | Aeon | `BROT1BT_unit.bp` -> `'AEON'` |
| `BRP` | Seraphim | `BRPT1PD_unit.bp` -> `'SERAPHIM'` |

Die restlichen Zeichen kodieren Techstufe (`T1`...`T3`, `EX` fuer Experimental) und
Einheitentyp (`PD` Point Defense, `BT` Bot, `BM` Bomber, `HT` Heavy Tank, `ML` Mobile
Launcher, `SHBM`/`SHPD` Shielded, `EPD` Enhanced PD, `PDRO` Rocket PD).
Domaenen sind daraus **nicht** verlaesslich ableitbar.

---

## Cybran - `BRM` (18)

| ID | Name |
|---|---|
| `BRMST3BOM` | Magna Class |
| `BRMT1BT` | Mite |
| `BRMT1EXM1` | Proton |
| `BRMT1EXPD` | Pen |
| `BRMT1EXPDT2` | Dual Pen |
| `BRMT1PD` | SlyFox |
| `BRMT2EPD` | Anode |
| `BRMT2HT` | Hippo |
| `BRMT2MEDM` | Immortal |
| `BRMT2PD` | SlingShot |
| `BRMT3AVA` | Avalanche Mk.2 |
| `BRMT3BM2` | Dervish |
| `BRMT3BT` | Mastodon |
| `BRMT3LZT` | Trilobyte |
| `BRMT3MCM2` | MadBolo |
| `BRMT3PD` | Tripple Threat |
| `BRMT3PDRO` | Agronar |
| `BRMT3VUL` | Vulture |

## UEF - `BRN` (13)

| ID | Name |
|---|---|
| `BRNT1EXPD` | Mayor |
| `BRNT1HPD` | Thug |
| `BRNT2BM` | Banshee |
| `BRNT2EPD` | Tower Boss |
| `BRNT2MT` | Statue |
| `BRNT2PD2` | Angry Ace |
| `BRNT3ABB` | IronFist |
| `BRNT3BLASP` | Blood Asp |
| `BRNT3BT` | Bull |
| `BRNT3PDRO` | Rocket Pad |
| `BRNT3SHBM` | Mayhem |
| `BRNT3SHPD` | Blockhouse |
| `BRNT3WT` | WarHammer |

## Aeon - `BRO` (14)

| ID | Name |
|---|---|
| `BROT1BT` | Hervour |
| `BROT1EXM1` | Bugbear |
| `BROT1EXPD` | Mizura |
| `BROT1HPD` | Zpyker |
| `BROT1ML` | Wavecrest |
| `BROT1MT` | Bonfire |
| `BROT2ASB` | Amphorak |
| `BROT2EPD` | Daelek |
| `BROT3BT` | Transoma |
| `BROT3HM` | Mogul |
| `BROT3NCM` | Eliash |
| `BROT3PDRO` | Zheela |
| `BROT3SHBM` | Elias |
| `BROT3SHPD` | Mothra |

## Seraphim - `BRP` (17)

| ID | Name |
|---|---|
| `BRPAT2BOMBER` | Vesinnee |
| `BRPAT2FIGBO` | Uhthesinn |
| `BRPEXBOT` | Yenah-lao |
| `BRPEXBTBOT` | Tha-Yath |
| `BRPEXHVBOT` | Athusil |
| `BRPEXPD` | Heth-Athala |
| `BRPEXSHBM` | Thaez-Atha |
| `BRPEXTANK` | Yath-Us |
| `BRPT1EXM1` | Othazyne |
| `BRPT1HT` | Yenshavoh |
| `BRPT1PD` | Hethula-Uttaus |
| `BRPT2BTBOT` | Iltha |
| `BRPT2PD` | Ve-Us |
| `BRPT3BOT` | Thaam-Thuum |
| `BRPT3BT` | Hethaamah |
| `BRPT3ML` | Heth-Zthuha |
| `BRPT3PD` | Athaamla |
