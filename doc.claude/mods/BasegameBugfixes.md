# Mod: Basegame Bugfixes

| | |
|---|---|
| **Ordner** | `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\BasegameBugfixes\` |
| **VFS-Pfad** | `/mods/basegamebugfixes/` |
| **uid** | `EFD7502E-1682-4DC2-BBA7-CC4243E74B71` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Status** | **Vorlage - ohne Inhalt** |
| **Angelegt** | 2026-08-06 |

---

## 1. Zweck

Behebt Fehler im LOUD-Basismaterial - Blueprints aus `gamedata.entpackt\units\units\`
**und** Fehler in LOUDs eigenem Lua-Code, die keiner Fremdmod-Quelle zuzuordnen sind.

**Noch nicht befuellt.** Was als Fehler gilt und was als Balance-Aenderung, ist noch
festzulegen.

---

## 1a. Gesammelte Fundstellen - noch nicht umgesetzt

Gefundene Fehler in LOUD, die hier hingehoeren. **Jeder davon sollte an das LOUD-Projekt
gemeldet werden** (`github.com/LOUD-Project/Git-LOUD`) - eine Behebung bei uns ist nur die
Zwischenloesung, damit wir weiterarbeiten koennen.

### B-01 Bauleiste stuerzt bei schnellen Upgrades ab

| | |
|---|---|
| **Datei** | `gamedata\lua\lua\ui\game\construction.lua` Z. 1427 und 1431 |
| **Quelle** | **LOUD** (UI-Code, kein Fremdmod) |
| **Gefunden** | 2026-08-16, Testlauf mit `PlayTest` |
| **Meldung** | `Error running OnRelease script in <deleted object>: construction.lua(1438): Game object has been destroyed` |
| **Status** | **nicht behoben**, nur dokumentiert |

**Der Code:**

```lua
if item.type == 'item' then
    UnitViewDetail.Show(__blueprints[item.id], sortedOptions.selection[1], item.id)
elseif item.type == 'enhancement' then
    UnitViewDetail.ShowEnhancement(item.enhTable, item.unitID, item.icon,
                                   GetEnhancementPrefix(item.unitID, item.icon),
                                   sortedOptions.selection[1])
end
```

`sortedOptions.selection[1]` ist die aktuell gewaehlte Einheit. Sie wird **ohne Pruefung**
weitergereicht. Ist sie zwischenzeitlich zerstoert worden, greift der Handler auf ein
geloeschtes Objekt zu und der `OnRelease`-Handler stirbt.

**Ausloeser:** ein Upgrade. Dabei wird die alte Einheit planmaessig zerstoert und durch die
neue ersetzt - `sortedOptions.selection[1]` zeigt fuer einen Moment ins Leere. Faellt in
diesen Moment das Loslassen der Maustaste ueber der Bauleiste, kracht es.

**Je schneller das Upgrade, desto wahrscheinlicher.** Im Fundfall lief `PlayTest` mit
`BuildRate 60000`, ein Upgrade dauerte praktisch keine Zeit. Das Panopticon (`SEB3404`)
mit seinen neun Ausbaustufen war gerade im Bau.

**LOUD macht es an anderer Stelle richtig** - Z. 659 derselben Datei:

```lua
if sortedOptions.selection[1] and not sortedOptions.selection[1]:IsDead()
   and sortedOptions.selection[1]:GetWorkProgress() then
