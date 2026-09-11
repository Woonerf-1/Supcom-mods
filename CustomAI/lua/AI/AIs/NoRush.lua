-- ============================================================================
-- NoRush.lua - Phasen-KI: erst Wirtschaft, dann Luftabwehr, dann Bodenabwehr,
--              dann Truppen und Aufklaerung
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\lua\AI\AIs\NoRush.lua
--
-- Diese Datei wird von AIFactory.lua ueber definition.Customize importiert und
-- ihr Apply() aufgerufen. Das geschieht im simInit-Hook, also
--   NACH  simInit.lua Z. 357  (LOUDs Builder sind in der globalen Tabelle)
--   VOR   der ersten Basisanlage (AddGlobalBaseTemplate)
--
-- Doku: doc.claude\mods\CustomAI_Stellschrauben.md Ebene 5
-- ============================================================================

-- ----------------------------------------------------------------------------
-- WARUM NICHT UEBER template.Builders
--
-- Die BuilderGroups eines Basistemplates werden genau EINMAL geladen, beim
-- Anlegen der Basis (aiaddbuildertable.lua, AddGlobalBaseTemplate). Danach
-- aendert sich die Liste nie wieder. Eine Gruppe zu streichen schaltet sie
-- dauerhaft ab - nicht auf Zeit.
--
-- Dynamisch ist nur die Prioritaet. Die Zeitsteuerung muss deshalb in der
-- PriorityFunction des einzelnen Builders sitzen.
--
-- WARUM DAS FREMDE KIs NICHT STOERT
--
-- Builders[<name>] ist global und von allen KIs geteilt. Aber:
-- Builder:Create (sim\Builder.lua Z. 209-224) legt je Brain und je Manager ein
-- eigenes Builder-Objekt an, und die PriorityFunction bekommt den Brain als
-- Parameter (BuilderManager.lua: Builders[T]:PriorityFunction(aiBrain,unit,self)).
-- Die Weiche kann also im Inneren stehen: nur wenn aiBrain.CustomAIKey zu einer
-- unserer Definitionen gehoert, greift die Sperre. Fuer jede fremde KI ist das
-- Feld nil und LOUDs Originalfunktion laeuft unveraendert.
--
-- WARUM 10, true UND NICHT 0, false
--
-- GetHighestBuilder fuehrt nur Aufgaben mit Priority > 100 aus - beide Werte
-- schalten also ab. Aber SetPriority (sim\Builder.lua Z. 253-256) loescht bei
-- temporary = false die OldPriority; der Builder kaeme nie zurueck.
-- Fuer ein Zeitfenster ist nur 10, true richtig.
-- ----------------------------------------------------------------------------

local LOG  = LOG
local WARN = WARN

-- ----------------------------------------------------------------------------
-- DIE NO-RUSH-EINSTELLUNG AUS DER LOBBY
--
-- Die Lobbyoption ist in
--   C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\ui\lobby\lobbyOptions.lua
--   Z. 91-118
-- definiert:  key = 'NoRushOption',  Werte 'Off' / '5' / '10' / '20' (Minuten).
--
-- Optionen dieser Tabelle landen unter ihrem key in ScenarioInfo.Options.
-- Belegt an zwei Nachbarn derselben Tabelle:
--   simInit.lua Z. 208        ScenarioInfo.Options.TeamLock == 'locked'
--   loudutilities.lua Z. 5996 ScenarioInfo.Options.TeamSpawn == 'fixed'
--
-- UNGEPRUEFT bleibt, ob der Schluessel auch dann gesetzt ist, wenn die Option
-- in der Lobby nie angefasst wurde. Faellt sie aus, liefert diese Funktion 0
-- und es wird gar nichts gesperrt - die KI spielt dann wie LOUD.
-- Das ist die harmlose Richtung des Fehlschlags.
--
-- Der Wert wird einmal ermittelt und gemerkt; er aendert sich waehrend einer
-- Partie nicht.
-- ----------------------------------------------------------------------------
local NoRushSekunden = nil

-- ⚠ VORWAERTSDEKLARATION - NICHT ENTFERNEN
--
-- Die Bedingung 'LuftfabrikenGrenze' (weiter unten in der Tabelle
-- `Bedingungen`) ruft NoRushDauer() auf. Die Funktion selbst steht aber ERST
-- NACH dieser Tabelle im Quelltext.
--
-- Ohne diese Zeile ist der Name zum Zeitpunkt des Aufrufs kein sichtbares
-- Local, sondern ein GLOBAL - und nicht gesetzte Globale sind im Sim ein
-- Fehler, kein nil (system\config.lua). Testlauf 24:
--
--   warning: Error running lua script: ...norush.lua(349):
--   access to nonexistent global variable "NoRushDauer"
--
-- Zwoelf Mal im Log - und jedes Mal fiel die PriorityFunction der drei
-- Luftfabrikbauer aus, die Fabriken 2 bis 4 kamen also nicht.
--
-- Mit der Deklaration hier oben schliesst die spaetere Zuweisung
-- (NoRushDauer = function() ... end) genau dieses Local.
local NoRushDauer

-- ----------------------------------------------------------------------------
-- FREIGABEBEDINGUNGEN
--
-- Eine Phase kann statt oder zusaetzlich zur Zeit eine Bedingung tragen. Der
-- Builder bleibt gesperrt, solange sie falsch ist. Zeit UND Bedingung muessen
-- beide erfuellt sein.
--
-- Die Bedingungen stehen hier und nicht in AIDefinitions.lua, weil jene Datei
-- auch von der Lobby-UI gelesen wird - dort gibt es kein `categories`.
-- AIDefinitions nennt nur den Namen und eine Zahl, also reine Daten.
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- ACU-AUSBAU ERKENNEN
--
-- Wird von der Bedingung 'KeinACUAusbau' gebraucht. Der Aufruf kaeme sonst je
-- umhuelltem Builder und Auswahldurchlauf - deshalb ein Zwischenspeicher, der
-- hoechstens einmal je Tick und Brain neu rechnet.
-- ----------------------------------------------------------------------------
local ACUCacheTick  = -1
local ACUCacheBrain = false
local ACUCacheWert  = false

