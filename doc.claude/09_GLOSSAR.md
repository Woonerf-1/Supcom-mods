# 09 — Glossar

## Dateiformate

| Endung | Bedeutung |
|---|---|
| `.scd` | Supreme Commander Data — umbenanntes ZIP-Archiv mit Spieldaten |
| `.bp` | Blueprint — Datendefinition (Lua-Syntax) für Einheiten, Geschosse, Props, Meshes |
| `.lua` | Skript (Sim oder UI) |
| `.scm` | Supreme Commander Mesh — 3D-Modell |
| `.sca` | Supreme Commander Animation |
| `.dds` | DirectDraw Surface — Textur |
| `.xwb` / `.xsb` | XACT Wave Bank / Sound Bank — Audio |
| `.v3d`, `.psh`, `.vsh`, `.fx` | Shader |
| `_unit.bp` | Einheiten-Blueprint |
| `_script.lua` | Verhaltensskript einer Einheit |
| `_Albedo.dds` | Grundfarbtextur |
| `_NormalsTS.dds` | Normal Map (Tangent Space) |
| `_SpecTeam.dds` | Specular + Teamfarben-Maske |
| `_lod0`, `_lod1` | Detailstufen (Level of Detail) |

## Begriffe

| Begriff | Bedeutung |
|---|---|
| **ACU** | Armored Command Unit — der Kommandant, Einheiten-ID `*0001` |
| **SCU** | Support Commander Unit |
| **Blueprint** | Datendefinition einer Spielentität |
| **Blueprint-ID** | Kennung wie `uel0001` — intern immer kleingeschrieben |
| **Brain / AIBrain** | Objekt, das eine Armee repräsentiert (auch die des Menschen) |
| **Buff** | temporäre oder dauerhafte Werteänderung an einer Einheit |
| **BuffField** | Flächenwirkung eines Buffs (z. B. Adjazenzboni) |
| **Categories** | Etiketten am Blueprint, die Zielsuche, Baumenü und KI steuern |
| **Desync** | Auseinanderlaufen der Simulation zwischen Spielern → Spielabbruch |
| **Enhancement** | Upgrade an ACU/SCU |
| **FA** | Forged Alliance (Add-on von Supreme Commander) |
| **Hook** | Skript, das nach dem Original im selben Environment läuft und es erweitert |
| **LOD** | Level of Detail — Modellvereinfachung mit der Entfernung |
| **LOUD** | Die hier verwendete SCFA-Distribution mit überarbeiteter KI und Einheitenpaketen |
| **Merge** | Blueprint-Zusammenführung statt Vollersatz (`Merge = true`) |
| **Platoon** | KI-Verband aus mehreren Einheiten |
| **Prop** | unbewegliches Objekt auf der Karte (Fels, Baum, Wrack) |
| **Reclaim** | Rückgewinnung von Masse/Energie aus Wracks und Props |
| **Shadow** | Datei eines Mods, die eine Originaldatei vollständig ersetzt und unerreichbar macht |
| **Sim** | Simulation — die deterministische Spiellogik |
| **Tarmac** | Bodentextur unter Gebäuden |
| **Tick** | Simulationsschritt, 0,1 s bei Normalgeschwindigkeit |
| **Trashbag** | Aufräumliste an einem Objekt (`self.Trash`), wird bei Zerstörung geleert |
| **VFS** | Virtual File System — die zusammengesetzte Dateisicht der Engine |
| **Veterancy** | Erfahrungssystem der Einheiten |
| **Wreckage** | Wrack einer zerstörten Einheit |

## Fraktionskürzel in Unit-IDs

| Kürzel | Fraktion |
|---|---|
| `A` | Aeon |
| `E` | UEF (Earth) |
| `R` | Cybran |
| `S` | Seraphim |

## Domänenkürzel

| Kürzel | Domäne |
|---|---|
| `L` | Land |
| `A` | Air |
| `S` | Sea |
| `B` | Base / Structure |

## Einheitenpakete in LOUD

| Paket | Herkunft |
|---|---|
| **BrewLAN** | großes Einheiten- und Strategiesymbolpaket |
| **BlackOps** | Einheiten- und Erweiterungspaket (auch „BO Unleashed") |
| **Total Mayhem** | Experimental-lastiges Einheitenpaket |
| **Wyvern Battle Pack** | zusätzliche Einheiten |
| **Nomads** | fünfte Fraktion (hier als Usermod) |
| **4D Compatibility Pack** | Kompatibilitätsschicht zwischen den Paketen |

## Log-Präfixe in `LOUD.log`

| Präfix | Bedeutung |
|---|---|
| `info:` | normale Statusmeldung |
| `warning:` | Warnung — oft die eigentliche Fehlerursache |
| `error:` | Fehler |
| `debug:` | Detailausgabe |
| `*AI DEBUG` | LOUD-KI-Diagnose |
| `*DEBUG` | LOUD-Initialisierungsschritte |
