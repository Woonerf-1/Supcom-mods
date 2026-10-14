# NavyRebalance - lua\

| Datei | Quelle | enthaelt | benutzt von |
|---|---|---|---|
| `FieldEngineers.lua` | `LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_LOUD\lua\FieldEngineers.lua` Z. 59-72 | `AssistThread` (Ingenieurschiff repariert im Leerlauf Verbuendete im Umkreis 30) | `units\SES0319\SES0319_script.lua` |

Wortgleich aus BrewLAN, nur auf die eine Funktion gekuerzt. Colins Fassung der Patch Class
importierte `/lua/fieldengineers.lua` - diese Datei gibt es in LOUD nicht (nur in BrewLAN),
das Script waere beim Laden abgebrochen.
