# 03 — Blueprints (`.bp`)

Blueprints sind die Datendefinition aller Einheiten, Geschosse, Props und Meshes.
Sie sind ausführbares Lua mit Konstruktor-Syntax: `UnitBlueprint { ... }`.

Referenzbeispiel (gelesen, verifiziert):
`gamedata.entpackt\units\units\UEL0001\UEL0001_unit.bp`

---

## 1. Dateien eines Einheitenordners

`gamedata.entpackt\units\units\<ID>\` bzw. im Mod `units\<ID>\`:

| Datei | Bedeutung |
|---|---|
| `<ID>_unit.bp` | **Blueprint** — alle Werte, Waffen, Kategorien |
| `<ID>_script.lua` | Verhaltensskript der Einheit (Klasse, Effekte, Sonderlogik) |
| `<ID>_lod0.scm`, `<ID>_lod1.scm` | Meshes (Level of Detail) |
| `<ID>_A001.sca`, `<ID>_Afold.sca`, … | Animationen |
| `<ID>_Albedo.dds`, `_NormalsTS.dds`, `_SpecTeam.dds` | Texturen |
| `<ID>_PhaseShield_mesh.bp` | Mesh-Blueprint für Schild-Effekt |

Die Blueprint-ID wird bei Einheiten aus dem Dateinamen abgeleitet — der Ordner- und
Dateiname bestimmt also, welche Einheit ersetzt/erweitert wird.

---

## 2a. `Economy.BuildableCategory` — wer darf was bauen

Eine Liste von Kategorieausdrücken. Sie steuert, **was diese Einheit bauen kann**.

```lua
BuildableCategory = {
    'BUILTBYCOMMANDER UEF',
    'BUILTBYTIER2COMMANDER UEF',
    'BUILTBYTIER3COMMANDER UEF',
    'BUILTBYTIER4COMMANDER UEF',
},
```

### Semantik

| Ebene | Verknüpfung |
|---|---|
| **Leerzeichen innerhalb eines Eintrags** | **UND** |
| **mehrere Einträge** | **ODER** |

`'BUILTBYTIER2COMMANDER UEF'` heißt also: die Zieleinheit muss die Kategorie
`BUILTBYTIER2COMMANDER` **und** `UEF` tragen.

Die Gegenseite steht in der `Categories`-Liste der jeweiligen Zieleinheit — dort stehen die
`BUILTBY*`-Marken, etwa `'BUILTBYTIER3ENGINEER'` oder `'BUILTBYTIER4COMMANDER'`.

### Wie man die Staffelung aushebelt

Lässt man die `BUILTBY*`-Bedingung weg, entfällt die gesamte Abstufung — Tech-Stufen,
Ausbaustufen, Fabrikbindung:

```lua
BuildableCategory = { 'UEF', 'AEON', 'SERAPHIM', 'CYBRAN' },   -- baut alles
```

**Nicht `'ALLUNITS'` schreiben.** Das zöge Zivilgebäude und Sonderobjekte ohne
Fraktionskategorie ins Baumenü — `XRC2201` und Ähnliches. Die vier (bei aktivem
Nomads-Mod fünf) Fraktionen einzeln aufzuzählen hält die sauber draußen.

Belegt an Colins `test21000` (jetzt in `_Altlasten\test21000\`), der genau das mit dem
UEF-ACU gemacht hat. **Praktisch ist das Ergebnis unhandlich**: alles landet in einem
einzigen Baumenü, bei aktiven Zusatzmods mehrere hundert Einträge. Für Testzwecke ist der
Weg über mehrere Einheiten je Fraktion besser — so macht es `PlayTest` mit vier SCUs.

### Leere Liste

```lua
BuildableCategory = { },
```

Kein Ausdruck trifft zu, also **nichts baubar**. So verwendet in
`usermods\SquareShields\`, um die Aufstiegsstufe der Schilde zu entfernen.

⚠️ **Aus der Semantik abgeleitet, nicht im Spiel gemessen.** Colins Gegenbeispiel stützt
die Lesart, beweist sie aber nicht.

---

## 2. Unit-ID-Systematik

`[Fraktion][Domäne][Techstufe][Nummer]`, z. B. `UEL0001`:

| Position | Beispiel | Bedeutung |
|---|---|---|
| 1 | `U`, `X`, `D`, `B`, `Z` | Herkunft/Set: `U` = original, `X` = Forged Alliance, `Z`/`B`/… = Mod-Pakete |
| 2 | `A`, `E`, `R`, `S` | Fraktion: **A**eon, **E** = UEF, **R** = Cybran, **S** = Seraphim |
| 3 | `L`, `A`, `S`, `B` | Domäne: **L**and, **A**ir, **S**ea, **B**ase/Building |
| 4–7 | `0001` | laufende Nummer; `0001` = ACU |

Beispiele: `UEL0001` UEF-ACU · `UAL0001` Aeon-ACU · `URL0001` Cybran-ACU · `XSL0001` Seraphim-ACU.

**Für eigene neue Einheiten:** Präfix wählen, das garantiert nicht kollidiert (siehe
`07_KONVENTIONEN.md`), und vor Vergabe per `search_files` in `gamedata.entpackt` und `usermods`
prüfen, dass die ID frei ist.

---

## 3. Aufbau eines `UnitBlueprint`

```lua
UnitBlueprint {
    AI          = { GuardRadius, InitialAutoMode, TargetBones, ... },
    Audio       = { CommanderArrival = Sound{Bank=..., Cue=..., LodCutoff=...}, ... },
    Buffs       = { Regen = { Level1 = 12, ... } },
    Categories  = { 'SELECTABLE','UEF','MOBILE','COMMAND','ENGINEER', ... },
    Defense     = {
        ArmorType, Health, MaxHealth, RegenRate,
        EconomyThreatLevel, SurfaceThreatLevel, AirThreatLevel,
        Shield = { ShieldMaxHealth, ShieldRegenRate, ShieldSize, ... },
    },
    Display     = { Mesh, UniformScale, MovementEffects, Tarmacs, ... },
    Economy     = { BuildCostEnergy, BuildCostMass, BuildTime,
                    BuildRate, BuildableCategory, ProductionPerSecondMass, ... },
    Enhancements= { ... },              -- ACU/SCU-Upgrades
    General     = { Category, Classification, FactionName, TechLevel,
                    UnitName, Icon, UnitWeight, CommandCaps, ... },
    Intel       = { VisionRadius, RadarRadius, SonarRadius, OmniRadius, ... },
    Interface   = { HelpText },
    LifeBarHeight, LifeBarOffset, LifeBarSize,
    Physics     = { MaxSpeed, MaxAcceleration, TurnRate, MotionType,
                    BuildOnLayerCaps, MeshExtentsX/Y/Z, ... },
    SelectionSizeX/Z, SelectionThickness,
    SizeX, SizeY, SizeZ,
    StrategicIconName, StrategicIconSortPriority,
    Transport   = { ... },
    Veteran     = { Level1 = ..., ... },
    Weapon      = { { ... }, { ... } },  -- Liste von Waffendefinitionen
    Wreckage    = { ... },
}
```

Ein Blick in die tatsächliche Datei schlägt jede Aufzählung — vor Änderungen die
Originaldatei in `gamedata.entpackt` lesen.

---

## 4. Balance ändern: `Merge = true`

**Der bevorzugte Weg.** Nur die genannten Felder werden überschrieben, alles andere bleibt.

```lua
-- usermods\MeinBalance\units\UEL0001\UEL0001_unit.bp
UnitBlueprint {
    Merge = true,
    BlueprintId = 'uel0001',      -- klein! Sicherheitshalber explizit setzen.

    Defense = {
        Health    = 15000,
        MaxHealth = 15000,
    },
    Economy = {
        BuildCostMass   = 12000,
        BuildCostEnergy = 240000,
    },
}
```

### ⚠️ Der wichtigste Fallstrick: Listen werden **indexweise** gemergt

Merge ruft `table.merged(original, mod)` auf (`lua\system\utils.lua`). Das ist ein
**rekursiver Merge über Schlüssel** — und Listen sind in Lua nur Tabellen mit den
Schlüsseln 1..n. Also:

```
original.Categories = { 'A', 'B', 'C', 'D', 'E' }
mod.Categories      = { 'X', 'Y' }
Ergebnis            = { 'X', 'Y', 'C', 'D', 'E' }     -- NICHT { 'X', 'Y' } !
```

Dasselbe gilt für `Weapon = { {...}, {...} }`: Waffe 1 im Mod merged auf Waffe 1 im Original.
Das ist praktisch, um gezielt einen Waffenwert zu ändern — und eine Falle, wenn man eine
Liste „ersetzen" will.

**Regeln daraus:**
- Einzelne Waffenwerte ändern → Waffenliste bis zum gewünschten Index nachbilden, nur das
  Zielfeld setzen.
- `Categories` wirklich ersetzen oder kürzen → geht **nicht** per Merge. Dafür
  `ModBlueprints()` verwenden.
- Ohne `Merge = true` wird das Original **vollständig** ersetzt — selten gewollt.
- `BlueprintId` in Kleinbuchstaben.

Weitere Fallstricke aus `Blueprints.lua`:
- Ein zur Laufzeit neu geladenes Blueprint greift nicht zuverlässig: manche Änderungen
  erfassen bestehende Einheiten, manche erst neu gebaute, manche gar nicht.
- Ein **entferntes** Feld fällt beim Reload auf den alten Wert zurück, nicht auf den Default.
  → Im Zweifel Spiel neu starten statt auf Hot-Reload vertrauen.

## 5. Massenänderungen: `ModBlueprints()`

Ablauf laut `lua\system\Blueprints.lua`:

```
1. alle .bp der Spieldaten ausführen  → füllt original_blueprints
2. alle .bp der aktiven Mods ausführen (ersetzen / mergen)
3. ExtractAllMeshBlueprints()
4. ModBlueprints(original_blueprints)      ← hier greift der Mod-Hook
5. RegisterAllBlueprints(original_blueprints)
```

`original_blueprints` ist nach Typ gegliedert:

```lua
{ Mesh = {}, Unit = {}, Prop = {}, Projectile = {},
  TrailEmitter = {}, Emitter = {}, Beam = {} }
