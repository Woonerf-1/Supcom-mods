# Ueberschreibungen - mehrfach belegte Unit-IDs

Zurueck: [README.md](README.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [basegame.md](basegame.md) - [mods.md](mods.md) - [pakete.md](pakete.md) - [usermods.md](usermods.md)

Mods aendern nicht nur eigene Einheiten - sie **ersetzen Blueprints vorhandener
Einheiten**. Steht dieselbe Unit-ID an zwei Ablageorten, gilt im Spiel nur eine Fassung.

**187 IDs kommen an mehr als einem Ablageort vor** - bei 1107 verschiedenen IDs
insgesamt. Ermittelt am 2026-08-06 aus `_generiert\units.csv`, das alle 1311
`*_unit.bp`-Dateien rekursiv erfasst. Case-insensitiv gerechnet.

---

## Was diese Datei NICHT sagt

**Sie sagt nicht, welcher Blueprint im Spiel gilt.** Dafuer fehlen zwei Angaben:

1. **Welche Mods sind aktiv?** Ein Blueprint wirkt nur, wenn sein Mod in der Partie
   aktiviert ist. `LOUD Integrated Storage` etwa ist auf dieser Installation **nicht
   aktiv** (Stand 2026-08-06). Welche Mods liefen, steht im `LOUD.log`
   (`../15_LOG.md`).
2. **In welcher Reihenfolge werden sie angewandt?** Die uid-Sortierung ist die
   Standardreihenfolge, wenn nichts anderes angegeben ist - sie **erzwingt** nichts.
   Ueber `before` und `after` in `mod_info.lua` laesst sich die Reihenfolge gezielt
   festlegen (`../02_MODSYSTEM.md` Abschnitt 5).

Diese Datei sagt nur: **hier gibt es mehr als eine Fassung.** Wer gewinnt, ist in jedem
Einzelfall zu pruefen - steht als Aufgabe in `../TODO.md`.

---

## Achtung: Schreibweise normalisieren

Blueprint-IDs sind **case-insensitiv** - die Engine behandelt `uab0301` und `UAB0301` als
dieselbe Einheit. Im Datenbestand kommen 24 IDs in beiden Schreibweisen vor: alle in
`ZLOUD Structure Enhancements`, das Basisfabriken, Flak, Artillerie und
Reparaturplattformen kleingeschrieben ersetzt.

Wer beim Vergleichen nicht normalisiert, uebersieht diese 24. Genau das ist bei der
ersten Auswertung passiert - Ergebnis damals 163 statt 187.

---

## Uebersicht

| Mod | Kategorie | Einheiten | mehrfach belegt | Anteil |
|---|---|---:|---:|---:|
| `UEF_trans_men` | usermod | 97 | 88 | 91 % |
| `LOUD Integrated Storage` | mod (loud_misc) | 84 | 56 | 67 % |
| `ZLOUD Structure Enhancements` | mod (loud_misc) | 36 | 32 | 89 % |
| `BrewLAN_LOUD` | mod | 152 | 23 | 15 % |
| `BlackOpsUnleashed` | mod | 86 | 20 | 23 % |
| `LOUD Unit Additions` | mod | 26 | 12 | 46 % |
| `Enhanced Nukes` | mod (loud_misc) | 8 | 8 | 100 % |
| `NOMADS-try_b4_ur_BI` | usermod | 9 | 6 | 67 % |
| `BattlePack` | mod | 25 | 4 | 16 % |
| `4DC` | mod | 15 | 4 | 27 % |
| `BlackopsACUs` | mod | 9 | 4 | 44 % |
| `Artillery` | mod (loud_misc) | 4 | 4 | 100 % |
| `Enhanced Commanders` | mod (loud_misc) | 4 | 4 | 100 % |
| `commanders` | usermod | 4 | 4 | 100 % |
| `nomads-4-loud` | usermod | 107 | 1 | 1 % |
| `test21000` | usermod | 1 | 1 | 100 % |
| `units` (basegame) | basegame | 425 | 120 | 28 % |

---

## Zwei Sorten von Mods

**Beobachtung aus den Zahlen, keine Aussage der Modautoren.**

**Inhaltspakete** fuegen hinzu und lassen den Bestand in Ruhe:
`civ_units` (0 von 100), `TotalMayhem` (0 von 62), `BrewLAN_Units` (0 von 25),
`BrewLAN_RNG` (0 von 18), `BrewLAN_Plenae` (0 von 14).

**Aenderungsmods** ersetzen bestehende Blueprints:
`Enhanced Nukes`, `Artillery`, `Enhanced Commanders` (je 100 Prozent),
`ZLOUD Structure Enhancements` (89 Prozent), `LOUD Integrated Storage` (67 Prozent).

Bei den Aenderungsmods liegt nahe, dass Ersetzen die Arbeitsweise ist - ein Lager laesst
sich nur ueber den Blueprint in ein bestehendes Gebaeude einbauen. Bei `UEF_trans_men`
(91 Prozent) ist kein solches Konzept erkennbar.

---

## Ueberschreibungen von basegame (120)

120 der 425 Basiseinheiten kommen auch anderswo vor. Aufschluesselung nach Muster:

| Muster | IDs |
|---|---:|
| `LOUD Integrated Storage` | 36 |
| `ZLOUD Structure Enhancements` | 31 |
| `UEF_trans_men` | 31 |
| `Enhanced Nukes` | 5 |
| `LOUD Integrated Storage` + `UEF_trans_men` | 4 |
| `commanders` | 3 |
| `Enhanced Nukes` + `UEF_trans_men` | 3 |
| `Artillery` | 3 |
| `nomads-4-loud` | 1 |
| `commanders` + `test21000` | 1 (`UEL0001`) |
| `ZLOUD Structure Enhancements` + `UEF_trans_men` | 1 |
| `NOMADS-try_b4_ur_BI` | 1 |
| **Summe** | **120** |

**Bei neun IDs konkurrieren drei Fassungen** - die vier mit `LOUD Integrated Storage`,
drei mit `Enhanced Nukes`, eine mit `ZLOUD Structure Enhancements` und `UEL0001`.

**Zwei Drittel der Faelle gehen von LOUD-eigenen Mods aus** (`loud_misc`): 79 der 120.
Auf dieser Installation sind sie nicht aktiv - dann bleibt der Basisstand.

---

## Ueberschreibungen zwischen mod-Paketen

Die `gamedata`-Pakete kollidieren untereinander - alle Faelle gehen von `loud_misc` aus:

| Muster | IDs |
|---|---:|
| `BlackOpsUnleashed` + `LOUD Integrated Storage` | 4 |
| `BlackOpsUnleashed` + `LOUD Integrated Storage` + `UEF_trans_men` | 4 |
| `LOUD Unit Additions` + `LOUD Integrated Storage` | 4 |
| `LOUD Unit Additions` + `LOUD Integrated Storage` + `UEF_trans_men` | 4 |
| `BlackopsACUs` + `Enhanced Commanders` | 4 |
| `BrewLAN_LOUD` + `Artillery` | 1 |

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
| `LOUD Integrated Storage` | mod | 12 |
| `LOUD Unit Additions` | mod | 7 |
| `BattlePack` | mod | 4 |
| `4DC` | mod | 4 |
| `Enhanced Nukes` | mod | 3 |
| `ZLOUD Structure Enhancements` | mod | 1 |

Summe der Quellen uebersteigt 88, weil einzelne IDs an drei Orten vorkommen.
Vollstaendige Listen: [usermods.md](usermods.md).

Erster Kandidat fuers Aufraeumen (`../12_NEUSCHNITT.md`).

---

## Uebrige Usermods

| Mod | ersetzt | Einzelheiten |
|---|---:|---|
| `NOMADS-try_b4_ur_BI` | 6 | 4 aus BrewLAN_LOUD, 1 aus LOUD Unit Additions, 1 aus basegame |
| `commanders` | 4 | die vier ACUs aus basegame, Vollersatz |
| `nomads-4-loud` | 1 | `XSS0302` (Hauthuum) |
| `test21000` | 1 | `UEL0001`, acht geaenderte Felder |

`NOMADS-try_b4_ur_BI` benennt drei um: `SSB3301` wird zu "Eye of pifpuff".
Eigenstaendig sind dort nur `CAS0401`, `CNB1202` (Eckard), `CNB1302` (Guenter).

---

## Was daraus folgt

1. **Ein Name in den Bestandslisten ist der Stand des jeweiligen Ablageorts, nicht
   zwingend der im Spiel.**
2. **Vor jeder Blueprint-Aenderung hier nachsehen.** Fast jede dritte Basiseinheit ist
   mehrfach belegt.
3. **`Merge = true` schuetzt nicht.** Ein Merge wirkt gegenueber dem Original, nicht
   gegenueber einem spaeter angewandten Vollersatz.
4. **Auch LOUD-eigene Mods ersetzen.** 79 der 120 basegame-Faelle stammen aus
   `loud_misc`. Ob sie wirken, haengt davon ab, ob der Spieler sie aktiviert hat.
5. **Ladereihenfolge ist gestaltbar.** Wer Konflikte vermeiden will, setzt `before` oder
   `after` in `mod_info.lua`, statt sich auf die uid-Sortierung zu verlassen.

## Ermittlungsverfahren

Aus `_generiert\units.csv` (Skriptlauf), das alle `*_unit.bp` rekursiv erfasst:

```
1. Spalten Paket, Mod, UnitID extrahieren, UnitID auf Grossschreibung normalisieren
2. IDs zaehlen, die in mehr als einer Paket/Mod-Kombination vorkommen
```

**Drei fruehere Verfahren waren unzureichend:**

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
- **Welcher Mod tatsaechlich gewinnt** - siehe Abschnitt "Was diese Datei NICHT sagt".
