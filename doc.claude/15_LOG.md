# 15 — Log-Auswertung und Befundregister

```
LOUD\bin\LOUD.log
```

**Hier liegt immer das Log der zuletzt gespielten Partie.** Es wird bei jedem Spielstart
überschrieben — vor einer Analyse also sichern. Daneben: `LOUD - Kopie.log`, eine manuelle
Sicherung eines früheren Laufs. 🔒 Nur lesen.

**Dieses Dokument beschreibt das Log nicht, sondern führt ein Register.** Jede
grundsätzliche Warnung oder Fehlermeldung wird Schritt für Schritt im Code zurückverfolgt,
bis die Ursache benannt ist. Einmalige Beobachtungen aus einer Partie gehören nicht hierher.

---

## 1. Auswertungsverfahren

Das Log ist groß (Referenzlauf: 23.392 Zeilen, 2,1 MB) und lässt sich nicht am Stück lesen.

```
1. Größe prüfen                    get_file_info
2. In die Analyseumgebung kopieren copy_file_user_to_claude
3. Gruppieren statt lesen          grep -o '<Muster>' LOUD.log | sort | uniq -c | sort -rn
4. Kontext gezielt holen           sed -n 'START,ENDEp' LOUD.log
```

### ⚠️ Fallstrick: Zahlen nicht wegnormalisieren

Naheliegend ist, für das Gruppieren alle Ziffern zu ersetzen
(`sed 's/[0-9]\+/N/g'`), damit Tick-Nummern und Einheiten-IDs nicht jede Zeile einzigartig
machen. **Das zerstört aber genau die Information, um die es geht:** aus
`T3TeleportJammer` wird `TNTeleportJammer`, aus `T2Bomber` wird `TNBomber` — und die
Tech-Stufe ist bei SupCom nie Rauschen.

Besser: mit `grep -o` gezielt den interessanten Teil ausschneiden, statt pauschal zu
normalisieren.

```bash
grep -o 'failed DecideWhatToBuild - "[^"]*"' LOUD.log | sort | uniq -c | sort -rn
```

Dieser Fehler ist beim ersten Durchgang tatsächlich passiert und hat zu einem falschen
Befund geführt.

## 2. Zeilentypen

| Präfix | Bedeutung |
|---|---|
| `info:` | Statusmeldung |
| `warning:` | **bei LOUD nicht gleich Fehler** — enthält auch reine KI-Diagnose |
| `debug:` | Detailausgabe (Speicher, Ladevorgänge) |
| `*AI DEBUG` | LOUD-KI-Diagnose, steht hinter `warning:` oder `info:` |
| `*DEBUG` | LOUD-Initialisierungsschritte |

## 3. Nützliche Suchmuster

| Frage | Suche |
|---|---|
| Welche Mods wurden gemountet? | `Mounting mod '` |
| Welcher VFS-Pfad? | `mounted as '/mods/` |
| **Greift mein Hook?** | **`Hooked `** — nennt Ziel- und Quelldatei |
| Blueprint-Ladeende | `Loaded N blueprints in total` |
| Lua-Fehler | `error:`, `stack traceback`, `Unknown exception` |
| Sound verworfen? | `Did not load the custom sounds` |
| Eigener Mod aktiv? | eigenes `LOG("<MODNAME>: …")` |

Die `Hooked`-Zeile ist beim Entwickeln das wichtigste Werkzeug: sie belegt, dass ein Hook
gefunden **und** ausgeführt wurde, samt Pfad.

---

## 4. Verfahren zur Rückverfolgung

```
1. MELDUNG ISOLIEREN   Rohtext der Warnung, ohne Normalisierung.
2. QUELLE FINDEN       Meldungstext in gamedata.entpackt suchen.
                       Datei in die Analyseumgebung kopieren, dann grep -n.
3. ZWEIG LESEN         Welche Bedingung führt in den else-Zweig?
4. EINGABEN PRÜFEN     Woher kommen die Parameter? Existieren die referenzierten Daten?
5. URSACHE BENENNEN    Engine, LOUD-Daten, Mod oder eigener Code?
6. EINTRAGEN           Register unten, mit Status und Belegstellen.
```

Suche im Referenzcode: `search_files` findet nur Dateinamen, keinen Inhalt. Für Volltext
die Kandidatendatei kopieren und dort `grep -n` verwenden.

---

## 5. Befundregister

Status: 🔴 offen · 🟡 in Arbeit · 🟢 geklärt

### 🟡 R-01 — `failed DecideWhatToBuild - "T3TeleportJammer"`

**Aufkommen:** 15.041 Warnungen, 64 % aller Logzeilen, verteilt auf fünf KI-Spieler.

