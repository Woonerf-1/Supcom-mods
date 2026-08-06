# Paket `civ_units` - Zivileinheiten

Zurueck: [README.md](README.md) - [pakete.md](pakete.md) - [../17_UNITLISTE.md](../17_UNITLISTE.md)

```
C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\civ_units\units\
```

**100 Einheiten, keine einzige mehrfach belegt.** Ein reines Inhaltspaket - es ersetzt
nichts und wird von nichts ersetzt.

Stand 2026-08-06 aus `_generiert\units.csv`.

Das **3. Zeichen `C` steht fuer Civilian**, nicht fuer eine Domaene. Das Verzeichnis
enthaelt 117 Unterordner; 17 davon haben kein `_unit.bp` und sind keine Einheiten -
darunter die fuenf Strassenobjekte `UEF_Bus`, `UEF_Car1`, `UEF_Fence`,
`UEF_Streetlight_01`, `UEF_truck`.

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

## Aeon (1)

| ID | Name |
|---|---|
| `UAC1301` | Aeon Civilian Structure |

## UEF (52)

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

Alle heissen *UEF Wall Segment*:
`XEC8001` bis `XEC8020` und `XEC9001` bis `XEC9011`.

## Cybran (46)

### Gebaeude (6)

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

Alle heissen *Cybran Wall Segment*: `XRC8001` bis `XRC8020` und `XRC8101` bis `XRC8120`.

Zwei Ausnahmen: `XRC8016` heisst *Cybran Wall Endcap Segment*, und bei `XRC8014` steht
im Blueprint ein ueberzaehliges Zeichen: *Cybran Wall Segment)*.

## Seraphim (3)

| ID | Name |
|---|---|
| `XSC1301` | Seraphim Administrative Building |
| `XSC8001` | Seraphim Wall Segment |
| `XSC9002` | Jammer Crystal |

---

## Auffaelligkeiten

**71 der 100 Einheiten sind Mauersegmente** - UEF 31, Cybran 40, Seraphim 1. Sie
unterscheiden sich vermutlich nur im Modell.

**Ein Tippfehler im Original:** `XRC8014` traegt den Namen *Cybran Wall Segment)* mit
schliessender Klammer.

**Kein Kollisionsrisiko.** Beim Neuschnitt ist dieses Paket unkritisch - eigene Mods
kollidieren damit nicht, solange sie keine `*C....`-IDs vergeben.
