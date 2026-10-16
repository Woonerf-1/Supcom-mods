# Mod: NavyRebalance

| | |
|---|---|
| **Ordner** | `LOUD\usermods\NavyRebalance\` |
| **VFS-Pfad** | `/mods/navyrebalance/` |
| **Anzeigename** | Navy Rebalance |
| **uid** | `169A779C-26F9-4C48-8E3F-A66EC806F33A` |
| **Version** | 1.0 |
| **Typ** | Sim-Mod (`ui_only = false`) |
| **Autor** | Colin (Werte), Extrakt und Korrekturen 2026-10-14 |
| **Icon** | `/textures/ui/common/icons/units/UES0401_icon.dds` - Bausymbol der Atlantis (Basisspiel `textures.scd`) |
| **Status** | **angelegt 2026-10-14, im Spiel ungeprueft** |
| **Umfang** | 14 Einheiten, 36 Dateien, 7,4 MB |

Uebergeordnet: [18_ABLEITUNG.md](../18_ABLEITUNG.md). Alle Pfade relativ zu `$FA`.

---

## 1. Zweck

Sechster Extrakt aus Colins Sammelmod `UEF_trans_men`: sein Marine-Rebalancing, dazu
Reparaturschiff und Seemine. Colins Werte werden uebernommen (wie bei den anderen
Extrakten), mit einer Ausnahme auf Pauls Entscheidung (Abschnitt 5.1).

## 2. Die 14 Einheiten

| ID | Name | Fraktion | Bedeutung | Quelle | Mechanismus |
|---|---|---|---|---|---|
| UAS0203 | Sylph | Aeon | T1-U-Boot | Basisspiel | Merge |
| URS0203 | Sliver | Cybran | T1-U-Boot | Basisspiel | Merge |
| XSS0203 | Sou-istle | Seraphim | T1-Angriffs-U-Boot | Basisspiel | Merge |
| UES0203 | Tigershark | UEF | T1-U-Boot | Basisspiel | Merge |
| UAS0304 | Silencer | Aeon | T3-Raketen-U-Boot | Basisspiel | Merge |
| URS0304 | Plan B | Cybran | T3-Raketen-U-Boot | Basisspiel | Merge |
| UES0304 | Ace | UEF | T3-Raketen-U-Boot | Basisspiel | Merge |
| XSS0304 | Yathsou | Seraphim | T3-U-Boot-Jaeger (Torpedos; Flak seit 2026-10-17 entfernt) | Basisspiel | Merge + Hook |
| XSS0303 | Iavish | Seraphim | T3-Flugzeugtraeger | Basisspiel | Merge |
| UES0401 | Atlantis | UEF | T4-Flugzeugtraeger | Basisspiel | Merge |
| XES0102 | Cooper | UEF | T2-Torpedoboot | Basisspiel | Merge |
| WEB0404 | Turtle | UEF | T4-Seefestung (Ausbau Schild oder Radar) | BattlePack | Kopie |
| SES0319 | Patch Class | UEF | T3-Reparatur-/Ingenieurschiff | BrewLAN | Kopie, Import repariert |
| UES0206 | Barnacle | UEF | Seemine | 4DC | Kopie, unveraendert |

**Nicht aufgenommen:** Torrent Class (`XAS0306`) - in `UEF_trans_men` unveraendert gegenueber
LOUD, ein Eintrag haette nichts bewirkt.

## 3. Bestand

```
LOUD\usermods\NavyRebalance\
  mod_info.lua
  units\<ID>\<ID>_unit.bp              11 Merge-Dateien
  units\WEB0404\, SES0319\, UES0206\   Vollkopien mit Assets
  lua\FieldEngineers.lua               Auszug BrewLAN: AssistThread
  lua\README.md
  hook\lua\ui\help\unitdescription.lua 5 Beschreibungstexte