```

**Behebung:** dieselbe Pruefung vor Z. 1427 setzen. Das ist ein Hook auf
`/lua/ui/game/construction.lua` - ein **UI-Hook**, also kein Sim-Mod-Anteil. Ob dieser Mod
dafuer der richtige Ort ist oder ob es einen eigenen UI-Fix-Mod braucht, ist offen
(`ui_only` waere dann `true`).

**Nicht unser Fehler.** Weder unsere Extrakte noch Colins Sammelmod fassen
`construction.lua` an. Der Fehler tritt in jedem LOUD-Spiel mit schnellen Upgrades auf.

### B-03 Sensoranlagen schalten sich bei vollem Konto ab und kommen nicht zurueck

| | |
|---|---|
| **Datei** | `gamedata\lua\lua\sim\Unit.lua`, `IntelWatchThread` |
| **Quelle** | **LOUD** |
| **Gefunden** | 2026-08-16, mehrere Testlaeufe mit `PlayTest` am Panopticon (`SEB3404`) |
| **Status** | **nicht behoben**, bewusst nicht angefasst |

**Die Bedingung:**

```lua
local bpVal = self:GetConsumptionPerSecondEnergy()
...
while ShouldWatchIntel(self, bpVal) and not self.Dead do
    WaitTicks(21)
    if GetEconomyStored( aiBrain, 'ENERGY' ) < bpVal and not self.Dead then
        ... Sensoren abschalten ...
        while GetEconomyStored( aiBrain, 'ENERGY' ) < bpVal and not self.Dead do
            WaitTicks(recharge + 1)
        end
        ... wieder einschalten ...
```

Verglichen wird der **gespeicherte Energievorrat** gegen den **Verbrauch pro Sekunde**.
**Das Einkommen kommt in der Formel nicht vor.**

**Gemessen** (Sandkasten, leere Karte, Panopticon im Vollausbau):

```
MM: Panopticon - Intel AUS | erhalten 1 | Verbrauch 0 | Einkommen 103502
                           | angefordert 6600 | gespeichert 19895 | Upkeep 6440
```

`erhalten 1` - die Einheit bekommt 100 % dessen, was sie anfordert. Das Einkommen liegt
bei 103 502 **pro Tick**, also ueber einer Million pro Sekunde, gegen 6 600 pro Tick
Anforderung. **Die Wirtschaft ist kerngesund, und trotzdem schaltet der Thread ab**, weil
19 895 gespeichert < 65 999 Verbrauch/s.

**Drei Folgen:**

1. **Jeder Verbraucher, dessen Sekundenverbrauch groesser ist als die Speicherkapazitaet,
   schaltet sich grundsaetzlich ab** - unabhaengig vom Einkommen.
2. **Er kommt nicht von selbst zurueck.** Die innere Warteschleife prueft dieselbe
   Bedingung; sie wird nie falsch. Im Test ging das Panopticon erst wieder an, **nachdem
   Paul den Schalter von Hand betaetigt hat**.
3. `bpVal` wird **einmal** vor der Schleife gelesen. Bei Einheiten, deren Verbrauch sich
   spaeter aendert (Ausbaustufen), wird gegen einen veralteten Wert geprueft.
   Ob der Thread bei jedem Ausbau neu startet, ist **ungeprueft**.

**Die richtige Bedingung waere** (Vorschlag Paul):

```lua
local bilanz = GetEconomyIncome(aiBrain,'ENERGY') - GetEconomyRequested(aiBrain,'ENERGY')
local vorrat = GetEconomyStored(aiBrain,'ENERGY')
local bedarf = self:GetConsumptionPerSecondEnergy() * 0.1   -- pro Tick

