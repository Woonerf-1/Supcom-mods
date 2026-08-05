# tools\ — Hilfsmittel für die Arbeitsumgebung

Ort: `LOUD\usermods\doc.claude\tools\`

Werkzeuge und Systemeinstellungen, die das Modding erleichtern.
**Kein Mod** — nichts hier wird vom Spiel geladen.

Ausführliche Doku: [`..\14_TOOLS.md`](../14_TOOLS.md)

---

## Inhalt

| Datei | Zweck | Rechte |
|---|---|---|
| `scd_als_ordner_an.reg` | `.scd` im Explorer als gepackten Ordner anzeigen | nur aktueller Benutzer, **keine Adminrechte** |
| `scd_als_ordner_aus.reg` | dasselbe rückgängig machen | nur aktueller Benutzer |
| `scd_als_ordner_an_systemweit.reg` | Variante für alle Benutzer | **Adminrechte nötig** |

---

## Warum das nützlich ist

`.scd`-Dateien sind umbenannte ZIP-Archive. Mit dem Registry-Eintrag öffnet ein
Doppelklick in `LOUD\gamedata\` direkt den Archivinhalt — praktisch zum schnellen
Nachsehen, ohne erst alles nach `gamedata.entpackt\` auszupacken.

**Ersetzt `gamedata.entpackt\` nicht.** Für Volltextsuche über die Spieldaten bleibt der
entpackte Ordner das Mittel der Wahl; der Explorer kann nicht in Archiven suchen.

## Anwendung

Doppelklick auf die `.reg`-Datei, Rückfrage bestätigen. Neu angemeldete Explorer-Fenster
zeigen die Änderung sofort; sonst hilft ein Neustart des Explorers.

Falls Regedit die Datei ablehnt (Zeilenenden), geht es auch ohne `.reg`:

```cmd
reg add    "HKCU\Software\Classes\.scd" /ve /d CompressedFolder /f
reg delete "HKCU\Software\Classes\.scd" /f
```

## ⚠️ Hinweis zu `.sca`

Die ursprüngliche Vorlage enthielt zusätzlich einen Eintrag für `.sca`.
**Der ist hier bewusst nicht übernommen** — `.sca` sind Animationsdateien, keine Archive.
Geprüft: die Datei beginnt mit der Kennung `ANIM`, nicht mit `PK`.

Begründung und Details in `..\14_TOOLS.md`.