-- IsUnitState ist KEIN Global.
--
-- Testlauf 7 (2026-08-08):
--   warning: Error running lua script: ...norush.lua(104):
--   access to nonexistent global variable "IsUnitState"
--
-- Folge: die Umhuellung warf bei jedem Aufruf, und damit fielen alle 120
-- Builder der Phase "Waehrend ACU-Ausbau zurueckstellen" aus - unter anderem
-- 'Factory Production - Engineers'. Die KI baute keine Ingenieure mehr.
--
-- Richtig ist moho.unit_methods.IsUnitState, wie in loudutilities.lua Z. 70,
-- EngineerManager.lua Z. 46 und aibehaviors.lua Z. 76.
-- Aufloesung erst beim ersten Aufruf und ueber rawget, weil das Modul auch
-- geladen wird, bevor moho sicher steht.
local IsUnitState = false
local IsUnitStateGeprueft = false

local function ACUBautAus(aiBrain)

    local tick = GetGameTick()

    if tick != ACUCacheTick or aiBrain != ACUCacheBrain then

        ACUCacheTick  = tick
        ACUCacheBrain = aiBrain
        ACUCacheWert  = false

        if not IsUnitStateGeprueft then

            IsUnitStateGeprueft = true

            local m = rawget(_G, 'moho')

            if m and m.unit_methods then
                IsUnitState = m.unit_methods.IsUnitState
            else
                WARN("CUSTOMAI NoRush: moho.unit_methods.IsUnitState nicht verfuegbar"
                     .." - ACU-Ausbau wird nur ueber das Feld Upgrading erkannt")
            end
        end

        for i, u in aiBrain:GetListOfUnits( categories.COMMAND, false, true ) do

            if not u.Dead then

                -- Fuer den Kommandanten ist Upgrading der belegte Weg:
                -- aibehaviors.lua Z. 156 prueft (not cdr.Upgrading).
                if u.Upgrading then
                    ACUCacheWert = true
                    break
                end

                if IsUnitState and IsUnitState(u, 'Enhancing') then
                    ACUCacheWert = true
                    break
                end
            end
        end
    end

    return ACUCacheWert
end

-- ----------------------------------------------------------------------------
-- ZAEHLEN: OBERGRENZEN ANDERS ALS UNTERGRENZEN
--
-- GetCurrentUnits zaehlt nur FERTIGE Einheiten.
--
-- Fuer OBERGRENZEN ("hoechstens 2 T1-Techniker") ist das falsch: die Bedingung
-- wird erst falsch, wenn der dritte fertig ist - die Fabrik hat ihn da laengst
-- begonnen. Beobachtet in Testlauf 9: drei statt zwei T1-Techniker.
-- Deshalb zaehlt `Zaehle` mit `GetListOfUnits( cat, false, false )`, also
-- einschliesslich der angefangenen Bauten.
--
-- Fuer UNTERGRENZEN ("mindestens 4 Extraktoren auf T2") ist GetCurrentUnits
-- richtig: ein Extraktor, der gerade erst aufsteigt, foerdert noch nichts.
-- ----------------------------------------------------------------------------
local function Zaehle(aiBrain, kategorie)
    return table.getn( aiBrain:GetListOfUnits( kategorie, false, false ) )
end

