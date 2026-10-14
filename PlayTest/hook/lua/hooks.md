# PlayTest - Hooks

Dateien in `usermods\PlayTest\hook\lua\`:

| Datei | wirkt auf | Zweck |
|---|---|---|
| `aibrain.lua` | `/lua/aibrain.lua` | Debug-Schalter, `norushradius` |
| `simInit.lua` | `/lua/simInit.lua` | spawnt vier SCUs je ACU |
| `system\Blueprints.lua` | `/lua/system/Blueprints.lua` | SCU-Werte hochsetzen |
| ~~`sim\Unit.lua`~~ | `/lua/sim/Unit.lua` | **entfernt 2026-10-14**, liegt in `doc.claude\_Altlasten\PlayTest\` - siehe unten |

**NUR FUER TESTPARTIEN.** Dieser Mod gehoert nie in ein echtes Spiel.

Ausfuehrliche Moddokumentation: `doc.claude\mods\PlayTest.md`

---

## aibrain.lua - Debug-Schalter

Der Hook laeuft **nach** der Originaldatei und ueberschreibt die dort auf `false` gesetzten
Schalter (`gamedata\lua\lua\aibrain.lua` Z. 185 ff.). Alles auf Dateiebene, kein
Funktionsaufruf noetig.

### Eigener Schalter

```lua
ScenarioInfo.MMDialog = true
```

Wird von unseren Feature-Mods abgefragt. Alle Ausgaben tragen das Praefix `MM:` und lassen
sich mit `grep "MM:"` vom LOUD-Rauschen trennen. Auf `false` gesetzt laufen die Mods still
weiter.

Ausgewertet in:

| Datei | protokolliert |
|---|---|
| `DynamicGameplay\units\SRB4402\SRB4402_script.lua` | je Puls: Einheiten in Reichweite, gebuffte Einheiten, erzeugte Emitter |

`ImprovedHydrocarbonPowerPlants` hat ein eigenes Praefix `IHPP:` und einen eigenen
Schalter - unabhaengig hiervon.

Das Panopticon (`SEB3404`) hatte zeitweise ebenfalls Ausgaben; sie sind nach Abschluss der
Untersuchung entfernt worden. Ergebnis in `SEB3404_Script.md` und in
`doc.claude\mods\BasegameBugfixes.md` als Fundstelle B-03.

### LOUD-eigene Schalter

Darunter als auskommentierte Liste, einzeln einschaltbar. `ProjectileDialog`,
`WeaponDialog` und `WeaponStateDialog` sind im LOUD-Quelltext ausdruecklich als
"VERY COSTLY" gekennzeichnet und deshalb getrennt gefuehrt.

**Erfahrungswert:** `BuffDialog` erzeugte in einer kurzen Sandkastenpartie 367 Zeilen und
gab jeden gestapelten Buff einzeln aus. Fuer eine gezielte Frage brauchbar, fuer eine
laengere Partie zu gespraechig.

### norushradius

```lua
if not ScenarioInfo.norushradius then
    ScenarioInfo.norushradius = 0
