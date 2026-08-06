# Paket `civ_units` - Zivileinheiten

Zurueck: [README.md](README.md) - [pakete.md](pakete.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\civ_units\units\
```

**100 Einheiten, keine einzige mehrfach belegt.** Ein reines Inhaltspaket - es ersetzt
nichts und wird von nichts ersetzt.

Stand 2026-08-06 aus `_generiert\units.csv`, gegen die CSV verifiziert.

| Fraktion | Gebaeude | Mauersegmente | Summe |
|---|---:|---:|---:|
| Aeon | 1 | 0 | 1 |
| UEF | 18 | 31 | 49 |
| Cybran | 7 | 40 | 47 |
| Seraphim | 2 | 1 | 3 |
| **Summe** | **28** | **72** | **100** |

Das **3. Zeichen `C` steht fuer Civilian**, nicht fuer eine Domaene. Das Verzeichnis
enthaelt 117 Unterordner; 17 davon haben kein `_unit.bp` und sind keine Einheiten -
darunter die fuenf Strassenobjekte `UEF_Bus`, `UEF_Car1`, `UEF_Fence`,
`UEF_Streetlight_01`, `UEF_truck`.

**72 der 100 Einheiten sind Mauersegmente.** Sie tragen denselben Namen und unterscheiden
sich vermutlich nur im Modell - ungeprueft.

---

## Aeon (1)

| ID | Name |
|---|---|
| `UAC1301` | Aeon Civilian Structure |

---

## UEF (49)

### Gebaeude und Objekte (18)

| ID | Name |
|---|---|
| `UEC0001` | UEF Civilian Truck |
| `UEC1101` | UEF Residential Building |
| `UEC1201` | UEF Science Lab |
| `UEC1301` | UEF Administrative Building |
| `UEC1401` | UEF Agricultural Center |
| `UEC1501` | UEF Manufacturing Facility |
| `UEC1901` | UEF Black Sun |
| `UEC1902` | UEF Black Sun Control Center |
| `UEC1903` | UEF Black Sun Support |
| `UEC1904` | UEF Black Sun Tower |
| `UEC1905` | UEF Black Sun Crane |
| `UEC1906` | UEF Black Sun Crane |
| `UEC1907` | UEF Black Sun Building |
| `XEC1301` | UEF Administration Building |
| `XEC1401` | UEF High Command Building |
| `XEC1501` | UEF Samantha Clarke Statue |
| `XEC1908` | UEF Blacksun Remains #1 |
| `XEC1909` | UEF Blacksun Remains #2 |

### Mauersegmente (31)

Alle tragen den Namen *UEF Wall Segment*:

`XEC8001` `XEC8002` `XEC8003` `XEC8004` `XEC8005` `XEC8006` `XEC8007` `XEC8008`
`XEC8009` `XEC8010` `XEC8011` `XEC8012` `XEC8013` `XEC8014` `XEC8015` `XEC8016`
`XEC8017` `XEC8018` `XEC8019` `XEC8020`
`XEC9001` `XEC9002` `XEC9003` `XEC9004` `XEC9005` `XEC9006` `XEC9007` `XEC9008`
`XEC9009` `XEC9010` `XEC9011`

---

## Cybran (47)

### Gebaeude (7)

| ID | Name |
|---|---|
| `URC1902` | Cybran Civilian Structure |
| `XRC1101` | QAI Jamming Station |
| `XRC1502` | Cybran Civilian Structure |
| `XRC2101` | QAI Prison Building |
| `XRC2201` | QAI Mainframe |
| `XRC2301` | QAI Node |
| `XRC2401` | QAI Spire Node |

### Mauersegmente (40)

Alle tragen den Namen *Cybran Wall Segment*, mit zwei Ausnahmen:
`XRC8016` heisst *Cybran Wall Endcap Segment*, und bei `XRC8014` steht im Blueprint eine
ueberzaehlige Klammer: *Cybran Wall Segment)*.

`XRC8001` `XRC8002` `XRC8003` `XRC8004` `XRC8005` `XRC8006` `XRC8007` `XRC8008`
`XRC8009` `XRC8010` `XRC8011` `XRC8012` `XRC8013` `XRC8014` `XRC8015` `XRC8016`
`XRC8017` `XRC8018` `XRC8019` `XRC8020`
`XRC8101` `XRC8102` `XRC8103` `XRC8104` `XRC8105` `XRC8106` `XRC8107` `XRC8108`
`XRC8109` `XRC8110` `XRC8111` `XRC8112` `XRC8113` `XRC8114` `XRC8115` `XRC8116`
`XRC8117` `XRC8118` `XRC8119` `XRC8120`

---

## Seraphim (3)

| ID | Name |
|---|---|
| `XSC1301` | Seraphim Administrative Building |
| `XSC8001` | Seraphim Wall Segment |
| `XSC9002` | Jammer Crystal |

---

## Bemerkenswert: der Kampagnen-Bestand

Das Paket enthaelt die Bauwerke aus der Supreme-Commander-Kampagne, allen voran
**Black Sun** und die **QAI**-Anlagen:

| ID | Name |
|---|---|
| `UEC1901` | UEF Black Sun |
| `UEC1902` | UEF Black Sun Control Center |
| `UEC1903` | UEF Black Sun Support |
| `UEC1904` | UEF Black Sun Tower |
| `UEC1905` | UEF Black Sun Crane |
| `UEC1906` | UEF Black Sun Crane |
| `UEC1907` | UEF Black Sun Building |
| `XEC1908` | UEF Blacksun Remains #1 |
| `XEC1909` | UEF Blacksun Remains #2 |
| `XRC1101` | QAI Jamming Station |
| `XRC2101` | QAI Prison Building |
| `XRC2201` | QAI Mainframe |
| `XRC2301` | QAI Node |
| `XRC2401` | QAI Spire Node |
| `XEC1501` | UEF Samantha Clarke Statue |

---

## Auffaelligkeiten

**Ein Tippfehler im Original:** `XRC8014` traegt den Namen *Cybran Wall Segment)* mit
schliessender Klammer.

**Doppelte Namen:** `UEC1905` und `UEC1906` heissen beide *UEF Black Sun Crane*,
`URC1902` und `XRC1502` beide *Cybran Civilian Structure*.

**Kein Kollisionsrisiko.** Beim Neuschnitt ist dieses Paket unkritisch - eigene Mods
kollidieren damit nicht, solange sie keine `*C....`-IDs vergeben.
