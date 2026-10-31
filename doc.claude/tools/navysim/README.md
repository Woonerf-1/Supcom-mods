# navysim - Gefechtssimulation U-Boot-Gruppen

Stand 2026-10-25. Anlass: Paul, Vergleich XSS0304 Yathsou (Seraphim T3, Fassung NavyRebalance) gegen T2-U-Boote
bei gleicher Masse, mit Reichweite und Torpedo-Abwehr.

## Dateien

| Datei | Inhalt |
|---|---|
| `NavySim.cs` | Simulation (C#, per `Add-Type` geladen) |
| `Run-NavySim.ps1` | Einheitenwerte, Laeufe, Ausgabe |

Aufruf aus `$FA`:

```
& 'LOUD\usermods\doc.claude\tools\navysim\Run-NavySim.ps1' -Runs 200 -PHit 0.25
& 'LOUD\usermods\doc.claude\tools\navysim\Run-NavySim.ps1' -Runs 100 -PHit 0.25 -BreakEven -NoTable -Only Vesper,Exodus
```

## Modell

- Zwei Gruppen als Punkte auf einer Linie, Startabstand 90, Takt 0,1 s, je Konstellation viele Laeufe (Zufall nur
  in der Zielwahl und bei Abwehrwerfer-Treffern).
- **Anfahrt:** jede Seite faehrt mit ihrem Tempo, bis der Gegner in ihrer Reichweite ist, und bleibt dann stehen.
  Die kuerzer reichende Seite faehrt also unter Beschuss weiter heran.
- **Feuern:** Salven nach Blueprint (Anzahl, Abstand `MuzzleSalvoDelay`, Takt nach LOUD-PhxLib). Ziel: zufaellige
  lebende Einheit, beibehalten bis zu deren Tod.
- **Torpedos:** Flugkoerper mit Startgeschwindigkeit (`MuzzleVelocity`), Beschleunigung und Hoechstgeschwindigkeit
  aus dem Projektil-Blueprint, Lebensdauer `ProjectileLifetime`. Stirbt das Ziel vorher, ist der Torpedo verloren.
- **Abwehrfeld** (`Defense.MissileTorpDestroy`, LOUD `lua/defaultantiprojectile.lua`): zerstoert sicher einen
  Torpedo, der in den Radius eindringt, danach Pause `1 + RedirectRateOfFire` Ticks (Code-Verhalten, deterministisch).
- **Abwehrwerfer** (Anti-Torpedo-Waffen von Uashavoh, Exodus): schiesst nach Takt (`RateOfFire` bzw.
  `WeaponRepackTimeout`) auf einen beliebigen Torpedo im Fenster MinRadius-MaxRadius, der die eigene Seite anfliegt;
  Trefferchance `-PHit` - **ungeprueft**, daher Parameter. Die Abwehr-Torpedos (`AIMAntiTorpedo01`) erreichen
  hoechstens 15, die Yathsou-Torpedos 18.
- Regeneration ja. **Nicht modelliert:** Sicht/Tarnung (alle sehen alle), Formation und Abstaende in der Gruppe,
  Ausweichen, Wasserbomben (Reichweite 12), Torpedo-Streuung, Treffer auf Nachbarn, Veteranen.

## Werte

Aus `LOUD\gamedata\units.scd`, `brewlan.scd`, `projectiles.scd` (2026-10-25), Yathsou mit NavyRebalance. Einzeln
im Kopf von `Run-NavySim.ps1`.
