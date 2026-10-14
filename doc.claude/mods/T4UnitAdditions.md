# Mod: T4UnitAdditions

| | |
|---|---|
| **Ordner** | `LOUD\usermods\T4UnitAdditions\` (bis 2026-10-14: `t4add`) |
| **VFS-Pfad** | `/mods/t4unitadditions/` |
| **uid** | `A0B5C51C-A8F7-47E0-BAEF-DE1FFCC63805` (bis 2026-10-14: `expt4modsV01`) |
| **Name** | T4 Unit Additions (vorher "Experimentierfreudige Menschen", bei Colin "Experimentierfreudiege Menschen") |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Status** | **Umgesetzt 2026-10-14, im Spiel ungeprueft.** Abschnitt 11 |
| **Im letzten Lauf aktiv** | nein (`LOUD\bin\LOUD.log` vom 2026-09-13, Mod-Liste ab Z. 930) |

Abschnitte 2-9 beschreiben den **Ausgangszustand** vor der Umsetzung (Analyse
2026-10-14). Was daraus wurde, steht in Abschnitt 11.

Uebergeordnet: [18_ABLEITUNG.md](../18_ABLEITUNG.md)

Hiess bis 2026-10-14 `t4add`. Abschnitte 2-9 verwenden den alten Namen, weil sie den
Zustand vor der Umbenennung beschreiben.

Alle Pfade relativ zu `$FA`. Diffs mit `git diff --no-index --ignore-cr-at-eol`.

---

## 1. Zweck und Inhalt

Neun Experimentaleinheiten aus Colins Sammelmod `UEF_trans_men`. Inhaltliche Klammer:
**transportierbare Experimentelle** plus der Traeger dafuer (`MKT0409`).

| ID | Name im Blueprint | Herkunft (LOUD-Paket) | Rolle |
|---|---|---|---|
| `MKT0409` | Acclamator | **nirgends** - einzige echte Neuheit; Modell eigen, Waffen aus BlackOps (`BEA0402` Citadel II) | Lufttraeger, `Class4AttachSize = 1` |
| `UEL0401` | Fatboy | **Basisspiel** (`LOUD\gamedata.entpackt\units\units\UEL0401\`) | transportierbar gemacht |
| `UEL0402` | Rampage | 4DC | umgebaut, transportierbar |
| `UAL0402` | Overlord | 4DC | umgebaut |
| `WEL0401` | Littleman | BattlePack | umgebaut, transportierbar |
| `WSL0404` | Yath-Yen | BattlePack | transportierbar, laengere Bauzeit |
| `SSL0403` | Iyadesu | BrewLAN for LOUD | unveraendert bis auf Pfade |
| `SSA0001` | (ohne Namen) | BrewLAN for LOUD | Bau-Drohne der Iyadesu (`SSL0403_Script.lua` Z. 34) |
| `VEB2302` | Flayer II | LOUD Unit Additions | **byte-identisch**, siehe 9.2 |

## 2. Bestand

499 Dateien, 51,8 MB.

```
LOUD\usermods\t4add\
  mod_info.lua
  units\           9 Einheiten, 74 Dateien (inkl. Thumbs.db in WEL0401)
  projectiles\     3 Projektile (RailGun01, BPNapalmMissile, over_charge), je bp + script
  lua\             7 Bibliotheken, ~3200 Zeilen
  effects\Emitters\  406 Emitter
  effects\entities\  1 Entity (EffectEMPAmbient01)
  textures\        2 Partikeltexturen + MKT0409_icon.dds