local Bedingungen = {

    -- niemals freigeben - dauerhafte Sperre
    Nie = function(aiBrain, n)
        return false
    end,

    -- solange der ACU an einem Ausbau arbeitet, bleibt der Builder aus
    KeinACUAusbau = function(aiBrain, n)
        return not ACUBautAus(aiBrain)
    end,

    -- --- UNTERGRENZEN: nur fertige Einheiten zaehlen ------------------------

    MindestensT3Extraktoren = function(aiBrain, n)
        return aiBrain:GetCurrentUnits( categories.MASSEXTRACTION * categories.TECH3 ) >= (n or 1)
    end,

    MindestensT2Extraktoren = function(aiBrain, n)
        return aiBrain:GetCurrentUnits( categories.MASSEXTRACTION - categories.TECH1 ) >= (n or 1)
    end,

    -- --- OBERGRENZEN: angefangene Bauten mitzaehlen -------------------------

    WenigerAlsT1Kraftwerke = function(aiBrain, n)
        return Zaehle( aiBrain,
            categories.ENERGYPRODUCTION * categories.TECH1 - categories.HYDROCARBON ) < (n or 1)
    end,

    -- T1-Kraftwerke nach Bedarf: n[1] als Grundstock, dazu n[2] je Extraktor
    -- ab Stufe 2.
    --
    -- Hintergrund: der Aufstieg T1 -> T2 eines Extraktors haengt an
    -- SelfUpgradeThread und dessen Energietrend-Schwelle (energylowtrigger
    -- 1.007 fuer T1-Extraktoren, defaultunits.lua Z. 813). Zu wenig Energie
    -- heisst also: die Extraktoren steigen nicht auf.
    T1KraftwerkeNachBedarf = function(aiBrain, n)

        local grund = 6
        local jeMex = 4

        if n then
            grund = n[1] or grund
            jeMex = n[2] or jeMex
        end

        local mex = aiBrain:GetCurrentUnits( categories.MASSEXTRACTION - categories.TECH1 )

        return Zaehle( aiBrain,
            categories.ENERGYPRODUCTION * categories.TECH1 - categories.HYDROCARBON )
            < (grund + (jeMex * mex))
    end,

    WenigerAlsT2Kraftwerke = function(aiBrain, n)
        return Zaehle( aiBrain,
            categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON ) < (n or 1)
    end,

    -- Noch kein T2-Kraftwerk vorhanden oder im Bau.
    --
    -- Vorgabe: "sobald es T2 gibt, keine T1-Kraftwerke mehr."
    --
    -- LOUD schaltet die T1-Kraftwerke von sich aus erst ab, wenn ein
    -- T3-Kraftwerk an der Basis steht (T1 Power Template, PriorityFunction,
    -- Loud_AI_Engineer_Energy_Builders.lua Z. 46-58). Dazwischen laeuft beides
    -- nebeneinander - ein T1-Kraftwerk liefert 20 Energie je Sekunde, ein T2
    -- liefert 500. Weiterzubauen ist damit Masseverschwendung.
    --
    -- Mit Zaehle, also einschliesslich Baustelle: sobald das erste
    -- T2-Kraftwerk BEGONNEN ist, lohnt kein T1 mehr.
    KeinT2Kraftwerk = function(aiBrain, n)
        return Zaehle( aiBrain,
            categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON ) < 1
    end,

    -- Dasselbe eine Stufe hoeher: noch kein T3-Kraftwerk vorhanden oder im Bau.
    --
    -- Vorgabe: "sobald T3 verfuegbar ist, keine T2-Kraftwerke mehr bauen."
    --
    -- LOUD hat dafuer zwar eine eigene Regel (T2 Power Template gibt 12
    -- zurueck, sobald UnitsGreaterAtLocation ein T3-Kraftwerk meldet,
    -- Loud_AI_Engineer_Energy_Builders.lua Z. 101-113) - aber sie zaehlt nur
    -- FERTIGE Kraftwerke und gilt je BASIS. Zwischen Baubeginn und
    -- Fertigstellung eines T3-Kraftwerks kann also noch ein T2 dazukommen, und
    -- an einem Aussenposten ohne eigenes T3 laufen die T2-Bauer weiter.
    --
    -- Diese Bedingung zaehlt armeeweit und einschliesslich Baustelle.
    KeinT3Kraftwerk = function(aiBrain, n)
        return Zaehle( aiBrain,
            categories.ENERGYPRODUCTION * categories.TECH3 - categories.HYDROCARBON ) < 1
    end,

    -- --- TECHNIKERPLAN -----------------------------------------------------
    --
    -- Alle Zaehlungen schliessen den Kommandanten aus (er ist COMMAND) und
    -- bei T3 zusaetzlich die SCU (SUBCOMMANDER ist TECH3).

    T1TechnikerNachBedarf = function(aiBrain, n)

        local grund = 2
        local jeMex = 2

        if n then
            grund = n[1] or grund
            jeMex = n[2] or jeMex
        end

        local mex = aiBrain:GetCurrentUnits( categories.MASSEXTRACTION - categories.TECH1 )

        return Zaehle( aiBrain,
            categories.MOBILE * categories.ENGINEER * categories.TECH1 - categories.COMMAND )
            < (grund + (jeMex * mex))
    end,

    -- T1-Techniker in Stufen, abhaengig von der Zahl FERTIGER Extraktoren ab
    -- Stufe 2. n ist eine Liste von Paaren { Extraktoren, Obergrenze }:
    --
    --   { {0,2}, {3,4}, {4,8} }
    --     ab  0 T2-Extraktoren hoechstens 2 Techniker
    --     ab  3                hoechstens 4
    --     ab  4                hoechstens 8
    --
    -- Begruendung des Nutzers: vor dem dritten fertigen T2-Extraktor fehlt
    -- neuen Technikern die Masse zum Durchbauen. Sie waeren dann teurer als
    -- ihr Nutzen.
    --
    -- Gezaehlt wird mit GetCurrentUnits, also nur FERTIGE Extraktoren - ein
    -- gerade aufsteigender foerdert noch nicht.
    -- Die Techniker dagegen mit Zaehle, also einschliesslich der in Bau
    -- befindlichen, sonst wird die Grenze regelmaessig um einen ueberschritten.
    T1TechnikerStufen = function(aiBrain, n)

        local mex = aiBrain:GetCurrentUnits( categories.MASSEXTRACTION - categories.TECH1 )

        local grenze = 0

        if n then
            for i, paar in n do
                if mex >= paar[1] and paar[2] > grenze then
                    grenze = paar[2]
                end
            end
        end

        return Zaehle( aiBrain,
            categories.MOBILE * categories.ENGINEER * categories.TECH1 - categories.COMMAND )
            < grenze
    end,

    T2TechnikerVorKraftwerk = function(aiBrain, n)

        local jeKraftwerk = n or 2

        local kw = aiBrain:GetCurrentUnits(
            categories.ENERGYPRODUCTION * categories.TECH2 - categories.HYDROCARBON )

        return Zaehle( aiBrain,
            categories.MOBILE * categories.ENGINEER * categories.TECH2 - categories.COMMAND )
            < (jeKraftwerk * (kw + 1))
    end,

    HoechstensT1Techniker = function(aiBrain, n)
        return Zaehle( aiBrain,
            categories.MOBILE * categories.ENGINEER * categories.TECH1
            - categories.COMMAND ) < (n or 10)
    end,

    HoechstensT2Techniker = function(aiBrain, n)
        return Zaehle( aiBrain,
            categories.MOBILE * categories.ENGINEER * categories.TECH2
            - categories.COMMAND ) < (n or 10)
    end,

    HoechstensT3Techniker = function(aiBrain, n)
        return Zaehle( aiBrain,
            categories.MOBILE * categories.ENGINEER * categories.TECH3
            - categories.SUBCOMMANDER - categories.COMMAND ) < (n or 10)
    end,

    -- Solange keine Fabrik der Stufe 3 steht, duerfen T1- und T2-Techniker
    -- nachgebaut werden. Sobald eine da ist, wird nur noch T3 nachgelegt.
    KeineT3Fabrik = function(aiBrain, n)
        return aiBrain:GetCurrentUnits( categories.FACTORY * categories.TECH3 ) < 1
    end,

    -- Gegenstueck: mindestens eine Fabrik der Stufe 3 steht.
    T3FabrikVorhanden = function(aiBrain, n)
        return aiBrain:GetCurrentUnits( categories.FACTORY * categories.TECH3 ) >= (n or 1)
    end,

    -- Mindestens n T3-Techniker fertig UND ein Quantentor vorhanden oder im Bau.
    --
    -- Vorgabe: "zuerst die 10 T3-Techniker und das QG anfangen, bevor
    -- Kampfeinheiten kommen."
    --
    -- Techniker mit GetCurrentUnits, also nur FERTIGE - halbfertige bauen noch
    -- nichts. Das Tor mit Zaehle, also einschliesslich Baustelle, weil
    -- "anfangen" ausdruecklich genuegt.
    TechnikerUndTorStehen = function(aiBrain, n)

        if aiBrain:GetCurrentUnits(
            categories.MOBILE * categories.ENGINEER * categories.TECH3
            - categories.SUBCOMMANDER - categories.COMMAND ) < (n or 10) then
            return false
        end

        return Zaehle( aiBrain, categories.GATE ) >= 1
    end,

    -- Obergrenze fuer Luftfabriken, zweistufig:
    --   n[1] gilt bis zum Ende der No-Rush-Frist
    --   n[2] danach
    --
    -- Eine feste Obergrenze taugt hier nicht: waehrend der Frist sind Fabriken
    -- reine Massesenken (es wird ja nichts produziert), danach sind sie der
    -- Zweck der KI. BaseSettings.FactoryCount.AIR bleibt die harte Grenze
    -- darueber.
    LuftfabrikenGrenze = function(aiBrain, n)

        local vorher  = 4
        local nachher = 8

        if n then
            vorher  = n[1] or vorher
            nachher = n[2] or nachher
        end

        local grenze = nachher

        if aiBrain.CycleTime < NoRushDauer() then
            grenze = vorher
        end

        return Zaehle( aiBrain, categories.FACTORY * categories.AIR ) < grenze
    end,

    -- Transporter: Luftfabrik auf Stufe 3 UND Quantentor vorhanden oder im Bau.
    TransporterFreigabe = function(aiBrain, n)

        if aiBrain:GetCurrentUnits( categories.FACTORY * categories.AIR * categories.TECH3 ) < 1 then
            return false
        end

        return Zaehle( aiBrain, categories.GATE ) >= 1
    end,
}

