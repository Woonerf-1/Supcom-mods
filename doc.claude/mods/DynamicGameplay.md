# Mod: DynamicGameplay

| | |
|---|---|
| **Ordner** | `usermods\DynamicGameplay\` |
| **VFS-Pfad** | `/mods/dynamicgameplay/` |
| **uid** | `8837F2BC-7C07-4CCF-8F80-34F545858442` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Log-Praefix** | keiner (kein eigener Lua-Code ausser Unit-Scripts) |
| **Status** | Entwurf - angepasst 2026-08-15, **im Spiel nur teilweise geprueft** |
| **Geprueft** | 2026-08-15 |

Uebergeordnet: [18_ABLEITUNG.md](../18_ABLEITUNG.md)

Hiess bis 2026-08-15 `dynamic_gameplay`.

---

## 1. Zweck

**Extrakt aus zwei LOUD-eigenen Paketen.** Vier Experimentaleinheiten, die das Spiel
beweglicher machen sollen - ohne die uebrigen rund 200 Einheiten der beiden Quellpakete.

| ID | Name | Herkunft |
|---|---|---|
| `SEB3404` | Panopticon - Experimental Sensor Array | BrewLAN for LOUD |
| `SRB4402` | Darkness - Experimental Omni Disrupting Facility | BrewLAN for LOUD |
| `BSL0005` | Hala Othuum - Tech 3 Elite Siege Tank | BlackOps Unleashed |
| `BSB2402` | Haasioz-Iya - Seraphim Quantum Rift Archway | BlackOps Unleashed |

## 2. Bestand

```
usermods\DynamicGameplay\
  mod_info.lua
  hook\lua\ui\help\unitdescription.lua      3 Zeilen
  hook\lua\ui\help\tooltips.lua             2 Eintraege, Beschriftung des Umschalters
  units\BSB2402\   7 Dateien
  units\BSL0005\   6 Dateien
  units\SEB3404\  16 Dateien
  units\SRB4402\   3 Dateien
