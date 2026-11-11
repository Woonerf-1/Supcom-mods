# FactionTemplate_StarCraft / FactionTemplate_W40K

| | |
|---|---|
| **Ordner** | `LOUD\usermods\FactionTemplate_StarCraft\`, `LOUD\usermods\FactionTemplate_W40K\` |
| **uid** | `E7112B35-0BDF-43D0-BA05-EB93CAD3F050` (StarCraft), `468E37CB-22BA-4199-BCDF-0EB47AC4CA8B` (W40K) |
| **Zweck** | Vorlagen fuer Fraktions-Mods auf Custom Factions; nur in der Lobby waehlbar (POC-Screenshot) |
| **Angelegt** | 2026-11-11 (Paul) |
| **Status** | gebaut, im Spiel ungetestet |

## Inhalt

- StarCraft: Zerg, Protoss, Terran. W40K: Imperium, Orks, Eldar, Necrons, Tyranids, Chaos.
- Nur Front-End: `hook_frontend\lua\factions.lua` haengt die Eintraege aus `lua\TemplateFactions.lua` an
  (Muster wie `Nomads\hook_frontend\lua\factions.lua`), dazu Lobby-Tooltips und KI-Namen
  (`lobby.lua` Z. 1451 bricht sonst bei KI-Slots ab).
- Kein `hook`, keine Einheiten: Partie mit einer dieser Fraktionen starten funktioniert **nicht** (gewollt).
- `requires = { 'custom-factions' }`.

## Icons

Je Fraktion drei Groessen wie bei Nomads: `faction_icon-sm` 18 x 18 (Lobby-Auswahl),
`widgets\faction-icons-alpha_bmp` 24 x 24, `faction_icon-lg` 60 x 60. Seit 2026-11-11 Original-Logos fuer den
POC-Screenshot (nur intern): StarCraft aus Liquipedia (`Zicon/Picon/Ticon.png`, 21 x 19), Imperium/Necrons aus
github.com/Warhammer40kGroup/wh40k-icon (MIT, SVG), Orks/Eldar/Tyranids/Chaos von Paul (Fandom-WebP).
Markenzeichen von Blizzard bzw. Games Workshop - Mods so nicht weitergeben.

**Ungeprueft:** ob Lobby-Combo und Tooltip PNG statt DDS anzeigen (Mod-Manager zeigt PNG, siehe EnhancedPauseBehavior).
Faellt das aus, als DDS speichern und die Endung in `TemplateFactions.lua` anpassen.