end
```

Beseitigt die Warnung `CUSTOMAI NoRush: ... ScenarioInfo.norushradius fehlt`. Die Angabe
kommt sonst aus der Lobby-Option NoRush; steht die auf "Off", setzt LOUD sie gar nicht
erst. Verhalten identisch, nur die Meldung entfaellt.

---

## simInit.lua - vier Unterkommandanten je ACU

Umhuellt `BeginSession()` und setzt nach einer Sekunde je Armee **einen SCU jeder
Fraktion** neben den ACU - `uel0301`, `ual0301`, `url0301`, `xsl0301`, im Kreuz mit
Abstand 6.

Alle vier Fraktionen, nicht nur die eigene: so lassen sich in einer Partie Einheiten aller
Fraktionen bauen.

`BeginSession` laeuft laut Kommentar im Original, nachdem `ScenarioInfo.Env.OnPopulate()`
und `OnStart()` die Starteinheiten erzeugt haben. Das Spawnen laeuft trotzdem in einem
eigenen Thread mit Vorlauf, damit die ACUs sicher stehen und positioniert sind.

Jeder `CreateUnitHPR`-Aufruf steckt in `pcall` - schlaegt einer fehl, gibt es eine
`WARN`-Zeile statt eines Threadabbruchs.

**Nebenwirkung:** unmittelbar danach erscheint `warning: Paul is trying to cheat!`. Das ist
**kein Spielerverhalten**: die Engine vermerkt ausserhalb des Bauwegs entstandene
Einheiten in `Sync.Cheaters`, und `UserSync.lua` Z. 206-216 gibt das ab Sekunde 15 aus.
`trying to cheat` statt `cheating` bedeutet, dass Cheats in der Lobby **nicht** aktiviert
waren.

Dass Hooks auf `/lua/simInit.lua` greifen, ist belegt:
`Hooked /lua/simInit.lua with /mods/customai/hook/lua/simInit.lua` im LOUD.log. Mehrere
Mods koennen dieselbe Datei hooken, die Umhuellungen verketten sich.

---

## system\Blueprints.lua - SCU-Werte hochsetzen

Ueber `ModBlueprints`. Zwei getrennte Faktoren, beide als Konstante ganz oben:

| Konstante | Wert | wirkt auf |
|---|---:|---|
| `FAKTOR` | 1000 | `BuildRate`, `ProductionPerSecondEnergy`, `ProductionPerSecondMass` |
| `FAKTOR_SPEICHER` | 100 | `StorageMass` |

Ausgangswerte in LOUD: `BuildRate 60`, Energie 200, Masse 2 (Seraphim 300 / 3).

Fehlt ein Feld im Blueprint, wird der Faktor als Absolutwert gesetzt statt multipliziert -
an der Logzeile ablesbar.

**Nicht angefasst:** die Produktionswerte in den Enhancements (z. B. `UEL0301_unit.bp`
Z. 287). Wer einen SCU aufruestet, bekommt dort wieder die Originalwerte.

**Vorsicht bei Messungen:** mit `BuildRate 60000` sind Ausbaustufen in Sekundenbruchteilen
fertig. Das verzerrt alles, was am Bauzyklus haengt - und hat den UI-Fehler B-01
(`construction.lua`) ueberhaupt erst sichtbar gemacht.

---

## sim\Unit.lua - entfernt (2026-10-14)

Nur noch Kommentar, wurde aber bei jeder Partie mitgeladen. Nach
`doc.claude\_Altlasten\PlayTest\hook\lua\sim\Unit.lua` verschoben (Paul). Der Befund
bleibt hier und in `doc.claude\mods\PlayTest.md` Abschnitt 4 festgehalten:

Enthielt eine Umhuellung von `Unit.PlayAnimationThread`, um die Aufloesung von
`.sca`-Pfaden zu messen. Der Hook wurde laut Log geladen
(`Hooked /lua/sim/unit.lua with /mods/playtest/hook/lua/sim/unit.lua`) und lief
fehlerfrei - **aber die Umhuellung wurde nie aufgerufen**, obwohl im selben Lauf zwei
Gebaeude mit `AnimationDeath` gesprengt wurden.

**Vermutung, UNBELEGT:** `Class()` kopiert die Methoden der Elternklasse beim Anlegen der
Unterklasse, statt sie ueber eine Metatabelle nachzuschlagen. Dann traegt `StructureUnit`
aus `/lua/defaultunits.lua` weiterhin die Originalfassung, und eine Umhuellung an `Unit`
greift nur bei Einheiten, die direkt von `Unit` erben - praktisch bei keiner.

**Reichweite:** falls das stimmt, sind Hooks auf `/lua/sim/Unit.lua` fuer die meisten
Einheiten wirkungslos - das betrifft auch fremde Mods. Steht in `TODO.md`.

Der Ersatztest lief ueber `ModBlueprints` und kam ohne Instrumentierung aus. Ergebnis in
`doc.claude\07_KONVENTIONEN.md` Abschnitt 5.

Stand 2026-10-14: ein **Klassenersatz** greift nachweislich (`AcidPools` auf `Unit.lua`,
`T4UnitAdditions` auf `terranunits.lua`); offen ist nur, warum der reine
Methodenaustausch nicht griff.
