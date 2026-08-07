# Mod: Basegame Bugfixes

| | |
|---|---|
| **Ordner** | `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\BasegameBugfixes\` |
| **VFS-Pfad** | `/mods/basegamebugfixes/` |
| **uid** | `EFD7502E-1682-4DC2-BBA7-CC4243E74B71` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Status** | **Vorlage - ohne Inhalt** |
| **Angelegt** | 2026-08-06 |

---

## 1. Zweck

Behebt Fehler in den Basiseinheiten des Spiels - Blueprints aus
`gamedata.entpackt\units\units\`.

**Noch nicht befuellt.** Was als Fehler gilt und was als Balance-Aenderung, ist noch
festzulegen.

## 2. Umsetzung

Noch nichts umgesetzt. Erwarteter Aufbau:

```
BasegameBugfixes\
├── mod_info.lua
└── units\<ID>\<ID>_unit.bp     Merge-Blueprints, siehe 03_BLUEPRINTS.md
```

**Merge, nicht Vollersatz.** Fuer Fehlerbehebungen an Basiseinheiten ist
`Merge = true` der richtige Weg: nur die betroffenen Felder werden geaendert, der Rest
bleibt beim LOUD-Stand und ueberlebt Updates.

## 3. Abhaengigkeiten und Konflikte

- **`requires`:** keine
- **`conflicts`:** keine
- **`before` / `after`:** keine

**Zu beachten:** 120 der 425 Basiseinheiten werden bereits von anderen Mods ersetzt
(`..\units\ueberschreibungen.md`). Vor jeder Aenderung dort nachsehen - bei einer
mehrfach belegten ID kann diese Fassung von einem spaeter angewandten Mod verdeckt
werden. `Merge = true` schuetzt davor **nicht**.

Wichtigste Konkurrenten bei Basiseinheiten:

| Mod | ersetzt basegame | auf dieser Installation aktiv |
|---|---:|---|
| `LOUD Integrated Storage` | 40 | nein |
| `ZLOUD Structure Enhancements` | 32 | nicht geprueft |
| `UEF_trans_men` | 39 | eingefroren |
| `Enhanced Nukes` | 8 | nicht geprueft |

## 4. Performance

Blueprint-Merges kosten zur Laufzeit nichts. Sollte spaeter ein Hook dazukommen, hier
den Aufwand pro Aufruf vermerken.

## 5. Multiplayer

- Alle Spieler brauchen den Mod: **ja** (Sim-Mod)
- Determinismus: bei reinen Blueprint-Merges kein Thema

## 6. Tests

| Datum | Was getestet | Ergebnis |
|---|---|---|
| | Mod erscheint im Mod-Manager | offen |

Log-Praefix fuer eigene Ausgaben: `BUGFIX:`

## 7. Offene Punkte

- [ ] Kein Icon hinterlegt - es gilt das generische Standardsymbol. Falls gewuenscht:
      `icons\basegamebugfixes.bmp` anlegen und `icon` in `mod_info.lua` setzen.
- [ ] Fehlerliste zusammenstellen: was soll behoben werden?
- [ ] Abgrenzung zu Balance-Aenderungen festlegen

## 8. Quellen

Noch keine.