```

Kein `lua\`, kein `shadow\`, kein `config.lua`, kein `icons\`, kein `sounds\`.
Dazu je eine `.md` neben den angefassten Lua-Dateien, siehe Abschnitt 11.

Das Mod-Bild ist das Bausymbol des Panopticon:
`icon = "/textures/ui/common/icons/units/SEB3404_icon.dds"` - ein reiner VFS-Pfad, es
liegt **keine Bilddatei im Mod** (Vorgehen wie bei den anderen Extrakten, siehe
`mods\SquareShields.md`).

**`SRB4402` hat nur drei Dateien** und trotzdem ein vollstaendiges Modell: der Darkness
benutzt die Geometrie und Texturen des Zivilgebaeudes `XRC2201` aus `civ_units.scd`
(siehe Abschnitt 6.1). BrewLAN macht es im Original genauso.

## 3. Warum Vollkopie

Wie bei den anderen Extrakten: `Merge = true` greift nur bei bereits vorhandener ID
(`Blueprints.lua`, `StoreBlueprint()`). Da beide Quellpakete per `conflicts` ausgeschlossen
sind, existiert sie nicht.

## 4. Dreifachvergleich - Original, UEF_trans_men, Extrakt

Verfahren: alle drei Fassungen in die Analyseumgebung kopieren, `\r` entfernen, `diff`.

### 4.1 Blueprints

| Datei | Original -> `UEF_trans_men` | `UEF_trans_men` -> Extrakt |
|---|---:|---:|
| `BSL0005_unit.bp` | 0 | 0 |
| `SEB3404_unit.bp` | 0 | 0 |
| `SRB4402_unit.bp` | 0 | 0 |
| `BSB2402_unit.bp` | 0 | **2** (nur Animationspfad) |

### 4.2 Scripts

| Datei | Original -> `UEF_trans_men` | `UEF_trans_men` -> Extrakt |
|---|---:|---:|
| `BSL0005_Script.lua` | 0 | 0 |
| `BSB2402_Script.lua` | 0 | 0 |
| `SRB4402_script.lua` | **4** | 0 (jetzt 2, siehe 5.2) |
| `SEB3404_Script.lua` | **2** | **8** (jetzt weniger, siehe 5.2) |

### 4.3 Der Kernbefund

**Der Extrakt hat kein Spielverhalten geaendert.** Er hat ausschliesslich Pfade und
Importe angepasst, damit die Einheiten ohne die Quellmods laufen. Saemtliche
inhaltlichen Abweichungen stammen aus `UEF_trans_men`.

## 5. Aenderungen

### 5.1 Bewusst uebernommene Verhaltensabweichungen Colins

Aus **Colin**, **als gewuenscht bestaetigt** am 2026-08-15 und 2026-08-16:

| Datei | Zeile | LOUD | jetzt |
|---|---|---|---|
| `SEB3404_Script.lua` | 72 | `SELECTABLE - COMMAND - SUBCOMMANDER - WALL - HEAVYWALL - MEDIUMWALL - MINE` | `SELECTABLE - COMMAND - SUBCOMMANDER` |
| `SEB3404_Script.lua` | 72 | `self:GetIntelRadius('radar')` | `self:GetIntelRadius('omni')` |
| `SRB4402_script.lua` | 74 | `... + categories.ual0401 + categories.sab2306 + categories.WALL` | ohne `sab2306` |

**Panopticon (`SEB3404`):** bleibt wie von Colin gestaltet. Die Wirkung ist erheblich und
sollte bekannt sein, bevor darueber entschieden wird:

| | LOUD | Colin / jetzt |
|---|---:|---:|
| Suchradius ohne Ausbau | 560 (Radar) | **212** (Omni) |
| Suchradius voll ausgebaut | 1115 | **394** |
| markierte Objekte | ohne Mauern und Minen | **mit** Mauern und Minen |

Der Suchradius sinkt also auf gut ein Drittel, gleichzeitig werden mehr Objekte markiert -
und jedes markierte Objekt kostet Unterhalt (`IntelSearch` rechnet die Kosten je Einheit).
Die beiden Teilaenderungen wirken gegeneinander; nach den Anhaltspunkten in
`18_ABLEITUNG.md` Abschnitt 0 spricht das eher fuer Versehen als fuer Absicht.

**Entschieden 2026-10-14 (Paul): Colins Fassung bleibt** - Panopticon und Darkness wie
in der Tabelle oben.

**Darkness (`SRB4402`):** Aeons Aria (`sab2306`) wird vom Darkness mitgetroffen. LOUD nimmt
sie aus, Colin nicht.

### 5.2 Korrigiert: der Schockwellen-Effekt des Darkness

Einzelheiten in `usermods\DynamicGameplay\units\SRB4402\SRB4402_script.md`.

Kurz: die drei Schockwellenring-Emitter hingen am Knochen `'XRC2201'`. Beide Modelle haben
genau einen Knochen, und er heisst je Detailstufe anders (`XRC2201` im LOD0,
`lod1_XRC2201` im LOD1) - aus groesserer Kameraentfernung existierte er also nicht. Die
Zeilen stehen vor dem Buff und vor dem Entfernen der Panopticon-Markierungen; ein Abbruch
dort haette den Darkness vollstaendig wirkungslos gemacht. Jetzt Knochen `0`,
LOD-unabhaengig. Der Fehler stammt aus **BrewLAN**.

### 5.3 Das Panopticon schaltet sich ab - Ursache geklaert, nicht behoben

Mehrere Testlaeufe am 2026-08-16. Das Geraet schaltet sich ab einer bestimmten Ausbaustufe
ab und kommt **nicht von selbst zurueck** - im Test erst, nachdem Paul den Schalter von
Hand betaetigt hat.

**Es liegt nicht an unserem Extrakt und nicht an Colin.** Ursache ist LOUDs
`IntelWatchThread` (`gamedata\lua\lua\sim\Unit.lua`), der den gespeicherten
Energievorrat gegen den **Sekundenverbrauch** vergleicht - das Einkommen kommt in der
Formel nicht vor. Vollstaendige Analyse als Fundstelle **B-03** in
`mods\BasegameBugfixes.md`.

Gemessen bei vollem Konto:

```
MM: Panopticon - Intel AUS | erhalten 1 | Verbrauch 0 | Einkommen 103502
                           | angefordert 6600 | gespeichert 19895 | Upkeep 6440
