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

## 4. Quellen benennen

**Regel: nie "das Original" schreiben.** Bei jeder Aussage ueber fremden Code gehoert dazu,
**welche** Fassung gemeint ist. An unseren Einheiten haengen bis zu fuenf, und sie
unterscheiden sich inhaltlich - nicht nur in Pfaden.

### 4.1 Die fuenf Quellen

| Kuerzel | Was | Wo nachschlagen |
|---|---|---|
| **FAF** | FAForever - Weiterentwicklung des Basisspiels | `github.com/FAForever/fa` |
| **BrewLAN** | Balthazars Originalmod | `github.com/The-Balthazar/BrewLAN` |
| **BlackOps** | Lt_hawkeyes Originalmod | (Repo bisher nicht ermittelt) |
| **LOUD** | LOUDs angepasste Fassung der Fremdmods **und** eigener Spielcode | `github.com/LOUD-Project/Git-LOUD`, gespiegelt in `LOUD\gamedata.entpackt\` |
| **Colin** | `usermods\UEF_trans_men\` - der Sammelmod, aus dem wir ableiten | lokal |
| **unser** | `SquareShields`, `ImprovedHydrocarbonPowerPlants`, `DynamicGameplay`, `T4UnitAdditions` | lokal |

**LOUD und der jeweilige Fremdmod sind nicht dasselbe.** LOUD uebernimmt nicht identisch -
beim Panopticon (`SEB3404`) hat LOUD saemtliche Buff-Multiplikatoren neu gesetzt, beim
Darkness (`SRB4402`) den Buffnamen geaendert und die Definition nicht mitgenommen.

### 4.2 Schreibweise

Statt "gegen das Original gediffed" also:

> gegen **LOUD** gediffed (`gamedata.entpackt\brewlan\mods\BrewLAN_LOUD\units\SEB3404\`)

Bei Ketten die Richtung angeben:

> BrewLAN -> LOUD -> Colin -> unser

Wo ein Wert aus einer anderen Quelle stammt als der umgebende Code, gehoert das **in die
Datei selbst**, nicht nur in die Dokumentation. Genau daran ist Colins Darkness
gescheitert: er hat LOUDs Unit-Script mit BrewLANs `Buff.lua` kombiniert, ohne es zu
vermerken - und die beiden sprechen ueber unterschiedliche Buffnamen.

### 4.3 Repos holen

Die Repos lassen sich klonen; das ist der einzige Weg zu einer **Volltextsuche**.
`Filesystem:search_files` findet nur Dateinamen - und ist zudem **gross-/kleinschreibungs-
empfindlich**, der VFS im Spiel dagegen nicht. Das hat schon zu einem Fehlbefund gefuehrt:
`buffdefinitions.lua` wurde mit dem Muster `**/*Buff*` nicht gefunden, obwohl die Datei
existiert.

```bash
git clone --depth 1 --filter=blob:none --sparse https://github.com/LOUD-Project/Git-LOUD.git
git clone --depth 1 --filter=blob:none --sparse https://github.com/The-Balthazar/BrewLAN.git
git clone --depth 1 --filter=blob:none --sparse https://github.com/FAForever/fa.git
```

Danach `git sparse-checkout set <pfad>` fuer den benoetigten Teil, dann `grep -rn`.

### 4.4 Beispiel: der Darkness-Buff durch alle Quellen

| Quelle | Aufruf im Unit-Script | Definition des Buffs | `OmniRadius` in `Buff.lua` |
|---|---|---|---|
| **FAF** | kennt `SRB4402` nicht | - | vorhanden, `Buff.lua` Z. 437 |
| **BrewLAN** | `DarknessOmniNerf` | `hook/lua/sim/buffdefinitions.lua` Z. 27: `Mult = 0.6`, `Duration = 20.1` | per eigenem Hook nachgeruestet, nur fuer Nicht-FAF |
| **LOUD** | `DarknessEffect` | **fehlt** | vorhanden, `Buff.lua` Z. 546 |
| **Colin** | `DarknessEffect` | **fehlt** | BrewLANs Hook mitgeschleppt - behandelt `DarknessOmniNerf`, liegt unter `lua\` statt `hook\lua\` |
| **unser** | `DarknessEffect` | **fehlt** | erbt LOUDs |

Beide Negativbefunde sind per Volltextsuche ueber das gesamte jeweilige Repo belegt, nicht
nur stichprobenartig.

## 5. Pfadangaben in Blueprints

**Belegt durch drei Testlaeufe am 2026-08-15** (`PlayTest`, Auswertung im CHANGELOG).

### 5.1 `.sca`-Animationen: immer vollstaendiger VFS-Pfad

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

### 5.2 Fehlschlaege bleiben stumm

Ein ungueltiger Animationspfad erzeugt **keine** Meldung im `LOUD.log` - weder `error:`
noch `warning:`. In allen drei Testlaeufen blieb das Log unauffaellig. Der Fehler faellt
nur beim Hinsehen auf: die Einheit gleitet starr ueber den Boden, statt zu laufen.

**Konsequenz fuer die Fehlersuche:** "nichts im Log" ist bei Animationen kein Beleg fuer
"alles in Ordnung".

### 5.3 Folge: Mods sind an ihren Ordnernamen gebunden

Jeder absolute `/mods/<n>/...`-Pfad bindet den Mod an seinen Ordnernamen.

**Beim Umbenennen eines Mod-Ordners deshalb zwingend alle Verweise mitziehen.**
Suchmuster: `/mods/<alter_name>/` ueber `.bp` **und** `.lua` des Mods. Beim Umbenennen von
`dynamic_gameplay` nach `DynamicGameplay` waren es zwei Fundstellen - eine in einem
Blueprint, eine in einem Unit-Script.

Gegenprobe vor dem Umbenennen: findet die Suche nichts, ist der Mod frei
(so bei `HCPP` -> `ImprovedHydrocarbonPowerPlants`).

### 5.4 Bekannte kaputte Pfade im Fremdmaterial

| Datei | Pfad | Befund |
|---|---|---|
| **LOUD**, `LOUD Unit Additions`, `XSBSSG01` und `XSBSSG02` | `/units/XSBSSG01/XSBSSG01_ADeath1.sca` | `/units/XSBSSG01/` existiert nicht - Thanatos hat dort keine Todesanimation. In **unserem** `SquareShields` korrigiert. |
| **unser** `t4add\units\SSL0403` (von **Colin**) | `/mods/brewlan/mods/BrewLAN_LOUD/units/ssl0403/...` (3x) | `/mods/brewlan/` existiert nicht; richtig waere `/mods/BrewLAN_LOUD/...`. Bei **LOUD** korrekt. **Noch nicht korrigiert.** |

## 6. Lua-Codestil

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

usermods\.git\                  Git-Verwaltung — Claude fuehrt nur lesendes Git aus
usermods\<eingefrorener Mod>\   Bestand, siehe 08_BESTANDSAUFNAHME.md
```

Schreibbar ist ausschließlich: **neue Mod-Ordner unter `usermods\`** und
**`usermods\doc.claude\`**.

Wenn eine Aufgabe eine Änderung außerhalb der Schreibzonen zu erfordern scheint: **melden und
einen Weg innerhalb von `usermods` vorschlagen**, statt die Zone zu verlassen.
