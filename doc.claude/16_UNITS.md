# 16 — Einheitenliste: der Generator

> **Die Einheitendaten stehen in `17_UNITLISTE.md` und `units\`.**
> Dieses Dokument beschreibt das Werkzeug, das sie erzeugt.

Erzeugt durch:
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\doc.claude\tools\Get-Units.ps1
```
Ausgabe nach:
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\doc.claude\units\_generiert\
```

> **Das Skript ist am 2026-08-06 gelaufen.** Ergebnis: 1311 Einheiten mit Namen,
> Fraktion und Techstufe. Die Ausgabe liegt in `units\_generiert\` und ist in die
> handgepflegten Dateien eingearbeitet. Der Lauf hat ein komplett uebersehenes Archiv
> aufgedeckt (`loud_misc`, 136 Einheiten) - Einzelheiten in
> `units\_generiert\README.md`.
>
> **Achtung:** Fruehere Fassungen des Skripts schrieben nach `..\units\`. Seit
> 2026-08-06 ist der Standardpfad `..\units\_generiert\`. Abweichend setzbar mit
> `-OutDir`.

---

## 1. Warum das Skript unverzichtbar ist

Die erste Erhebung entstand durch Auflisten der `units\`-Verzeichnisse. Das lieferte Mod,
Unit-ID und - über die ID-Systematik - Fraktion und Domäne, hatte aber **drei blinde
Flecken**, die der Skriptlauf aufgedeckt hat:

1. **Ganze Archive rutschen durch.** `loud_misc` mit 136 Einheiten in fünf LOUD-eigenen
   Mods wurde übersehen.
2. **Blueprints ausserhalb von `units\`-Ordnern** werden nicht gefunden - etwa die 17
   `PING_*_unit.bp` in `brewlan\mods\BrewLAN_RNG\CrateDrop\effects\entities\`.
3. **Ordner ohne Blueprint** werden mitgezählt - im Paket `units` sieben, in `civ_units`
   siebzehn.

Ergebnis: 1175 statt der tatsächlichen 1311.

Dazu liefert das Skript, was über Verzeichnislisten gar nicht zu bekommen ist:
**Namen** aus `General.UnitName`, **Fraktion** aus `Categories` und die **Techstufe**.
Die Pakete haben keine Lokalisierungsdateien - die Namen stehen inline in jedem einzelnen
Blueprint. Bei 1311 Einheiten ist das über Einzelzugriffe nicht erreichbar.

Ausserdem: **`search_files` liefert falsche negative Ergebnisse** und rekursiert über
tiefe Bäume nicht zuverlässig (`15_LOG.md` Abschnitt 6). Für den Nachweis, dass eine ID
**nicht** existiert, taugt nur ein vollständiger Durchlauf.

## 2. Ausführen

```powershell
cd "C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\doc.claude\tools"
.\Get-Units.ps1
```

Falls PowerShell die Ausführung blockiert:
```powershell
powershell -ExecutionPolicy Bypass -File .\Get-Units.ps1
```

Laufzeit: einige Minuten. Keine Adminrechte nötig, **es wird nur gelesen** —
geschrieben wird ausschließlich nach `doc.claude\units\`.

## 3. Ausgabedateien

| Datei | Inhalt |
|---|---|
| `units.csv` | alle Einheiten, Semikolon-getrennt, UTF-8 — für Excel; **die kanonische Datenquelle** |
| `units.md` | nach Paket/Mod gruppierte Tabellen, zum Lesen |
| `units-summary.md` | Zählungen je Paket/Mod, je Fraktion, je Techstufe |

Spalten: `Paket · Mod · UnitID · Fraktion · Tech · Domaene · Name · Datei`

**Generiert — nicht von Hand bearbeiten.** Bei Änderungen das Skript erneut laufen lassen.

> `units.md` ist die **Skriptausgabe** und nicht zu verwechseln mit den handgepflegten
> Paketdateien in `units\` (`basegame.md`, `brewlan.md`, `blackops.md` …).

## 4. Wo die Blueprints liegen

Drei Muster, alle vom Skript abgedeckt:

```
gamedata.entpackt\<Archiv>\mods\<Mod>\units\<ID>\<ID>_unit.bp
gamedata.entpackt\<Archiv>\units\<ID>\<ID>_unit.bp                (units, civ_units)
usermods\<Mod>\units\<ID>\<ID>_unit.bp
```

⚠️ **`brewlan` ist tiefer verschachtelt** — dort liegen die Einheiten unter
`brewlan\mods\<Mod>\<Untermod>\units\<ID>\`, etwa `BrewLAN_Units\BrewResearch\units\`.
Das Skript findet sie über die rekursive Suche trotzdem, leitet den Mod-Namen aber
aus der zweiten Ebene ab. Vollständige Struktur: `17_UNITLISTE.md`.

Bekannte Mod-Ordner in den Archiven:

| Archiv | Mods darin |
|---|---|
| `units` | (kein `mods\` — direkt `units\`) |
| `civ_units` | (kein `mods\` — direkt `units\`) |
| `blackops` | `BlackOpsUnleashed`, `BlackopsACUs` |
| `brewlan` | `BrewLAN_Units`, `BrewLAN_LOUD`, `BrewLAN_Plenae`, `BrewLAN_RNG` |
| `TotalMayhem` | `TotalMayhem` |
| `loud_units` | `LOUD Unit Additions` |
| `WyvernBattlePack` | `BattlePack` |
| `4D-CompatibilityPack` | `4DC` |
| `loud_misc` | 24 LOUD-eigene Mods (`02_MODSYSTEM.md` §6.5) |

## 5. Wie Fraktion, Tech und Domäne ermittelt werden

Vorrang hat immer das Blueprint selbst, die ID-Systematik ist nur Rückfallebene:

| Feld | 1. Wahl | 2. Wahl | 3. Wahl |
|---|---|---|---|
| Fraktion | `Categories`: `UEF`/`AEON`/`CYBRAN`/`SERAPHIM`/`NOMADS` | `General.FactionName` | 2. Zeichen der ID (`A`/`E`/`R`/`S`) |
| Tech | `Categories`: `TECH1`…`EXPERIMENTAL` | `General.TechLevel` (`RULEUTL_*`) | — |
| Domäne | `Categories`: `STRUCTURE`/`NAVAL`/`AIR`/`LAND` | 3. Zeichen der ID (`L`/`A`/`S`/`B`) | — |
| Name | `General.UnitName` | `Interface.HelpText` | leer |

`<LOC xyz_name>`-Präfixe werden entfernt. Bleibt ein Feld leer, steht `?` in der Spalte —
das ist ein Hinweis auf ein ungewöhnliches Blueprint, kein Skriptfehler.

## 6. ⚠️ Die Liste sagt nicht, was im Spiel verfügbar ist

**Auf der Platte vorhanden ≠ im Spiel geladen.** Die Blueprints eines Mods werden nur
eingelesen, wenn der Mod in der Partie **aktiv** ist (`02_MODSYSTEM.md` §4).

Genau dieser Unterschied hat bei R-01 zu einer Fehldiagnose geführt (`15_LOG.md` §5):
`BEB4209` liegt unter
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\units\BEB4209\BEB4209_unit.bp
```
— aber `BlackOpsUnleashed` ist in der Regel nicht aktiv, also existiert die Einheit im Spiel
nicht. `BuildingTemplates.lua` verweist trotzdem darauf.

**Für die Liste heißt das:** Sie ist eine Bestandsaufnahme der Datenträgerinhalte. Welche
Mods in einer Partie aktiv waren, steht im `LOUD.log` (`15_LOG.md` §3).

## 7. Verwendung

- **Freie Unit-IDs finden** für eigene Einheiten (`03_BLUEPRINTS.md` §2, `07_KONVENTIONEN.md` §3)
- **Kollisionen erkennen** — dieselbe ID in mehreren Paketen
- **Überblick vor dem Neuschnitt** (`12_NEUSCHNITT.md`)
- **Nachschlagen**, in welchem Mod eine im Log auftauchende ID beheimatet ist

## 8. Aktualität

Nach jedem LOUD-Update neu erzeugen — zusammen mit `gamedata.entpackt\`
(`01_ARCHITEKTUR.md` §2). Ebenso nach jeder Änderung an eigenen Mods mit neuen Einheiten.
