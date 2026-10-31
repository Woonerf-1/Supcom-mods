# Mod: EnhancedPauseBehavior

| | |
|---|---|
| **Ordner** | `usermods\EnhancedPauseBehavior\` |
| **VFS-Pfad** | `/mods/enhancedpausebehavior/` |
| **uid** | `E9410707-B979-462F-B9E8-3DDB886DB31B` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`), enthaelt aber nur UI-Lua |
| **Status** | Entwurf, im Spiel ungeprueft |
| **Angelegt** | 2026-10-31 |
| **Zuletzt geaendert** | 2026-10-31 |

---

## 1. Zweck

Mehrspieler: Wer eine Pause beenden will, setzt das Spiel nicht sofort fort. Alle
menschlichen Spieler bekommen das Fenster "Resume Game?" mit Namensliste
(ready / waiting). Sind alle bereit, laeuft ein Countdown von 5 s, danach geht es fuer
alle weiter. Kein Notausgang bei AFK (Paul 2026-10-31): wer nicht bereit wird, haelt
die Pause, jeder kann aber abbrechen.

Pause-Knopf: LOUD hat bereits einen (dritter Reiter oben in der Menueleiste, Taste
`Pause`, `keymap/keyactions.lua` Z. 12). Der Mod nutzt diesen Knopf, er baut keinen
zweiten. Texte im Fenster englisch wie das uebrige LOUD-UI (Paul 2026-10-31).

## 2. Umsetzung

| Mechanismus | Datei im Mod | Wirkt auf (VFS) | Original |
|---|---|---|---|
| Hook | `hook\lua\ui\game\tabs.lua` | `/lua/ui/game/tabs.lua` | `LOUD\gamedata\lua.scd` -> `lua/ui/game/tabs.lua` |
| eigenes Modul | `modules\readycheck.lua` | `/mods/enhancedpausebehavior/modules/readycheck.lua` | - |
| Bild | `enhancedpausebehavior.png` | Mod-Manager (256x256 PNG wie PlayTest, CustomAI, CorrosiveOcean) | - |

### Geaenderte Funktionen

| Was | Original | Neu | Begruendung |
|---|---|---|---|
| `tabs.lua` `Create` | Z. 358 | ruft vorher `readycheck.Init()` | Chat-Funktion registrieren, Huellen setzen |
| `tabs.lua` `CommonLogic` | Z. 412-497 | Pause-Reiter: `OnCheck` umhuellt | nach abgefangenem Fortsetzen Knopf gedrueckt halten |
| `tabs.lua` `OnPause` | Z. 741-768 | bei `state = false` Fenster schliessen | Spiel laeuft wieder |
| `_G.SessionResume` | Engine | Huelle: startet Bereit-Abfrage | Muster aus FAF `Repos\FAF\lua\ui\game\pause.lua` |
| `_G.SessionRequestPause` | Engine | Huelle: waehrend Abfrage = eigenes Bereit zuruecknehmen | Pause-Taste waehrend Abfrage |

### Ablauf

| Schritt | Wer | Nachricht |
|---|---|---|
| Fortsetzen gedrueckt (Knopf oder Taste) | Anfragender, gilt als bereit | `request` |
| "Ready" / "Not Ready" | jeder Spieler | `ready` |
| alle Teilnehmer bereit | nur der Anfragende entscheidet | `go` |
| Countdown (5 s) abgelaufen | nur der Anfragende ruft `SessionResume()` | - |
| "Cancel" | jeder Spieler | `cancel` |

Teilnehmer: verbundene Clients, deren Befehlsquelle eine Armee mit `human = true` und
`outOfGame = false` fuehrt. Beobachter, KI und ausgeschiedene Spieler zaehlen nicht;
Beobachter sehen das Fenster ohne Knoepfe. Direktes Fortsetzen wie in LOUD bleibt bei
Einzelspieler, Replay, Spielende und nur einem menschlichen Spieler.

Sonderfaelle:

- **Erneut pausieren waehrend Abfrage oder Countdown** (Pause-Knopf, Taste `Pause`,
  "Stop"): nimmt das eigene Bereit zurueck. Ein laufender Countdown stoppt bei allen
  ("Countdown stopped by ..."), die Abfrage bleibt offen, das Spiel bleibt pausiert.
- **Verbindungsverlust eines Spielers:** er zaehlt nicht mehr; waehrend des Countdowns
  startet der Countdown neu ("... left the game - countdown restarted").
- **Verbindungsverlust des Anfragenden:** Abfrage endet, Spiel bleibt pausiert, jeder
  kann neu anfragen.
- **Zwei Anfragen gleichzeitig:** es gilt auf allen Rechnern die mit dem niedrigeren
  Client-Index; wer schon bereit war, wird uebernommen.
- **Spiel laeuft wieder / Spielende:** Fenster schliesst (Rueckfall ueber
  `SessionIsPaused()` nach 3 s, falls `OnPause(false)` ausbleibt).

## 3. Warum dieser Eingriffspunkt

- **Abgleich ueber `SessionSendChatMessage`** (an alle Clients), Empfang ueber
  `gamemain.lua` `RegisterChatFunc(func, 'EnhancedPauseBehavior')`. Diese Nachrichten
  laufen neben der Simulation, nicht durch den Befehlsstrom und nicht ins Replay
  (`Repos\FAF\engine\User.lua` Z. 1139). Damit kann der Mod den Sim-Zustand nicht
  veraendern - kein Desync-Risiko.
- **Nicht SimCallback/Sync:** SimCallbacks sind Befehle im Befehlsstrom und werden an
  Sim-Ticks ausgefuehrt; waehrend der Pause tickt die Sim nicht. Jeder Bereit-Klick
  wuerde ausserdem Sim und Replay beruehren.
