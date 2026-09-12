# tooltips.lua

Datei: `usermods\DynamicGameplay\hook\lua\ui\help\tooltips.lua`
Wirkt auf: `/lua/ui/help/tooltips.lua`

## Zweck

Beschriftet die Schaltflaechen des Panopticon (`SEB3404`). Ohne diese Datei bleibt der
Umschalter im Spiel **ohne Titel und ohne Beschreibung**.

## Warum es fehlte

Das Blueprint verweist korrekt auf einen Tooltip-Schluessel
(`SEB3404_unit.bp` Z. 409, LOUD-Fassung):

```lua
RULEUTC_WeaponToggle = { bitmapId = 'Vision', helpText = 'toggle_economy_watch' },
```

Den zugehoerigen Text liefert **BrewLAN** in `mods/BrewLAN/hook/lua/ui/help/tooltips.lua`.
**LOUD hat ihn nicht uebernommen**, und **Colin** hatte ihn ebenfalls nicht - seine
`UEF_trans_men\hook\lua\ui\help\tooltips.lua` enthaelt nur einen Eintrag zu
Einheitenbeschraenkungen.

LOUD kennt zwar den Schluessel `toggle_weapon` ("Toggle between air and ground weaponry"),
aber das Panopticon benutzt `RULEUTC_WeaponToggle` fuer etwas voellig anderes - die
Verbrauchsbeschraenkung. Der Standardtext waere also nicht nur fehlend, sondern falsch.

## Inhalt

| Schluessel | wofuer |
|---|---|
| `toggle_economy_watch` | der Umschalter am fertig ausgebauten Panopticon |
| `construction_tab_enhancement_panopticon_array` | Reiter in der Ausbauleiste |

Die Texte sind woertlich aus BrewLAN uebernommen. Die `<LOC ...>`-Schluessel stehen mit
drin, obwohl BrewLANs `strings_db` bei uns nicht geladen wird - dann greift der Klartext
dahinter. So bleibt die Herkunft erkennbar, falls jemand spaeter uebersetzen will.

## Was der Schalter tut

**Er schaltet nichts ab.** Er steuert `self.ActiveConsumptionRestriction` in
`SEB3404_Script.lua`:

| Zustand | Wirkung in `IntelSearch` |
|---|---|
| Beschraenkung **an** | Einheiten nach Entfernung sortiert, naechste zuerst; Abbruch sobald `Verbrauch + Kosten > freie Energie`. Der Rest bleibt unmarkiert. |
| Beschraenkung **aus** | alle Einheiten in Reichweite werden markiert, unabhaengig von der Energielage |

Die freie Energie ist `Einkommen - Bedarf + bisheriger Panopticon-Verbrauch` - der eigene
Verbrauch wird herausgerechnet, sonst spaerrte sich das Gebaeude selbst aus.

**Achtung, die Logik ist invertiert:** `SetScriptBit('RULEUTC_WeaponToggle', true)`
bedeutet `ActiveConsumptionRestriction = false`, also **keine** Beschraenkung. Genau so
wird das Panopticon beim `Xband_Dish`-Ausbau freigeschaltet - ungebremst.

Der Schalter erscheint erst mit dem letzten Ausbau; `AddToggleCap` steht in
`CreateEnhancement` im Zweig `if enh == 'Xband_Dish'`.