NoRushDauer = function()

    if NoRushSekunden then
        return NoRushSekunden
    end

    local wert = false

    -- Strikte Globals: nicht gesetzte Globale wirft einen Fehler,
    -- deshalb rawget - siehe doc.claude\04_LUA_SIM.md Abschnitt 2.
    local SI = rawget(_G, 'ScenarioInfo')

    if SI and SI.Options then
        wert = SI.Options.NoRushOption
    end

    -- tonumber('Off') ist nil -> 0 Minuten -> keine Sperre
    NoRushSekunden = (tonumber(wert) or 0) * 60

    LOG("CUSTOMAI NoRush: Lobbyoption NoRushOption = "..tostring(wert)
        .." -> "..NoRushSekunden.." Sekunden")

    return NoRushSekunden
end

-- ----------------------------------------------------------------------------
-- ZUSTAND DES MODULS
--
-- import() liefert bei jedem Aufruf dieselbe Modultabelle. Diese Tabellen
-- ueberleben also mehrere Apply()-Aufrufe - noetig, damit zwei KIs denselben
-- Builder benutzen koennen, ohne dass die Umhuellung doppelt gelegt wird.
--
--   Umhuellt[BuilderName]     = true
--   Sperren[BuilderName][Key] = { Zeit = <sekunden>, Anteil = <faktor>, Prio = <wert> }
--
-- Zeit   feste Vorgabe in Spielsekunden
-- Anteil Bruchteil der No-Rush-Dauer, erst zur Laufzeit ausgerechnet
-- Prio   Obergrenze fuer die Prioritaet, dauerhaft - siehe unten
--
-- Zeit und Anteil duerfen beide gesetzt sein; es gilt der spaetere Zeitpunkt.
-- ----------------------------------------------------------------------------
local Umhuellt = {}
local Sperren  = {}

-- ----------------------------------------------------------------------------
-- Legt die Umhuellung um die PriorityFunction eines Builders - hoechstens
-- einmal je Builder.
-- ----------------------------------------------------------------------------
local function Umhuellen(name)

    if Umhuellt[name] then
        return true
    end

    local eintrag = Builders[name]

    if not eintrag then
        WARN("CUSTOMAI NoRush: Builder \""..name.."\" nicht gefunden - uebersprungen")
        return false
    end

    Umhuellt[name] = true
    Sperren[name]  = Sperren[name] or {}

    local orig    = eintrag.PriorityFunction
    local sperren = Sperren[name]

    eintrag.PriorityFunction = function(self, aiBrain, unit, manager)

        local key = aiBrain.CustomAIKey
        local e   = false

        if key then
            e = sperren[key]
        end

        if e then

            local frist = e.Zeit or 0

            if e.Anteil then

                local ausNoRush = e.Anteil * NoRushDauer()

                if ausNoRush > frist then
                    frist = ausNoRush
                end
            end

            -- CycleTime ist die Spielzeit in Sekunden
            -- (BrainConditionsMonitor.lua Z. 111)
            if frist > 0 and aiBrain.CycleTime < frist then
                return 10, true
            end

            -- Freigabebedingungen - ALLE muessen erfuellt sein.
            -- Eine Liste, weil ein Builder in mehreren Phaseneintraegen
            -- vorkommen darf: 'Air Transport T2' traegt sowohl
            -- TransporterFreigabe als auch KeinACUAusbau.
            if e.Bed then

                for i = 1, e.BedAnzahl do

                    if not e.Bed[i](aiBrain, e.BedWert[i]) then
                        return 10, true
                    end
                end
            end
        end

        -- ab hier: LOUDs Originalverhalten
        local p, t

        if not orig then

            -- Der Builder hatte urspruenglich GAR KEINE PriorityFunction.
            --
            -- FALL 1: wir verwalten ihn nicht (fremde KI, oder fuer diesen Key
            -- ist nichts eingetragen). Dann muss die Umhuellung ein echter
            -- Leerlauf sein. `false` bewirkt genau das: BuilderManager.lua
            -- Z. 327 prueft `if newPri and newPri != Priority` und laesst die
            -- Zuweisung aus.
            if not e then
                return false
            end

            -- FALL 2: wir verwalten ihn - dann MUSS die Prioritaet aktiv
            -- zurueckgegeben werden.
            --
            -- ⚠ HIER LAG DER FEHLER (Testlauf 8, 2026-08-08):
            -- Frueher lieferte dieser Zweig auch dann `false`, wenn weder
            -- Deckel noch Boden gesetzt waren. Das ist bei einem Builder, den
            -- wir zuvor per Sperre auf 10 gesetzt haben, verhaengnisvoll:
            -- `false` heisst "nichts aendern", also blieb er auf 10 - auch
            -- nachdem die Bedingung erfuellt war. Der Builder kam NIE zurueck.
            --
            -- Sichtbar wurde es an den Massespeichern: die vier Extraktoren
            -- gingen auf T2, die Bedingung war erfuellt, und trotzdem wurde
            -- kein Speicher gebaut. Betroffen war jeder Builder ohne eigene
            -- PriorityFunction - Builder MIT einer waren nie betroffen, weil
            -- deren Original den Wert ohnehin neu liefert.
            p, t = self.Priority, true
        else
            p, t = orig(self, aiBrain, unit, manager)
        end

        -- --- Prioritaetsdeckel und -boden --------------------------------
        -- Beide greifen NUR, wenn der Builder ohnehin laufen wuerde.
        -- GetHighestBuilder fuehrt nur Aufgaben ueber 100 aus; alles darunter
        -- ist LOUDs Art, eine Aufgabe abzuschalten (0 dauerhaft, 10-12
        -- vorlaeufig). Diese Werte bleiben unangetastet - sonst wuerden wir
        -- eine bewusste Abschaltung von LOUD ueberstimmen.
        -- temporary = true, damit OldPriority erhalten bleibt.
        if e and p and p > 100 then

            if e.Prio and p > e.Prio then
                p = e.Prio
            end

            if e.PrioMin and p < e.PrioMin then
                p = e.PrioMin
            end

            return p, true
        end

        return p, t
    end

    return true
