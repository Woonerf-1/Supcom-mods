# units\ - Detaildaten zu Einheiten

**Index dieses Ordners.** Der Einstieg liegt eine Ebene hoeher:
[../17_UNITLISTE.md](../17_UNITLISTE.md).

---

## Die drei Kategorien

Massgeblich ist der **Ablageort des Blueprints**, nicht das ID-Praefix:

| Kategorie | Ablageort | Einheiten | Datei |
|---|---|---:|---|
| basegame | `gamedata.entpackt\units\units\` | 432 | [basegame.md](basegame.md) |
| mod | `gamedata.entpackt\<Archiv>\...\units\` | 525 | [mods.md](mods.md) -> [pakete.md](pakete.md) |
| usermod | `usermods\<Mod>\units\` | 218 | [usermods.md](usermods.md) |
| **Gesamt** | | **1175** | |

Die ID-Systematik ist eine **Lesehilfe, kein Ordnungsmerkmal**: `UAB8765` und `XSB8765`
tragen Basisspiel-Praefixe, liegen aber in `LOUD Unit Additions`; umgekehrt liegen 13
Eintraege mit `B`/`D`/`S`-Praefix im Basisverzeichnis.

---

## Dateien

| Datei | Inhalt | IDs geprueft | Namen |
|---|---|---|---|
| [basegame.md](basegame.md) | Paket `units`, 432 Einheiten | ja | 391 von 432 |
| [mods.md](mods.md) | Uebersicht der 13 Erweiterungspakete, 525 | ja | - |
| [pakete.md](pakete.md) | Detaillisten je Paket | ja | offen |
| [usermods.md](usermods.md) | eigene Mods, 218 Einheiten | ja | teilweise |
| [ueberschreibungen.md](ueberschreibungen.md) | 99 mehrfach belegte IDs | ja | - |
| `<UNITID>.md` | Einzeleinheit, volle Blueprint-Analyse | nach Bedarf | |
| [_VORLAGE.md](_VORLAGE.md) | Kopiervorlage fuer Einzeleinheiten | - | |

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
7. **Keine Daten doppelt fuehren.** Wandert Inhalt in eine Detaildatei, verschwindet er
   aus der uebergeordneten und wird nur noch verlinkt.
8. **Vollstaendige Pfade** zu Blueprint- und Lokalisierungsdateien
   (`../07_KONVENTIONEN.md` Abschnitt 7).

## Namenskonvention

| Ebene | Dateiname |
|---|---|
| Kategorie basegame | `basegame.md` |
| Kategorie mod | `mods.md` plus `pakete.md` |
| Kategorie usermod | `usermods.md` |
| Einzeleinheit | `<UNITID>.md` in Grossbuchstaben, z. B. `UEL0001.md` |
| Querschnittsthema | sprechender Name, z. B. `ueberschreibungen.md` |

Wird eine Paketdatei zu gross, wird sie aufgeteilt (`blackops.md`, `brewlan.md` ...) und
dieser Index angepasst.

## Pflicht: Zaehlung pruefen

Nach jeder Aenderung an einer Einheitentabelle die Eintraege gegen die Kopfangabe pruefen
und die Summe gegen das Dateisystem. Verfahren: Datei in die Analyseumgebung kopieren,
Verzeichnisliste danebenlegen, dann

```bash
grep -oE '`[A-Za-z]{3}[0-9]{4}`' datei.md | tr -d '`' | sort -u > ids.txt
comm -23 ids.txt real.txt    # in der Doku, aber nicht auf Platte -> erfunden
comm -13 ids.txt real.txt    # auf Platte, aber nicht erfasst -> fehlt
grep -P '[^\x00-\x7F]' datei.md   # Sonderzeichen
```

So wurde am 2026-08-05 bestaetigt, dass alle 19 Ablageorte vollstaendig erfasst sind:
432 basegame + 525 mod + 218 usermod = 1175 Blueprint-Ordner, 1075 verschiedene IDs,
99 davon mehrfach belegt. Keine erfundene ID, keine fehlende, reines ASCII.

**Offen:** Namen der mod-Pakete und von `UEF_trans_men`.

## Abgrenzung

- **Generierte Dateien** aus `../tools/Get-Units.ps1` gehoeren nach `units\_generiert\`,
  nicht hierher. Was hier liegt, ist von Hand gepflegt.
- **Mod-Dokumentation** - was ein Mod tut, warum, mit welchen Risiken - gehoert nach
  `../mods/<modname>.md`. Hier stehen nur Einheitendaten.

## Wichtig

**Auf der Platte vorhanden ist nicht gleich im Spiel geladen.** Blueprints eines Mods
werden nur eingelesen, wenn der Mod in der Partie aktiv ist (`../02_MODSYSTEM.md`
Abschnitt 4). Daran ist eine fruehere Fehldiagnose gescheitert (`../15_LOG.md` R-01).
