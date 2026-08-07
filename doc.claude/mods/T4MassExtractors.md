# Mod: T4 Mass Extractors

| | |
|---|---|
| **Ordner** | `C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\T4MassExtractors\` |
| **VFS-Pfad** | `/mods/t4massextractors/` |
| **uid** | `F778CB9A-FA72-413F-99A1-80AE74CFE37B` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Status** | **Vorlage - ohne Inhalt** |
| **Angelegt** | 2026-08-06 |

---

## 1. Zweck

Fuegt Massextraktoren der Experimental-Stufe hinzu - eine Ausbaustufe oberhalb der
vorhandenen T3-Extraktoren.

**Noch nicht befuellt.**

## 2. Umsetzung

Noch nichts umgesetzt. Erwarteter Aufbau:

```
T4MassExtractors\
├── mod_info.lua
├── icons\units\<id>_icon.dds     optional, wird automatisch gefunden
└── units\<NEUEID>\
    ├── <NEUEID>_unit.bp
    ├── <NEUEID>_script.lua
    └── Meshes, Texturen
```

**Neue Einheiten, kein Merge.** Verfahren in `..\03_BLUEPRINTS.md` Abschnitt 6.

### Ausgangsmaterial

Die vorhandenen Extraktoren je Fraktion, als Vorlage zum Kopieren:

| Stufe | Aeon | UEF | Cybran | Seraphim |
|---|---|---|---|---|
| T1 | `UAB1103` | `UEB1103` | `URB1103` | `XSB1103` |
| T2 | `UAB1202` | `UEB1202` | `URB1202` | `XSB1202` |
| T3 | `UAB1302` | `UEB1302` | `URB1302` | `XSB1302` |

**Alle zwoelf werden bereits von `LOUD Integrated Storage` ersetzt**, die T3-Varianten
zusaetzlich von `UEF_trans_men` (`..\units\ueberschreibungen.md`). Als Kopiervorlage ist
das unerheblich - relevant nur, falls spaeter doch ein Merge auf eine dieser IDs
gebraucht wird.

### Freie IDs

Nach der Systematik `[Set][Fraktion][Domaene][Nummer]` waeren `*B1402` naheliegend
(analog zu `1103`/`1202`/`1302`). **Vor Vergabe pruefen**, ob die ID frei ist -
`..\17_UNITLISTE.md` und `..\units\`.

Freie Set-Praefixe fuer voellig neue IDs: `F` `G` `H` `I` `J` `K` `P` `Q` `T` `Y`.

### Baubarkeit

Eine neue Einheit muss in der `BuildableCategory` eines Bauers landen, sonst ist sie
nicht baubar. Verfahren ungeklaert - LOUDs Mechanismus in
`gamedata.entpackt\lua\lua\CustomUnits\LOUD_Buildings.lua` ist noch nicht gelesen
(`..\TODO.md`).

## 3. Abhaengigkeiten und Konflikte

- **`requires`:** keine
- **`conflicts`:** keine
- **`before` / `after`:** keine

Neue IDs kollidieren per Definition mit nichts - solange sie wirklich neu sind.

## 4. Performance

Neue Gebaeude ohne eigene Logik kosten nichts Besonderes. Bei einem eigenen
`_script.lua` mit Thread hier den Aufwand vermerken.

## 5. Multiplayer

- Alle Spieler brauchen den Mod: **ja** (Sim-Mod, neue Einheiten)
- Determinismus: bei reinen Blueprints kein Thema

## 6. Tests

| Datum | Was getestet | Ergebnis |
|---|---|---|
| | Mod erscheint im Mod-Manager | offen |
| | Einheit ist baubar | offen |
| | Modell und Symbol werden angezeigt | offen |

Log-Praefix fuer eigene Ausgaben: `T4MEX:`

## 7. Offene Punkte

- [ ] Kein Icon hinterlegt - es gilt das generische Standardsymbol.
- [ ] Vier Fraktionen oder nur eine? Vorlage-Einheiten festlegen.
- [ ] ID-Schema festlegen und Freiheit pruefen
- [ ] Baubarkeit klaeren (`LOUD_Buildings.lua` lesen)
- [ ] Werte festlegen: Ertrag, Kosten, Bauzeit, Lebenspunkte

## 8. Quellen

Noch keine.