end

-- ----------------------------------------------------------------------------
-- Sperrt einen einzelnen Builder fuer diesen Key.
-- Bei mehreren Eintraegen fuer denselben Builder gewinnt beim Zeitpunkt jeweils
-- der groessere Wert - eine Aufgabe aus Phase 4 wird nicht durch Phase 2
-- vorgezogen. Beim Prioritaetsdeckel gewinnt der KLEINERE Wert.
-- ----------------------------------------------------------------------------
local function Sperren1(name, key, zeit, anteil, prio, prioMin, bed, bedWert)

    if not Umhuellen(name) then
        return 0
    end

    local e = Sperren[name][key]

    if not e then
        e = {}
        Sperren[name][key] = e
    end

    if zeit and (not e.Zeit or zeit > e.Zeit) then
        e.Zeit = zeit
    end

    if anteil and (not e.Anteil or anteil > e.Anteil) then
        e.Anteil = anteil
    end

    if prio and (not e.Prio or prio < e.Prio) then
        e.Prio = prio
    end

    if prioMin and (not e.PrioMin or prioMin > e.PrioMin) then
        e.PrioMin = prioMin
    end

    if bed then

        e.Bed      = e.Bed or {}
        e.BedWert  = e.BedWert or {}
        e.BedAnzahl = e.BedAnzahl or 0

        -- dieselbe Bedingung nicht zweimal eintragen
        local schondrin = false

        for i = 1, e.BedAnzahl do
            if e.Bed[i] == bed and e.BedWert[i] == bedWert then
                schondrin = true
                break
            end
        end

        if not schondrin then
            e.BedAnzahl = e.BedAnzahl + 1
            e.Bed[e.BedAnzahl] = bed
            e.BedWert[e.BedAnzahl] = bedWert
        end
    end

    return 1
end

-- ----------------------------------------------------------------------------
-- Sperrt alle Builder einer BuilderGroup, ausser den namentlich Ausgenommenen.
--
-- BuilderGroups[<gruppe>] enthaelt neben den drei Kopffeldern nur
-- Builder-NAMEN (Builder{...} gibt den BuilderName zurueck) -
-- siehe lua\system\GlobalBuilderGroup.lua und GlobalBuilderTemplate.lua.
-- ----------------------------------------------------------------------------
local function SperrenGruppe(gruppe, key, zeit, anteil, prio, prioMin, bed, bedWert, ausser)

    local gr = BuilderGroups[gruppe]

    if not gr then
        WARN("CUSTOMAI NoRush: BuilderGroup \""..gruppe.."\" nicht gefunden - uebersprungen")
        return 0
    end

    ausser = ausser or {}

    local ausgenommen = {}

    for i, n in ausser do
        ausgenommen[n] = true
    end

    local anzahl = 0

    for k, v in gr do

        if k != 'BuilderGroupName' and k != 'BuildersType' and k != 'BuildersRestriction' then

            if not ausgenommen[v] then
                anzahl = anzahl + Sperren1(v, key, zeit, anteil, prio, prioMin, bed, bedWert)
            end
        end
    end

    return anzahl
end

