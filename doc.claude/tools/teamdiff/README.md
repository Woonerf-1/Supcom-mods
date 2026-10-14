# tools\teamdiff - Team-PDF "Unsere Mods - was sich geaendert hat"

Erzeugt `doc.claude\team\LOUD-Mods_Aenderungen.pdf`: je Mod und Einheit eine Tabelle
**Original (LOUD) | Colin (`UEF_trans_men`) | Aktuell (unser Mod)**, menschenlesbar
(Klartext-Feldnamen, Einheitennamen). Wunsch Paul, 2026-10-14.

## Aufruf

```
powershell -File "LOUD\usermods\doc.claude\tools\teamdiff\build.ps1" -Stand 14.10.2026
```

Schreibt nur nach `doc.claude\team\` (PDF) und nach `%TEMP%\loud_teamdiff\` (JSON, HTML,
Edge-Profil). Braucht Microsoft Edge (Druck per `--headless --print-to-pdf`).

## Dateien

| Datei | Rolle |
|---|---|
| `build.ps1` | ruft das Datenskript, setzt JSON und Datum in die Vorlage, druckt per Edge |
| `teamdiff_data.ps1` | liest die Blueprints als Feldpfad -> Wert; Original = Fund in `gamedata.entpackt` (Basisspiel bevorzugt), Colin = `UEF_trans_men\units\<ID>`, Aktuell = unser Mod, bei Merge Original + Merge-Felder |
| `teamdiff.html` | Vorlage: Feldnamen-Uebersetzung, Texte je Mod ("Ausserhalb der Werte"), offene Einheiten, Layout |

## Regeln der Darstellung

- Ausgeblendet: reine Pfadumschreibungen (`/mods/<x>/`), Grafik-, Ton-, Modell- und
  Knochenfelder (Anzahl je Einheit wird genannt).
- Listen (Kategorien, Faehigkeiten, Zielprioritaeten) als `+`/`-` gegenueber dem Original.
- Gelb: Colin != Original. Gruen mit Stern: Aktuell != Colin (unsere Entscheidung).
- IHPP: die Hook-Werte (`hook\lua\system\Blueprints.lua`) sind im Datenskript nachgetragen,
  weil sie nicht in den Blueprints stehen. Aendert sich der Hook, dort nachziehen.
- Script- und Regel-Aenderungen stehen nicht in den Blueprints - sie sind von Hand in
  `teamdiff.html` (`MODS[...].notes`) gepflegt. **Bei jeder Mod-Aenderung mitpflegen.**

## Grenzen

- Der Blueprint-Leser ist zeilenbasiert (wie `bpmerge.ps1`); mehrere Felder in einer Zeile
  werden nur bei einfachen Tabellen `X = { a = 1, b = 2 }` aufgeloest.
- Einheiten ohne LOUD-Original zeigen nur Eckwerte (Kosten, Leben, Produktion).
