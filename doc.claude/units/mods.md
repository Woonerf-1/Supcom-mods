# Mods aus `gamedata`

Zurueck: [README.md](README.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [basegame.md](basegame.md) - [usermods.md](usermods.md) - [ueberschreibungen.md](ueberschreibungen.md)

**523 Einheiten** aus den Erweiterungspaketen der LOUD-Distribution.
Detaillisten je Paket: [pakete.md](pakete.md).

---

## Die drei Kategorien

Massgeblich ist der **Ablageort des Blueprints**, nicht das ID-Praefix:

| Kategorie | Ablageort | Einheiten | Datei |
|---|---|---:|---|
| basegame | `gamedata.entpackt\units\units\` | 432 | [basegame.md](basegame.md) |
| mod | `gamedata.entpackt\<Archiv>\...\units\` | 523 | diese Datei, Details in [pakete.md](pakete.md) |
| usermod | `usermods\<Mod>\units\` | 218 | [usermods.md](usermods.md) |
| **Gesamt** | | **1173** | |

Die ID-Systematik (`../17_UNITLISTE.md`) taugt **nicht** als Kriterium: `UAB8765` und
`XSB8765` tragen Basisspiel-Praefixe, liegen aber in `LOUD Unit Additions`; umgekehrt
liegen 13 Eintraege mit `B`/`D`/`S`-Praefix im Basisverzeichnis.

**Wie viele dieser 523 Blueprints von Usermods ueberschrieben werden, ist nicht
ermittelt.** Die Praefixe in `usermods\UEF_trans_men\units\` deuten auf rund 50 Faelle,
belegt ist das nicht - siehe [ueberschreibungen.md](ueberschreibungen.md).

---

## Die Pakete

| Archiv | Mod | Einheiten | Besonderheit |
|---|---|---:|---|
| `brewlan` | BrewLAN_LOUD | 149 | groesstes Einzelpaket |
| `civ_units` | - (direkt `units\`) | 117 | 3. Zeichen `C` = Civilian |
| `blackops` | BlackOpsUnleashed | 84 | enthaelt die `*B4209`-Teleport-Jammer |
| `TotalMayhem` | TotalMayhem | 62 | eigene ID-Systematik `BR[MNOP]...` |
| `loud_units` | LOUD Unit Additions | 26 | Praefixe `L`, `V`, `W` |
| `WyvernBattlePack` | BattlePack | 25 | Praefix `W` |
| `brewlan` | BrewLAN_Units\BrewResearch | 20 | verschachtelter Untermod |
| `4D-CompatibilityPack` | 4DC | 15 | Kompatibilitaetsschicht |
| `blackops` | BlackopsACUs | 9 | Praefix `E`, alternative ACUs |
| `brewlan` | BrewLAN_Plenae\CityGeneration | 8 | Stadtgenerierung |
| `brewlan` | BrewLAN_Units\BrewIntel | 5 | verschachtelter Untermod |
| `brewlan` | BrewLAN_Plenae\Spomeniki | 2 | Denkmaeler |
| `brewlan` | BrewLAN_RNG\CrateDrop | 1 | Beutekiste |
| **Summe** | | **523** | |

Die Spalte "Einheiten" stammt aus der ersten Erhebung und ist **nicht gegen das
Dateisystem geprueft**. Bei `basegame` hat genau diese Pruefung einen Zaehlfehler
aufgedeckt (404 statt 432).

---

## Ablagemuster

```
gamedata.entpackt\<Archiv>\units\<ID>\<ID>_unit.bp                       civ_units
gamedata.entpackt\<Archiv>\mods\<Mod>\units\<ID>\<ID>_unit.bp            die meisten
gamedata.entpackt\brewlan\mods\<Mod>\<Untermod>\units\<ID>\<ID>_unit.bp  brewlan
```

`brewlan` ist tiefer verschachtelt als die uebrigen Pakete: `BrewLAN_Units`,
`BrewLAN_Plenae` und `BrewLAN_RNG` haben keinen eigenen `units\`-Ordner, sondern
enthalten weitere Mods, die je einen haben.

## Abweichungen von der ID-Systematik

| Paket | Abweichung |
|---|---|
| `TotalMayhem` | eigenes Schema `BR[MNOP]...`, Fraktion im 3. Zeichen |
| `civ_units`, `CityGeneration` | 3. Zeichen `C` = Civilian statt Domaene |
| `BlackOpsUnleashed` | `K`-Kennung: `BALK003` `BELK002` `BRLK001` `BRLK005` `BSLK004` |
| `brewlan` | `ZZZ...`, `ZZCITYBLOCK...`, `ZZCRATE`, `SNLMER1` ohne Fraktionskennung |
| `civ_units` | benannte Objekte: `UEF_Bus` `UEF_Car1` `UEF_Fence` `UEF_Streetlight_01` `UEF_truck` |
| `loud_units` | `UALX401` |
| `WyvernBattlePack` | `WEL03041` (fuenfstellig) |

## Pruefstand

Die Zaehlungen dieses Pakets sind **nicht** gegen das Dateisystem abgeglichen. Bei
`basegame` hat genau diese Pruefung einen Zaehlfehler aufgedeckt (404 statt 432).
Verfahren in [README.md](README.md), Abschnitt "Zaehlung pruefen". Steht in `../TODO.md`.