-- ----------------------------------------------------------------------------
-- EIGENE BUILDER-KOPIEN
--
-- Prioritaeten sind ueber die Umhuellung erreichbar, BuilderConditions und
-- InstanceCount nicht: Builder:Create (sim\Builder.lua) liest beide je Manager
-- aus der globalen Tabelle Builders[]. Eine Aenderung dort traefe alle KIs.
--
-- Der Ausweg: eine KOPIE unter neuem Namen registrieren und sie in eine eigene
-- BuilderGroup stecken, die nur an UNSER Basistemplate gehaengt wird. Andere
-- KIs sehen die Gruppe nie, weil ihre Templates sie nicht auflisten.
--
-- Die drei Bausteine liegen alle im simInit-Fenster bereit:
--   Builder{}       lua\system\GlobalBuilderTemplate.lua  -> Builders[name]
--   BuilderGroup{}  lua\system\GlobalBuilderGroup.lua     -> BuilderGroups[name]
--   template.Builders    unsere tief kopierte Fassung
--
-- Das Original wird zusaetzlich automatisch mit Bedingung 'Nie' gesperrt -
-- sonst laufen Original und Kopie nebeneinander.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Kopiert einen Builder und gibt den neuen Namen zurueck.
--
-- Bewusst KEIN table.deepcopy auf der ganzen Tabelle: BuilderConditions
-- enthalten in Feld 1 ganze Modultabellen (EBC, UCBC, LUTL). Ein tiefes
-- Kopieren wuerde diese Module mitkopieren. Stattdessen:
--   - Kopffelder flach uebernehmen
--   - BuilderConditions als neue Liste mit denselben Bedingungstabellen
--     (Builder:Create kopiert sie ohnehin je Manager tief)
--   - BuilderData tief kopieren, weil EngineerBuilder.Create darin
--     BuildStructures ueberschreibt (sim\Builder.lua) - geteilt waere das ein
--     Fehler
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PLATZHALTER IN BuilderDatenWerte
--
-- 'NoRushRadius' wird durch ScenarioInfo.norushradius ersetzt. Das Feld kommt
-- aus der Szenariodatei der Karte, z. B.
-- maps\LostTemple\losttemple_scenario.lua Z. 15:  norushradius = 52
--
-- Damit laesst sich der Extraktorbau auf genau den Bereich begrenzen, in dem
-- waehrend der No-Rush-Frist ueberhaupt gebaut werden darf - statt auf eine
-- geratene feste Entfernung.
--
-- Fehlt das Feld (Karte ohne No-Rush-Kreis), bleibt der urspruengliche Wert
-- stehen und es gibt eine Warnung.
-- ----------------------------------------------------------------------------
local function WertAufloesen(wert, neu, feld, unterfeld, kopie)

    -- Benannte Kategorienausdruecke.
    --
    -- Noetig, weil AIDefinitions.lua datenrein bleiben muss: die Datei wird
    -- auch von der Lobby-UI gelesen, und dort gibt es kein `categories`.
    -- Ueber einen Namen laesst sich der Ausdruck trotzdem setzen.
    if wert == 'EngineerOhneACU' then
        return categories.ENGINEER - categories.COMMAND
    end

    if wert != 'NoRushRadius' then
        return wert
    end

    local SI = rawget(_G, 'ScenarioInfo')

    if SI and SI.norushradius then
        return SI.norushradius
    end

    -- Nicht jede Karte bringt das Feld mit. Testlauf 19 auf 'rockbottom':
    --   CUSTOMAI NoRush: ... ScenarioInfo.norushradius fehlt
    --
    -- Ohne Ersatzwert bliebe MaxRange auf LOUDs 250 stehen - und genau das
    -- schickte die Techniker wieder 243 weit. Deshalb ein Standardwert aus
    -- der Definition.
    if kopie and kopie.NoRushRadiusStandard then

        WARN("CUSTOMAI NoRush: "..neu.." - ScenarioInfo.norushradius fehlt,"
             .." "..feld.."."..unterfeld.." = "..kopie.NoRushRadiusStandard
             .." (Standardwert aus AIDefinitions)")

        return kopie.NoRushRadiusStandard
    end

    WARN("CUSTOMAI NoRush: "..neu.." - ScenarioInfo.norushradius fehlt und kein"
         .." NoRushRadiusStandard gesetzt, "..feld.."."..unterfeld
         .." bleibt unveraendert")

    return nil
end

