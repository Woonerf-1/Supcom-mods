# tools\ — Hilfsmittel für die Arbeitsumgebung

Ort: `LOUD\usermods\doc.claude\tools\`

Werkzeuge und Systemeinstellungen, die das Modding erleichtern.
**Kein Mod** — nichts hier wird vom Spiel geladen.

Ausführliche Doku: [`..\14_TOOLS.md`](../14_TOOLS.md)

---

## Inhalt

| Datei | Zweck | Rechte |
|---|---|---|
| `Get-Units.ps1` | erzeugt die vollständige Einheitenliste nach `..\units\` | keine, **nur lesend** |
| `Expand-Gamedata.ps1` | entpackt `.scd`-Archive nach `gamedata.entpackt\` | Schreibrechte im Zielordner |
| `scd_als_ordner_an.reg` | `.scd` im Explorer als gepackten Ordner anzeigen | nur aktueller Benutzer, **keine Adminrechte** |
| `scd_als_ordner_aus.reg` | dasselbe rückgängig machen | nur aktueller Benutzer |
| `scd_als_ordner_an_systemweit.reg` | Variante für alle Benutzer | **Adminrechte nötig** |

---

## Gamedata entpacken

```powershell
cd "C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\doc.claude\tools"
.\Expand-Gamedata.ps1              # Basisspiel
.\Expand-Gamedata.ps1 -Ziel LOUD   # LOUD neu erzeugen
```

Weitere Parameter: `-Quelle`, `-OutDir`, `-Ueberschreiben` (ohne den Schalter werden
vorhandene Ordner übersprungen, ein zweiter Lauf ist also gefahrlos).

`.scd` ist ein ZIP; `ZipFile::ExtractToDirectory` verlangt aber die Endung `.zip`. Das
Skript kopiert deshalb je Archiv eine Kopie ins `%TEMP%`, entpackt sie und löscht sie
wieder. **Die Originale in `gamedata\` bleiben unangetastet.**

**Zwei Spiegel, nicht einer** — das ist der Punkt:

| Spiegel | Inhalt |
|---|---|
| `LOUD\gamedata.entpackt\` | 17 LOUD-Archive: `lua`, `units`, `brewlan`, `blackops`, `loud_misc`, … |
| `…\Supreme Commander Forged Alliance\gamedata.entpackt\` | Basisspiel: `effects`, `props`, `env`, `textures`, `meshes`, `projectiles`, `lua`, `units`, … |

LOUD mountet vom Basisspiel **nur** `textures.scd`, `effects.scd`, `env.scd`,
`projectiles.scd`, `props.scd` und `meshes.scd` (`LoudDataPath.lua`). Alles andere dort —
insbesondere `units\` und `lua\` — wird von LOUD vollständig ersetzt und ist im Spiel
nicht erreichbar. Beim Nachschlagen darauf achten, aus welchem der beiden Spiegel ein
Fund stammt.

Ohne den zweiten Spiegel ließen sich Verweise wie
`/effects/emitters/seraphim_rift_arch_base_01_emit.bp`,
`/props/DefaultWreckage/DefaultWreckage_prop.bp` oder `Tarmacs/Tar12x_01_albedo`
**nicht nachprüfen** — sie liegen sämtlich im gepackten Basisspiel.

⚠️ **Nicht selbstaktualisierend.** Nach einem Spiel- oder LOUD-Update erneut mit
`-Ueberschreiben` laufen lassen.

---

## Einheitenliste erzeugen

```powershell
cd "C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\doc.claude\tools"
.\Get-Units.ps1
```

Falls PowerShell blockiert: `powershell -ExecutionPolicy Bypass -File .\Get-Units.ps1`

Laufzeit einige Minuten. Ergebnis in `..\units\` (`units.csv`, `units.md`,
`units-summary.md`). Details: [`..\16_UNITS.md`](../16_UNITS.md)

---

## Warum das nützlich ist

`.scd`-Dateien sind umbenannte ZIP-Archive. Mit dem Registry-Eintrag öffnet ein
Doppelklick in `LOUD\gamedata\` direkt den Archivinhalt — praktisch zum schnellen
Nachsehen, ohne erst alles nach `gamedata.entpackt\` auszupacken.

**Ersetzt `gamedata.entpackt\` nicht.** Für Volltextsuche über die Spieldaten bleibt der
entpackte Ordner das Mittel der Wahl; der Explorer kann nicht in Archiven suchen.

## Anwendung

Doppelklick auf die `.reg`-Datei, Rückfrage bestätigen. Neu angemeldete Explorer-Fenster
zeigen die Änderung sofort; sonst hilft ein Neustart des Explorers.

Falls Regedit die Datei ablehnt (Zeilenenden), geht es auch ohne `.reg`:

```cmd
reg add    "HKCU\Software\Classes\.scd" /ve /d CompressedFolder /f
reg delete "HKCU\Software\Classes\.scd" /f
```

## ⚠️ Hinweis zu `.sca`

Die ursprüngliche Vorlage enthielt zusätzlich einen Eintrag für `.sca`.
**Der ist hier bewusst nicht übernommen** — `.sca` sind Animationsdateien, keine Archive.
Geprüft: die Datei beginnt mit der Kennung `ANIM`, nicht mit `PK`.

Begründung und Details in `..\14_TOOLS.md`.
