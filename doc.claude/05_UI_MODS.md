# 05 — UI-Mods

Ein UI-Mod ändert nur die Darstellung auf dem eigenen Rechner. Er ist deutlich
risikoärmer als ein Sim-Mod: kein Desync, keine Zustimmung der Mitspieler nötig.

---

## 1. Erkennungsmerkmal

```lua
-- mod_info.lua
ui_only = true
```

Folgen:
- Der Mod wird **nicht** über `gameinfo.Options.Mods` an die Simulation übergeben.
- Er wird direkt aus den Preferences des Spielers angewandt (`GetUiMods()` in `mods.lua`).
- Nur der eigene Rechner braucht ihn.

**Wichtig:** Sobald ein Mod irgendetwas an der Spiellogik ändert, ist `ui_only = false`
Pflicht — sonst spielt man effektiv ein anderes Spiel als die Mitspieler.

---

## 2. Verzeichnis `/lua/ui/` (Referenz in `gamedata.entpackt\lua\lua\ui\`)

| Pfad | Inhalt |
|---|---|
| `uimain.lua` | Einstiegspunkt der Benutzeroberfläche |
| `uiutil.lua` | Hilfsfunktionen, Skin-Zugriff, Standardelemente |
| `controls\` | wiederverwendbare Steuerelemente (Buttons, Listen, Slider …) |
| `dialogs\` | Dialogfenster |
| `game\` | **In-Game-HUD**: Baumenü, Auswahlleiste, Minimap, Ressourcenanzeige, Befehlsmodus |
| `lobby\` | Mehrspieler-/Skirmish-Lobby, Mod-Manager, Spieleroptionen |
| `menus\` | Hauptmenü |
| `help\`, `splash\`, `override\` | Hilfetexte, Startbildschirm, Overrides |
| `maputil.lua` | Kartenlisten und -metadaten |
| `AITooltips.lua` | Tooltips für KI-Optionen |

Ergänzend im Wurzelverzeichnis `/lua/`:
`GAZ_UI\`, `hotbuild\`, `keymap\`, `maui\` (UI-Framework), `skins\`, `options\`,
`EnhancedLobby.lua`, `LEMLobbyOptions.lua`, `GameColors.lua`, `spreadattack.lua`.

LOUD bringt hier eigene Erweiterungen mit — bei UI-Arbeit immer die LOUD-Version lesen,
nicht Vanilla-Wissen anwenden.

---

## 3. Muster für einen UI-Hook

```lua
-- usermods\MeinUIMod\hook\lua\ui\game\construction.lua
local OldSetupUI = SetupUI            -- Name aus der Originaldatei übernehmen

function SetupUI(...)
    local result = OldSetupUI(...)
    -- eigene Anpassung
    return result
end
```

Vorgehen:
1. Originaldatei in `gamedata.entpackt\lua\lua\ui\...` lesen.
2. Die konkrete Funktion identifizieren, die geändert werden soll.
3. Hook mit exakt demselben VFS-Pfad unter `hook\lua\ui\...` anlegen.
4. Alte Funktion sichern, aufrufen, Rückgabewerte durchreichen.

---

## 4. Sim ↔ UI

Die beiden Prozesse teilen keinen Speicher.

| Richtung | Mechanismus | Datei |
|---|---|---|
| UI → Sim | `SimCallbacks` | `/lua/SimCallbacks.lua` |
| Sim → UI | Sync-Tabelle | `/lua/SimSync.lua`, `/lua/UserSync.lua` |

Ein Mod, der beide Seiten braucht (z. B. UI-Knopf löst Sim-Aktion aus), ist **kein**
`ui_only`-Mod und muss bei allen Spielern aktiv sein.

---

## 5. Nützliche UI-APIs

```lua
import('/lua/maui/group.lua').Group
import('/lua/maui/bitmap.lua').Bitmap
import('/lua/maui/text.lua').Text
import('/lua/lazyvar.lua')                    -- reaktive Layoutwerte
LayoutHelpers.AtLeftTopIn(control, parent, x, y)
GetSelectedUnits()
GetFrontEndData() / SetFrontEndData()
Prefs.GetFromCurrentProfile(key) / SetToCurrentProfile(key, value)
```

Genaue Signaturen vor Verwendung in `gamedata.entpackt\lua\lua\maui\` bzw. `ui\` nachlesen.

---

## 6. Testen

UI-Fehler stehen ebenfalls in `LOUD\bin\LOUD.log` und erscheinen zusätzlich als rote
Meldungen im Spiel. Ein UI-Mod lässt sich schnell prüfen: Spiel starten, Mod im Mod-Manager
aktivieren, Skirmish gegen KI starten. Kein Neustart der Mitspieler nötig.
