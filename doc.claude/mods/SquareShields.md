# Mod: SquareShields

| | |
|---|---|
| **Ordner** | `usermods\SquareShields\` |
| **VFS-Pfad** | `/mods/squareshields/` |
| **uid** | `D5F66739-FD09-4166-8D73-A5D496772B7C` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Status** | Entwurf - angepasst 2026-08-15, **im Spiel ungetestet** |
| **Geprueft** | 2026-08-15 |

Uebergeordnet: [18_ABLEITUNG.md](../18_ABLEITUNG.md)

---

## 1. Zweck

**Extrakt aus `LOUD Unit Additions`.** Stellt die vier experimentellen Wuerfelschilde
bereit - SSD Hope (UEF), Luminesc (Aeon), ED-X (Cybran), Thanatos (Seraphim) - **ohne**
die uebrigen 22 Einheiten dieses Pakets.

Bewusst **ohne Aufstiegsstufe**: die Stufe 02 (`...ssg02`, "Squareshield & Storage") bleibt
draussen. Wer sie will, aktiviert `LOUD Unit Additions`.

## 2. Bestand

```
usermods\SquareShields\
  mod_info.lua
  units\UABSSG01\   10 Dateien
  units\UEBSSG01\   11 Dateien
  units\URBSSG01\   10 Dateien
  units\XSBSSG01\   11 Dateien
```

Kein `hook\`, kein `shadow\`, kein `lua\`, kein `effects\`, kein `icons\`.
Je Einheit rund 3,4 MB Assets, insgesamt etwa 13 MB.

## 3. Warum Vollkopie und nicht Merge

`Merge = true` greift nur, wenn die ID **schon vorhanden** ist:

```lua
-- gamedata.entpackt\lua\lua\system\Blueprints.lua, StoreBlueprint()
if t[id] and bp.Merge then
    t[id] = table.merged(t[id], bp)
else
    t[id] = bp