```

Beispiel:

```lua
-- usermods\MeinBalance\hook\lua\system\Blueprints.lua
local OldModBlueprints = ModBlueprints

function ModBlueprints(all_bps)
    OldModBlueprints(all_bps)          -- andere Mods nicht abwürgen!

    for id, bp in all_bps.Unit do
        if bp.Economy and bp.Economy.BuildCostMass then
            bp.Economy.BuildCostMass = bp.Economy.BuildCostMass * 1.25
        end
    end
end
```

> **Pfad bestätigt (05.08.2026):** `hook\lua\system\Blueprints.lua` — also das normale
> Hook-Muster. Der Kopfkommentar in `Blueprints.lua` nennt zwar `/mods/.../hook/system/`,
> das ist aber irreführend. Beleg im `LOUD.log`:
> `Hooked /lua/system/Blueprints.lua with /mods/enhanced resources/hook/lua/system/Blueprints.lua`
> — und der LOUD-eigene Mod `Enhanced Resources`
> (`gamedata.entpackt\loud_misc\mods\Enhanced Resources\`) hat genau diese Struktur.
> Siehe `15_LOG.md` §4.1.

### LOUD-Besonderheit: Unit-Icons aus Usermods

`Blueprints.lua` sucht für jede `<ID>_unit.bp` eines Mods automatisch nach einem Icon unter
`<mod>\icons\units\<id>_icon.dds` oder `<mod>\textures\ui\common\icons\units\<id>_icon.dds`
— aber nur, wenn es noch kein Icon in den LOUD-Paketen gibt.

## 6. Neue Einheit anlegen

1. Nächstliegende bestehende Einheit in `gamedata.entpackt\units\units\` finden.
2. Kompletten Ordner nach `usermods\MeinMod\units\<NEUEID>\` kopieren.
3. Alle Dateien auf die neue ID umbenennen.
4. Im `.bp` anpassen: Verweise auf Mesh/Textur/Script-Pfade, `General.UnitName`,
   `Interface.HelpText`, `StrategicIconName`, Kategorien.
5. Im `_script.lua` den Klassennamen und `import`-Pfade anpassen.
6. Baubarkeit herstellen: die neue Einheit muss in der `BuildableCategory` einer Fabrik oder
   eines Bauers landen — üblich über eine eigene Kategorie + Anpassung der Bauer-Blueprints
   oder über LOUDs Mechanismus in `lua\CustomUnits\` (dort liegt z. B. `LOUD_Buildings.lua`).

## 7. Kategorien

`Categories = { ... }` steuert praktisch alles: Zielauswahl, Bau-Menüs, KI-Verhalten,
Buff-Wirkung, Statistiken.

Häufige Gruppen:
- Fraktion: `UEF`, `AEON`, `CYBRAN`, `SERAPHIM`
- Techstufe: `TECH1`, `TECH2`, `TECH3`, `EXPERIMENTAL`
- Domäne: `LAND`, `AIR`, `NAVAL`, `STRUCTURE`, `MOBILE`
- Rolle: `ENGINEER`, `CONSTRUCTION`, `FACTORY`, `DIRECTFIRE`, `INDIRECTFIRE`,
  `ANTIAIR`, `SHIELD`, `INTELLIGENCE`, `ECONOMIC`, `MASSEXTRACTION`, `ENERGYPRODUCTION`
- Sonstiges: `SELECTABLE`, `COMMAND`, `SUBCOMMANDER`, `RECLAIM`, `CAPTURE`, `SILO`,
  `VISIBLETORECON`, `OVERLAYOMNI`, `SHOWQUEUE`

Im Lua-Code werden sie als Ausdruck kombiniert:

```lua
categories.MOBILE * categories.LAND - categories.COMMAND    -- UND / NICHT
categories.TECH3 + categories.EXPERIMENTAL                  -- ODER
```

Verfügbare Kategorien: `search_files` über `gamedata.entpackt\units` nach dem Namen, oder
`gamedata.entpackt\lua\lua\sim\` nach `categories.<NAME>`.

## 8. Weitere Blueprint-Typen

`ProjectileBlueprint`, `PropBlueprint`, `MeshBlueprint`, `TrailEmitterBlueprint`,
`BeamBlueprint`, `EmitterBlueprint`. Zum Ersetzen dieser **muss** `BlueprintId` gesetzt werden
(anders als bei Units wird sie sonst aus dem Dateipfad abgeleitet).
