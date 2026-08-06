# Mod-Pakete - Detaillisten

Zurueck: [README.md](README.md) - [mods.md](mods.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [basegame.md](basegame.md) - [usermods.md](usermods.md) - [ueberschreibungen.md](ueberschreibungen.md)

**Index ueber die Detaillisten der 18 mod-Pakete.** Zusammen 668 Einheiten.

Stand 2026-08-06 aus `_generiert\units.csv` - gezaehlt werden `*_unit.bp`-Dateien,
rekursiv, Kollisionen case-insensitiv.

---

## Wo steht was

| Datei | Pakete | Einheiten | mehrfach belegt |
|---|---|---:|---:|
| [loud_misc.md](loud_misc.md) | LOUD Integrated Storage, ZLOUD Structure Enhancements, Enhanced Nukes, Artillery, Enhanced Commanders | 136 | 104 |
| [brewlan.md](brewlan.md) | BrewLAN_LOUD, BrewLAN_Units, BrewLAN_Plenae, BrewLAN_RNG | 209 | 23 |
| [blackops.md](blackops.md) | BlackOpsUnleashed | 86 | 20 |
| [civ_units.md](civ_units.md) | civ_units | 100 | 0 |
| [totalmayhem.md](totalmayhem.md) | TotalMayhem | 62 | 0 |
| [kleinpakete.md](kleinpakete.md) | LOUD Unit Additions, BattlePack, 4DC, BlackopsACUs | 75 | 24 |
| **Summe** | | **668** | **171** |

Die 171 Faelle hier plus die aus basegame und den Usermods ergeben zusammen die
**187 mehrfach belegten IDs** ([ueberschreibungen.md](ueberschreibungen.md)) - IDs, die an
drei Orten vorkommen, werden dabei nur einmal gezaehlt.

---

## Zwei Sorten von Paketen

| Typ | Pakete | Ersatzanteil |
|---|---|---|
| **Inhaltspakete** - fuegen hinzu | civ_units, TotalMayhem, BrewLAN_Units, BrewLAN_Plenae, BrewLAN_RNG | 0 % |
| **Aenderungsmods** - ersetzen | Enhanced Nukes, Artillery, Enhanced Commanders | 100 % |
| | LOUD Integrated Storage | 67 % |
| | ZLOUD Structure Enhancements | 89 % |
| **gemischt** | BrewLAN_LOUD, BlackOpsUnleashed, LOUD Unit Additions, BattlePack, 4DC | 15-46 % |

Bei den Aenderungsmods ist Ersetzen die **Arbeitsweise**, nicht ein Mangel. Alle vier
liegen in `loud_misc` und sind LOUD-eigen.

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
nicht - so wurden sie zunaechst uebersehen.

## Abweichungen von der ID-Systematik

| Paket | Abweichung |
|---|---|
| `TotalMayhem` | eigenes Schema `BR[MNOP]...`, Fraktion im 3. Zeichen |
| `civ_units` | 3. Zeichen `C` = Civilian statt Domaene; dazu benannte Objekte wie `UEF_Bus` |
| `BrewLAN_Plenae` | `SEC...` Civilian, `SNLMER1/2` Marsrover, `ZZCITYBLOCK...`, `ZZZ000...` |
| `BrewLAN_RNG` | `PING_...` und `ZZCRATE` ohne Fraktionskennung |
| `BlackOpsUnleashed` | `K`-Kennung: `BALK003` `BELK002` `BRLK001` `BRLK005` `BSLK004` |
| `ZLOUD Structure Enhancements` | 24 IDs **kleingeschrieben** - dieselben Blueprints wie die Grossbuchstaben-IDs |
| `LOUD Unit Additions` | `UALX401`, `*SSG01`/`*SSG02` |
| `BattlePack` | `WEL03041` (fuenfstellig) |
| `4DC` | Basisspiel-Praefixe trotz eigener Einheiten |

## Pruefstand

| Was | Stand |
|---|---|
| Bestand | geprueft 2026-08-06 aus `_generiert\units.csv` |
| Kollisionen | case-insensitiv gerechnet |
| Namen | aus `UnitName` im Blueprint, sonst `HelpText` |
| Fraktionszuordnung | aus `Categories` im Blueprint (Skript) |
