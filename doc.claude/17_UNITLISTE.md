# 17 - Einheitenverzeichnis (Index)

**Einstieg zu allen Einheiten in allen Paketen, Mods und Fraktionen.**
Die Daten selbst liegen in [units\](units/) - Ordneruebersicht:
[units\README.md](units/README.md).

Stand: 2026-08-05. Erhoben durch Auflisten der Blueprint-Verzeichnisse unter
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\
```

---

## Die drei Kategorien

Massgeblich ist der **Ablageort des Blueprints**, nicht das ID-Praefix:

| Kategorie | Ort | Einheiten | Geprueft | Datei |
|---|---|---:|---|---|
| basegame | `gamedata.entpackt\units\units\` | 425 | ja | [units\basegame.md](units/basegame.md) |
| mod | `gamedata.entpackt\<Archiv>\...` | 668 | ja | [units\mods.md](units/mods.md) |
| usermod | `usermods\<Mod>\...` | 218 | ja | [units\usermods.md](units/usermods.md) |
| **Gesamt** | | **1311** | | |

Gezaehlt werden `*_unit.bp`-Dateien, rekursiv - Stand 2026-08-06 aus
[units\_generiert\units.csv](units/_generiert/units.csv).
1107 verschiedene IDs (case-insensitiv), **187 davon mehrfach belegt**.

Die ID-Systematik taugt **nicht** als Kriterium: `UAB8765` und `XSB8765` tragen
Basisspiel-Praefixe, liegen aber in `LOUD Unit Additions`; umgekehrt liegen 13 Eintraege
mit `B`/`D`/`S`-Praefix im Basisverzeichnis. Sie ist eine Lesehilfe, kein Ordnungsmerkmal.

---

## Wegweiser

| Frage | Datei |
|---|---|
| **Wird diese ID von einem Mod ueberschrieben?** | [units\ueberschreibungen.md](units/ueberschreibungen.md) |
| **Wie heisst Einheit X?** | [units\_generiert\units.csv](units/_generiert/units.csv) - alle 1311 mit Namen |
| Einheiten des Basisspiels | [units\basegame.md](units/basegame.md) |
| Mod-Einheiten aus `gamedata` - Uebersicht | [units\mods.md](units/mods.md) |
| - Detaillisten je Paket | [units\pakete.md](units/pakete.md) |
| - LOUD-eigene Mods aus `loud_misc` | [units\loud_misc.md](units/loud_misc.md) |
| Einheiten unserer eigenen Mods | [units\usermods.md](units/usermods.md) |
| Volle Analyse einer einzelnen Einheit | `units\<UNITID>.md`, Vorlage: [units\_VORLAGE.md](units/_VORLAGE.md) |
| Format- und Pruefregeln | [units\README.md](units/README.md) |
| Liste neu erzeugen | [16_UNITS.md](16_UNITS.md) -> `tools\Get-Units.ps1` |

---

## Bestand

| Paket | Mod | Einheiten | Kategorie |
|---|---|---:|---|
| `units` | units | 425 | basegame |
| `brewlan` | BrewLAN_LOUD | 152 | mod |
| `usermods` | nomads-4-loud | 107 | usermod |
| `civ_units` | civ_units | 100 | mod |
| `usermods` | UEF_trans_men | 97 | usermod |
| `blackops` | BlackOpsUnleashed | 86 | mod |
| `loud_misc` | LOUD Integrated Storage | 84 | mod |
| `TotalMayhem` | TotalMayhem | 62 | mod |
| `loud_misc` | ZLOUD Structure Enhancements | 36 | mod |
| `loud_units` | LOUD Unit Additions | 26 | mod |
| `WyvernBattlePack` | BattlePack | 25 | mod |
| `brewlan` | BrewLAN_Units | 25 | mod |
| `brewlan` | BrewLAN_RNG | 18 | mod |
| `4D-CompatibilityPack` | 4DC | 15 | mod |
| `brewlan` | BrewLAN_Plenae | 14 | mod |
| `blackops` | BlackopsACUs | 9 | mod |
| `usermods` | NOMADS-try_b4_ur_BI | 9 | usermod |
| `loud_misc` | Enhanced Nukes | 8 | mod |
| `usermods` | commanders | 4 | usermod |
| `loud_misc` | Artillery | 4 | mod |
| `loud_misc` | Enhanced Commanders | 4 | mod |
| `usermods` | test21000 | 1 | usermod |
| **Summe** | | **1311** | |

## Verteilung

| Fraktion | Einheiten | | Techstufe | Einheiten |
|---|---:|---|---|---:|
| UEF | 339 | | T3 | 421 |
| Cybran | 317 | | T1 | 307 |
| Seraphim | 269 | | T2 | 284 |
| Aeon | 247 | | unbestimmt | 155 |
| Nomads | 115 | | Experimental | 144 |
| keine | 24 | | | |

## Ueberschreibungen

**187 IDs kommen an mehr als einem Ablageort vor** (case-insensitiv gerechnet).
**120 der 425 Basiseinheiten werden von mindestens einem Mod ersetzt** - fast jede dritte.

| Mod | Einheiten | davon Ersatz | Anteil |
|---|---:|---:|---:|
| `UEF_trans_men` | 97 | 88 | 91 % |
| `LOUD Integrated Storage` | 84 | 56 | 67 % |
| `ZLOUD Structure Enhancements` | 36 | 32 | 89 % |
| `BrewLAN_LOUD` | 152 | 23 | 15 % |
| `BlackOpsUnleashed` | 86 | 20 | 23 % |
| `LOUD Unit Additions` | 26 | 12 | 46 % |
| `Enhanced Nukes`, `Artillery`, `Enhanced Commanders`, `commanders`, `test21000` | | | 100 % |

Einzelheiten: [units\ueberschreibungen.md](units/ueberschreibungen.md)

---

## Wo die Blueprints liegen

```
gamedata.entpackt\units\units\<ID>\<ID>_unit.bp                          basegame
gamedata.entpackt\<Archiv>\units\<ID>\<ID>_unit.bp                       civ_units
gamedata.entpackt\<Archiv>\mods\<Mod>\units\<ID>\<ID>_unit.bp            die meisten mod-Pakete
gamedata.entpackt\brewlan\mods\<Mod>\<Untermod>\units\<ID>\<ID>_unit.bp  brewlan
usermods\<Mod>\units\<ID>\<ID>_unit.bp                                   usermod
```

---

## Lesehilfe: die ID-Systematik

**Pfadfinderregel:** Fraktion und Domaene sind zunaechst aus der Unit-ID abgeleitet.
Wo Belege aus Blueprints oder Lokalisierungsdateien vorliegen, stehen sie **statt** der
Ableitung - und werden bei Gelegenheit weiter ergaenzt (`TODO.md`).

Schema `[Set][Fraktion][Domaene][Nummer]`:

| Position | Zeichen | Bedeutung |
|---|---|---|
| 1 | `U` | Original Supreme Commander |
| | `X` | Forged Alliance |
| | `B` `D` `S` `L` `V` `W` `E` `Z` `C` `M` | LOUD- und Mod-Ergaenzungen |
| 2 | `A` | Aeon |
| | `E` | UEF |
| | `R` | Cybran |
| | `S` | Seraphim |
| | `N` | Nomads (nur `nomads-4-loud`) |
| 3 | `L` | Land |
| | `A` | Luft |
| | `S` | See |
| | `B` | Gebaeude |
| | `C` | Civilian (statt Domaene) |
| | `M` | Sonstiges, ungeklaert |

Die Ableitung ist eine **Konvention, keine Garantie.** Massgeblich ist immer `Categories`
im Blueprint.

### Stand der Ergaenzung

| Bereich | IDs geprueft | Namen | Fraktion belegt |
|---|---|---|---|
| `units` (basegame) | ja | 391 von 432 aus `strings_db.lua` | nein, abgeleitet |
| alle 13 mod-Pakete | ja | offen | nein, abgeleitet |
| `usermods\nomads-4-loud` | ja | 98 von 107 aus Lokalisierung | ja |
| `usermods\NOMADS-try_b4_ur_BI` | ja | vollstaendig aus Blueprints | ja |
| `usermods\commanders`, `test21000` | ja | kein `UnitName` im Blueprint | ja |
| `usermods\UEF_trans_men` | ja | offen | nein |
| `TotalMayhem` | ja | offen | ja, 4 Stichproben |

### Bekannte Abweichungen

| Paket / Mod | Abweichung |
|---|---|
| `TotalMayhem` | eigenes Schema `BR[MNOP]...`, Fraktion im 3. Zeichen |
| `civ_units`, `CityGeneration` | 3. Zeichen `C` = Civilian statt Domaene |
| `nomads-4-loud` | 2. Zeichen `N` = Nomads; `XNO...` und `XNY...` ungeklaert |
| `BlackOpsUnleashed` | `K`-Kennung: `BALK003` `BELK002` `BRLK001` `BRLK005` `BSLK004` |
| `brewlan` | `ZZZ...`, `ZZCITYBLOCK...`, `ZZCRATE`, `SNLMER1` ohne Fraktionskennung |
| `units` | `...M...` als 3. Zeichen: `UAM0004` `UEM0006` `URM0004` `XSM0001` |
| `civ_units` | benannte Objekte: `UEF_Bus` `UEF_Car1` `UEF_Fence` `UEF_Streetlight_01` `UEF_truck` |
| `UEF_trans_men` | `MKT0409` |
| `loud_units` | `UALX401` |
| `WyvernBattlePack` | `WEL03041` (fuenfstellig) |

---

## Freie Set-Praefixe fuer eigene Einheiten

Belegt: `U` `X` `B` `D` `S` `L` `V` `W` `E` `Z` `C` `M` `N`

Frei u. a.: `F` `G` `H` `I` `J` `K` `P` `Q` `T` `Y`

Vor Vergabe hier und in den Dateien unter `units\` gegenpruefen
(`07_KONVENTIONEN.md` Abschnitt 3).

---

## Grenzen dieser Erhebung

1. **Auf der Platte vorhanden ist nicht gleich im Spiel geladen.** Blueprints eines Mods
   werden nur eingelesen, wenn der Mod in der Partie aktiv ist (`02_MODSYSTEM.md`
   Abschnitt 4). Daran ist eine fruehere Fehldiagnose gescheitert (`15_LOG.md` R-01).
2. **Erfasst sind Blueprint-Dateien.** `ModBlueprints()`-Hooks aendern Blueprints
   programmatisch, ohne eigene Datei (`03_BLUEPRINTS.md` Abschnitt 5) - das taucht hier
   nicht auf.
3. **Verhaltens-Hooks** (`hook\lua\sim\Unit.lua` u. ae.) aendern kein Blueprint, wohl aber
   das Verhalten aller Einheiten.
4. **Nicht-Unit-Blueprints** (Projektile, Props, Meshes, Emitter) sind nicht erfasst.
5. **Die 24 LOUD-eigenen Mods** aus `loud_misc.scd` (`02_MODSYSTEM.md` Abschnitt 6.5)
   wurden bislang nicht auf Einheiten geprueft.

## Aktualitaet

Nach jedem LOUD-Update neu erheben, zusammen mit `gamedata.entpackt\`
(`01_ARCHITEKTUR.md` Abschnitt 2). Ebenso nach jeder Ergaenzung eigener Einheiten.
