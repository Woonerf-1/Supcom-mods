# Mods aus `gamedata`

Zurueck: [README.md](README.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [basegame.md](basegame.md) - [usermods.md](usermods.md) - [pakete.md](pakete.md) - [ueberschreibungen.md](ueberschreibungen.md)

**668 Einheiten** aus 18 Paketen der LOUD-Distribution.
Detaillisten: [pakete.md](pakete.md) und [loud_misc.md](loud_misc.md).

Stand: 2026-08-06, erhoben aus `_generiert\units.csv` (Skriptlauf) - zaehlt
`*_unit.bp`-Dateien, rekursiv.

---

## Die drei Kategorien

Massgeblich ist der **Ablageort des Blueprints**, nicht das ID-Praefix:

| Kategorie | Ablageort | Einheiten | Datei |
|---|---|---:|---|
| basegame | `gamedata.entpackt\units\units\` | 425 | [basegame.md](basegame.md) |
| mod | `gamedata.entpackt\<Archiv>\...` | 668 | diese Datei, Details in [pakete.md](pakete.md) und [loud_misc.md](loud_misc.md) |
| usermod | `usermods\<Mod>\...` | 218 | [usermods.md](usermods.md) |
| **Gesamt** | | **1311** | |

Die ID-Systematik (`../17_UNITLISTE.md`) taugt **nicht** als Kriterium: `UAB8765` und
`XSB8765` tragen Basisspiel-Praefixe, liegen aber in `LOUD Unit Additions`; umgekehrt
liegen 13 Eintraege mit `B`/`D`/`S`-Praefix im Basisverzeichnis.

---

## Die Pakete

| Archiv | Mod | Einheiten | mehrfach belegt | Besonderheit |
|---|---|---:|---:|---|
| `brewlan` | BrewLAN_LOUD | 152 | 23 | groesstes Einzelpaket |
| `civ_units` | civ_units | 100 | 0 | 3. Zeichen `C` = Civilian |
| `blackops` | BlackOpsUnleashed | 86 | 20 | enthaelt die `*B4209`-Teleport-Jammer |
| `loud_misc` | **LOUD Integrated Storage** | 84 | 56 | LOUD-eigen, ersetzt Basisgebaeude |
| `TotalMayhem` | TotalMayhem | 62 | 0 | eigene ID-Systematik `BR[MNOP]...` |
| `loud_misc` | **ZLOUD Structure Enhancements** | 36 | 32 | LOUD-eigen, 24 IDs kleingeschrieben |
| `loud_units` | LOUD Unit Additions | 26 | 12 | Praefixe `L`, `V`, `W` |
| `WyvernBattlePack` | BattlePack | 25 | 4 | Praefix `W` |
| `brewlan` | BrewLAN_Units | 25 | 0 | Untermods BrewIntel + BrewResearch |
| `brewlan` | BrewLAN_RNG | 18 | 0 | 17 davon ausserhalb von `units\` |
| `4D-CompatibilityPack` | 4DC | 15 | 4 | Kompatibilitaetsschicht |
| `brewlan` | BrewLAN_Plenae | 14 | 0 | CityGeneration, Spomeniki, Logger |
| `blackops` | BlackopsACUs | 9 | 4 | Praefix `E`, alternative ACUs |
| `loud_misc` | **Enhanced Nukes** | 8 | 8 | LOUD-eigen, ersetzt vollstaendig |
| `loud_misc` | **Artillery** | 4 | 4 | LOUD-eigen, ersetzt vollstaendig |
| `loud_misc` | **Enhanced Commanders** | 4 | 4 | LOUD-eigen, ersetzt BlackopsACUs |
| **Summe** | | **668** | | |

**Fett: die fuenf Mods aus `loud_misc`** - eigene Datei: [loud_misc.md](loud_misc.md).
Sie waren in der ersten Erhebung uebersehen worden und aendern das Bild erheblich.

---

## Die LOUD-eigenen Mods aus `loud_misc`

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loud_misc\mods\<Mod>\units\
```

`loud_misc.scd` enthaelt 24 LOUD-eigene Mods (`../02_MODSYSTEM.md` Abschnitt 6.5), von
denen **fuenf Einheiten mitbringen**. Sie unterscheiden sich grundlegend von den
Inhaltspaketen:

| Mod | Einheiten | davon Ersatz | Arbeitsweise |
|---|---:|---:|---|
| LOUD Integrated Storage | 84 | 56 | ersetzt Basisgebaeude, um Lager einzubauen |
| ZLOUD Structure Enhancements | 36 | 32 | ersetzt Fabriken, Flak, Artillerie, Reparatur |
| Enhanced Nukes | 8 | 8 | **ersetzt ausschliesslich** |
| Artillery | 4 | 4 | **ersetzt ausschliesslich** |
| Enhanced Commanders | 4 | 4 | ersetzt die vier `BlackopsACUs` |

Vollstaendige Listen: [loud_misc.md](loud_misc.md)

**Das ist ein anderer Modtyp.** Wo BrewLAN und Total Mayhem Einheiten *hinzufuegen*,
*veraendern* diese fuenf bestehende. `Enhanced Nukes`, `Artillery` und
`Enhanced Commanders` bestehen zu 100 Prozent aus Ueberschreibungen.

**Konsequenz fuer eigene Mods:** Wer ein Basisgebaeude anfasst, konkurriert
moeglicherweise mit `LOUD Integrated Storage` - und das ist ein Mod, der bei vielen
Spielern aktiv ist. Vor jeder Blueprint-Aenderung in
[ueberschreibungen.md](ueberschreibungen.md) nachsehen.

---

## Ablagemuster

```
gamedata.entpackt\<Archiv>\units\<ID>\<ID>_unit.bp                       civ_units
gamedata.entpackt\<Archiv>\mods\<Mod>\units\<ID>\<ID>_unit.bp            die meisten
gamedata.entpackt\brewlan\mods\<Mod>\<Untermod>\units\<ID>\<ID>_unit.bp  brewlan
gamedata.entpackt\brewlan\mods\BrewLAN_RNG\CrateDrop\effects\entities\   Sonderfall
```

`brewlan` ist tiefer verschachtelt: `BrewLAN_Units`, `BrewLAN_Plenae` und `BrewLAN_RNG`
haben keinen eigenen `units\`-Ordner, sondern enthalten weitere Mods.

**Sonderfall `BrewLAN_RNG`:** 17 der 18 Blueprints liegen **nicht** unter `units\`,
sondern in `CrateDrop\effects\entities\PING_*\`. Es sind Beuteanzeigen, die technisch als
Einheiten definiert sind. Eine Erhebung, die nur `units\`-Ordner auflistet, findet sie
nicht.

## Abweichungen von der ID-Systematik

| Paket | Abweichung |
|---|---|
| `TotalMayhem` | eigenes Schema `BR[MNOP]...`, Fraktion im 3. Zeichen |
| `civ_units`, `CityGeneration` | 3. Zeichen `C` = Civilian statt Domaene |
| `BlackOpsUnleashed` | `K`-Kennung: `BALK003` `BELK002` `BRLK001` `BRLK005` `BSLK004` |
| `brewlan` | `ZZZ...`, `ZZCITYBLOCK...`, `ZZCRATE`, `SNLMER1`, `PING_...` |
| `civ_units` | benannte Objekte: `UEF_Bus` `UEF_Car1` `UEF_Fence` `UEF_Streetlight_01` `UEF_truck` |
| `loud_units` | `UALX401` |
| `WyvernBattlePack` | `WEL03041` (fuenfstellig) |

## Pruefstand

| Was | Stand |
|---|---|
| Bestand | geprueft 2026-08-06 aus `_generiert\units.csv` |
| Kollisionen | 187 mehrfach belegte IDs, **case-insensitiv** gerechnet |
| Namen | in `_generiert\units.csv` vollstaendig, in `pakete.md` erst teilweise |
| Fraktionszuordnung | aus `Categories` im Blueprint (Skript) |