```

## 4. Mechanik

Wie bei `mods\AirForceRebalance.md` Abschnitt 4: Basisspiel-Einheiten, deren Script Colin
nicht angefasst hat, als **Merge** mit nur den geaenderten Feldern, maschinell aus dem
Feldvergleich LOUD gegen Colin erzeugt. Kein anderer Mod ueberschreibt diese 11 IDs
(geprueft 2026-10-14).

**Entfernte Felder:** ein Merge kann Felder nur setzen, nicht loeschen. Colins Entfernen
von `Intel.SonarStealth = true` ist deshalb als `SonarStealth = false` umgesetzt
(gleichwertig). Die entfernten Flak-Buffs bleiben - siehe 5.1.

Paketeinheiten als Kopie; die Pakete sind per `conflicts` ausgeschlossen (BattlePack,
BrewLAN, 4DC - alle drei schon durch andere eigene Mods ausgeschlossen).

## 5. Aenderungen (Quelle -> Colin -> jetzt)

### 5.1 Ausnahme: Treibstoff-Buff der Flak bleibt (Entscheidung Paul)

LOUD gibt Flak-Waffen einen Buff `FUELRATIO`: jeder Treffer senkt den Treibstoff von
Flugzeugen im Radius 2 um 1,6 % (`LOUD\gamedata.entpackt\lua\lua\sim\Unit.lua`
Z. 2077-2133). 30 LOUD-Einheiten aller Fraktionen tragen ihn (Flak-Gebaeude und
Flak-Schiffe). Colin hat ihn nur bei Iavish, Yathsou und Atlantis entfernt - einseitig.
**Bleibt wie LOUD** (Paul, 2026-10-14), analog zur Entscheidung bei der T2-Flak in
`mods\AirForceRebalance.md` 5.6.

### 5.2 T1-U-Boote

| ID | Aenderung |
|---|---|
| UAS0203 Sylph | Torpedo 300 -> **150** |
| URS0203 Sliver | Energie 4950 -> 4800, Masse 400 -> 365, `BuildTime` 2000 -> 1800, Torpedo 220 -> **110** |
| XSS0203 Sou-istle | Energie 5000 -> 4800, Masse 395 -> 365, `BuildTime` 2000 -> 1800 (Schaden unveraendert) |
| UES0203 Tigershark | Energie 4950 -> 4800, Masse 400 -> 365, `BuildTime` 2000 -> 1800, Torpedo 220 -> **180** |

Muster: Kosten angeglichen (365 Masse, 1800 Bauzeit; Sylph ohne Kostenaenderung),
Torpedoschaden gesenkt, aber **uneinheitlich** (halbiert bei Sylph/Sliver, -18 % beim
Tigershark, unveraendert bei Sou-istle). Uebernommen wie von Colin.

### 5.3 Raketen-U-Boote und U-Jagd

| ID | Aenderung |
|---|---|
| UAS0304 Silencer | Sonar-Tarnung entfernt |
| URS0304 Plan B | Sonar-Tarnung entfernt |
| UES0304 Ace | Sonar-Tarnung entfernt |
| XSS0304 Yathsou | Colin: Masse 3950 -> 2150, `BuildTime` 8000 -> 5000, Sonar-Tarnung entfernt. **Seit 2026-10-17 (Paul): Preise wie LOUD (3950 / 8000), Flak "Losaare AA Autocannon" ganz entfernt**, Sonar-Tarnung bleibt aus. Die Flak entfernt `hook\lua\system\Blueprints.lua` (Waffe mit Label `AA` und Faehigkeitstext "Anti-Air") - ein Merge kann keine Listeneintraege loeschen. Waffen werden per Label gefunden (`Unit.lua` Z. 1850, 4249 in `LOUD\gamedata\lua.scd`), der Script-Eintrag `AA` bleibt ungenutzt; die Geschuetzklappe oeffnet weiter (nur Optik) |

Muster: die strategischen U-Boote sind per Sonar aufspuerbar.

### 5.4 Traeger und Torpedoboot

| ID | Aenderung |
|---|---|
| XSS0303 Iavish | Hauptwaffe 750 -> 800, Reichweite 176 -> 195; Waffe 2 `CannotAttackGround = true` (Flak-Buff: bleibt) |
| UES0401 Atlantis | Waffe 1 Schaden 350 -> 450, Reichweite 64 -> 75, Feuerrate 1 -> 2 (Flak-Buff: bleibt) |
| XES0102 Cooper | Torpedo 270 -> **540** |

### 5.5 Seefestung, Reparaturschiff, Mine

| ID | Aenderung |
|---|---|
| WEB0404 Turtle | Energie 298500 -> 150000, Masse 24500 -> 12000 (Haelfte). Baurate 20 fuer die Ausbauten vorhanden |
| SES0319 Patch Class | Werte unveraendert gegenueber BrewLAN; Script-Import geaendert, siehe 6 |
| UES0206 Barnacle | unveraendert gegenueber 4DC - aufgenommen, damit die Mine verfuegbar bleibt, solange 4DC ausgeschlossen ist |

## 6. Korrekturen durch uns

- **Patch Class:** Colin hatte BrewLANs Import
  `import(BrewLANLOUDPath .. '/lua/fieldengineers.lua')` durch `import('/lua/fieldengineers.lua')`
  ersetzt - die Datei gibt es in LOUD nicht, nur in BrewLAN. Das Script waere beim Laden
  abgebrochen. Jetzt eigener Auszug `lua\FieldEngineers.lua` (`AssistThread`, wortgleich).
- **Turtle:** Texturpfade `/mods/UEF_trans_men/...` auf `/mods/navyrebalance/...`.
- **Turtle:** `desktop.ini` und eine leere `UEF T3 Anti-navy Installation.txt` nicht
  uebernommen (lagen schon im BattlePack-Original).

## 7. Beschreibungen und KI

- Beschreibungen wortgleich aus BrewLAN (`ses0319`), BattlePack (`web0404`,
  `web0404-Shield`, `web0404-Radar_T3`), 4DC (`ues0206`). Basisspiel-Einheiten behalten
  LOUDs Texte.
- **KI:** keines der drei Quellpakete fuehrt Turtle, Patch Class oder Barnacle in einer
  `CustomUnits`-Liste - nichts zu uebernehmen. Basisspiel-Einheiten baut die KI ohnehin.

## 8. Tests

| Datum | Was | Ergebnis |
|---|---|---|
| 2026-10-14 | 41 Pfadliterale gegen das VFS | alle loesen auf |
| 2026-10-14 | ASCII, Restverweise, Kopien gegen Colin | sauber, nur Abschnitt 6 |
| | **Testlauf im Spiel** | **ausstehend** |

**Pruefliste:**

1. Mod-Manager: "Navy Rebalance" mit Atlantis-Bild; Konfliktmeldung bei BattlePack,
   BrewLAN, 4DC.
2. Log: `Hooked /lua/ui/help/unitdescription.lua with /mods/navyrebalance/...`, kein Fehler
   mit `navyrebalance` im Pfad.
3. T1-U-Boot und Cooper bauen - Kosten im Baumenue wie Abschnitt 5 (Merge wirkt).
4. Raketen-U-Boot: von Sonar erfasst?
5. Patch Class: repariert im Leerlauf Verbuendete - **kein Lua-Fehler** beim Bau.
6. Turtle: Ausbau Schild bzw. Radar baut fertig.
7. Barnacle verlegen und ausloesen.

## 9. Offene Punkte

- [ ] Testlauf, Abschnitt 8
- [ ] T1-U-Boot-Torpedos uneinheitlich (5.2) - so lassen?
- [x] Cooper: Colin hat `STRUCTURE` aus `Weapon[2].TargetPriorities` gestrichen, unser Merge
      nicht (Merge kann Listeneintraege nicht loeschen). Gefunden 2026-10-14 ueber das
      Team-PDF. **Entschieden (Paul): bleibt wie LOUD**, das Torpedoboot greift weiter
      Gebaeude an.

## 10. Quellen

- `LOUD\usermods\doc.claude\_Altlasten\UEF_trans_men\units\`
- `LOUD\gamedata.entpackt\units\units\`
- `LOUD\gamedata.entpackt\WyvernBattlePack\mods\BattlePack\units\WEB0404\`
- `LOUD\gamedata.entpackt\brewlan\mods\BrewLAN_LOUD\units\SES0319\`, `...\lua\FieldEngineers.lua`
- `LOUD\gamedata.entpackt\4D-CompatibilityPack\mods\4DC\units\UES0206\`
