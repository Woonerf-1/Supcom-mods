# referenz\ — Verbatim-Kopien wichtiger Originaldateien

Ort: `LOUD\usermods\doc.claude\referenz\`

Diese Dateien sind **Lesekopien** aus Bereichen außerhalb der Schreibzone.
Sie dienen dem Vergleich und der Nachvollziehbarkeit.

> Diese Kopien werden von Claude **nicht** zurückgespielt. `LOUD\bin\` ist keine Schreibzone.
> Wenn dort etwas geändert werden soll, macht das der Nutzer bewusst und selbst.

| Kopie | Original | Stand | Dokumentiert in |
|---|---|---|---|
| `LoudDataPath.lua.txt` | `LOUD\bin\LoudDataPath.lua` (LOUD-Original) | 2026-08-05 | `..\11_DATAPATH.md` §1 |
| `CommonDataPath.lua.txt` | `LOUD\bin\CommonDataPath.lua` | 2026-08-05 | `..\11_DATAPATH.md` §2–3 |

Die Endung `.txt` ist Absicht: so kann keine dieser Dateien versehentlich als Lua
ausgeführt oder von einem Werkzeug für eine echte Skriptdatei gehalten werden.

---

## Welche Variante liegt gerade in `bin\`?

Es gibt zwei legitime Zustände. Beide sind gewollt — welcher richtig ist, hängt davon ab,
ob Nomads gespielt werden soll.

| | LOUD-Original | Nomads-Variante |
|---|---|---|
| Zeile mit `mount_nomads.lua` | nein | **ja** |
| `mount_contents(...)` für *Eigene Dateien* | auskommentiert | **aktiv** |
| Strategiesymbole | aus `bin\...SMALL-classic.scd` | aus `usermods\BrewLAN-StrategicIcons*.scd` |
| Nomads spielbar | nein | ja |

Quelle der Nomads-Variante: `usermods\nomads-4-loud\LoudDataPath.lua`
Installation: `usermods\nomads-4-loud\CopyLoudDataPath.bat` (vom Nutzer auszuführen)

---

## ⚠️ Nach jedem LOUD-Update

`LOUD\bin\` wird vom LOUD-Team gepflegt und beim Update zurückgesetzt. Wer Nomads nutzt,
muss `CopyLoudDataPath.bat` danach **erneut** ausführen — sonst fehlen die Nomads-Einheiten
stillschweigend, ohne Eintrag im Log.

Ebenfalls nach jedem Update fällig: `gamedata.entpackt\` neu erzeugen, sonst arbeiten wir
gegen veralteten Referenzcode. Prüfverfahren in `..\01_ARCHITEKTUR.md` §2.

Diese Referenzkopien sind dann ebenfalls veraltet und sollten neu gezogen werden.
