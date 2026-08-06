# _generiert\ - maschinell erzeugte Einheitendaten

Zurueck: [../README.md](../README.md) - [../../17_UNITLISTE.md](../../17_UNITLISTE.md)

**Diese Dateien nicht von Hand bearbeiten.** Sie werden bei jedem Lauf ueberschrieben.

Erzeugt durch
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\doc.claude\tools\Get-Units.ps1
```

| Datei | Inhalt |
|---|---|
| `units.csv` | alle Einheiten, Semikolon-getrennt: Paket, Mod, UnitID, Fraktion, Tech, Domaene, Name, Datei |
| `units.md` | nach Paket/Mod gruppierte Tabellen |
| `units-summary.md` | Zaehlungen je Paket/Mod, Fraktion, Techstufe |

**Stand: 2026-08-06 23:42. 1311 Einheiten.**

---

## Verhaeltnis zu den handgepflegten Dateien

Die Dateien eine Ebene hoeher (`basegame.md`, `mods.md`, `pakete.md`, `usermods.md`)
zaehlen **Blueprint-Ordner unter `units\`**. Das Skript zaehlt **`*_unit.bp`-Dateien,
rekursiv ueber das gesamte Paket**. Beide Zahlen sind richtig, messen aber Verschiedenes.

| | handgepflegt | Skript |
|---|---:|---:|
| Zaehleinheit | Ordner unter `units\` | `*_unit.bp` rekursiv |
| Gesamt | 1175 | **1311** |

### Was das Skript zusaetzlich findet

1. **`loud_misc` - 136 Einheiten in 5 LOUD-eigenen Mods.** In der Handerhebung
   vollstaendig uebersehen:
   `LOUD Integrated Storage` (84), `ZLOUD Structure Enhancements` (36),
   `Enhanced Nukes` (8), `Artillery` (4), `Enhanced Commanders` (4).
2. **Blueprints ausserhalb von `units\`.** In `BrewLAN_RNG\CrateDrop\effects\entities\`
   liegen 17 `PING_*_unit.bp` - Beuteanzeigen, die als Einheiten definiert sind.
3. **`BrewLAN_Plenae\Logger`** hat 3 Einheiten, nicht null.
4. Einzelne Ordner enthalten mehr als ein `_unit.bp`.

### Was die Handerhebung zusaetzlich zeigt

1. **Ordner ohne Blueprint.** Im Paket `units` sind das sieben:
   `UEL0003` `URB0401` `URB3302` `URB4301` `XAA0002` `XRL0201` `XRL0404` -
   Verzeichnisse ohne `_unit.bp`, also keine Einheiten.
   In `civ_units` sind es 17, darunter die fuenf Strassenobjekte
   `UEF_Bus` `UEF_Car1` `UEF_Fence` `UEF_Streetlight_01` `UEF_truck`.
2. **Untermod-Granularitaet.** Das Skript fasst `BrewIntel` und `BrewResearch` zu
   `BrewLAN_Units` zusammen; die Handerhebung trennt sie.
3. **Ueberschreibungen.** Das Skript ermittelt sie nicht.

### Folgerung

Fuer **Namen, Techstufen und Vollstaendigkeit** ist `units.csv` die bessere Quelle.
Fuer **Ueberschreibungen und Ablageort-Kategorien** die handgepflegten Dateien.
Beides gehoert zusammengefuehrt - siehe `../../TODO.md`.

## Kennzahlen aus dem Lauf

| Fraktion | Einheiten |
|---|---:|
| UEF | 339 |
| Cybran | 317 |
| Seraphim | 269 |
| Aeon | 247 |
| Nomads | 115 |
| keine | 24 |

| Techstufe | Einheiten |
|---|---:|
| T3 | 421 |
| T1 | 307 |
| T2 | 284 |
| unbestimmt | 155 |
| Experimental | 144 |

Die 155 unbestimmten Techstufen sind Blueprints ohne `TECH*`-Kategorie und ohne
`General.TechLevel` - meist Props, Effekte und Hilfsobjekte.
