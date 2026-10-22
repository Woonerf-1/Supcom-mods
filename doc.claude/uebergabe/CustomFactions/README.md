# Uebergabe an Custom Factions: fraktionsneutrale Hooks

Stand 2026-10-22. Vorschlag aus dem Neuaufbau des Nomads-Mods (`LOUD\usermods\Nomads`, Doku `doc.claude\mods\Nomads.md`).

Grundsatz (Paul, 22.10.): Alles, was mehrere Fraktionen betrifft, gehoert nach Custom Factions (CF), nicht in einen
Fraktions-Mod. Ein Fraktions-Mod liefert nur **Daten**: Felder im Fraktionseintrag und eigene Dateien.

`CustomFactions.scd` baut die SupComNet-Seite. Die Dateien hier sind **Vorschlaege**, ungetestet. Pfade unter
`hook\lua\...` entsprechen den LOUD-Dateien, die gehakt werden; sie gehoeren in den Spiel-Hook-Ordner von CF
(nicht `hook_frontend`). Jede Datei ist in sich geschlossen (keine Hilfsmodule, also unabhaengig vom Mount-Pfad).

**Wichtig fuer den Test:** Nomads verlaesst sich seit diesem Stand auf diese Hooks. Ohne sie gilt fuer Nomads:
keine Vorlagen-Umrechnung, kein Vorab-Bau, KI ohne Bauvorlagen/Layouts (Abbruch), Absturz bei Tarmacs von
Nomads-Gebaeuden, keine Nomads-Sprueche, Cybran-Strahl statt Nomads-Strahl, kein Nomads-Filter im Erzeugen-Dialog.

## 1. Felder im Fraktionseintrag (Vertrag)

Fraktionseintrag = Tabelle, die ein Fraktions-Mod per Hook auf `/lua/factions.lua` an `Factions` anhaengt
(Index 5 und folgende). LOUD selbst liest davon nur die Pflichtfelder aus `UEBERGABE-Modder.md` Abschnitt 3a.

| Feld | Typ | gelesen von | Bedeutung |
|---|---|---|---|
| `Category` | string | createunit.lua, MiscBuildConditions.lua | Einheiten-Kategorie der Fraktion, z. B. `'NOMADS'` |
| `FactionInUnitBp` | string | construction.lua, hotbuild.lua, EffectUtilities.lua | Wert von `General.FactionName` der Einheiten |
| `DisplayName` | string (LOC) | createunit.lua | Anzeigename |
| `BuildingPrefixes` | {string} | construction.lua, hotbuild.lua | Buchstaben-Praefixe der Gebaeude-IDs fuer die Vorlagen-Umrechnung |
| `BuildingTemplatesFile` | Pfad | BuildingTemplates.lua | Datei mit `BuildingTemplates` (+ optional `RebuildStructuresTemplate`) |
| `PreBuildUnits` | {MassExtractors={ids}, Regular={ids}} | aibrain.lua | Vorab-Bau |
| `LayoutFallback` | Zahl 1-4 | basetemplates.lua, Loud_*_Templates.lua | Basis-Layout welcher LOUD-Fraktion (Vorgabe 1 = UEF) |
| `TauntsFile` | Pfad | taunt.lua, sorianutilities.lua | Datei mit `Taunts = { {text, bank, cue}, ... }` |
| `AdjacencyBeam` | Pfad | EffectUtilities.lua | Emitter des Adjacency-Strahls |

Nicht ausgewertet (aus nomads-4-loud mitgenommen, fuer spaetere KI-Arbeit): `BaseTemplatesFile`,
`UpgradeTemplatesFile`, `PlatoonTemplateKey`.

## 2. Die Hooks

Belege beziehen sich auf LOUD `gamedata\lua.scd`, Stand 2026-10-22.

### Bauvorlagen
- `hook\lua\ui\game\construction.lua`: LOUDs `OnSelection` (Z. 3005-3351) mit erweiterter Praefix-Tabelle in
  `ConvertID` (Z. 3190-3195). Fraktion ohne Praefixe -> nicht umrechenbar statt Lua-Fehler.
- `hook\lua\hotbuild\hotbuild.lua`: LOUDs `buildActionTemplate` (Z. 452-599), gleiche Aenderung in `ConvertID`
  (Z. 479-492). LOUD bricht dort fuer eine fremde Fraktion ab (`for ... in nil`, Z. 486).
- `hook\lua\BuildingTemplates.lua`: setzt `BuildingTemplates[i]`/`RebuildStructuresTemplate[i]` fuer i > 4.
  Ersetzt den alten Nomads-Hook, der das in LOUD fehlende `factions.GetFactions` aufrief (Abbruch beim Import).
- Beide Vollkopien (construction, hotbuild) bei LOUD-Updates gegen das Original abgleichen.

### Vorab-Bau
- `hook\lua\aibrain.lua`: `OnSpawnPreBuiltUnits(self, multoverride)` wie LOUD (Z. 1004 ff.), danach Vorab-Bau aus
  `PreBuildUnits` fuer Index > 4, nur ohne `multoverride` (LOUD-Listen nur fuer Index 1-4, Z. 1077-1101).

