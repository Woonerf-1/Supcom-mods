# Mod: Nomads

| | |
|---|---|
| **Ordner** | `LOUD\usermods\Nomads\` |
| **VFS-Pfad** | `/mods/nomads/` |
| **Anzeigename** | Nomads |
| **uid** | `B1CD51F1-6724-40D6-9B2B-639E24AB11DF` |
| **Version** | 0.1 |
| **Typ** | Sim-Mod (`ui_only = false`), Fraktions-Mod fuer Custom Factions |
| **Abhaengigkeit** | `requires = { 'custom-factions' }` (Custom Factions, uid `custom-factions`) |
| **Icon** | `/mods/nomads/Nomads.dds` - Abzeichen aus dem Fraktions-Logo (64x64 A8R8G8B8) |
| **Status** | **Neuaufbau abgeschlossen 2026-10-22 (Phasen 1-8), im Spiel ungetestet.** Braucht den Custom-Factions-Stand aus `uebergabe\CustomFactions\` |
| **Quelle** | `nomads-4-loud`, seit 2026-10-22 in `doc.claude\_Altlasten\nomads-4-loud\` (unveraendert archiviert) |

Alle Pfade relativ zu `$FA`. Plan und Entscheidungen: [Nomads_Plan.md](Nomads_Plan.md).

---

## 1. Zweck

Neuaufbau der Nomads-Fraktion fuer LOUD (Paul, 2026-10-22), sauber und so, dass weitere optionale Fraktionen
daneben bestehen koennen:

- **Kein Wurzel-Mount**, kein `LoudDataPath.lua`-Patch. Alles liegt unter `/mods/nomads/`; Anmeldung der Fraktion
  ueber Custom Factions (Front-End-Hooks per `frontend_hookdir`).
- **Hook statt Vollkopie.** Shadow nur fuer neue Dateien an festen Engine-Pfaden (Abschnitt 6).
- **Fraktionsneutrales gehoert nach Custom Factions** (Paul): Nomads liefert nur Daten (Felder im Fraktionseintrag,
  eigene Dateien). Die generischen Hooks liegen als Uebergabe in `doc.claude\uebergabe\CustomFactions\`.
- **Adjacency nicht:** die Adjacency-Werte der Quelle sind der eigenstaendige Mod `AdjacencyRebalance`.

## 2. Bestand

```
LOUD\usermods\Nomads\                3192 Dateien, 405 MB
  mod_info.lua                       frontend_hookdir, requires Custom Factions
  Nomads.dds                         Mod-Icon
  units\         804 Dateien  269 MB 109 Einheiten: XNA 14, XNB 47, XNC 4, XNL 23, XNO 2, XNS 9, XNY 1, ZNB 6, CNB 2
  textures\     1473          42 MB  Skin ui\nomads, Einheiten-Icons, Partikel, Fraktions-Icons
  sounds\         32          44 MB  Soundbanks (LOUD bindet <mod>\sounds automatisch an /sounds)
  movies\          1          24 MB  nomads_load.sfd (Ladebildschirm)
  env\            14          14 MB  Tarmacs
  meshes\         11           7 MB  Kartenrand
  effects\       621           3 MB  Emitter, Strahlen, Entities
  projectiles\   148         0,7 MB
  lua\            29         0,7 MB  Fraktionseintrag, Klassen, Waffen, Effekte, Faehigkeiten-Panel, KI-Vorlagen
  loc\             2                 Quelltexte (LOUD laedt sie nicht, Abschnitt 5)
  hook\           26                 Spiel-Hooks (Abschnitt 4)
  hook_frontend\   4                 Front-End-Hooks (Abschnitt 3)
  shadow\         25                 neue Dateien an festen Pfaden (Abschnitt 6)