if bilanz < 0 and vorrat < bedarf then
```

Also abschalten, wenn die Bilanz **negativ** ist **und** der Puffer den Fehlbetrag nicht
mehr deckt - statt schon dann, wenn der Puffer kleiner als ein Sekundenverbrauch ist.

**Einheitenfalle:** `GetEconomyIncome` und `GetEconomyRequested` liefern **pro Tick**,
`GetConsumptionPerSecondEnergy` pro Sekunde. Faktor 10. Vermutlich mit ein Grund, warum
der einfache Vergleich gewaehlt wurde.

**Nebenbei:** `recharge` kommt aus `bp.Intel.ReactivateTime` mit Rueckfall 20 Sekunden.
Das Panopticon hat dort **0**, daraus wird `1 + 0*10 = 1` Tick - es prueft also zehnmal
pro Sekunde statt alle 20 Sekunden.

**Bewusst nicht behoben** (Entscheidung 2026-08-16). Es waere ein Hook auf
`/lua/sim/Unit.lua` - genau die Datei, bei der offen ist, ob Hooks fuer Strukturen
ueberhaupt greifen (siehe `TODO.md`, `Class()`-Frage) - und ein Eingriff in LOUDs
Wirtschaftslogik fuer **alle** Einheiten. Behelf im Spiel: genug Energiespeicher bauen,
Faustregel **Speicherkapazitaet >= Sekundenverbrauch der Sensoranlage**.

### B-02 Kartenname fehlt in der Fehlermeldung

| | |
|---|---|
| **Datei** | `gamedata\lua\lua\ui\maputil.lua` Z. 92 und 98 |
| **Quelle** | **LOUD** |
| **Gefunden** | 2026-08-16 |
| **Status** | **nicht behoben**, nur dokumentiert |

```lua
local mapName = 'Unknown' or scenario.name
WARN('Map '..mapName..' is missing a save file!')
```

`'Unknown'` ist immer wahr, der `or`-Zweig greift nie. **Jede dieser Meldungen nennt die
Karte "Unknown"** - die einzige nuetzliche Information fehlt. Steht zweimal in derselben
Datei (`has no armies table!` und `is missing a save file!`).

Richtig waere `local mapName = scenario.name or 'Unknown'`.

Folge fuer uns: die zwei Warnungen im Log liessen sich nicht zuordnen. Behelf ist
`tools\Test-Maps.ps1`.

---

## 2. Umsetzung

Noch nichts umgesetzt. Erwarteter Aufbau:

```
BasegameBugfixes\
├── mod_info.lua
└── units\<ID>\<ID>_unit.bp     Merge-Blueprints, siehe 03_BLUEPRINTS.md
```

**Merge, nicht Vollersatz.** Fuer Fehlerbehebungen an Basiseinheiten ist
`Merge = true` der richtige Weg: nur die betroffenen Felder werden geaendert, der Rest
bleibt beim LOUD-Stand und ueberlebt Updates.

## 3. Abhaengigkeiten und Konflikte

- **`requires`:** keine
- **`conflicts`:** keine
- **`before` / `after`:** keine

**Zu beachten:** 120 der 425 Basiseinheiten werden bereits von anderen Mods ersetzt
(`..\units\ueberschreibungen.md`). Vor jeder Aenderung dort nachsehen - bei einer
mehrfach belegten ID kann diese Fassung von einem spaeter angewandten Mod verdeckt
werden. `Merge = true` schuetzt davor **nicht**.

Wichtigste Konkurrenten bei Basiseinheiten:

| Mod | ersetzt basegame | auf dieser Installation aktiv |
|---|---:|---|
| `LOUD Integrated Storage` | 40 | nein |
| `ZLOUD Structure Enhancements` | 32 | nicht geprueft |
| `UEF_trans_men` | 39 | eingefroren |
| `Enhanced Nukes` | 8 | nicht geprueft |

## 4. Performance

Blueprint-Merges kosten zur Laufzeit nichts. Sollte spaeter ein Hook dazukommen, hier
den Aufwand pro Aufruf vermerken.

## 5. Multiplayer

- Alle Spieler brauchen den Mod: **ja** (Sim-Mod)
- Determinismus: bei reinen Blueprint-Merges kein Thema

## 6. Tests

| Datum | Was getestet | Ergebnis |
|---|---|---|
| | Mod erscheint im Mod-Manager | offen |

Log-Praefix fuer eigene Ausgaben: `BUGFIX:`

## 7. Offene Punkte

- [ ] Kein Icon hinterlegt - es gilt das generische Standardsymbol. Falls gewuenscht:
      `icons\basegamebugfixes.bmp` anlegen und `icon` in `mod_info.lua` setzen.
- [ ] Fehlerliste zusammenstellen: was soll behoben werden?
- [ ] Abgrenzung zu Balance-Aenderungen festlegen

## 8. Quellen

Noch keine.
