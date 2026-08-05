# 06 — Workflow, Logging, Debugging

## 1. Der Testzyklus

```
1. Änderung schreiben    → nur in usermods\<Mod>\
2. LOUD beenden          (Mods werden beim Start gemountet; laufende Instanz sieht nichts)
3. LOUD starten
4. Mod-Manager           → Mod aktivieren (bei neuem Mod / neuer uid nötig)
5. Skirmish gegen KI     → kleine Karte, wenige Gegner = schneller Zyklus
6. LOUD\bin\LOUD.log     → auswerten
```

**Kein Hot-Reload verlassen sich.** Blueprint-Reload zur Laufzeit ist laut
`lua\system\Blueprints.lua` unzuverlässig: manche Änderungen greifen nur bei neu gebauten
Einheiten, manche gar nicht, entfernte Felder behalten ihren alten Wert.

---

## 2. Das Log

**Datei:** `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\bin\LOUD.log`

Wird bei jedem Start neu geschrieben. Neben ihr liegt `LOUD - Kopie.log` (manuelle Sicherung
eines früheren Laufs — nicht überschreiben lassen, ggf. vor einem Testlauf selbst sichern).

### Aufbau des Logs

```
info: Mounting mod 'meinmod' with additional functionality (e.g. sounds)
info: DISK: AddSearchPath: '...\usermods\meinmod', mounted as '/mods/meinmod/'
info: *DEBUG UserInit
info: *DEBUG GlobalInit begins
warning: ...
info: Loaded N resources from mod at ...
info: Loaded N blueprints in total
info: Blueprints loaded
```

### Erste Prüfungen bei Problemen

| Frage | Wonach im Log suchen |
|---|---|
| Wird der Mod überhaupt gefunden? | `Mounting mod '<name>'` und `mounted as '/mods/<name>/'` |
| Ist `mod_info.lua` fehlerhaft? | `Problem loading ...mod_info.lua` (aus `LoadModInfo`) |
| Werden Blueprints geladen? | `Loaded N resources from mod at ...` |
| Lua-Fehler? | `error:`, `warning:`, `Problem `, `stack traceback` |
| Hook aktiv? | eigenes `LOG("MEINMOD: hook aktiv")` am Anfang des Hooks |

### Eigene Logausgaben

```lua
LOG("MEINMOD: OnStartBuild " .. tostring(bpid))
WARN("MEINMOD: unerwarteter Zustand")
LOG(repr(irgendeineTabelle))          -- Tabellen lesbar ausgeben
```

**Konvention:** jede eigene Ausgabe mit einem festen Präfix `<MODNAME>:` versehen, damit sie
im 10.000-Zeilen-Log auffindbar ist (siehe `07_KONVENTIONEN.md`).

---

## 3. Typische Fehlerbilder

| Symptom | Wahrscheinliche Ursache |
|---|---|
| Mod erscheint nicht im Mod-Manager | `mod_info.lua` fehlt/fehlerhaft, `selectable = false`, oder Syntaxfehler → Log prüfen |
| Mod da, aber wirkungslos | Hook-Pfad stimmt nicht mit VFS-Pfad überein (`hook\lua\sim\Unit.lua`, nicht `hook\sim\Unit.lua`) |
| Eigene Sounds fehlen komplett | Namenskollision einer `.xwb` → Log: `Did not load the custom sounds for '<name>'`. Siehe `11_DATAPATH.md` §2 |
| Hooks wirken gar nicht mehr | `LOUD\bin\LoudDataPath.lua` wurde überschrieben → gegen `doc.claude\referenz\LoudDataPath.lua.txt` prüfen |
| Änderung wirkt, aber alte Werte bleiben teils | Blueprint-Reload statt Neustart; oder Merge hat nur einen Listenindex getroffen |
| Ein anderer Mod wird kaputtgemacht | `shadow` statt `hook` benutzt, oder die alte Funktion im Hook nicht aufgerufen |
| Zwei Mods heben sich auf | Ladereihenfolge → `before`/`after` in `mod_info.lua` |
| Spiel stürzt beim Laden ab | Lua-Syntaxfehler im Hook, oder `nil`-Zugriff auf ein Blueprint-Feld |
| Desync im Mehrspieler | Nichtdeterministischer Sim-Code (siehe `04_LUA_SIM.md` §5) |
| Einheit nicht baubar | Nicht in der `BuildableCategory` eines Bauers gelandet |
| Neue Einheit unsichtbar / rosa | Mesh-/Texturpfade im Blueprint zeigen noch auf die Originaldateien |

---

## 4. Defensiv programmieren

Blueprint-Felder existieren nicht garantiert — in LOUD sind viele Einheiten aus fremden
Paketen (BrewLAN, BlackOps, Total Mayhem, Wyvern) mit abweichenden Strukturen.

```lua
-- schlecht
local kosten = bp.Economy.BuildCostMass * 2

-- gut
if bp and bp.Economy and bp.Economy.BuildCostMass then
    local kosten = bp.Economy.BuildCostMass * 2
end
```

Ebenso: `unit` kann bereits zerstört sein (`unit.Dead`), `instigator` kann `nil` sein.

---

## 5. Mod vorübergehend deaktivieren

Drei Wege, vom saubersten zum gröbsten:

1. Im Mod-Manager abwählen.
2. `enabled = false` in `mod_info.lua` — der Mod wird nie geladen.
3. Ordner aus `usermods\` heraus verschieben — **funktioniert nicht als Deaktivierung.**
   `mount_mods()` in `bin\CommonDataPath.lua` mountet **jeden** Unterordner von `usermods\`,
   unabhängig von `mod_info.lua`; ein Sammelordner `usermods\_deaktiviert\` würde selbst
   gemountet und die Engine findet die `mod_info.lua` darin trotzdem (sie sucht rekursiv
   nach `*mod_info.lua`). Weg 2 nutzen oder den Ordner ganz aus `usermods\` entfernen.

---

## 6. Isoliert testen

Bei unklarem Verhalten alle anderen Mods im Mod-Manager abwählen. In `usermods\` liegen
mehrere große Fremdpakete (Nomads, BO Unleashed, …), die weitreichend in Sim und Blueprints
eingreifen — sie sind eine häufige Ursache für „mein Mod tut nichts".

---

## 7. Vor jedem Abschluss

- [ ] Nur Dateien unter `usermods\` angefasst (Mods und `doc.claude\`), sonst nichts
- [ ] `CHANGELOG.md` ergänzt
- [ ] `mods\<modname>.md` aktuell
- [ ] Bekannte Konflikte notiert
- [ ] `TODO.md` gepflegt (was ist offen, was war die nächste Idee)
