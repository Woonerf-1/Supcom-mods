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

## DynamicGameplay (2026-08-15)

Entfernt beim vollstaendigen Durchgang des Mods. Dreifachvergleich Original ->
`UEF_trans_men` -> Extrakt in `doc.claude\mods\DynamicGameplay.md`.

| Datei | kam aus | Grund |
|---|---|---|
| `VersionCheck.lua` | `lua\legacy\` | BrewLAN-Kompatibilitaetsshim fuer SupCom/FA/FAF. Von niemandem importiert - die beiden Verweise darauf sind auskommentiert. |
| `AdjacencyBuffs.lua` | `lua\sim\` | BrewLANs Booster-Node-Buffs (`T3EngineeringBoosterBonus`, `T3HealthBoosterRegenBonus` und fuenf Tabellen). **Keine** der vier Einheiten hat ueberhaupt ein `Adjacency`-Feld. Lag zudem unter `lua\` statt `hook\lua\` und waere damit nie ausgefuehrt worden. |
| `Buff.lua` | `lua\sim\` | Patch auf `BuffAffectUnit` fuer den Buff `DarknessOmniNerf`. Lag unter `lua\` statt `hook\lua\` - nie ausgefuehrt. Siehe offener Punkt unten. |
| `BSB2402_Script.lua.original` | `units\BSB2402\` | Sicherungskopie des Kollegen. Wird nicht geladen (`.lua.original` ist keine `.lua`), gehoert aber nicht in einen Mod. |
| `unitdescription.lua.vollstaendig` | `hook\lua\ui\help\` | vollstaendige Fassung mit zehn Eintraegen. Im Mod verblieben sind nur die drei zu `seb3404`; die uebrigen sieben betreffen `t4add`. |

### Offener Punkt: DarknessEffect

`SRB4402_script.lua` Z. 76 ruft `Buff.ApplyBuff(v, 'DarknessEffect')` auf. Dieser Buff ist
**nirgends definiert** - nicht in LOUDs `AdjacencyBuffs.lua`, nicht in `Buff.lua`, nicht in
der hier abgelegten `AdjacencyBuffs.lua`, und auch nicht im vollstaendigen BrewLAN.

Durchsucht am 2026-08-15:

| Datei | Treffer |
|---|---|
| `BrewLAN_Units\BrewResearch\hook\lua\sim\buffdefinitions.lua` | nein - nur `ResearchItemBuff1-5`, `ResearchAIBuff`, `ResearchAIxBuff` |
| `BrewLAN_Units\BrewResearch\hook\lua\sim\AdjacencyBuffs.lua` | nein |
| `BrewLAN_LOUD\hook\lua\sim\Unit.lua` | nein |
| `BrewLAN_LOUD\hook\lua\system\Blueprints.lua` | nur `ual0401 = {'DARKNESSIMMUNE'}` Z. 239 - eine **Kategorie**, kein Buff |
| `BrewLAN_LOUD\lua\defaultunits.lua` | nein, kein einziges `BuffBlueprint` |
| LOUD `/lua/sim/AdjacencyBuffs.lua`, `/lua/sim/Buff.lua` | nein |

**Der Aufruf laeuft also schon im BrewLAN-Original ins Leere.** Dazu passt, dass die hier
abgelegte `Buff.lua` einen **anderen** Namen behandelt (`DarknessOmniNerf`) - das sieht
nach einer Umbenennung aus, bei der eine Stelle nicht mitgezogen wurde. Der eigentliche
Effekt des Darkness laeuft ueber `SetIntelRadius('Omni', ...)`, nicht ueber einen
Adjacency-Buff.

**Bewusst nicht geaendert** (Entscheidung 2026-08-15). Der Aufruf steht wortgleich im
Original; solange nicht belegt ist, dass er schadet, ist Nichtstun die kleinere Aenderung.

**Einschraenkung:** es wurden die plausiblen Kandidaten gelesen, nicht alle rund 30
Lua-Dateien in BrewLAN. `search_files` findet nur Dateinamen, keine Inhalte - ein
vollstaendiger Negativbeweis braucht ein Skript in `doc.claude\tools\`
(`CLAUDE.md` Abschnitt 4). Das Ergebnis ist **wahrscheinlich, nicht bewiesen**.

Steht in `TODO.md`.
