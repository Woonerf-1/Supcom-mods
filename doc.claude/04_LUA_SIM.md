# 04 — Simulations-Lua

Alles unter `gamedata.entpackt\lua\lua\` entspricht dem VFS-Pfad `/lua/`.
Das ist der Referenzcode: **lesen, nie ändern** — Änderungen entstehen als Hook im eigenen Mod.

---

## 1. Dateikartei: wo liegt was

### `/lua/` (Wurzel) — Kern und Fraktionsdefinitionen

| Datei | Zuständig für |
|---|---|
| `globalInit.lua` | Aufbau der Lua-Umgebung, Klassen, Import, Trashbag |
| `SessionInit.lua`, `simInit.lua` | Start der Simulation |
| `userInit.lua`, `UserSync.lua` | Start des UI-Prozesses, Sim→UI-Datenfluss |
| `defaultunits.lua` | **Basisklassen aller Einheiten** (StructureUnit, MobileUnit, FactoryUnit, AirUnit, WalkingLandUnit, ShieldStructureUnit …) |
| `aeonunits.lua`, `terranunits.lua`, `cybranunits.lua`, `seraphimunits.lua` | fraktionsspezifische Klassen |
| `*weapons.lua`, `*projectiles.lua` | Waffen-/Geschossklassen je Fraktion |
| `defaultweapons.lua` (in `sim\`), `defaultprojectiles.lua` | generische Basisklassen |
| `defaultantiprojectile.lua` | Flak/Abfangsysteme |
| `defaultexplosions.lua`, `EffectTemplates.lua`, `EffectUtilities.lua` | Effekte |
| `defaultcollisionbeams.lua` | Strahlenwaffen |
| `shield.lua` | Schilde |
| `aibrain.lua` | **AIBrain** — Ressourcen, Einheitenlisten, Plattformlogik |
| `platoon.lua` | Platoon-Verhalten |
| `loudutilities.lua` | **LOUD-eigene Hilfsfunktionen** — oft der Unterschied zu Vanilla |
| `utilities.lua` | allgemeine Helfer (Entfernung, Winkel, Zielsuche) |
| `game.lua` | Spielregeln, Baubeschränkungen |
| `BuildingTemplates.lua`, `basetemplates.lua` | Bau-Templates |
| `upgradetemplates.lua`, `enhancementcommon.lua` | ACU/SCU-Enhancements |
| `BuffFieldDefinitions.lua`, `DefaultBuffField.lua` | Buff-Felder (Adjazenz, Auren) |
| `factions.lua` | Fraktionsregistrierung |
| `SimCallbacks.lua` | **UI → Sim**-Aufrufe |
| `SimSync.lua`, `UserSync.lua` | **Sim → UI**-Datenfluss |
| `victory.lua`, `selfdestruct.lua`, `wreckage.lua`, `tarmacs.lua` | Spielende, Selbstzerstörung, Wracks, Bodenspuren |
| `mods.lua` | Modsystem (siehe `02_MODSYSTEM.md`) |
| `CustomUnits\LOUD_Buildings.lua` | LOUD-Mechanismus zum Registrieren zusätzlicher Bauoptionen |

### `/lua/sim/` — Simulationsklassen

| Datei | Inhalt |
|---|---|
| **`Unit.lua`** | **Die zentrale Einheitenklasse.** Häufigstes Hook-Ziel. |
| `weapon.lua`, `defaultweapons.lua` | Waffenlogik |
| `Projectile.lua`, `DefaultProjectiles.lua`, `DefaultDamage.lua` | Geschosse, Schadensverteilung |
| `CollisionBeam.lua` | Strahlen |
| `Entity.lua`, `Prop.lua`, `Blip.lua`, `VizMarker.lua` | Basisobjekte, Aufklärungs-Blips |
| `Buff.lua`, `buffdefinitions.lua`, `BuffField.lua` | Buff-System |
| `AdjacencyBuffs.lua`, `AdjacencyBuffFunctions.lua` | Adjazenzboni |
| `Builder.lua`, `BuilderManager.lua`, `FactoryBuilderManager.lua`, `EngineerManager.lua`, `PlatoonFormManager.lua`, `StrategyManager.lua`, `StrategyBuilder.lua`, `BrainConditionsMonitor.lua` | **KI-Infrastruktur (LOUD-Schwerpunkt)** |
| `Navigator.lua`, `MarkerUtilities.lua` | Wegfindung, Kartenmarker |
| `ScenarioUtilities.lua`, `ScriptTask.lua` | Missionen |
| `Profiler.lua` | Performanceanalyse |
| `tasks\` | Auftragsdefinitionen |

### `/lua/AI/` — Skirmish-KI

`aiutilities.lua`, `aiattackutilities.lua`, `aibehaviors.lua`, `aibuildstructures.lua`,
`Transportutilities.lua`, `sorianutilities.lua`, `SkirmishStrategyList.lua`
sowie die Verzeichnisse `AIBuilders\`, `AIBaseTemplates\`, `PlatoonTemplates\`,
`CustomAIs_v2\`. LOUD hat hier die tiefgreifendsten Eigenentwicklungen.

### `/lua/system/` — Infrastruktur

`class.lua` (Klassensystem), `import.lua`, `Blueprints.lua` (Blueprint-Laden),
`BuffBlueprints.lua`, `utils.lua` (`table.merged`, `safecall`, …), `trashbag.lua`,
`Localization.lua`, `repr.lua`, `profile.lua`, `saveload.lua`.

---

## 2. Lua-Dialekt: Achtung, kein Standard-Lua 5.1

Die FA-Engine nutzt eine modifizierte Lua 5.0.x-Variante:

| Besonderheit | Bedeutung |
|---|---|
| `!=` | funktioniert zusätzlich zu `~=` (siehe Originalcode) |
| `for k, v in tabelle do` | **ohne `pairs()`** — die Engine iteriert Tabellen direkt |
| `table.getn(t)` | statt `#t` |
| kein `goto`, kein Integer-Typ, kein `bit32` | |
| `import('/pfad/datei.lua')` | Modul laden; Pfad ist **VFS-Pfad**, nicht Dateisystempfad |
| `LOG()`, `WARN()`, `SPEW()` | Ausgabe ins `LOUD.log` |
| `repr(t)` | Tabelle lesbar ausgeben |
| Klassen | `Class(BasisKlasse) { ... }` aus `system\class.lua` |

