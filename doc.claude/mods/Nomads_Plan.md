# Plan: nomads-4-loud sauber nach `Nomads` uebernehmen

Stand 2026-10-22. **Freigegeben (Paul, 2026-10-22)** mit den Entscheidungen in Abschnitt 7. Alle Pfade relativ zu `$FA`.

> **Umgesetzt 2026-10-22: Phasen 1-8, ohne Testlauf.** Ergebnis und Abweichungen vom Plan: `mods\Nomads.md`.
> Geaendert gegenueber dem Plan: alles Fraktionsneutrale (Vorlagen, KI-Vorlagen, Layouts, Vorab-Bau, Tarmacs,
> Sprueche, Adjacency-Strahl, Erzeugen-Dialog) liegt nicht in Nomads, sondern als Uebergabe in
> `uebergabe\CustomFactions\` (Paul). KI-Stellen mit fester Fraktionszahl nur dokumentiert (eigenes Teilprojekt).
> `nomads-4-loud` archiviert in `_Altlasten`. Abschnitt 5 unten ist Analysestand vor der Umsetzung.
Bezug: `mods\Nomads.md` (Mod-Doku), Uebergabe "Custom Factions" (Session-Scratchpad
`CustomFactions\UEBERGABE-Modder.md`, Abschnitt 3/3a).

---

## 0. Grundsaetze

1. **`nomads-4-loud` bleibt unveraendert.** Alles wird kopiert; Pruefung per Git nach jedem Schritt.
2. **Kein Wurzel-Mount.** Der neue Mod liegt unter `/mods/nomads/`. Jeder Pfad (`import`,
   Texturen, Meshes, Sounds, Projektile) zeigt dorthin. Nichts verlaesst sich auf
   `LoudDataPath.lua`/`mount_nomads.lua`.
3. **Hook statt Vollkopie.** Die 9 Schatten-Dateien werden Hooks; eine Vollkopie nur, wo
   es nachweislich nicht anders geht - begruendet und als solche markiert.
4. **Mehrere Fraktionen mitdenken.** Fraktionseigenes steht im Fraktionseintrag
   (`lua\NomadsFaction.lua`). Mechanik, die jede Zusatzfraktion braucht (Vorlagen-Umrechnung,
   KI-Vorlagen), wird **fraktionsneutral** gebaut: sie liest die Fraktionstabelle, statt
   "Nomads" fest einzutragen.
5. **Adjacency nicht.** Der Schatten `sim\AdjacencyBuffs.lua` entfaellt; das ist der
   eigenstaendige Mod `AdjacencyRebalance`.
6. **Ballast bleibt draussen** (Abschnitt 2). Jede Datei bekommt eine Entscheidung:
   uebernehmen / umbauen / entfaellt.
7. Jeder Schritt: maschinelle Pfadpruefung (alle Literale loesen auf), ASCII, Doku, CHANGELOG,
   Commit-Vorschlag. Kein Testlauf ersetzt durch Vermutung.

## 1. Bestand der Quelle (Inventur 2026-10-22)

| Bereich | Dateien | Groesse | Ziel |
|---|---:|---:|---|
| `units\` | 799 (107 Einheiten: XNA 14, XNB 47, XNC 4, XNL 23, XNO 2, XNS 9, XNY 1, ZNB 6, XSS0302 1) | 268 MB | uebernehmen, Pfade umschreiben |
| `textures\` | 1516 | 42,5 MB | uebernehmen (Skin `ui\nomads`, Icons, Strategiesymbole) |
| `sounds\` | 32 | 43,9 MB | uebernehmen - Lademechanik pruefen (Phase 1) |
| `movies\` | 1 | 23,8 MB | **erledigt** (Ladefilm) |
| `env\` (Tarmacs) | 14 | 13,5 MB | uebernehmen |
| `meshes\` (Kartenrand) | 11 | 7,4 MB | uebernehmen (Skin) |
| `effects\` | 621 | 3,2 MB | uebernehmen |
| `projectiles\` | 148 | 0,7 MB | uebernehmen |
| `lua\` | 28 | 0,4 MB | uebernehmen, Importe umschreiben |
| `hook\` | 66 | 0,3 MB | einzeln pruefen (Abschnitt 4) |
| `shadow\` | 9 | 0,4 MB | zu Hooks umbauen (Abschnitt 5) |
| `loc\` | 2 | - | uebernehmen - Lademechanik pruefen |

## 2. Entfaellt (nicht uebernehmen)

| Was | Grund |
|---|---|
| `icons\hook\` (66 Dateien) | dateigleiche Kopie von `hook\` (Hashvergleich: 0 Abweichungen) |
| `.github\`, `.vscode\`, `setup\`, `tools\` | Entwicklungswerkzeuge |
| `CopyLoudDataPath.bat`, `LoudDataPath.lua`, `mount_nomads.lua`, `init_nomads.lua`, `shader_cleaner.bat` | Wurzel-Mount-Weg, ersetzt durch Custom Factions (Uebergabe 3.1) |
| `shadow\lua\sim\AdjacencyBuffs.lua` | eigener Mod `AdjacencyRebalance` |
| `textures\ui\common\faction_icon-sm\random_ico.dds` | Zufall gehoert Custom Factions |
| `hook\lua\ui\lobby\lobby.lua`, `hook\lua\ui\menus\main.lua` | FAF-Lobby-Funktion bzw. toter Hauptmenue-Film (erledigt, `mods\Nomads.md` 3) |
| `hook\lua\kirvesweapons.lua` | 0 Byte |

## 3. Phasen

### Phase 1 - Assets und Lademechanik klaeren
1. **Sounds:** wie LOUD Soundbanks eines Mods laedt ("Mounting mod ... with additional
   functionality (e.g. sounds)" im Log) - belegen, dann `sounds\` kopieren.
2. **Loc:** wie `<LOC ...>`-Texte eines Mods ins Spiel kommen (Quelle legt `loc\` an `/loc`) -
   belegen; falls kein Mod-Weg: Texte direkt in Hooks (wie beim Lobby-Tooltip).
3. Kopieren: `units`, `projectiles`, `effects`, `env`, `meshes`, `textures`, `sounds`, `loc`.

### Phase 2 - Pfade umschreiben (maschinell)
- Rund 363 `import('/lua/nomads...')` und alle Ressourcenpfade in `.bp`/`.lua` auf
  `/mods/nomads/...` (Uebergabe 3.8). Skript wie bei den bisherigen Extrakten; danach
  Pfad-Resolver: **jedes** Literal muss aufloesen (Mod, LOUD-Archive, Basisspiel).
- Strategiesymbole/Icons: wie LOUD sie fuer Mods findet (Icon-Suche in aktiven Mods,
  `BlackopsIconSearch.lua` Z. 57-62) - Ablageort danach waehlen.

### Phase 3 - `lua\` der Quelle
28 Dateien (Waffen, Projektile, Effekte, Einheitenklassen, Faehigkeiten, Tasks, UI-Panels):
nach `/mods/nomads/lua/...`; Importe darauf umstellen. `lua\sim\...` und `lua\user\...` pruefen,
ob sie LOUD-Dateien gleichen Namens ersetzen sollten (dann Hook) oder eigenstaendig sind.

### Phase 4 - Hooks (66 Dateien)
Jede Datei: Ziel in LOUD vorhanden? Inhalt gegen den **aktuellen** LOUD-Stand pruefen
(die Quelle ist teils veraltet, siehe 5). Einordnen nach Spiel (`hook\`) oder Front-End
(`hook_frontend\`). **18 Hook-Ziele gibt es in LOUDs `lua.scd` nicht** - je Datei klaeren, ob toter
FAF-Rest oder eigenstaendige Datei, die importiert wird:
`aibrainPlans`, `version`, `AI\AIBuilders\AIEconomicBuilders`, `...\SorianEconomicBuilders`,
`...\SorianStrategyPlatoonBuilders`, `AI\OpAI\AirAttacks_save`, `...\NavalAttacks_save`,
`...\DefaultBlankPlanlist`, `AI\PlatoonTemplates\LandPlatoonTemplatesSorian`,
`keymap\hotbuild`, `keymap\unitkeygroups`, `keymap\upgradetab`, `ui\dialogs\createunitfilters`,
`ui\game\nomads_avatars`, `ui\lobby\UnitsRestrictions`, `ui\notify\defaultmessages`,
`etc\faf\blacklist`, `effects\Entities\NBlackhole\NBlackhole_script`.

### Phase 5 - Schatten zu Hooks
| Schatten der Quelle | neu |
|---|---|
| `lua\factions.lua` | **erledigt** (Hooks Front-End + Spiel, `NomadsFaction.lua`) |
| `lua\CustomFactions\Nomads.lua` | **erledigt** (`NomadsFaction.lua`); KI-Felder nachtragen (Phase 7) |
| `lua\ui\lobby\aiNames.lua` | **erledigt** |
| `lua\CustomUnits\nomads.lua` | `/mods/nomads/lua/CustomUnits/` - LOUD liest das fuer aktive Mods selbst |
| `lua\CustomFactions\NomadsAIFiles\*` (3) | `/mods/nomads/lua/AI/...`, angebunden ueber Phase 7 |
| `lua\ui\game\construction.lua` | **Vorlagen, Abschnitt 4** - die Kopie ist **veraltet** (ihr fehlt LOUDs Zeile 26 `local DEEPCOPY = table.deepcopy`), einzige inhaltliche Aenderung: Praefixe fuer NOMADS |
| `lua\sim\AdjacencyBuffs.lua` | entfaellt |

### Phase 6 - Vorlagen fraktionsuebergreifend (Pauls Vorgabe) - siehe Abschnitt 4

### Phase 7 - KI
- KI-Vorlagen der Fraktion: `BuildingTemplates`, `BaseTemplates`, `UpgradeTemplates` (Quelle
  bindet sie ueber den Hook `hook\lua\BuildingTemplates.lua` an - fraktionsneutral, liest
  Felder `BuildingTemplatesFile` usw. aus dem Fraktionseintrag). **Fehler der Quelle:** prueft
  `faction.BaseTemplatesFile`, laedt aber `faction.BuildingTemplatesFile`.
- `PlatoonTemplateKey`, Builder-Hooks, `aibrain.lua`-Hook, `AIBehaviors`.
- **LOUD-Stellen mit fester Fraktionszahl** (Uebergabe 3a: `LUASIM-PLAN.md` Paragraph 131) - ohne
  Anpassung stuerzt die KI mit einer Zusatzfraktion ab oder baut nichts. Liste beschaffen, je Stelle
  fraktionsneutral loesen.

### Phase 8 - Pruefung und Abschluss
Testlaeufe (Abschnitt 6), Doku, Team-PDF-Abschnitt, `nomads-4-loud` per Git unveraendert.

## 4. Vorlagen fraktionsuebergreifend

### 4.1 Spieler-Bauvorlagen (Templates)
**Wie LOUD es macht:** `LOUD\gamedata\lua.scd`, `lua/ui/game/construction.lua`, in der globalen
Funktion `OnSelection` (Z. 3005-3351) die lokale Funktion `ConvertID` (Z. 3188-3208): Ist eine
Einheit der Vorlage fuer den Bauer nicht baubar, werden die Buchstaben der ID gegen die
Praefixe der **Fraktion des Bauers** getauscht (`ueb1101` -> `xsb1101`). Die Praefixliste kennt
nur AEON, UEF, CYBRAN, SERAPHIM (Z. 3190-3195).

**Folgen fuer eine Zusatzfraktion:**
- andere Fraktion baut eine Nomads-Vorlage: geht schon (`xnb1101` -> `ueb1101`, Muster `(%a+)(%d+)`);
- **Nomads-Bauer mit fremder Vorlage: `prefixes['NOMADS']` ist nil -> Lua-Fehler** in der
  Schleife Z. 3197. Die Quelle loest das mit einer Vollkopie von `construction.lua` (eine Zeile
  `["NOMADS"] = {"xna","xnb","xnc","xnl","xno","xns","xny","znb"}`).

**Vorschlag (fraktionsneutral):**
- Jeder Fraktionseintrag bekommt ein Feld `BuildingPrefixes` (Nomads: wie oben).
- Ein Hook ersetzt `OnSelection` durch eine Fassung, deren Praefixliste aus den vier
  LOUD-Fraktionen **plus allen Eintraegen mit `BuildingPrefixes`** gebaut wird - sonst
  wortgleich. Hooks sehen die Locals der Originaldatei (belegt durch den Lobby-Hook von Custom
  Factions, der `factionBmps` aus `lobby.lua` Z. 93 nutzt, Log 2026-10-22).
- **Wohin:** in **Custom Factions** (eine Stelle fuer alle Fraktions-Mods) - abzustimmen mit der
  SupComNet-Seite; Custom Factions hat bisher nur Front-End-Hooks. Ersatz: in Nomads.
- Nachteil jeder Loesung ohne LOUD-Aenderung: 347 Zeilen Kopie, die bei LOUD-Updates
  nachgezogen werden muessen. Besser langfristig: LOUD-Team bitten, die Praefixe aus
  `factions.lua` zu lesen.

### 4.2 Weitere "Vorlagen"
| Stelle | Quelle | Plan |
|---|---|---|
| KI-Bauvorlagen `BuildingTemplates`/`RebuildStructuresTemplate` | Hook der Quelle, liest Fraktionsfelder | fraktionsneutral uebernehmen, Fehler (Phase 7) beheben |
| KI-Basis-/Upgrade-Vorlagen | Dateien unter `NomadsAIFiles` | nach `/mods/nomads/lua/AI/`, ueber Fraktionseintrag |
| Ausbau-Tabelle `keymap\upgradetab` | Hook der Quelle | Ziel fehlt in LOUD - pruefen, ob LOUD Ausbauten anders fuehrt |
| Hotbuild `keymap\hotbuild` | Hook der Quelle, nutzt `FactionInUnitBpToKey` (nur dort definiert) | Ziel fehlt in LOUD - wahrscheinlich FAF, pruefen |
| Bautasten `ui\game\buildmodedata` | Hook der Quelle (Tastenbelegung je Bauer) | pruefen gegen LOUD-Stand |
| GAZ-Fabrikvorlagen `GAZ_UI\modules\template_alternatives` | LOUD, nur 4 Fraktionen | pruefen, ob genutzt; ggf. Nomads-Zuordnung ergaenzen |

## 5. Bekannte Befunde aus der Analyse
- Die Quelle ist teils **aelter als LOUD** (Beispiel `construction.lua`) - Vollkopien daraus wuerden
  LOUD-Verbesserungen zurueckdrehen. Deshalb Hooks und Pruefung gegen den aktuellen Stand.
- LOUD liest `lua\CustomFactions\*.lua`, `PreBuildUnits` und die KI-Felder **nicht** selbst; die
  KI-Felder wertet nur der Nomads-eigene Hook `BuildingTemplates.lua` aus.
- `XSS0302` (Seraphim-Praefix) liegt im Nomads-Ordner - klaeren, was das ist.

## 6. Tests (am Ende jeder Phase, Paul)
1. Lobby: Nomads waehlbar, Zufall zuletzt, KI-Nomade startet.
2. Spiel: Kommandant `XNL0001` entsteht, baut Grundgebaeude; Ladefilm.
3. **Vorlagen:** UEF-Vorlage mit Nomads-Ingenieur bauen; Nomads-Vorlage mit UEF-, Aeon-,
   Cybran-, Seraphim-Ingenieur bauen.
4. KI: Nomads-KI baut eine Basis und greift an; gemischte Partie mit allen fuenf Fraktionen.
5. Log: keine Fehler mit `nomads` im Pfad; Pfad-Resolver vor jedem Test.

## 7. Entscheidungen (Paul, 2026-10-22)
1. **Vorlagen-Umrechnung fraktionsneutral in Custom Factions.** Bei LOUD-Aenderungen an
   `construction.lua` (`OnSelection`) gegen LOUD abgleichen - die Stelle ist eher statisch.
   Custom Factions baut die SupComNet-Seite (`make_customfactions.ps1`); der Hook wird hier
   geschrieben und dorthin uebergeben.
2. **Umfang:** alles auf einmal, so weit es geht.
3. **Keine Zwischentests** - Paul testet am Ende. Deshalb besonders gruendliche statische
   Pruefung (Pfad-Resolver, Syntax, Gegenpruefung gegen LOUD) nach jeder Phase.