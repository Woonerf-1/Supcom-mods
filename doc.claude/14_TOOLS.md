# 14 — Tools

Der Ordner `usermods\doc.claude\tools\` sammelt Hilfsmittel für die Arbeitsumgebung:
Registry-Einstellungen, Skripte, Konvertierungshelfer.

**Kein Mod.** Nichts darin wird vom Spiel geladen — es gibt keine `mod_info.lua`.
Durch die Lage unterhalb von `doc.claude\` taucht der Ordner auch nicht als eigener
Mountpunkt im `LOUD.log` auf (siehe §3).

---

## 1. `.scd` als gepackten Ordner anzeigen

### Zweck

`.scd`-Dateien sind umbenannte ZIP-Archive (`01_ARCHITEKTUR.md` §2). Ohne Zuordnung
kennt der Explorer sie nicht. Mit dem Registry-Eintrag `CompressedFolder` öffnet ein
Doppelklick in `LOUD\gamedata\` direkt den Archivinhalt.

Praktisch, um schnell nachzusehen, was in einem Archiv steckt — etwa nach einem
LOUD-Update, wenn `gamedata.entpackt\` noch nicht neu gezogen ist.

**Kein Ersatz für `gamedata.entpackt\`.** Der Explorer kann nicht in Archiven suchen,
und bei den großen Paketen (`units.scd` 306 MB, `brewlan.scd` 200 MB) ist er zäh.
Für die eigentliche Referenzarbeit bleibt der entpackte Ordner das Mittel der Wahl.

### Dateien

| Datei | Registry-Zweig | Rechte |
|---|---|---|
| `scd_als_ordner_an.reg` | `HKEY_CURRENT_USER\Software\Classes\.scd` | keine Adminrechte |
| `scd_als_ordner_aus.reg` | löscht denselben Schlüssel | keine Adminrechte |
| `scd_als_ordner_an_systemweit.reg` | `HKEY_CLASSES_ROOT\.scd` | **Adminrechte** |

**Empfehlung: die HKCU-Variante.** Sie wirkt für den angemeldeten Benutzer, braucht keine
erhöhten Rechte und lässt sich sauber zurücknehmen. `HKEY_CLASSES_ROOT` ist eine
Verschmelzung aus `HKLM\Software\Classes` und `HKCU\Software\Classes`; Schreibvorgänge
landen in HKLM und überschreiben eine eventuell vorhandene systemweite Zuordnung.

### Anwendung

Doppelklick, Rückfrage bestätigen. Falls Regedit die Datei wegen der Zeilenenden ablehnt,
tut es auch die Kommandozeile:

```cmd
reg add    "HKCU\Software\Classes\.scd" /ve /d CompressedFolder /f
reg delete "HKCU\Software\Classes\.scd" /f
```

### ⚠️ Warum `.sca` nicht dabei ist

Die eingereichte Vorlage enthielt zusätzlich:

```
[HKEY_CLASSES_ROOT\.sca]
@="CompressedFolder"
```

**Das ist nicht korrekt.** `.sca` sind Supreme-Commander-Animationen, keine Archive.
Nachgeprüft an `gamedata.entpackt\units\units\UEL0001\UEL0001_A001.sca`:

```
Magic Bytes:  41 4E 49 4D   →  "ANIM"
ZIP wäre:     50 4B 03 04   →  "PK.."
unzip-Test:   "End-of-central-directory signature not found"
```

Folge der Zuordnung wäre: Doppelklick auf eine `.sca` öffnet den ZIP-Handler des
Explorers, der dann eine Fehlermeldung zeigt. Kein Schaden, aber auch kein Nutzen —
und eine Fehlerquelle bei der Suche nach echten Problemen.

**Welche SupCom-Formate sind tatsächlich ZIP:**

| Endung | ZIP? | Was es ist |
|---|---|---|
| `.scd` | ✅ ja | Spieldaten-Archiv (teils unkomprimiert, `method=store`) |
| `.sca` | ❌ nein | Animation, Magic `ANIM` |
| `.scm` | ❌ nein | Mesh |
| `.bp` | ❌ nein | Blueprint, reiner Lua-Text |
| `.dds` | ❌ nein | Textur |
| `.xwb` / `.xsb` | ❌ nein | XACT Wave/Sound Bank |

Wer den `.sca`-Eintrag trotzdem will, kann ihn jederzeit ergänzen — die Begründung
gegen ihn steht hier.

---

## 2. Regeln für `tools\`

1. **Nichts darin wird vom Spiel geladen.** Keine `mod_info.lua` anlegen, sonst
   erscheint der Ordner als Mod im Mod-Manager.
2. **Systemändernde Skripte führt der Nutzer aus**, nicht Claude
   (`CLAUDE.md` Regel 2). Claude schreibt sie und erklärt, was sie tun.
3. **Zu jedem Eingriff gehört die Rücknahme.** Wer eine `.reg` zum Setzen anlegt, legt
   auch die zum Entfernen an.
4. **Keine Zugangsdaten**, keine Token, keine Passwörter — der Ordner liegt im
   Git-Repository (`13_GIT.md` §1).
5. **Kommentare in `.reg`-Dateien ohne Umlaute.** Die Kodierung von `.reg` ist heikel;
   reines ASCII vermeidet Ärger.

---

## 3. Keine Nebenwirkung im Spiel

`mount_mods()` mountet nur die **direkten** Unterordner von `usermods\`. Da `tools\`
innerhalb von `doc.claude\` liegt, entsteht kein eigener Mountpunkt — der Inhalt landet
lediglich als Teil von `/mods/doc.claude/tools/` im VFS.

Gelesen wird davon nichts: ohne `mod_info.lua` registriert die Engine keinen Mod, und
`.reg`- und `.md`-Dateien wertet sie ohnehin nie aus.
Siehe `01_ARCHITEKTUR.md` §4 und `11_DATAPATH.md` §2.
