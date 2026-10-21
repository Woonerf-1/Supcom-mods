# Mod: AdjacencyRebalance

| | |
|---|---|
| **Ordner** | `LOUD\usermods\AdjacencyRebalance\` |
| **VFS-Pfad** | `/mods/adjacencyrebalance/` |
| **Anzeigename** | Adjacency Rebalance |
| **uid** | `1F3048D7-78B5-476D-8EFE-D5EA42111D9E` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Herkunft** | Werte aus `nomads-4-loud` (`shadow\lua\sim\AdjacencyBuffs.lua`), herausgeloest 2026-10-21 |
| **Icon** | `/textures/ui/common/icons/units/UEB3105_icon.dds` - UEF-Energiespeicher T3 (LOUD `textures.scd`) |
| **Status** | **angelegt 2026-10-21, im Spiel ungeprueft** |

Alle Pfade relativ zu `$FA`.

---

## 1. Zweck

Staerkere Nachbarschaftsboni (Adjacency) fuer Energiespeicher T1-T3 und die
Experimental-Speicher. Bisher steckten die Werte in einer Vollkopie von LOUDs
`AdjacencyBuffs.lua` im Nomads-Mod - hier herausgeloest als eigener Mod (Paul, 2026-10-21).

## 2. Bestand

```
LOUD\usermods\AdjacencyRebalance\
  mod_info.lua
  hook\lua\sim\AdjacencyBuffs.lua   setzt 24 Werte in der globalen Tabelle Buffs
```

## 3. Mechanik

- Nomads lieferte eine **Vollkopie** der 2593 Zeilen von `lua/sim/AdjacencyBuffs.lua`
  (`LOUD\gamedata\lua.scd`) mit 24 geaenderten Werten; alles andere zeilengleich
  (Vergleich 2026-10-21).
- Hier stattdessen ein **Hook**: er laeuft nach den `BuffBlueprint{}`-Aufrufen des Originals
  und aendert die Eintraege in `Buffs` (global, `lua/system/BuffBlueprints.lua` Z. 5). Ein
  zweites `BuffBlueprint{}` mit gleichem Namen ginge nicht - LOUD weist Duplikate ab
  (dort Z. 41-43).
- Vorteil: kuenftige LOUD-Aenderungen an `AdjacencyBuffs.lua` kommen an; nur die 24 Werte
  sind unsere.
- Logzeile: `AdjacencyRebalance: 24 Werte gesetzt`. Fehlt ein Buff, `WARN` mit Namen.

## 4. Werte (LOUD -> Mod)

Prozent = Aufschlag auf das Nachbargebaeude, je nach dessen Groesse (Size 4/12/16).

| Buff | Wirkung | LOUD | Mod |
|---|---|---|---|
| Energiespeicher T1 -> Energieproduktion | Size 4 / 12 / 16 | +10 % / +3,3 % / +2,5 % | **+17 % / +7,5 % / +7 %** |
| Energiespeicher T1 -> Schildleben | Size 12 / 16 | +0,8 % / +0,65 % | **+1,5 % / +1 %** |
| Energiespeicher T2 -> Energieproduktion | Size 4 / 12 / 16 | +17,5 % / +5,83 % / +4,375 % | **+30 % / +15 % / +15 %** |
| Energiespeicher T2 -> Schildleben | Size 12 / 16 | +2,03 % / +1,52 % | **+4,5 % / +3 %** |
| Energiespeicher T3 -> Energieproduktion | Size 4 / 12 / 16 | +21,5 % / +7,17 % / +5,375 % | **+50 % (Mult 1,1) / +25 % / +16 %** |
| Energiespeicher T3 -> Schildleben | Size 12 / 16 | +2,14 % / +1,6 % | **+13 % / +10 % (Mult 1,01)** |
| Experimental-Massespeicher -> Masseproduktion | | +20 % | **+30 %** |
| Experimental-Energiespeicher -> Energieproduktion | | +24 % | **+60 %** |
| Experimental-Energie -> Feuerrate | | -8 % | **-16 %** |
| Experimental-Energiespeicher -> Schildregeneration | | +6 % | **+10 % (Mult 1,1)** |
| dito, **neu** Schildleben | | - | **+13 % (Mult 1,1)** |

Buff-Namen und Einzelwerte: `hook\lua\sim\AdjacencyBuffs.lua`.

## 5. Verhaeltnis zu nomads-4-loud

`nomads-4-loud` bleibt **unveraendert** (Paul, 2026-10-21: nur herausloesen, das Original
nicht anfassen - wie bei `UEF_trans_men`). Dessen Vollkopie
`nomads-4-loud\shadow\lua\sim\AdjacencyBuffs.lua` liefert dieselben 24 Werte; solange sie
geladen wird, setzt dieser Hook nur noch einmal dasselbe (unschaedlich). Wie und wann
Nomads eingebunden wird (`LoudDataPath.lua`), klaert der Reverse Engineer, nicht dieser Mod.

Die Nomads-eigenen Buffs (`hook\lua\sim\buffdefinitions.lua`, Capacitor usw.) gehoeren zur
Nomads-Fraktion und sind nicht Teil dieses Mods.
## 6. Tests

| Datum | Was | Ergebnis |
|---|---|---|
| 2026-10-21 | Vergleich Nomads-Schatten gegen `lua.scd` | 24 Werte, sonst zeilengleich |
| | **Testlauf im Spiel** | **ausstehend** |

**Pruefliste:**

1. Mod-Manager: "Adjacency Rebalance" mit Energiespeicher-Bild.
2. Log: `Hooked /lua/sim/AdjacencyBuffs.lua with /mods/adjacencyrebalance/...` und
   `AdjacencyRebalance: 24 Werte gesetzt`, kein `WARN`.
3. Energiespeicher T1 neben einem Kraftwerk der Groesse 4 (`SIZE4`): Produktionsbonus ohne Mod +10 %, mit Mod +17 %.

## 7. Offene Punkte

- [ ] Testlauf, Abschnitt 6
