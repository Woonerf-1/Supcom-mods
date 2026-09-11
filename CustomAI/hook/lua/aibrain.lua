-- ============================================================================
-- Hook auf /lua/aibrain.lua
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\hook\lua\aibrain.lua
-- Hookt: /lua/aibrain.lua
--
-- ZWEI AUFGABEN:
--   1. Personality auf 'loud' setzen, damit die eigene KI die vollen Cheats
--      bekommt (siehe unten)
--   2. Rueckfallebene fuer das Laden der KI-Definitionen, falls der Hook auf
--      simInit.lua einmal nicht greifen sollte
--
-- ---------------------------------------------------------------------------
-- WARUM AUFGABE 1
--
-- Es gibt ZWEI aehnlich benannte Felder mit verschiedenem Verhalten:
--
--   aiBrain.Personality
--     gesetzt in aibrain.lua Z. 893 aus dem Lobby-Key
--     danach NIE wieder geaendert
--     -> hier steht dauerhaft z. B. 'customai_standard'
--
--   ScenarioInfo.ArmySetup[<Armee>].AIPersonality
--     erst der Lobby-Key, dann von SetupMainBase (aiarchetype-managerloader.lua
--     Z. 47) mit dem baseType ueberschrieben
--     -> hier steht spaeter 'loud'
--
-- Das Cheat-System prueft aiBrain.Personality:
--
--   aiutilities.lua Z. 842  SetupAICheat:    if Personality != 'loud' then return end
--   aiutilities.lua Z.1025  ApplyCheatBuffs: if Personality == 'loud' then ... end
--
-- Ohne diesen Hook fehlen einer eigenen KI: VeterancyMult, MinorCheatModifier,
-- MajorCheatModifier, BuildRateModifier, CheatIntel, CheatALL, CheatMOBILE,
-- CheatENG, CheatCDROmni, die ACU-Startvorraete und der Ausgleich bei
-- Unterzahl. Uebrig blieben nur CheatIncome und CheatBuildRate.
--
-- Der Rueckgabewert 'loud' aus unserer FirstBaseFunction hilft dagegen NICHT -
-- er landet nur im ScenarioInfo-Feld.
--
-- Der urspruengliche Key wird in self.CustomAIKey aufbewahrt.
-- Die FirstBaseFunction bleibt unberuehrt: sie liest das ScenarioInfo-Feld,
-- das zu ihrem Zeitpunkt noch den Lobby-Key traegt.
--
-- ACHTUNG - STRIKTE GLOBALS:
-- Merker immer mit rawget(_G, '<name>') pruefen. Ein direkter Zugriff auf eine
-- nicht gesetzte globale Variable ist im Sim ein FEHLER, nicht nil
-- (system\config.lua Z. 94-96). Ein Fehler hier bricht den Import von
-- aibrain.lua ab und damit den gesamten Sim-Start - das Spiel haengt dann im
-- Ladeschirm. Genau so passiert in Testlauf 1.
--
-- Doku: doc.claude\mods\CustomAI.md Abschnitt 4
--       doc.claude\mods\CustomAI_Stellschrauben.md, Abschnitt
--       "KI-Key und Personality"
-- ============================================================================

-- --- Aufgabe 2: Rueckfallebene -------------------------------------------

if not rawget(_G, 'CUSTOMAI_TEMPLATE_LOADED') then

    LOG("CUSTOMAI: lade KIs ueber aibrain-Hook"
        .." - der simInit-Hook hat also NICHT gegriffen")

    import('/mods/customai/lua/AI/LoadAIs.lua')

else

    LOG("CUSTOMAI: KIs waren schon geladen - simInit-Hook hat gegriffen")

end


-- --- Aufgabe 3: Debug-Schalter ------------------------------------------
--
-- LOUDs Diagnoseschalter sind Felder in ScenarioInfo, gesetzt am Kopf von
-- /lua/aibrain.lua (Z. 13-74). Sie gelten fuer die ganze Partie, nicht je KI -
-- in einem Testspiel mit nur unserer KI ist das unerheblich.
--
-- Welche gesetzt werden, steht in AIDefinitions.lua unter DebugSchalter.
-- Fehlt das Feld, wird nichts angefasst und LOUDs Vorgaben bleiben stehen.
--
-- ACHTUNG: diese Schalter erzeugen SEHR viel Log. Nur fuer Testlaeufe.

