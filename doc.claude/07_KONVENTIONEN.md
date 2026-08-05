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

## 4. Lua-Codestil

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

## 7. Dokumentationspflicht

Für jeden selbst gebauten Mod existiert `usermods\doc.claude\mods\<Modname>.md`
(Vorlage: `doc.claude\mods\_VORLAGE.md`). Sie wird **gleichzeitig** mit dem Code
aktualisiert, nicht später — beides liegt im selben Git-Repository und gehört idealerweise
in denselben Commit.

`CHANGELOG.md` bekommt einen Eintrag pro abgeschlossener Änderung, mit Datum, Mod und
kurzer Beschreibung.

## 8. Dateien, die nie angefasst werden

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
