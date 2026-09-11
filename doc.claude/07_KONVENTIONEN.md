# 07 — Konventionen

## 1. Mod-Ordner

- Name: `PascalCase` ohne Leer- und Sonderzeichen, z. B. `SchildRebalance`.
- Der VFS mountet ihn kleingeschrieben als `/mods/schildrebalance/` — interne Pfadangaben
  im Code deshalb **konsequent kleinschreiben**.
- Ein Mod = ein Anliegen. Lieber drei kleine Mods als ein Sammelsurium: kleinere Mods sind
  einzeln aktivierbar, leichter zu testen und kollidieren seltener.
- Präfix für eigene Mods: **`mm_`** (mein Mod) ist optional, aber hilfreich, um sie in
  `usermods\` sofort von den Fremdpaketen zu unterscheiden.

## 2. `uid`

- **Immer eine frische GUID.** Nie von einem anderen Mod kopieren.
- Format: `"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"` in Großbuchstaben, als String.
- Erzeugung z. B. per PowerShell: `[guid]::NewGuid()`
- Bei einer neuen Mod-Version, von der andere Mods abhängen könnten: neue GUID.
- Alle vergebenen GUIDs in `08_BESTANDSAUFNAHME.md` eintragen.

## 3. Unit-IDs für neue Einheiten

- Schema aus `03_BLUEPRINTS.md` beibehalten: `[Set][Fraktion][Domäne][Nummer]`.
- Für eigene Einheiten das Set-Präfix **`M`** verwenden (z. B. `MEL0101` = eigene UEF-Landeinheit),
  da `U`, `X`, `D`, `B`, `Z` bereits durch Vanilla und die LOUD-Pakete belegt sind.
- **Vor Vergabe prüfen:** `search_files` über `gamedata.entpackt` *und* `usermods` nach der ID.

## 4. Pfadangaben in Blueprints

**Belegt durch drei Testlaeufe am 2026-08-15** (`PlayTest`, Auswertung im CHANGELOG).

### 4.1 `.sca`-Animationen: immer vollstaendiger VFS-Pfad

Animationspfade in `Display.AnimationWalk`, `Display.AnimationDeath`,
`TransportAnimation` und Verwandten werden **strikt und absolut** aufgeloest.
Getestet wurde am Seraphim-SCU (`XSL0301`) und an der Selen (`XSL0101`), jeweils mit
blossem Auge an der Laufanimation beurteilt:

| Form | Beispiel | Ergebnis |
|---|---|---|
| erfundenes Verzeichnis | `/units/gibtesnicht/XSL0301_AWalk01.sca` | kaputt |
| richtige Wurzel, ohne Unterordner | `/units/XSL0101_awalk01.sca` | kaputt |
| reiner Dateiname | `XSL0301_AWalk01.sca` | kaputt |

Es gibt **keinen** Rueckfall auf das Verzeichnis des Blueprints, **keine** Suche nach dem
blossen Dateinamen und **keine** Suche innerhalb von `/units/`.

**Das unterscheidet `.sca` von Mesh-Texturen.** Dort loest ein blosser Dateiname wie
`AlbedoName = 'UEBSSG01_lod1_albedo.dds'` sehr wohl neben der `.bp` auf
(`gamedata.entpackt\lua\lua\system\Blueprints.lua`, `ExtractMeshBlueprint`, Z. 177-183).
Die Analogie traegt nicht - wer sie annimmt, baut still kaputte Pfade.

### 4.2 Fehlschlaege bleiben stumm

Ein ungueltiger Animationspfad erzeugt **keine** Meldung im `LOUD.log` - weder `error:`
noch `warning:`. In allen drei Testlaeufen blieb das Log unauffaellig. Der Fehler faellt
nur beim Hinsehen auf: die Einheit gleitet starr ueber den Boden, statt zu laufen.

**Konsequenz fuer die Fehlersuche:** "nichts im Log" ist bei Animationen kein Beleg fuer
"alles in Ordnung".

### 4.3 Folge: Mods sind an ihren Ordnernamen gebunden

Jeder absolute `/mods/<n>/...`-Pfad bindet den Mod an seinen Ordnernamen.

**Beim Umbenennen eines Mod-Ordners deshalb zwingend alle Verweise mitziehen.**
Suchmuster: `/mods/<alter_name>/` ueber `.bp` **und** `.lua` des Mods. Beim Umbenennen von
`dynamic_gameplay` nach `DynamicGameplay` waren es zwei Fundstellen - eine in einem
Blueprint, eine in einem Unit-Script.

Gegenprobe vor dem Umbenennen: findet die Suche nichts, ist der Mod frei
(so bei `HCPP` -> `ImprovedHydrocarbonPowerPlants`).

### 4.4 Bekannte kaputte Pfade im Fremdmaterial

| Datei | Pfad | Befund |
|---|---|---|
| `LOUD Unit Additions`, `XSBSSG01` und `XSBSSG02` | `/units/XSBSSG01/XSBSSG01_ADeath1.sca` | `/units/XSBSSG01/` existiert nicht - Thanatos hat dort keine Todesanimation. In `usermods\SquareShields\` korrigiert. |
| `usermods\t4add\units\SSL0403` | `/mods/brewlan/mods/BrewLAN_LOUD/units/ssl0403/...` (3x) | `/mods/brewlan/` existiert nicht; richtig waere `/mods/BrewLAN_LOUD/...`. Vom Kollegen eingebaut, im Original korrekt. **Noch nicht korrigiert.** |

## 5. Lua-Codestil

- **Stil der Originaldatei übernehmen.** Der Engine-Lua-Dialekt ist alt (siehe `04_LUA_SIM.md` §2);
  modernes Lua 5.1+ funktioniert hier teilweise nicht.
- Einrückung: 4 Leerzeichen.
- Bezeichner: Englisch, `PascalCase` für Funktionen/Klassen, `camelCase` für lokale Variablen.
- Kommentare: **Deutsch**, erklären *warum*, nicht *was*.
- Jede Hook-Datei beginnt mit einem Kopfkommentar:

```lua
--[[
    Mod:      SchildRebalance
    Hookt:    /lua/sim/Unit.lua
    Zweck:    Schildregeneration nach Treffer verzögern
    Original: gamedata.entpackt\lua\lua\sim\Unit.lua  (Funktion OnDamage)
    Risiken:  läuft bei jedem Treffer — Logik muss O(1) bleiben
    Stand:    2026-08-05
]]
```

- Alte Funktion **immer** sichern und aufrufen:

```lua
local OldName = Klasse.Name
function Klasse:Name(...)
    ...
    return OldName(self, ...)
