-- ============================================================================
-- AIDefinitions.lua - die zentrale Liste aller KIs dieses Mods
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\lua\AI\AIDefinitions.lua
--
-- DIES IST DIE EINZIGE DATEI, DIE FUER EINE NEUE KI ZWINGEND ZU AENDERN IST.
-- Ein Eintrag hier bewirkt beides:
--   - die KI erscheint in der Lobby-Auswahlliste
--     (gelesen von CustomAIs_v2\CustomAI.lua)
--   - sie bekommt ein eigenes Basistemplate
--     (erzeugt von AIFactory.lua, angestossen von LoadAIs.lua)
--
-- Diese Datei wird von BEIDEN Seiten gelesen - UI (Lobby) und Sim.
-- Sie darf deshalb nichts tun ausser Daten zurueckzugeben: keine LOGs,
-- keine Engine-Aufrufe, keine globalen Variablen.
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 4
-- ============================================================================

-- ----------------------------------------------------------------------------
-- FELDER EINES EINTRAGS
--
--   Key          Pflicht. Eindeutige Kennung, klein geschrieben, mit Praefix
--                'customai_'. Landet in aiBrain.Personality und ist das
--                Unterscheidungsmerkmal im Basistemplate.
--                ACHTUNG: Die Duplikatspruefung der Engine funktioniert nicht -
--                zwei gleiche Keys erzeugen zwei Lobby-Eintraege.
--
--   Name         Pflicht. Anzeigename in der Lobby.
--                MUSS 'AI: LOUD' ENTHALTEN. Sonst tritt LOUD zurueck und
--                startet gar keinen Plan - die KI steht dann untaetig im Spiel.
--                Siehe aibrain.lua OnCreateAI, doc.claude\mods\CustomAI.md
--                Abschnitt 3.
--
--   Source       Pflicht. Name des LOUD-Basistemplates, von dem geerbt wird.
--                Verfuegbar sind die 14 Templates aus
--                gamedata.entpackt\lua\lua\AI\AIBaseTemplates\.
--                'Loud_Main_Standard' ist der grosse Standardaufbau.
--
--   Value        Optional, Vorgabe 200. Rueckgabewert der FirstBaseFunction,
--                wenn der Key passt. Muss ueber allen LOUD-Werten liegen -
--                Loud_Main_Standard gibt bis zu 100 zurueck. 200 gewinnt sicher.
--
--   Customize    Optional. Voller VFS-Pfad zu einer Datei mit
--                  function Apply(template, definition)
--                Dort wird das geerbte Template veraendert. Fehlt das Feld,
--                bleibt es eine unveraenderte Kopie - Verhalten wie LOUD.
--
--   Phasen       Optional, nur fuer Customize = '/mods/customai/lua/AI/AIs/NoRush.lua'.
--                Liste von Abschnitten mit Builder- und/oder
--                BuilderGroup-Namen und einem Freigabezeitpunkt, angegeben
--                entweder als `Zeit` (feste Spielsekunden) oder als `Anteil`
--                (Bruchteil der No-Rush-Dauer aus der Lobby). Bis dahin laufen
--                diese Aufgaben auf Prioritaet 10 - faktisch aus, aber
--                wiederbelebbar. Aufbau siehe AIs\NoRush.lua.
--
--   Description  Optional. Nur fuer die Doku, wird nicht angezeigt.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- PHASENPLAN
--
--   Phase 1  (ab Sekunde 0)   Wirtschaft: Extraktoren, Kraftwerke, Fabriken,
--                             Ingenieure. Nicht gesperrt, also LOUDs
--                             Normalverhalten - nur ohne Konkurrenz.
--                             Der Techaufstieg der Fabriken braucht keinen
--                             Eintrag: LaunchUpgradeThread und
--                             FactorySelfEnhanceThread werden von
--                             FactoryBuilderManager.lua Z. 630-645 gestartet,
--                             sobald die Bauschlange einer Fabrik leer ist -
--                             genau der Zustand, den Phase 1 erzeugt.
--   Phase 2  (aLuft)          stationaere Flugabwehr
--   Phase 3  (aBoden)         minimale stationaere Bodenabwehr (nur T1/T2)
--                             UND ab hier erst neue Fabriken - danach dauerhaft
--                             mit Prioritaetsdeckel 745, also hinter der
--                             Wirtschaft. Begruendung unten beim Eintrag.
--   Phase 4  (aTruppen)       mobile Truppen, Aufklaerung, Artillerie, Nukes,
--                             Optik, Experimentaleinheiten, schwere Verteidigung
--
-- Die drei Werte sind ANTEILE der No-Rush-Dauer aus der Lobby, nicht Sekunden.
-- NoRush.lua liest dafuer ScenarioInfo.Options.NoRushOption zur Laufzeit aus.
--
--   NoRushOption   Dauer   Phase 2   Phase 3   Phase 4
--   'Off'           -      keine Sperre - die KI spielt wie LOUD
--   '5'            5 min    1:45      2:45      3:45
--   '10'          10 min    3:30      5:30      7:30
--   '20'          20 min    7:00     11:00     15:00
--
-- Statt `Anteil` ist in jeder Phase auch `Zeit` in Spielsekunden moeglich -
-- damit liesse sich eine KI mit festen Zeiten bauen, die die Lobbyoption
-- ignoriert.
--
-- Alle Builder-Namen aus
-- C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBuilders\Loud_AI_Engineer_Defense_Builders.lua
-- Nicht gefundene Namen meldet NoRush.lua als Warnung im Log.
-- ----------------------------------------------------------------------------
local function Phasenplan(aLuft, aBoden, aTruppen)

    return {

        {
            Name   = "Flugabwehr",
            Anteil = aLuft,
            Builder = {
                'T2 Base AA - Base Template',
                'T3 Base AA - Base Template',
                'T3 Perimeter AA',
                'T4 Perimeter AA',
                'T3 Picket AA',
                'Experimental AA Defense',
                'T2 Base AA - Expansion',
                'T3 Base AA - Expansions',
                'Experimental AA Defense - Expansions',
            },
        },

        -- ----------------------------------------------------------------
        -- T3-Flak vor allem anderen in der Verteidigung
        --
        -- Original liegen fast alle Verteidigungsbauer bei 750
        -- (Loud_AI_Engineer_Defense_Builders.lua), T3 Base PD bei 751.
        -- Mit 760 stehen die T3-Flakbauer ueber dem ganzen Feld und werden
        -- zuerst gesetzt.
        -- ----------------------------------------------------------------
        {
            Name          = "T3-Flak zuerst",
            Anteil        = aLuft,
            PrioritaetMin = 760,
            Builder = {
                'T3 Base AA - Base Template',
                'T3 Perimeter AA',
                'T3 Picket AA',
                'T3 Base AA - Expansions',
            },
        },

        -- ----------------------------------------------------------------
        -- ALLES ZURUECKSTELLEN, WAEHREND DER ACU AUSBAUT
        --
        -- Solange der Kommandant an einem Ausbau arbeitet - der erste ist bei
        -- allen Fraktionen ResourceAllocation - bleiben die grossen
        -- Masseverbraucher auf Prioritaet 10.
        --
        -- ⚠ DAS IST KEINE ECHTE PAUSE. Die Engine verteilt Masse und Energie
        -- anteilig; laufende Bauten laufen weiter. Der Eintrag verhindert nur,
        -- dass NEUE Aufgaben begonnen werden. Fabriken, die schon eine Einheit
        -- in der Schlange haben, bauen sie zu Ende.
        --
        -- NICHT gesperrt und damit weiterlaufend:
        --   'Engineer Mass Builders'    Extraktoren - genau das, was der
        --                               Ausbau spaeter bezahlen soll
        --   'Engineer Energy Builders'  Kraftwerke, sonst faellt die Energie
        --                               waehrend des Ausbaus weg
        --   'Engineer Tasks'            enthaelt 'Assist ACU SACU' (740) -
        --                               freie Ingenieure gehen dem ACU helfen,
        --                               weil ihnen sonst nichts uebrig bleibt
        --   'ACU Tasks'                 der Kommandant selbst
        -- ----------------------------------------------------------------
        {
            Name      = "Waehrend ACU-Ausbau zurueckstellen",
            Bedingung = 'KeinACUAusbau',
            Gruppen = {
                'Engineer Mass Storage Construction',
                'Engineer Energy Storage Construction',
                'Engineer Mass Energy Construction',
                'Engineer Eng Station Construction',
                'Engineer Construction - Land Base',
                'Engineer Construction - Land DP',
                'Engineer Base Defense Construction - Core',
                'Engineer Base Defense Construction - Perimeter',
                'Engineer Base Defense Construction - Picket Line',
                'Engineer Shield Construction',
                'Engineer Artillery Construction T3',
                'Engineer Artillery Construction T4',
                'Engineer Nuke Construction',
                'Engineer Optics Construction',
                'Engineer T4 Construction Land',
                'Engineer T4 Construction Air - Land Map',
                'Engineer T4 Economy Construction',
                'Factory Production - Engineers',
                'Factory Production Land',
                'Factory Production Land - Land Only Map',
                'Factory Production Air - Fighters',
                'Factory Production Air - Bombers',
                'Factory Production Air - Gunships',
                'Factory Production Air - Transports',
            },
            Builder = {
                'Land Factory Balance',
                'Air Factory Balance',
                'Land Factory - High Air Production Ratio',
                'Air Factory - Land Ratio High',
                'Mass Storage 600 - NoRush',
            },
        },

        -- ----------------------------------------------------------------
        -- LUFTWAFFE: KEINE LANDFABRIKEN
        --
        -- BaseSettings.FactoryCount LAND = 0 laesst FactoryCapCheck immer
        -- scheitern. Das genuegt aber NICHT: 'Land Factory Rebuild' prueft
        -- den Deckel gar nicht, sondern nur 'FactoryLessAtLocation' - der
        -- Bauer wuerde also weiterhin eine Landfabrik setzen, sobald die
        -- Phasensperre faellt. Deshalb hier zusaetzlich dauerhaft aus.
        --
        -- Die erste und einzige Fabrik kommt vom ACU: auf Karten ueber 1024
        -- baut 'CDR Initial Large Map' eine LUFTfabrik. Auf kleineren Karten
        -- waere es eine Landfabrik - dann stuende diese KI ohne Fabrik da.
        -- Siehe doc.claude\TODO.md.
        -- ----------------------------------------------------------------
        {
            Name      = "Land- und Marinefabriken dauerhaft aus",
            Bedingung = 'Nie',
            Builder = {
                'Land Factory Balance',
                'Land Factory - High Air Production Ratio',
                'Land Factory Rebuild',
                'Land Factory Balance - Expansion',
                'Land Factory - High Air Production Ratio - Expansion',
                'Land Factory Rebuild - Expansion',
                'Naval Factory Builder',
                'Naval Factory Rebuild',
            },
        },

        -- ----------------------------------------------------------------
        -- LUFTWAFFE: SCHWERPUNKT AUF GUNSHIPS UND ASF
        --
        -- Alle Einheitenbauer in Loud_AI_Factory_Air_Builders.lua stehen im
        -- Original bei 600 - ein voellig flaches Feld. Erst ein Boden bzw.
        -- Deckel erzeugt eine Rangfolge.
        --
        --   650  Gunships T2/T3, Jaeger T2/T3 (ASF)
        --   600  Bomber, unveraendert
        --   300  Aufklaerer - werden nur noch gebaut, wenn sonst nichts ansteht
        -- ----------------------------------------------------------------
        {
            Name          = "Gunships und ASF bevorzugen",
            Anteil        = aTruppen,
            PrioritaetMin = 650,
            Builder = {
                'Gunship T2',
                'Gunship T3',
                'Fighters T2',
                'Fighters T2 Crossover',
                'Fighters T3',
                'Fighters T3 Advanced',
            },
        },

        {
            Name       = "Wenig Aufklaerer",
            Prioritaet = 300,
            Builder = {
                'Air Scout T2',
                'Air Scout T3',
            },
        },

        -- ----------------------------------------------------------------
        -- EXTRAKTOREN AUSSERHALB DES NO-RUSH-KREISES ERST DANACH
        --
        -- Die 750er- und 1500er-Staffel zielt auf Massepunkte, die waehrend
        -- der Frist ohnehin unerreichbar sind - dort kann niemand expandieren.
        -- Sie binden nur Techniker, die naeher gebraucht werden.
        --
        -- Anteil 1.0 heisst: Freigabe genau mit Ablauf der Frist.
        -- ----------------------------------------------------------------
        {
            Name   = "Entfernte Extraktoren erst nach No-Rush",
            Anteil = 1.0,
            Builder = {
                'Mass Extractor T1 - 750 - Loop - BuildClose',
                'Mass Extractor T1 - 750 - BuildClose - NoRush',
                'Mass Extractor T1 - 750 - Loop',
                'Mass Extractor T1 - 1500 - Loop',
                'Mass Extractor T1 - 1500 - Loop - NoRush',
                'Mass Extractor T1 - 1500 - Loop - Extra',
            },
        },

        -- ----------------------------------------------------------------
        -- AIR STAGING ERST NACH DER NO-RUSH-FRIST
        --
        -- Anteil 1.0 heisst: genau bei Ablauf der Frist. Vorher fliegt nichts,
        -- also braucht auch nichts betankt zu werden.
        -- Bauer in Loud_AI_Engineer_Defense_Builders.lua ab Z. 2065.
        -- ----------------------------------------------------------------
        {
            Name   = "Air Staging erst nach No-Rush",
            Anteil = 1.0,
            Builder = {
                'Air Staging T1',
                'Air Staging T2',
                'Air Staging T1 - Small Base',
                'Air Staging T2 - Small Base',
            },
        },

        -- ----------------------------------------------------------------
        -- KEINE T1-VERTEIDIGUNG, NIEMALS
        --
        -- Bedingung 'Nie' liefert immer false, der Builder bleibt damit
        -- dauerhaft auf Prioritaet 10.
        --
        -- Ohne diesen Eintrag setzte die KI ab Phase 2 bzw. 3 zuerst
        -- T1-Geschuetze - beobachtet in Testlauf 6 bei 5:29.
        -- ----------------------------------------------------------------
        {
            Name      = "T1-Verteidigung dauerhaft aus",
            Bedingung = 'Nie',
            Builder = {
                'T1 Base Defense - PD',
                'T1 Base Defense - AA',
                'T1 Perimeter PD - Small Map',
                'T1 Perimeter PD - Large Map',
                'T1 Perimeter - AA',
                'T1 Extractor Defense',
                -- auch der Kommandant baut T1-Verteidigung
                'CDR T1 Base Defense - PD',
                'CDR T1 AA - Response - Small Maps',
            },
        },

        -- ----------------------------------------------------------------
        -- KEINE T1-EINHEITEN, NIEMALS
        --
        -- Begruendung des Nutzers: bei No-Rush sind T1-Einheiten Verschwendung -
        -- sie sind zum Ablauf der Frist wertlos und kosten Masse und
        -- Einheitenlimit.
        --
        -- ACHTUNG, Nebenwirkung: 'Land Scout' und 'Air Scout T1' fallen mit
        -- weg. Aufklaerung gibt es damit erst, wenn die Fabriken auf Stufe 2
        -- sind. aiBrain.IL, LandRatio und AirRatio bleiben bis dahin leer.
        -- ----------------------------------------------------------------
        {
            Name      = "T1-Einheiten dauerhaft aus",
            Bedingung = 'Nie',
            Builder = {
                -- Land
                'Land Scout',
                'T1 Bots',
                'T1 Tanks',
                'T1 Mobile Artillery',
                'T1 Mobile AA - Large Map',
                'T1 Mobile AA - Small Map',
                'T1 Amphibious Tank',
                -- Luft
                'Air Scout T1',
                'Fighters T1',
                'Fighters T1 Plus',
                'Bomber T1',
                'Torpedo Bomber T1',
                -- ⚠ KORREKTUR: 'Air Transport T1' bleibt gesperrt.
                --
                -- Zwischenzeitlich war er freigegeben, weil im Log
                -- "calls for transport" auftauchte. Diese Diagnose war falsch -
                -- siehe CHANGELOG Nachtrag 33. Der Techniker laeuft dabei
                -- weiter; die Anforderung ist nur ein Nebeneffekt langer Wege.
                --
                -- Ausdrueckliche Vorgabe des Nutzers: T1-Techniker gehen zu
                -- Fuss. In der Fruehphase fehlt die Masse eines Transporters
                -- beim Extraktor.
                'Air Transport T1',
            },
        },

        -- ----------------------------------------------------------------
        -- T2-TRANSPORTER ERST MIT T3-LUFTFABRIK UND QUANTENTOR
        --
        -- Die Bedingung prueft beides. GetCurrentUnits zaehlt angefangene
        -- Bauten mit - "Quantentor im Bau" ist damit abgedeckt.
        -- ----------------------------------------------------------------
        {
            Name      = "Transporter",
            Anteil    = aTruppen,
            Bedingung = 'TransporterFreigabe',
            Builder = {
                'Air Transport T2',
                'Air Transport T3',
                'UEF Gunship Transports',
            },
        },

        -- ----------------------------------------------------------------
        -- KRAFTWERKSPLAN
        --
        -- T1  Grundstock 6, dazu 4 je Extraktor ab Stufe 2.
        --     Bei 4 T1-Extraktoren also 6; sind alle vier auf T2, sind es 22.
        --
        --     Ein FESTER Deckel waere hier falsch: der Aufstieg T1 -> T2 eines
        --     Extraktors haengt an der Energietrend-Schwelle von
        --     SelfUpgradeThread (energylowtrigger 1.007, defaultunits.lua
        --     Z. 813). Zu wenig Energie heisst, die Extraktoren steigen nicht
        --     auf - genau die Beobachtung aus Testlauf 7.
        --
        -- T2  hoechstens so viele wie T3-Extraktoren plus 1. Daraus entsteht
        --     die gewuenschte Abfolge Kraftwerk, Extraktor, Kraftwerk,
        --     Extraktor.
        --
        -- T3  ohne Grenze; LOUD schaltet T1 und T2 ohnehin ab, sobald ein
        --     T3-Kraftwerk an der Basis steht
        --     (Loud_AI_Engineer_Energy_Builders.lua Z. 46-58 und Z. 101-113).
        -- ----------------------------------------------------------------
        {
            Name          = "T1-Kraftwerke nach Bedarf",
            Bedingung     = 'T1KraftwerkeNachBedarf',
            BedingungWert = { 6, 4 },   -- Grundstock, je T2-Extraktor
            Builder = {
                'T1 Power Template',
            },
        },

        {
            -- ----------------------------------------------------------------
            -- KEIN T1-KRAFTWERK MEHR, SOBALD EIN T2 STEHT
            --
            -- Vorgabe: "sobald es T2 gibt, keine T1-Kraftwerke mehr."
            --
            -- LOUD schaltet die T1-Bauer von sich aus erst ab, wenn ein
            -- T3-Kraftwerk an der Basis steht (T1 Power Template,
            -- PriorityFunction, Loud_AI_Engineer_Energy_Builders.lua Z. 46-58).
            -- Dazwischen laeuft beides nebeneinander:
            --
            --   T1-Kraftwerk    20 Energie/s   (UAB1101_unit.bp Z. 95)
            --   T2-Kraftwerk   500 Energie/s   (UAB1201_unit.bp Z. 149)
            --
            -- Ein T1 nachzulegen, wenn T2 verfuegbar ist, waere
            -- Masseverschwendung - fuenfundzwanzig T1 entsprechen einem T2.
            --
            -- Gilt zusaetzlich zur Bedarfsrechnung oben; die strengere
            -- Bedingung gewinnt.
            --
            -- Der Riegel ist ungefaehrlich: er greift erst, wenn ein
            -- T2-Kraftwerk begonnen ist - es gibt also immer einen Weg zu
            -- mehr Energie.
            -- ----------------------------------------------------------------
            Name      = "T1-Kraftwerke nur bis zum ersten T2",
            Bedingung = 'KeinT2Kraftwerk',
            Builder = {
                'T1 Power Template',

                -- Der Kommandant baut T1-Kraftwerke ueber einen eigenen
                -- Builder und ist in der Startphase allein dafuer zustaendig
                -- (siehe "Techniker: nur Extraktoren bis zum vierten T2").
                -- Die Abschaltregel gilt fuer ihn genauso: steht ein
                -- T2-Kraftwerk, lohnt auch fuer ihn kein T1 mehr.
                --
                -- Er bleibt trotzdem versorgt - 'CDR - T3 Power'
                -- (Loud_AI_ACU_Builders.lua Z. 344) ist nicht gesperrt, und
                -- ein T2-Kraftwerk hat er ohnehin nicht im Programm.
                'CDR - T1 Power',
            },
        },

        {
            -- ⚠ KORREKTUR 2026-08-08: vorher hing diese Zahl an den
            -- T2-Technikern (`T2KraftwerkeNachTechnikern`, ein Kraftwerk je
            -- zwei Techniker). Das ergab im Spiel nur EIN Kraftwerk statt vier.
            --
            -- Ursache: 'Engineer T2 - Standard' baut nur nach, wenn KEIN
            -- T2-Techniker untaetig im Pool liegt
            -- (PoolLessAtLocation { 'LocationType', 1, ... TECH2 },
            -- Loud_AI_Factory_Engineer_Builders.lua Z. 161). Die Technikerzahl
            -- waechst dadurch sehr langsam - und die Kraftwerke hingen daran.
            --
            -- Jetzt eine schlichte Obergrenze. Die Technikerregel unten haengt
            -- weiterhin an den Kraftwerken, aber nicht mehr umgekehrt - damit
            -- ist die gegenseitige Blockade aufgeloest.
            Name          = "T2-Kraftwerke hoechstens 4",
            Bedingung     = 'WenigerAlsT2Kraftwerke',
            BedingungWert = 4,
            Builder = {
                'T2 Power Template',
                'T2 Power - Naval',
            },
        },

        {
            -- ----------------------------------------------------------------
            -- KEIN T2-KRAFTWERK MEHR, SOBALD EIN T3 STEHT
            --
            -- Vorgabe: "sobald T3 verfuegbar ist, keine T2-Kraftwerke mehr
            -- bauen." Dieselbe Logik wie eine Stufe tiefer:
            --
            --   T1-Kraftwerk     20 Energie/s
            --   T2-Kraftwerk    500 Energie/s
            --   T3-Kraftwerk   2500 Energie/s
            --
            -- LOUD hat dafuer eine eigene Regel - 'T2 Power Template' gibt 12
            -- zurueck, sobald ein T3-Kraftwerk gemeldet wird
            -- (Loud_AI_Engineer_Energy_Builders.lua Z. 101-113). Sie laesst
            -- aber zwei Luecken:
            --
            --   sie zaehlt nur FERTIGE Kraftwerke - zwischen Baubeginn und
            --   Fertigstellung eines T3 kann noch ein T2 dazukommen
            --
            --   sie gilt je BASIS (UnitsGreaterAtLocation) - an einem
            --   Aussenposten ohne eigenes T3 laufen die T2-Bauer weiter
            --
            -- Unsere Bedingung zaehlt armeeweit und einschliesslich Baustelle
            -- und schliesst damit beide.
            -- ----------------------------------------------------------------
            Name      = "T2-Kraftwerke nur bis zum ersten T3",
            Bedingung = 'KeinT3Kraftwerk',
            Builder = {
                'T2 Power Template',
                'T2 Power - Naval',
            },
        },

        -- ----------------------------------------------------------------
        -- TECHNIKERPLAN
        --
        -- Obergrenze 10 je Stufe. Zusaetzlich:
        --
        -- T1  2 Stueck, dazu 2 je Extraktor ab Stufe 2.
        -- T2  2 je stehendem T2-Kraftwerk plus 2 Vorlauf. Zusammen mit
        --     'T2-Kraftwerke nach T2-Technikern' ergibt das die Abfolge
        --     2 Techniker, 1 Kraftwerk, 2 Techniker, 1 Kraftwerk.
        -- T1 und T2 werden **nicht mehr nachgebaut, sobald eine Fabrik der
        --     Stufe 3 steht** - ab dann wird nur noch T3 aufgefuellt.
        -- T3  immer auf 10 aufstocken, SCU nicht mitgezaehlt. Deshalb
        --     zusaetzlich ein Prioritaetsboden von 900 auf den Nachbauern -
        --     'Engineer T3 - Standard' und '- Extra' liegen im Original bei
        --     650, nur 'Engineer T3 - Initial' bei 900, und der baut wegen
        --     'UseBuilderOnce' genau einmal.
        -- SCU der Rest, Deckel 20 in BaseSettings.
        --
        -- Mehrere Bedingungen an einem Builder werden UND-verknuepft; die
        -- Eintraege ergaenzen sich also.
        -- ----------------------------------------------------------------
        {
            -- ----------------------------------------------------------------
            -- T1-TECHNIKER IN STUFEN
            --
            -- Vorgabe des Nutzers:
            --   "als Mensch brauche ich erst nach 3 fertigen T2E neue Techniker,
            --    vorher wuerde denen die Masse fehlen zum Durchbauen. Dann +2.
            --    Nach 4 T2E nochmal +4 Techniker und auf die Storages."
            --
            --   ab 0 fertigen T2-Extraktoren   hoechstens 2
            --   ab 3                           hoechstens 4
            --   ab 4                           hoechstens 8
            --
            -- Ersetzt die alte Regel "2 + 2 je T2-Extraktor", die schon beim
            -- ERSTEN Aufstieg nachlegte - in Testlauf 22 kam der dritte
            -- Techniker auf Tick 2115, also viel zu frueh.
            -- ----------------------------------------------------------------
            Name          = "T1-Techniker in Stufen",
            Bedingung     = 'T1TechnikerStufen',
            BedingungWert = { {0,2}, {3,4}, {4,8} },
            Builder = {
                'Engineer T1 - Initial',
                'Engineer T1 - Initial - NoRush',
                'Engineer T1 - Standard',
            },
        },

        {
            Name          = "T2-Techniker vor jedem T2-Kraftwerk",
            Bedingung     = 'T2TechnikerVorKraftwerk',
            BedingungWert = 2,
            Builder = {
                'Engineer T2 - Initial',
                'Engineer T2 - Standard',
            },
        },

        {
            Name          = "T2-Techniker hoechstens 10",
            Bedingung     = 'HoechstensT2Techniker',
            BedingungWert = 10,
            Builder = {
                'Engineer T2 - Initial',
                'Engineer T2 - Standard',
            },
        },

        {
            Name      = "Kein T1/T2 mehr, sobald eine T3-Fabrik steht",
            Bedingung = 'KeineT3Fabrik',
            Builder = {
                'Engineer T1 - Initial',
                'Engineer T1 - Initial - NoRush',
                'Engineer T1 - Standard',
                'Engineer T2 - Initial',
                'Engineer T2 - Standard',
            },
        },

        {
            Name          = "T3-Techniker auf 10 aufstocken",
            Bedingung     = 'HoechstensT3Techniker',
            BedingungWert = 10,
            PrioritaetMin = 900,
            Builder = {
                'Engineer T3 - Initial',
                'Engineer T3 - Standard',
                'Engineer T3 - Extra',
            },
        },

        -- ----------------------------------------------------------------
        -- WAS EIN FREIER TECHNIKER TUT
        --
        -- Alle Unterstuetzungsaufgaben liegen im Original zwischen 720 und
        -- 750, also unter den Bauaufgaben - das ist richtig so und bleibt:
        -- sie greifen, wenn nichts Wertvolleres ansteht. Geaendert wird nur
        -- die Reihenfolge UNTEREINANDER.
        --
        --   848  Assist ACU SACU        SCU-Ausbau, also RAS zuerst
        --   844  Assist Mass - NoRush   Extraktoren und deren Aufstieg (Kopie)
        --   842  Assist Energy          Kraftwerke
        --   838  Eng Assist Structure   alles Uebrige, darunter das Quantentor
        --
        -- 'Assist ACU SACU' steht damit sogar ueber den nahen Extraktoren
        -- (850 liegt knapp darueber, 845/846 darunter) - bewusst: ein SCU im
        -- Ausbau ist die teuerste und lohnendste Investition, die die KI hat.
        -- ----------------------------------------------------------------
        {
            -- ----------------------------------------------------------------
            -- DER KOMMANDANT IN DER FRUEHPHASE
            --
            -- Vorgabe des Nutzers nach Testlauf 19:
            --   bis alle vier Extraktoren auf T2 sind, ist der ACU ALLEIN fuer
            --   die T1-Kraftwerke zustaendig. Ab dann darf und soll er die
            --   Aufstiege T2 -> T3 unterstuetzen.
            --
            -- Das deckt sich mit seinem Referenzlog: der ACU baut dort
            -- durchgehend Kraftwerke (Tick 338, 474, 610, 746, 882, 1092, ...)
            -- und unterstuetzt kein einziges Mal; die Extraktoren machen
            -- ausschliesslich die Techniker.
            --
            -- 'MindestensT2Extraktoren = 4' trifft genau den Umschaltpunkt:
            -- solange noch ein Extraktor auf T1 steht, laufen T1 -> T2-Aufstiege,
            -- und die soll der ACU nicht anfassen. Sind alle vier auf T2,
            -- bleiben nur noch T2 -> T3.
            --
            -- Prioritaet 790 liegt ueber 'CDR - T1 Power' (780) - ab dem
            -- Umschaltpunkt hat die Unterstuetzung also Vorrang. Der ACU bleibt
            -- dabei in Basisnaehe: 'CDR Assist Mass' traegt
            -- BuildingGreaterAtLocationAtRange { ..., 36 } und
            -- Assist.AssistRange = 48.
            -- ----------------------------------------------------------------
            Name          = "ACU unterstuetzt ab dem vierten T2-Extraktor",
            Bedingung     = 'MindestensT2Extraktoren',
            BedingungWert = 4,
            PrioritaetMin = 790,
            Builder = {
                'CDR Assist Mass',
            },
        },

        {
            -- ----------------------------------------------------------------
            -- KEINE EXTRAKTOREN VOM KOMMANDANTEN
            --
            -- Im Referenzlog baut der Mensch JEDEN Extraktor mit einem
            -- Techniker (uel0105), keinen einzigen mit dem ACU. Die
            -- Arbeitsteilung ist eindeutig: ACU = Kraftwerke, Techniker =
            -- Extraktoren.
            --
            -- 'CDR - Mass Extractor' liegt im Original bei 775, also knapp
            -- unter 'CDR - T1 Power' (780) - er wuerde einspringen, sobald
            -- gerade kein Kraftwerk faellig ist. Genau das soll er nicht.
            --
            -- Ab dem vierten T2-Extraktor wieder frei: dann ist die
            -- Eroeffnung durch und der ACU darf mitbauen.
            -- ----------------------------------------------------------------
            Name          = "Extraktoren nur von Technikern",
            Bedingung     = 'MindestensT2Extraktoren',
            BedingungWert = 4,
            Builder = {
                'CDR - Mass Extractor',
            },
        },

        -- ================================================================
        -- STARTPHASE GEGEN EXPANSIONSPHASE
        --
        -- Die beiden Abschnitte sind ueber die No-Rush-Frist getrennt:
        --
        --   STARTPHASE   bis Anteil 1.0, also bis zum Ablauf der Frist
        --                Nur die vier Massepunkte im Basisumkreis
        --                (StartMassepunkte = 4, MaxRange = 100), zwei bis acht
        --                Techniker in Stufen, der ACU baut allein die
        --                T1-Kraftwerke. Kein Ausbau nach aussen.
        --
        --   EXPANSIONSPHASE ab Anteil 1.0
        --                Die 750er- und 1500er-Staffel wird frei, Aussenposten
        --                entstehen. Fuer JEDEN neuen Extraktor gilt dieselbe
        --                Kette wie in der Startphase:
        --                T1 bauen > auf T2 > Speicher rundherum > auf T3.
        --
        -- Die Kette gilt in beiden Phasen, weil sie an den Aufstiegsregeln
        -- haengt (FabrikAufstieg..., ExtraktorAufstiegT3ErstVollUmbaut,
        -- SpeicherAufstiegAbT3Extraktoren) und diese je Einheit pruefen, nicht
        -- je Phase.
        -- ================================================================

        -- ----------------------------------------------------------------
        -- EXPANSION ERST NACH ABLAUF DER FRIST
        --
        -- Vorgabe: "Expansion ab Ende No-Rush". Vorher ist ausserhalb des
        -- Kreises ohnehin nichts zu holen.
        --
        -- Anteil 1.0 heisst: Freigabe genau mit Ablauf der Frist. Bei
        -- No-Rush 'Off' ergibt NoRushDauer() null und die Sperre entfaellt -
        -- dann expandiert die KI wie LOUD, was fuer Partien ohne Frist richtig
        -- ist.
        --
        -- LOUD unterscheidet die Aussenposten bereits nach Markertyp der Karte,
        -- und zwar genau nach den gewuenschten Kriterien:
        --
        --   'Large Expansion Area' -> Loud_Expansion_Standard
        --        volle Basis: Fabriken, Verteidigung, Radar, Schilde,
        --        Artillerie, T4. EngineerCount 2/3/4/9.
        --
        --   'Expansion Area'       -> Loud_Expansion_Small / _Tiny
        --        kleine Basis: je eine Fabrik, Extraktoren, Speicher, Radar.
        --        EngineerCount 1/2/2/2.
        --
        --   'Defensive Point'      -> Loud_DP_Standard / _Small
        --        genau der Fall "einzelner Extraktor": nur
        --        'Engineer Defenses DP Standard',
        --        'Engineer Mass Builders - Defensive Point' und
        --        'Engineer Mass Storage Construction - Active DP'.
        --        KEINE Fabrikbauer, EngineerCount Tech1 = 0.
        --
        -- Eine eigene Unterscheidung ist damit nicht noetig - nur die
        -- Zeitsperre.
        -- ----------------------------------------------------------------
        {
            Name   = "Expansion erst nach No-Rush",
            Anteil = 1.0,
            Gruppen = {
                'Engineer Construction - Land Base',
                'Engineer Construction - Land DP',
                'Engineer Construction - Naval Base',
                'Engineer Construction - Naval DP',
            },
        },

        {
            -- ----------------------------------------------------------------
            -- KAMPFEINHEITEN ERST NACH TECHNIKERN UND TOR
            --
            -- Vorgabe: "zuerst die 10 T3-Techniker und das QG anfangen, bevor
            -- Kampfeinheiten kommen."
            --
            -- Gilt ZUSAETZLICH zur Phasengrenze aTruppen (75 Prozent der
            -- Frist) - beide Bedingungen werden UND-verknuepft. Aufklaerung
            -- und Transporter bleiben ausgenommen, sie haengen an ihren
            -- eigenen Regeln.
            --
            -- ⚠ Wenn Tor oder Techniker ausbleiben, baut die KI GAR KEINE
            -- Kampfeinheiten. Das Tor haengt an 2500 Energie je Sekunde, die
            -- T3-Techniker an der T3-Fabrik, und die wiederum jetzt an vier
            -- T3-Extraktoren. Eine lange Kette - im Testlauf beobachten, ob sie
            -- vor Ablauf der Frist durchlaeuft.
            -- ----------------------------------------------------------------
            Name          = "Kampfeinheiten erst nach T3-Technikern und Tor",
            Bedingung     = 'TechnikerUndTorStehen',
            BedingungWert = 10,
            Gruppen = {
                'Factory Production Air - Fighters',
                'Factory Production Air - Bombers',
                'Factory Production Air - Gunships',
                'Factory Production Air - Torpedo Bombers',
            },
        },

        {
            -- ----------------------------------------------------------------
            -- GAR KEIN LAND
            --
            -- Vorgabe: "unser Air Force General will kein Land."
            --
            -- Bisher waren Landeinheiten nur ZEITLICH gesperrt (Phase 4, ab
            -- 75 Prozent der Frist) und Landfabriken dauerhaft. Ohne Fabrik
            -- entstehen zwar ohnehin keine Landeinheiten - aber die Regel soll
            -- ausgesprochen sein und nicht als Nebenwirkung gelten.
            --
            -- 'Engineer Construction - Land Base' und '- Land DP' gehoeren
            -- ausdruecklich NICHT hierher: das sind Aussenposten AN LAND,
            -- keine Landeinheiten. Die braucht auch eine Luftwaffe.
            --
            -- Die Verbandsbildung ('Land Formations - *') bleibt ebenfalls
            -- frei - ohne Landeinheiten bildet sie nichts, und eine Sperre
            -- waere nur eine weitere Zeile ohne Wirkung.
            -- ----------------------------------------------------------------
            Name      = "Keine Landeinheiten, niemals",
            Bedingung = 'Nie',
            Gruppen = {
                'Factory Production Land',
                'Factory Production Land - Land Only Map',
                'Factory Production Land - Water Map',
                'Engineer T4 Construction Land',
                'Engineer T4 Construction Land - Expansions',
            },
        },

        {
            -- ----------------------------------------------------------------
            -- NIEMALS EINEN T2-EXTRAKTOR DIREKT BAUEN
            --
            -- Vorgabe: "nicht T3 bauen, sondern immer brav die Buildorder
            -- durchziehen" - also T1 setzen und aufsteigen lassen, weil das
            -- schneller mehr Masse bringt als der teure Direktbau.
            --
            -- LOUD hat dafuer eigene Bauer, die einen fertigen T2-Extraktor
            -- aus dem Nichts setzen (Loud_AI_Engineer_Mass_Builders.lua):
            --
            --   Z. 262  Mass Extractor T2 - 750 - Loop - BuildClose  (MAIN)
            --   Z. 449  Mass Extractor T2 - 250 - DP
            --   Z. 537  Mass Extractor T2 - 750 - Loop - Expansion
            --   Z. 637  Mass Extractor T2 - 750 - Loop - Naval
            --
            -- Sie greifen erst spaeter, wenn T2-Techniker da sind - also genau
            -- in der Expansionsphase, um die es hier geht. Alle vier dauerhaft
            -- aus; damit laeuft jeder Massepunkt ueber T1 und die Aufstiege.
            -- ----------------------------------------------------------------
            Name      = "Keine T2-Extraktoren aus dem Nichts",
            Bedingung = 'Nie',
            Builder = {
                'Mass Extractor T2 - 750 - Loop - BuildClose',
                'Mass Extractor T2 - 250 - DP',
                'Mass Extractor T2 - 750 - Loop - Expansion',
                'Mass Extractor T2 - 750 - Loop - Naval',
            },
        },

        -- ----------------------------------------------------------------
        -- IN DER EROEFFNUNG BAUEN TECHNIKER NUR EXTRAKTOREN
        --
        -- ⚠ TESTLAUF 21: die Startmassepunkte sind gekuerzt und die vier
        -- Extraktoren stehen nah (57, 25, 46, 43). Danach taten die Techniker
        -- aber Dinge, die laut Vorgabe dem Kommandanten gehoeren:
        --
        --   tick 1093  Eng 2097156  T1 Power Template   -> 20
        --   tick 1185  Eng 2097156  T1 Power Template   -> 13
        --   tick 1219  Eng 2097154  Hydrocarbon         -> 105
        --
        -- Vorgabe war: "vorher ist er [der ACU] alleine fuer die paar
        -- T1-Kraftwerke zustaendig". Der Kommandant baut sie ueber
        -- 'CDR - T1 Power' - ein eigener Builder. 'T1 Power Template' ist der
        -- Technikerbauer und gehoert bis zum vierten T2-Extraktor gesperrt.
        --
        -- Hydrokarbon ebenso: 105 Entfernung ist weit ausserhalb der
        -- Eroeffnung, und es ist keine Extraktorarbeit.
        --
        -- Ab dem vierten T2-Extraktor beides frei - dann beginnt die Phase,
        -- in der die Techniker ohnehin Strom bauen sollen.
        -- ----------------------------------------------------------------
        {
            Name          = "Techniker: nur Extraktoren bis zum vierten T2",
            Bedingung     = 'MindestensT2Extraktoren',
            BedingungWert = 4,
            Builder = {
                'T1 Power Template',
                'Hydrocarbon',
                'Hydrocarbon - Expansion',
            },
        },

        -- ----------------------------------------------------------------
        -- DIE PHASE T2 -> T3 (Dokumentation, kein Eingriff)
        --
        -- Vorgabe des Nutzers: waehrend der T2 -> T3-Aufstiege bauen die
        -- Techniker Strom - also T2-Kraftwerke - und unterstuetzen den
        -- Aufstieg. Das ergibt sich bereits aus den vorhandenen Werten;
        -- hier steht nur, WARUM die Reihenfolge stimmt, damit sie beim
        -- naechsten Umbau nicht versehentlich zerstoert wird.
        --
        -- Rangfolge der Technikeraufgaben in dieser Phase:
        --
        --   900  T2 Power Template          Strom zuerst - der Aufstieg haengt
        --                                   am Energietrend (SelfUpgradeThread,
        --                                   defaultunits.lua Z. 813)
        --   852  Assist Mass - NoRush       den Aufstieg unterstuetzen
        --   850  Mass Extractor T1 - 250    faellt hier ohnehin aus: im
        --                                   No-Rush-Radius ist kein Punkt mehr
        --                                   frei, die Bedingung scheitert
        --   848  Assist ACU SACU
        --   843  Mass Storage 600 - NoRush  Speicher fuer die Adjazenz
        --   842  Assist Energy
        --   745  neue Fabriken              bewusst ganz unten
        --
        -- Alles, was sonst stoeren koennte, ist zu diesem Zeitpunkt bereits
        -- gesperrt: entfernte Extraktoren (Anteil 1.0), Verteidigung
        -- (Phasen 2 und 3), Einheiten (Phase 4), Air Staging (Anteil 1.0).
        --
        -- Die T2-Kraftwerke selbst sind auf vier begrenzt
        -- (WenigerAlsT2Kraftwerke), danach uebernimmt T3.
        --
        -- DANACH: SOBALD T3-TECHNIKER DA SIND
        --
        -- Zu diesem Zeitpunkt sind die Extraktoraufstiege durch - es gibt
        -- nichts mehr zu unterstuetzen. Die Rangfolge kippt deshalb:
        --
        --   905  Quantum Gate - NoRush      zuerst das eine Tor
        --   900  T2 Power Template          dann Strom
        --   851  T3 Power Template
        --
        -- Deshalb steht das Tor auf 905 und nicht mehr auf 855: mit 855 lag es
        -- unter T2 Power und der erste T3-Techniker haette Kraftwerke gebaut.
        -- ----------------------------------------------------------------

        {
            -- 'Assist ACU SACU' laeuft jetzt als Kopie 'Assist SCU - NoRush'
            -- ohne den Kommandanten - siehe Kopien. Das Original wird dabei
            -- automatisch gesperrt, der Boden steht in der Kopie.
            Name          = "Freie Techniker: SCU-Ausbau zuerst (siehe Kopien)",
            Builder = {},
        },

        {
            Name          = "Freie Techniker: dann Strom",
            PrioritaetMin = 842,
            Builder = {
                'Assist Energy',
            },
        },

        {
            Name          = "Freie Techniker: dann alles Uebrige",
            PrioritaetMin = 838,
            Builder = {
                'T1 Assist Structure/Exp',
                'Eng Assist Structure/Exp',
            },
        },

        -- ----------------------------------------------------------------
        -- KEINE SPEICHER, BEVOR NICHT ALLE VIER EXTRAKTOREN AUF T2 SIND
        --
        -- Beobachtung aus Testlauf 7: die Ingenieure bauten Speicher, statt
        -- den Extraktoraufstieg zu unterstuetzen.
        --
        -- Der Prioritaetsboden allein reichte nicht - Speicher kosten Masse
        -- und druecken damit den Massetrend, an dem SelfUpgradeThread haengt.
        -- Ein Speicher, der zu frueh gebaut wird, verzoegert also genau den
        -- Aufstieg, den er beschleunigen soll.
        --
        -- Danach laufen sie mit Tempo an: die Kopie hat Prioritaet 843 und
        -- vier Instanzen statt zwei.
        -- ----------------------------------------------------------------
        {
            -- ⚠ ZURUECK AUF 4 (Vorgabe nach Testlauf 22):
            --
            --   "nach 4 T2E nochmal +4 Techniker und auf die Storages"
            --
            -- Zwischenzeitlich stand hier 1, abgeleitet aus "jeder Extraktor
            -- fuer sich T1 > T2 > Storage > T3". Das war eine Fehldeutung:
            -- die Reihenfolge gilt pro Extraktor, der EINSTIEG in den
            -- Speicherbau aber erst, wenn alle vier auf T2 stehen. Danach
            -- entscheidet der Aufstiegsriegel je Extraktor, wann er weiter darf.
            Name          = "Speicher erst ab 4 Extraktoren auf T2",
            Bedingung     = 'MindestensT2Extraktoren',
            BedingungWert = 4,
            Builder = {
                'Mass Storage 600',
                'Mass Storage 600 - NoRush',
                'Mass Storage 1024',
                'Mass Storage DP',
            },
            Gruppen = {
                'Engineer Mass Energy Construction',
                'Engineer Energy Storage Construction',
            },
        },

        {
            Name   = "Bodenabwehr minimal",
            Anteil = aBoden,
            Builder = {
                'T2 Base PD - Base Template',
                'T2 Base PD - Expansion',
                'T2 Extractor Defense',
                'T3 Extractor Defense',
            },
        },

        -- ----------------------------------------------------------------
        -- Phase 3b: NEUE FABRIKEN
        --
        -- Zwei Wirkungen in einem Eintrag:
        --
        --   Anteil     bis dahin gar keine neuen Fabriken
        --   Prioritaet danach dauerhaft hinter der Wirtschaft
        --
        -- Die ERSTE Fabrik ist davon nicht betroffen - die baut der ACU aus
        -- 'ACU Tasks - Start Game' ('CDR Initial Large Map' baut T1AirFactory,
        -- 'CDR Initial Small Map' und 'CDR Initial Threat Nearby' T1LandFactory,
        -- Loud_AI_ACU_Builders.lua ab Z. 126). Diese Gruppe ist nirgends
        -- gesperrt. Ohne Fabrik gaebe es keine Ingenieure und keinen Techaufstieg.
        --
        -- Ebenfalls NICHT betroffen:
        --   'Land/Air Factory Rebuild'  Prioritaet 10 im Original, ersetzen nur
        --                               zerstoerte Fabriken - der Deckel greift
        --                               dort ohnehin nicht
        --   'Quantum Gate'              baut SCUs, also Ingenieure. Zaehlt hier
        --                               als Wirtschaft, nicht als Fabrik.
        --
        -- WARUM 745
        --
        -- GetHighestBuilder prueft nur das oberste Prioritaetsband
        -- (BuilderManager.lua, siehe CustomAI_Stellschrauben.md Ebene 4c).
        -- Wer niedriger steht, kommt erst dran, wenn oben nichts uebrig ist.
        -- Die Wirtschaftsbauer an MAIN liegen bei:
        --
        --   900  T2 Power Template
        --   851  T3 Power Template
        --   850  Mass Extractor T1 - 250 / Mass Fab T3
        --   846  Mass Extractor T1 - 750 - BuildClose
        --   845  Mass Extractor T1 - 750 - Loop
        --   840  Mass Extractor T2 - 750 / T3 Power - Perimeter
        --   800  Mass Fab T2
        --   762  Mass Energy Adjacency
        --   761  T1 Power Template
        --   760  Mass Extractor T1 - 1500 - Loop
        --   755  Mass Extractor T1 - 1500 - Loop - Extra
        --   750  Hydrocarbon / Mass Storage 600
        --   ---- 745 = unser Deckel fuer Fabriken ----
        --   740  Mass Storage 1024
        --   700  Energy Storage - HydroCarbon
        --
        -- Im Original stehen die Fabrikbauer bei 800/801 - also ueber T1-Power,
        -- ueber den entfernteren Massextraktoren und ueber Hydrokarbon.
        -- Mit 745 rutschen sie unter alles davon; oberhalb bleiben nur noch die
        -- beiden Speicherbauten.
        -- ----------------------------------------------------------------
        {
            Name       = "Neue Fabriken",
            Prioritaet = 745,

            -- ⚠ GEAENDERT (Testlauf 19): vorher Anteil = aBoden UND
            -- MindestensT3Extraktoren = 4. Beides ersetzt durch die
            -- Vorgabe des Nutzers:
            --
            --   "die zweite bis vierte Fabrik koennen kommen, sobald die
            --    erste auf T3 ist. QG ist zwar wichtiger, aber sonst wasten
            --    wir Masse."
            --
            -- Eine T3-Fabrik heisst: der Techaufstieg ist durch, die Wirtschaft
            -- traegt. Ab da sind weitere Fabriken kein verfruehter Massefresser
            -- mehr, sondern verhindern, dass Ueberschuss ungenutzt liegen
            -- bleibt.
            --
            -- Das Quantentor bleibt vorrangig, ohne dass es hier stehen muss:
            -- 'Quantum Gate - NoRush' hat Prioritaet 855, die Fabriken 745.
            Bedingung = 'T3FabrikVorhanden',

            Builder = {
                -- Hauptbasis
                'Land Factory Balance',
                'Air Factory Balance',
                'Land Factory - High Air Production Ratio',
                'Air Factory - Land Ratio High',
                -- Aussenposten
                'Land Factory Balance - Expansion',
                'Air Factory Balance - Expansion',
                'Land Factory - High Air Production Ratio - Expansion',
                -- Marine
                'Naval Factory Builder',
            },
        },

        {
            Name   = "Truppen, Aufklaerung und schweres Geraet",
            Anteil = aTruppen,
            Gruppen = {
                'Factory Production Land',
                'Factory Production Land - Land Only Map',
                'Factory Production Land - Water Map',
                'Factory Production Air - Scouts',
                'Factory Production Air - Fighters',
                'Factory Production Air - Bombers',
                'Factory Production Air - Gunships',
                'Factory Production Air - Transports',
                'Factory Production Air - Torpedo Bombers',
                'Engineer Artillery Construction T3',
                'Engineer Artillery Construction T4',
                'Engineer Nuke Construction',
                'Engineer Optics Construction',
                'Engineer T4 Construction Land',
                'Engineer T4 Construction Air - Land Map',
                'Engineer T4 Construction Air - Water Map',
            },
            -- Aufklaerung faellt seit 2026-08-08 ebenfalls in Phase 4.
            -- Waehrend No-Rush gibt es nichts aufzuklaeren; die Wirtschaft in
            -- Phase 1 haengt nicht daran (die Bedingungen dort sind
            -- ausschliesslich EBC-Lagerverhaeltnisse, keine LandRatio/AirRatio).
            -- Preis: die KI startet Phase 4 ohne jedes Feindwissen, Bedrohungs-
            -- karte und Angriffsplanung bauen sich erst danach auf. Deshalb
            -- liegt tTruppen bewusst VOR dem Ende des No-Rush-Zeitraums.
            --
            -- Die Verbandsbildung ('Land Formations - Scouts',
            -- 'Air Formations - Scouts') bleibt frei - ohne gebaute Aufklaerer
            -- bildet sie ohnehin nichts.
            -- der Rest der Bodenabwehr, in Phase 3 bewusst ausgelassen
            Builder = {
                'T3 Base PD - Base Template',
                'T3 Perimeter PD',
                'T4 Perimeter PD',
                'Experimental PD',
            },
        },
        {
            -- ----------------------------------------------------------------
            -- HOECHSTENS VIER LUFTFABRIKEN BIS ZUM ENDE DER FRIST
            --
            -- "zweite bis vierte Fabrik" - waehrend der No-Rush-Frist wird
            -- nichts produziert, mehr als vier waeren dann reine Massesenken.
            -- Danach gilt 8, also der Wert aus BaseSettings.FactoryCount.AIR.
            -- ----------------------------------------------------------------
            Name          = "Luftfabriken: 4 waehrend der Frist, danach 8",
            Bedingung     = 'LuftfabrikenGrenze',
            BedingungWert = { 4, 8 },
            Builder = {
                'Air Factory Balance',
                'Air Factory - Land Ratio High',
                'Air Factory Balance - Expansion',
            },
        },

        -- ----------------------------------------------------------------
        -- Phase 3c: DIE ZWEITE FABRIK
        --
        -- 'Land Factory Rebuild' und 'Air Factory Rebuild' heissen nur so.
        -- Ihre PriorityFunction (HaveZeroLandFactories / HaveZeroAirFactories,
        -- Loud_AI_Engineer_Factory_Builders.lua Z. 54-82) liefert nach 60
        -- Sekunden 990, sobald die KI von einem Typ KEINE Fabrik hat. Das ist
        -- LOUDs Garantie "mindestens je eine Land- und eine Luftfabrik", kein
        -- Ersatzbau - und genau die Quelle der zweiten Fabrik.
        --
        -- Auf Karten ueber 1024 baut der ACU eine Luftfabrik
        -- ('CDR Initial Large Map'), danach greift der Landfabrik-Bauer.
        --
        -- OHNE Prioritaetsdeckel: nach der Freigabe soll ihr Notfallwert von
        -- 990 unangetastet gelten. Eine KI ganz ohne Fabrik muss sofort eine
        -- bauen duerfen.
        --
        -- Der Ingenieurnachschub haengt nicht daran: die Luftfabrik hat
        -- 'BUILTBYTIER1FACTORY <Fraktion> MOBILE LAND CONSTRUCTION' in ihrer
        -- BuildableCategory (UEB0102_unit.bp Z. 95) und baut Ingenieure.
        -- ----------------------------------------------------------------
        {
            Name          = "Zweite Fabrik",
            Anteil        = aBoden,
            Bedingung     = 'MindestensT3Extraktoren',
            BedingungWert = 4,
            Builder = {
                'Land Factory Rebuild',
                'Land Factory Rebuild - Expansion',
                'Naval Factory Rebuild',
                -- ⚠ 'Air Factory Rebuild' ist hier NICHT mehr gesperrt.
                --
                -- Er feuert nur, wenn die KI GAR KEINE Luftfabrik hat
                -- (HaveZeroAirFactories, Loud_AI_Engineer_Factory_Builders.lua
                -- Z. 54-82). Fuer eine reine Luftwaffe waere das der Totalausfall:
                -- keine Fabrik, keine Techniker, kein Wiederaufbau.
                --
                -- Ausserdem baut der ACU auf Karten bis 1024 eine LANDfabrik
                -- ('CDR Initial Small Map') - und die ist bei uns dauerhaft
                -- gesperrt. Dort ist dieser Bauer der einzige Weg zu einer
                -- Luftfabrik ueberhaupt.
            },
        },

        -- ----------------------------------------------------------------
        -- DAUERHAFTE UMSORTIERUNG - keine Zeitsperre, nur Prioritaetsboden
        --
        -- Diese drei Eintraege haben weder Zeit noch Anteil noch Bedingung.
        -- Sie heben nur die Prioritaet an, damit die betroffenen Aufgaben
        -- frueher an die Reihe kommen.
        -- ----------------------------------------------------------------

        {
            -- 'Assist Mass' laeuft jetzt als eigene Kopie ohne die
            -- Lagerbedingung - siehe Kopien weiter unten. Das Original wird
            -- dabei automatisch gesperrt.
            --
            -- Dieser Eintrag bleibt leer und dient nur der Nachvollziehbarkeit.
            Name          = "Extraktoraufstieg unterstuetzen (siehe Kopien)",
            Builder = {},
        },

        {
            -- Massespeicher an die Extraktoren.
            --
            -- 'Mass Storage 600' laeuft jetzt als eigene Kopie (siehe Kopien
            -- weiter unten). Dieser Boden gilt nur noch fuer die uebrigen
            -- Bauer der Gruppe - 'Mass Storage 1024' und die IS-Fassung.
            --
            -- 'Mass Storage 600' baut ueber EngineerBuildMassAdjacencyAI vier
            -- Speicher direkt an einen Extraktor (Loud_AI_Engineer_Mass_Builders.lua
            -- Z. 841). Das bringt doppelt: Adjazenzbonus auf die Foerderung UND
            -- gelagerte Masse, die SelfUpgradeThread als Umgehung nutzt
            -- (masslimit .67 - wer 67 Prozent der Aufstiegskosten im Lager hat,
            -- darf aufsteigen). Speicher beschleunigen also den Weg zu T3.
            --
            -- Original 750 / 740 - damit knapp ueber unserem Fabrikdeckel, aber
            -- unter allem anderen. Mit 843 stehen sie neu:
            --   ueber  Mass Fab T2 (800), T1-Kraftwerk (761), die entfernten
            --          Extraktoren (760/755) und Hydrokarbon (750)
            --   unter  den nahen Extraktoren (845/846/850) und T2-Kraftwerk (900)
            -- Also: erst die nahen Massepunkte besetzen, dann Speicher, dann
            -- die weiter entfernten Punkte.
            Name          = "Massespeicher vorziehen",
            PrioritaetMin = 843,
            Gruppen = {
                -- ohne LOUD Integrated Storage
                'Engineer Mass Storage Construction',
                -- mit LOUD Integrated Storage - dann ersetzt diese Gruppe die obere
                -- (Loud_Main_Standard.lua, LOUD_IS_Installed_Builders)
                'Engineer Mass Energy Construction',
            },
        },

        {
            -- Das Quantentor laeuft jetzt als eigene Kopie mit gelockerter
            -- Energieschwelle (siehe Kopien). Das Original ist dabei
            -- automatisch gesperrt; die Boeden hier gelten nur noch fuer die
            -- beiden anderen Fassungen.
            Name          = "Quantentor vorziehen",
            PrioritaetMin = 855,
            Builder = {
                'Quantum Gate - Small Base',
                'Quantum Gate - Expansion',
            },
        },

        {
            -- SCU-Produktion.
            --
            -- 'Sub Commander' liegt schon bei 900, gleichauf mit den
            -- Initial-Ingenieuren - daran ist nichts zu verbessern. Er wird
            -- aber von BelowEngineerCapCheck('SCU') begrenzt; die Obergrenze
            -- steht in BaseSettings.EngineerCount.SCU (unten angehoben).
            --
            -- 'Sub Commander - Extra' laeuft ERST OBERHALB dieser Grenze und
            -- nur bei sehr guter Wirtschaft
            -- (GreaterThanEconTrendEfficiencyOverTime { 2, 60, 1.02, 1.04 }).
            -- Original 650, gleichauf mit 'Engineer T3 - Standard'. Mit 905
            -- laeuft die Nachproduktion durch, sobald die Bedingungen stimmen.
            --
            -- Beide sind FactoryBuilder in 'Factory Production - Engineers' -
            -- jener Gruppe, die in keiner Phase gesperrt ist - und beide haben
            -- BuilderType = {'Gate'}, brauchen also das Quantentor.
            Name          = "SCU-Nachproduktion vorziehen",
            PrioritaetMin = 905,
            Builder = {
                'Sub Commander - Extra',
            },
        },
    }