- Spielwirksam sind nur `SessionResume()` (ein Aufruf durch den Anfragenden) und
  `SessionRequestPause()` (unveraendert) - dieselben Engine-Funktionen wie der
  LOUD-Pause-Knopf.
- **`ui_only = false`** nur, damit die Lobby den Mod fuer alle erzwingt
  (`lua/ui/lobby/lobby.lua` `CheckIfHaveMods` Z. 679-711). Hooks von Game-Mods greifen
  auch im UI-State: `lua/SessionInit.lua` Z. 15-18 haengt die UI-Mods an
  `__active_mods` an, die Game-Mods stehen dort schon.
- Hook auf `tabs.lua` statt `gamemain.lua`: `tabs.OnPause` wird von `gamemain.OnPause`
  und `gamemain.OnResume` aufgerufen (Z. 750-775), `Create` beim Aufbau des Spiel-UI
  (`gamemain.lua` Z. 249). Ein Hook deckt alles ab.

## 4. Abhaengigkeiten und Konflikte

- **`requires` / `conflicts` / `before` / `after`:** -
- **`UI-Party`** (LOUD `loud_misc.scd`) hookt `tabs.lua` nur `OnGameOver` - vertraeglich.
- **`pauseReplayAtTime`** (LOUD `loud_misc.scd`) ruft `SessionResume` nur im Replay -
  dort greift der Mod nicht.
- Andere Mods, die `_G.SessionResume` ersetzen: keine gefunden (`loud_misc.scd`,
  `usermods`).

## 5. Performance

Nur waehrend einer offenen Abfrage: `OnFrame` des Fensters, Abfrage von
`GetSessionClients`/`GetArmiesTable` alle 0,5 s. Ausserhalb der Pause kein Aufwand.

## 6. Multiplayer

- Alle Spieler brauchen den Mod: ja (Lobby erzwingt ihn).
- Determinismus: kein Sim-Code; Abgleich nur ueber Session-Nachrichten.

## 7. Tests

| Datum | Was getestet | Ergebnis |
|---|---|---|
| - | Testanleitung unten | offen |

Testanleitung (2 Spieler, Original-LOUD):

1. LAN-/Direct-IP-Lobby mit 2 Spielern, Host aktiviert "Enhanced Pause Behavior"
   (Gast braucht den Mod, sonst Fehlmeldung der Lobby); optional eine KI dazu.
2. Partie starten, A pausiert (Pause-Reiter oben oder Taste `Pause`).
3. B drueckt erneut Pause (fortsetzen): Spiel bleibt pausiert, beide sehen
   "Resume Game?", B "ready", A "waiting", KI nicht in der Liste.
4. A wartet: kein Countdown.
5. A klickt "Ready": bei beiden "Resuming in 5 ... 1", dann laeuft das Spiel, Fenster zu.
6. Neu pausieren und anfragen, beide bereit, im Countdown bei A "Stop" oder `Pause`:
   Countdown stoppt bei beiden ("Countdown stopped by A"), Spiel bleibt pausiert.
7. "Cancel": Fenster schliesst bei beiden, Meldung "Resume cancelled by ...".
8. `LOUD\bin\LOUD.log` auf Fehler mit `readycheck` / `enhancedpausebehavior` pruefen.

## 8. Bekannte Probleme / offene Punkte

Ungeprueft, in `TODO.md` eingetragen:

- [ ] Exe: `SessionSendChatMessage` wird waehrend der Pause zugestellt (FAF-Doku:
      getrennt von der Simulation; nicht im LOUD-Spiel beobachtet).
- [ ] Exe: ein Spieler kann die Pause eines anderen fortsetzen (abgeleitet aus FAF
      `pause.lua`, das dies erst per Lua beschraenkt).
- [ ] Exe: ob der Absender die eigene Nachricht zurueckbekommt. Der Mod verarbeitet sie
      lokal sofort und verwirft das Echo - beides funktioniert.
- [ ] SupComNet: ob im Mehrspieler `gamemain.OnResume` feuert (Rueckfall vorhanden).

SupComNet bindet alle verwendeten Funktionen (`SupComNet.Game\Scenes\BattleScene.LuaUi.cs`,
`BattleScene.Chat.cs`). Abweichung ohne Folgen fuer den Mod: Beobachter haben dort eine
nicht-leere `authorizedCommandSources` in `GetSessionClients`.

## 9. Referenzen

- `LOUD\gamedata\lua.scd` -> `lua/ui/game/tabs.lua` (Pause-Reiter, `TogglePause`, `OnPause`)
- `LOUD\gamedata\lua.scd` -> `lua/ui/game/gamemain.lua` Z. 748-800, 1084-1096
- `LOUD\gamedata\lua.scd` -> `lua/ui/dialogs/disconnect.lua` (Rahmen `CreateBorder`, Clientliste)
- `LOUD\gamedata\lua.scd` -> `lua/ui/game/chat.lua` `FindClients` Z. 536-574
- `LOUD\gamedata\lua.scd` -> `lua/UserSync.lua` Z. 173-188, `lua/SessionInit.lua` Z. 15-18
- `LOUD\gamedata\lua.scd` -> `lua/ui/lobby/lobby.lua` Z. 679-711
- `Repos\FAF\lua\ui\game\pause.lua`, `Repos\FAF\engine\User.lua` Z. 1126-1144
- Vorbilder ohne Gegenstueck: LOUD hat weder Lobby-Start-Countdown noch Bereit-Abfrage im Spiel.