do
    local ok, modul = pcall(import, '/mods/customai/lua/AI/AIDefinitions.lua')

    if ok and modul and modul.Definitions then

        local SI = rawget(_G, 'ScenarioInfo')

        if SI then

            for i, d in modul.Definitions do

                if d.DebugSchalter then

                    for name, wert in d.DebugSchalter do

                        SI[name] = wert

                        LOG("CUSTOMAI Debug: ScenarioInfo."..name.." = "..tostring(wert)
                            .." (aus "..d.Key..")")
                    end
                end
            end
        end
    end
end


-- --- Aufgabe 4: Startmassepunkte begrenzen -------------------------------
--
-- ⚠ TESTLAUF 20 - DER GRUND, WARUM MaxRange UND MaxChoices WIRKUNGSLOS WAREN
--
-- Fuer Massextraktoren laeuft der Bau NICHT ueber AIBuildBaseTemplateOrdered,
-- sondern ueber AIExecuteBuildStructure (aibuildstructures.lua Z. 43), weil
-- IsResource(buildingType) wahr ist. Und dort steht ab Z. 97:
--
--   if testtype == 'Mass' and aiBrain.StartingMassPointList[1] then
--       location = LOUDREMOVE(aiBrain.StartingMassPointList, 1)
--       location = location.Position
--       if CanBuildStructureAt( aiBrain, testunit, location ) then
--           constructionData.MaxRange = 1500
--
-- Solange diese Liste nicht leer ist, nimmt der Techniker stur den naechsten
-- LISTENEINTRAG - Entfernung egal. `MaxChoices` wird gar nicht erst gelesen,
-- und `MaxRange` wird sogar aktiv auf 1500 gesetzt.
--
-- Damit sind die Nachtraege 30, 40 und 42 erklaert: die Werte waren richtig
-- gesetzt (der Log bestaetigt 250 -> 100 und nil -> 1), aber dieser Codepfad
-- sieht sie nicht.
--
-- WOHER DIE LISTE KOMMT
--
-- ScenarioUtilities.lua Z. 1036-1075, am Ende von InitializeArmies: die
-- Massepunkte des Teams werden nach Entfernung zur Startposition sortiert, und
-- jede KI bekommt reihum `MassPointShare` Stueck zugeteilt. Die Zahl ist
-- grosszuegig - Z. 954:
--
--   min( 12 + PlayerCount, floor(NumMassPoints/PlayerCount) - 1 )
--
-- Auf einer Karte mit vielen Massepunkten sind das leicht 14 Stueck, und die
-- hinteren liegen weit ausserhalb der Basis. Genau daher die Wege von 243 und
-- 319 aus Testlauf 20.
--
-- WAS DIESER THREAD TUT
--
-- Die Liste wird auf die ersten n Eintraege gekuerzt - die naechstgelegenen,
-- weil sie so sortiert zugeteilt wurden. Alles Weitere faellt dann in den
-- normalen Pfad, der MaxRange und MaxChoices sehr wohl beachtet.
--
-- Der Thread wartet, weil die Liste erst in InitializeArmies gefuellt wird -
-- also NACH OnCreateAI. Ein direkter Zugriff hier waere zu frueh.
-- ---------------------------------------------------------------------------
function StartmassepunkteKuerzen(self, key)

    local anzahl = false

    local ok, modul = pcall(import, '/mods/customai/lua/AI/AIDefinitions.lua')

    if ok and modul and modul.Definitions then

        for i, d in modul.Definitions do
            if d.Key == key then
                anzahl = d.StartMassepunkte
                break
            end
        end
    end

    if not anzahl then
        return
    end

    -- bis zu 30 Sekunden auf die Liste warten; der erste Extraktorauftrag
    -- kam in den Testlaeufen um Tick 420.
    --
    -- ⚠ TESTLAUF 22: zusaetzlich auf die erste FABRIK warten. Die Techniker
    -- entstehen dort und laufen von dort los - nicht von der Startposition der
    -- Armee, nach der LOUD sortiert (ScenarioUtilities.lua Z. 1062), und auch
    -- nicht vom Kommandanten, der zu Beginn noch auf der Startposition steht.
    -- Eine Sortierung nach dem Kommandanten war deshalb dasselbe wie LOUDs
    -- Sortierung und aenderte nichts: die Reihenfolge blieb 57, 25, 46, 43.
    local versuche = 0
    local fabrik   = false

    while versuche < 40 do

        if self.StartingMassPointList and self.StartingMassPointList[1] then

            for i, u in self:GetListOfUnits( categories.FACTORY, false, true ) do
                if not u.Dead then
                    fabrik = u
                    break
                end
            end

            if fabrik then
                break
            end
        end

        WaitTicks(10)
        versuche = versuche + 1
    end

    if not (self.StartingMassPointList and self.StartingMassPointList[1]) then
        WARN("CUSTOMAI: "..tostring(self.Nickname)
             .." - StartingMassPointList bleibt leer, nicht gekuerzt")
        return
    end

    local vorher = table.getn(self.StartingMassPointList)

    -- ERST sortieren, DANN kuerzen - sonst blieben die vier Punkte uebrig, die
    -- der Startposition am naechsten sind, und nicht die der Fabrik.
    if fabrik then

        local pos = fabrik:GetPosition()

        table.sort( self.StartingMassPointList,
            function(a,b) return VDist3( a.Position, pos ) < VDist3( b.Position, pos ) end )

        LOG("CUSTOMAI: "..tostring(self.Nickname)
            .." - Startmassepunkte nach Entfernung zur Fabrik "
            ..repr(pos).." sortiert")
    else
        WARN("CUSTOMAI: "..tostring(self.Nickname)
             .." - keine Fabrik gefunden, Reihenfolge der Massepunkte unveraendert")
    end

    while table.getn(self.StartingMassPointList) > anzahl do
        table.remove(self.StartingMassPointList)
    end

    LOG("CUSTOMAI: "..tostring(self.Nickname).." - StartingMassPointList von "
        ..vorher.." auf "..table.getn(self.StartingMassPointList)
        .." Eintraege gekuerzt (MassPointShare war "
        ..tostring(self.MassPointShare)..")")