> ⚠️ **Korrektur vom 05.08.2026.** Dieser Eintrag stand kurzzeitig als 🟢 geklärt mit der
> Begründung „die Blueprint-IDs existieren nicht". **Das war falsch.** Sie existieren —
> siehe Schritt 5. Ursache des Irrtums: ein falsch-negatives `search_files` (§6).

**Rückverfolgung:**

**1. Meldung**
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\aibuildstructures.lua   (Z. 315)
```
in der Funktion `AIBuildBaseTemplateOrdered()`:
```lua
WARN("*AI DEBUG "..aiBrain.Nickname.." Eng "..eng.EntityID.." failed DecideWhatToBuild - "..repr(buildingType).."  platoon "..repr(eng.BuilderName))
```

**2. Auslöser** — dieselbe Datei, Z. 249:
```lua
local whatToBuild = DecideWhatToBuild( aiBrain, eng, buildingType, buildingTemplate)
```
Bei `nil` führt der Weg in den `else`-Zweig mit der Warnung.

**3. Sackgasse** — `DecideWhatToBuild` ist eine **Engine-Methode**, kein Lua:
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\EngineerManager.lua   (Z. 33, 467)
```
```lua
local DecideWhatToBuild = AIBrainMethods.DecideWhatToBuild
```
Nicht einsehbar → stattdessen die **Eingabedaten** prüfen.

**4. Zuordnung Bautyp → Blueprint-ID**
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\BuildingTemplates.lua
```
| Zeile | Eintrag | Fraktion |
|---|---|---|
| 77 / 78 | `{ 'T2TeleportJammer', 'beb4209' }` / `{ 'T3TeleportJammer', 'beb4209' }` | UEF |
| 184 / 185 | `bab4209` | Aeon |
| 289 / 290 | `brb4209` | Cybran |
| 390 / 391 | `bsb4209` | Seraphim |

**5. Die Einheiten existieren — aber in einem Mod**
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\units\BEB4209\BEB4209_unit.bp
```
Das `b`-Präfix steht für **BlackOps**, nicht für BrewLAN.

**Zwischenstand der Ursache:** Nicht „existiert nicht", sondern **nicht geladen**.
Die Blueprints eines Mods werden nur eingelesen, wenn der Mod in der Partie **aktiv** ist
(`02_MODSYSTEM.md` §4). `BlackOpsUnleashed` ist in der Regel nicht aktiv — dann liefert
`DecideWhatToBuild` `nil`, während `BuildingTemplates.lua` den Eintrag unabhängig davon
immer anbietet.

**Noch offen:** Bestätigen, dass `BlackOpsUnleashed` im Referenzlauf tatsächlich inaktiv
war (Mod-Liste am Logbeginn), und prüfen, ob `BuildingTemplates.lua` die Einträge
überhaupt an eine Mod-Bedingung knüpft.

**Bewertung:** Kein Modfehler von uns. Die KI fragt in jedem Durchlauf einen Bautyp an,
dessen Einheit mangels aktivem Mod nicht geladen ist.

**Folgen:** Log unbrauchbar ohne Filter; vermutlich Rechenzeit in einer Schleife, die unter
diesen Bedingungen nie gelingen kann.

**Beim Filtern:**
```bash
grep '^warning' LOUD.log | grep -v 'DecideWhatToBuild'
```

**Nicht unser Zuständigkeitsbereich** —
`C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata\lua.scd`
wird beim LOUD-Update ersetzt. Ein Hook auf `/lua/BuildingTemplates.lua`, der die vier
Einträge entfernt, wäre technisch möglich; erst sinnvoll, wenn die Log-Flut tatsächlich
stört.

---

### 🔴 R-02 — `Template "T2Bomber" for "Aeon" is empty { }`

**Aufkommen:** je 5× für `T2Bomber`, `T2LandMobileTMD`, `T3LandMobileTMD`,
`T3MobileAntiNuke` — alle nur für Aeon.

**Nächster Schritt:** Meldungstext suchen in
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\system\GlobalPlatoonTemplate.lua
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\PlatoonTemplates\
```
Vermutung: Aeon-Platoon-Templates ohne zugeordnete Einheiten — vergleichbar mit R-01,
aber auf Platoon- statt Bauebene.

---

### 🔴 R-03 — `Error in file /lua/RuleInit.lua : Unknown exception`

**Aufkommen:** 8×, jeweils während eines Kartenwechsels in der Lobby.

**Nächster Schritt:** lesen
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\RuleInit.lua
```
Prüfen, ob die Meldung mit `Map Unknown is missing a save file!` (4×) zusammenhängt.

---

### 🔴 R-04 — Lobby: `Attempt to set attribute 'BadMap' on nil`

**Aufkommen:** 12×, zusätzlich 2× `attempt to concatenate field '?' (a nil value)`.
Stack-Traceback nennt Zeile 4869, teils 4801 und 2357.