local function BuilderKopieren(kopie, key)

    local original = Builders[kopie.Original]

    if not original then
        WARN("CUSTOMAI NoRush: Builder \""..tostring(kopie.Original)
             .."\" nicht gefunden - Kopie uebersprungen")
        return false
    end

    local neu = kopie.Name or (kopie.Original.." - "..key)

    if Builders[neu] then
        -- schon angelegt (zweiter Apply-Aufruf) - nicht doppelt registrieren
        return neu
    end

    local spec = {}

    for k, v in original do
        if k != 'BuilderConditions' and k != 'BuilderData' then
            spec[k] = v
        end
    end

    spec.BuilderName   = neu
    spec.Priority      = kopie.Prioritaet   or original.Priority
    spec.InstanceCount = kopie.Instanzen    or original.InstanceCount

    -- ------------------------------------------------------------------
    -- Platoon-Vorlage mitkopieren, wenn die Squadgroesse geaendert werden soll
    --
    -- Die Vorlage entscheidet, WIE VIELE Einheiten ein Bauauftrag erzeugt -
    -- nicht der Builder. 'T1BuildEngineerInitial' steht in
    -- lua\AI\PlatoonTemplates\Loud_AI_Factory_Platoons.lua Z. 27 auf
    -- { <blueprint>, 1, 3, 'Support', 'none' }, baut also bis zu DREI
    -- Techniker auf einen Schlag. Eine Obergrenze im Builder kann das nicht
    -- verhindern: sie wird einmal geprueft, danach laeuft der ganze Auftrag.
    --
    -- PlatoonTemplate{} registriert in PlatoonTemplates[name]
    -- (lua\system\GlobalPlatoonTemplate.lua).
    -- ------------------------------------------------------------------
    if kopie.PlatoonMax and original.PlatoonTemplate then

        local vorlage = PlatoonTemplates[ original.PlatoonTemplate ]

        if not vorlage then

            WARN("CUSTOMAI NoRush: PlatoonTemplate \""..tostring(original.PlatoonTemplate)
                 .."\" nicht gefunden - Squadgroesse unveraendert")
        else

            local vname = original.PlatoonTemplate.." - "..key

            if not PlatoonTemplates[vname] then

                local v = table.deepcopy(vorlage)

                v.Name = vname

                -- Feld 3 jeder Squadzeile ist die Hoechstzahl.
                local function Kappen(liste)
                    for i, squad in liste do
                        if squad[3] and squad[3] > kopie.PlatoonMax then
                            squad[3] = kopie.PlatoonMax
                        end
                    end
                end

                if v.GlobalSquads then
                    Kappen(v.GlobalSquads)
                end

                if v.FactionSquads then
                    for f, liste in v.FactionSquads do
                        Kappen(liste)
                    end
                end

                PlatoonTemplate(v)

                LOG("CUSTOMAI NoRush: PlatoonTemplate \""..vname
                    .."\" - hoechstens "..kopie.PlatoonMax.." je Auftrag")
            end

            spec.PlatoonTemplate = vname
        end
    end

    if original.BuilderData then

        spec.BuilderData = table.deepcopy(original.BuilderData)

        -- Einzelne Felder ueberschreiben, zwei Ebenen tief. Reine Daten,
        -- also auch aus AIDefinitions.lua heraus setzbar.
        if kopie.BuilderDatenWerte then

            for feld, wert in kopie.BuilderDatenWerte do

                if type(wert) == 'table' then

                    spec.BuilderData[feld] = spec.BuilderData[feld] or {}

                    for unterfeld, unterwert in wert do

                        local w = WertAufloesen(unterwert, neu, feld, unterfeld, kopie)

                        if w != nil then

                            LOG("CUSTOMAI NoRush: "..neu.." - BuilderData."..feld.."."..unterfeld
                                .." "..tostring(spec.BuilderData[feld][unterfeld])
                                .." -> "..tostring(w))

                            spec.BuilderData[feld][unterfeld] = w
                        end
                    end
                else
                    spec.BuilderData[feld] = wert
                end
            end
        end
    end

    -- Bedingungen uebernehmen, die genannten weglassen oder umparametrieren.
    -- Aufbau einer Bedingung: { <Modul>, '<Funktionsname>', { <Argumente> } }
    -- oder { <Funktion>, { <Argumente> } } - nur die erste Form ist benennbar.
    --
    -- OhneBedingung   Liste von Funktionsnamen, die entfallen
    -- BedingungWerte  Tabelle Funktionsname -> neue Argumentliste. Das Modul
    --                 bleibt dasselbe, nur die Zahlen werden ersetzt. So
    --                 laesst sich eine Bedingung lockern, statt sie ganz zu
    --                 streichen - und AIDefinitions.lua bleibt datenrein, weil
    --                 dort kein Modulverweis noetig ist.
    local weg = {}

    if kopie.OhneBedingung then
        for i, n in kopie.OhneBedingung do
            weg[n] = true
        end
    end

    local neueWerte = kopie.BedingungWerte or {}

    -- Einzelne Argumente einer Bedingung aendern, adressiert ueber ihre
    -- Position. Noetig, wenn in der Argumentliste Kategorieobjekte stehen -
    -- die lassen sich aus AIDefinitions.lua heraus nicht schreiben, weil jene
    -- Datei auch von der Lobby-UI gelesen wird und dort kein `categories`
    -- existiert.
    --
    --   BedingungArgAendern = {
    --       BuildingGreaterAtLocationAtRange = { [5] = 300 },
    --   }
    local neueArgs = kopie.BedingungArgAendern or {}

    if original.BuilderConditions then

        spec.BuilderConditions = {}

        local zaehler = 0

        for i, bed in original.BuilderConditions do

            local name = false

            if type(bed[2]) == 'string' then
                name = bed[2]
            end

            if name and weg[name] then

                LOG("CUSTOMAI NoRush: "..neu.." - Bedingung "..name.." entfernt")

            elseif name and neueWerte[name] then

                zaehler = zaehler + 1
                spec.BuilderConditions[zaehler] = { bed[1], bed[2], neueWerte[name] }

                LOG("CUSTOMAI NoRush: "..neu.." - Bedingung "..name.." umparametriert")

            elseif name and neueArgs[name] then

                local args = table.deepcopy(bed[3])

                for pos, wert in neueArgs[name] do

                    local w = WertAufloesen(wert, neu, 'Bedingung', name, kopie)

                    LOG("CUSTOMAI NoRush: "..neu.." - Bedingung "..name
                        .." Argument "..pos.." ersetzt")

                    args[pos] = w
                end

                zaehler = zaehler + 1
                spec.BuilderConditions[zaehler] = { bed[1], bed[2], args }
            else
                zaehler = zaehler + 1
                spec.BuilderConditions[zaehler] = bed
            end
        end
    end

    -- zusaetzliche Bedingungen anhaengen, unveraendert durchgereicht
    if kopie.PlusBedingung then

        spec.BuilderConditions = spec.BuilderConditions or {}

        local zaehler = table.getn(spec.BuilderConditions)

        for i, bed in kopie.PlusBedingung do
            zaehler = zaehler + 1
            spec.BuilderConditions[zaehler] = bed
        end
    end

    Builder(spec)

    if not Builders[neu] then
        WARN("CUSTOMAI NoRush: Kopie \""..neu.."\" wurde nicht registriert")
        return false
    end

    LOG("CUSTOMAI NoRush: Kopie \""..neu.."\" aus \""..kopie.Original
        .."\" - Prioritaet "..tostring(spec.Priority)
        ..", Instanzen "..tostring(spec.InstanceCount))

    return neu
end

-- ----------------------------------------------------------------------------
-- Legt alle Kopien einer Definition an, steckt sie nach BuildersType getrennt
-- in eigene BuilderGroups und haengt diese an template.Builders.
-- Die Originale werden dauerhaft gesperrt.
-- ----------------------------------------------------------------------------
local function KopienAnlegen(template, definition)

    local key = definition.Key

    -- BuildersType -> Liste neuer Buildernamen
    local nachTyp = {}

    for i, kopie in definition.Kopien do

        local neu = BuilderKopieren(kopie, key)

        if neu then

            local typ = Builders[neu].BuilderType

            -- BuilderType des Builders ist eine Liste ('T1','T2',...);
            -- der BuildersType der GRUPPE ist etwas anderes und muss angegeben
            -- werden - er entscheidet, welcher Manager die Aufgabe bekommt.
            typ = kopie.Gruppentyp or 'EngineerBuilder'

            nachTyp[typ] = nachTyp[typ] or {}

            local n = table.getn(nachTyp[typ]) + 1
            nachTyp[typ][n] = neu

            -- Original dauerhaft aus, sonst laeuft es neben der Kopie.
            --
            -- ACHTUNG (Testlauf 9): unsere Kopien haengen nur am MAIN-Template.
            -- Aussenposten benutzen LOUDs Loud_Expansion_*-Templates, in denen
            -- unsere Gruppe nicht vorkommt. Die Sperre wirkt aber ARMEEWEIT -
            -- ein gesperrtes Original ist damit auch an Aussenposten weg.
            -- Deshalb steht bei Kopien, deren Aufgabe auch dort gebraucht wird,
            -- `OriginalSperren = false`; dann laufen an MAIN beide nebeneinander
            -- (harmlos, InstanceCount begrenzt jede fuer sich) und der
            -- Aussenposten behaelt LOUDs Fassung.
            if kopie.OriginalSperren != false then
                Sperren1(kopie.Original, key, nil, nil, nil, nil, Bedingungen.Nie, nil)
            end
        end
    end

    for typ, namen in nachTyp do

        local gruppe = 'CustomAI_'..key..'_'..typ

        local spec = {
            BuilderGroupName = gruppe,
            BuildersType     = typ,
        }

        for i, n in namen do
            spec[i] = n
        end

        BuilderGroup(spec)

        -- an unser Template haengen - GlobalBaseTemplate.lua prueft beim
        -- Registrieren, dass jeder Name in BuilderGroups existiert
        local n = table.getn(template.Builders) + 1
        template.Builders[n] = gruppe

        LOG("CUSTOMAI NoRush: BuilderGroup \""..gruppe.."\" mit "
            ..table.getn(namen).." Kopien an das Template gehaengt")
    end
