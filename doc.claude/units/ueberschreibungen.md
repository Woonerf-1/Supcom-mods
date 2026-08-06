# Ueberschreibungen - mehrfach belegte Unit-IDs

Zurueck: [README.md](README.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [basegame.md](basegame.md) - [mods.md](mods.md) - [pakete.md](pakete.md) - [usermods.md](usermods.md)

Mods aendern nicht nur eigene Einheiten - sie **ersetzen Blueprints vorhandener
Einheiten**. Steht dieselbe Unit-ID an zwei Ablageorten, gilt im Spiel nur eine Fassung:
die des zuletzt angewandten aktiven Mods (`../02_MODSYSTEM.md` Abschnitt 5 -
Ladereihenfolge alphabetisch nach `uid`, sofern kein `before`/`after` gesetzt ist).

**99 IDs kommen an mehr als einem Ablageort vor.** Vollstaendig ermittelt am 2026-08-05
aus allen 19 Verzeichnislisten - nicht durch Parsen der Dokumentation.

---

## Uebersicht

| Ueberschreibender Mod | ersetzt basegame | ersetzt mod | Summe |
|---|---:|---:|---:|
| `UEF_trans_men` | 39 | 49 | 88 |
| `NOMADS-try_b4_ur_BI` | 1 | 5 | 6 |
| `commanders` | 4 | 0 | 4 |
| `nomads-4-loud` | 1 | 0 | 1 |
| `test21000` | 1 | 0 | 1 |

`UEL0001` wird von `commanders` **und** `test21000` ersetzt, daher 99 verschiedene IDs
statt 100.

**Alle ueberschreibenden Mods liegen in `usermods\`.** Die 13 Pakete aus `gamedata`
kollidieren untereinander nicht - jede ID kommt dort nur einmal vor.

## Woher die ersetzten Blueprints stammen

| Quelle | Kategorie | Einheiten | ersetzt | Anteil |
|---|---|---:|---:|---:|
| `units` | basegame | 432 | 45 | 10 % |
| `BrewLAN_LOUD` | mod | 149 | 22 | 15 % |
| `BlackOpsUnleashed` | mod | 86 | 16 | 19 % |
| `LOUD Unit Additions` | mod | 26 | 8 | 31 % |
| `BattlePack` | mod | 25 | 4 | 16 % |
| `4DC` | mod | 15 | 4 | 27 % |
| **Summe** | | | **99** | |

Die uebrigen sieben Pakete werden nicht angetastet: `civ_units`, `TotalMayhem`,
`BrewResearch`, `BrewIntel`, `CityGeneration`, `Spomeniki`, `CrateDrop`, `BlackopsACUs`.

Bemerkenswert: `LOUD Unit Additions` und `4DC` haben anteilig am meisten Ueberschreibungen.
Bei `4DC` ist das besonders heikel - das Paket ist eine **Kompatibilitaetsschicht**
zwischen den anderen Paketen. Wird sie ersetzt, kann genau die Vermittlung ausfallen,
fuer die sie gedacht ist.

## Dreifachbelegung

| ID | Kette |
|---|---|
| `UEL0001` | `units` -> `commanders` -> `test21000` |

Nach der uid-Sortierung (`12345678901234567890test21000` vor `THISoneIS4myBOImax`) wird
**`commanders` zuletzt angewandt und gewinnt**. Abgeleitet aus der Regel, im Spiel nicht
geprueft.

---

# `UEF_trans_men` (88 von 97 eigenen Blueprints)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\UEF_trans_men\units\
```

**91 Prozent des Mods sind Ueberschreibungen.** Nur 9 IDs sind eigenstaendig:

`MKT0409` `SAB0104` `SAB1312` `SEB1312` `SRA4212` `SRB1312` `SRB4313` `SRB5383`
`SSB1312`

Erster Kandidat fuers Aufraeumen (`../12_NEUSCHNITT.md`).

## ersetzt basegame (39)

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

## ersetzt `BrewLAN_LOUD` (18)

`SAA0306` `SAA0313` `SEA0310` `SEA0313` `SEB3404` `SEL0324` `SES0319` `SRA0201`
`SRA0313` `SRB2221` `SRB4402` `SRL0319` `SRL0320` `SSA0001` `SSA0313` `SSA0314`
`SSL0324` `SSL0403`

## ersetzt `BlackOpsUnleashed` (16)

`BAB1202` `BAB1302` `BAB2308` `BAB4307` `BAL0310` `BEB1202` `BEB1302` `BRB1202`
`BRB1302` `BSA0310` `BSB1202` `BSB1302` `BSB2402` `BSB4205` `BSL0005` `BSLK004`

## ersetzt `LOUD Unit Additions` (7)

`UABSSG01` `UEBSSG01` `URBSSG01` `VEB2302` `WRL0404` `WSB0104` `XSBSSG01`

## ersetzt `BattlePack` (4)

`WEB0404` `WEB4301` `WEL0401` `WSL0404`

## ersetzt `4DC` (4)

`UAL0310` `UAL0402` `UEL0402` `UES0206`

---

# `NOMADS-try_b4_ur_BI` (6 von 9)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\NOMADS-try_b4_ur_BI\units\
```

| ID | ersetzt aus | Kategorie | Name im Mod | Bewertung |
|---|---|---|---|---|
| `SAB4401` | BrewLAN_LOUD | mod | Pillar of Prominence | Originalname |
| `SEA0106` | BrewLAN_LOUD | mod | Seagull | Originalname |
| `SEA0401` | BrewLAN_LOUD | mod | AC-500 Centurion | Originalname |
| `SSB3301` | BrewLAN_LOUD | mod | Eye of pifpuff | **umbenannt** |
| `WAB0201` | LOUD Unit Additions | mod | Saviour | Originalname |
| `XEA0002` | units | basegame | - (kein `UnitName`) | Original: Recon Satellite |

Eigenstaendig sind nur `CAS0401` (Deluge Class), `CNB1202` (Eckard) und `CNB1302`
(Guenter).

---

# `commanders` (4)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\commanders\units\
```

| ID | ersetzt aus | Fraktion |
|---|---|---|
| `UAL0001` | units | Aeon |
| `UEL0001` | units | UEF |
| `URL0001` | units | Cybran |
| `XSL0001` | units | Seraphim |

Die vier ACUs, jeweils als **Vollersatz** (1285 Zeilen, Original 1282), nicht als Merge.
Kein `UnitName`-Feld; `Enhancements`-Bloecke vorhanden.

---

# `test21000` (1)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\test21000\units\UEL0001\
```

`UEL0001` aus `units` - Vollersatz mit **acht geaenderten Feldern**, alle in `Economy`
(`../08_BESTANDSAUFNAHME.md`). Als Merge waeren es rund 12 Zeilen statt 1283 plus
16 Asset-Kopien.

---

# `nomads-4-loud` (1)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\nomads-4-loud\units\XSS0302\
```

`XSS0302` aus `units` - Original: **Hauthuum**, Seraphim-U-Boot. Die einzige ID dieses
Mods ausserhalb des Nomads-Namensraums.

---

## Was daraus folgt

1. **Ein Name in den Bestandslisten ist der Stand des jeweiligen Ablageorts, nicht
   zwingend der im Spiel.** Bei mehrfach belegten IDs haengt es davon ab, welche Mods
   aktiv sind.
2. **Vor jeder Blueprint-Aenderung hier nachsehen.** Sonst wird die eigene Aenderung von
   einem anderen Mod verdeckt - oder verdeckt dessen Aenderung.
3. **`Merge = true` schuetzt nicht.** Ein Merge wirkt gegenueber dem Original, nicht
   gegenueber einem spaeter angewandten Vollersatz.
4. **Die gamedata-Pakete sind untereinander konfliktfrei.** Alle 99 Faelle entstehen
   durch Usermods, 88 davon durch einen einzigen.

## Ermittlungsverfahren

Aus Verzeichnislisten, nicht aus der Dokumentation:

```
1. Fuer jeden der 19 Ablageorte list_directory -> ID-Liste
2. Alle Listen mit Herkunftsspalte zusammenfuehren
3. IDs zaehlen, die in mehr als einem Ablageort vorkommen
```

Eine fruehere Ermittlung hatte die ID-Listen aus der Dokumentation geparst und dabei auch
IDs erfasst, die dort nur im Fliesstext vorkamen - etwa `UAM0004`, `UEM0006`, `URM0004`,
`XSM0001`, die faelschlich als ueberschrieben galten. Aus der Dokumentation
zurueckzuparsen ist keine Quelle.

## Grenzen dieser Aufstellung

Erfasst sind **Blueprint-Dateien**. Nicht erfasst:

- **`ModBlueprints()`-Hooks** aendern Blueprints programmatisch, ohne eigene Datei
  (`../03_BLUEPRINTS.md` Abschnitt 5). LOUDs eigener Mod `Enhanced Resources` tut das.
- **Verhaltens-Hooks** (`hook\lua\sim\Unit.lua` u. ae.) aendern kein Blueprint, wohl aber
  das Verhalten aller Einheiten.
- **Nicht-Unit-Blueprints** (Projektile, Props, Meshes, Emitter).
- **Die 24 LOUD-eigenen Mods** aus `loud_misc.scd` (`../02_MODSYSTEM.md` Abschnitt 6.5) -
  bislang nicht auf Einheiten geprueft.
