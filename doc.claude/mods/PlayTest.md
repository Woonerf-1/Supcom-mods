# Mod: PlayTest

| | |
|---|---|
| **Ordner** | `usermods\PlayTest\` |
| **VFS-Pfad** | `/mods/playtest/` |
| **Typ** | Sim-Mod |
| **Log-Praefix** | `PLAYTEST:` fuer den Mod selbst, `MM:` fuer die Ausgaben unserer Feature-Mods |
| **Status** | in Benutzung, im Spiel bestaetigt 2026-08-16 |

**NUR FUER TESTPARTIEN.** Dieser Mod gehoert nie in ein echtes Spiel.

---

## 1. Zweck

Eine Umgebung, in der sich beliebige Einheiten sofort bauen und ausprobieren lassen, und
in der unsere eigenen Mods nachweisen, was sie tun.

Der Mod aendert **nichts** an unseren Feature-Mods - er schaltet nur deren Ausgaben ein
und stattet den Spieler aus.

## 2. Bestand

```
usermods\PlayTest\
  mod_info.lua
  hook\lua\aibrain.lua               Debug-Schalter
  hook\lua\simInit.lua               spawnt vier SCUs je ACU
  hook\lua\system\Blueprints.lua     SCU-Werte hochsetzen
  hook\lua\sim\Unit.lua              STILLGELEGT, nur Kommentar
  units\                             leer
```

## 3. Was der Mod tut

### 3.1 Vier Unterkommandanten je ACU

`hook\lua\simInit.lua` umhuellt `BeginSession()` und setzt nach einer Sekunde je Armee
**einen SCU jeder Fraktion** neben den ACU - `uel0301`, `ual0301`, `url0301`, `xsl0301`,
im Kreuz mit Abstand 6.

Alle vier Fraktionen, nicht nur die eigene: so lassen sich in einer Partie Einheiten
aller Fraktionen bauen.

Jeder `CreateUnitHPR`-Aufruf steckt in `pcall` - schlaegt einer fehl, gibt es eine
`WARN`-Zeile statt eines Threadabbruchs.

**Im Spiel bestaetigt (2026-08-16):**

```
PLAYTEST: Armee 1 (Paul) - vier SCUs beim ACU abgesetzt
PLAYTEST: Armee 2 (civilian) hat keinen ACU - uebersprungen
PLAYTEST: insgesamt 4 Unterkommandanten erzeugt
```

**Nebenwirkung:** unmittelbar danach erscheint dreimal `warning: Paul is trying to cheat!`.
Das ist **kein Spielerverhalten**, sondern die Folge von `CreateUnitHPR`: die Engine
vermerkt ausserhalb des Bauwegs entstandene Einheiten in `Sync.Cheaters`, und
`UserSync.lua` Z. 206-216 gibt das ab Sekunde 15 aus. `trying to cheat` statt `cheating`
bedeutet, dass Cheats in der Lobby **nicht** aktiviert waren.

### 3.2 SCU-Werte hochsetzen

`hook\lua\system\Blueprints.lua`, ueber `ModBlueprints`. Zwei getrennte Faktoren:

| Konstante | Wert | wirkt auf |
|---|---:|---|
| `FAKTOR` | 1000 | `BuildRate`, `ProductionPerSecondEnergy`, `ProductionPerSecondMass` |
| `FAKTOR_SPEICHER` | 100 | `StorageMass` |

Ausgangswerte in LOUD: `BuildRate 60`, Energie 200, Masse 2 (Seraphim 300 / 3).

Fehlt ein Feld im Blueprint, wird der Faktor als Absolutwert gesetzt statt multipliziert -
an der Logzeile ablesbar.

**Nicht angefasst:** die Produktionswerte in den Enhancements (z. B. `UEL0301_unit.bp`
Z. 287). Wer einen SCU aufruestet, bekommt dort wieder die Originalwerte.

**Im Spiel bestaetigt (2026-08-16):**

```
PLAYTEST: uel0301 - BuildRate 60000, Energie 200000, Masse 2000, Massespeicher ...
PLAYTEST: 4 von 4 SCUs versehen - Produktion x1000, Massespeicher x100
```

### 3.3 Debug-Schalter

`hook\lua\aibrain.lua`. Der Hook laeuft **nach** der Originaldatei und kann die dort auf
`false` gesetzten Schalter (`gamedata\lua\lua\aibrain.lua` Z. 185 ff.) ueberschreiben.

**Eigener Schalter fuer unsere Mods:**

```lua
ScenarioInfo.MMDialog = true
```

Ausgaben tragen durchgaengig das Praefix `MM:` und lassen sich damit vom LOUD-Rauschen
trennen. Auf `false` gesetzt laufen die Mods still weiter.

Ausgewertet in:

| Datei | protokolliert |
|---|---|
| `DynamicGameplay\units\SEB3404\SEB3404_Script.lua` | je Durchlauf: Suchradius, Anzahl markierter Objekte, `PanopticonUpkeep`, `ActiveConsumptionRestriction`; dazu jedes `OnIntelEnabled`/`OnIntelDisabled` |
| `DynamicGameplay\units\SRB4402\SRB4402_script.lua` | je Puls: Einheiten in Reichweite, Anzahl gebuffter Einheiten, erzeugte Emitter |
| `ImprovedHydrocarbonPowerPlants\hook\lua\system\Blueprints.lua` | eigenes Praefix `IHPP:` |

**Die Panopticon-Ausgaben beantworten die offene Frage, warum es sich immer wieder
abschaltet.** Wechseln sich `Intel AUS` und `Intel AN` ab, ist es das Aufschaukeln ueber
den Energieverbrauch: jedes markierte Objekt kostet Unterhalt, reicht die Energie nicht,
schaltet die Engine die Intel-Anlage ab, der Verbrauch faellt weg, sie geht wieder an.

**LOUD-eigene Schalter** stehen darunter als auskommentierte Liste. `ProjectileDialog`,
`WeaponDialog` und `WeaponStateDialog` sind im LOUD-Quelltext ausdruecklich als
"VERY COSTLY" gekennzeichnet und deshalb getrennt gefuehrt.

### 3.4 Fehlende Szenario-Angabe ergaenzt

```lua
if not ScenarioInfo.norushradius then
    ScenarioInfo.norushradius = 0