```

Nicht uebernommen aus der Quelle (Plan Abschnitt 2): `icons\hook\` (Kopie von `hook\`), Entwicklungsordner,
Wurzel-Mount-Dateien (`CopyLoudDataPath.bat`, `LoudDataPath.lua`, `mount_nomads.lua`, `init_nomads.lua`),
`shadow\lua\sim\AdjacencyBuffs.lua`, Zufalls-Icon, `units\XSS0302` (veraltete, schwaechere Kopie des
Seraphim-Schlachtschiffs aus LOUD), `effects\particle.fx` (globaler Shader, Abschnitt 8), 4 dateigleiche
Partikeltexturen, die Veteranen-Layout-Datei, 12 Strategie-Icons, die LOUD selbst hat, sowie 7 tote bzw.
fehlbenannte Dateien (PNG als `.dds`/`.jpg`, "... copy.dds"; jetzt `_Altlasten\Nomads\`).

## 3. Fraktion, Front-End und Lobby

**Fraktionseintrag:** `lua\NomadsFaction.lua` (eine Quelle fuer Front-End und Spiel). Pflichtfelder laut Uebergabe
Custom Factions 3a vorhanden; alle UI-Pfade absolut `/mods/nomads/...` (`UIUtil.UIFile` uebernimmt vorhandene
absolute Pfade, `lua/ui/uiutil.lua` Z. 357-361). `loadingTexture = '/UEF_load.dds'` ist LOUDs eigenes Bild.

| Datei | Zweck |
|---|---|
| `hook_frontend\lua\factions.lua`, `hook\lua\factions.lua` | haengen Nomads an `Factions`, ergaenzen `FactionIndexMap`/`FactionDesToKey`; der Spiel-Hook ist fuer Ladebildschirm und Sim noetig (Uebergabe 3a) |
| `hook_frontend\lua\ui\lobby\aiNames.lua` | `ainames.nomads`, 57 Namen (ohne Eintrag bricht die Lobby mit KI ab, `lobby.lua` Z. 1451/1454) |
| `hook_frontend\lua\ui\help\tooltips.lua` | `lob_nomads`, `restricted_units_nomads` |
| `lua\CustomUnitRestrictions\nomads.lua` | Einheitenbeschraenkung "No Nomads" (Kategorie `NOMADS`) |

**Felder fuer Custom Factions** (Vertrag: `uebergabe\CustomFactions\README.md` Abschnitt 1): `BuildingPrefixes`,
`BuildingTemplatesFile`, `PreBuildUnits`, `LayoutFallback = 1`, `TauntsFile`, `AdjacencyBeam`, `Category`,
`DisplayName`, `FactionInUnitBp`. Nicht ausgewertet, fuer spaetere KI-Arbeit: `BaseTemplatesFile`,
`UpgradeTemplatesFile`, `PlatoonTemplateKey`.

Belegt per `LOUD\bin\LOUD.log` 2026-10-22 01:00: Front-End-Hooks angewendet, `Nomads: Fraktion angehaengt, Index 5`.

## 4. Spiel-Hooks

Jeder Hook gegen den aktuellen LOUD-Stand (`LOUD\gamedata\lua.scd`) geprueft; Kommentar im Kopf jeder Datei.

### 4.1 Umgebaut (Quelle war FAF-Stand oder brach LOUD)

| Hook | Inhalt | Warum umgebaut |
|---|---|---|
| `aibrain.lua` | Faehigkeiten-Verwaltung (EnsureAbilities, SetSpecialAbility, SetUnitSpecialAbility, CheckAbilities, GetUnitsWithAbility, GetSpecialAbilityParam) | LOUD hat kein `CreateBrainShared`; Tabellen entstehen bei Bedarf. Vorab-Bau ging nach Custom Factions |
| `abilitydefinition.lua` | Nomads-Faehigkeiten nur ergaenzt, wo der Name fehlt | Quelle ueberschrieb LOUDs `TargetLocation`/`EXScryTarget`; Leisten-Plaetze neu (LaunchNuke/LaunchTacMissile 12, AreaBombardment/Capacitor 9, IntelProbe 10) |
| `SimCallbacks.lua` | `ActivateCapacitor`, `AutoCapacitor` | Signatur `(data, units)` wie LOUD |
| `SimSync.lua`, `usersync.lua` | Sync der Faehigkeiten-Leiste | EntityID bzw. Pruefung auf `UnitAbilitiesTable` |
| `proptree.lua` | Wrapper um `Tree.OnDamage` nur fuer `BlackholeDamage`/`BlackholeDeathNuke` | Quelle ersetzte LOUDs Baum fast ganz (ohne Feuer-Uebergreifen) |
| `sim\buffdefinitions.lua` | nur `ACU_T2/T3/T4_Engineering_NMD` | doppelte Buffs lehnt LOUD ab (`BuffBlueprints.lua` Z. 41-43) |
| `ui\controls\worldview.lua` | Zielkreuze der Nomads-Faehigkeiten | greift nur bei `mode[2].Behaviour` (sonst Absturz bei LOUDs `TargetLocation`) |
| `ui\game\orders.lua` | nur `GetCurrentSelection()` | Rest war FAF |
| `ui\game\unitview.lua`, `ui\game\layouts\unitview_{left,mini,right}.lua` | Capacitor-Symbol und -Balken | doppelter Hintergrund entfernt, ohne `SetBG`, absolute Texturpfade |
| `skins\skins.lua` | Skin `nomads` (texturesPath `/mods/nomads/textures/ui/nomads`) | doppelter Eintrag `dialogColumnColor` entfernt |
| `ui\help\tooltips.lua` | Spiel-Tooltips | Lobby-Eintraege nach `hook_frontend` |
| `ui\game\buildmodedata.lua` | Baumodus (Taste B) | Fabrik-IDs auf znb95xx/96xx, nicht existierende IDs (xal0203, xnb4203, xnl0109, xns0301) und Quantentor-Vorgaben entfernt, doppeltes `['D']` behoben |
| `ui\uiutil.lua` (Spiel und Front-End) | installiert `lua\NomadsLoc.lua` | Texte, Abschnitt 5 |

### 4.2 Neu

| Hook | Inhalt |
|---|---|
| `hotbuild\buildingtab.lua` | 79 Eintraege in LOUDs Hotbuild-Gruppen; 11 FAF-Gruppen ohne LOUD-Gegenstueck ausgelassen (Quelle `keymap\unitkeygroups.lua`) |
| `hotbuild\upgradetab.lua` | 19 Ausbau-Zuordnungen; kein Hydrocarbon-Ausbau (LOUD fuehrt fuer keine Fraktion einen) |
| `system\Blueprints.lua` | Hydrocarbon-Kraftwerke CNB1202/CNB1302 nur mit ImprovedHydrocarbonPowerPlants (Abschnitt 7) |

### 4.3 Unveraendert uebernommen

`armordefinition.lua` (Nomads-Ruestungstypen), `TerrainTypes.lua` (Schwebe-Effekte), `utilities.lua`
(`GetAllUnitsInSphere`), `ui\game\gamemain.lua` (Faehigkeiten-Leiste), `ui\help\unitdescription.lua` (+ CNB-Texte).

### 4.4 Entfallen

| Hook der Quelle | Grund |
|---|---|
| `aibrainPlans`, `sim\ScenarioUtilities`, `AI\AIBehaviors`, `AI\AIBuilders\*`, `AI\OpAI\*`, `AI\PlatoonTemplates\*` | tote FAF-Reste (Ziele fehlen in LOUD) |
| `platoon` | brach LOUDs Experimental-KI |
| `sim\Buff.lua` | brach die KI-Cheat-Buffs (`RemoveBuff` lieferte nil) |
| `EffectUtilities`, `BuildingTemplates`, `tarmacs`, `ui\dialogs\createunit(filters)`, `ui\game\taunt`, `AI\sorianutilities`, `editor\MiscBuildConditions` | fraktionsneutral, jetzt Uebergabe Custom Factions (Abschnitt 9) |
| `defaultantiprojectile`, `game`, `kirvesweapons` (0 B), `shield`, `version`, `maui`, `options`, `etc`, `effects`, `projectiles` (CAANanoDart) | FAF-Stand bzw. ohne Wirkung in LOUD |
| `ui\game\missiontext`, `nomads_avatars`, `ui\lobby`, `ui\menus`, `ui\notify`, `unitviewDetail_*`, `user\UserScriptCommand`, `keymap\*` | FAF-Dateien, die LOUD nicht hat |
| `lua\CustomFactions\Nomads.lua`, `lua\nomadsbuffs.lua` | ersetzt durch `NomadsFaction.lua` bzw. ungenutzt |

## 5. Texte und Sprueche

- **Texte:** LOUD laedt nur `/loc/<sprache>/strings_db.lua` (`lua/system/Localization.lua` Z. 18-45); die
  Nomads-Textdatei wuerde nicht gelesen. `lua\NomadsLoc.lua` erweitert das globale `LOC` einmal je State, nur fuer
  die 504 Schluessel aus `lua\NomadsStrings.lua`, die LOUDs `strings_db` nicht hat (2 Doppelte bleiben LOUD).
- **Sprueche:** 18 Stueck in `lua\NomadsTaunts.lua` (Nichols 10, Benson 8), angemeldet ueber `TauntsFile`. Die
  Nummern vergibt Custom Factions fortlaufend ab 65 (Nomads als einzige Zusatzfraktion: `/65` bis `/82`); die
  Quelle belegte fest 99-116 und haette mit jeder weiteren Fraktion kollidiert. Kommt eine weitere Fraktion in der
  Reihenfolge davor, verschiebt sich der Block - Paul: so lassen. KI-Sprueche: `sorianutilities` am Fraktionsindex.

## 6. Shadow (neue Dateien an festen Pfaden)

- `shadow\lua\sim\tasks\` (LaunchNuke, LaunchTacMissile, NomadsAreaBombardment, NomadsIntelProbe,
  NomadsIntelProbeAdvanced): die Engine laedt Tasks per Namen aus `/lua/sim/tasks/<Name>.lua` (`IssueScript`).
- `shadow\textures\ui\common\game\strategicicons\` (5 Symbole x 4 Zustaende): Strategie-Icons haben einen festen
  Pfad. Nur Symbole, die LOUD nicht hat - kein Ueberschreiben.
- **Ungeprueft:** dass `shadowdir` neue Pfade (ohne Gegenstueck in LOUD) zuverlaessig hinzufuegt - TODO, im Testlauf
  pruefen (Faehigkeiten, Strategie-Icons dieser Einheiten).

## 7. Hydrocarbon-Kraftwerke (nur mit ImprovedHydrocarbonPowerPlants)

- CNB1202 Eckard (Improved Hydrocarbon Power Plant, Stufe 2) und CNB1302 Guenter (Advanced Hydrocarbon Power Plant,
  Stufe 3) aus Colins `NOMADS-try_b4_ur_BI` (jetzt `_Altlasten`), mit Icons.
- XNB1102 Basic Hydrocarbon Power Plant verweist von sich aus auf cnb1202 (`units\XNB1102\XNB1102_unit.bp`
  Z. 89-121), wie LOUDs T1-Kraftwerke auf die Einheiten aus ImprovedHydrocarbonPowerPlants. Werte identisch mit
  dessen Satz (Stufe 2: 21000 E, 1750 M, Bauzeit 2000, 875 E/s; Stufe 3: 64250 E, 4250 M, 5400, 4075 E/s).
- **Wo:** in Nomads (Paul: Fraktionsinhalte gehoeren nicht in andere Mods). Die Vermischung von Fraktions- und
  Inhalts-Mods ist grundsaetzlich noch zu besprechen (TODO).
- **Schalter:** `hook\lua\system\Blueprints.lua`, Wrapper um `RegisterAllBlueprints` (LOUD `lua/system/Blueprints.lua`
  Z. 499; nach allen `ModBlueprints`-Hooks, Z. 1335/1339). Fehlen beb1202/beb1302, werden CNB1202/CNB1302 nicht
  registriert (XNB1102 ohne Ausbau, wie LOUD ohne den Mod). Sonst uebernehmen sie Adjacency, RegenRate und
  StorageEnergy vom UEF-Gegenstueck - also die Mod-Manager-Einstellungen von ImprovedHydrocarbonPowerPlants.
  Log: `Nomads: verbesserte Hydrocarbon-Kraftwerke aktiv` bzw. `inaktiv`.
- **Angepasst:** Script-Importe `/mods/nomads/lua/...`, Klassen CNB1202/CNB1302, Name "Guenter" mit ue (Paul),
  neutrale Hilfetexte statt Colins Scherztexten. Mesh/Texturen = XNB1102 (dateigleich), groesser skaliert.

## 8. Pfade und Pruefung (Phase 8, 2026-10-22)

- **Umschreibung (Phase 2):** 1127 Pfade auf `/mods/nomads/` in 492 Dateien (Skripte im Session-Scratchpad
  `nomads\paths.ps1`, `nomads\vfsindex.ps1`). `nomadseffecttemplate.lua`: `EmtBpPath` bleibt LOUDs
  `/effects/emitters/`, 38 Verwendungen auf `EmtBpPathNomads`.
- **Pruefung ueber den ganzen Mod:** 969 Verweise auf `/mods/nomads/...` loesen auf (bis auf Pfad-Anfaenge, an die
  zur Laufzeit etwas angehaengt wird); 1188 Verweise auf LOUD-Pfade loesen auf.
- **22 Verweise ins Leere, schon in der Quelle:** Meteor2-6 (`/env/RedRocks/Props/Boulder0[2-6]_albedo.dds`),
  11 Projektile mit `/projectiles/CIFMolecularResonanceShell01/...` bzw. `/projectiles/TDFGauss01/...`
  (NAnnihilator1, NAPRound1/2, NAPRoundOC1, NArtilleryShell1/2, NGattlingRound1/2, NKineticRound1/2,
  NParticleBlastArtilleryShell1, NSplittingArtilleryShell1), `units\XNB9002` (Lod0), `units\XNC0003` (3 Texturen),
  `units\XNL0301` (Animation `Afold_2`). Ungeprueft, ob sie im Spiel stoeren (TODO).
- ASCII, Klammer- und Blockbilanz aller neuen und geaenderten Lua-Dateien geprueft.
- `nomads-4-loud` laut Git unveraendert (3327 Dateien) und dann archiviert.

**Offen aus der Quelle:**
- `effects\particle.fx`: globaler Partikel-Shader mit Teamfarben-Trick; nicht uebernommen (wuerde LOUDs Shader fuer
  alle Fraktionen ersetzen). Folge: Nomads-Effekte, die Teamfarbe erwarten, erscheinen ohne (ungeprueft).
- 17 Emitter fehlen schon in der Quelle.

## 9. Was Custom Factions liefern muss

Siehe `doc.claude\uebergabe\CustomFactions\README.md`. Ohne diesen Stand fehlen Nomads: Vorlagen-Umrechnung
(`construction.lua`, `hotbuild.lua`), KI-Bauvorlagen, Vorab-Bau, KI-Basis-Layouts, Tarmac-Rueckfall (sonst Absturz
bei Nomads-Gebaeuden), Sprueche, Nomads-Adjacency-Strahl, Filter im Erzeugen-Dialog.

**KI noch offen** (eigenes Teilprojekt, README Abschnitt 3): FactionSquads/FactionName, `factionnames`,
EnhancementTable fuer SCUs, Builder mit FactionIndex 1-4, Engineering-Stationen. Bis dahin kann eine Nomads-KI
abstuerzen oder wenig bauen.

## 10. Testlauf (Paul, ein Durchgang am Ende)

Voraussetzung: Custom Factions mit den Hooks aus der Uebergabe; `Nomads` aktiv. Danach `LOUD\bin\LOUD.log` auswerten.

1. **Mod-Manager:** Nomads mit neuem Icon; `nomads-4-loud` und `NOMADS-try_b4_ur_BI` erscheinen nicht mehr.
2. **Lobby:** Nomads waehlbar, Zufall zuletzt, Tooltip; KI-Spieler als Nomads (Name aus der Liste).
3. **Ladebildschirm:** Nomads-Film, wenn Nomads die zuletzt geladene Fraktion ist.
4. **Spielstart:** Kommandant XNL0001 entsteht; Vorab-Bau (mit eingeschaltetem Vorab-Bau: 4x XNB1103, XNB0101,
   4x XNB1101).
5. **Bauen:** Grundgebaeude, Fabriken, Ausbauten per Hotbuild; Strategie-Icons; Nomads-Skin der Oberflaeche.
6. **Faehigkeiten:** Leiste unten (Orbital-Schlag, Sonde, Kondensator) - ausloesen, Zielkreuze.
7. **Vorlagen:** UEF-Vorlage mit Nomads-Ingenieur; Nomads-Vorlage mit UEF-, Aeon-, Cybran-, Seraphim-Ingenieur;
   beides auch per Hotbuild-Vorlagentaste.
8. **Hydrocarbon:** ohne ImprovedHydrocarbonPowerPlants kein Ausbau an XNB1102, Log `... inaktiv`; mit ihm Ausbau zu
   Eckard und Guenter, Log `... aktiv`.
9. **Sprueche:** `/65` im Chat; KI-Nomade spricht.
10. **KI:** Nomads-KI gegen eine LOUD-KI - baut sie, greift sie an, stuerzt etwas ab?
11. **Log:** keine Fehler mit `nomads` im Pfad; `Hooked ...` fuer alle Nomads-Hooks; fehlende Texturen/Emitter notieren.