end

-- ----------------------------------------------------------------------------
-- Apply(template, definition)
--
-- Erwartet definition.Phasen - eine Liste von Abschnitten:
--
--   Phasen = {
--       {
--           Name           = "Luftabwehr",
--           Anteil         = 0.35,               -- Bruchteil der No-Rush-Dauer
--           Zeit           = 420,                -- ODER feste Spielsekunden
--           Bedingung      = 'MindestensT3Extraktoren',  -- Name aus der Liste oben
--           BedingungWert  = 4,
--           Prioritaet     = 745,                -- Deckel, dauerhaft
--           PrioritaetMin  = 843,                -- Boden, dauerhaft
--           Builder        = { 'T1 Base Defense - AA' },
--           Gruppen        = { 'Factory Production Air - Bombers' },
--           Ausser         = { 'Air Scout T1' }, -- gilt fuer Gruppen
--       },
--   }
--
-- Zeit/Anteil und Bedingung muessen BEIDE erfuellt sein.
--
-- `Prioritaet` und `PrioritaetMin` wirken AUCH NACH der Freigabe und schieben
-- eine Aufgabenart dauerhaft hinter oder vor eine andere, ohne sie
-- abzuschalten. Hintergrund: GetHighestBuilder prueft nur das oberste
-- Prioritaetsband - wer niedriger steht, kommt erst dran, wenn oben nichts
-- uebrig ist. Beide greifen nur oberhalb von 100, damit LOUDs eigene
-- Abschaltwerte (0, 10, 11, 12) unangetastet bleiben.
--
-- Das Basistemplate selbst wird NICHT veraendert - alle BuilderGroups bleiben
-- geladen, sie sind nur zeitweise auf Prioritaet 10 gesetzt.
-- ----------------------------------------------------------------------------
function Apply(template, definition)

    local key    = definition.Key
    local phasen = definition.Phasen

    -- ------------------------------------------------------------------
    -- BaseSettings ueberschreiben
    --
    -- definition.BaseSettings wird feldweise in das (von AIFactory bereits
    -- tief kopierte) Template gemischt. Nur genannte Felder werden ersetzt,
    -- der Rest bleibt LOUDs Vorgabe.
    --
    -- Zwei Ebenen reichen: EngineerCount, FactoryCount und
    -- MassToFactoryValues sind Untertabellen, RallyPointRadius ist flach.
    -- ------------------------------------------------------------------
    if definition.BaseSettings then

        for feld, wert in definition.BaseSettings do

            if type(wert) == 'table' then

                template.BaseSettings[feld] = template.BaseSettings[feld] or {}

                for unterfeld, unterwert in wert do

                    LOG("CUSTOMAI NoRush: "..key.." BaseSettings."..feld.."."..unterfeld
                        .." "..tostring(template.BaseSettings[feld][unterfeld])
                        .." -> "..tostring(unterwert))

                    template.BaseSettings[feld][unterfeld] = unterwert
                end
            else

                LOG("CUSTOMAI NoRush: "..key.." BaseSettings."..feld
                    .." "..tostring(template.BaseSettings[feld])
                    .." -> "..tostring(wert))

                template.BaseSettings[feld] = wert
            end
        end
    end

    if not phasen then
        WARN("CUSTOMAI NoRush: "..tostring(key).." hat kein Feld Phasen - keine Sperre gesetzt")
        return
    end

    -- Kopien zuerst: sie tragen ihre eigenen Sperren fuer die Originale ein,
    -- und die Phasenliste darf sie danach noch weiter einschraenken.
    if definition.Kopien then
        KopienAnlegen(template, definition)
    end

    local gesamt = 0

    for i, phase in phasen do

        local zeit    = phase.Zeit
        local anteil  = phase.Anteil
        local prio    = phase.Prioritaet
        local prioMin = phase.PrioritaetMin
        local bedWert = phase.BedingungWert
        local bed     = false
        local anzahl  = 0

        if phase.Bedingung then

            bed = Bedingungen[phase.Bedingung]

            if not bed then
                WARN("CUSTOMAI NoRush: Bedingung \""..tostring(phase.Bedingung)
                     .."\" ist nicht definiert - Phase laeuft ohne sie")
            end
        end

        if phase.Builder then

            for j, name in phase.Builder do
                anzahl = anzahl + Sperren1(name, key, zeit, anteil, prio, prioMin, bed, bedWert)
            end
        end

        if phase.Gruppen then

            for j, gruppe in phase.Gruppen do
                anzahl = anzahl + SperrenGruppe(gruppe, key, zeit, anteil, prio, prioMin, bed, bedWert, phase.Ausser)
            end
        end

        gesamt = gesamt + anzahl

        LOG("CUSTOMAI NoRush: "..key.." Phase \""..tostring(phase.Name)
            .."\" - "..anzahl.." Builder"
            .." (Zeit "..tostring(zeit)..", Anteil "..tostring(anteil)
            ..", Deckel "..tostring(prio)..", Boden "..tostring(prioMin)
            ..", Bedingung "..tostring(phase.Bedingung).." "..tostring(bedWert)..")")
    end

    LOG("CUSTOMAI NoRush: "..key.." - "..gesamt.." Sperren gesetzt")
end
