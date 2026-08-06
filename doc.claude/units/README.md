# units\ - Detaildaten zu Einheiten

**Index dieses Ordners.** Der Einstieg liegt eine Ebene hoeher:
[../17_UNITLISTE.md](../17_UNITLISTE.md).

---

## Die drei Kategorien

Massgeblich ist der **Ablageort des Blueprints**, nicht das ID-Praefix:

| Kategorie | Ablageort | Einheiten | Datei |
|---|---|---:|---|
| basegame | `gamedata.entpackt\units\units\` | 425 | [basegame.md](basegame.md) |
| mod | `gamedata.entpackt\<Archiv>\...` | 668 | [mods.md](mods.md), [pakete.md](pakete.md), [loud_misc.md](loud_misc.md) |
| usermod | `usermods\<Mod>\...` | 218 | [usermods.md](usermods.md) |
| **Gesamt** | | **1311** | |

Die ID-Systematik ist eine **Lesehilfe, kein Ordnungsmerkmal**: `UAB8765` und `XSB8765`
tragen Basisspiel-Praefixe, liegen aber in `LOUD Unit Additions`; umgekehrt liegen 13
Eintraege mit `B`/`D`/`S`-Praefix im Basisverzeichnis.

---

## Dateien

| Datei | Inhalt | IDs geprueft | Namen |
|---|---|---|---|
| [basegame.md](basegame.md) | Paket `units`, 425 Blueprints | ja | 421 von 425 |
| [mods.md](mods.md) | Uebersicht der 18 Erweiterungspakete, 668 | ja | - |
| [pakete.md](pakete.md) | Index ueber die Paketdateien | ja | - |
| [brewlan.md](brewlan.md) | BrewLAN, 209 Einheiten | ja | ja |
| [blackops.md](blackops.md) | BlackOpsUnleashed, 86 | ja | ja |
| [loud_misc.md](loud_misc.md) | LOUD-eigene Mods, 136 | ja | ja |
| [civ_units.md](civ_units.md) | Zivileinheiten, 100 | ja | ja |
| [totalmayhem.md](totalmayhem.md) | TotalMayhem, 62 | ja | ja |
| [kleinpakete.md](kleinpakete.md) | LOUD Unit Additions, BattlePack, 4DC, BlackopsACUs, 75 | ja | ja |
| [usermods.md](usermods.md) | eigene Mods, 218 Blueprints | ja | ja |
| [ueberschreibungen.md](ueberschreibungen.md) | 187 mehrfach belegte IDs | ja | - |
| [_generiert\](_generiert/) | Skriptausgabe, Rohdaten | ja | ja |
| `<UNITID>.md` | Einzeleinheit, volle Blueprint-Analyse | nach Bedarf | |
| [_VORLAGE.md](_VORLAGE.md) | Kopiervorlage fuer Einzeleinheiten | - | |

**Alle 1311 Einheiten sind erfasst, benannt und gegen das Dateisystem geprueft.**

### WICHTIG: Zaehlweise

Alle Dateien zaehlen jetzt einheitlich **`*_unit.bp`-Dateien, rekursiv** - so wie das
Skript. Die fruehere Zaehlweise "Ordner unter `units\`" ergab 1175 und hatte zwei blinde
Flecken: sie uebersah Blueprints ausserhalb von `units\`-Ordnern (und damit das gesamte
Archiv `loud_misc` mit 136 Einheiten) und zaehlte leere Ordner mit.

Einzelheiten: [_generiert\README.md](_generiert/README.md)

---

## Prinzip: Index oben, Details unten

```
17_UNITLISTE.md          Einstieg - Kategorien, Bestand, ID-Systematik
  |
  +-- units\README.md    dieser Index
        |
        +-- <kategorie>.md   alle IDs der Kategorie
        +-- <UNITID>.md      Einzeleinheit - Werte, Waffen, Abhaengigkeiten
