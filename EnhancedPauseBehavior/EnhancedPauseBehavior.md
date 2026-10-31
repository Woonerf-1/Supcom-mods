# EnhancedPauseBehavior

Stand: 2026-10-31. Im Spiel ungeprueft.

## Was

Mehrspieler: Wer eine Pause beenden will, setzt das Spiel nicht sofort fort. Alle
menschlichen Spieler bekommen ein Fenster "Spiel fortsetzen?" mit Namensliste
(bereit / wartet). Sind alle bereit, laeuft ein Countdown (5 s), danach geht es
fuer alle weiter.

- Pause-Knopf: LOUD hat bereits einen (dritter Reiter oben in der Menueleiste,
  Taste `Pause`). Der Mod nutzt diesen Knopf, er baut keinen zweiten.
- Zaehlen nur: verbundene Clients, deren Befehlsquelle eine Armee mit
  `human = true` und `outOfGame = false` fuehrt. Beobachter, KI und
  ausgeschiedene Spieler zaehlen nicht. Beobachter sehen das Fenster ohne Knoepfe.
- Sonst unveraendert (direktes Fortsetzen wie LOUD): Einzelspieler, Replay,
  Spielende, nur ein menschlicher Spieler.

## Ablauf

| Schritt | Wer | Nachricht |
|---|---|---|
| Fortsetzen gedrueckt (Knopf oder Taste) | Anfragender, gilt als bereit | `request` |
| "Bereit" / "Nicht bereit" | jeder Spieler | `ready` |
| alle Teilnehmer bereit | nur der Anfragende entscheidet | `go` |
| Countdown abgelaufen | nur der Anfragende ruft `SessionResume()` | - |
| "Abbrechen" | jeder Spieler | `cancel` |

Sonderfaelle:

- **Erneut pausieren waehrend Abfrage oder Countdown** (Pause-Knopf, Taste
  `Pause`, "Stopp"): nimmt das eigene Bereit zurueck. Ein laufender Countdown
  stoppt bei allen, die Abfrage bleibt offen. Das Spiel war und bleibt pausiert.
- **Verbindungsverlust eines Spielers:** er zaehlt nicht mehr. Waehrend des
  Countdowns startet der Countdown neu (Hinweis im Fenster).
- **Verbindungsverlust des Anfragenden:** Abfrage endet, Spiel bleibt pausiert,
  jeder kann neu anfragen.
- **Zwei Anfragen gleichzeitig:** es gilt auf allen Rechnern die mit dem
  niedrigeren Client-Index; wer schon bereit war, wird uebernommen.
- **Spiel laeuft wieder / Spielende:** Fenster schliesst.
- Kein automatisches Fortsetzen nach Zeit (siehe offene Fragen).

## Abgleichweg: Session-Nachrichten

`SessionSendChatMessage` (an alle Clients), Empfang ueber
`gamemain.lua RegisterChatFunc(func, 'EnhancedPauseBehavior')`.

Begruendung:

- Die Nachrichten laufen neben der Simulation, nicht durch den Befehlsstrom und
  nicht ins Replay (FAF-Annotation `Repos\FAF\engine\User.lua` Z. 1139). Damit
  kann der Mod den Sim-Zustand nicht veraendern - kein Desync-Risiko.
- `SimCallback`/Sync scheiden aus: SimCallbacks sind Befehle im Befehlsstrom und
  werden an Sim-Ticks ausgefuehrt; waehrend der Pause tickt die Sim nicht.
  Ausserdem wuerde jeder Bereit-Klick Sim-Code und Replay beruehren.
- Spielwirksam sind nur `SessionResume()` (ein einziger Aufruf durch den
  Anfragenden) und `SessionRequestPause()` (unveraendert) - die
  Engine-Funktionen, die der LOUD-Pause-Knopf ohnehin nutzt.

`ui_only = false` nur, damit die Lobby den Mod fuer alle erzwingt
(`lobby.lua` `CheckIfHaveMods`, Z. 679-711). Sim-Dateien enthaelt er nicht.
Hooks von Game-Mods greifen auch im UI-State: `SessionInit.lua` Z. 15-18 haengt
die UI-Mods an `__active_mods` an, die Game-Mods stehen dort schon.

## Dateien

| Datei | Mechanismus | Original |
|---|---|---|
| `mod_info.lua` | - | - |
| `hook\lua\ui\game\tabs.lua` | Hook auf `Create`, `CommonLogic`, `OnPause` | `LOUD\gamedata\lua.scd` -> `lua/ui/game/tabs.lua` Z. 358, 412-497, 741-768 |
| `modules\readycheck.lua` | eigenes Modul; ersetzt `_G.SessionResume` und `_G.SessionRequestPause` durch Huellen (Muster aus FAF `lua/ui/game/pause.lua`) | - |

Verwendete Engine-Funktionen (UI-State): `SessionResume`, `SessionRequestPause`,
`SessionIsPaused`, `SessionIsMultiplayer`, `SessionIsReplay`,
`SessionIsGameOver`, `SessionSendChatMessage`, `GetSessionClients`,
`GetArmiesTable`, `GetFrame`, `PlaySound`, `print`. Alle im LOUD-UI-Lua in
Gebrauch (`tabs.lua`, `chat.lua`, `disconnect.lua`, `UserSync.lua`).

## Vorbilder

- LOUD `lua/ui/game/tabs.lua`: Pause-Knopf, Taste `pause` (`keymap/keyactions.lua` Z. 12).
- LOUD `lua/ui/dialogs/disconnect.lua`: Fensterrahmen (`CreateBorder` wird
  wiederverwendet), Clientliste, `OnFrame`-Takt.
- FAF `lua/ui/game/pause.lua`: Huelle um `SessionResume` (dort: Fortsetzen erst
  nach 10 s, nur Chat-Hinweis - keine Bereit-Abfrage).
- LOUD hat weder Lobby-Start-Countdown noch Bereit-Abfrage im Spiel.

## Konflikte

- `UI-Party` (LOUD `loud_misc.scd`) hookt `tabs.lua` nur `OnGameOver` - vertraeglich.
- `pauseReplayAtTime` ruft `SessionResume` nur im Replay - dort greift der Mod nicht.
- Andere Mods, die `_G.SessionResume` ersetzen: keine gefunden.

## Ungeprueft (Testlauf noetig)

1. Exe: `SessionSendChatMessage` wird waehrend der Pause zugestellt. Erwartet
   (FAF-Doku: getrennt von der Simulation), nicht im LOUD-Spiel beobachtet.
2. Exe: ein Spieler kann eine Pause eines anderen fortsetzen. Abgeleitet aus
   FAF `pause.lua` (beschraenkt das erst per Lua), nicht beobachtet.
3. Exe: ob der Absender seine eigene Nachricht zurueckbekommt. Der Mod
   verarbeitet sie lokal sofort und verwirft das Echo - beides funktioniert.
4. SupComNet: ob im Mehrspieler `gamemain.OnResume` feuert. Rueckfall: das
   Fenster schliesst sich spaetestens 3 s nach Spielfortsetzung ueber
   `SessionIsPaused()`.

Diese Punkte gehoeren nach `doc.claude\TODO.md` (Auftrag erlaubte nur Schreiben
im Mod-Ordner).