**Nächster Schritt:** diese Zeilen lesen in
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\ui\lobby\lobby.lua
```
Vermutung: ein Mitspieler hat eine Karte nicht.

---

### 🔴 R-05 — `<Spielername> is trying to cheat!`

**Aufkommen:** 3× je menschlichem Spieler, unmittelbar vor `Abandoned by Player` und
`Closing connection`.

**Nächster Schritt:** Meldungstext suchen in
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\SimCallbacks.lua
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\game.lua
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\sim\Unit.lua
```
Verdacht: eine Prüfung, die beim Verbindungsabbau anschlägt, nicht bei echtem Betrug.
**Bis dahin nicht bewerten.**

---

### 🔴 R-06 — `GetResource: Invalid name ""`

**Aufkommen:** 6×.

**Nächster Schritt:** `GetResource` suchen unter
```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\
```
Leerer Ressourcenname deutet auf einen unvollständigen Blueprint- oder Templateeintrag.

---

### 🟢 R-07 — Lose Dateien in `usermods\` erzeugen Warnungen

```
warning: Couldn't locate zip directory for '...\usermods\readme.md'
warning: Search path element "...\usermods\readme.md" is not a valid .zip file.
```

**Ursache geklärt:** `mount_mods()` in `bin\CommonDataPath.lua` behandelt jeden Eintrag im
Wurzelverzeichnis als Mod. Ordner werden gemountet, Dateien als Archiv geöffnet — bei
`.md` und `.txt` schlägt das fehl. Zwei Warnungen pro Datei und Start.
Siehe `11_DATAPATH.md` §2.

**Betroffen:** `README.md`, `test.txt`. `.git\` wird als `/mods/.git/` gemountet, ohne
Warnung (Ordner). **Folgenlos**, aber vermeidbar: `test.txt` kann weg.

---

### 🟢 R-08 — `Hooked /lua/system/Blueprints.lua with /mods/enhanced resources/hook/lua/system/Blueprints.lua`

Keine Warnung, sondern der Beleg für den `ModBlueprints`-Hookpfad:
**`hook\lua\system\Blueprints.lua`**. Nachgetragen in `03_BLUEPRINTS.md` §5 und
`10_VORLAGEN.md` §3.

---

## 6. ⚠️ Werkzeugfalle: `search_files` ist nicht verlässlich

**Ein negatives Ergebnis von `search_files` beweist nichts.**

Nachgewiesen am 05.08.2026:

| Suchwurzel | Muster | Ergebnis |
|---|---|---|
| `…\gamedata.entpackt\blackops` | `*4209*` | ❌ keine Treffer |
| `…\gamedata.entpackt\blackops` | `BEB4209_unit.bp` | ❌ keine Treffer |
| `…\blackops\mods\BlackOpsUnleashed\units\BEB4209` | `BEB4209_unit.bp` | ✅ Treffer |

Die Datei existiert. `search_files` findet sie nur, wenn man direkt auf ihren Ordner zeigt —
über tiefe Verzeichnisbäume rekursiert es offenbar nicht zuverlässig (Tiefen- oder
Zeitgrenze, die stillschweigend greift).

**Regeln daraus:**

1. **Nie aus einem leeren `search_files`-Ergebnis auf Nichtexistenz schließen.**
2. Zum Nachweis, dass etwas **nicht** existiert, taugt nur ein vollständiger Durchlauf —
   also ein Skript auf dem Rechner des Nutzers (`doc.claude\tools\`).
3. `search_files` bleibt brauchbar für **positive** Treffer in flachen Verzeichnissen.
4. Zum Suchen im Dateiinhalt taugt es ohnehin nicht — es matcht nur Dateinamen.

Dieser Fehler hat R-01 zwischenzeitlich falsch als geklärt markiert.

---

## 7. Merksätze

- Das Log wird **bei jedem Start überschrieben**. Vor der Analyse sichern.
- **Nicht jede `warning:` ist ein Fehler** — bei LOUD steckt dort auch KI-Diagnose.
- **Rohtext gruppieren, nicht normalisieren** (§1).
- **`Hooked …` ist beim Debuggen eigener Mods der beste Beleg.**
- Eigene Ausgaben mit festem Präfix (`07_KONVENTIONEN.md` §5), sonst unauffindbar.
- Ein Befund gilt erst als geklärt, wenn die Ursache **im Code belegt** ist — nicht, wenn
  sie plausibel klingt.
- **„Existiert nicht" und „nicht geladen" sind zwei verschiedene Dinge.** Ein Blueprint aus
  einem inaktiven Mod liegt auf der Platte, ist im Spiel aber nicht vorhanden.
- **Negative Werkzeugergebnisse sind keine Beweise** (§6).
