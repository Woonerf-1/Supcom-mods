# Ueberschreibungen - mehrfach belegte Unit-IDs

Zurueck: [README.md](README.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [basegame.md](basegame.md) - [mods.md](mods.md) - [pakete.md](pakete.md) - [usermods.md](usermods.md)

Mods aendern nicht nur eigene Einheiten - sie **ersetzen Blueprints vorhandener
Einheiten**. Steht dieselbe Unit-ID an zwei Ablageorten, gilt im Spiel nur eine Fassung:
die des zuletzt angewandten aktiven Mods (`../02_MODSYSTEM.md` Abschnitt 5 -
Ladereihenfolge alphabetisch nach `uid`, sofern kein `before`/`after` gesetzt ist).

**187 IDs kommen an mehr als einem Ablageort vor** - bei 1107 verschiedenen IDs
insgesamt. Ermittelt am 2026-08-06 aus `_generiert\units.csv`, das alle 1311
`*_unit.bp`-Dateien rekursiv erfasst. **Case-insensitiv gerechnet** (siehe unten).

---

## Achtung: Schreibweise normalisieren

Blueprint-IDs sind **case-insensitiv** - die Engine behandelt `uab0301` und `UAB0301` als
dieselbe Einheit. Im Datenbestand kommen 24 IDs in beiden Schreibweisen vor: alle in
`ZLOUD Structure Enhancements`, das die Basisfabriken, Flak, Artillerie und
Reparaturplattformen kleingeschrieben ersetzt.

Wer beim Vergleichen nicht auf Grossschreibung normalisiert, uebersieht 24
Ueberschreibungen. Genau das ist bei der ersten Auswertung passiert - Ergebnis damals
163 statt 187.

---

## Uebersicht

| Mod | Kategorie | Einheiten | davon Ersatz | Anteil |
|---|---|---:|---:|---:|
| `UEF_trans_men` | usermod | 97 | 88 | 91 % |
| `LOUD Integrated Storage` | mod (loud_misc) | 84 | 56 | 67 % |
| `ZLOUD Structure Enhancements` | mod (loud_misc) | 36 | 32 | 89 % |
| `BrewLAN_LOUD` | mod | 152 | 23 | 15 % |
| `BlackOpsUnleashed` | mod | 86 | 20 | 23 % |
| `LOUD Unit Additions` | mod | 26 | 12 | 46 % |
| `Enhanced Nukes` | mod (loud_misc) | 8 | 8 | **100 %** |
| `NOMADS-try_b4_ur_BI` | usermod | 9 | 6 | 67 % |
| `BattlePack` | mod | 25 | 4 | 16 % |
| `4DC` | mod | 15 | 4 | 27 % |
| `BlackopsACUs` | mod | 9 | 4 | 44 % |
| `Artillery` | mod (loud_misc) | 4 | 4 | **100 %** |
| `Enhanced Commanders` | mod (loud_misc) | 4 | 4 | **100 %** |
| `commanders` | usermod | 4 | 4 | **100 %** |
| `nomads-4-loud` | usermod | 107 | 1 | 1 % |
| `test21000` | usermod | 1 | 1 | **100 %** |
| `units` (basegame) | basegame | 425 | 120 | 28 % |

Die Spalte "davon Ersatz" zaehlt IDs, die auch anderswo vorkommen - sie sagt nicht, wer
gewinnt. Das entscheidet die Ladereihenfolge.

**120 der 425 Basiseinheiten werden von mindestens einem Mod ersetzt** - fast jede dritte.

---

## Zwei Sorten von Mods

Die Erhebung zeigt einen Unterschied, der fuer den Neuschnitt wesentlich ist:

**Inhaltspakete** fuegen Einheiten hinzu und lassen den Bestand in Ruhe:
`civ_units` (0 von 100), `TotalMayhem` (0 von 62), `BrewLAN_Units` (0 von 25),
`BrewLAN_RNG` (0 von 18), `BrewLAN_Plenae` (0 von 14).

**Aenderungsmods** ersetzen bestehende Blueprints, um Eigenschaften einzubauen:
`Enhanced Nukes`, `Artillery`, `Enhanced Commanders` (je 100 Prozent),
`LOUD Integrated Storage` (67 Prozent).

Bei den Aenderungsmods ist Ersetzen kein Fehler, sondern die Arbeitsweise -
`LOUD Integrated Storage` baut in 56 Basisgebaeude ein Lager ein, das geht nicht anders
als ueber den Blueprint. Bei `UEF_trans_men` (91 Prozent) ist es dagegen kein erkennbares
Konzept.

---

## Ueberschreibungen von basegame (96)

| Ueberschreibender Mod | Kategorie | IDs |
|---|---|---:|
| `UEF_trans_men` | usermod | 39 |
| `LOUD Integrated Storage` | mod | 40 |
| `ZLOUD Structure Enhancements` | mod | 8 |
| `Enhanced Nukes` | mod | 8 |
| `commanders` | usermod | 4 |
| `Artillery` | mod | 3 |
| `nomads-4-loud` | usermod | 1 |
| `NOMADS-try_b4_ur_BI` | usermod | 1 |
| `test21000` | usermod | 1 |

Summe 105, verschiedene IDs 96 - einige werden von zwei Mods zugleich beansprucht.

### Mehrfachkonflikte

| Muster | IDs |
|---|---:|
| basegame + `LOUD Integrated Storage` + `UEF_trans_men` | 4 |
| basegame + `Enhanced Nukes` + `UEF_trans_men` | 3 |
| basegame + `ZLOUD Structure Enhancements` + `UEF_trans_men` | 1 |
| basegame + `commanders` + `test21000` | 1 (`UEL0001`) |

Bei diesen neun IDs konkurrieren **drei** Fassungen. Welche gewinnt, entscheidet allein
die uid-Sortierung - im Spiel nicht geprueft.

---

## Ueberschreibungen zwischen mod-Paketen

Anders als in der ersten Erhebung angenommen, kollidieren die `gamedata`-Pakete
**durchaus** untereinander - alle Faelle gehen von `loud_misc` aus:

| Muster | IDs |
|---|---:|
| `BlackOpsUnleashed` + `LOUD Integrated Storage` | 4 |
| `BlackOpsUnleashed` + `LOUD Integrated Storage` + `UEF_trans_men` | 4 |
| `LOUD Unit Additions` + `LOUD Integrated Storage` | 4 |
| `LOUD Unit Additions` + `LOUD Integrated Storage` + `UEF_trans_men` | 4 |
| `BlackopsACUs` + `Enhanced Commanders` | 4 |
| `BrewLAN_LOUD` + `Artillery` | 1 |

`LOUD Integrated Storage` greift also nicht nur in das Basisspiel ein, sondern auch in
BlackOps und die LOUD-eigenen Einheitenerweiterungen.

---

## `UEF_trans_men` (88 von 97)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\UEF_trans_men\units\
```

**91 Prozent des Mods sind Ueberschreibungen.** Eigenstaendig sind nur 9 IDs:

`MKT0409` `SAB0104` `SAB1312` `SEB1312` `SRA4212` `SRB1312` `SRB4313` `SRB5383`
`SSB1312`

| Quelle | Kategorie | IDs |
|---|---|---:|
| `units` | basegame | 39 |
| `BrewLAN_LOUD` | mod | 18 |
| `BlackOpsUnleashed` | mod | 16 |
| `LOUD Unit Additions` | mod | 7 |
| `LOUD Integrated Storage` | mod | 12 |
| `BattlePack` | mod | 4 |
| `4DC` | mod | 4 |
| `Enhanced Nukes` | mod | 3 |
| `ZLOUD Structure Enhancements` | mod | 1 |

Summe der Quellen uebersteigt 88, weil einzelne IDs an drei Orten vorkommen.

Erster Kandidat fuers Aufraeumen (`../12_NEUSCHNITT.md`).

---

## Uebrige Usermods

| Mod | ersetzt | Einzelheiten |
|---|---:|---|
| `NOMADS-try_b4_ur_BI` | 6 | 4 aus BrewLAN_LOUD, 1 aus LOUD Unit Additions, 1 aus basegame |
| `commanders` | 4 | die vier ACUs aus basegame, Vollersatz |
| `nomads-4-loud` | 1 | `XSS0302` (Hauthuum) |
| `test21000` | 1 | `UEL0001`, acht geaenderte Felder |

`NOMADS-try_b4_ur_BI` benennt drei davon um: `SSB3301` wird zu "Eye of pifpuff".
Eigenstaendig sind dort nur `CAS0401`, `CNB1202` (Eckard), `CNB1302` (Guenter).

---

## Was daraus folgt

1. **Ein Name in den Bestandslisten ist der Stand des jeweiligen Ablageorts, nicht
   zwingend der im Spiel.** Bei mehrfach belegten IDs haengt es davon ab, welche Mods
   aktiv sind.
2. **Vor jeder Blueprint-Aenderung hier nachsehen.** Fast jede vierte Basiseinheit ist
   betroffen.
3. **`Merge = true` schuetzt nicht.** Ein Merge wirkt gegenueber dem Original, nicht
   gegenueber einem spaeter angewandten Vollersatz.
4. **Auch LOUD-eigene Mods ueberschreiben.** `LOUD Integrated Storage` ersetzt 56
   Blueprints, davon 40 aus dem Basisspiel. Wer ein Basisgebaeude anfasst, konkurriert
   mit einem Mod, der bei vielen Spielern aktiv ist.

## Ermittlungsverfahren

Aus `_generiert\units.csv` (Skriptlauf), das alle `*_unit.bp` rekursiv erfasst:

```
1. Spalten Paket, Mod, UnitID extrahieren
2. IDs zaehlen, die in mehr als einer Paket/Mod-Kombination vorkommen
```

**Zwei fruehere Verfahren waren unzureichend:**

- *Parsen der Dokumentation* erfasste IDs, die dort nur im Fliesstext standen
  (`UAM0004`, `UEM0006`, `URM0004`, `XSM0001` galten faelschlich als ersetzt).
- *Auflisten der `units\`-Ordner* uebersah `loud_misc` vollstaendig und Blueprints
  ausserhalb von `units\`-Ordnern. Ergebnis damals: 99 statt 187.
- *Vergleich ohne Normalisierung der Schreibweise* uebersah die 24 kleingeschriebenen
  IDs aus `ZLOUD Structure Enhancements`. Ergebnis damals: 163 statt 187.

## Grenzen dieser Aufstellung

Erfasst sind **Blueprint-Dateien**. Nicht erfasst:

- **`ModBlueprints()`-Hooks** aendern Blueprints programmatisch, ohne eigene Datei
  (`../03_BLUEPRINTS.md` Abschnitt 5). LOUDs Mod `Enhanced Resources` tut genau das -
  er taucht hier nicht auf, obwohl er Blueprints veraendert.
- **Verhaltens-Hooks** (`hook\lua\sim\Unit.lua` u. ae.) aendern kein Blueprint, wohl aber
  das Verhalten aller Einheiten.
- **Nicht-Unit-Blueprints** (Projektile, Props, Meshes, Emitter).
- **Welcher Mod tatsaechlich gewinnt** - das haengt von der Ladereihenfolge und davon ab,
  welche Mods aktiv sind.
