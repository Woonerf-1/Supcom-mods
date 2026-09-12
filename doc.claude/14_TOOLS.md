# 14 — Werkzeuge

Ort: `LOUD\usermods\doc.claude\tools\`
Kurzübersicht: [`tools\README.md`](tools/README.md)

**Kein Mod.** Nichts in `tools\` wird vom Spiel geladen — der Ordner liegt unter
`doc.claude\`, und das hat kein `mod_info.lua`, taucht also in `AllMods()` nie auf.

---

## Übersicht

| Werkzeug | Zweck | Rechte | Laufzeit |
|---|---|---|---|
| `Get-Units.ps1` | vollständige Einheitenliste nach `units\_generiert\` | nur lesend | einige Minuten |
| `Expand-Gamedata.ps1` | `.scd`-Archive nach `gamedata.entpackt\` entpacken | Schreibrechte im Ziel | einige Minuten, GB-Bereich |
| `Test-Maps.ps1` | `maps\` und `usermaps\` auf unvollständige Szenarien prüfen | nur lesend | Sekunden |
| `scd_als_ordner_*.reg` | `.scd` im Explorer als Archiv öffnen | Registry | sofort |

Aufruf jeweils aus dem `tools\`-Ordner. Falls PowerShell die Ausführung verweigert:

```powershell
powershell -ExecutionPolicy Bypass -File .\<Skript>.ps1
```

---

## 1. `Get-Units.ps1`

Durchsucht `gamedata.entpackt\` und `usermods\` nach `*_unit.bp` und erzeugt in
`units\_generiert\`:

| Datei | Inhalt |
|---|---|
| `units.csv` | eine Zeile je Einheit: Paket, Mod, UnitID, Fraktion, Tech, Domäne, Name, Dateipfad |
| `units.md` | dasselbe als Tabelle |
| `units-summary.md` | Zusammenfassung je Paket |

**Wofür es unentbehrlich ist:** die Frage „wo kommt diese ID sonst noch vor". Genau damit
kam heraus, dass **alle 25 Einheiten unserer vier Extrakt-Mods bereits in einem
LOUD-eigenen Mod existieren** — einzige Ausnahme `MKT0409`.

⚠️ **Nicht selbstaktualisierend.** Nach neuen Mods oder einem LOUD-Update neu laufen
lassen. Der aktuelle Stand ist vom 2026-08-06 und kennt die vier Extrakt-Mods noch nicht.

Details: [`16_UNITS.md`](16_UNITS.md), [`17_UNITLISTE.md`](17_UNITLISTE.md)

---

## 2. `Expand-Gamedata.ps1`

```powershell
.\Expand-Gamedata.ps1              # Basisspiel
.\Expand-Gamedata.ps1 -Ziel LOUD   # LOUD neu erzeugen
```

Weitere Parameter: `-Quelle`, `-OutDir`, `-Ueberschreiben`. Ohne den Schalter werden
vorhandene Ordner übersprungen — ein zweiter Lauf ist gefahrlos.

`.scd` ist ein ZIP, aber `ZipFile::ExtractToDirectory` verlangt die Endung `.zip`. Das
Skript kopiert deshalb je Archiv eine Kopie ins `%TEMP%`, entpackt sie und löscht sie
wieder. **Die Originale in `gamedata\` bleiben unangetastet.**

### Zwei Spiegel, nicht einer

| Spiegel | Inhalt |
|---|---|
| `LOUD\gamedata.entpackt\` | 17 LOUD-Archive: `lua`, `units`, `brewlan`, `blackops`, `loud_misc`, `loud_units`, `civ_units`, … |
| `…\Supreme Commander Forged Alliance\gamedata.entpackt\` | Basisspiel: `effects`, `props`, `env`, `textures`, `meshes`, `projectiles`, `lua`, `units`, `ambience`, `loc_DE`, … |

**LOUD mountet vom Basisspiel nur sechs Archive** — `textures.scd`, `effects.scd`,
`env.scd`, `projectiles.scd`, `props.scd`, `meshes.scd` (`LoudDataPath.lua`). Alles andere
dort, insbesondere `units\` und `lua\`, wird von LOUD ersetzt und ist im Spiel
**unerreichbar**.

> **Beim Nachschlagen immer prüfen, aus welchem Spiegel ein Fund stammt.** Ein Treffer im
> Basisspiel-Spiegel unter `lua\` oder `units\` sagt nichts über das laufende Spiel aus.

Ohne den zweiten Spiegel ließen sich Verweise wie
`/effects/emitters/seraphim_rift_arch_base_01_emit.bp`,
`/props/DefaultWreckage/DefaultWreckage_prop.bp` oder `Tarmacs/Tar12x_01_albedo`
**nicht nachprüfen** — sie liegen sämtlich im gepackten Basisspiel. Bis zum 2026-08-16
standen sie in allen Mod-Dokumenten als „nicht einsehbar".

⚠️ **Nicht selbstaktualisierend.** Nach einem Spiel- oder LOUD-Update erneut mit
`-Ueberschreiben`.

---

## 3. `Test-Maps.ps1`

```powershell
.\Test-Maps.ps1              # beide Ordner
.\Test-Maps.ps1 -NurFehler   # nur die auffälligen Karten
.\Test-Maps.ps1 -Ordner usermaps
```

Liest jede `*_scenario.lua` in `maps\` **und** `usermaps\`, zieht die Felder `map`, `save`
und `script` heraus und prüft, ob die Dateien existieren. Zusätzlich, ob eine
`armies`-Tabelle vorhanden ist.

Beides fragt LOUD in `IsScenarioPlayable()` ab
(`gamedata\lua\lua\ui\maputil.lua`). Fällt eine Karte durch, erscheint sie **nicht** in der
Kartenauswahl.

**Warum es das Skript braucht:** LOUDs Warnung nennt die Karte nie beim Namen.

```lua
local mapName = 'Unknown' or scenario.name      -- Z. 92 und 98
```

`'Unknown'` ist immer wahr, der `or`-Zweig greift nie — im Log steht deshalb nur
`Map Unknown is missing a save file!`. Dokumentiert als Fundstelle **B-02** in
[`mods\BasegameBugfixes.md`](mods/BasegameBugfixes.md).

**Die Fallstrick-Auflösung:** beide Ordner werden ins VFS nach `/maps/` gemountet. Ein
Szenario in `usermaps\` kann deshalb auf eine Datei in `maps\` verweisen und umgekehrt.
Das Skript sucht in beiden Wurzeln; ein naiver Vergleich nur innerhalb des Kartenordners
meldet Fehler, die keine sind.

---

## 4. `.scd` im Explorer öffnen

| Datei | Wirkung |
|---|---|
| `scd_als_ordner_an.reg` | `.scd` wird als gepackter Ordner angezeigt, nur aktueller Benutzer |
| `scd_als_ordner_aus.reg` | rückgängig |
| `scd_als_ordner_an_systemweit.reg` | für alle Benutzer, **Adminrechte nötig** |

Ohne `.reg` geht es auch:

```cmd
reg add    "HKCU\Software\Classes\.scd" /ve /d CompressedFolder /f
reg delete "HKCU\Software\Classes\.scd" /f
```

**Ersetzt die entpackten Spiegel nicht.** Der Explorer kann nicht *in* Archiven suchen —
für Volltextsuche bleibt `gamedata.entpackt\` das Mittel der Wahl.

⚠️ **Nicht für `.sca`.** Die ursprüngliche Vorlage enthielt einen entsprechenden Eintrag;
er ist hier bewusst nicht übernommen. `.sca` sind Animationsdateien, keine Archive —
geprüft: die Datei beginnt mit der Kennung `ANIM`, nicht mit `PK`.

---

## 5. Repos als Suchwerkzeug

Kein Skript, aber das schärfste Werkzeug für Herkunftsfragen. **`Filesystem:search_files`
findet nur Dateinamen** — und ist zudem **groß-/kleinschreibungsempfindlich**, der VFS im
Spiel dagegen nicht. Das hat bereits zu einem Fehlbefund geführt: `buffdefinitions.lua`
wurde mit dem Muster `**/*Buff*` nicht gefunden, obwohl die Datei existiert.

```bash
git clone --depth 1 --filter=blob:none --sparse https://github.com/LOUD-Project/Git-LOUD.git
git clone --depth 1 --filter=blob:none --sparse https://github.com/The-Balthazar/BrewLAN.git
git clone --depth 1 --filter=blob:none --sparse https://github.com/FAForever/fa.git
```

Danach `git sparse-checkout set <pfad>` für den benötigten Teil, dann `grep -rn`.

Ein Sparse-Checkout von BrewLAN dauert unter einer Minute und liefert die Volltextsuche,
die lokal fehlt. Quellenkonvention: [`07_KONVENTIONEN.md`](07_KONVENTIONEN.md) Abschnitt 4.

---

## 6. Wann was

| Frage | Werkzeug |
|---|---|
| Wo kommt diese Unit-ID sonst vor? | `units.csv` aus `Get-Units.ps1` |
| Existiert dieser VFS-Pfad? | passender `gamedata.entpackt`-Spiegel |
| Wo ist dieser Bezeichner definiert? | Repo klonen, `grep -rn` |
| Warum fehlt eine Karte in der Auswahl? | `Test-Maps.ps1` |
| Schnell in ein Archiv schauen | `.reg`-Eintrag, Doppelklick |
