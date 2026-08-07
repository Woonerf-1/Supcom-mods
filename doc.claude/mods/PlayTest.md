# Mod: PlayTest

| | |
|---|---|
| **Ordner** | `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\PlayTest\` |
| **VFS-Pfad** | `/mods/playtest/` |
| **uid** | `3786F645-B959-44F1-9C52-E3B3C5CA09AA` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Status** | **Vorlage - ohne Inhalt** |
| **Angelegt** | 2026-08-06 |

---

## 1. Zweck

Testmod zum Ausprobieren - Werte, Mechanismen, Verfahren. **Nicht fuer den regulaeren
Spielbetrieb.**

Der Nachfolger von `test21000` aus dem eingefrorenen Bestand, aber sauber gebaut:
Merge statt Vollersatz, keine Asset-Kopien.

## 2. Umsetzung

Noch nichts umgesetzt. Je nach Testfall:

```
PlayTest\
├── mod_info.lua
├── units\<ID>\<ID>_unit.bp        Merge-Blueprints fuer Wertetests
└── hook\lua\sim\Unit.lua          fuer Verhaltenstests
```

**Immer `Merge = true`.** Was hier entsteht, ist zum Wegwerfen gedacht - ein
Vollersatz mit Asset-Kopien waere doppelt verschwendet. Referenz, wie es nicht geht:
`test21000` aendert acht Felder und liefert dafuer ein 1283-Zeilen-Blueprint plus
16 unveraenderte Asset-Kopien (`..\08_BESTANDSAUFNAHME.md`).

## 3. Abhaengigkeiten und Konflikte

- **`requires`:** keine
- **`conflicts`:** keine
- **`before` / `after`:** keine

**Wenn dieser Mod gezielt einen anderen ueberschreiben soll**, ist `after` noetig -
`requires` allein regelt keine Reihenfolge (`..\02_MODSYSTEM.md` Abschnitt 5).
Das ist bislang nur aus dem Code gelesen, nicht praktisch geprueft.

## 4. Performance

Testcode darf teuer sein - aber nichts davon wandert in einen produktiven Mod.

## 5. Multiplayer

- Alle Spieler brauchen den Mod: **ja** (Sim-Mod)
- **Vor einer Partie mit anderen abschalten.** Ein Testmod, der bei einem Mitspieler
  fehlt, fuehrt zu Desync oder Startfehlern.

## 6. Tests

| Datum | Was getestet | Ergebnis |
|---|---|---|
| | Mod erscheint im Mod-Manager | offen |

Log-Praefix fuer eigene Ausgaben: `PLAYTEST:`

## 7. Offene Punkte

- [ ] Kein Icon hinterlegt - es gilt das generische Standardsymbol.
- [ ] Ueberlegen, ob `enabled = false` der bessere Standard waere - dann taucht der Mod
      gar nicht erst im Mod-Manager auf und wird nicht versehentlich mitgestartet.
      Dagegen spricht: zum Testen muss er jedes Mal von Hand eingeschaltet werden.

## 8. Verwendung als Pruefstand

Offene Fragen aus `..\TODO.md`, die sich hier klaeren lassen:

- **Wirkt `before`/`after` wie gelesen?** Zwei Mods, die dasselbe Blueprint-Feld
  unterschiedlich setzen, mit und ohne `after` starten.
- **Wer gewinnt bei mehrfach belegten IDs?**
- **`ModBlueprints`-Hookpfad:** `hook\lua\system\` gegen `hook\system\`.
- **`/schook` gegen mod-eigenes `hook\`** - Reihenfolge der Ausfuehrung.

## 9. Quellen

Noch keine.
