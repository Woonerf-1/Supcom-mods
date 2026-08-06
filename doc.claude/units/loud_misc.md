# Paket `loud_misc` - LOUD-eigene Mods

Zurueck: [README.md](README.md) - [mods.md](mods.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)
Verwandt: [basegame.md](basegame.md) - [pakete.md](pakete.md) - [ueberschreibungen.md](ueberschreibungen.md)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\loud_misc\mods\<Mod>\units\
```

**136 Einheiten in fuenf Mods.** `loud_misc.scd` enthaelt insgesamt 24 LOUD-eigene Mods
(`../02_MODSYSTEM.md` Abschnitt 6.5); nur diese fuenf bringen Einheiten mit.

> Dieses Archiv war in der Handerhebung vom 05.08. **vollstaendig uebersehen** worden.
> Erfasst durch den Skriptlauf vom 06.08. (`_generiert\units.csv`).

---

## Ein anderer Modtyp

Wo BrewLAN und Total Mayhem Einheiten **hinzufuegen**, **veraendern** diese fuenf
bestehende:

| Mod | Einheiten | davon Ersatz | Anteil |
|---|---:|---:|---:|
| [LOUD Integrated Storage](#loud-integrated-storage) | 84 | 56 | 67 % |
| [ZLOUD Structure Enhancements](#zloud-structure-enhancements) | 36 | 32 | 89 % |
| [Enhanced Nukes](#enhanced-nukes) | 8 | 8 | 100 % |
| [Artillery](#artillery) | 4 | 4 | 100 % |
| [Enhanced Commanders](#enhanced-commanders) | 4 | 4 | 100 % |
| **Summe** | **136** | **104** | 76 % |

Fuer diesen Typ ist Ersetzen die **Arbeitsweise, kein Mangel** - ein Lager laesst sich
nur ueber den Blueprint in ein bestehendes Gebaeude einbauen.

**Konsequenz fuer eigene Mods:** Wer ein Basisgebaeude anfasst, konkurriert
moeglicherweise mit `LOUD Integrated Storage`. Vor jeder Blueprint-Aenderung in
[ueberschreibungen.md](ueberschreibungen.md) nachsehen.

Spalte "Auch in": weitere Ablageorte derselben ID. `-` heisst: nur hier.

---

## LOUD Integrated Storage

84 Einheiten, 56 davon Ersatz. Baut Lager in bestehende Gebaeude ein und ergaenzt
Kombinationsvarianten (`*1304` bis `*1306`, `*4303`).

Muster je Fraktion: die Basisgebaeude `1103`-`1106`, `1201`-`1202`, `1301`-`1303` und
`4301` werden ersetzt; dazu kommen neue Kombinationsgebaeude.

| ID | Name | Auch in |
|---|---|---|
| `UAB1103` | - | basegame |
| `UAB1104` | - | basegame |
| `UAB1105` | - | basegame |
| `UAB1106` | - | basegame |
| `UAB1107` | Mass Fabricator & Storage | - |
| `UAB1201` | - | basegame |
| `UAB1202` | - | basegame |
| `UAB1203` | Improved Power Generator & Storage | - |
| `UAB1301` | - | basegame |
| `UAB1302` | - | basegame, UEF_trans_men |
| `UAB1303` | - | basegame |
| `UAB1304` | Advanced Mass Extractor & Storage | - |
| `UAB1305` | Adv. Mass Fabricator & Storage | - |
| `UAB1306` | Adv. Power Generator & Storage | - |
| `UAB4301` | - | basegame |
| `UAB4303` | Radiance | - |
| `UAB8765` | - | LOUD Unit Additions |
| `UABSSG01` | - | LOUD Unit Additions, UEF_trans_men |
| `UEB1103` | - | basegame |
| `UEB1104` | - | basegame |
| `UEB1105` | - | basegame |
| `UEB1106` | - | basegame |
| `UEB1107` | Mass Fabricator & Storage | - |
| `UEB1201` | - | basegame |
| `UEB1202` | - | basegame |
| `UEB1203` | Improved Power Generator & Storage | - |
| `UEB1301` | - | basegame |
| `UEB1302` | - | basegame, UEF_trans_men |
| `UEB1303` | - | basegame |
| `UEB1304` | Advanced Mass Extractor & Storage | - |
| `UEB1305` | Adv. Mass Fabricator & Storage | - |
| `UEB1306` | Adv. Power Generator & Storage | - |
| `UEB4301` | - | basegame |
| `UEB4303` | HSD Pulse | - |
| `UEB8765` | - | LOUD Unit Additions |
| `UEBSSG01` | - | LOUD Unit Additions, UEF_trans_men |
| `URB1103` | - | basegame |
| `URB1104` | - | basegame |
| `URB1105` | - | basegame |
| `URB1106` | - | basegame |
| `URB1107` | Mass Fabricator & Storage | - |
| `URB1201` | - | basegame |
| `URB1202` | - | basegame |
| `URB1203` | Improved Power Generator & Storage | - |
| `URB1301` | - | basegame |
| `URB1302` | - | basegame, UEF_trans_men |
| `URB1303` | - | basegame |
| `URB1304` | Advanced Mass Extractor & Storage | - |
| `URB1305` | Adv. Mass Fabricator & Storage | - |
| `URB1306` | Adv. Power Generator & Storage | - |
| `URB4207` | - | basegame |
| `URB4303` | ED5+ | - |
| `URB8765` | - | LOUD Unit Additions |
| `URBSSG01` | - | LOUD Unit Additions, UEF_trans_men |
| `XSB1103` | - | basegame |
| `XSB1104` | - | basegame |
| `XSB1105` | - | basegame |
| `XSB1106` | - | basegame |
| `XSB1107` | Mass Fabricator & Storage | - |
| `XSB1201` | - | basegame |
| `XSB1202` | - | basegame |
| `XSB1203` | Improved Power Generator & Storage | - |
| `XSB1301` | - | basegame |
| `XSB1302` | - | basegame, UEF_trans_men |
| `XSB1303` | - | basegame |
| `XSB1304` | Advanced Mass Extractor & Storage | - |
| `XSB1305` | Adv. Mass Fabricator & Storage | - |
| `XSB1306` | Adv. Power Generator & Storage | - |
| `XSB4301` | - | basegame |
| `XSB4303` | Heavy Shield Generator & Storage | - |
| `XSB8765` | - | LOUD Unit Additions |
| `XSBSSG01` | - | LOUD Unit Additions, UEF_trans_men |
| `BAB1106` | - | BlackOpsUnleashed |
| `BAB1302` | - | BlackOpsUnleashed, UEF_trans_men |
| `BAB1304` | Adv. Hydrocarbon Plant & Storage | - |
| `BEB1106` | - | BlackOpsUnleashed |
| `BEB1302` | - | BlackOpsUnleashed, UEF_trans_men |
| `BEB1304` | HCPP - X3000 | - |
| `BRB1106` | - | BlackOpsUnleashed |
| `BRB1302` | - | BlackOpsUnleashed, UEF_trans_men |
| `BRB1304` | Advanced Hydrocarbon Power Plant & Storage | - |
| `BSB1106` | - | BlackOpsUnleashed |
| `BSB1302` | - | BlackOpsUnleashed, UEF_trans_men |
| `BSB1304` | Uya-atoh | - |

Der Mod greift auch in **BlackOps** und **LOUD Unit Additions** ein - nicht nur ins
Basisspiel. Acht IDs sind dreifach belegt (mit `UEF_trans_men`).

---

## ZLOUD Structure Enhancements

36 Einheiten, 32 davon Ersatz. Vier neue Gebaeude, der Rest sind Ueberschreibungen.

| ID | Name | Auch in |
|---|---|---|
| `UAB3304` | - | basegame |
| `UAB4203` | - | basegame |
| `UAB4304` | Shador | - |
| `UEB3304` | - | basegame |
| `UEB4203` | - | basegame |
| `UEB4304` | Obfuscator | - |
| `URB3304` | - | basegame |
| `URB4203` | - | basegame, UEF_trans_men |
| `URB4304` | BlackOut | - |
| `XSB3304` | - | basegame |
| `XSB4203` | - | basegame |
| `XSB4304` | Ultha Sele-ioz | - |

### Achtung: 24 IDs in Kleinschreibung

Die uebrigen 24 Blueprints tragen **kleingeschriebene** Ordner- und Dateinamen:

`uab0301` `uab0302` `uab0303` `uab2204` `uab2304` `uab5202`
`ueb0301` `ueb0302` `ueb0303` `ueb2204` `ueb2304` `ueb5202`
`urb0301` `urb0302` `urb0303` `urb2204` `urb2304` `urb5202`
`xsb0301` `xsb0302` `xsb0303` `xsb2204` `xsb2304` `xsb5202`

**Es sind dieselben Blueprints wie die gleichnamigen Grossbuchstaben-IDs im Basisspiel.**
Blueprint-IDs sind case-insensitiv - die Engine behandelt `uab0301` und `UAB0301` als
eine Einheit. Wer beim Vergleichen die Schreibweise nicht normalisiert, uebersieht diese
24 Ueberschreibungen. Genau das ist bei der ersten Auswertung passiert.

Betroffen sind je Fraktion die drei Fabriken (`0301`-`0303`), die Flugabwehr (`2204`),
die Artillerie (`2304`) und die Reparaturplattform (`5202`).

---

## Enhanced Nukes

8 Einheiten, **alle Ersatz**. Nuklearwaffen und Abwehr.

| ID | Name | Auch in |
|---|---|---|
| `UAB2305` | - | basegame |
| `UAS0304` | - | basegame, UEF_trans_men |
| `UEB2305` | - | basegame |
| `UES0304` | - | basegame, UEF_trans_men |
| `URB2305` | - | basegame |
| `URS0304` | - | basegame, UEF_trans_men |
| `XSB2305` | - | basegame |
| `XSB2401` | - | basegame |

Die drei U-Boot-IDs (`*S0304`) sind dreifach belegt - basegame, `Enhanced Nukes` und
`UEF_trans_men`.

---

## Artillery

4 Einheiten, **alle Ersatz**. Experimentalartillerie.

| ID | Name | Auch in | Original |
|---|---|---|---|
| `UEB2401` | - | basegame | Mavor |
| `URL0401` | - | basegame | Scathis |
| `XAB2307` | - | basegame | Salvation |
| `SSB2404` | - | BrewLAN_LOUD | - |

Der einzige Fall, in dem ein `loud_misc`-Mod ein **BrewLAN**-Blueprint ersetzt.

---

## Enhanced Commanders

4 Einheiten, **alle Ersatz** - die vier alternativen ACUs aus `BlackopsACUs`.

| ID | Name | Auch in |
|---|---|---|
| `EAL0001` | - | BlackopsACUs |
| `EEL0001` | - | BlackopsACUs |
| `ERL0001` | - | BlackopsACUs |
| `ESL0001` | - | BlackopsACUs |

Damit gibt es fuer diese vier IDs drei Fassungen im Spiel: `BlackopsACUs`,
`Enhanced Commanders` - und bei aktivem `usermods\commanders` zusaetzlich dessen
Basisspiel-ACUs unter anderen IDs.

---

## Pruefstand

| Was | Stand |
|---|---|
| Bestand | geprueft 2026-08-06 aus `_generiert\units.csv` |
| Kollisionen | case-insensitiv gerechnet |
| Namen | aus `UnitName` im Blueprint; ueberschreibende Blueprints tragen meist keinen |
| Die uebrigen 19 Mods in `loud_misc` | ohne Einheiten - nur Hooks, UI und Skripte |
