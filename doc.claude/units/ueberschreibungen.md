# Ueberschreibungen - mehrfach belegte Unit-IDs

Zurueck: [README.md](README.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [basegame.md](basegame.md) - [mods.md](mods.md) - [usermods.md](usermods.md)

Mods aendern nicht nur eigene Einheiten - sie **ersetzen Blueprints vorhandener
Einheiten**. Steht dieselbe Unit-ID an zwei Ablageorten, gilt im Spiel nur eine Fassung:
die des zuletzt angewandten aktiven Mods (`../02_MODSYSTEM.md` Abschnitt 5 -
Ladereihenfolge alphabetisch nach `uid`, sofern kein `before`/`after` gesetzt ist).

**98 IDs sind mehrfach belegt.** Diese Zahl stammt aus einem Abgleich der
Markdown-Listen und ist **teilweise fehlerhaft** - siehe Warnung unten.

---

## WARNUNG: Zahlen nur teilweise geprueft

Die urspruengliche Ermittlung hat die ID-Listen aus der Dokumentation geparst. Dabei
wurden auch IDs erfasst, die dort nur **im Fliesstext** vorkamen - etwa in der Tabelle
"Abweichungen von der ID-Systematik". Sie wurden faelschlich dem Mod zugeordnet, unter
dessen Abschnitt sie zufaellig standen.

Nachgewiesene Falschtreffer (2026-08-05): `UAM0004`, `UEM0006`, `URM0004`, `XSM0001`
waren als von `UEF_trans_men` ueberschrieben gefuehrt, liegen aber gar nicht in dessen
`units\`-Ordner.

**Geprueft gegen Verzeichnislisten:**

| Mod | Stand |
|---|---|
| `UEF_trans_men` | geprueft: 97 eigene IDs, davon 39 Ueberschreibungen von basegame |
| `commanders`, `test21000`, `nomads-4-loud`, `NOMADS-try_b4_ur_BI` | geprueft (klein) |
| Ueberschreibungen von `mod`-Paketen (BrewLAN, blackops, ...) | **ungeprueft** |

**Verlaesslich ist derzeit nur:** 45 der 432 basegame-Blueprints werden ueberschrieben.
Alles Weitere ist neu zu ermitteln - aus Verzeichnislisten, nicht aus Markdown.
Steht in `../TODO.md`.

---

## Geprueft: Ueberschreibungen von basegame (45)

| Ueberschreibender Mod | IDs |
|---|---:|
| `UEF_trans_men` | 39 |
| `commanders` | 4 |
| `test21000` | 1 (`UEL0001`, zugleich `commanders`) |
| `nomads-4-loud` | 1 |
| `NOMADS-try_b4_ur_BI` | 1 |
| **verschiedene IDs** | **45** |

### `UEF_trans_men` -> basegame (39)

`UAA0204` `UAA0303` `UAB1302` `UAB2108` `UAB4201` `UAL0301` `UAS0203` `UAS0304`
`UEA0204` `UEA0303` `UEA0305` `UEB1302` `UEB3106` `UEB4201` `UEL0205` `UEL0401`
`UES0203` `UES0304` `UES0401` `URA0204` `URA0303` `URB1302` `URB4203` `URS0203`
`URS0304` `XAA0305` `XAA0306` `XAB3301` `XAS0306` `XES0102` `XRA0305` `XSA0204`
`XSA0303` `XSA0402` `XSB1302` `XSL0402` `XSS0203` `XSS0303` `XSS0304`

### uebrige -> basegame (6)

| ID | Mod | Original |
|---|---|---|
| `UAL0001` | commanders | Armored Command Unit (Aeon) |
| `UEL0001` | commanders, test21000 | Armored Command Unit (UEF) |
| `URL0001` | commanders | Armored Command Unit (Cybran) |
| `XSL0001` | commanders | Armored Command Unit (Seraphim) |
| `XSS0302` | nomads-4-loud | Hauthuum |
| `XEA0002` | NOMADS-try_b4_ur_BI | Recon Satellite |

---

## Ungeprueft: Ueberschreibungen von mod-Paketen

Die folgenden Angaben stammen aus dem fehlerhaften Markdown-Abgleich und sind **vor
Weiterverwendung neu zu ermitteln**. Sie stehen hier als Ausgangspunkt, nicht als Befund.

| Quelle | vermutete Anzahl |
|---|---:|
| `brewlan` / BrewLAN_LOUD | 22 |
| `blackops` / BlackOpsUnleashed | 15 |
| `loud_units` | 4 |
| `WyvernBattlePack` | 4 |
| `4D-CompatibilityPack` | 4 |

Vermutete Liste, aus dem Ordner von `UEF_trans_men` (dieser ist geprueft, die Zuordnung
zur Quelle nicht):

`BAB1202` `BAB1302` `BAB2308` `BAB4307` `BAL0310` `BEB1202` `BEB1302` `BRB1202`
`BRB1302` `BSA0310` `BSB1202` `BSB1302` `BSB2402` `BSB4205` `BSL0005` `BSLK004`
`SAA0306` `SAA0313` `SAB0104` `SAB1312` `SEA0310` `SEA0313` `SEB1312` `SEB3404`
`SEL0324` `SES0319` `SRA0201` `SRA0313` `SRA4212` `SRB1312` `SRB2221` `SRB4313`
`SRB4402` `SRB5383` `SRL0319` `SRL0320` `SSA0001` `SSA0313` `SSA0314` `SSB1312`
`SSL0324` `SSL0403` `UABSSG01` `UAL0310` `UAL0402` `UEBSSG01` `UEL0402` `UES0206`
`URBSSG01` `VEB2302` `WEB0404` `WEB4301` `WEL0401` `WRL0404` `WSB0104` `WSL0404`
`XSBSSG01`

Dazu 6 IDs von `NOMADS-try_b4_ur_BI`: `SAB4401` `SEA0106` `SEA0401` `SSB3301` `WAB0201`
(sechste ist `XEA0002`, oben bereits als basegame gefuehrt).

**Ob diese IDs tatsaechlich in den genannten Paketen vorkommen, ist nicht geprueft.**
Einige - `SAB0104` `SAB1312` `SEB1312` `SRA4212` `SRB1312` `SRB4313` `SRB5383` `SSB1312`
`MKT0409` - koennten auch Neuschoepfungen ohne Gegenstueck sein.

---

## Verfahren zur Neuermittlung

Nicht aus Markdown parsen, sondern aus Verzeichnislisten:

```
1. Fuer jeden Ablageort list_directory -> ID-Liste
2. Alle Listen mit Herkunftsspalte zusammenfuehren
3. IDs zaehlen, die in mehr als einem Ablageort vorkommen
```

Steht in `../TODO.md`.

---

## Dreifachbelegung

| ID | Kette |
|---|---|
| `UEL0001` | `units` -> `commanders` -> `test21000` |

Nach der uid-Sortierung (`12345678901234567890test21000` vor `THISoneIS4myBOImax`) wird
**`commanders` zuletzt angewandt und gewinnt**. Abgeleitet aus der Regel, im Spiel nicht
geprueft.

---

## Was daraus folgt

1. **Ein Name in den Bestandslisten ist der Stand des jeweiligen Ablageorts, nicht
   zwingend der im Spiel.** Bei mehrfach belegten IDs haengt es davon ab, welche Mods
   aktiv sind.
2. **Vor jeder Blueprint-Aenderung hier nachsehen.** Sonst wird die eigene Aenderung von
   einem anderen Mod verdeckt - oder verdeckt dessen Aenderung.
3. **`Merge = true` schuetzt nicht.** Ein Merge wirkt gegenueber dem Original, nicht
   gegenueber einem spaeter angewandten Vollersatz.
4. **Alle ueberschreibenden Mods liegen in `usermods\`.** Die Pakete aus `gamedata`
   scheinen untereinander nicht zu kollidieren - ungeprueft.
5. **Fuer den Neuschnitt** (`../12_NEUSCHNITT.md`): `UEF_trans_men` hat 97 eigene
   Blueprint-Ordner, davon allein 39 Ueberschreibungen des Basisspiels. Erster Kandidat
   fuers Aufraeumen.

## Grenzen dieser Aufstellung

Erfasst sind **Blueprint-Dateien**. Nicht erfasst:

- **`ModBlueprints()`-Hooks** aendern Blueprints programmatisch, ohne eigene Datei
  (`../03_BLUEPRINTS.md` Abschnitt 5). LOUDs eigener Mod `Enhanced Resources` tut das.
- **Verhaltens-Hooks** (`hook\lua\sim\Unit.lua` u. ae.) aendern kein Blueprint, wohl aber
  das Verhalten aller Einheiten.
- **Nicht-Unit-Blueprints** (Projektile, Props, Meshes, Emitter).
- **Die 24 LOUD-eigenen Mods** aus `loud_misc.scd` (`../02_MODSYSTEM.md` Abschnitt 6.5) -
  bislang nicht auf Einheiten geprueft.