```

Kein `hook\`, kein `shadow\`, kein `lua\CustomUnits\`, keine Lokalisierung, kein `icon`.

## 3. Dreifachvergleich - LOUD-Quelle, UEF_trans_men, t4add

Quelle jeweils `$SRC`. `$SRC` gegen `Repos\LOUD` fuer alle acht Quell-Einheiten:
**0 Abweichungen** - der entpackte Stand ist fuer diese Dateien aktuell.

### 3.1 Einheiten

Zeilenzahlen = geaenderte Zeilen (entfernt + hinzugefuegt). Alle Binaerdateien
(`.scm`, `.sca`, `.dds`) sind in allen drei Fassungen identisch.

| Datei | Quelle -> UTM | UTM -> t4add | was in UTM -> t4add |
|---|---:|---:|---|
| `MKT0409_unit.bp` | - | 4 | Projektilpfad `UEF_trans_men` -> `t4add` |
| `MKT0409_script.lua` | - | 6 | drei Importpfade |
| `SSA0001` (alle) | 0 | 0 | |
| `SSL0403_unit.bp` | **6** | 0 | |
| `SSL0403_Script.lua` | **2** | **11** | Nil-Schutz, siehe 5.2 |
| `UAL0402_unit.bp` | **24** | 4 | zwei Animationspfade `4DC` -> `t4add` |
| `UAL0402_Script.lua` | 0 | 2 | Emitterpfad `4DC` -> `t4add` |
| `UEL0401_unit.bp` | **3** | 0 | |
| `UEL0402_unit.bp` | **25** | 4 | Projektilpfad |
| `VEB2302` (alle) | 0 | 0 | |
| `WEL0401_unit.bp` | **37** | 2 | Projektilpfad |
| `WSL0404_unit.bp` | **4** | 0 | |
| `WSL0404_Script.lua` | 12 | 12 | nur Emitterpfad, zweimal umgeschrieben |

### 3.2 Bibliotheken unter `lua\`

| Datei | Zeilen | Quelle | gegen Quelle |
|---|---:|---|---|
| `BlackOpsweapons.lua` | 1009 | BlackOps Unleashed | nur `/mods/BlackOpsUnleashed/` -> `/mods/t4add/` |
| `BlackOpsprojectiles.lua` | 950 | BlackOps Unleashed | nur Pfade |
| `BlackOpsEffectTemplates.lua` | 743 | BlackOps Unleashed | nur `EmtBpPathAlt` |
| `BlackOpsdefaultcollisionbeams.lua` | 300 | BlackOps Unleashed | nur Pfade |
| `4D_projectiles.lua` | 70 | 4DC | identisch |
| `BattlePackprojectiles.lua` | 61 | BattlePack | gekuerzt (Flamethrower, StarAdderMissiles entfernt) + Pfade |
| `BattlePackEffectTemplates.lua` | 50 | BattlePack | gekuerzt + Pfade |

### 3.3 Der Kernbefund

**t4add = `UEF_trans_men` + Pfadumschreibungen + eine Script-Aenderung** (`SSL0403`, 5.2).
Saemtliche Wertaenderungen stammen aus `UEF_trans_men`, also von Colin. Damit ist die
offene Frage aus `18_ABLEITUNG.md` Abschnitt 6 fuer `UAL0402`, `UEL0402`, `WEL0401`
beantwortet.

## 4. Colins Wertaenderungen (Quelle -> UTM)

Vollstaendig aus dem Diff. `18_ABLEITUNG.md` Abschnitt 2 nennt nur einen Teil davon.
Spalte "Einschaetzung" nach den Anhaltspunkten aus `18_ABLEITUNG.md` Abschnitt 0 - **keine
Entscheidung**.

### 4.1 Transportierbarkeit (die inhaltliche Klammer)

| Einheit | Aenderung | Einschaetzung |
|---|---|---|
| `UEL0401` | `TransportClass` 10 -> 4, `RULEUCC_CallTransport` | Absicht (durchgaengiges Muster) |
| `UEL0402` | neu `Transport = { TransportClass = 4 }`, `RULEUCC_CallTransport` | Absicht |
| `WEL0401` | `TransportClass` 10 -> 4, `RULEUCC_CallTransport` | Absicht |
| `WSL0404` | `TransportClass` 10 -> 4 | Absicht |
| `UAL0402` | - (war in 4DC schon Klasse 4) | |

Klasse 4 ist in LOUD etabliert (20 Blueprints in `$SRC`, u. a. Galactic Colossus
`UAL0401`). `MKT0409` traegt `Class4AttachSize = 1` (`MKT0409_unit.bp` Z. 204).

### 4.2 Balance

| Einheit | Feld | LOUD | Colin |
|---|---|---:|---:|
| `UAL0402` | Health | 60000 | 50000 |
| | BuildCostEnergy / Mass / Time | 395000 / 23000 / 6585 | **55000** / 25000 / 9000 |
| | Ausbau ChronoDampener E / M / Zeit | 125000 / 2500 / 1250 | 75000 / 1500 / 250 |
| | MaxSpeed | 2.8 | 2.9 |
| | AnimationWalkRate | 1.9 | 1.91 |
| | Waffe Z. 261 `MaxRadius` | 60 | 42 |
| | Description | `(Assault)` | `(Kleiner Collossi)` |
| `UEL0402` | Health | 36500 | 25000 |
| | BuildCostMass / Time | 14000 / 35000 | 9000 / 7000 |
| | Fussstapfen-Schaden | 2000 | 1000 |
| | neu | | `REPAIR`, `PATROLHELPER`, `Can Assist`, `RULEUCC_Capture`, `RULEUCC_Repair` |
| `WEL0401` | ShieldRegenStartTime | 2 | 1 |
| | TurnRadius / TurnRate | 4 / 28 | 0 / 30 |
| | TurretYawSpeed (7 Waffen) | 30-120 | 44-180 |
| `WSL0404` | BuildTime | 2500 | 8000 |

**Auffaellig:**

- **`UAL0402` Energie 395000 -> 55000** - Faktor 7, waehrend Masse und Bauzeit
  *steigen*. Gegenlaeufig; nach Abschnitt 0 eher Versehen (Tippfehler 395000 -> 55000?).
  **Einschaetzung, nicht belegt.** Entschieden 2026-10-14 (Paul): **bleibt so.**
- **`UEL0402` Repair/Capture ohne `BuildRate`.** Der Blueprint hat weder `BuildRate`
  noch `BuildableCategory`. Ob die Befehle dann ueberhaupt wirken, ist engineseitig und
  **ungeprueft** - falls nicht, ist die Aenderung wirkungslos (Hinweis auf Versehen).
- **`UAL0402` Description "Kleiner Collossi"** erscheint so im Spiel.

## 5. Script-Aenderungen an `SSL0403`

### 5.1 Quelle -> UTM: `VersionIsFAF` (Z. 15) - notwendig

BrewLAN: `import(BrewLANLOUDPath .. "/lua/legacy/versioncheck.lua")`. `BrewLANLOUDPath()`
liefert `nil`, wenn BrewLAN nicht aktiv ist (`LOUD\gamedata.entpackt\lua\lua\game.lua`
Z. 22-28). Die Verkettung mit `nil` haette das Script beim Laden abbrechen lassen. Colins
`VersionIsFAF = false` ist damit **Voraussetzung** fuer den Betrieb ohne BrewLAN.
Z. 14 (`BrewLANLOUDPath()`) ist danach toter Code.

### 5.2 UTM -> t4add: Nil-Schutz in `CheckBuildRestrictionsAllow` (Z. 132-141)

`restrictedData[group]` wird vor dem Zugriff auf `.categories` geprueft. Wer das eingebaut
hat, ist nicht dokumentiert (kein CHANGELOG-Eintrag). **Ungeprueft**, ob
`restrictedData[group]` in LOUD je `nil` sein kann - Kandidat waeren
LOUD-eigene Sperrgruppen, die in `LOUD\gamedata.entpackt\lua\lua\ui\lobby\restrictedUnitsData.lua`
fehlen. Harmlos, bleibt.

## 6. Was tatsaechlich gebraucht wird

Abhaengigkeiten von den Einheiten aus verfolgt (Imports, `ProjectileId`, Effekt-Templates,
Emitter, Texturen).

| genutzt | aus | braucht an Mod-Material |
|---|---|---|
| `RailGunWeapon02` | `BlackOpsweapons.lua` Z. 368 | 5 Emitter |
| `CitadelHVMWeapon` | Z. 189 | nichts (Basis-Templates; Rumpf auskommentiert Z. 190-308) |
| `CitadelPlasmaGatlingCannonWeapon` | Z. 311 | `JuggPlasmaGatlingCannonMuzzleFlash` (Basis-Emitter), `JuggPlasmaGatlingCannonShells` (1 Emitter) |
| `RailGun01Projectile` | `BlackOpsprojectiles.lua` Z. 420 | `RailGun*`-Templates - **alle 23 Emitter aus dem Basisspiel** |
| `NapalmMissile` | `BattlePackprojectiles.lua` Z. 16 | 1 Emitter (`napalm_fire_emit_2.bp`) |
| `Over_ChargeProjectile` | `4D_projectiles.lua` Z. 57 | nichts (nur Basis-Emitter) |
| Unit-Scripts direkt | `UAL0402_Script.lua` Z. 97, `WSL0404_Script.lua` Z. 49-54 | 2 Emitter |

Basis-Emitter geprueft: alle 29 vorhanden in `gamedata.entpackt\effects\effects\Emitters\`
(Basisspiel-Spiegel; `effects.scd` wird von LOUD gemountet, `14_TOOLS.md` Abschnitt 2).

**Ergebnis:**

| | vorhanden | gebraucht |
|---|---:|---:|
| Emitter | 406 | **9** |
| Bibliotheksklassen | 119 | **6** |
| `BattlePackEffectTemplates.lua` | 1 Datei | **0** - nur von `NEnergy` benutzt, das niemand importiert |
| `BlackOpsdefaultcollisionbeams.lua` | 1 Datei | **0** - nur von Beam-Waffen, die niemand nutzt |
| `effects\entities\EffectEMPAmbient01` | 2 Dateien | **0** - nur aus `BlackOpsprojectiles.lua` Z. 186 (ungenutzte Klasse) |
| eigene Texturen | 2 | **0** - beide byte-identisch mit LOUDs eigenen (6.1) |

Die 9 gebrauchten Emitter sind identisch mit ihrer Quelle bis auf Pfade:
`xcannon_cannon_muzzle_01`, `x_cannon_fire_test_01`, `jugg_rail_cannon_muzzle_07`, `_08`,
`x_cannon_charge_test_01`, `jugg_gattler_shells_01` (BlackOps), `napalm_fire_emit_2`,
`seratank_beam_emit` (BattlePack), `destruction_explosion_fire_plume_03` (4DC - **nicht**
die gleichnamige Basisspiel-Datei, die weicht ab).

### 6.1 Texturen

| t4add | identisch mit (MD5) |
|---|---|
| `textures\particles\fire_cloud_alpha_04.dds` | `LOUD\gamedata.entpackt\textures\textures\particles\fire_cloud_alpha_04.dds` -> `/textures/particles/fire_cloud_alpha_04.dds` |
| `textures\particles\rb_0036_35.dds` | `LOUD\gamedata.entpackt\textures\textures\particles\ribbon\rb_0036_35.dds` -> `/textures/particles/ribbon/rb_0036_35.dds` |

## 7. Fremdverweise

346 Pfadliterale in `.bp`/`.lua` (ohne Emitter-Ordner) gegen das VFS geprueft.

| Verweis | Fundort | Ergebnis |
|---|---|---|
| `/mods/brewlan/mods/BrewLAN_LOUD/units/ssl0403/...` (3x) | `SSL0403_unit.bp` Z. 82, 88, 620 | **loest nicht auf** - bekannt, Colins Umschreibung; BrewLAN-Original schreibt `/mods/BrewLAN_LOUD/...` |
| `/mods/t4add/projectiles/MGQAIPlasmaArtyChild01/...` | `BlackOpsprojectiles.lua` Z. 299 | loest nicht auf - **in ungenutzter Klasse**, faellt mit 6 weg |
| `/projectiles/CIFMissileTactical01/CIFMissileTactical01_mesh.bp` | `BPNapalmMissile_proj.bp` Z. 28 | **loest auf** - kein Dateiname, sondern Mesh-ID, die `LOUD\gamedata.entpackt\lua\lua\system\Blueprints.lua` Z. 170/180 aus dem Basisprojektil erzeugt. Steht so im BattlePack-Original |
| `/mods/BlackOpsUnleashed/textures/...` (47 Emitter) | `effects\Emitters\` | loest auf (Paket gemountet), aber **alle in ungenutzten Emittern** |
| alle uebrigen | | loesen auf: 74 in `t4add`, 78 Basis-`effects`, 17 LOUD-`lua`, 15 `projectiles`, 4 LOUD-`units`, 3 4DC, Rest `textures`/`props` |

Fuer die drei kaputten `SSL0403`-Pfade gibt es zwei Korrekturen:
`/mods/t4add/units/SSL0403/...` (eigene Kopie, liegt vor) oder `/mods/BrewLAN_LOUD/...`
(LOUD-Paket). Ersteres entspricht dem Extrakt-Prinzip.

## 8. Was ohne die Quellmods fehlt

Im letzten Lauf war keiner der vier Quellmods aktiv. Mit `conflicts` (Abschnitt 10) waere
das erzwungen.

| | Zustand | Quelle |
|---|---|---|
| **Einheitensymbole** | alle 9 vorhanden: 7 in LOUDs `textures`, `UEL0401` Basisspiel, `MKT0409` im Mod (wird per `DiskFindFiles` gefunden, `LOUD\gamedata.entpackt\lua\lua\BlackopsIconSearch.lua` Z. 57-62) | |
| **Ausbau-Symbol `cd`** (`UAL0402`) | vorhanden, `gamedata.entpackt\textures\textures\ui\common\game\aeon-enhancements\cd_btn_up.dds` | |
| **Namen** (`<LOC ..._name>`) | Schluessel nur in den Quellmods -> Anzeige faellt auf den Text hinter dem Tag zurueck. Unkritisch. `MKT0409`: "Acclamator " mit Leerzeichen | |
| **Beschreibungstexte** | **fehlen** fuer `UAL0402`, `UAL0402-cd`, `UEL0402`, `SSL0403`, `WEL0401`, `WSL0404`, `MKT0409` | `hook\lua\ui\help\unitdescription.lua` der Quellmods |
| **KI-Registrierung** | **fehlt** - die KI baut keine der Einheiten. Quellen hatten Eintraege fuer `uel0402`, `UAL0402`, `wsl0404`, `wel0401`, `veb2302`; UTM zusaetzlich `mkt0409` | `lua\CustomUnits\*.lua`, gelesen von `LOUD\gamedata.entpackt\lua\lua\loudutilities.lua` Z. 2670-2709 (nur aktive Mods) |

**Korrektur zu `TODO.md` / `mods\DynamicGameplay.md`:** von den "sieben Beschreibungstexten
fuer t4add" in `_Altlasten\DynamicGameplay\unitdescription.lua.vollstaendig` betreffen nur
**drei** t4add-Einheiten (`mkt0409`, `ual0402`, `ual0402-cd`). `ual0310`, `srl0319`,
`urs0304`, `sel0324` liegen nicht in t4add.

## 9. Mechanismusfragen

### 9.1 `UEL0401` - Merge statt Vollkopie

`UEL0401` ist eine **Basisspiel-Einheit** - die ID existiert immer. Damit greift
`Merge = true` (`18_ABLEITUNG.md` Abschnitt 3.5). Colins Aenderung sind zwei Felder:

```lua
UnitBlueprint {
    Merge = true,
    BlueprintId = "uel0401",
    General = { CommandCaps = { RULEUCC_CallTransport = true } },
    Transport = { TransportClass = 4 },
}
```

`CommandCaps` ist eine Schluesseltabelle, keine Liste - die Merge-Falle fuer Listen greift
nicht. Vorteil: LOUD-Aenderungen am Fatboy kommen weiter durch; 10 Asset-Dateien entfallen.
**Wo die Datei liegen muss** (`units\` mit `Merge` oder `hook\units\`), ist in
`18_ABLEITUNG.md` 3.5 nur am LOUD-Beispiel belegt (`hook\units\`) - beim Umsetzen pruefen.

Fuer die uebrigen acht gilt dasselbe wie bei den anderen Extrakten: bei `conflicts` gegen
das Quellpaket existiert die ID nicht, also Vollkopie.

### 9.2 `VEB2302` - warum hier?

Byte-identisch mit `LOUD Unit Additions`, steht nicht auf der Sollliste. `SquareShields`
schliesst `LOUD Unit Additions` per `conflicts` aus - ohne Kopie gaebe es den Flayer II dann
nicht. **Einschaetzung:** die Kopie rettet die Einheit fuer Spiele mit `SquareShields`. Nicht
belegt, dass Colin das so gemeint hat.

### 9.3 `conflicts`

| Paket | uid | wegen |
|---|---|---|
| BrewLAN for LOUD | `25D57D85-7D84-27HT-A501-BR3WL4N000079` | `SSL0403`, `SSA0001` |
| 4th Dimension Units for LOUD | `454af309-5afb-458b-bf5b-a00000000007` | `UAL0402`, `UEL0402` |
| Wyvern Battle Pack for LOUD | `9a9C61C0-1787-10DF-A0AD-BATTLEPACK002` | `WEL0401`, `WSL0404` |
| LOUD Unit Additions | `fffffffe-6e98-4864-9599-4133236eea7a` | `VEB2302` |

BlackOps **nicht** noetig: keine gemeinsame ID, die Bibliotheken liegen unter
`/mods/t4add/`. BrewLAN und LOUD Unit Additions sind ohnehin schon durch
`DynamicGameplay` bzw. `SquareShields` ausgeschlossen.

## 10. Entscheidungen (Paul, 2026-10-14)

Alle acht nach Vorschlag:

| # | Frage | Entscheidung |
|---|---|---|
| 1 | Bibliotheken und Emitter | auf das Gebrauchte gekuerzt |
| 2 | `UEL0401` | Merge statt Vollkopie |
| 3 | `conflicts` | gegen BrewLAN, 4DC, BattlePack, LOUD Unit Additions |
| 4 | `SSL0403`-Pfade | auf die eigene Kopie |
| 5 | Colins Werte (Abschnitt 4) | **alle unveraendert uebernommen** |
| 6 | Beschreibungstexte | sachliche Texte der Quellmods; `mkt0409` neu und sachlich |
| 7 | KI-Registrierung | aufgenommen |
| 8 | Namen | zunaechst nur Anzeigename korrigiert; **Nachtrag:** Ordner `T4UnitAdditions`, Name "T4 Unit Additions" (Paul, 2026-10-14) |

## 11. Umsetzung (2026-10-14)

Ergebnis: **87 Dateien, 46,1 MB** (vorher 499, 51,8 MB). 414 Dateien nach
`doc.claude\_Altlasten\T4UnitAdditions\` verschoben, nichts geloescht.

### 11.1 Bestand jetzt

```
LOUD\usermods\T4UnitAdditions\
  mod_info.lua                         neu geschrieben
  hook\lua\ui\help\unitdescription.lua neu, 8 Texte
  lua\CustomUnits\T4UnitAdditions.lua            neu, KI-Registrierung
  lua\README.md                        neu, Herkunft der Auszuege
  lua\                                 5 Bibliotheken, gekuerzt auf 6 Klassen
  effects\Emitters\                    9 Emitter
  projectiles\                         3 Projektile, unveraendert
  textures\ui\common\icons\units\      MKT0409_icon.dds
  units\                               9 Einheiten; UEL0401 nur noch Merge-Datei
