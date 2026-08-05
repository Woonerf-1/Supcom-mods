# Mod: <Modname>

> Kopiervorlage. Für jeden selbst gebauten Mod eine Kopie als `<Modname>.md` anlegen und
> **gleichzeitig mit dem Code** pflegen — nicht nachträglich.

| | |
|---|---|
| **Ordner** | `usermods\<Modname>\` |
| **VFS-Pfad** | `/mods/<modname>/` |
| **uid** | `00000000-0000-0000-0000-000000000000` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) / UI-Mod (`ui_only = true`) |
| **Status** | Entwurf / getestet / stabil |
| **Angelegt** | JJJJ-MM-TT |
| **Zuletzt geändert** | JJJJ-MM-TT |

---

## 1. Zweck

Was ändert sich aus Sicht des Spielers? Zwei bis drei Sätze, ohne Technik.

## 2. Umsetzung

| Mechanismus | Datei im Mod | Wirkt auf (VFS) | Original in `gamedata.entpackt` |
|---|---|---|---|
| Hook | `hook\lua\sim\Unit.lua` | `/lua/sim/Unit.lua` | `lua\lua\sim\Unit.lua` |
| Merge | `units\uel0001\UEL0001_unit.bp` | Blueprint `uel0001` | `units\units\UEL0001\UEL0001_unit.bp` |

### Geänderte Funktionen / Felder

| Was | Original | Neu | Begründung |
|---|---|---|---|
| `Unit:OnStartBuild` | — | erweitert | ... |
| `Defense.Health` | 12000 | 15000 | ... |

## 3. Warum dieser Eingriffspunkt

Kurz begründen, warum Hook statt Merge (oder umgekehrt).
**Bei `shadow\`: hier zwingend begründen** — plus LOUD-Versionsstand notieren, da die Datei
bei jedem LOUD-Update neu abgeglichen werden muss.

## 4. Abhängigkeiten und Konflikte

- **`requires`:** —
- **`conflicts`:** —
- **`before` / `after`:** —
- **Bekannte Wechselwirkungen:** z. B. mit `nomads-4-loud` (nutzt `shadow`), mit anderen
  Mods, die dieselbe Datei hooken oder dasselbe Blueprint anfassen.

## 5. Performance

Läuft der Code in häufig aufgerufenen Funktionen (`OnDamage`, `OnStartBuild`, Threads)?
Aufwand pro Aufruf? Was wurde dagegen getan?

## 6. Multiplayer

- Alle Spieler brauchen den Mod: ja / nein
- Determinismus geprüft (kein `math.random`, keine Systemzeit, kein UI-Zugriff): ja / nein

## 7. Tests

| Datum | Was getestet | Ergebnis |
|---|---|---|
| JJJJ-MM-TT | Mod erscheint im Mod-Manager | ok |
| JJJJ-MM-TT | Wirkung im Skirmish gegen KI | ... |
| JJJJ-MM-TT | `LOUD.log` ohne neue `warning:`/`error:` | ... |

Log-Präfix dieses Mods: `<MODNAME>:`

## 8. Bekannte Probleme / offene Punkte

- [ ] ...

## 9. Referenzen

Gelesene Originaldateien, auf denen die Umsetzung beruht:

- `gamedata.entpackt\...`
