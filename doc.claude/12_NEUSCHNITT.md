# 12 — Neuschnitt der Mods

**Status: Zuschnitt festgelegt (2026-08-06), Vorlagen angelegt, noch ohne Inhalt.**

Alles in `usermods\` gehört uns — unabhängig davon, welcher Autor in einer `mod_info.lua`
steht. Es gibt hier keine fremden Besitzstände.

Der vorhandene Bestand ist **eingefroren** (Stand 2026-08-05). Er wird nicht repariert,
sondern **abgelöst**: alles wird neu gedacht und in neuen Mods umgesetzt.

---

## 1. Was „eingefroren" bedeutet

- Die sieben bestehenden Ordner werden **nicht mehr verändert** — weder repariert noch
  aufgeräumt. Jede Stunde dort wäre in Material investiert, das ohnehin abgelöst wird.
- Sie bleiben als **Vergleichsstand** liegen, bis der Ersatz steht und getestet ist.
- Abschalten ja (`enabled = false` oder Mod-Manager), überschreiben nein, löschen nein.
- Bestandsaufnahme mit allen Befunden: `08_BESTANDSAUFNAHME.md`.

---

## 2. Befunde aus dem Bestand

Nicht als Mängelliste zum Abarbeiten, sondern als **Lehren für den Neubau**:

| Befund | Wo beobachtet | Konsequenz für neue Mods |
|---|---|---|
| Vollersatz statt Merge | `test21000`, `commanders` | Merge als Standard; Vollersatz nur begründet |
| Unveränderte Asset-Kopien | `test21000` (16 Dateien) | wer Zahlen ändert, liefert keine Meshes mit |
| Doppelbelegung `UEL0001` | `commanders` + `test21000` | ein Anliegen pro Mod, Blueprint-IDs koordinieren |
| uids ohne GUID-Charakter | 5 von 7 | frische GUIDs; sie steuern nebenbei die Ladereihenfolge |
| Keine `requires`/`conflicts` | alle | Abhängigkeiten explizit machen |
| O(n) pro Bauauftrag | `EscalatingBuildCosts` | Zähler cachen statt iterieren |
| Tote Felder `mountpoints`/`hooks` | `nomads-4-loud`, `commanders` | weglassen, wirkungslos (`11_DATAPATH.md` §2) |
| Falsche Asset-Pfade | `AcidPools`, `commanders` | Pfade gegen die reale Mountstruktur prüfen |

### Referenzmessung `test21000`

Diff gegen das Original: **8 geänderte Felder, alle in `Economy`** — ausgeliefert als
1283-Zeilen-Blueprint plus 16 unveränderte Asset-Kopien.

| Feld | Original | test21000 |
|---|---|---|
| `BuildRate` | 10 | 1000 |
| `MaxBuildDistance` | 10 | 100 |
| `ProductionPerSecondEnergy` | 20 | 1 000 000 |
| `ProductionPerSecondMass` | 2 | 10 000 |
| `StorageEnergy` | 5000 | 4000 |
| `BuildableCategory` | 4 × `BUILTBY*COMMANDER UEF` | `UEF`, `AEON`, `SERAPHIM`, `CYBRAN`, `NOMADS` |

Als Merge-Blueprint: **~12 Zeilen, null Assets** — und LOUD-Update-fest, statt die neue
Original-Version zu verdecken.

Das Verfahren dahinter ist für den Neuschnitt allgemein nützlich: beide Blueprints in die
Analyseumgebung kopieren, `diff` laufen lassen. Bei `test21000` waren so in einem Schritt
8 relevante von 1283 Zeilen gefunden.

---

## 3. Zuschnitt

**Festgelegt am 2026-08-06.** Drei Mods, **ohne Abhaengigkeiten untereinander**.

| Mod | Ordner | uid | Anliegen |
|---|---|---|---|
| Basegame Bugfixes | `usermods\BasegameBugfixes\` | `EFD7502E-1682-4DC2-BBA7-CC4243E74B71` | Fehler in Basiseinheiten beheben |
| T4 Mass Extractors | `usermods\T4MassExtractors\` | `F778CB9A-FA72-413F-99A1-80AE74CFE37B` | Massextraktoren der Experimental-Stufe |
| PlayTest | `usermods\PlayTest\` | `3786F645-B959-44F1-9C52-E3B3C5CA09AA` | Testmod, nicht fuer den Spielbetrieb |

Angelegt als **leere Vorlagen** - jeweils nur `mod_info.lua`, noch ohne Inhalt.
Je ein Dokument unter `mods\`:
[BasegameBugfixes.md](mods/BasegameBugfixes.md) -
[T4MassExtractors.md](mods/T4MassExtractors.md) -
[PlayTest.md](mods/PlayTest.md)

### Warum ohne Abhaengigkeiten

Jeder Mod ist fuer sich aktivierbar und ergibt fuer sich Sinn - das war Regel 1 aus
Abschnitt 4. Keine `requires`, keine `before`/`after`.

Das bedeutet auch: **die Ladereihenfolge zwischen ihnen ist nicht festgelegt.** Solange
sie keine gemeinsamen Blueprint-IDs anfassen, spielt das keine Rolle. Sobald doch,
muss `after` gesetzt werden - `requires` genuegt dafuer nicht
(`02_MODSYSTEM.md` Abschnitt 5).

### Verhaeltnis zum eingefrorenen Bestand

| Neuer Mod | loest ab |
|---|---|
| `PlayTest` | `test21000` |
| `BasegameBugfixes` | - |
| `T4MassExtractors` | - |

Die uebrigen eingefrorenen Mods (`AcidPools`, `commanders`, `nomads-4-loud`,
`NOMADS-try_b4_ur_BI`, `UEF_trans_men`) haben noch keinen Nachfolger. Ob sie einen
bekommen, ist offen - **nichts auf Verdacht nachbauen** (Abschnitt 6).

---

## 4. Regeln für jeden neuen Mod

Gelten unabhängig vom Zuschnitt:

1. **Ein Mod = ein abschaltbares Anliegen.** Muss allein aktivierbar sein und für sich
   Sinn ergeben.
2. **Merge vor Vollersatz.** Vollersatz nur, wenn strukturell nötig — und begründet.
3. **Keine unveränderten Asset-Kopien.**
4. **Frische GUID** (`07_KONVENTIONEN.md` §2), eingetragen in `08_BESTANDSAUFNAHME.md`.
5. **`requires` / `conflicts` ausfüllen**, wo Abhängigkeiten oder Kollisionen bestehen.
6. **Keine `mountpoints`/`hooks`-Felder** — wirkungslos.
7. **Eigenes Dokument** `doc.claude\mods\<name>.md` (Vorlage: `mods\_VORLAGE.md`).
8. **Log-Präfix** pro Mod, damit Ausgaben im `LOUD.log` auffindbar sind.

---

## 5. Vorgehen pro Mod

```
1. ZIEL KLÄREN         Was soll im Spiel passieren? (Nutzer legt fest)
2. VERORTEN            Zuständige Originaldatei in gamedata.entpackt lesen.
3. MINIMUM BESTIMMEN   Welche Felder/Funktionen ändern sich tatsächlich?
                       Bei Blueprints: gegen das Original diffen.
4. NEU BAUEN           Neuer Ordner, Merge/Hook, nur das Nötige.
5. DOKUMENTIEREN       mods\<name>.md + CHANGELOG.md
6. GEGENTESTEN         Alten Mod deaktivieren, neuen aktivieren, Verhalten vergleichen.
7. ALT MARKIEREN       In 08_BESTANDSAUFNAHME.md als „ersetzt durch <name>" vermerken.
                       Ordner bleibt liegen.
```

---

## 6. Was dieser Neuschnitt nicht ist

- **Keine Balance-Diskussion.** Erst Struktur, dann Werte.
- **Kein Löschen.** Der eingefrorene Bestand bleibt, bis der Ersatz getestet ist.
- **Keine Pflicht zur Vollständigkeit.** Nicht alles muss ein Nachfolgemod bekommen.
