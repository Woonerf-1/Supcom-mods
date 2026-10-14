# Mod: AirForceRebalance

| | |
|---|---|
| **Ordner** | `LOUD\usermods\AirForceRebalance\` |
| **VFS-Pfad** | `/mods/airforcerebalance/` |
| **Anzeigename** | Air Force Rebalance |
| **uid** | `58FA781C-DB8D-4060-BABF-26248D292D6C` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Autor** | Colin (Werte und Ideen), Extrakt und Korrekturen 2026-10-14 |
| **Icon** | `/textures/ui/common/icons/units/SEA0313_icon.dds` - Bausymbol des Tomcat (UEF-Penetration-Fighter), liegt in LOUDs `textures.scd` |
| **Status** | **angelegt 2026-10-14, im Spiel ungeprueft** |
| **Umfang** | 26 Einheiten, 149 Dateien, 25 MB |

Uebergeordnet: [18_ABLEITUNG.md](../18_ABLEITUNG.md). Alle Pfade relativ zu `$FA`.

---

## 1. Zweck

Colins Sammelmod `UEF_trans_men` enthaelt ein **zusammenhaengendes Luftwaffen-Rebalancing**:
je Flugzeugtyp dasselbe Muster ueber alle vier Fraktionen. Dieser Mod loest es heraus -
dazu die **reine Flugabwehr** aus demselben Sammelmod und die Uyanah (Pauls Wunsch).

Leitlinie wie bei den anderen Extrakten (`18_ABLEITUNG.md` Abschnitt 0): **Colins Werte
werden uebernommen** (Entscheidung Paul, 2026-10-14). Korrigiert wird nur, was
nachweislich nicht funktioniert (Abschnitt 6).

## 2. Die 26 Einheiten

### 2.1 Luftueberlegenheitsjaeger (T3) - reine Jagdflugzeuge

| ID | Name | Fraktion | Quelle | Mechanismus |
|---|---|---|---|---|
| UAA0303 | Corona | Aeon | Basisspiel | Merge |
| URA0303 | Gemini | Cybran | Basisspiel | Merge |
| XSA0303 | Iazyne | Seraphim | Basisspiel | Merge |
| UEA0303 | Wasp | UEF | Basisspiel | Merge |

### 2.2 Torpedobomber - gegen Schiffe und U-Boote

| ID | Name | Fraktion | Stufe | Quelle | Mechanismus |
|---|---|---|---|---|---|
| UAA0204 | Skimmer | Aeon | T2 | Basisspiel | Merge |
| URA0204 | Cormorant | Cybran | T2 | Basisspiel | Merge |
| XSA0204 | Uosioz | Seraphim | T2 | Basisspiel | Merge |
| UEA0204 | Stork | UEF | T2 | Basisspiel | Merge |
| XAA0306 | Solace | Aeon | T3 | Basisspiel | **Kopie** (Script geaendert, Waffe umbenannt) |
| SSA0314 | Sinnaino ("Penetrator Bomber") | Seraphim | T3 | BrewLAN | Kopie |

### 2.3 Gunships (T3) - Kampfhubschrauber gegen Bodenziele

| ID | Name | Fraktion | Quelle | Mechanismus |
|---|---|---|---|---|
| XAA0305 | Restorer (Flak-Gunship) | Aeon | Basisspiel | Merge |
| XRA0305 | Wailer | Cybran | Basisspiel | Merge |
| BSA0310 | Vulthatha-Ioz (Raketen-Gunship) | Seraphim | BlackOps | Kopie |
| UEA0305 | Broadsword | UEF | Basisspiel | Merge |

### 2.4 Penetration Fighter (T3) - schwere Jaeger, die Luftabwehr durchbrechen

| ID | Name | Fraktion | Quelle | Mechanismus |
|---|---|---|---|---|
| SAA0313 | Helios | Aeon | BrewLAN | Kopie |
| SRA0313 | Twilight Patron | Cybran | BrewLAN | Kopie |
| SSA0313 | Ialosaare | Seraphim | BrewLAN | Kopie |
| SEA0313 | **Tomcat** (Mod-Bild) | UEF | BrewLAN | Kopie |

### 2.5 Sonderflugzeuge

| ID | Name | Fraktion | Bedeutung | Quelle | Mechanismus |
|---|---|---|---|---|---|
| SRA0201 | Blade Raven | Cybran | T2-Aufklaerer | BrewLAN | Kopie |
| SEA0310 | Wild Weasel | UEF | T3-Koederflugzeug, Radarstoerung | BrewLAN | Kopie (nur bp + Script; Modell von `UEA0302`) |
| SAA0306 | Bayblade (BrewLAN: "Solaris") | Aeon | experimenteller Lufttransporter | BrewLAN | Kopie |
| SRA4212 | Orlok | Cybran | T2 "Ambush Fighter", Jaeger mit Tarnung und Radarstealth | **nur in `UEF_trans_men`** | Kopie, Bausymbol aus Colins `textures\` |

### 2.6 Flugabwehr - Kategorie `ANTIAIR`, nur Luftwaffen

| ID | Name | Fraktion | Bedeutung | Quelle | Mechanismus |
|---|---|---|---|---|---|
| SEL0324 | NG3 Longbow | UEF | T3 mobile Flugabwehr | BrewLAN | Kopie, Script repariert |
| SRL0320 | Slink | Cybran | T3 amphibische Flugabwehr, tarnfaehig | BrewLAN | Kopie |
| UAL0310 | Vindicator | Aeon | T3 mobile Abwehr: Flak + Raketenabwehr | 4DC | Kopie |
| BSLK004 | Uyanah | Seraphim | T3 "Lightning AA Tank", **auch Bodenwaffe** | BlackOps | Kopie (auf Pauls Wunsch, siehe 9) |

## 3. Bestand

```
LOUD\usermods\AirForceRebalance\
  mod_info.lua
  units\<ID>\<ID>_unit.bp              11 Merge-Dateien (nur geaenderte Felder)
  units\<ID>\...                       15 Vollkopien mit Assets
  lua\4D_weapons.lua                   Auszug 4DC: ArrowMissileWeapon, LaserPhalanxWeapon
  lua\4D_projectiles.lua               Auszug 4DC: ArrowMissileProjectile
  lua\CustomUnits\AirForceRebalance.lua  KI-Registrierung
  lua\README.md
  projectiles\ArrowMissile\            Vindicator-Rakete (= 4DC, byte-identisch)
  effects\Emitters\seraphim_electricity_emit.bp   Uyanah (= BlackOps, byte-identisch)
  hook\lua\ui\help\unitdescription.lua 15 Beschreibungstexte
  textures\ui\common\icons\units\SRA4212_icon.dds   Bausymbol Orlok (aus UEF_trans_men)