```

Wer eine ID sucht, geht Einstieg -> Kategoriedatei -> ggf. Einzeldatei. So bleibt jede
Ebene klein genug, um sie ganz zu lesen.

## Formatregeln

1. **Kein Zeichen ausserhalb von ASCII.** Keine Emoji, keine Pfeile, keine Umlaute -
   `ae`, `oe`, `ue`, `ss` ausschreiben. Pruefen mit
   `grep -P '[^\x00-\x7F]' <datei>.md` (darf nichts liefern).
2. **Tabellen einspaltig** - eine Zeile pro Einheit. Zweispaltige Tabellen der Form
   `| ID | Name | ID | Name |` sind verboten: beim Entfernen einer Zeile verrutscht die
   zweite Spalte. Genau so gingen am 2026-08-05 drei Eintraege verloren.
3. **Ueberschreibungen als eigene Spalte**, nicht als Symbol. Der Modname sagt, wer
   ersetzt; ein Zeichen sagt das nicht.
4. **Zeilen maschinell erzeugen**, nicht abtippen. Verzeichnisliste, Lokalisierung und
   Ueberschreibungsliste zusammenfuehren und als Markdown ausgeben.
5. **Jede Datei beginnt mit Rueckverweisen** auf `../17_UNITLISTE.md` und diese Datei.
6. **Jede Unit-ID in Backticks** - so ist sie dateiuebergreifend auffindbar.
   **Keine Bereichsschreibweise** wie "XEC8001 bis XEC8020": wer nach einer einzelnen ID
   sucht, findet sie sonst nicht. Auch 40 gleichnamige Mauersegmente werden einzeln
   aufgefuehrt.
7. **Keine Daten doppelt fuehren.** Wandert Inhalt in eine Detaildatei, verschwindet er
   aus der uebergeordneten und wird nur noch verlinkt.
8. **Vollstaendige Pfade** zu Blueprint- und Lokalisierungsdateien
   (`../07_KONVENTIONEN.md` Abschnitt 7).

9. **Unit-IDs sind case-insensitiv.** Vor jedem Vergleich auf Grossschreibung
   normalisieren - 24 IDs kommen im Bestand in beiden Schreibweisen vor
   ([ueberschreibungen.md](ueberschreibungen.md)).
10. **Rekursiv suchen, nicht nur `units\`-Ordner auflisten.** Blueprints liegen auch
   ausserhalb, und ganze Archive koennen sonst durchrutschen - so wurde `loud_misc`
   mit 136 Einheiten uebersehen.

## Namenskonvention

| Ebene | Dateiname |
|---|---|
| Kategorie basegame | `basegame.md` |
| Kategorie mod | `mods.md` (Uebersicht), `pakete.md` (Index), dann je Paket |
| Kategorie usermod | `usermods.md` |
| Einzeleinheit | `<UNITID>.md` in Grossbuchstaben, z. B. `UEL0001.md` |
| Querschnittsthema | sprechender Name, z. B. `ueberschreibungen.md` |

Wird eine Paketdatei zu gross, wird sie aufgeteilt (`blackops.md`, `brewlan.md` ...) und
dieser Index angepasst.

## Pflicht: Zaehlung pruefen

Nach jeder Aenderung an einer Einheitentabelle **alle drei** Pruefungen laufen lassen.

### 1. IDs gegen `_generiert\units.csv`

```bash
grep -oE '`[A-Za-z][A-Za-z0-9_]{4,}`' datei.md | tr -d '`' | sort -u > ids.txt
comm -23 ids.txt soll.txt    # in der Doku, nicht in den Daten -> erfunden
comm -13 ids.txt soll.txt    # in den Daten, nicht in der Doku -> fehlt
```

IDs, die nur im Fliesstext erwaehnt werden, tauchen als "erfunden" auf. Meist harmlos -
aber jeden Treffer einzeln ansehen, nicht pauschal abtun.

### 2. Abschnittszahlen gegen Tabellenzeilen

Die Zahl in einer Ueberschrift wie "Aeon (28)" wird von Hand gesetzt und verrutscht
leicht. **Nur Zeilen zaehlen, die mit einer ID in Backticks beginnen** - sonst zaehlen
Erwaehnungen im Fliesstext mit und erzeugen Fehlalarme.

```python
import re
row  = re.compile(r'^\|\s*`([A-Za-z][A-Za-z0-9_]{4,})`')
head = re.compile(r'^(#+)\s+(.*)$')
cnt  = re.compile(r'\((\d+)\)')
for f in ["basegame","brewlan","blackops","loud_misc",
          "civ_units","totalmayhem","kleinpakete","usermods"]:
    cur=None; k=None; n=0
    for line in open(f+".md", encoding="utf-8"):
        m = head.match(line)
        if m:
            if cur and k is not None and n>0 and n!=k:
                print(f"{f}: {cur} Kopf:{k} Zeilen:{n}")
            cur=m.group(2); c=cnt.search(cur)
            k=int(c.group(1)) if c else None; n=0
        elif row.match(line): n+=1
```

### 3. Sonderzeichen

```bash
grep -P '[^\x00-\x7F]' datei.md   # darf nichts liefern
```

### Erfahrung

Am 2026-08-06 lief die Pruefung ueber alle acht Paketdateien und fand vier Fehler, die
beim Lesen unsichtbar geblieben waren:

| Datei | Fehler |
|---|---|
| `blackops.md` | Kopfzahl UEF 14 statt 15 |
| `blackops.md` | Kopfzahl Seraphim 32 statt 31 |
| `civ_units.md` | Fraktionszahlen UEF 52 statt 49, Cybran 46 statt 47 |
| `civ_units.md` | 62 IDs nur als Bereich notiert - nicht auffindbar |

Der letzte Punkt ist der schwerste: **Bereichsschreibweise bricht Regel 6.** Wer nach
`XRC8107` sucht, findet nichts.

**Stand nach der Korrektur:** alle acht Dateien ohne Abweichung zwischen Kopfzahl und
Tabellenzeilen, ohne Sonderzeichen, vollstaendig gegen `_generiert\units.csv`
abgeglichen - 1311 Einheiten.

**Offen:** neun Einheiten ohne Namenseintrag (`UAM0004` `UEM0006` `URM0004` `XSM0001`
`SAB1312` `SRB1312` `ZZZ2220` `ZZZ2402` `ZZZ5301`).

## Abgrenzung

- **Generierte Dateien** aus `../tools/Get-Units.ps1` liegen in
  [_generiert\](_generiert/) und werden bei jedem Lauf ueberschrieben. Was hier liegt,
  ist von Hand gepflegt.
- **Mod-Dokumentation** - was ein Mod tut, warum, mit welchen Risiken - gehoert nach
  `../mods/<modname>.md`. Hier stehen nur Einheitendaten.

## Wichtig

**Auf der Platte vorhanden ist nicht gleich im Spiel geladen.** Blueprints eines Mods
werden nur eingelesen, wenn der Mod in der Partie aktiv ist (`../02_MODSYSTEM.md`
Abschnitt 4). Daran ist eine fruehere Fehldiagnose gescheitert (`../15_LOG.md` R-01).
