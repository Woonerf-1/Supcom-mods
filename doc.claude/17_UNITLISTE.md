# 17 — Einheitenverzeichnis (Index)

**Einstieg zu allen Einheiten in allen Paketen, Mods und Fraktionen.**
Die Daten selbst liegen in [`units\`](units/) — Ordnerübersicht:
[`units\README.md`](units/README.md).

**Stand: 2026-08-05.** Erhoben durch Auflisten der Blueprint-Verzeichnisse unter
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\
```

---

## Wegweiser

| Frage | Datei |
|---|---|
| **Wird diese ID von einem Mod überschrieben?** | [`units\ueberschreibungen.md`](units/ueberschreibungen.md) |
| Einheiten des **Basisspiels** (Paket `units`), mit Namen | [`units\basegame.md`](units/basegame.md) |
| **Mod-Einheiten** aus `gamedata` — Übersicht | [`units\mods.md`](units/mods.md) |
|  ↳ Detaillisten je Paket | [`units\pakete.md`](units/pakete.md) |
| **Usermod-Einheiten** — unsere eigenen Mods | [`units\usermods.md`](units/usermods.md) |
| Volle Analyse einer einzelnen Einheit | `units\<UNITID>.md` — Vorlage: [`units\_VORLAGE.md`](units/_VORLAGE.md) |
| Wie ist der Ordner organisiert? | [`units\README.md`](units/README.md) |
| Liste maschinell neu erzeugen | [`16_UNITS.md`](16_UNITS.md) → `tools\Get-Units.ps1` |

---

## Die drei Kategorien

Maßgeblich ist der **Ablageort des Blueprints**, nicht das ID-Präfix:

| Kategorie | Ort | Einheiten | Datei |
|---|---|---:|---|
| **basegame** | `gamedata.entpackt\units\units\` | 432 | [`units\basegame.md`](units/basegame.md) |
| **mod** | `gamedata.entpackt\<Archiv>\…\units\` | 523 | [`units\mods.md`](units/mods.md) |
| **usermod** | `usermods\<Mod>\units\` | 218 | [`units\usermods.md`](units/usermods.md) |
| **Gesamt** | | **1173** | |

⚠️ **Die ID-Systematik taugt nicht als Kriterium** — `UAB8765` und `XSB8765` tragen
Basisspiel-Präfixe, liegen aber in `LOUD Unit Additions`; umgekehrt liegen 13 Einträge
mit `B`/`D`/`S`-Präfix im Basisverzeichnis. Sie ist eine Lesehilfe, kein Ordnungsmerkmal.

---

## Bestand

| Paket | Mod | Einheiten | Kategorie | Datei |
|---|---|---:|---|---|
| `units` | — | 432 | basegame | [`units\basegame.md`](units/basegame.md) |
| `brewlan` | BrewLAN_LOUD | 149 | mod | [`units\pakete.md`](units/pakete.md) |
| `civ_units` | — | 117 | mod | [`units\pakete.md`](units/pakete.md) |
| `usermods` | nomads-4-loud | 107 | usermod | [`units\usermods.md`](units/usermods.md) |
| `usermods` | UEF_trans_men | 97 | usermod | [`units\usermods.md`](units/usermods.md) |
| `blackops` | BlackOpsUnleashed | 84 | mod | [`units\pakete.md`](units/pakete.md) |
| `TotalMayhem` | TotalMayhem | 62 | mod | [`units\pakete.md`](units/pakete.md) |
| `loud_units` | LOUD Unit Additions | 26 | mod | [`units\pakete.md`](units/pakete.md) |
| `WyvernBattlePack` | BattlePack | 25 | mod | [`units\pakete.md`](units/pakete.md) |
| `brewlan` | BrewLAN_Units\BrewResearch | 20 | mod | [`units\pakete.md`](units/pakete.md) |
| `4D-CompatibilityPack` | 4DC | 15 | mod | [`units\pakete.md`](units/pakete.md) |
| `blackops` | BlackopsACUs | 9 | mod | [`units\pakete.md`](units/pakete.md) |
| `usermods` | NOMADS-try_b4_ur_BI | 9 | usermod | [`units\usermods.md`](units/usermods.md) |
| `brewlan` | BrewLAN_Plenae\CityGeneration | 8 | mod | [`units\pakete.md`](units/pakete.md) |
| `brewlan` | BrewLAN_Units\BrewIntel | 5 | mod | [`units\pakete.md`](units/pakete.md) |
| `usermods` | commanders | 4 | usermod | [`units\usermods.md`](units/usermods.md) |
| `brewlan` | BrewLAN_Plenae\Spomeniki | 2 | mod | [`units\pakete.md`](units/pakete.md) |
| `brewlan` | BrewLAN_RNG\CrateDrop | 1 | mod | [`units\pakete.md`](units/pakete.md) |
| `usermods` | test21000 | 1 | usermod | [`units\usermods.md`](units/usermods.md) |
| **Summe** | | **1173** | | |

Die Summe zählt **Blueprint-Ordner, nicht eindeutige Einheiten.**
⚠️ **98 IDs sind mehrfach belegt** — im Spiel gilt dann nur eine Fassung.
→ [`units\ueberschreibungen.md`](units/ueberschreibungen.md)

✅ Das Paket `units` (432) wurde am 2026-08-05 gegen das Dateisystem abgeglichen —
vollständig und ohne Erfindungen. Die übrigen Pakete sind **nicht** gegengeprüft
(`units\README.md`, Abschnitt „Zählung prüfen").

---

## Wo die Blueprints liegen

```
gamedata.entpackt\<Archiv>\units\<ID>\<ID>_unit.bp                       units, civ_units
gamedata.entpackt\<Archiv>\mods\<Mod>\units\<ID>\<ID>_unit.bp            die meisten Pakete
gamedata.entpackt\brewlan\mods\<Mod>\<Untermod>\units\<ID>\<ID>_unit.bp  brewlan
usermods\<Mod>\units\<ID>\<ID>_unit.bp                                   eigene Mods
```

---

## Lesehilfe: die ID-Systematik

**Pfadfinderregel:** Fraktion und Domäne sind zunächst aus der Unit-ID abgeleitet.
Wo Belege aus Blueprints oder Lokalisierungsdateien vorliegen, stehen sie **statt** der
Ableitung — und werden bei Gelegenheit weiter ergänzt (`TODO.md`).

Schema `[Set][Fraktion][Domäne][Nummer]`:

| Position | Zeichen | Bedeutung |
|---|---|---|
| 1 | `U` | Original Supreme Commander |
| | `X` | Forged Alliance |
| | `B` `D` `S` `L` `V` `W` `E` `Z` `C` `M` | LOUD- und Mod-Ergänzungen |
| 2 | `A` | Aeon |
| | `E` | UEF |
| | `R` | Cybran |
| | `S` | Seraphim |
| | `N` | Nomads (nur `nomads-4-loud`) |
| 3 | `L` | Land |
| | `A` | Luft |
| | `S` | See |
| | `B` | Gebäude |
| | `C` | Civilian (statt Domäne) |
| | `M` | Sonstiges, ungeklärt |

⚠️ Die Ableitung ist eine **Konvention, keine Garantie.** Maßgeblich ist immer
`Categories` im Blueprint.

### Stand der Ergänzung

| Bereich | Namen | Fraktion belegt |
|---|---|---|
| `units` | ✅ aus `strings_db.lua` (385 von 404) | ⬜ abgeleitet |
| `usermods\nomads-4-loud` | ✅ aus Lokalisierung | ✅ |
| `usermods\NOMADS-try_b4_ur_BI` | ✅ aus Blueprints | ✅ |
| `usermods\commanders`, `test21000` | — (kein `UnitName` im Blueprint) | ✅ |
| `usermods\UEF_trans_men` | ⬜ offen (97 Blueprints) | ⬜ |
| `TotalMayhem` | ⬜ offen | ✅ (4 Stichproben) |
| alle übrigen Pakete | ⬜ offen | ⬜ abgeleitet |

### Bekannte Abweichungen

| Paket / Mod | Abweichung |
|---|---|
| `TotalMayhem` | eigenes Schema `BR[MNOP]…`, Fraktion im **3.** Zeichen |
| `civ_units`, `CityGeneration` | 3. Zeichen `C` = Civilian statt Domäne |
| `nomads-4-loud` | 2. Zeichen `N` = Nomads; `XNO…`/`XNY…` ungeklärt |
| `BlackOpsUnleashed` | `K`-Kennung: `BALK003` `BELK002` `BRLK001` `BRLK005` `BSLK004` |
| `brewlan` | `ZZZ…`, `ZZCITYBLOCK…`, `ZZCRATE`, `SNLMER1` ohne Fraktionskennung |
| `units` | `…M…` als 3. Zeichen: `UAM0004` `UEM0006` `URM0004` `XSM0001` |
| `civ_units` | benannte Objekte: `UEF_Bus` `UEF_Car1` `UEF_Fence` `UEF_Streetlight_01` `UEF_truck` |
| `UEF_trans_men` | `MKT0409` |
| `loud_units` | `UALX401` |
| `WyvernBattlePack` | `WEL03041` (fünfstellig) |

---

## Freie Set-Präfixe für eigene Einheiten

Belegt: `U` `X` `B` `D` `S` `L` `V` `W` `E` `Z` `C` `M` `N`

Frei u. a.: `F` `G` `H` `I` `J` `K` `P` `Q` `T` `Y`

Vor Vergabe hier und in den Dateien unter `units\` gegenprüfen
(`07_KONVENTIONEN.md` §3).

---

## ⚠️ Grenzen dieser Erhebung

1. **Auf der Platte vorhanden ≠ im Spiel geladen.** Blueprints eines Mods werden nur
   eingelesen, wenn der Mod in der Partie aktiv ist (`02_MODSYSTEM.md` §4).
   Genau daran ist eine frühere Fehldiagnose gescheitert (`15_LOG.md` R-01).
2. **Erfasst sind Blueprint-Dateien.** `ModBlueprints()`-Hooks ändern Blueprints
   programmatisch, ohne eigene Datei (`03_BLUEPRINTS.md` §5) — das taucht hier nicht auf.
3. **Verhaltens-Hooks** (`hook\lua\sim\Unit.lua` u. ä.) ändern keine Blueprints, wohl aber
   das Verhalten aller Einheiten.
4. **Nicht-Unit-Blueprints** (Projektile, Props, Meshes, Emitter) sind nicht erfasst.
5. **Die 24 LOUD-eigenen Mods** aus `loud_misc.scd` (`02_MODSYSTEM.md` §6.5) wurden
   bislang nicht auf Einheiten geprüft.

## Aktualität

Nach jedem LOUD-Update neu erheben, zusammen mit `gamedata.entpackt\`
(`01_ARCHITEKTUR.md` §2). Ebenso nach jeder Ergänzung eigener Einheiten.