end


-- --- Aufgabe 5: gleichzeitige Aufstiege ----------------------------------
--
-- ScenarioUtilities.lua Z. 962-995 setzt am Ende von InitializeArmies:
--
--   aiBrain.UpgradeIssued = 0
--   aiBrain.UpgradeIssuedLimit = 1
--   -- mehr nur bei Unterzahl
--
-- SelfUpgradeThread prueft das vor jedem Aufstieg (aibehaviors.lua Z. 8732):
--
--   if aiBrain.UpgradeIssued < aiBrain.UpgradeIssuedLimit ...
--
-- ⚠ KORREKTUR NACH TESTLAUF 25:
--
-- Zuerst war hier ein fester Wert von 4 eingetragen, weil die gestaffelten
-- T3-Aufstiege (5813, 9008, 10188, 10469) wie eine Drossel aussahen.
-- **Das war falsch.** Begruendung des Nutzers:
--
--   "fuer gleichzeitigen Aufstieg in der No-Rush haben wir nicht ansatzweise
--    die Ressourcen. Der Clou ist immer einen zu pushen, der dann Ressourcen
--    bringt, dann den naechsten. In der Expansionsphase ist das kein Thema -
--    pro vorhandenen T3-Extraktor kann ein weiterer locker gepusht werden."
--
-- LOUDs Vorgabe von 1 ist waehrend der Frist also genau richtig: ein Aufstieg
-- finanziert den naechsten. Erst danach traegt die Wirtschaft mehrere.
--
-- Deshalb kein fester Wert, sondern eine mitlaufende Grenze:
--
--   waehrend der No-Rush-Frist   WaehrendFrist  (Vorgabe 1)
--   danach                       JeT3Extraktor * Anzahl T3-Extraktoren,
--                                mindestens WaehrendFrist,
--                                hoechstens Hoechstens
--
-- Der Thread laeuft bis zum Ende der Partie und passt den Wert alle zehn
-- Sekunden an.
-- ---------------------------------------------------------------------------
function AufstiegsgrenzeSetzen(self, key)

    local regel = false

    local ok, modul = pcall(import, '/mods/customai/lua/AI/AIDefinitions.lua')

    if ok and modul and modul.Definitions then

        for i, d in modul.Definitions do
            if d.Key == key then
                regel = d.GleichzeitigeAufstiege
                break
            end
        end
    end

    if not regel then
        return
    end

    local waehrend  = regel.WaehrendFrist  or 1
    local jeMex     = regel.JeT3Extraktor  or 1
    local hoechstens = regel.Hoechstens    or 8

    -- No-Rush-Dauer aus der Lobbyoption; dieselbe Quelle wie in NoRush.lua.
    local frist = 0

    do
        local SI = rawget(_G, 'ScenarioInfo')

        if SI and SI.Options then
            frist = (tonumber(SI.Options.NoRushOption) or 0) * 60
        end
    end

    -- warten, bis InitializeArmies das Feld angelegt hat
    local versuche = 0

    while versuche < 40 do

        if self.UpgradeIssuedLimit then
            break
        end

        WaitTicks(10)
        versuche = versuche + 1
    end

    if not self.UpgradeIssuedLimit then
        WARN("CUSTOMAI: "..tostring(self.Nickname)
             .." - UpgradeIssuedLimit wurde nie gesetzt, Grenze unveraendert")
        return
    end

    LOG("CUSTOMAI: "..tostring(self.Nickname).." - Aufstiegsgrenze: waehrend der"
        .." Frist "..waehrend..", danach "..jeMex.." je T3-Extraktor, hoechstens "
        ..hoechstens.." (Frist "..frist.." Sekunden)")

    local letzte = false

    while not self.Result do

        local neu = waehrend

        if self.CycleTime and self.CycleTime >= frist then

            neu = jeMex * self:GetCurrentUnits(
                categories.MASSEXTRACTION * categories.TECH3 )

            if neu < waehrend then
                neu = waehrend
            end

            if neu > hoechstens then
                neu = hoechstens
            end
        end

        -- LOUDs Zuschlag bei Unterzahl nie unterschreiten
        if neu < self.UpgradeIssuedLimit and letzte == false then
            neu = self.UpgradeIssuedLimit
        end

        if neu != letzte then

            LOG("CUSTOMAI: "..tostring(self.Nickname).." - UpgradeIssuedLimit "
                ..tostring(self.UpgradeIssuedLimit).." -> "..neu
                .." auf Tick "..GetGameTick())

            self.UpgradeIssuedLimit = neu
            letzte = neu
        end

        WaitSeconds(10)
    end
end


-- --- Aufgabe 1: Personality umschreiben ----------------------------------

local oldAIBrain = AIBrain

AIBrain = Class(oldAIBrain) {

    OnCreateAI = function(self, planName)

        -- zuerst das Original, es setzt self.Personality und self.CheatValue
        oldAIBrain.OnCreateAI(self, planName)

        local personality = self.Personality

        if personality and string.find( personality, 'customai_' ) then

            -- Key aufbewahren - fuer eigene Auswertungen zur Laufzeit
            self.CustomAIKey = personality

            self.Personality = 'loud'

            LOG("CUSTOMAI: "..tostring(self.Nickname)
                .." - Personality von '"..personality.."' auf 'loud' gesetzt"
                .." (CustomAIKey = '"..personality.."', CheatValue = "
                ..tostring(self.CheatValue)..")")

            -- Aufgabe 4: die Startmassepunkte begrenzen
            self:ForkThread( StartmassepunkteKuerzen, personality )

            -- Aufgabe 5: mehr gleichzeitige Aufstiege zulassen
            self:ForkThread( AufstiegsgrenzeSetzen, personality )
        end
    end,
}