end
```

Genau das soll hier nicht der Fall sein - `LOUD Unit Additions` ist per `conflicts`
ausgeschlossen. Ein Merge-Blueprint allein wuerde in den `else`-Zweig fallen und einen
Torso ergeben. **Vollkopie ist der richtige Mechanismus.**

Aus demselben Grund ist Regel 3 aus `12_NEUSCHNITT.md` Abschnitt 4 ("keine unveraenderten
Asset-Kopien") hier nicht verletzt: die Kopie ist der Traeger, nicht eine Dublette neben
einem aktiven Original.

### Geprueft und verworfen: zwei schlankere Wege

**`excludes.lua`** - `LoadBlueprints()` (Z. 1243-1285) kann Blueprints eines *anderen*
Mods vom Laden ausschliessen. Damit liesse sich `LOUD Unit Additions` aktivieren und alles
ausser den Schilden unterdruecken, ganz ohne Kopie. **Blockiert:**

```lua
if e.key == m.config[e.combo] or e.always then
```

`m.config` wird in `mods.lua` (Z. 277-284) nur gesetzt, wenn `config.lua` erfolgreich
geladen wurde. `LOUD Unit Additions` hat keine. Beleg dafuer, dass `m.config` dann `nil`
bleibt: im `LOUD.log` steht **null mal** `has an empty or malformed config file` - diese
Warnung wuerde bei jedem Mod ohne gueltige Config feuern, wenn der `pcall` durchliefe.
Ausserdem setzt der Weg voraus, dass `LOUD Unit Additions` aktiv ist - was wir nicht
wollen.

**Nur Blueprints, Assets aus LOUDs VFS** - `loud_units.scd` wird nach `/` gemountet, die
Dateien unter `/mods/LOUD Unit Additions/units/UEBSSG01/...` sind also **immer** im VFS,
unabhaengig von der Aktivierung (nur *Blueprints* werden aus `m.location` **aktiver** Mods
geladen). Absolute Asset-Pfade in LOD-Bloecken sind ein reales Muster, siehe
`dynamic_gameplay\units\SRB4402\SRB4402_unit.bp` Z. 72-75. **Verworfen**, weil der Mod
damit still an LOUDs Dateilayout haengt: benennt ein Update etwas um, verschwindet das
Modell ohne Fehlermeldung. Ausserdem waere die Weiterleitung des Unit-Scripts
(`TypeClass = import('/mods/LOUD Unit Additions/...')`) **unverifiziert**.

## 4. Aenderungen gegenueber dem Original

Ausgangsbasis: `gamedata.entpackt\loud_units\mods\LOUD Unit Additions\units\<ID>\` -
Blueprints und Scripts waren vor der Anpassung **byte-identisch** (Diff 0), ebenso
identisch mit `usermods\UEF_trans_men\units\<ID>\`.

### 4.1 Aufstieg entfernt - alle vier Blueprints

| Feld | Original | Neu |
|---|---|---|
| `Economy.BuildableCategory` | `{ '<id>ssg02' }` | `{ }` |
| `Economy.RebuildBonusIds` | `{'<id>ssg01','<id>ssg02'}` | `{'<id>ssg01'}` |
| `General.UpgradesTo` | `'<id>ssg02'` | entfernt |

`Economy.BuildRate = 30` bleibt stehen - schadet nicht und waere bei einem spaeteren
Aufstieg wieder noetig.

### 4.2 Korrigiert: der Animationspfad in XSBSSG01 - BELEGT

`XSBSSG01_unit.bp` Z. 61, `Display.AnimationDeath`:

| | |
|---|---|
| Original (`LOUD Unit Additions`) | `/units/XSBSSG01/XSBSSG01_ADeath1.sca` |
| jetzt | `/mods/squareshields/units/XSBSSG01/XSBSSG01_ADeath1.sca` |

**Der Originalpfad ist nachweislich kaputt.** `/units/XSBSSG01/` existiert im VFS nicht -
`/units/` speist sich nur aus `units.scd` und `civ_units.scd`, die `.sca` liegt unter
`loud_units\mods\LOUD Unit Additions\units\XSBSSG01\`.

Dass daraus wirklich eine fehlende Animation folgt, war lange offen und ist seit dem
2026-08-15 **belegt**: drei Testlaeufe mit `PlayTest` haben gezeigt, dass `.sca`-Pfade
strikt und absolut aufgeloest werden - kein Rueckfall auf das Blueprint-Verzeichnis,
keine Dateinamensuche, keine Suche innerhalb von `/units/`. Einzelheiten in
`07_KONVENTIONEN.md` Abschnitt 4.

Thanatos hat in `LOUD Unit Additions` also seit jeher keine Todesanimation, und
`XSBSSG02` erbt denselben Fehler (es verweist auf dieselbe Datei).

**Preis der Korrektur:** der Mod ist damit an seinen Ordnernamen gebunden. Wird
`SquareShields\` umbenannt, muss diese Zeile mitgezogen werden.

### 4.3 `mod_info.lua`

| Feld | Alt | Neu |
|---|---|---|
| `uid` | `SquareShieldThyngVersion01` | `D5F66739-FD09-4166-8D73-A5D496772B7C` |
| `conflicts` | nicht gesetzt | `{ "fffffffe-6e98-4864-9599-4133236eea7a" }` |
| `icon` | nicht gesetzt | `/textures/ui/common/icons/units/UEBSSG01_icon.dds` |

Das Mod-Bild ist das Bausymbol der UEF-Fassung. Der Wert geht unveraendert an
`Bitmap:SetTexture()` (`gamedata.entpackt\lua\lua\ui\dialogs\modmanager.lua` Z. 1131 und
1365), ist also ein reiner VFS-Pfad - **es liegt keine Bilddatei im Mod**. Dargestellt mit
36x36 in der Liste, 70x70 in der Detailansicht.

**`requiresNames` wurde bewusst nicht gesetzt.** Die Tabelle ordnet ausschliesslich uids
aus `requires` einen Klartextnamen zu, damit die Meldung ueber einen **fehlenden** Mod
lesbar ist (`mods.lua` Z. 86-91). Fuer `conflicts` wird sie nicht gelesen - sie waere hier
wirkungslose Kosmetik.

`conflicts` wirkt in **beide Richtungen**: `GetDependencies()` (`mods.lua` Z. 396 ff.)
durchsucht alle Mods danach, ob sie diesen als Konflikt fuehren. Es genuegt also, dass
unser Mod `LOUD Unit Additions` nennt. Das Spiel verweigert dann die gleichzeitige
Aktivierung.

## 5. Referenzen nach aussen - vollstaendige Liste

Was der Mod **nicht** mitliefert, sondern aus dem Spiel bzw. aus LOUD bezieht.

### 5.1 Schildmeshes - LOUD, `effects.scd`

Alle vier Blueprints, Abschnitt `Defense.Shield`. Quelle:
`gamedata.entpackt\effects\effects\Entities\SquareShields\` - **alle Dateien vorhanden,
geprueft.**

| VFS-Pfad | verwendet von |
|---|---|
| `/effects/entities/SquareShields/BoxShieldSection01_mesh` (`ImpactMesh`) | alle vier |
| `/effects/entities/SquareShields/Shield02z_mesh` (`MeshZ`) | alle vier |
| `/effects/entities/SquareShields/UEFShield02_mesh` | UEBSSG01 |
| `/effects/entities/SquareShields/AeonShield02_mesh` | UABSSG01 |
| `/effects/entities/SquareShields/CybranShield02_mesh` | URBSSG01 |
| `/effects/entities/SquareShields/SeraphimShield02_mesh` | XSBSSG01 |

Hinweis: der gleichnamige Ordner `usermods\UEF_trans_men\effects\entities\SquareShields\`
war dort **schon immer wirkungslos** - ein Mod wird nur nach `/mods/<n>/` gemountet, nicht
auf die Wurzel.

### 5.2 Trefferwirkung - Namen aus `EffectTemplates`

`Defense.Shield.ImpactEffects`, keine Pfade sondern Schluessel:
`UEFShieldHit01` - `AeonShieldHit01` - `CybranShieldHit01` - `SeraphimShieldHit01`.
Aufgeloest ueber `/lua/EffectTemplates.lua`. **Existenz nicht einzeln nachgeprueft**,
unveraendert aus dem Original uebernommen.

### 5.3 Emitter in den Unit-Scripts

Alle unter `/effects/emitters/...`, also aus `effects.scd` bzw. dem Vanilla-Paket.

| Script | Emitter |
|---|---|
| `UEBSSG01_script.lua` | `terran_shield_generator_t2_01_emit.bp`, `..._t2_02_emit.bp` |
| `UABSSG01_script.lua` | `aeon_shield_generator_t2_01`, `_t2_02`, `_t3_03`, `_t3_04` |
| `URBSSG01_script.lua` | `cybran_shield_01_generator_01`, `_02`, `_03` |
| `XSBSSG01_script.lua` | `seraphim_shield_generator_t2_01`, `_t2_03`, `_t3_03` |

### 5.4 Lua-Importe der Unit-Scripts

| Script | Importe |
|---|---|
| UEBSSG01 | `/lua/terranunits.lua` (`TShieldStructureUnit`), `/lua/sim/Entity.lua` |
| UABSSG01 | `/lua/aeonunits.lua` (`AShieldStructureUnit`), `/lua/sim/Entity.lua`, `/lua/EffectTemplates.lua`, `/lua/utilities.lua` |
| URBSSG01 | `/lua/defaultunits.lua` (`StructureUnit`), `/lua/sim/Entity.lua`, `/lua/EffectTemplates.lua`, `/lua/utilities.lua` |
| XSBSSG01 | `/lua/seraphimunits.lua` (`SShieldStructureUnit`), `/lua/sim/Entity.lua`, `/lua/EffectTemplates.lua`, `/lua/utilities.lua` |

Alles Spielcode aus `lua.scd`, kein Mod-Import. **Kein Verweis auf `/mods/uef_trans_men/`,
`/mods/LOUD Unit Additions/` oder einen anderen Mod.**

### 5.5 Tarmacs - Vanilla-FA, `gamedata\env.scd`

`Display.Tarmacs`, relativ aufgeloest:

| Blueprint | Albedo / Normal |
|---|---|
| UEBSSG01 | `Tarmacs/Tar12x_01_albedo` / `Tar12x_01_normals` |
| UABSSG01 | `Tarmacs/Tar12x_aeon_01_albedo` / `..._normals` |
| URBSSG01 | `Tarmacs/Tar12x_cybran_01_albedo` / `..._normals` |
| XSBSSG01 | `Tarmacs/Tar8x_seraphim_01_albedo` / `..._normals` |

**Nicht direkt einsehbar:** diese Dateien liegen im gepackten `env.scd` des Vanilla-Spiels
(`$FA\gamedata\env.scd`, von `LoudDataPath.lua` nach `/` gemountet), nicht in
`gamedata.entpackt`. Da die Namen unveraendert aus `LOUD Unit Additions` stammen,
verhalten sie sich dort wie bisher.

### 5.6 Wrack

Alle vier: `Wreckage.Blueprint = '/props/DefaultWreckage/DefaultWreckage_prop.bp'`.
Aus dem gepackten `props.scd` des Vanilla-Spiels - in `gamedata.entpackt` **nicht
enthalten**, daher nicht direkt einsehbar. Unveraendert aus dem Original.

### 5.7 Strategiesymbole und Bauicons

- `StrategicIconName = 'icon_structure4_shield'` (alle vier) - aus `textures.scd`.
- Die Bauicons liegen bereits im Spiel:
  `gamedata.entpackt\textures\textures\ui\common\icons\units\UEBSSG01_icon.dds` und die
  drei uebrigen. `LoadBlueprints()` (Z. 1300) sucht nur dann im Mod nach einem Icon, wenn
  unter `/textures/ui/common/icons/units/<id>_icon.dds` keines liegt. **Der Mod braucht
  also keine eigenen Icons.**

### 5.8 Sounds

Alle aus vorhandenen Soundbanks, keine mitgelieferte `.xwb`:

| Blueprint | Bank / Cue |
|---|---|
| alle vier | `UALDestroy` / `UAB_Destroy_Lrg_PreDestroy`, `UAB_Destroy_Huge` |
| UEBSSG01 | `UEB` / `UEB4301_Activate` (ShieldOn/Off), `Interface` / `UEF_Select_Structure` |
| UABSSG01 | `UAB` / `UAB4301_Activate`, `Interface` / `Aeon_Select_Structure` |
| URBSSG01 | `Interface` / `Cybran_Select_Structure` |
| XSBSSG01 | `SeraphimSelect` / `Seraphim_Select_Structure` |

Damit entfaellt auch die Kollisionsfalle aus `11_DATAPATH.md` Abschnitt 2 Regel 4 - der
Mod hat keinen `sounds\`-Ordner.

### 5.9 Lokalisierung

`<LOC uebssg01_name>SSD Hope` und Entsprechungen. Die `<LOC ...>`-Schluessel loesen ueber
`strings_db.lua` auf; fehlt der Eintrag, greift der Klartext dahinter. **Der Mod bringt
keine eigene Lokalisierung mit** - ohne `LOUD Unit Additions` erscheinen also die
englischen Klartextnamen. Funktional folgenlos.

### 5.10 Selbst mitgeliefert

Meshes, Texturen und die Todesanimation je Einheit im eigenen `units\<ID>\`-Ordner - LOD0
und LOD1 werden ueber die Namenskonvention neben der `.bp` gefunden
(`Blueprints.lua`, `ExtractMeshBlueprint`, Z. 177-183). Die LOD1-Texturen sind im
Blueprint relativ benannt (`UEBSSG01_lod1_albedo.dds`) und loesen ebenfalls im eigenen
Ordner auf.

## 6. Abhaengigkeiten und Konflikte

- **`requires`:** keine.
- **`conflicts`:** `fffffffe-6e98-4864-9599-4133236eea7a` (LOUD Unit Additions).
- **`before` / `after`:** nicht gesetzt.
- **`LOUD Integrated Storage`** bringt fuer dieselben vier IDs ein 22-Zeilen-Merge mit
  (`hook\units\<ID>\<ID>_unit.bp`), das gegenueber `LOUD Unit Additions` genau ein Feld
  aendert: `Economy.BuildRate` 30 -> 25. Greift es auf unser Blueprint, ist die Wirkung
  dieselbe. Laut Entscheidung vom 2026-08-15 wird das nicht gesondert behandelt.

## 7. Performance / Multiplayer

Keine Lua-Logik ausserhalb der vier Unit-Scripts, die unveraendert aus
`LOUD Unit Additions` stammen. Sim-Mod, also von allen Spielern benoetigt.

## 8. Tests

| Datum | Was getestet | Ergebnis |
|---|---|---|
| 2026-08-15 | Diff aller Blueprints und Scripts gegen `LOUD Unit Additions` | 0 Unterschiede (vor der Anpassung) |
| 2026-08-15 | Diff gegen `UEF_trans_men` (`UEBSSG01`) | 0 Unterschiede |
| 2026-08-15 | Fremdverweise vollstaendig aufgelistet | siehe Abschnitt 5 |
| - | Start im Spiel | **noch nicht** |

Log-Praefix dieses Mods: noch keiner vergeben (bisher kein eigener Lua-Code).

## 9. Offene Punkte

- [ ] **Testlauf.** Erwartet: `Mounting mod 'squareshields'` im Log, die vier Schilde in
      der Bauliste des T4-Ingenieurs, **kein** Aufstiegsknopf.
- [ ] **Greift `conflicts` wie gelesen?** Im Mod-Manager pruefen, ob `LOUD Unit Additions`
      und `SquareShields` wirklich nicht gleichzeitig aktivierbar sind. Bisher nur aus
      `mods.lua` abgeleitet, im Spiel **ungeprueft**.
- [x] **Zeigt Thanatos eine Todesanimation?** Geklaert 2026-08-15 ueber drei Testlaeufe
      mit `PlayTest`: `.sca`-Pfade werden strikt absolut aufgeloest, der Originalpfad
      `/units/XSBSSG01/...` ist kaputt. Korrigiert auf `/mods/squareshields/...`,
      siehe Abschnitt 4.2. Im Spiel noch nicht gegengeprueft.
- [ ] **Bricht das Entfernen von `UpgradesTo` etwas?** `ToggleCaps` und `OrderOverrides`
      bleiben unveraendert; ein leeres `BuildableCategory = { }` ist **nicht belegt** als
      gueltiger Wert - falls es Warnungen gibt, das Feld ganz streichen.
- [ ] **Wird das Mod-Bild angezeigt?** `icon` zeigt auf ein `.dds` aus `textures.scd`
      statt auf eine Datei im Mod. Aus `modmanager.lua` abgeleitet, **nicht im Spiel
      gesehen**.
- [ ] **Tarmac- und Wrackpfade** liegen in gepackten Vanilla-Archiven und sind hier nicht
      einsehbar. Unveraendert uebernommen, im Spiel zu bestaetigen.

## 10. Referenzen

- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loud_units\mods\LOUD Unit Additions\units\UEBSSG01\UEBSSG01_unit.bp`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loud_units\mods\LOUD Unit Additions\mod_info.lua`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loud_misc\mods\LOUD Integrated Storage\hook\units\UEBSSG01\UEBSSG01_unit.bp`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\effects\effects\Entities\SquareShields\`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\system\Blueprints.lua`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\mods.lua`