```

`erhalten 1` heisst 100 Prozent der Anforderung erfuellt, bei ueber einer Million
Einkommen pro Sekunde. Abgeschaltet wird trotzdem, weil 19 895 gespeichert < 65 999
Verbrauch/s.

**Faustregel im Spiel: Energiespeicher >= Sekundenverbrauch.**

| Ausbaustufe | Verbrauch/s | T1-Speicher (3 000) |
|---|---:|---:|
| Grundausbau | 6 440 | 3 |
| Med_Dish_002 | 18 150 | 7 |
| Small_Dish_003 | 30 000 | 10 |
| Med_Dish_004 | 66 000 | **22** |

Sichtweiten und Verbrauch aller neun Stufen stehen in
`usermods\DynamicGameplay\units\SEB3404\SEB3404_Script.md`.

**Entscheidung 2026-08-16: nicht anfassen.** Eine Anpassung an `IntelSearch` wurde gebaut,
getestet und wieder zurueckgenommen - sie loeste das Problem nicht.

### 5.4 Neu: Beschriftung des Panopticon-Schalters

`hook\lua\ui\help\tooltips.lua`, zwei Eintraege aus BrewLAN. Ohne sie bleibt der
Umschalter unbeschriftet, und LOUDs Standardtext waere zudem falsch. Einzelheiten in
`usermods\DynamicGameplay\hook\lua\ui\help\tooltips.md`.

Der Schalter heisst **Toggle Economy Watch** und schaltet nichts ab - er verkleinert bei
Bedarf die Reichweite auf ein bezahlbares Mass.

### 5.5 Entfernter Ballast

| Was | wo | Grund |
|---|---|---|
| `local BrewLANPath = import('/lua/game.lua').BrewLANPath()` | `SRB4402_script.lua` Z. 5 | nirgends benutzt; mit `conflicts` gegen BrewLAN ohnehin immer `nil` |
| zwei auskommentierte `BrewLANPath`-Zeilen | `SEB3404_Script.lua` Z. 10-11 | toter Code |
| auskommentierter `SetMesh`-Aufruf | `SEB3404_Script.lua` Z. 28 | toter Code |

Nicht archiviert - die Zeilen stehen unveraendert in `UEF_trans_men`.

Nach `doc.claude\_Altlasten\DynamicGameplay\` verschoben:

| Datei | Grund |
|---|---|
| `lua\legacy\VersionCheck.lua` | BrewLAN-Kompatibilitaetsshim, von niemandem importiert |
| `lua\sim\AdjacencyBuffs.lua` | BrewLANs Booster-Buffs; **keine** der vier Einheiten hat ein `Adjacency`-Feld, und die Datei lag unter `lua\` statt `hook\lua\` |
| `lua\sim\Buff.lua` | Patch auf `BuffAffectUnit`, ebenfalls am toten Ort |
| `units\BSB2402\BSB2402_Script.lua.original` | Sicherungskopie |
| `unitdescription.lua` (sieben von zehn Eintraegen) | betreffen `t4add`, nicht diesen Mod |

### 5.6 Pfadumschreibungen

Notwendig geworden durch die Umbenennung des Ordners - `.sca`- und Mesh-Pfade werden
strikt absolut aufgeloest (`07_KONVENTIONEN.md` Abschnitt 4):

| Datei | Zeile | jetzt |
|---|---|---|
| `BSB2402_unit.bp` | 40 | `/mods/dynamicgameplay/units/BSB2402/BSB2402_adeath.sca` |
| `SEB3404_Script.lua` | 29 | `/mods/dynamicgameplay/units/SEB3404/SEB3404_..._mesh` |

**Im Spiel bestaetigt:** die Todesanimation der Rift Gate laeuft mit korrigiertem Pfad
und fehlte mit einem absichtlich verbogenen - das war die A/B-Gegenprobe zum
Pfadtest vom 2026-08-15.

### 5.7 `mod_info.lua`

| Feld | Alt | Neu |
|---|---|---|
| Ordner | `dynamic_gameplay` | `DynamicGameplay` |
| `uid` | `Dynamic_gameplay_Version01` | `8837F2BC-7C07-4CCF-8F80-34F545858442` |
| `conflicts` | nicht gesetzt | BrewLAN **und** BlackOps, siehe unten |
| `icon` | nicht gesetzt | `/textures/ui/common/icons/units/SEB3404_icon.dds` |
| `description` | knapp | ausgeschrieben, mit Herkunftsangabe |

## 6. Referenzen nach aussen - vollstaendige Liste

**Alle Verweise sind geprueft und loesen auf.** Moeglich wurde das durch den zweiten
entpackten Spiegel (`Expand-Gamedata.ps1`, siehe `tools\README.md`) - die
Basisspiel-Archive waren vorher nicht einsehbar.

### 6.1 Modell des Darkness - `civ_units.scd`

`SRB4402_unit.bp` bringt nur `SRB4402_lod1.scm` selbst mit. Alles Uebrige kommt von
`XRC2201`:

| Zeile | Feld | Pfad |
|---|---|---|
| 55 | `AnimationDeath` | `/units/XRC2201/XRC2201_Adeath1.sca` |
| 72 | `MeshName` | `/units/xrc2201/xrc2201_lod0.scm` |
| 73 | `AlbedoName` | `/units/xrc2201/xrc2201_albedo.dds` |
| 74 | `SpecularName` | `/units/xrc2201/xrc2201_specteam.dds` |
| 75 | `NormalsName` | `/units/xrc2201/xrc2201_normalsTS.dds` |
| 81 | `NormalsName` LOD1 | `/units/xrc2201/xrc2201_lod1_normalsTS.dds` |

Alle sechs vorhanden in `LOUD\gamedata.entpackt\civ_units\units\XRC2201\`.
`UniformScale = 0.04` - das Zivilgebaeude wird stark verkleinert.

**Hinweis:** `/units/` speist sich nur aus `units.scd` und `civ_units.scd` - das sind die
einzigen beiden LOUD-Archive mit einem `units\`-Ordner im Wurzelverzeichnis
(`07_KONVENTIONEN.md` Abschnitt 4.3).

### 6.2 Emitter - Basisspiel, `effects.scd`

| Script | Emitter | Anzahl | geprueft |
|---|---|---:|---|
| `BSB2402_Script.lua` Z. 16-53 | `seraphim_rift_arch_base_01` bis `_10`, `_top_01` bis `_03`, `_edge_01` | 14 Dateien | alle vorhanden |
| `SRB4402_script.lua` Z. 64 | `cybran_qai_shutdown_ambient_01` bis `_04` | 4 | alle vorhanden |
| `SRB4402_script.lua` Z. 56, 58 | `flash_01_emit.bp`, `destruction_explosion_concussion_ring_03_emit.bp` | 2 | vorhanden |

Alle in `...\Supreme Commander Forged Alliance\gamedata.entpackt\effects\effects\Emitters\`.

`seraphim_rift_arch_edge_01_emit.bp` wird **sechsmal** aufgerufen, jeweils an einem
anderen Knochen - es gibt nur diese eine Kante-Datei, keine `_02` bis `_06`. Sieht nach
Absicht aus, nicht nach Fehler.

### 6.3 Tarmacs

| Blueprint | Pfad | Quelle |
|---|---|---|
| `SEB3404_unit.bp` Z. 104/105 | `/mods/brewlan_LOUD/env/common/decals/Tarmacs/Tar18x_01_albedo.dds` und `_normals.dds` | `brewlan.scd` - **geprueft vorhanden** |
| `SRB4402_unit.bp` Z. 88/92 | `Tarmacs/Tar12x_cybran_01_albedo` / `_normals` | Basisspiel, `env.scd` |

Der BrewLAN-Pfad ist ein harter Verweis in ein LOUD-Paket. Er loest auf, weil
`brewlan.scd` nach `/` gemountet wird und dort `mods\BrewLAN_LOUD\...` enthaelt - das
gilt **unabhaengig davon, ob BrewLAN aktiv ist**, denn Mounten und Aktivieren sind
getrennt. Er ueberlebt aber kein LOUD-Update, das den Ordner umbenennt.

### 6.4 Projektile - Basisspiel

`/projectiles/NullShell/NullShell_proj.bp` (SRB4402) ·
`/projectiles/SDFTauCannon01/`, `/projectiles/SDFAireauBolter02/`,
`/projectiles/SANUallCavitationTorpedo01/` (BSL0005)

### 6.5 Wrack und Texturen

`/props/DefaultWreckage/DefaultWreckage_prop.bp` (SEB3404, SRB4402, BSB2402) -
**geprueft** in `gamedata.entpackt\props\props\DefaultWreckage\`.

`/textures/environment/Falloff_seraphim_lookup.dds` (BSL0005, BSB2402) - `textures.scd`.

### 6.6 Lua-Importe - alles Spielcode

`/lua/defaultunits.lua` · `/lua/seraphimunits.lua` · `/lua/seraphimweapons.lua` ·
`/lua/sim/Buff.lua` · `/lua/sim/Entity.lua` · `/lua/sim/VizMarker.lua` ·
`/lua/sim/defaultweapons.lua` · `/lua/effectutilities.lua` · `/lua/ai/aiutilities.lua` ·
`/lua/utilities.lua`

**Kein Mod-Import mehr.** Nach dem Entfernen von `BrewLANPath` haengt nichts mehr an der
Anwesenheit von BrewLAN.

### 6.7 Sounds und Symbole

Banks: `URB`, `URLDestroy`, `UELDestroy`, `XSL`, `XSL_Destroy`, `XSL_Weapon`,
`SeraphimSelect`, `Interface`. Kein eigener `sounds\`-Ordner, damit greift die
`.xwb`-Kollisionsfalle aus `11_DATAPATH.md` Abschnitt 2 Regel 4 nicht.

Strategiesymbole: `icon_structure4_intel` (SEB3404), `icon_structure4_counterintel`
(SRB4402), `icon_seabed3_directfire` (BSL0005), `icon_factory4_land` (BSB2402).

## 7. Abhaengigkeiten und Konflikte

- **`requires`:** keine.
- **`conflicts`:** zwei Eintraege, weil der Mod aus zwei Paketen zieht:
  - `25D57D85-7D84-27HT-A501-BR3WL4N000079` - BrewLAN for LOUD (`SEB3404`, `SRB4402`)
  - `9e8ea941-c306-4751-b367-a11000000502` - BlackOps Unleashed (`BSL0005`, `BSB2402`)
- **`before` / `after`:** nicht gesetzt.

Die BrewLAN-uid ist dieselbe, die `game.lua` in `BrewLANPath()` hart abfragt; BrewLANs
eigene `mod_info.lua` weist darauf hin, dass sie an drei Stellen fest verdrahtet ist.

## 8. Performance / Multiplayer

Keine Lua-Logik ausserhalb der vier Unit-Scripts. `SEB3404` und `SRB4402` arbeiten mit
periodischen Threads (`FindAllUnits` im Intel-Radius) - bei mehreren Exemplaren auf
grossen Karten ist das der teuerste Teil des Mods. **Nicht gemessen.**

Sim-Mod, also von allen Spielern benoetigt.

## 9. Tests

| Datum | Was | Ergebnis |
|---|---|---|
| 2026-08-15 | Dreifachvergleich aller acht Dateien | siehe Abschnitt 4 |
| 2026-08-15 | Referenzen vollstaendig aufgeloest | Abschnitt 6, alle geprueft |
| 2026-08-15 | Mod gemountet und aktiv | `Mounting mod 'dynamicgameplay'` im Log |
| 2026-08-15 | `unitdescription.lua`-Hook greift | `Hooked /lua/ui/help/unitdescription.lua with /mods/dynamicgameplay/...` |
| 2026-08-15 | Rift Gate gebaut und gesprengt, Todesanimation | **laeuft** - mit verbogenem Pfad fehlte sie, A/B-Gegenprobe |
| 2026-08-16 | Panopticon gebaut, voll ausgebaut, beobachtet | Abschalten geklaert, Ursache in LOUD (B-03) |
| 2026-08-16 | Darkness: Puls im Spiel gesehen | **Effekt laeuft** |

## 10. Offene Punkte

- [x] **`SEB3404_Script.lua` Z. 29** - geklaert: der vermeintliche zweite Verweis auf
      `/units/SEB3404/SEB3404_` stammte aus der auskommentierten `BrewLANPath`-Zeile und
      ist mit dem Aufraeumen entfallen.
- [x] **`DarknessEffect`** - geklaert: der Buff ist **LOUD-eigen**,
      `gamedata\lua\lua\sim\buffdefinitions.lua` Z. 217. **Frueherer Befund "nirgends
      definiert" war falsch** - es wurde nur nach BrewLANs Namen `DarknessOmniNerf`
      gesucht.
- [x] **Panopticon-Ausbaustufen** - geklaert: die neun `*_Buff` sind in derselben
      LOUD-Datei definiert, mit gegenueber BrewLAN entschaerften Werten.
      **Frueherer Befund "nirgends definiert" war falsch** - `Filesystem:search_files` ist
      gross-/kleinschreibungsempfindlich.
- [x] **Warum schaltet sich das Panopticon ab?** - geklaert 2026-08-16, Ursache in LOUDs
      `IntelWatchThread`, siehe Abschnitt 5.3 und `mods\BasegameBugfixes.md` B-03.
      **Nicht behoben**, Behelf: genug Energiespeicher.
- [x] **Beschriftung des Umschalters** - ergaenzt, siehe Abschnitt 5.4.
- [x] **Panopticon-Suchradius und Zielauswahl** - entschieden 2026-10-14 (Paul): bleibt
      wie von Colin, siehe Abschnitt 5.1.
- [x] **Greift `conflicts`?** Bestaetigt 2026-08-16 im Mod-Manager: beim Aktivieren von
      BrewLAN erscheint *"The requested mod requires the following mods be disabled:
      Dynamic Gameplay"*.
- [x] **Wird das Mod-Bild angezeigt?** Bestaetigt 2026-08-16.
- [x] **`BSL0005` und `BSB2402`** - **kein eigener Test noetig.** Beide sind gegen LOUD
      byte-identisch (Blueprint und Script je 0 geaenderte Zeilen), einzige Ausnahme ist
      der Animationspfad in `BSB2402_unit.bp` Z. 40 - und genau der ist durch die
      A/B-Gegenprobe vom 2026-08-15 belegt (mit verbogenem Pfad fehlte die
      Todesanimation, mit korrigiertem laeuft sie). Wer sie im Spiel baut, spielt LOUDs
      Fassung.
- [x] **MM-Debugausgabe im Darkness entfernen** - war bereits erledigt (CHANGELOG
      2026-08-16 (4)); nachgeprueft 2026-10-14: in `usermods\DynamicGameplay\` ist keine
      `LOG`-Zeile aktiv, nur zwei auskommentierte aus BrewLAN.
- [ ] **Sieben Beschreibungstexte nach `t4add` uebernehmen** - liegen in
      `_Altlasten\DynamicGameplay\unitdescription.lua.vollstaendig`. **Achtung:** die
      Texte zu `ual0402` und `urs0304` sind interne Scherze und erscheinen so im Spiel.

## 11. Dokumentation neben dem Code

Nach `07_KONVENTIONEN.md`: keine erklaerenden Kommentare im Code, sondern eine eigene
Markdown-Datei daneben mit Verweis im Kurzkommentar.

| Code | Doku |
|---|---|
| `units\SEB3404\SEB3404_Script.lua` | `units\SEB3404\SEB3404_Script.md` |
| `units\SRB4402\SRB4402_script.lua` | `units\SRB4402\SRB4402_script.md` |
| `hook\lua\ui\help\tooltips.lua` | `hook\lua\ui\help\tooltips.md` |

## 12. Referenzen

- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_LOUD\units\` (`SEB3404`, `SRB4402`)
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\blackops\mods\BlackOpsUnleashed\units\` (`BSL0005`, `BSB2402`)
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\civ_units\units\XRC2201\`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\gamedata.entpackt\effects\effects\Emitters\`
- `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\doc.claude\_Altlasten\UEF_trans_men\units\` (Altbestand)
- `doc.claude\_Altlasten\DynamicGameplay\`