end
```

Beseitigt die Warnung
`CUSTOMAI NoRush: ... ScenarioInfo.norushradius fehlt, Construction.MaxRange = N`.
Die Angabe kommt sonst aus der Lobby-Option NoRush; steht die auf "Off", setzt LOUD sie
gar nicht erst. Das Verhalten bleibt identisch, nur die Meldung entfaellt.

## 4. Stillgelegt: `hook\lua\sim\Unit.lua`

Enthielt eine Umhuellung von `Unit.PlayAnimationThread`, um die Aufloesung von
`.sca`-Pfaden zu messen. Der Hook wurde laut Log geladen
(`Hooked /lua/sim/unit.lua with /mods/playtest/hook/lua/sim/unit.lua`) und lief
fehlerfrei - **aber die Umhuellung wurde nie aufgerufen**, obwohl im selben Lauf zwei
Gebaeude mit `AnimationDeath` gesprengt wurden.

**Vermutung, UNBELEGT:** `Class()` kopiert die Methoden der Elternklasse beim Anlegen der
Unterklasse, statt sie ueber eine Metatabelle nachzuschlagen. Dann traegt `StructureUnit`
aus `/lua/defaultunits.lua` weiterhin die Originalfassung, und eine Umhuellung an `Unit`
greift nur bei Einheiten, die direkt von `Unit` erben - praktisch bei keiner.

Reichweite: falls das stimmt, sind Hooks auf `/lua/sim/Unit.lua` fuer die meisten
Einheiten wirkungslos - das betrifft auch fremde Mods. Steht in `TODO.md`.

Der Ersatztest lief ueber `ModBlueprints` und kam ohne Instrumentierung aus. Ergebnis in
`07_KONVENTIONEN.md` Abschnitt 5.

## 5. Abhaengigkeiten und Konflikte

Keine `requires`, keine `conflicts`. Der Mod hookt `/lua/aibrain.lua`, `/lua/simInit.lua`
und `/lua/system/Blueprints.lua` - alle drei werden auch von anderen Mods gehookt
(`CustomAI`, `Enhanced Resources`, `ImprovedHydrocarbonPowerPlants`). Umhuellungen
verketten sich, das ist unkritisch.

## 6. Offene Punkte

- [ ] **Cheat-Meldung unterdruecken?** Liesse sich vermeiden, indem der Spawn ueber den
      regulaeren Bauweg statt ueber `CreateUnitHPR` laeuft. Deutlich mehr Aufwand fuer
      rein kosmetischen Gewinn.
- [ ] **Enhancement-Produktionswerte** der SCUs mit hochsetzen? Siehe 3.2.
- [ ] **`hook\lua\sim\Unit.lua`** loeschen, sobald die `Class()`-Frage geklaert ist.

## 7. Beim Messen beachten

**Der Testaufbau praegt die Zahlen.** Mit `PlayTest` steht in jeder Armee ein ACU und vier
SCUs - diese fuenf Einheiten tauchen in **jeder** Umkreissuche auf, die ueber `ArmyBrains`
oder ueber eigene Einheiten laeuft.

Beim Darkness-Test am 2026-08-16 ergab das 16 uebersprungene Einheiten je Puls, konstant
ueber alle Messungen - ausschliesslich Kommandanten. Das sah zunaechst nach einem Problem
in der Zielauswahl aus und war schlicht der eigene Aufbau.

**Regel: eine ueberraschende Zahl zuerst gegen den eigenen Testaufbau pruefen, bevor man
dem fremden Code ein Problem unterstellt.**

Zwei weitere Verzerrungen aus derselben Quelle:

| Einstellung | Wirkung auf Messungen |
|---|---|
| `BuildRate 60000` | Ausbaustufen sind in Sekundenbruchteilen fertig - verzerrt alles, was am Bauzyklus haengt, und hat den UI-Fehler B-01 ueberhaupt erst sichtbar gemacht |
| Produktion x1000 | Energieknappheit tritt praktisch nie auf - ein energiebedingtes Verhalten laesst sich so **nicht** nachstellen |

Umgekehrt gilt: eine **leere Sandkastenkarte** hat keine Feinde. Alles, was ueber
`'Enemy'` filtert - etwa `IntelSearch` des Panopticon - meldet dort konstant null Treffer.
Das ist kein Befund, sondern die Kartenlage.