**Beim Schreiben von Hook-Code den Stil der Originaldatei übernehmen**, nicht modernes Lua.

---

## 3. Die wichtigsten Hook-Punkte in `Unit.lua`

Ein Hook auf `/lua/sim/Unit.lua` erreicht alle Einheiten. Häufige Methoden:

| Methode | Aufruf bei |
|---|---|
| `OnCreate(self)` | Einheit entsteht |
| `OnStopBeingBuilt(self, builder, layer)` | Bau abgeschlossen |
| `OnStartBuild(self, unitBeingBuilt, order)` | beginnt zu bauen |
| `OnStopBuild(self, unitBeingBuilt)` | Bau beendet |
| `OnDamage(self, instigator, amount, vector, damageType)` | Schaden erhalten |
| `OnKilled(self, instigator, type, overkillRatio)` | zerstört |
| `OnDestroy(self)` | Objekt wird entsorgt |
| `OnMotionHorzEventChange`, `OnLayerChange` | Bewegung / Layerwechsel |
| `OnVeteran` / Veteranenlogik | Rangaufstieg |

**Pflichtmuster:**

```lua
-- usermods\MeinMod\hook\lua\sim\Unit.lua
local OldOnKilled = Unit.OnKilled

function Unit:OnKilled(instigator, type, overkillRatio)
    -- eigene Logik
    return OldOnKilled(self, instigator, type, overkillRatio)
end
```

> **Performancehinweis:** `OnDamage` und `OnStartBuild` laufen extrem oft. Der vorhandene Mod
> `EscalatingBuildCosts` iteriert in `OnStartBuild` über *alle* Einheiten des Spielers — das
> ist O(n) pro Bauauftrag und in LOUD-Großpartien spürbar. Bei eigenem Code stattdessen
> Zähler cachen (z. B. am `AIBrain` in einer eigenen Tabelle).