end

Definitions = {

    -- ====================================================================
    -- AI: LOUD Aeon Airforce General
    --
    -- Die Grundlage aller weiteren KIs dieses Mods. Sie enthaelt den
    -- vollstaendigen Phasenplan, den Kraftwerksplan, die Builder-Kopien und
    -- die SCU-Ausrichtung.
    --
    -- Die Phasen sind Anteile der No-Rush-Dauer; NoRush.lua liest die
    -- Einstellung zur Laufzeit aus ScenarioInfo.Options.NoRushOption.
    -- Bei 'Off' wird nichts gesperrt.
    --
    -- Die drei Testeintraege (Standard, Small, Smaller) sind am 2026-08-08
    -- entfallen - sie hatten nur belegt, dass `Source` umschaltbar ist.
    -- ====================================================================

    {
        Key       = 'customai_aeon_air',
        Name      = 'AI: LOUD Aeon Airforce',
        Source    = 'Loud_Main_Standard',
        Value     = 200,
        Customize = '/mods/customai/lua/AI/AIs/NoRush.lua',

        --                   Luft  Boden  Truppen   (Anteil der No-Rush-Dauer)
        Phasen = Phasenplan( 0.35,  0.55,    0.75 ),

        -- ----------------------------------------------------------------
        -- SCU-Obergrenze anheben
        --
        -- 'Sub Commander' (Prioritaet 900) laeuft nur, solange
        -- BelowEngineerCapCheck('SCU') wahr ist. Die Rechnung steht in
        -- UnitCountBuildConditions.lua Z. 699-743:
        --
        --   Grundwert   BaseSettings.EngineerCount.SCU
        --   mal Cheat   max( Grundwert, floor(Grundwert * CheatValue^2) )
        --   ab Einheitenlimit 1000 zusaetzlich
        --               + min( 1 + floor((Limit - 1000) / 300), 10 )
        --
        -- LOUDs 12 ergeben bei Limit 5000 und Cheat 1 also 22 SCUs.
        -- Mit 20 werden daraus 30.
        --
        -- Darueber hinaus baut nur noch 'Sub Commander - Extra', und der
        -- verlangt eine sehr gute Wirtschaft. Wer wirklich unbegrenzt SCUs
        -- will, muss hier weiter hochgehen - nicht an der Prioritaet drehen.
        -- ----------------------------------------------------------------
        BaseSettings = {
            EngineerCount = {
                -- Grosszuegig, damit der Technikerplan im Phasenteil den
                -- Ausschlag gibt und nicht LOUDs Deckel. BelowEngineerCapCheck
                -- rechnet zusaetzlich Cheatwert und Einheitenlimit drauf.
                Tech1 = 16,
                Tech2 = 16,
                Tech3 = 16,

                -- ------------------------------------------------------------
                -- SCU: KEINE OBERGRENZE
                --
                -- Vorgabe: "ich will definitiv kein Oberlimit fuer SCUs - je
                -- mehr desto besser."
                --
                -- BelowEngineerCapCheck verlangt eine Zahl
                -- (UnitCountBuildConditions.lua Z. 782), "unbegrenzt" gibt es
                -- dort nicht. 200 ist deshalb praktisch unbegrenzt: es liegt
                -- weit ueber jedem erreichbaren Einheitenlimit, zumal der Wert
                -- noch mit CheatValue^2 multipliziert wird (bei 1.3 also 1.69).
                --
                -- Gebremst wird die Produktion damit nur noch durch das, was
                -- sie ohnehin bremsen soll:
                --
                --   PoolLessAtLocation { 'LocationType', 2, SUBCOMMANDER }
                --       kein Nachbau, solange zwei SCU untaetig herumstehen
                --   GreaterThanEconTrendEfficiencyOverTime
                --       nur bei tragfaehiger Wirtschaft
                --   BuilderType = { 'Gate' }
                --       es braucht das Quantentor
                --   das Einheitenlimit der Partie
                --
                -- Nebenwirkung: 'Sub Commander - Extra' verlangt
                -- AboveEngineerCapCheck und feuert damit nie mehr. Er ist auch
                -- nicht noetig - 'Sub Commander' steht bei 900 und laeuft jetzt
                -- durchgehend.
                -- ------------------------------------------------------------
                SCU   = 200,
            },

            -- ------------------------------------------------------------
            -- Reine Luftwaffe: keine Land-, keine Marinefabriken,
            -- hoechstens 8 Luftfabriken.
            --
            -- FactoryCapCheck (UnitCountBuildConditions.lua Z. 656) liest
            -- diese Werte je Basis. LAND = 0 heisst: die Pruefung schlaegt
            -- immer fehl.
            --
            -- ACHTUNG: 'Land Factory Rebuild' prueft den Deckel NICHT.
            -- Er ist deshalb zusaetzlich im Phasenplan dauerhaft gesperrt.
            -- ------------------------------------------------------------
            FactoryCount = {
                LAND = 0,
                AIR  = 8,
                SEA  = 0,
                GATE = 1,
            },
        },

        -- ----------------------------------------------------------------
        -- SELBSTAUFSTIEGE VON STRUKTUREN
        --
        -- Wird NICHT von NoRush.lua ausgewertet, sondern von
        -- hook\lua\defaultunits.lua - Aufstiege sind keine Builder, sondern
        -- laufen ueber StructureUnit.LaunchUpgradeThread.
        --
        -- Fabrik T1 -> T2 erst ab 4 Extraktoren der Stufe 2 oder hoeher.
        -- Der Weg T2 -> T3 bleibt unangetastet.
        --
        -- Extraktor T2 -> T3 erst, wenn dieser Extraktor von Speichern umbaut
        -- ist. Geprueft wird JE EXTRAKTOR an den vier Nachbarplaetzen aus
        -- `MassAdjacency`: steht dort ein Speicher, oder ist der Platz gar
        -- nicht bebaubar, gilt er als erledigt. Ein Massepunkt am Wasser oder
        -- am Hang blockiert damit nicht.
        --
        -- Massespeicher T1 -> T2 erst ab 4 Extraktoren der Stufe 3.
        -- Speicher steigen ueber den Auffangzweig in defaultunits.lua
        -- Z. 877-883 auf (uab1106 hat UpgradesTo = 'uab2106').
        --
        -- Zusammen ergibt das die Reihenfolge:
        --   1. Extraktoren auf T2
        --   2. T1-Speicher rundherum
        --   3. Extraktoren auf T3
        --   4. Speicher auf T2
        -- ----------------------------------------------------------------
        FabrikAufstiegAbT2Extraktoren     = 4,

        -- Vorgabe: "das T3 Fabrikupgrade kommt zu frueh, erst nachdem
        -- Extraktoren auf T3 sind". Vor der T3-Wirtschaft bringt der teure
        -- Aufstieg nichts - waehrend der Frist wird ohnehin nichts produziert.
        FabrikAufstiegT3AbT3Extraktoren   = 4,

        ExtraktorAufstiegT3ErstVollUmbaut = true,
        SpeicherAufstiegAbT3Extraktoren   = 4,

        -- ----------------------------------------------------------------
        -- STARTMASSEPUNKTE
        --
        -- Ausgewertet von hook\lua\aibrain.lua.
        --
        -- LOUD teilt jeder KI beim Sitzungsstart `MassPointShare` Massepunkte
        -- fest zu (ScenarioUtilities.lua Z. 954 und 1036-1075), sortiert nach
        -- Entfernung zur Startposition. Solange diese Liste nicht leer ist,
        -- nimmt AIExecuteBuildStructure (aibuildstructures.lua Z. 97) stur den
        -- naechsten LISTENEINTRAG - `MaxRange` und `MaxChoices` werden dabei
        -- uebergangen, `MaxRange` sogar auf 1500 gesetzt.
        --
        -- Die Zahl ist grosszuegig: min( 12 + Spielerzahl, ... ). In Testlauf 20
        -- fuehrte das zu Wegen von 243 und 319.
        --
        -- 4 entspricht der Vorgabe "die ersten vier Extraktoren". Alles Weitere
        -- laeuft dann ueber den normalen Pfad, der MaxRange = 100 beachtet.
        -- ----------------------------------------------------------------
        StartMassepunkte = 4,

        -- ----------------------------------------------------------------
        -- GLEICHZEITIGE AUFSTIEGE
        --
        -- Ausgewertet von hook\lua\aibrain.lua.
        --
        -- LOUD erlaubt armeeweit einen Selbstaufstieg zur Zeit
        -- (ScenarioUtilities.lua Z. 970: UpgradeIssuedLimit = 1), mehr nur bei
        -- Unterzahl. SelfUpgradeThread prueft das vor jedem Aufstieg
        -- (aibehaviors.lua Z. 8732).
        --
        -- WAEHREND DER FRIST IST DAS RICHTIG. Vorgabe des Nutzers:
        --
        --   "fuer gleichzeitigen Aufstieg in der No-Rush haben wir nicht
        --    ansatzweise die Ressourcen. Der Clou ist immer einen zu pushen,
        --    der dann Ressourcen bringt, dann den naechsten."
        --
        -- Ein Aufstieg finanziert also den naechsten. Vier gleichzeitig wuerden
        -- sich gegenseitig verhungern lassen - die Engine verteilt anteilig,
        -- alle vier waeren viermal so langsam.
        --
        -- NACH DER FRIST traegt die Wirtschaft mehrere:
        --
        --   "in der Expansionsphase ist das kein Thema - pro vorhandenen
        --    T3-Extraktor kann ein weiterer locker gepusht werden."
        --
        -- Der Hook fuehrt die Grenze deshalb mit: waehrend der Frist 1, danach
        -- einer je vorhandenem T3-Extraktor, gedeckelt bei 8. LOUDs Zuschlag
        -- bei Unterzahl wird nie unterschritten.
        -- ----------------------------------------------------------------
        GleichzeitigeAufstiege = {
            WaehrendFrist = 1,
            JeT3Extraktor = 1,
            Hoechstens    = 8,
        },

        -- ----------------------------------------------------------------
        -- WARTEZEIT UNTAETIGER TECHNIKER
        --
        -- Ausgewertet von hook\lua\sim\EngineerManager.lua.
        --
        -- LOUD rechnet `min( 101, 14 + failedbuilds * 5 )` Ticks. `failedbuilds`
        -- waechst bei jedem vergeblichen Anlauf; nach rund 18 sind es 101 Ticks,
        -- also **zehn Sekunden** Stillstand, bevor er ueberhaupt wieder fragt.
        --
        -- Bei dieser KI passiert das oft, weil viele Auftraege an Bedingungen
        -- haengen. Der Wert deckelt `failedbuilds`:
        --
        --   2  ->  hoechstens 24 Ticks, also 2,4 Sekunden
        --
        -- Kleinere Werte heissen mehr Suchlaeufe und mehr Rechenzeit - die
        -- Wartezeit ist im Original ausdruecklich gegen genau das gedacht.
        --
        -- Deshalb gilt der Deckel nur bis zum Ende der No-Rush-Frist:
        -- solange hat die KI wenige Techniker und keine Aussenposten, da
        -- kostet haeufiges Suchen nichts. Danach laeuft LOUDs Original.
        --
        -- 'NoRush' liest die Lobbyeinstellung; eine Zahl waere Spielsekunden.
        -- Bei No-Rush 'Off' ergibt sich 0, der Deckel entfaellt dann ganz.
        -- ----------------------------------------------------------------
        TechnikerWartezeitFehlschlaege = 2,
        TechnikerWartezeitBis          = 'NoRush',

        -- ----------------------------------------------------------------
        -- DEBUG-SCHALTER
        --
        -- Ausgewertet von hook\lua\aibrain.lua. Es sind Felder in
        -- ScenarioInfo, gesetzt am Kopf von /lua/aibrain.lua Z. 13-74; sie
        -- gelten fuer die ganze Partie, nicht je KI.
        --
        -- ⚠ NUR FUER TESTLAEUFE. Diese Schalter erzeugen sehr viel Log.
        -- Vor dem naechsten normalen Spiel auf false setzen oder den ganzen
        -- Block auskommentieren.
        --
        -- Anlass: die Startbauordnung muss wasserdicht sein, und die letzten
        -- vier Ursachen liessen sich nur durch Quelltextlesen und Raten
        -- eingrenzen. Diese Schalter beantworten die offenen Fragen direkt:
        --
        --   EngineerDialog          welcher Techniker bekommt welche Aufgabe,
        --                           und warum keine
        --   PriorityDialog          jede Prioritaetsaenderung mit altem und
        --                           neuem Wert - zeigt, ob unsere Deckel und
        --                           Boeden ueberhaupt ankommen
        --   StructureUpgradeDialog  jeder Aufstieg mit Ausloeser und Schwelle
        --   NameEngineers           benennt die Techniker im Spiel um, damit
        --                           man sie im Bild wiedererkennt
        --
        --   ReferenzLog             KEIN LOUD-Schalter, sondern unserer.
        --                           Ausgewertet von hook\lua\defaultunits.lua:
        --                           schreibt mit, welche STRUKTUR ein
        --                           MENSCHLICHER Spieler wann beginnt.
        --                           Damit laesst sich die eigene Eroeffnung als
        --                           Zeitreihe gegen die der KI halten, statt
        --                           sie muendlich zu beschreiben.
        --                           Zeilenform:
        --                             CUSTOMAI Referenz: <Spieler> beginnt
        --                             <blueprint> (<Beschreibung>) durch
        --                             <Erbauer> auf Tick <n>
        -- ----------------------------------------------------------------
        DebugSchalter = {
            EngineerDialog         = true,
            PriorityDialog         = true,
            StructureUpgradeDialog = true,
            NameEngineers          = true,
            ReferenzLog            = true,
        },

        -- ----------------------------------------------------------------
        -- EIGENE BUILDER-KOPIEN
        --
        -- Fuer alles, was ueber Prioritaeten nicht erreichbar ist:
        -- BuilderConditions und InstanceCount. NoRush.lua legt je Kopie einen
        -- neuen Builder an, steckt ihn in eine eigene BuilderGroup und haengt
        -- diese an unser Template. Das Original wird automatisch dauerhaft
        -- gesperrt.
        --
        -- Leitsatz des Nutzers: Masse ausgeben fuer mehr Masse, wenn man Masse
        -- hat - immer.
        -- ----------------------------------------------------------------
        Kopien = {

            {
                -- Unterstuetzung beim Extraktoraufstieg.
                --
                -- ⚠ TESTLAUF 9: die Techniker halfen beim T1->T2-Aufstieg NICHT,
                -- beim T2->T3-Aufstieg dagegen schon. Ursache war nicht die
                -- Prioritaet, sondern die zweite Bedingung des Originals:
                --
                --   { EBC, 'GreaterThanEconStorageCurrent', { 150, 2500 }}
                --
                -- 2500 gelagerte ENERGIE. Zu Spielbeginn steht noch kein
                -- Kraftwerk, die Schwelle wird nie erreicht - erst spaeter,
                -- rechtzeitig zum T3-Aufstieg. Genau das Beobachtete.
                --
                -- Neu auf { 50, 200 } gelockert. Ganz streichen waere falsch:
                -- die Bedingung schuetzt davor, dass Unterstuetzung die
                -- Wirtschaft leerzieht.
                --
                -- LessThanEconMassStorageRatio { 60 } entfaellt weiterhin ganz -
                -- sie schaltete die Unterstuetzung genau dann ab, wenn das
                -- Masselager voll war.
                -- ⚠ PRIORITAET 852, NICHT 844 (Testlauf 13):
                --
                -- Der Log zeigt, dass beide T1-Techniker durchgehend mit
                -- 'Mass Extractor T1 - 250' beschaeftigt waren - Prioritaet
                -- **850**, also ueber unserer Unterstuetzung mit 844. Der
                -- Builder laeuft mit LoopBuild und beginnt nach jedem
                -- "ends loop due to resource shortage" von vorn. Solange freie
                -- Massepunkte in Reichweite liegen, kommt die Unterstuetzung
                -- damit NIE an die Reihe.
                --
                -- 852 stellt sie ueber den Extraktorbau. Sie greift nur,
                -- solange tatsaechlich etwas aufsteigt, und ist ueber
                -- BuilderData.Assist.Time auf 90 Sekunden begrenzt - der
                -- Extraktorbau verliert also nur waehrend eines Aufstiegs.
                Original      = 'Assist Mass',
                Name          = 'Assist Mass - NoRush',
                Prioritaet    = 852,
                Instanzen     = 6,
                OhneBedingung = { 'LessThanEconMassStorageRatio' },
                BedingungWerte = {
                    GreaterThanEconStorageCurrent = { 50, 200 },
                },

                -- ⚠ TESTLAUF 11 - vermutlich der eigentliche Grund:
                --
                --   { UCBC, 'BuildingGreaterAtLocationAtRange',
                --     { 'LocationType', 0, MASSPRODUCTION - TECH1,
                --       ENGINEER + MASSPRODUCTION, 120 }}
                --
                -- Das letzte Argument ist ein RADIUS um den Basispunkt.
                -- Steht der aufsteigende Extraktor weiter als 120 entfernt,
                -- ist die Bedingung falsch - es gibt aus Sicht des Builders
                -- nichts zu unterstuetzen. Auf grossen Karten liegen die
                -- Massepunkte regelmaessig weiter weg.
                --
                -- Dasselbe noch einmal in BuilderData.Assist.AssistRange:
                -- selbst wenn die Bedingung greift, sucht EngineerAssistAI nur
                -- innerhalb dieses Radius.
                --
                -- Beides auf 300. Das erklaert vermutlich auch den zweiten
                -- Befund: weil die Unterstuetzung nicht greift, faellt der
                -- Techniker auf die naechstniedrige Aufgabe zurueck - und das
                -- sind die entfernten Massextraktoren (760/755). Genau das war
                -- im Bild zu sehen.
                BedingungArgAendern = {
                    BuildingGreaterAtLocationAtRange = { [5] = 300 },
                },
                BuilderDatenWerte = {
                    Assist = {
                        AssistRange = 300,
                    },
                },

                -- Original NICHT sperren: die Kopie haengt nur am
                -- MAIN-Template, die Sperre wuerde aber armeeweit gelten und
                -- damit auch an Aussenposten die Unterstuetzung abschalten.
                OriginalSperren = false,
            },

            {
                -- Extraktorbau: nach JEDEM Extraktor neu entscheiden.
                --
                -- ⚠ TESTLAUF 14 - das ist der eigentliche Grund, warum die
                -- Unterstuetzung nie zustande kam. platoon.lua Z. 8872-8898:
                --
                --   if self.PlatoonData.Construction.LoopBuild and self.PlanName then
                --       if GetEconomyStored(aiBrain,'MASS') >= LoopMass
                --          and (GetEconomyStoredRatio(aiBrain,'MASS')*100) < 75 then
                --           if GetEconomyStored(aiBrain,'ENERGY') >= LoopEnergy then
                --               self:SetAIPlan( self.PlanName, aiBrain )
                --               return
                --
                -- Mit LoopBuild startet das Platoon denselben Builder erneut -
                -- OHNE ueber GetHighestBuilder zu gehen. 'Mass Extractor T1 - 250'
                -- hat LoopMass = 1 und LoopEnergy = 500; beides ist praktisch
                -- immer erfuellt.
                --
                -- Beleg aus dem Log: die beiden Techniker bekamen ihre Aufgabe
                -- auf Tick 420 und 504 - und danach nie wieder ein "adding".
                -- Der erste Extraktoraufstieg begann auf Tick 1260. Zu diesem
                -- Zeitpunkt hat kein Techniker mehr gefragt, was zu tun ist.
                --
                -- Deshalb war jede Prioritaetsaenderung wirkungslos: die Wahl
                -- wurde nie erneut getroffen.
                --
                -- LoopBuild = false heisst: nach jedem Extraktor geht der
                -- Techniker ueber ReturnToBaseAI zurueck in den Pool und waehlt
                -- neu. Dann kann 'Assist Mass - NoRush' (852) den Extraktorbau
                -- (850) schlagen.
                --
                -- PREIS: der Techniker laeuft zwischen den Extraktoren zur
                -- Basis zurueck. Bei Entfernungen von 50 bis 200 kostet das
                -- Zeit. Falls es zu traege wird, waere die Alternative, den
                -- Aufstieg ueber DesiresAssist/NumAssistees anzufordern statt
                -- ueber die Aufgabenwahl - dafuer muesste der Hook auf
                -- defaultunits.lua erweitert werden.
                Original   = 'Mass Extractor T1 - 250',
                Name       = 'Mass Extractor T1 - 250 - NoRush',
                BuilderDatenWerte = {
                    Construction = {
                        LoopBuild = false,

                        -- ⚠ TESTLAUF 17: der Builder schickte Techniker 194 und
                        -- 341 weit, obwohl MaxRange auf 250 stand. Alles
                        -- ausserhalb des No-Rush-Kreises ist ohnehin sinnlos -
                        -- dort kann waehrend der Frist niemand expandieren.
                        --
                        -- 'NoRushRadius' wird von NoRush.lua durch
                        -- ScenarioInfo.norushradius ersetzt. Das Feld steht in
                        -- der Szenariodatei jeder Karte, z. B.
                        -- maps\LostTemple\losttemple_scenario.lua Z. 15:
                        --   norushradius = 52
                        --
                        -- Damit begrenzt sich der Extraktorbau von selbst auf
                        -- den Bereich, in dem gebaut werden darf - kartenweise
                        -- richtig statt geraten.
                        MaxRange = 'NoRushRadius',

                        -- ⚠ TESTLAUF 19: der 250er-Bauer hatte als einziger KEIN
                        -- MaxChoices - gesetzt war es nur bei den 750er- und
                        -- 1500er-Kopien. Ohne den Wert waehlt LOUD nicht den
                        -- naechsten Punkt:
                        --
                        --   tick 422  Eng 2097154  Entfernung 57
                        --   tick 506  Eng 2097156  Entfernung 25
                        --
                        -- Der erste Techniker nahm den 57 weit entfernten Punkt,
                        -- obwohl der 25 weite noch frei war. Genau die Beobachtung
                        -- "es wird nicht der naechste angefahren".
                        MaxChoices = 1,
                    },
                },

                -- Karte ohne norushradius: 'rockbottom' bringt das Feld nicht
                -- mit. Dann gilt dieser Wert statt LOUDs 250.
                --
                -- 100 ist gewaehlt, weil die vier nahen Massepunkte in
                -- Testlauf 19 zwischen 25 und 57 lagen, die naechsten
                -- unerwuenschten aber bei 211 und 243. Der Wert trennt beides
                -- deutlich.
                NoRushRadiusStandard = 100,
            },

            {
                -- Extraktoren: zum NAECHSTEN Punkt, nicht zu irgendeinem.
                --
                -- ⚠ TESTLAUF 12 - die Antwort auf "warum nicht das dichteste
                -- Massefeld":
                --
                --   Loud_AI_Engineer_Mass_Builders.lua Z. 189
                --   MaxChoices = 6,   -- pick from list of up to 6 closest
                --
                -- LOUD waehlt ZUFAELLIG aus den sechs naechstgelegenen freien
                -- Punkten. Das streut die Basis absichtlich - fuer eine KI, die
                -- frueh Masse braucht, ist es aber genau falsch.
                --
                -- MaxChoices = 1 heisst: immer der naechste.
                --
                -- Der 750er-Bauer steht auf 4 (Z. 91), dieser hier auf 6.
                Original   = 'Mass Extractor T1 - 1500 - Loop',
                Name       = 'Mass Extractor T1 - 1500 - Loop - NoRush',
                BuilderDatenWerte = {
                    Construction = {
                        MaxChoices = 1,
                    },
                },
            },

            {
                Original   = 'Mass Extractor T1 - 750 - Loop - BuildClose',
                Name       = 'Mass Extractor T1 - 750 - BuildClose - NoRush',
                BuilderDatenWerte = {
                    Construction = {
                        MaxChoices = 1,
                    },
                },
            },

            {
                -- Anfangstechniker: hoechstens zwei statt drei.
                --
                -- ⚠ TESTLAUF 10: trotz Obergrenze 2 entstanden drei
                -- T1-Techniker. Die Ursache liegt nicht im Builder, sondern in
                -- seiner Platoon-Vorlage:
                --
                --   Loud_AI_Factory_Platoons.lua Z. 27
                --   PlatoonTemplate { Name = 'T1BuildEngineerInitial',
                --       Aeon = { { 'ual0105', 1, 3, 'Support', 'none' } }
                --
                -- Das dritte Feld ist die Hoechstzahl je Auftrag - der Builder
                -- erzeugt also DREI Techniker auf einen Schlag. Eine Bedingung
                -- wird einmal vor dem Auftrag geprueft und kann das nicht
                -- verhindern.
                --
                -- PlatoonMax kopiert die Vorlage und kappt das Feld auf 2.
                Original    = 'Engineer T1 - Initial',
                Name        = 'Engineer T1 - Initial - NoRush',
                PlatoonMax  = 2,
                Gruppentyp  = 'FactoryBuilder',
            },

            {
                -- Quantentor.
                --
                -- ⚠ KORREKTUR: das SPIEL verlangt kein bestimmtes
                -- Energieeinkommen fuers Tor - das tut nur LOUDs Bauregel:
                --
                --   Loud_AI_Engineer_Factory_Builders.lua Z. 726ff
                --   { LUTL, 'GreaterThanEnergyIncome', { 12600 }}
                --
                -- GreaterThanEnergyIncome rechnet
                -- GetEconomyIncome(aiBrain,'ENERGY') * 10, also Energie je
                -- SEKUNDE (loudutilities.lua Z. 119-121). 12600/s sind ohne
                -- T3-Kraftwerke praktisch unerreichbar:
                --
                --   Aeon-ACU mit RAS        2700/s   (UAL0001_unit.bp Z. 490)
                --   dieselbe Stufe 2        5400/s   (Z. 512)
                --   T2-Kraftwerk             500/s   (UAB1201_unit.bp Z. 149)
                --   T1-Kraftwerk              20/s   (UAB1101_unit.bp Z. 95)
                --
                -- ACU mit RAS plus vier T2-Kraftwerken sind rund 4700/s.
                -- LOUDs Schwelle setzt damit faktisch T3-Kraftwerke voraus -
                -- und die brauchen T3-Techniker, die eine T3-Fabrik brauchen.
                --
                -- Fuer diese KI gilt die Vorgabe des Nutzers: das Tor braucht
                -- nur Techniker, das ACU-RAS reicht. Schwelle deshalb auf
                -- 2500/s - erreichbar, sobald der ACU sein RAS hat.
                --
                -- BuilderType = {'T3','SubCommander'} bleibt: ein T3-Techniker
                -- muss es bauen.
                -- ⚠ PRIORITAET 905, NICHT 855 (Vorgabe nach Testlauf 19):
                --
                --   "Es gibt keine Aufstiege mehr, wenn T3-Techniker kommen.
                --    Die koennen erstmal das eine QG starten, bevor sie auf
                --    Strom gehen."
                --
                -- Mit 855 stand das Tor zwar ueber 'T3 Power Template' (851),
                -- aber UNTER 'T2 Power Template' (900). Solange die vier
                -- T2-Kraftwerke noch nicht stehen, haette der erste
                -- T3-Techniker also Kraftwerke gebaut statt das Tor zu setzen -
                -- genau die Reihenfolge, die nicht gewollt ist.
                --
                -- 905 stellt das Tor ueber beide Kraftwerksbauer. Es ist die
                -- einzige Aufgabe im Ingenieurmanager mit dieser Prioritaet;
                -- 'Sub Commander - Extra' und 'Engineer T3 - Standard' liegen
                -- zwar ebenfalls bei 900 bzw. 905, sind aber FactoryBuilder und
                -- damit in einer anderen Aufgabenliste.
                --
                -- Die Bedingungen des Tors bleiben die Bremse gegen einen zu
                -- frueh begonnenen Bau: 2500 Energie je Sekunde sowie 400 Masse
                -- und 5000 Energie im Lager.
                Original       = 'Quantum Gate',
                Name           = 'Quantum Gate - NoRush',
                Prioritaet     = 905,
                BedingungWerte = {
                    GreaterThanEnergyIncome = { 2500 },
                },
            },

            {
                -- Unterstuetzung fuer SCU - aber NICHT fuer den Kommandanten.
                --
                -- Vorgabe: "ACU-RAS und auch nur das soll nicht unterstuetzt
                -- werden."
                --
                -- Der Kommandant fordert die Unterstuetzung aktiv an:
                -- CDREnhance (aibehaviors.lua Z. 886-891) setzt beim Ausbau
                --   unit.DesiresAssist = true
                --   unit.NumAssistees  = 3
                -- und nimmt sie erst nach dem Ausbau zurueck (Z. 928-930).
                -- 'Assist ACU SACU' zieht daraufhin bis zu drei Techniker ab.
                --
                -- Die Kopie schliesst den Kommandanten aus beiden Stellen aus,
                -- an denen die Kategorie geprueft wird:
                --   BuilderData.Assist.AssisteeCategory
                --   LocationEngineerNeedsBuildingAssistanceInRange, Argument 2
                --
                -- 'EngineerOhneACU' loest NoRush.lua zu
                -- categories.ENGINEER - categories.COMMAND auf. Die SCU bleibt
                -- erfasst (SUBCOMMANDER ist ENGINEER, nicht COMMAND) - die
                -- Vorrangregel "bevorzugt SCU-RAS" gilt also unveraendert.
                --
                -- Ebenso unveraendert: die Bedingung KeinACUAusbau, die
                -- waehrend des Ausbaus 120 Bauer zurueckstellt.
                Original   = 'Assist ACU SACU',
                Name       = 'Assist SCU - NoRush',
                Prioritaet = 848,
                BuilderDatenWerte = {
                    Assist = {
                        AssisteeCategory = 'EngineerOhneACU',
                    },
                },
                BedingungArgAendern = {
                    LocationEngineerNeedsBuildingAssistanceInRange = { [2] = 'EngineerOhneACU' },
                },
            },

            {
                -- Aeon-Kommandant: beide RAS-Stufen hintereinander.
                --
                -- Vorgabe: "der Aeon Commander hat 2 Stufen RAS - die zweite
                -- bitte sofort nach der ersten starten."
                --
                -- LOUDs Liste kennt nur die erste
                -- (Loud_AI_ACU_Builders.lua Z. 999):
                --   Enhancement = { 'ResourceAllocation', 'AdvancedEngineering',
                --                   'EnhancedSensors' }
                --
                -- Die zweite Stufe heisst 'ResourceAllocationAdvanced'
                -- (UAL0001_unit.bp Z. 505-513) und traegt
                -- Prerequisite = 'ResourceAllocation' - sie kann also direkt
                -- folgen. Der Sprung ist erheblich:
                --
                --   ResourceAllocation          2700 Energie/s, 18 Masse/s
                --   ResourceAllocationAdvanced  5400 Energie/s, 36 Masse/s
                --
                -- Damit erreicht der ACU allein die 2500 Energie/s, die unsere
                -- gelockerte Quantentor-Bedingung verlangt - und noch einiges
                -- darueber.
                --
                -- CDREnhance arbeitet die Liste der Reihe nach ab, die
                -- Position bestimmt also die Abfolge.
                --
                -- ⚠ GILT NUR FUER AEON. Der Builder traegt FactionIndex = 2.
                -- Wird die KI in der Lobby auf eine andere Fraktion gestellt,
                -- greift diese Kopie nicht - dort bleibt LOUDs Liste.
                Original = 'Aeon CDR Upgrade',
                Name     = 'Aeon CDR Upgrade - NoRush',
                BuilderDatenWerte = {
                    Enhancement = {
                        'ResourceAllocation',
                        'ResourceAllocationAdvanced',
                        'AdvancedEngineering',
                        'EnhancedSensors',
                    },
                },
            },

            {
                -- Seraphim-Kommandant: ebenfalls zwei RAS-Stufen.
                --
                -- LOUDs Liste (Loud_AI_ACU_Builders.lua Z. 1061):
                --   { 'ResourceAllocation', 'AdvancedEngineering', 'RegenAura' }
                --
                -- XSL0001_unit.bp Z. 673 fuehrt 'ResourceAllocationAdvanced'
                -- mit Prerequisite = 'ResourceAllocation'.
                --
                --   ResourceAllocation          3000 Energie/s, 16 Masse/s
                --   ResourceAllocationAdvanced  6000 Energie/s, 32 Masse/s
                Original = 'Seraphim CDR Upgrade',
                Name     = 'Seraphim CDR Upgrade - NoRush',
                BuilderDatenWerte = {
                    Enhancement = {
                        'ResourceAllocation',
                        'ResourceAllocationAdvanced',
                        'AdvancedEngineering',
                        'RegenAura',
                    },
                },
            },

            -- ----------------------------------------------------------------
            -- UEF UND CYBRAN: NICHTS ZU TUN
            --
            -- Beide haben nur EINE RAS-Stufe - geprueft in den Blueprints:
            --
            --   UEL0001_unit.bp Z. 411   ResourceAllocation  3300 Energie/s, 14 Masse/s
            --   URL0001_unit.bp Z. 559   ResourceAllocation  3500 Energie/s, 12 Masse/s
            --
            -- Ein 'ResourceAllocationAdvanced' gibt es dort nicht. Und in
            -- beiden LOUD-Listen steht 'ResourceAllocation' bereits an erster
            -- Stelle:
            --
            --   UEF     { 'ResourceAllocation', 'Shield', 'AdvancedEngineering' }
            --   Cybran  { 'ResourceAllocation', 'AdvancedEngineering',
            --            'MicrowaveLaserGenerator' }
            --
            -- Eine Kopie waere eine Kopie ohne Aenderung.
            -- ----------------------------------------------------------------

            {
                -- SCU-Produktion ohne Untaetigkeitsbremse.
                --
                -- Vorgabe: "eine SCU ist sowohl Kraftwerk als auch
                -- Masseproduktion - Untaetigkeit ist KEIN Kriterium."
                --
                -- Das Original hat genau zwei Bedingungen
                -- (Loud_AI_Factory_Engineer_Builders.lua Z. 111-114):
                --
                --   { UCBC, 'PoolLessAtLocation', { 'LocationType', 2, SUBCOMMANDER }}
                --   { UCBC, 'BelowEngineerCapCheck', { 'LocationType', 'SCU' } }
                --
                -- Die erste stoppt den Nachbau, sobald zwei SCU untaetig im
                -- Pool liegen. Fuer gewoehnliche Techniker ist das richtig -
                -- fuer eine SCU mit ResourceAllocation nicht: sie produziert
                -- auch im Stehen Masse und Energie (Aeon-SCU siehe
                -- SCUSelfEnhanceThread, aibehaviors.lua Z. 8180).
                -- Eine untaetige SCU ist ein Kraftwerk, kein Leerlauf.
                --
                -- Bleibt: BelowEngineerCapCheck gegen
                -- BaseSettings.EngineerCount.SCU = 200, also praktisch nur das
                -- Einheitenlimit - und BuilderType = {'Gate'}.
                --
                -- ⚠ Damit gibt es keine wirtschaftliche Bremse mehr. Die
                -- Fabrik baut SCU, solange Masse da ist. Wenn die KI dadurch
                -- ins Stocken geraet, gehoert hier eine
                -- GreaterThanEconTrendEfficiencyOverTime-Bedingung ergaenzt,
                -- nicht die Untaetigkeitsbremse zurueck.
                Original      = 'Sub Commander',
                Name          = 'Sub Commander - NoRush',
                OhneBedingung = { 'PoolLessAtLocation' },
                Gruppentyp    = 'FactoryBuilder',
            },

            {
                -- Massespeicher.
                --
                -- ⚠ INSTANZEN VON 4 AUF 2 (Testlauf 18):
                --
                -- Im Log standen sieben Warnungen der Form
                --   Eng <n> Mass Storage 600 - NoRush fails CanBuildStructureAt
                --   { 759.5, 0, 410.5 } for "xsb1106"
                -- dreimal fuer DENSELBEN Punkt, von drei verschiedenen Technikern.
                --
                -- Eine fehlende Vorabpruefung ist NICHT die Ursache - die gibt es:
                -- AIBuildBaseTemplateOrdered (aibuildstructures.lua Z. 293) prueft
                -- CanBuildStructureAt, bevor der Platz in die Bauschlange kommt.
                --
                -- Aber sie prueft beim EINREIHEN, nicht beim Bauen. Danach laeuft
                -- der Techniker hin; ProcessBuildCommand (platoon.lua Z. 8797)
                -- prueft erneut - und inzwischen steht dort der Speicher eines
                -- ANDEREN eigenen Technikers. Ein Wettlauf, kein Logikfehler.
                --
                -- Je mehr Instanzen, desto mehr Techniker rechnen aus derselben
                -- Extraktorliste dieselben vier Nachbarplaetze aus. Mit 4 Instanzen
                -- der Kopie plus 2 des nicht gesperrten Originals waren es bis zu
                -- sechs.
                --
                -- LOUD faengt den Fall sauber ab: Eintrag verwerfen, weiterziehen.
                -- Es kostet nur den Hinweg. Zwei Instanzen sind der Kompromiss
                -- zwischen Tempo und vergeblichen Laeufen.
                Original   = 'Mass Storage 600',
                Name       = 'Mass Storage 600 - NoRush',
                Prioritaet = 843,
                Instanzen  = 2,
                OriginalSperren = false,

                -- ⚠ Vorgabe nach Testlauf 23: "es kommen viel zu spaet die
                -- Storages um den 4. Extraktor."
                --
                -- Nicht die Prioritaet war die Bremse, sondern zwei
                -- Wirtschaftsschwellen im Original
                -- (Loud_AI_Engineer_Mass_Builders.lua Z. 864-866):
                --
                --   { EBC, 'GreaterThanEconEnergyStorageCurrent', { 2500 }}
                --   { EBC, 'GreaterThanEnergyTrendOverTime', { 20 }}
                --
                -- 2500 gelagerte Energie ist derselbe Wert, der schon bei
                -- 'Assist Mass' die Unterstuetzung verhinderte (Nachtrag 26).
                -- In dieser Phase stehen erst wenige T1-Kraftwerke - die
                -- Schwelle wird spaet erreicht.
                --
                -- Gelockert auf 500 und 5. Ganz streichen waere falsch:
                -- Speicher sind teuer, und bei negativem Energietrend soll die
                -- KI nicht weiterbauen.
                BedingungWerte = {
                    GreaterThanEconEnergyStorageCurrent = { 500 },
                    GreaterThanEnergyTrendOverTime      = { 5 },
                },
            },
        },

        Description = "Aeon-Luftwaffen-General. Richtet sich nach der Lobbyoption "
                      .."No Rush: bis 35 Prozent der Frist nur Wirtschaft und Tech, "
                      .."dann Flugabwehr, ab 55 Prozent minimale Bodenabwehr, ab "
                      .."75 Prozent Truppen und Aufklaerung. Keine T1-Einheiten, "
                      .."keine T1-Verteidigung, hoher Fokus auf Quantentor und SCU. "
                      .."Bei 'Off' verhaelt sie sich wie LOUD.",
    },

    -- --------------------------------------------------------------------
    -- VORLAGE fuer eine weitere KI - Kopieren, umbenennen, einkommentieren:
    --
    -- {
    --     Key       = 'customai_turtle',
    --     Name      = 'AI: LOUD Turtle (Custom)',
    --     Source    = 'Loud_Main_Standard',
    --     Value     = 200,
    --     Customize = '/mods/customai/lua/AI/AIs/Turtle.lua',
    --     Description = "Baut mehr Verteidigung, greift spaeter an.",
    -- },
    -- --------------------------------------------------------------------
}