end
```

- Unsicheres markieren: `-- UNGEPRÜFT: Signatur nicht in $SRC verifiziert`

## 5. Logausgaben

Festes Präfix pro Mod, damit sie im Log auffindbar sind:

```lua
LOG("SCHILDREBALANCE: Regenerationssperre aktiv für " .. self:GetUnitId())
```

Debug-Ausgaben in häufig laufenden Funktionen vor dem „Fertig"-Zustand entfernen oder hinter
einen Schalter legen:

```lua
local DEBUG = false
if DEBUG then LOG("SCHILDREBALANCE: ...") end
```

## 6. Blueprint-Änderungen

- **Immer `Merge = true`**, außer die Einheit soll wirklich vollständig ersetzt werden.
- `BlueprintId` explizit und kleingeschrieben setzen.
- Nur die tatsächlich geänderten Felder aufführen — keine kopierten Vollblueprints mit
  einer geänderten Zahl darin (unwartbar, bricht bei LOUD-Updates).
- Über jeden geänderten Wert ein Kommentar mit dem **Originalwert**:

```lua
Defense = {
    Health    = 15000,   -- Original: 12000
    MaxHealth = 15000,   -- Original: 12000
},
```

## 7. Dateiangaben — immer vollständig

Jede Datei außerhalb von `$DOC` wird mit **vollständigem absolutem Pfad** genannt — in
Antworten wie in der Dokumentation.

```
✅ C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\BuildingTemplates.lua  (Z. 77–78)

❌ BuildingTemplates.lua
❌ lua\lua\BuildingTemplates.lua
❌ $SRC\lua\lua\BuildingTemplates.lua
```

Grund: der Pfad soll direkt kopierbar sein. Abkürzungen und Platzhalter zwingen zum Suchen.
Zeilennummern gehören dahinter, wenn sie bekannt sind.

**Ausnahme:** Verweise auf Dokumente innerhalb von `$DOC` — dort reicht der Dateiname
(`03_BLUEPRINTS.md` §5), weil sie nebeneinander liegen.

Die Kurzformen `$FA`, `$LOUD`, `$SRC`, `$MODS`, `$DOC` aus `CLAUDE.md` §2 dienen dem
Überblick in Tabellen und Erklärungen — **nicht** als Pfadangabe für eine konkrete Datei.

---

## 8. Dokumentationspflicht

Für jeden selbst gebauten Mod existiert `usermods\doc.claude\mods\<Modname>.md`
(Vorlage: `doc.claude\mods\_VORLAGE.md`). Sie wird **gleichzeitig** mit dem Code
aktualisiert, nicht später — beides liegt im selben Git-Repository und gehört idealerweise
in denselben Commit.

`CHANGELOG.md` bekommt einen Eintrag pro abgeschlossener Änderung, mit Datum, Mod und
kurzer Beschreibung.

## 9. Dateien, die nie angefasst werden

```
LOUD\gamedata\                  gepackte Spieldaten
LOUD\gamedata.entpackt\         Referenzquelle
LOUD\bin\                       inkl. LoudDataPath.lua und LOUD.log
LOUD\doc\                       Original-Readmes der Distribution
LOUD\maps\  LOUD\sounds\  LOUD\usermaps\
alles unterhalb von $FA außerhalb von LOUD\

usermods\.git\                  Git-Verwaltung — Claude führt kein Git aus
usermods\<eingefrorener Mod>\   Bestand, siehe 08_BESTANDSAUFNAHME.md
```

Schreibbar ist ausschließlich: **neue Mod-Ordner unter `usermods\`** und
**`usermods\doc.claude\`**.

Wenn eine Aufgabe eine Änderung außerhalb der Schreibzonen zu erfordern scheint: **melden und
einen Weg innerhalb von `usermods` vorschlagen**, statt die Zone zu verlassen.