```

`units\SEL0324\SEL0324_script.md` dokumentiert die Reparatur des Longbow.

## 4. Mechanik: Merge oder Kopie

**Merge** (`Merge = true`, `03_BLUEPRINTS.md`, `18_ABLEITUNG.md` 3.5) fuer die 11
Basisspiel-Einheiten, deren Script Colin nicht angefasst hat. Die Merge-Datei enthaelt nur
die geaenderten Felder; der Rest bleibt LOUD und zieht bei LOUD-Updates mit.

- Erzeugt mit einem Werkzeug, das LOUD-Original und Colins Fassung als Feldpfade liest
  (`Weapon[2].Damage` usw.) und genau die Unterschiede ausgibt. Kontrolle: die Zahl der
  erzeugten Felder entspricht je Einheit der Zahl geaenderter Zeilen im Diff.
- **Listen** (`Weapon`) werden positionsweise gemerged. Steht eine Aenderung an Waffe 2,
  enthaelt die Merge-Datei fuer Waffe 1 einen leeren Platzhalter `{}`.
- Ablage unter `units\`: LOUD laedt alle `.bp` aktiver Mods nach den Standardressourcen
  (`LOUD\gamedata.entpackt\lua\lua\system\Blueprints.lua` Z. 1219/1289).
- Kein anderer Mod in `gamedata.entpackt` oder `usermods` ueberschreibt diese 11 IDs
  (geprueft 2026-10-14) - der Merge wird nicht verdeckt.

**Kopie** fuer alles aus BrewLAN, BlackOps, 4DC, fuer Colins Einzelanfertigung Orlok und
fuer die Solace (Script geaendert - ein Merge erreicht das Script nicht, es kommt aus dem
Ordner des Originals). Die Pakete sind per `conflicts` ausgeschlossen, die IDs existieren
also nur durch diesen Mod.

## 5. Colins Aenderungen (Quelle -> Colin)

Uebernommen wie von Colin (Entscheidung Paul). **Auffaelliges** ist markiert, bleibt aber.

### 5.1 Jaeger (Merge)

| ID | Aenderung |
|---|---|
| UAA0303 | `KTurn` 1.4 -> 1.6, `KTurnDamping` 1.35 -> 1.4, `BuildTime` 7579 -> 5000 |
| URA0303 | `KTurn` 1.42 -> 1.6, `KTurnDamping` 1.35 -> 1.4, `BuildTime` 7579 -> 5000 |
| XSA0303 | `KTurn` 1.55 -> 1.6, `KTurnDamping` 1.35 -> 1.4, `BuildTime` 7579 -> 5000 |
| UEA0303 | `KTurn` 1.43 -> 1.6, `KTurnDamping` 1.35 -> 1.4, `BuildTime` 7579 -> 5000 |

Muster: alle vier gleich wendig, schneller gebaut.

### 5.2 Torpedobomber

| ID | Aenderung |
|---|---|
| UAA0204 | `MaxHealth` 1350 -> 1550, Energie 12000 -> 24000, Masse 240 -> 500, `BuildTime` 300 -> 2500, Torpedo 300 -> 372 |
| URA0204 | `MaxHealth` 1350 -> 1550, Energie 14000 -> 28000, Masse 265 -> 500, `BuildTime` 200 -> 2500, Torpedo 300 -> 372 |
| XSA0204 | `MaxHealth` 1350 -> 1550, Energie 14000 -> 28000, Masse 265 -> 500, `BuildTime` 200 -> 2500, Torpedo **480 -> 372** (einzige Senkung) |
| UEA0204 | `MaxHealth` 1475 -> 1675, Energie 14000 -> 28000, Masse 265 -> 500, `BuildTime` 200 -> 2500, Torpedo 300 -> 372 |
| XAA0306 Solace | HP 3400 -> 3700, Masse 1600 -> 1500, `BuildTime` 1100 -> 6000, Torpedo **400 -> 1500**, Waffe `Torpedo` -> `ClusterTorpedo` (bp und Script) |
| SSA0314 Sinnaino | `BuildTime` 3000 -> 12000, Bombe 3200 -> 3300, Radius 2.8 -> 3, `FiringTolerance` 3 -> 30, Waffe `Torpedo` -> `ClusterTorpedo` |

Muster T2: alle vier auf gleiche Werte (372 Schaden, 500 Masse) - Angleichung zwischen
den Fraktionen.

### 5.3 Gunships

| ID | Aenderung |
|---|---|
| XAA0305 Restorer | Masse 2362 -> 1562, `BuildTime` 1625 -> 5000, Waffen 93/120/120 -> 195/200/200 |
| XRA0305 Wailer | HP 4450 -> 4400, Masse 2625 -> 1525, `BuildTime` 1475 -> 5000, Waffen 100/40 -> 200/80 |
| UEA0305 Broadsword | HP 5000 -> 5300, `RegenRate` 6 -> 8, Masse 2500 -> 1500, `BuildTime` 1475 -> 5000, Waffen 65/24 -> 105/30 |
| BSA0310 Vulthatha-Ioz | Masse 2625 -> 1600, `BuildTime` 1475 -> 5000, Waffen 120/16/16 -> 200/40/40 |

Muster: billiger an Masse, Bauzeit etwa x3, deutlich mehr Schaden.

### 5.4 Penetration Fighter

| ID | Aenderung |
|---|---|
| SAA0313 Helios | `CombatTurnSpeed` 1.25 -> 1.3, `KTurn` 1.3 -> 1.6, `KTurnDamping` 1.3 -> 1.4, neu `TurnSpeed` 1.3, HP 3855 -> 3800, Masse 1250 -> 1150, `BuildTime` 6750 -> 13000, Unterhalt 35 -> 75, Sicht 40 -> 50, Strategiesymbol `antiair` -> `antimissile` |
| SRA0313 Twilight Patron | `KTurn` 1.3 -> 1.6, `KTurnDamping` 1.3 -> 1.4, HP 3750 -> 3800, `BuildTime` 6750 -> 13000, Sicht 40 -> 56, Reichweite 44 -> 47 (4 Waffen), `FiringTolerance` 0 -> 1.1, Strategiesymbol -> `antimissile` |
| SSA0313 Ialosaare | `CombatTurnSpeed` 1.25 -> 1.4, `KTurn` 1.3 -> 1.8, `KTurnDamping` 1.3 -> 1.7, Tempo 28/14 -> 32/16, neu `TurnSpeed` 1.3, HP 3750 -> 3800, Masse 1390 -> 1050, `BuildTime` 6750 -> 13000, Strategiesymbol -> `antimissile`. `TightTurnMultiplier` 1.02 -> 10000 (geklaert, siehe 10) |
| SEA0313 Tomcat | `KTurn` 1.3 -> 1.6, Tempo 28/14 -> 25/13, neu `TurnSpeed` 0.8, HP 4125 -> 4200, `RegenRate` 10 -> 7, Masse 1390 -> 1400, `BuildTime` 6750 -> 13000, Unterhalt 35 -> 75, Sicht 40 -> 35, `FuelRechargeRate` 5 -> 10, `FiringTolerance` 1 -> 1.2 (2x) und 10 -> 5, Reichweite 60 -> 54, Feuerrate 0.5 -> 0.8, Strategiesymbol -> `antimissile` |

Muster: Bauzeit fast verdoppelt, Unterhalt verdoppelt (Helios, Tomcat), wendiger.

### 5.5 Sonderflugzeuge

| ID | Aenderung |
|---|---|
| SRA0201 Blade Raven | neu `Intel.Cloak = true` (Tarnung) |
| SEA0310 Wild Weasel | **unveraendert** gegenueber BrewLAN |
| SAA0306 Bayblade | Name "Solaris" -> "Bayblade", HP 5400 -> 7500, Energie 102000 -> 80000, Masse 8250 -> 5250, Absturzschaden 2650 -> 200. **Fester Schild entfernt, stattdessen Ausbau "Shield Dome"** (Schild 7500, 125 Energie/s Unterhalt, Kosten 2160 E / 1000 M). Grundunterhalt 252 E/s entfaellt |
| SRA4212 Orlok | ohne Quelle in LOUD; Tarnung, Partikelkanone (`CDFParticleCannonWeapon`) |

### 5.6 Flugabwehr

| ID | Aenderung |
|---|---|
| ~~UEL0205 Sky Boxer~~ | Colin: neu `Transport.CanFireFromTransport = true` - feuert aus dem Transport. **Zurueckgenommen** (Paul, 2026-10-14): ein reiner UEF-Vorteil; LOUD vergibt die Faehigkeit sonst symmetrisch (T1-Bots aller Fraktionen). Merge-Datei in `_Altlasten\AirForceRebalance\units\UEL0205\`. **Entschieden (Paul): keine T2-Flak feuert aus dem Transport** - der Sky Boxer bleibt reines LOUD |
| SRL0320 Slink | Energie 12500 -> 3000, Masse 1200 -> 450, `BuildTime` 625 -> 2400, Beschleunigung 0.9 -> 2.6, Tempo 2.7 -> 3.3, Schaden 120 -> 70, Reichweite 50 -> 44 |
| UAL0310 Vindicator | HP 2500 -> 1800, Energie 13500 -> 7500, Masse 900 -> 450, `BuildTime` 450 -> 2400, Tempo 2.6 -> 3.3, SAM 75 -> 50 / Reichweite 52 -> 44 / Feuerrate 1.0 -> 1.5 (2x), Arrow-SAM Feuerrate 0.2 -> 0.07. **Baurate entfernt** - siehe 6.4 |
| SEL0324 NG3 Longbow | HP 1800 -> 2000, Energie 30000 -> 3000, Masse 2200 -> 450, `BuildTime` 1100 -> 2400, Radar 196 -> **30**, Omni 52 -> **10**, Sicht 40 -> 20, Schaden 200 -> 115, Reichweite 48 -> 44, Grundunterhalt 400 E/s entfaellt. **Neu: Ausbau "Omni Sensor"** (Radar 150, Omni 70, 750 E/s; Kosten 3250 E / 300 M). Script umgeschrieben - siehe 6.1 |
| BSLK004 Uyanah | HP 2250 -> 1850, `RegenRate` 1 -> 2, Energie 9600 -> 3000, Masse 960 -> 450, `BuildTime` 3840 -> 2400, Tempo 2.5 -> 3.3, Blitz 60 -> 40 / Reichweite 40 -> 44, Bodenwaffe 100 -> **20**, Energiebedarf beider Waffen entfernt |

Muster Flugabwehr: Slink, Vindicator und Uyanah alle auf **450 Masse, 2400 Bauzeit,
Tempo 3.3, Reichweite 44** angeglichen; der Longbow auf 450 / 2400 / Reichweite 44
(Tempo unveraendert).

## 6. Korrekturen durch uns

Nur, was nachweislich nicht funktioniert oder auf Dateien ausserhalb des Mods zeigt.

### 6.1 NG3 Longbow: Script repariert (Entscheidung Paul)

Colins Fassung haette Lua-Fehler ausgeloest. Einzelheiten in
`LOUD\usermods\AirForceRebalance\units\SEL0324\SEL0324_script.md`. Kurz:

- `SetMaintenanceConsumptionPerSecondEnergy` existiert nicht (weder LOUD noch
  `Repos\FAF\engine\Sim\Unit.lua`) - aufgerufen bei jedem Abschalten des Radars.
- `Buff` nicht importiert, und es war der Intel-Buff des ACU.
- Radar-Animation nie gestartet, Transportverhalten entfallen.

Colins Idee (billige Flak, Radar per Ausbau) bleibt.

### 6.2 Bayblade: Ausbau-Name

`RemoveEnhancements = {"ShieldDome", ...}` - der Ausbau heisst `ShieldDomeAdd`. Korrigiert
nach dem Muster, das Colin beim Longbow richtig hat. Ausserdem zwei tote Script-Zweige
fuer einen nicht vorhandenen Ausbau "StealthUpgrade" entfernt (verwiesen u. a. auf einen
Emitter `/effects/emitters/stealth_effect.bp`).

### 6.3 Uyanah: Importe und Todesanimation

- Colin hatte die Waffenklassen aus `seraphimweapons.lua` und den Dummy aus
  `sim\weapon.lua` (nackte Basisklasse `Weapon`, kann selbst nicht feuern) geholt,
  Kommentar "Option A: standard LOUD location". BlackOps nutzt `kirvesweapons.lua` - die
  Datei liegt in LOUD vor (`LOUD\gamedata.entpackt\lua\lua\kirvesweapons.lua` Z. 24, 32).
  **Zurueck auf BlackOps.**
- Colin hatte `AnimationDeath` gestrichen, vermutlich weil der BlackOps-Pfad bei ihm nicht
  aufloeste. Die Datei liegt vor - mit eigenem Pfad wiederhergestellt.

### 6.4 Baurate fuer Ausbauten

Bayblade, Longbow und Vindicator haben Ausbauten, aber **keine `BuildRate`** - beim
Vindicator hat Colin sie entfernt (4DC: 15), die beiden anderen hatten nie eine. Ohne
Baurate kein Baufortschritt (im Spiel belegt am Rampage-Reparieren, `mods\T4UnitAdditions.md`
Abschnitt 12). **Gesetzt: `BuildRate = 15`** fuer alle drei (Wert des 4DC-Originals).
Ausbauzeiten dann: Shield Dome 2 s, Omni Sensor 4 s. **Unser Wert, von Paul bestaetigt (2026-10-14)**; im Spiel noch nicht gesehen.

### 6.5 Pfade

Alle Verweise auf `/mods/UEF_trans_men/`, `/mods/4DC/`, `/mods/BrewLAN_LOUD/`,
`/mods/BlackOpsUnleashed/` umgeschrieben auf `/mods/airforcerebalance/`
(Vindicator 7 Animationen + Projektil + Importe, Bayblade-Animation, Uyanah 2 Animationen
+ Emitter). Ergebnis: 121 Pfadliterale, alle loesen auf.

## 7. Abhaengigkeiten

| | |
|---|---|
| `conflicts` | BrewLAN for LOUD (`25D57D85-...`), BlackOps Unleashed (`9e8ea941-...`), 4th Dimension Units (`454af309-...`) |
| `requires` | keine |
| Bibliotheken | eigene Auszuege (`lua\README.md`), kein Import aus fremden Paketen |
| Ueberschneidung mit eigenen Mods | keine gemeinsamen IDs. BrewLAN und BlackOps schliessen schon `DynamicGameplay`/`ImprovedHydrocarbonPowerPlants` aus, 4DC schon `T4UnitAdditions` |
| T4-Transportregel | betrifft hier keine Einheit (keine T4-Landeinheit enthalten) |

## 8. Beschreibungen und KI

**Beschreibungen** (`hook\lua\ui\help\unitdescription.lua`):
- wortgleich aus BrewLAN, BlackOps, 4DC: `sra0201`, `sea0310`, `sea0313`, `sra0313`,
  `ssa0314`, `srl0320`, `bsa0310`, `bslk004`, `ual0310`, `ual0310-ptsg`
- `sel0324-sre` von Colin (sachlich)
- **neu von uns, sachlich:** `saa0306` (BrewLAN-Text war ein Scherz und beschreibt den
  festen Schild), `saa0306-ptsg` (Colins Text war ein Scherz), `sel0324` (BrewLAN-Text
  beschreibt das alte Radar), `sra4212` (gab es nicht)
- ohne Text: `saa0313`, `ssa0313` (in keiner Quelle vorhanden). Die Basisspiel-Einheiten
  behalten LOUDs Texte.

**KI** (`lua\CustomUnits\AirForceRebalance.lua`): Eintraege wortgleich aus den Quellpaketen
fuer Blade Raven, Sinnaino, die vier Penetration Fighter, Vulthatha-Ioz, Longbow,
Vindicator, Slink, Uyanah. Weggelassen: BrewLANs Eintraege, die den Slink als
Scharfschuetzen bzw. Artillerie fuehren (`T3SniperBots`, `T3LandArtillery`) - fuer eine
Flugabwehr unpassend. Bayblade, Wild Weasel, Orlok hatten nirgends einen Eintrag.
Basisspiel-Einheiten baut die KI ohnehin.

## 9. Abgrenzung

- **Flugabwehr-Kriterium:** Kategorie `ANTIAIR` und ausschliesslich Waffen mit
  `RangeCategory` `UWRC_AntiAir` (bzw. Raketenabwehr). Erfuellt von Sky Boxer, Longbow,
  Slink, Vindicator (Sky Boxer zurueckgenommen, siehe 5.6). **Uyanah** erfuellt es nicht (Bodenwaffe), ist aber auf Pauls Wunsch
  enthalten.
- Nicht enthalten: reine Raketenabwehr (Buzzkill, Volcano, Purger, Protector), Schiffe mit
  Flak (Atlantis, Iavish, Yathsou, Patch Class), Megaroach.
- Rest von `UEF_trans_men` nach diesem Mod: 41 Einheiten (Marine, Wirtschaft, TML/TMD,
  Ingenieure, Tarnung, Minen) - Liste in `TODO.md`.

## 10. Bekannte Grenzen

- **Ausbau-Knochen fehlen:** Longbow (`Back_Upgrade`, `Left_Arm_B01`, `Right_Arm_B01`) und
  Bayblade (`TarantulaBody`) verweisen auf Knochen, die ihre Modelle nicht haben. LOUD
  prueft mit `IsValidBone` (`sim\Unit.lua` Z. 3908-3985) - kein Absturz, nur keine
  Ausbau-Effekte.
- ~~Orlok ohne Bausymbol~~ - **Irrtum der ersten Fassung:** das Symbol lag in Colins `UEF_trans_men\textures\ui\common\icons\units\SRA4212_icon.dds` und ist jetzt im Mod. LOUD findet Symbole in aktiven Mods ueberall (`BlackopsIconSearch.lua` Z. 57-62, `Blueprints.lua` Z. 1303). Nicht uebernommen: `SRA4212rnd_icon.dds` (Symbol eines Forschungs-Gegenstands, den es hier nicht gibt). Die Kategorie `RESEARCHLOCKED` des Orlok sperrt nichts - in LOUD liest sie nur `BasegameRevamp` beim Freischalten.
- **Bayblade-Schild ohne eigenes Schaltersymbol:** Colin hat `OrderOverrides` entfernt; der
  Schalter erscheint mit LOUDs Standardsymbol.
- **Ialosaare `TightTurnMultiplier = 10000`** - **geklaert, bleibt** (Paul, 2026-10-14): der Wert
  wirkt auf die Drehung des Modells, nicht auf den Bewegungsvektor. Die Einheit dreht sich
  schnell zum Ziel, fliegt aber trotzdem die Kurve. Kein Versehen, sondern Wendigkeit in
  der Darstellung.

## 11. Tests

| Datum | Was | Ergebnis |
|---|---|---|
| 2026-10-14 | 121 Pfadliterale gegen das VFS | alle loesen auf |
| 2026-10-14 | ASCII, Restverweise auf Quellpakete | sauber |
| 2026-10-14 | Vollkopien gegen Colins Fassung | nur die Aenderungen aus Abschnitt 6 |
| | **Testlauf im Spiel** | **ausstehend** |

**Pruefliste:**

1. Mod-Manager: "Air Force Rebalance" mit Tomcat-Bild; Konfliktmeldung bei BrewLAN,
   BlackOps, 4DC.
2. Log: `Hooked /lua/ui/help/unitdescription.lua with /mods/airforcerebalance/...`, kein
   Fehler mit `airforcerebalance` im Pfad.
3. Je Fraktion ein Jaeger, ein Torpedobomber, ein Gunship bauen - Werte im Baumenue
   (Kosten, Bauzeit) wie in Abschnitt 5 (Merge wirkt).
4. Solace und Sinnaino feuern ihre Torpedos ("ClusterTorpedo").
5. Longbow: Omni Sensor bauen (ca. 4 s), Radar 150 / Omni 70, Energieverbrauch 750/s;
   Radar aus- und einschalten - **kein Lua-Fehler**; Ausbau entfernen - Radar zurueck auf
   30; Radar-Schuessel dreht sich.
6. Bayblade: Shield Dome bauen (ca. 2 s), Schild an/aus, Ausbau entfernen und erneut bauen.
7. Vindicator: Schild-Ausbau baut fertig; Arrow-Rakete fliegt.
8. Uyanah: Blitz trifft Luft, Todesanimation laeuft.
9. Blade Raven und Orlok tarnen sich.
10. KI mit BrewLAN-Einheiten (z. B. Penetration Fighter) - baut sie die?

## 12. Offene Punkte

- [ ] Testlauf, Abschnitt 11
- [x] `BuildRate = 15` fuer die Ausbauten - bestaetigt (Paul, 2026-10-14)
- [x] Ialosaare `TightTurnMultiplier = 10000` - geklaert, bleibt (10)
- [x] Bausymbol fuer den Orlok - war vorhanden, uebernommen (10)

## 13. Quellen

- `LOUD\usermods\UEF_trans_men\units\` - Colins Fassungen (Altbestand, eingefroren)
- `LOUD\gamedata.entpackt\units\units\` - LOUD-Basiseinheiten
- `LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_LOUD\units\`
- `LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\units\`
- `LOUD\gamedata.entpackt\4D-CompatibilityPack\mods\4DC\`
