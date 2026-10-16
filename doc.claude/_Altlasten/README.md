# _Altlasten

Ablage fuer Dateien, die aus einem Mod entfernt wurden, aber nicht verloren gehen sollen.

**Regel:** hier liegt nichts, was das Spiel jemals laedt. Der Ordner ist Teil von
`doc.claude\` und damit im Git-Repository. `.bp`-Dateien sind hier folgenlos, weil
`LoadBlueprints()` nur `m.location` **aktiver** Mods durchsucht.

**Achtung `mod_info.lua` (korrigiert 2026-10-17):** LOUD bindet `doc.claude\` als
`/mods/doc.claude/` ein (`LOUD\bin\LOUD.log`: `AddSearchPath ... usermods\doc.claude`), und
`AllMods()` sucht **rekursiv** (`mods.lua` Z. 273 in `LOUD\gamedata\lua.scd`:
`DiskFindFiles('/mods', '*mod_info.lua')`). Ein archivierter Mod mit `mod_info.lua` taucht
deshalb im Mod-Manager auf. Archivierte Mods bekommen ihr `mod_info.lua` darum als
`mod_info.lua.archiv` (so bei `test21000` und `UEF_trans_men`). Die fruehere Aussage
"`doc.claude\` hat kein `mod_info.lua`, also findet `AllMods()` nichts" war falsch.

**Gilt fuer alles im Archiv** (Paul, 2026-10-17, auch CLAUDE.md Regel 9). Geprueft am
2026-10-17: ausser den beiden `.archiv`-Dateien liegt hier kein `*mod_info.lua`. Andere
Dateien sind unschaedlich - die uebrigen `DiskFindFiles`-Aufrufe in LOUD (`aibrain.lua`,
`EnhancedLobby.lua`, `lobby.lua`, `BlackopsIconSearch.lua`) suchen nur unter
`mod.location` aktiver Mods.

Endungen wie `.lua` bleiben erhalten, damit man den Inhalt weiter mit Syntaxhervorhebung
lesen kann. Wo eine Datei nur teilweise entfernt wurde, traegt die Kopie hier den Zusatz
`.vollstaendig`.

Jede Datei bekommt im Kopf einen Kommentar: woher sie kam, wann und warum sie entfernt
wurde, und was stattdessen gilt.

Der fruehere Ordner `_ausrangiert\` ist am 2026-10-14 hierher ueberfuehrt worden (Paul:
`_Altlasten` fuehrt). Inhalt siehe Abschnitt CustomAI unten.

---

## AirForceRebalance (2026-10-14)

| Datei | kam aus | Grund |
|---|---|---|
| `units\UEL0205\UEL0205_unit.bp` | `usermods\AirForceRebalance\units\UEL0205\` | Merge fuer den Sky Boxer (nur `CanFireFromTransport = true`, Colin). Zurueckgenommen (Paul): reiner UEF-Vorteil; entschieden: keine T2-Flak feuert aus dem Transport |

---

## PlayTest (2026-10-14)

| Datei | kam aus | Grund |
|---|---|---|
| `hook\lua\sim\Unit.lua` | `usermods\PlayTest\hook\lua\sim\` | enthielt seit 2026-08-15 nur noch einen Kommentar zum gescheiterten Methodenaustausch auf `Unit.lua`, wurde aber bei jeder Partie geladen. Befund in `mods\PlayTest.md` Abschnitt 4 |

---

## CustomAI (2026-08-08, ueberfuehrt 2026-10-14)

| Datei | kam aus | Grund |
|---|---|---|
| `lobby.lua.ausrangiert` | `doc.claude\_ausrangiert\` (urspruenglich `usermods\CustomAI\hook\lua\ui\lobby\lobby.lua`) | Hook zur Lobby-Vorbelegung von Fraktion und Farbe. Wurde nie geladen - Hooks greifen erst beim Sitzungsstart, die Lobby laeuft davor. Verworfen 2026-08-08, Analyse in der Datei bleibt gueltig. Siehe `TODO.md`, Erledigt |

---

## test21000 (2026-08-16)

Colins Cheat-Mod fuer den UEF-Kommandanten. **Vollstaendig durch `PlayTest` ersetzt**,
deshalb aus `usermods\` entfernt.

| | |
|---|---|
| Autor | Colin |
| uid | `12345678901234567890test21000` (keine GUID) |
| Beschreibung im Mod | "DID YOU SAY YOU WANTED RESCOURESSSS?????!!!!!" |
| Inhalt | ein einziger Blueprint: `units\UEL0001\` (UEF-ACU), Vollersatz |

Die `.sca`-, `.scm`- und `.dds`-Dateien lagen unveraendert mit im Ordner und liegen hier
unter `restliche_dateien\`.

### Was er geaendert hat

19 Zeilen gegenueber **LOUD** (`gamedata\units\units\UEL0001\UEL0001_unit.bp`):

| Feld | LOUD | test21000 |
|---|---:|---:|
| `BuildRate` | 10 | 1 000 |
| `MaxBuildDistance` | 10 | 100 |
| `ProductionPerSecondEnergy` | 20 | 1 000 000 |
| `ProductionPerSecondMass` | 2 | 10 000 |
| `StorageEnergy` | 5 000 | 4 000 |
| `BuildableCategory` | vier `BUILTBY*`-Eintraege | `'UEF'`, `'AEON'`, `'SERAPHIM'`, `'CYBRAN'`, `'NOMADS'` |

Der `NOMADS`-Eintrag zeigt, dass er das mit aktivem Nomads-Mod benutzt hat.

### Warum ersetzt

| | test21000 | PlayTest |
|---|---|---|
| Ansatz | ACU-Blueprint **vollstaendig ersetzen** | vier SCUs spawnen, Werte per `ModBlueprints` |
| Baumenue | alles in einem Menue, bei aktiven Zusatzmods mehrere hundert Eintraege | je SCU das gewohnte Fraktionsmenue mit Tech-Stufen |
| Kollisionen | jeder andere Mod an `UEL0001` - z. B. `usermods\commanders\` | keiner, kein Basis-Blueprint angefasst |
| Dokumentiert | nein | ja |

### Der Mehrwert, der bleibt

Die Semantik von `BuildableCategory` - festgehalten in `03_BLUEPRINTS.md`.
Kurz: Leerzeichen innerhalb eines Eintrags = **UND**, mehrere Eintraege = **ODER**.
Colin hat schlicht die `BUILTBY*`-Bedingung weggelassen, damit faellt die gesamte
Staffelung weg.

Umsichtig war nur, dass er die fuenf Fraktionen einzeln aufzaehlt statt `'ALLUNITS'` zu
schreiben - das haelt Zivilgebaeude und Sonderobjekte ohne Fraktionskategorie aus dem
Baumenue heraus.

Das stuetzt nebenbei unsere Lesart in `SquareShields`, wo `BuildableCategory = { }` gesetzt
wurde, um die Aufstiegsstufe zu entfernen: eine leere Liste heisst "kein Ausdruck trifft
zu", also nichts baubar. **Bewiesen ist das damit nicht**, die Lesart ist aber konsistent.

---

## T4UnitAdditions, vormals t4add (2026-10-14)

414 Dateien, die keine Einheit des Mods benutzt. Abhaengigkeitsanalyse in
`mods\T4UnitAdditions.md` Abschnitt 6. Die Pfadstruktur unter `T4UnitAdditions\` spiegelt den Mod-Ordner.
Keine Kopfkommentare in den einzelnen Dateien (Emitter-Blueprints, Binaerdateien) -
diese Tabelle ersetzt sie.

| Was | kam aus | Grund |
|---|---|---|
| 397 Emitter | `effects\Emitters\` | von keiner genutzten Klasse referenziert; 388 stammen aus BlackOps, 9 nur aus BattlePack; 47 verweisen noch auf `/mods/BlackOpsUnleashed/textures/` |
| `EffectEMPAmbient01` (2 Dateien) | `effects\entities\` | nur von einer ungenutzten Klasse in `BlackOpsprojectiles.lua` referenziert |
| `fire_cloud_alpha_04.dds`, `rb_0036_35.dds` | `textures\particles\` | byte-identisch mit LOUDs `/textures/particles/...`; die zwei Emitter verweisen jetzt dorthin |
| `BattlePackEffectTemplates.lua` | `lua\` | nur von `NEnergy` benutzt, das niemand importiert |
| `BlackOpsdefaultcollisionbeams.lua` | `lua\` | nur von Strahlwaffen benutzt, die niemand importiert |
| `*.lua.vollstaendig` (5) | `lua\` | vollstaendige Fassungen der gekuerzten Bibliotheken |
| `UEL0401_unit.bp.vollstaendig` + 10 Assets | `units\UEL0401\` | Vollkopie von LOUDs Fatboy, ersetzt durch eine Merge-Datei. Assets identisch mit `LOUD\gamedata.entpackt\units\units\UEL0401\` |
| `UEL0401_unit.bp.merge` | `units\UEL0401\` | Merge-Datei (zwei Felder), am selben Tag ersetzt durch die allgemeine T4-Transportregel in `hook\lua\system\Blueprints.lua` |
| `Thumbs.db` | `units\WEL0401\` | Windows-Vorschaucache, lag auch im BattlePack-Original |

---

## DynamicGameplay (2026-08-15)

| Datei | kam aus | Grund |
|---|---|---|
| `VersionCheck.lua` | `lua\legacy\` | BrewLAN-Kompatibilitaetsshim fuer SupCom/FA/FAF. Von niemandem importiert - die beiden Verweise darauf sind auskommentiert. |
| `AdjacencyBuffs.lua` | `lua\sim\` | BrewLANs Booster-Node-Buffs (`T3EngineeringBoosterBonus`, `T3HealthBoosterRegenBonus` und fuenf Tabellen). **Keine** der vier Einheiten hat ueberhaupt ein `Adjacency`-Feld. Lag zudem unter `lua\` statt `hook\lua\` und waere damit nie ausgefuehrt worden. |
| `Buff.lua` | `lua\sim\` | Patch auf `BuffAffectUnit` fuer den Buff `DarknessOmniNerf`. Lag unter `lua\` statt `hook\lua\` - nie ausgefuehrt. Siehe offener Punkt unten. |
| `BSB2402_Script.lua.original` | `units\BSB2402\` | Sicherungskopie des Kollegen. Wird nicht geladen (`.lua.original` ist keine `.lua`), gehoert aber nicht in einen Mod. |
| `unitdescription.lua.vollstaendig` | `hook\lua\ui\help\` | vollstaendige Fassung mit zehn Eintraegen. Im Mod verblieben sind nur die drei zu `seb3404`; die uebrigen sieben betreffen `t4add`. |

### Offener Punkt: DarknessEffect - ERLEDIGT, frueherer Befund war falsch

**Richtigstellung 2026-08-16.** `DarknessEffect` ist sehr wohl definiert - **LOUD-eigen**,
in `gamedata\lua\lua\sim\buffdefinitions.lua` Z. 217:

```lua
BuffBlueprint { Name = 'DarknessEffect',
    BuffType = 'COUNTERINTEL', Stacks = 'ALWAYS', Duration = 20.1,
    Affects = {
        VisionRadius = { Add = 0, Mult = 0.9  },
        RadarRadius  = { BuffCheckFunction = AdjBuffFuncs.RadarRadiusBuffCheck, Add = 0, Mult = 0.85 },
        OmniRadius   = { BuffCheckFunction = AdjBuffFuncs.OmniRadiusBuffCheck,  Add = 0, Mult = 0.75 },
    },
    Effects = { '/effects/emitters/jammer_ambient_01_emit.bp',
                '/effects/emitters/jammer_ambient_02_emit.bp' },
}
```

LOUD hat BrewLANs reinen Omni-Nerf also **nicht weggelassen, sondern ersetzt und
ausgebaut** - er wirkt jetzt auf Sicht, Radar und Omni, mit Buff-Check-Funktionen und
eigenen Effekten am betroffenen Gegner.

**Warum der Fehlbefund entstand:** es wurde ueber das LOUD-Repo nach BrewLANs Namen
`DarknessOmniNerf` gesucht (null Treffer, korrekt) - und daraus geschlossen, es gebe keine
Definition. Nach `DarknessEffect` wurde nie gesucht. Ein Suchbegriff zu wenig.

Damit war das Verschieben der `Buff.lua` hierher trotzdem richtig, nur aus anderem Grund:
nicht "Patch am toten Ort fuer einen fehlenden Buff", sondern **BrewLAN-Altlast, die LOUD
laengst durch Eigenes ersetzt hat**.

Der Darkness funktioniert in LOUD. Was tatsaechlich fehlte, war der optische Effekt - und
dessen Ursache liegt woanders, siehe `mods\DynamicGameplay.md` Abschnitt 5.2.

---

## UEF_trans_men (2026-10-17)

| Was | kam aus | Grund |
|---|---|---|
| ganzer Ordner `UEF_trans_men\` (1952 Dateien, 329 MB) | `usermods\UEF_trans_men\` | Colins Sammelmod, vollstaendig auf eigene Mods verteilt bzw. bewusst verworfen (Uebersicht `18_ABLEITUNG.md` Abschnitt 6.1). Paul: nach `_Altlasten` |
| `mod_info.lua` -> `mod_info.lua.archiv` | dort | damit der Mod-Manager ihn nicht mehr findet (siehe Regel oben) |

Bleibt Vergleichsquelle fuer das Team-PDF (`tools\teamdiff\`, Spalte "Colin").
Nicht mehr verfuegbar im Spiel: die 4 offenen Einheiten (Pearl, Yenesel, Wraith,
Megaroach) und alles aus Colins Fassung, das in keinem eigenen Mod steckt.

Ebenfalls am 2026-10-17: `test21000\mod_info.lua` -> `mod_info.lua.archiv` (gleicher Grund).