```

### 11.2 Aenderungen im Einzelnen

| Datei | Aenderung |
|---|---|
| `mod_info.lua` | GUID, Name (jetzt "T4 Unit Additions"), ASCII-`description`, Kopfkommentar, `icon` (Bausymbol der Acclamator im Mod), `conflicts` (9.3) |
| `lua\BlackOps*.lua`, `BattlePackprojectiles.lua`, `4D_projectiles.lua` | auf die sechs Klassen aus Abschnitt 6 gekuerzt; Klassenrumpfe unveraendert. `CitadelHVMWeapon` ohne auskommentierten Block. Details `LOUD\usermods\T4UnitAdditions\lua\README.md` |
| `effects\Emitters\seratank_beam_emit.bp` Z. 3 | Textur -> `/textures/particles/ribbon/rb_0036_35.dds` (LOUD, byte-identisch) |
| `effects\Emitters\destruction_explosion_fire_plume_03_emit.bp` Z. 32 | Textur -> `/textures/particles/fire_cloud_alpha_04.dds` (LOUD, byte-identisch); Z. 8 `(c)` statt Copyright-Zeichen (ASCII) |
| `units\SSL0403\SSL0403_unit.bp` Z. 82, 88, 620 | `/mods/t4unitadditions/units/SSL0403/SSL0403_ADeath01.sca`, `_AWalk01.sca`, `_AAttack01.sca` |
| `units\SSL0403\SSL0403_Script.lua` Z. 14-15 | toten `BrewLANLOUDPath`-Aufruf und auskommentierten Import entfernt; `VersionIsFAF = false` bleibt (5.1) |
| `units\UEL0401\UEL0401_unit.bp` | Merge-Datei mit zwei Feldern (9.1) statt 11 Dateien Vollkopie. **Spaeter am selben Tag ersetzt** durch die allgemeine Regel 11.6 und nach `_Altlasten` verschoben - der Fatboy ist im Mod wieder reines LOUD |
| ~~`hook\lua\terranunits.lua`~~ | Rueckfall gegen unsichtbare Fatboys (LOUD-Fehler B-04). Am 2026-10-14 hier angelegt, nach Bestaetigung im Spiel **in den neuen Mod `BasegameBugfixes` verschoben** - ist kein Teil der T4-Erweiterung. Fuer sichtbare Fatboys bei schnellem Bau muss `BasegameBugfixes` aktiv sein |
| `units\MKT0409\MKT0409_unit.bp`, `AI` | **neu `BeaconName = 'UEB5102'`** (2026-10-14). Im Spiel entstand kein Faehrpunkt (Paul): `RULEUCC_Ferry` war gesetzt, aber die Bake fehlte. Alle UEF-Transporter in LOUD tragen diesen Wert, z. B. `LOUD\gamedata.entpackt\units\units\UEA0104\UEA0104_unit.bp` Z. 3; Bake vorhanden unter `units\UEB5102\`. Fehlte schon in UTM |
| `units\UEL0402\UEL0402_unit.bp`, `Economy` | **neu `BuildRate = 60`, `MaxBuildDistance = 15`** (Paul, 2026-10-14). Colins Repair/Capture wirkte ohne Baurate nicht (Abschnitt 12). 60 = UEF-SCU `LOUD\gamedata.entpackt\units\units\UEL0301\UEL0301_unit.bp` Z. 115; Reichweite groesser als beim SCU (8), weil der Rampage gross ist. **Erste eigene Wertaenderung in diesem Mod** |
| `hook\lua\ui\help\unitdescription.lua` | Texte fuer `ual0402`, `ual0402-cd`, `uel0402`, `ssl0403`, `veb2302`, `wel0401`, `wsl0404` wortgleich aus den Quellpaketen; `mkt0409` **neu von uns** (sachlich, aus dem Blueprint) |
| `lua\CustomUnits\T4UnitAdditions.lua` | Eintraege wortgleich aus `4D_Custom Units.lua`, `Wyvern_Units.lua`, `LOUD Unit Additions.lua`. `SSL0403` hatte in keiner Quelle einen Eintrag. **`mkt0409` bewusst nicht** (Paul, 2026-10-14): die KI wuesste mit einem Traeger nichts anzufangen. UTM hatte ihn als `T4AirExperimental2` in `BO_AirUnits.lua` |

### 11.3 Merge `UEL0401` - Ablageort

`units\UEL0401\` genuegt. Begruendung am Code:
`LOUD\gamedata.entpackt\lua\lua\system\Blueprints.lua`, `LoadBlueprints()`: erst alle
Standardressourcen (Z. 1219-1239), danach jede `.bp` irgendwo unter `m.location` jedes
aktiven Mods (Z. 1289-1311). Beim Laden der Merge-Datei existiert `uel0401` also schon.
Die ID ergibt sich bei Units aus dem Dateinamen bzw. dem gesetzten `BlueprintId`
(`SetShortId`, Z. 142-143). LOUDs eigene Merge-Beispiele liegen unter `hook\units\` - das
waere ebenfalls von der Suche erfasst. **Im Spiel ungeprueft.**

### 11.4 Nebenbefund Emitter-IDs

`destruction_explosion_fire_plume_03_emit.bp` setzt
`BlueprintId = 'destruction_explosion_fire_plume_03'`, denselben Namen wie der Emitter des
Basisspiels. **Kein Konflikt:** `EmitterBlueprint()`
ueberschreibt die ID immer mit dem kleingeschriebenen Dateipfad (`Blueprints.lua`
Z. 114-117, 408-410).

### 11.5 Pruefung nach der Umsetzung

- 168 Pfadliterale in `.bp`/`.lua` (diesmal einschliesslich Emitter) gegen das VFS: alle
  loesen auf; einzige Ausnahme ist die Mesh-ID `CIFMissileTactical01_mesh` (Abschnitt 7,
  loest ueber den Mechanismus auf).
- Kein Verweis mehr auf entfernte Dateien.
- Alle `.bp`/`.lua` reines ASCII.
- Die zwei geaenderten Emitter weichen von ihrer Quelle nur in den genannten Zeilen ab.

### 11.6 Regel: alle T4-Landeinheiten transportierbar (2026-10-14, Paul)

`hook\lua\system\Blueprints.lua`, Hook auf `ModBlueprints`, laeuft **vor** LOUDs eigener
Nachbearbeitung (damit LOUDs Faehigkeitstext "Transport hook size" Z. 945-956 die neuen
Werte sieht).

| Bedingung | Kategorien `EXPERIMENTAL` + `LAND` + `MOBILE` + `SELECTABLE` |
|---|---|
| `TransportClass` fehlt oder 10 | -> 4 |
| `TransportClass` 4 (danach) | `RULEUCC_CallTransport = true`, `CanFireFromTransport = false` |
| `TransportClass` 5 | **unveraendert**, kein Transportruf (Entscheidung Paul: Iyadesu bleibt 5). LOUD nennt Klasse 5 "Drone" (`Blueprints.lua` Z. 946) |

Gilt fuer alle geladenen Einheiten, also LOUD-Basis und aktive Mods - auch fuer kuenftig
hinzukommende T4-Landeinheiten. Grenze: ein anderer Mod, dessen `ModBlueprints`-Hook
**innerhalb** unseres Aufrufs laeuft (frueher angewandt), kann die Werte danach wieder
ueberschreiben. **Geprueft 2026-10-14:** keiner der 25 `hook\lua\system\Blueprints.lua` in
`usermods` und `loud_misc` setzt `TransportClass` oder den Transportruf. Nur
`loud_misc\mods\BrewLAN_Plenae\StrategicIconsOverhaul` liest die Klasse (Z. 342, Wahl des
Strategiesymbols fuer `TRANSPORTATION`-Einheiten mit Klasse > 3) - bei aktivem Mod
koennten Einheiten mit `TRANSPORTATION` ein anderes Symbol bekommen. Nicht geprueft:
Hooks in `blackops` und `brewlan`. Ins Log schreibt der
Hook `T4UnitAdditions: <n> T4-Landeinheiten transportierbar: <IDs>`.

**Belegt:**
- Fehlende `TransportClass` = Klasse 1 (`Blueprints.lua` Z. 945).
- Waffen im Transport sind ohne `CanFireFromTransport = true` abgeschaltet
  (`sim\weapon.lua` Z. 820-827); keine T4-Landeinheit in `$SRC` setzt es. Die Regel setzt
  `false` trotzdem ausdruecklich.
- `SELECTABLE` schliesst den Ythotha-Geist `XSL0402` aus (`UNSELECTABLE`, entsteht in
  `XSL0401_script.lua` Z. 131).

**Erwartet in LOUD-Basis:** Fatboy, Scathis, Monkeylord, Megalith, Ythotha (10 -> 4),
Galactic Colossus (4, bekommt Transportruf). Dazu die Mod-Einheiten Overlord, Rampage,
Littleman, Yath-Yen. **Ungeprueft:** ob LOUDs KI nun versucht, T4 zu verladen.

Damit ist die Merge-Datei des Fatboys ueberfluessig (nach `_Altlasten` verschoben); Colins
gleichlautende Felder in den Vollkopien bleiben unschaedlich stehen.

## 12. Tests

| Datum | Was | Ergebnis |
|---|---|---|
| 2026-10-14 | Pfadaufloesung, ASCII, Restverweise | siehe 11.5 |
| 2026-10-14 | T4-Transportregel (11.6) (Paul, im Spiel) | **funktioniert.** Beobachtung: die T4 behindern sich beim Verladen gegenseitig. Vermutlich Wegfindung grosser Einheiten an einem Traeger mit nur einem Andockpunkt - nicht untersucht |
| 2026-10-14 | Iyadesu `SSL0403`: Lauf-, Angriffs-, Todesanimation (Paul, im Spiel) | **laufen** nach der Pfadkorrektur vom 2026-10-14 (Paul). Ob sie vorher fehlten, wurde nicht beobachtet - also keine A/B-Gegenprobe. Die `.sca`-Regel (`07_KONVENTIONEN.md` Abschnitt 4) bleibt durch die PlayTest-Laeufe vom 2026-08-15 belegt |
| 2026-10-14 | Acclamator transportiert (Faehre) (Paul, im Spiel) | **funktioniert** |
| 2026-10-14 | Fatboy nach Bau einer Acclamator unsichtbar (Paul, im Spiel) | **nicht durch diesen Mod.** LOUD-Fehler bei Bauzeit unter ~6 Ticks, per `T4DEBUG`-Diagnose belegt; die Acclamator war Zufall der Reihenfolge. Fix bestaetigt, liegt jetzt in `BasegameBugfixes`: `mods\BasegameBugfixes.md` B-04 |
| 2026-10-14 | Rampage reparieren mit `BuildRate = 60`, `MaxBuildDistance = 15` (Paul, im Spiel) | **funktioniert** - "guter Repairbot". Einnehmen und Patrouillenhilfe nicht berichtet |
| 2026-10-14 | Acclamator als Faehre (Paul, im Spiel) | **kein Faehrpunkt** - `BeaconName` fehlte, ergaenzt (11.2). Erneut pruefen |
| 2026-10-14 | Rampage `UEL0402` reparieren (Paul, im Spiel) | **repariert nichts, kostet aber Energie.** Bestaetigt 4.2: Repair ohne `BuildRate` ist wirkungslos. Einnehmen nicht berichtet |
| 2026-10-14 | Mod-Manager (Screenshot Paul) | Name, Bild (`MKT0409_icon.dds` aus dem Mod), Beschreibung und alle vier `conflicts` werden angezeigt. Konfliktmeldung beim Aktivieren eines Quellpakets noch nicht gesehen. Name damals noch "Experimentierfreudige Menschen" |
| | **Testlauf im Spiel** | **ausstehend** |

**Testlauf - was zu pruefen ist:**

1. Mod-Manager: Name und Bild; beim Aktivieren von 4DC/BattlePack/BrewLAN/LOUD Unit
   Additions erscheint die Konfliktmeldung.
2. Log: `Mounting mod 't4unitadditions'`, `Hooked /lua/ui/help/unitdescription.lua with /mods/t4unitadditions/...`,
   kein Fehler mit `t4unitadditions` im Pfad.
3. Jede der neun Einheiten bauen; Beschreibungstext im Baumenue sichtbar.
4. `UEL0401` Fatboy: in die Acclamator laden (Merge wirkt), sonst unveraendert.
5. Acclamator: Railgun, Gatling, Flak feuern mit Effekten.
6. Littleman (Napalm), Rampage (EMP-Waffen), Yath-Yen (Strahl zwischen den Kugeln),
   Overlord (Todesexplosion mit Feuerfahnen).
7. ~~Iyadesu: Lauf-, Angriffs- und Todesanimation (bisher kaputt).~~ Erledigt 2026-10-14, laufen.
8. KI: baut sie eine der Einheiten? Eine Partie mit UEF-KI reicht fuer Rampage,
   Littleman, Flayer II. Die Acclamator darf sie **nicht** bauen.
9. Acclamator als Faehre (`RULEUCC_Ferry`, `MKT0409_unit.bp` Z. 130).

## 13. Offene Punkte

- [ ] Testlauf, Abschnitt 12
- [ ] `UEL0402`: wirken Repair/Capture ohne `BuildRate`? (4.2) - im Testlauf mitpruefen
- [ ] `SSL0403`: kann `restrictedData[group]` in LOUD `nil` sein? (5.2)
- [ ] `SSA0001` hat keinen Namen und keine Beschreibung - auch in BrewLAN nicht. Unkritisch,
      die Drohne wird nicht gebaut, sondern von der Iyadesu erzeugt.