### Layouts (KI)
- `hook\lua\basetemplates.lua`, `hook\lua\AI\AIBuilders\Loud_MAIN_base_templates.lua`,
  `Loud_Expansion_Base_Templates.lua`, `Loud_DP_Templates.lua`, `Loud_Perimeter_Defense_Templates.lua`:
  jede Layout-Tabelle hat 4 Eintraege und wird mit `[factionIndex]` gelesen (platoon.lua Z. 7293-7301, 7804, 7961).
  Index > 4 bekommt den Eintrag `[LayoutFallback or 1]`. Die Layouts nennen Gebaeudetypen, die IDs liefert
  `BuildingTemplates`; daher passt ein fremdes Layout (abgeleitet, nicht getestet).

### Tarmacs
- `hook\lua\tarmacs.lua`: `GetTarmacType` mit Rueckfall `''`. Der Fraktionsindex kommt aus dem 2. Zeichen der
  Blueprint-ID (defaultunits.lua Z. 576-578, `{e=1,a=2,r=3,s=4}`), fuer andere Buchstaben nil -> Abbruch Z. 71.

### Sprueche
- `hook\lua\ui\game\taunt.lua` und `hook\lua\AI\sorianutilities.lua`: Nummern fortlaufend ab 65 (LOUD 1-64,
  taunt.lua ab Z. 8), je Fraktion ein Block in der Reihenfolge von `Factions`. Beide Dateien rechnen gleich und
  muessen gemeinsam geaendert werden. `AITaunts` wird am Fraktionsindex gesetzt (sorianutilities.lua Z. 27, 86-97);
  Fraktion ohne Sprueche bekommt die Liste von Index 1 (sonst Abbruch Z. 89).
- Ersetzt die festen Nummern 99-116 aus nomads-4-loud. Diese haetten mit jeder weiteren Fraktion oder jedem Mod
  mit eigenen Spruechen kollidiert; `table.cat` auf `AITaunts` haengte nach Hook-Reihenfolge statt nach Index an.
- Rest-Risiko: ein Mod, der ohne diese Regel feste Nummern ab 65 belegt. Der UI-Hook warnt dann im Log.
- Spieler-Befehl fuer Nomads (einzige Zusatzfraktion): `/65` bis `/82`.
- Entscheidung Paul 2026-10-22: so belassen. Kommt eine weitere Fraktion in der Reihenfolge vor Nomads, verschiebt
  sich deren Block (die eingetippte Nummer haengt von den aktiven Fraktions-Mods ab). Innerhalb einer Partie passen
  Spieler, Gaeste und KI zusammen (gleiche Factions-Reihenfolge). Verworfen: feste Bereiche je Fraktion,
  Namensbefehl wie `/nomads3`.

### Adjacency-Strahl
- `hook\lua\EffectUtilities.lua`: LOUDs `CreateAdjacencyBeams` (Z. 1559-1608) wortgleich, nur der Zweig fuer
  Nicht-Aeon/UEF liest `AdjacencyBeam`. Vollkopie, bei LOUD-Updates abgleichen.

### Dialoge
- `hook\lua\ui\dialogs\createunit.lua`: Eintrag je Fraktion > 4 in `nameFilters[2].choices` (Z. 117-150).

### KI, optional
- `hook\lua\editor\MiscBuildConditions.lua`: `IsFactionCat(aiBrain, cat1, cat2, cat3)` als Baubedingung ueber die
  Kategorie statt fester Indexnummern (LOUD hat nur `FactionIndex`, Z. 17). Derzeit von keinem Builder genutzt.
- `GetFactions()` in `factions.lua` (Paul: gehoert nach CF): wird nach diesem Umbau von nichts mehr gebraucht. Nur
  aufnehmen, wenn kuenftige Fraktions-Mods sie erwarten (FAF-Konvention).

## 3. Offen: weitere Stellen mit fester Fraktionszahl (KI)

Aus der Pruefung von nomads-4-loud (Subagent-Bericht, Belege in `doc.claude\mods\Nomads.md` Abschnitt KI). Nicht
umgesetzt; das ist ein eigenes KI-Teilprojekt.

1. `FactoryBuilderManager`: `FactionSquads[aiBrain.FactionName]`; `FactionName` ist fuer Index > 4 nil
   (aibrain.lua Z. 246, Liste mit 4 Namen). Setzt man ihn ohne Squads, Abbruch Z. 777.
2. `PlatoonFormManager`: Tabelle `factionnames` (Z. 16) mit 4 Eintraegen.
3. `aibehaviors.lua` Z. 8168-8185: `EnhancementTable` fuer SCU-Upgrades, Abbruch fuer fremde SCU.
4. Builder mit `FactionIndex`-Bedingung 1-4: Zusatzfraktionen bekommen diese Builder nicht.
5. Engineering-Stationen und weitere Fraktionslisten in den Buildern.
