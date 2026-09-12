# _Altlasten

Ablage fuer Dateien, die aus einem Mod entfernt wurden, aber nicht verloren gehen sollen.

**Regel:** hier liegt nichts, was das Spiel jemals laedt. Der Ordner ist Teil von
`doc.claude\` und damit im Git-Repository, aber `doc.claude\` hat kein `mod_info.lua` -
`AllMods()` in `mods.lua` findet den Ordner also nie als Mod, und keine Datei darin wird
je ausgefuehrt. Auch `.bp`-Dateien waeren hier folgenlos, weil `LoadBlueprints()` nur
`m.location` **aktiver** Mods durchsucht.

Endungen wie `.lua` bleiben erhalten, damit man den Inhalt weiter mit Syntaxhervorhebung
lesen kann. Wo eine Datei nur teilweise entfernt wurde, traegt die Kopie hier den Zusatz
`.vollstaendig`.

Jede Datei bekommt im Kopf einen Kommentar: woher sie kam, wann und warum sie entfernt
wurde, und was stattdessen gilt.

Verwandter Ordner: `_ausrangiert\` - dort liegt aelteres Material aus der KI-Arbeit
(`lobby.lua.ausrangiert`). Bei Gelegenheit zusammenlegen.

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