---

## 4. Häufig gebrauchte Engine-APIs

Alle vor Verwendung in `$SRC` gegenprüfen (`search_files` nach dem Funktionsnamen).

**Einheit**
```lua
self:GetBlueprint()            -- Blueprint-Tabelle
self:GetAIBrain()              -- AIBrain des Besitzers
self:GetArmy()                 -- Armee-Index
self:GetPosition()             -- {x, y, z}
self:GetHealth() / :SetHealth(instigator, hp) / :GetMaxHealth()
self:AdjustHealth(instigator, delta)
self:Destroy() / self:Kill()
self:GetUnitId()               -- Blueprint-ID
self:SetCustomName(name)
self:ForkThread(fn, ...)       -- Coroutine, an die Einheit gebunden
self.Trash:Add(obj)            -- Aufräumen bei Zerstörung
```

**Brain / Wirtschaft**
```lua
brain:GetListOfUnits(categories.X, needToBeIdle, requireBuilt)
brain:GetCurrentUnits(categories.X)
brain:GetEconomyStored('MASS' | 'ENERGY')
brain:GetEconomyIncome(...) / GetEconomyTrend(...)
brain:TakeResource('MASS', menge)
brain:GiveResource('MASS', menge)
ArmyBrains[index]
```

**Global**
```lua
GetUnitsInRect(rect) / GetEntitiesInRect
Damage(instigator, position, target, amount, damageType)
DamageArea(instigator, position, radius, amount, type, damageFriendly)
CreateUnitHPR(bpid, army, x, y, z, pitch, heading, roll)
WaitSeconds(n) / WaitTicks(n)      -- nur in Threads
GetGameTick() / GetGameTimeSeconds()
Random(min, max)
```

**Kategorien**
```lua
categories.MOBILE * categories.LAND - categories.COMMAND
EntityCategoryContains(categories.STRUCTURE, unit)
EntityCategoryFilterDown(categories.TECH3, unitTable)
```

---

## 5. Determinismus — die harte Regel der Sim

Die Simulation läuft auf jedem Rechner identisch. Jede Abweichung = **Desync**.

Verboten im Sim-Code:
- `math.random` (stattdessen `Random()` der Engine)
- Zugriff auf UI-Zustand, Mauszeiger, lokale Preferences
- Echtzeit/Systemuhr (`os.time`, `os.clock`) für spielrelevante Entscheidungen
- Iterationsreihenfolge unsortierter Tabellen für Entscheidungen mit Spielwirkung
- Fließkomma-Tricks, die von Rundung abhängen

Erlaubt ist `LOG()` — Logausgaben beeinflussen den Zustand nicht.

---

## 6. Threads und Aufräumen

```lua
function Unit:OnCreate()
    OldOnCreate(self)
    self.MeinThread = self:ForkThread(self.MeineSchleife)
end

function Unit:MeineSchleife()
    while not self.Dead do
        WaitSeconds(1)
        -- ...
    end
end
```

- `ForkThread` an der Einheit bindet den Thread an deren Lebensdauer.
- Alles, was manuell aufgeräumt werden muss (Effekte, Entities), in `self.Trash` legen.
- Endlosschleifen **immer** mit `WaitSeconds`/`WaitTicks` — sonst friert die Sim ein.
- 1 Tick = 0,1 s bei Normalgeschwindigkeit.

---

## 7. Vorgehen beim Suchen im Referenzcode

```
1. Begriff kennen?      → search_files($SRC\lua, '**/*.lua')  + read_text_file
2. Blueprint-Feld?      → search_files($SRC\units, '**/*.bp')
3. Nur Symbolname?      → in defaultunits.lua / Unit.lua / aibrain.lua nachschlagen —
                          dort liegen 80 % der Antworten
4. LOUD-spezifisch?     → loudutilities.lua, lua\AI\, lua\sim\*Manager.lua prüfen
```
