# Kleine Pakete

Zurueck: [README.md](README.md) - [pakete.md](pakete.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)

Vier Pakete mit zusammen **75 Einheiten**, davon 24 mehrfach belegt.
Stand 2026-08-06 aus `_generiert\units.csv`.

Spalte "Auch in": weitere Ablageorte derselben ID. `-` heisst: nur hier.

| Paket | Einheiten | mehrfach belegt |
|---|---:|---:|
| [LOUD Unit Additions](#loud-unit-additions) | 26 | 12 |
| [BattlePack (Wyvern)](#battlepack-wyvern) | 25 | 4 |
| [4DC](#4dc) | 15 | 4 |
| [BlackopsACUs](#blackopsacus) | 9 | 4 |

---

## LOUD Unit Additions

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loud_units\mods\LOUD Unit Additions\units\
```

26 Einheiten, **12 mehrfach belegt** (46 Prozent) - der hoechste Anteil aller
Inhaltspakete. Betroffen sind vor allem die Lagergebaeude, die `LOUD Integrated Storage`
ebenfalls anfasst.

Vier Vierergruppen je Fraktion: Schildgeneratoren (`*SSG01`, `*SSG02`), Lager (`*8765`),
Artillerie (`V*2302`) und Sondereinheiten (`L*2320`).

| ID | Name | Auch in |
|---|---|---|
| `LAB2320` | Zion | - |
| `LEB2320` | Jackhammer | - |
| `LRB2320` | Trigger | - |
| `LSB2320` | Incubus | - |
| `UAB8765` | Resource Storage Facility | LOUD Integrated Storage |
| `UABSSG01` | Luminesc | LOUD Integrated Storage, UEF_trans_men |
| `UABSSG02` | Luminesc | - |
| `UALX401` | Angel | - |
| `UEB8765` | Resource Storage Facility | LOUD Integrated Storage |
| `UEBSSG01` | SSD Hope | LOUD Integrated Storage, UEF_trans_men |
| `UEBSSG02` | SSD Hope | - |
| `URB8765` | Resource Storage Facility | LOUD Integrated Storage |
| `URBSSG01` | ED-X | LOUD Integrated Storage, UEF_trans_men |
| `URBSSG02` | ED-X | - |
| `VAB2302` | Apparitioner | - |
| `VEB2302` | Flayer II | UEF_trans_men |
| `VRB2302` | Sky Bloom | - |
| `VSB2302` | Tuvatham | - |
| `WAB0201` | Saviour | NOMADS-try_b4_ur_BI |
| `WEL0405` | King Kraptor | - |
| `WRL0404` | Megaroach | UEF_trans_men |
| `WSB0104` | Dehgarwof | UEF_trans_men |
| `XSB8765` | Hala-Vishual | LOUD Integrated Storage |
| `XSBSSG01` | Thanatos | LOUD Integrated Storage, UEF_trans_men |
| `XSBSSG02` | Thanatos | - |
| `XSS0403` | Vergra | - |

Auffaellig: die `SSG01`-Varianten sind dreifach belegt, die `SSG02`-Varianten gar nicht.
`UALX401` bricht die ID-Systematik (`UAL` + `X401`).

---

## BattlePack (Wyvern)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\WyvernBattlePack\mods\BattlePack\units\
```

25 Einheiten, durchgaengig Set-Praefix `W`. Vier werden von `UEF_trans_men` ersetzt.

| ID | Name | Auch in |
|---|---|---|
| `WAL0401` | Universal Colossus | - |
| `WAL4404` | Maruda | - |
| `WAS0332` | Shadow of Intent | - |
| `WEB0404` | Turtle | UEF_trans_men |
| `WEB4301` | Protector | UEF_trans_men |
| `WEL0207` | Sharp Shooter | - |
| `WEL0302` | Wrecker | - |
| `WEL0304` | Rommel | - |
| `WEL03041` | Walrus | - |
| `WEL0305` | Pegasus | - |
| `WEL0309` | Banisher | - |
| `WEL0401` | Littleman | UEF_trans_men |
| `WEL0416` | Dragonite | - |
| `WEL4404` | Star Adder | - |
| `WES0303` | Poseidon Class | - |
| `WRA0401` | Soul Ripper II | - |
| `WRL0207` | Cocoon | - |
| `WRL0301` | SeaLion | - |
| `WRL0305` | Echidna | - |
| `WRL0309` | Python | - |
| `WRL1466` | Storm Strider | - |
| `WSL0202` | Onyzum | - |
| `WSL0205` | Beshlas | - |
| `WSL0308` | Otheeka | - |
| `WSL0404` | Yath-Yen | UEF_trans_men |

`WEL03041` ist fuenfstellig und faellt aus der Systematik.

---

## 4DC

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\4D-CompatibilityPack\mods\4DC\units\
```

15 Einheiten. **Kompatibilitaetsschicht zwischen den Paketen** - vier werden von
`UEF_trans_men` ersetzt. Das ist besonders heikel: wird die Vermittlungsschicht
ueberschrieben, kann genau die Funktion ausfallen, fuer die sie gedacht ist.

Trotz Basisspiel-Praefixen kollidiert **keine** dieser IDs mit basegame - es sind eigene
Einheiten.

| ID | Name | Auch in |
|---|---|---|
| `UAA0206` | Abolisher | - |
| `UAB2306` | Anachronon | - |
| `UAL0108` | Artos | - |
| `UAL0204` | Predator | - |
| `UAL0310` | Vindicator | UEF_trans_men |
| `UAL0402` | Overlord | UEF_trans_men |
| `UEB2306` | Brimstone | - |
| `UEL0107` | Caiman | - |
| `UEL0108` | Crusher | - |
| `UEL0402` | Rampage | UEF_trans_men |
| `UES0206` | Barnacle | UEF_trans_men |
| `URB2306` | Beholder | - |
| `URL0305` | Crawfish | - |
| `XEL0308` | Hermes | - |
| `XSA0201` | Shyeld | - |

---

## BlackopsACUs

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackopsACUs\units\
```

9 Einheiten, Set-Praefix `E`. Alternative Kommandanten.

| ID | Name | Auch in |
|---|---|---|
| `EAL0001` | - | Enhanced Commanders |
| `EEL0001` | - | Enhanced Commanders |
| `ERL0001` | - | Enhanced Commanders |
| `ESL0001` | - | Enhanced Commanders |
| `ESB0001` | Lamdba Emitter | - |
| `ESB0002` | Lamdba Emitter | - |
| `ESB0003` | Lamdba Emitter | - |
| `ESB0004` | Lamdba Emitter | - |
| `ESB0005` | Lamdba Emitter | - |

Die vier ACU-Blueprints sind gross (65-88 KB) und fuehren **kein `UnitName`-Feld** - wie
die ACUs in `usermods\commanders`. Alle vier werden vom LOUD-eigenen Mod
`Enhanced Commanders` ersetzt ([loud_misc.md](loud_misc.md)).

Die fuenf `ESB`-Eintraege sind klein (rund 2 KB) und tragen alle denselben `HelpText`.
"Lamdba" ist ein Tippfehler im Original.
