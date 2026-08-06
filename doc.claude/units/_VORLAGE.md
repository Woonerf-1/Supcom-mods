# Einheit `<UNITID>`

> Kopiervorlage für die Detailanalyse einer einzelnen Einheit.
> Kopie als `<UNITID>.md` anlegen (Großbuchstaben).
>
> Zurück: [`README.md`](README.md) · [`..\17_UNITLISTE.md`](../17_UNITLISTE.md)

| | |
|---|---|
| **Unit-ID** | `<unitid>` (im Code immer klein) |
| **Name** | |
| **Paket / Mod** | |
| **Fraktion** | |
| **Techstufe** | |
| **Domäne** | |
| **Mehrfach belegt?** | siehe [`ueberschreibungen.md`](ueberschreibungen.md) |

**Blueprint:**
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\...\<UNITID>_unit.bp
```

**Skript:**
```
...\<UNITID>_script.lua
```

**Name laut Lokalisierung:** Schlüssel `<unitid>_name` in
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loc_US\loc\US\strings_db.lua
```

---

## 1. Kategorien

```lua
Categories = {
    ...
}
```

Relevant für: Zielauswahl, Baumenü, KI-Verhalten, Buffs.

## 2. Kennwerte

| Feld | Wert | Zeile im Blueprint |
|---|---|---|
| `Defense.MaxHealth` | | |
| `Defense.RegenRate` | | |
| `Defense.ArmorType` | | |
| `Economy.BuildCostMass` | | |
| `Economy.BuildCostEnergy` | | |
| `Economy.BuildTime` | | |
| `Physics.MaxSpeed` | | |
| `Intel.VisionRadius` | | |

## 3. Waffen

| # | Klasse | Schaden | Feuerrate | Reichweite | Ziele |
|---|---|---|---|---|---|
| 1 | | | | | |

⚠️ Bei Änderungen per `Merge`: die Waffenliste wird **indexweise** gemergt
(`..\03_BLUEPRINTS.md` §4).

## 4. Baubarkeit

- **Gebaut von:** (Kategorien in `BuildableCategory` welcher Bauer?)
- **Baut selbst:** `Economy.BuildableCategory`
- **Enhancements:** ja / nein

## 5. Abhängigkeiten

- Meshes, Texturen, Animationen im Einheitenordner
- Verweise auf andere Pakete (Sounds, Effekte, Projektile)
- Wird von `BuildingTemplates.lua` oder KI-Templates referenziert? → welcher Bautyp

## 6. Überschreibungen

- Ersetzt diese ID einen Blueprint aus einem anderen Paket?
- Wird sie selbst überschrieben?
- → [`ueberschreibungen.md`](ueberschreibungen.md)

## 7. Auffälligkeiten

- Fehlende Felder, ungewöhnliche Werte, Abweichungen von der ID-Systematik
- Bekannte Log-Meldungen dazu → `..\15_LOG.md`

## 8. Quellen

Gelesene Dateien mit vollständigem Pfad und Zeilenangabe.
