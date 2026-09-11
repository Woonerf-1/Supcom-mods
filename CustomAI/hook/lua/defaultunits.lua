-- ============================================================================
-- hook\lua\defaultunits.lua
--
-- Datei: C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\usermods\CustomAI\hook\lua\defaultunits.lua
--
-- ZWECK
-- Selbstaufstiege von Strukturen an Bedingungen binden. Aufstiege sind KEINE
-- Builder - sie laufen ueber SelfUpgradeThread, gestartet von
-- StructureUnit.LaunchUpgradeThread (defaultunits.lua Z. 696). Ueber
-- Prioritaeten sind sie deshalb nicht erreichbar; es bleibt nur dieser Hook.
--
-- Zwei Regeln, beide aus AIDefinitions.lua:
--   FabrikAufstiegAbT2Extraktoren    Fabrik T1 -> T2 erst ab n Extraktoren
--                                    ab Stufe 2
--   SpeicherAufstiegAbT3Extraktoren  Massespeicher T1 -> T2 erst ab n
--                                    Extraktoren der Stufe 3
--
-- Doku: doc.claude\mods\CustomAI_Stellschrauben.md Ebene 5
-- ============================================================================

-- ----------------------------------------------------------------------------
-- ZWEI KLASSEN, ZWEI GRUENDE
--
-- LaunchUpgradeThread ist in StructureUnit definiert (Z. 696).
--
-- FactoryUnit muss SEPARAT umhuellt werden:
--   defaultunits.lua Z. 147   StructureUnit = Class(Unit) { ... }
--   defaultunits.lua Z. 2046  FactoryUnit   = Class(StructureUnit) { ... }
-- Die Ableitung wird beim Laden der Datei ausgewertet - unser Hook laeuft erst
-- danach, FactoryUnit zeigt dann noch auf die alte StructureUnit.
--
-- Massespeicher dagegen leiten sich ERST BEIM LADEN DER EINHEITENSKRIPTE ab:
--   units\units\UAB1106\UAB1106_script.lua Z. 1
--   local AMassStorageUnit = import('/lua/defaultunits.lua').StructureUnit
-- Das passiert nach unserem Hook, sie bekommen also die umhuellte Fassung.
--
-- Alle anderen Strukturen laufen ebenfalls durch die StructureUnit-Umhuellung.
-- Sie greift deshalb nur bei MASSSTORAGE und reicht sonst unveraendert durch.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- WARUM SPEICHER UEBERHAUPT AUFSTEIGEN
--
-- defaultunits.lua Z. 877-883, am Ende von LaunchUpgradeThread:
--
--   -- pick up any structure that has an upgrade not covered by above
--   if __blueprints[finishedUnit.BlueprintID].General.UpgradesTo != '' ...
--       ... SelfUpgradeThread( ..., 1.01, 1.03, 9999, 9999, 36, 300, false, ... )
--
-- Ein Auffangzweig fuer alles, was oben nicht genannt ist. Der Massespeicher
-- faellt hinein: uab1106 hat UpgradesTo = 'uab2106'
-- (units\units\UAB1106\UAB1106_unit.bp Z. 90).
--
-- Beobachtung des Nutzers: diese Aufstiege liefen VOR denen der Extraktoren
-- und nahmen ihnen die Masse weg.
-- ----------------------------------------------------------------------------

local Regeln = false

-- Der Import passiert beim ersten Aufruf, nicht beim Laden der Datei:
-- defaultunits.lua wird sehr frueh geladen, und die Reihenfolge gegenueber
-- unseren eigenen Dateien ist nicht garantiert.
local function RegelnHolen(key)

    if not Regeln then

        Regeln = {}

        local ok, modul = pcall(import, '/mods/customai/lua/AI/AIDefinitions.lua')

        if ok and modul and modul.Definitions then

            for i, d in modul.Definitions do

                if d.Key then

                    Regeln[d.Key] = {
                        Fabrik    = d.FabrikAufstiegAbT2Extraktoren,
                        FabrikT3  = d.FabrikAufstiegT3AbT3Extraktoren,
                        Speicher  = d.SpeicherAufstiegAbT3Extraktoren,
                        ExtraktT3 = d.ExtraktorAufstiegT3ErstVollUmbaut,
                    }

                    LOG("CUSTOMAI Aufstieg: "..d.Key
                        .." - Fabrik ab "..tostring(d.FabrikAufstiegAbT2Extraktoren)
                        .." T2-Extraktoren, Extraktor T3 erst voll umbaut: "
                        ..tostring(d.ExtraktorAufstiegT3ErstVollUmbaut)
                        ..", Speicher ab "
                        ..tostring(d.SpeicherAufstiegAbT3Extraktoren)
                        .." T3-Extraktoren")
                end
            end
        else
            WARN("CUSTOMAI Aufstieg: AIDefinitions.lua nicht ladbar - Hook wirkungslos")
        end
    end

    return Regeln[key]
end

-- ----------------------------------------------------------------------------
-- IST DIESER EXTRAKTOR VOLL UMBAUT?
--
-- Statt einer armeeweiten Speicherzahl wird jeder Extraktor einzeln geprueft.
-- Damit kann ein Massepunkt, an dem gar kein Speicher hinpasst - Gelaende,
-- Wasser, ein fremdes Gebaeude -, den Aufstieg nicht dauerhaft blockieren.
--
-- Die vier Nachbarplaetze stehen in
-- C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\AI\AIBuilders\Loud_MAIN_base_templates.lua
-- Z. 2739-2776 (`MassAdjacency`) und sind bei allen vier Fraktionen gleich:
-- {-2,0}, {2,0}, {0,-2}, {0,2}.
--
-- Je Platz gilt:
--   Speicher steht schon      -> erledigt
--   frei UND baubar           -> noch nicht fertig, Aufstieg wartet
--   frei und NICHT baubar     -> zaehlt als erledigt
--
-- CanBuildStructureAt ist eine Brainmethode; LOUD nutzt sie genauso in
-- EconomyBuildConditions.lua Z. 214 und 251.
-- ----------------------------------------------------------------------------
local Versatz = { {-2, 0}, {2, 0}, {0, -2}, {0, 2} }

-- ----------------------------------------------------------------------------
-- DEN SPEICHER-BLUEPRINT NACHSCHLAGEN STATT FEST EINTRAGEN
--
-- Erste Fassung hatte 'ueb1106', 'uab1106', 'urb1106', 'xsb1106' fest in einer
-- Tabelle. Das bricht, sobald eine Fraktion dazukommt - und Fraktionsmods sind
-- bei LOUD ueblich.
--
-- Richtig ist die Nachschlagetabelle, die das Spiel selbst benutzt:
-- C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD\gamedata.entpackt\lua\lua\buildingTemplates.lua
--
--   BuildingTemplates[FactionIndex] = { { 'MassStorage', 'uab1106' }, ... }
--
-- Eine neue Fraktion bringt ihren eigenen Block mit; damit stimmt der
-- Blueprint automatisch. Genau so macht es auch EngineerBuilder.Create in
-- lua\sim\Builder.lua, wenn es BuildStructures aufloest.
--
-- Eine Wand oder ein anderes Gebaeude gleicher Groesse zu pruefen waere
-- unzuverlaessig: CanBuildStructureAt prueft neben dem Platzbedarf auch
-- Bauzonen und Gelaendeneigung, und die koennen sich je Gebaeudetyp
-- unterscheiden. Der echte Speicher ist die einzige ehrliche Probe.
-- ----------------------------------------------------------------------------
local SpeicherBPCache = {}

local function SpeicherBP(aiBrain)

    local fi = aiBrain.FactionIndex

    if not fi then
        return false
    end

    if SpeicherBPCache[fi] == nil then

        SpeicherBPCache[fi] = false

        local ok, modul = pcall(import, '/lua/buildingtemplates.lua')

        if ok and modul and modul.BuildingTemplates and modul.BuildingTemplates[fi] then

            for i, eintrag in modul.BuildingTemplates[fi] do

                if eintrag[1] == 'MassStorage' then
                    SpeicherBPCache[fi] = eintrag[2]
                    break
                end
            end
        end

        if not SpeicherBPCache[fi] then
            WARN("CUSTOMAI Aufstieg: kein MassStorage in BuildingTemplates["..fi
                 .."] - Extraktoraufstieg wird nicht gebremst")
        else
            LOG("CUSTOMAI Aufstieg: Speicher der Fraktion "..fi.." ist "
                ..SpeicherBPCache[fi])
        end
    end

    return SpeicherBPCache[fi]
end

local function ExtraktorVollUmbaut(unit, aiBrain)

    local bp = SpeicherBP(aiBrain)

    -- Unbekannte Fraktion: nicht blockieren.
    if not bp then
        return true
    end

    local pos = unit:GetPosition()

    for i, v in Versatz do

        local p = { pos[1] + v[1], pos[2], pos[3] + v[2] }

        -- ⚠ Nur FERTIGE Speicher zaehlen.
        --
        -- GetNumUnitsAroundPoint zaehlt auch angefangene Bauten mit. Ein
        -- Speicher, der gerade erst zu fuenf Prozent steht, haette den Platz
        -- damit als erledigt gemeldet - und der Extraktor waere aufgestiegen,
        -- bevor der Speicher fertig ist. Genau die Beobachtung
        -- "einer der T3 geht vor seinen Storages los".
        --
        -- Deshalb GetUnitsAroundPoint und GetFractionComplete je Einheit.
        local fertig = false

        for j, u in aiBrain:GetUnitsAroundPoint( categories.MASSSTORAGE, p, 1.5, 'Ally' ) do

            if not u.Dead and u:GetFractionComplete() == 1 then
                fertig = true
                break
            end
        end

        if not fertig then

            -- Platz frei oder Speicher noch im Bau: bebaubar heisst warten.
            -- Ist er nicht bebaubar UND steht dort auch nichts Angefangenes,
            -- gilt er als erledigt - so bleibt ein Massepunkt am Hang oder am
            -- Wasser kein Dauerhindernis.
            if aiBrain:CanBuildStructureAt( bp, p ) then
                return false
            end

            -- Baustelle vorhanden? CanBuildStructureAt meldet dort false,
            -- obwohl der Platz sehr wohl belegt wird - also abwarten.
            if aiBrain:GetNumUnitsAroundPoint( categories.MASSSTORAGE, p, 1.5, 'Ally' ) > 0 then
                return false
            end
        end
    end

    return true
end

-- ----------------------------------------------------------------------------
-- Gibt true zurueck, wenn der Aufstieg dieser Einheit noch warten soll.
--
-- Die Weiche haengt an aiBrain.CustomAIKey, gesetzt von hook\lua\aibrain.lua.
-- Fuer jede fremde KI und fuer menschliche Spieler ist das Feld nil, die
-- Regeltabelle liefert nichts und LOUDs Original laeuft unveraendert durch.
-- ----------------------------------------------------------------------------
local function AufstiegWarten(unit, aiBrain)

    if not aiBrain then
        return false
    end

    local key = aiBrain.CustomAIKey

    if not key then
        return false
    end

    local r = RegelnHolen(key)

    if not r then
        return false
    end

    -- Fabriken T1 -> T2: erst ab n Extraktoren ab Stufe 2.
    if r.Fabrik
       and EntityCategoryContains( categories.FACTORY, unit )
       and EntityCategoryContains( categories.TECH1, unit ) then

        if aiBrain:GetCurrentUnits( categories.MASSEXTRACTION - categories.TECH1 ) < r.Fabrik then
            return true
        end
    end

    -- Fabriken T2 -> T3: erst ab n Extraktoren der Stufe 3.
    --
    -- Vorgabe: "das T3 Fabrikupgrade kommt zu frueh, erst nachdem Extraktoren
    -- auf T3 sind". Der Aufstieg ist teuer und bringt vor der T3-Wirtschaft
    -- nichts, weil waehrend der Frist ohnehin keine Einheiten gebaut werden.
    if r.FabrikT3
       and EntityCategoryContains( categories.FACTORY, unit )
       and EntityCategoryContains( categories.TECH2, unit ) then

        if aiBrain:GetCurrentUnits( categories.MASSEXTRACTION * categories.TECH3 ) < r.FabrikT3 then
            return true
        end
    end

    -- Massespeicher: erst wenn genug Extraktoren auf Stufe 3 sind.
    if r.Speicher and EntityCategoryContains( categories.MASSSTORAGE, unit ) then

        if aiBrain:GetCurrentUnits( categories.MASSEXTRACTION * categories.TECH3 ) < r.Speicher then
            return true
        end
    end

    -- Extraktor T2 -> T3: erst wenn er von Speichern umbaut ist.
    --
    -- Reihenfolge, die daraus entsteht:
    --   1. Extraktoren auf T2
    --   2. T1-Speicher rundherum bauen
    --   3. Extraktoren auf T3
    --   4. Speicher auf T2
    --
    -- Der Schritt T1 -> T2 bleibt frei - nur die Stufe 2 wird gebremst.
    -- Geprueft wird je Extraktor, nicht armeeweit: ein Massepunkt, an dem kein
    -- Speicher hinpasst, haelt die uebrigen nicht auf.
    if r.ExtraktT3
       and EntityCategoryContains( categories.MASSEXTRACTION, unit )
       and EntityCategoryContains( categories.TECH2, unit ) then

        if not ExtraktorVollUmbaut(unit, aiBrain) then
            return true
        end
    end

    return false
end

-- ----------------------------------------------------------------------------
-- Nichts tun heisst spaeter noch einmal fragen.
--
-- FactoryBuilderManager.lua Z. 630-636 ruft LaunchUpgradeThread erneut auf,
-- sobald die Bauschlange einer Fabrik leer ist, und EngineerManager.lua Z. 608
-- tut dasselbe fuer Strukturen. Beide pruefen dabei `not unit.UpgradeThread`.
-- Da wir keinen Thread starten, kommt der naechste Versuch von selbst.
--
-- Ein Wartethread waere hier falsch: er muesste gegen Mehrfachaufrufe
-- abgesichert werden und ueberlebt den Aufstieg der Einheit nicht sauber.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- REFERENZPROTOKOLL: WAS BAUT DER MENSCHLICHE SPIELER?
--
-- Zweck: die Eroeffnung eines menschlichen Spielers als Zeitreihe mitschreiben,
-- um die Bauordnung der KI dagegen halten zu koennen. Bisher musste die
-- Vorgabe muendlich beschrieben und von Hand in Bedingungen uebersetzt werden -
-- genau daran sind mehrere Runden gescheitert.
--
-- LOUDs Debug-Ausgaben haengen an den KI-Managern; ein menschlicher Spieler hat
-- keine. Deshalb hier am Gebaeude selbst.
--
-- Geschaltet ueber DebugSchalter.ReferenzLog in AIDefinitions.lua. Der
-- aibrain-Hook schreibt daraus ScenarioInfo.ReferenzLog.
--
-- GRENZEN:
--   - nur STRUKTUREN. Mobile Einheiten leiten sich von MobileUnit ab, und
--     deren Unterklassen (WalkingLandUnit, AirUnit, ...) stehen in
--     defaultunits.lua schon vor unserem Hook fest - eine Umhuellung von
--     MobileUnit wuerde sie nicht mehr erreichen. Fuer eine Bauordnung sind
--     Strukturen aber das Wesentliche.
--   - protokolliert wird der BAUBEGINN, nicht die Fertigstellung.
--   - Aufstiege erscheinen ebenfalls, weil dabei eine neue Einheit entsteht.
-- ----------------------------------------------------------------------------
local function ReferenzSchreiben(unit, builder)

    local SI = rawget(_G, 'ScenarioInfo')

    if not (SI and SI.ReferenzLog) then
        return
    end

    local brain = GetAIBrain(unit)

    if not brain then
        return
    end

    -- BrainType ist 'Human' oder 'AI' (aibrain.lua Z. 831 und 863).
    -- Zivilarmeen tragen ebenfalls 'AI' und fallen damit heraus.
    if brain.BrainType != 'Human' then
        return
    end

    local wer = 'unbekannt'

    if builder and not builder.Dead then
        wer = tostring(builder.BlueprintID)
    end

    LOG("CUSTOMAI Referenz: "..tostring(brain.Nickname)
        .." beginnt "..tostring(unit.BlueprintID)
        .." ("..tostring(__blueprints[unit.BlueprintID].Description)..")"
        .." durch "..wer
        .." auf Tick "..GetGameTick())
end

-- ----------------------------------------------------------------------------
-- WARTEN STATT VERWERFEN
--
-- ⚠ TESTLAUF 22: die Luftfabrik stieg NIE auf T2 auf, obwohl die Bedingung
-- (4 Extraktoren ab Stufe 2) ab etwa Tick 3500 erfuellt war und der Lauf bis
-- 8770 ging.
--
-- Grund: der Wiederholungsversuch haengt an OnUnitBuilt.
-- FactoryBuilderManager.lua Z. 617-636:
--
--   if not factory.Dead then
--       if LOUDGETN(factory:GetCommandQueue()) <= 1 then
--           ...
--           if not factory.UpgradesComplete then
--               if not factory.UpgradeThread and factory.LaunchUpgradeThread then
--                   factory:LaunchUpgradeThread( aiBrain )
--
-- Der Aufruf kommt also nur, wenn die Fabrik gerade eine Einheit FERTIG
-- gebaut hat. Waehrend der No-Rush-Frist ist die Einheitenproduktion gesperrt,
-- und sobald die Technikergrenze erreicht ist, baut die Fabrik gar nichts mehr.
-- Damit gibt es keinen weiteren Versuch - unser einmaliges "return" war
-- endgueltig.
--
-- Deshalb jetzt ein Wartethread, der selbst nachfragt. Das Flag am Objekt
-- verhindert, dass bei mehreren Aufrufen mehrere Threads entstehen.
-- ----------------------------------------------------------------------------
local function AufstiegNachholen(unit, aiBrain, original)

    if unit.CustomAIWartetAufAufstieg then
        return
    end

    unit.CustomAIWartetAufAufstieg = true

    unit:ForkThread( function(self)

        while not self.Dead do

            WaitSeconds(5)

            if self.Dead then
                return
            end

            if not AufstiegWarten(self, aiBrain) then

                self.CustomAIWartetAufAufstieg = false

                if not self.UpgradeThread and not self.UpgradesComplete then

                    LOG("CUSTOMAI Aufstieg: "..tostring(self.EntityID)
                        .." Bedingung erfuellt, Aufstieg wird nachgeholt auf Tick "
                        ..GetGameTick())

                    original.LaunchUpgradeThread(self, aiBrain)
                end

                return
            end
        end
    end)
end

local altStructureUnit = StructureUnit

StructureUnit = Class(altStructureUnit) {

    OnStartBeingBuilt = function(self, builder, layer)

        ReferenzSchreiben(self, builder)

        return altStructureUnit.OnStartBeingBuilt(self, builder, layer)
    end,

    LaunchUpgradeThread = function(self, aiBrain)

        if AufstiegWarten(self, aiBrain) then
            AufstiegNachholen(self, aiBrain, altStructureUnit)
            return
        end

        return altStructureUnit.LaunchUpgradeThread(self, aiBrain)
    end,
}

-- ----------------------------------------------------------------------------
-- ALLE UNTERKLASSEN EINZELN UMHUELLEN
--
-- ⚠ TESTLAUF 16: das Referenzprotokoll blieb luecken haft - Luftfabrik auf
-- Tick 69, dann nichts bis Tick 3578. Extraktoren und Kraftwerke fehlten
-- vollstaendig, also genau der interessante Teil.
--
-- Grund ist wieder die Ableitungsfalle: defaultunits.lua leitet siebzehn
-- Klassen von StructureUnit ab (Z. 2046 bis 4911), und alle werden beim Laden
-- der Datei ausgewertet - VOR unserem Hook. Sie zeigen deshalb weiter auf die
-- alte StructureUnit.
--
-- Nur Klassen, die erst in den Einheitenskripten entstehen, bekamen die
-- Umhuellung. Massespeicher gehoeren dazu (UAB1106_script.lua importiert
-- StructureUnit direkt) - deshalb tauchten ausgerechnet die im Log auf.
--
-- Extraktoren haengen an MassCollectionUnit, Kraftwerke an
-- EnergyCreationUnit. Beide muessen einzeln umhuellt werden.
--
-- Die Liste unten deckt alles ab, was fuer eine Bauordnung zaehlt. Bewusst
-- ausgelassen: ConcreteStructureUnit, WallStructureUnit, FootprintDummyUnit,
-- TransportBeaconUnit, MineStructureUnit - Beiwerk ohne Aussagekraft.
-- ----------------------------------------------------------------------------
local function ReferenzUmhuellen(name, klasse)

    if not klasse then
        WARN("CUSTOMAI Referenz: Klasse \""..name.."\" nicht gefunden")
        return klasse
    end

    local alt = klasse

    return Class(alt) {

        OnStartBeingBuilt = function(self, builder, layer)

            ReferenzSchreiben(self, builder)

            return alt.OnStartBeingBuilt(self, builder, layer)
        end,
    }
end

TeleportUnit           = ReferenzUmhuellen('TeleportUnit',           TeleportUnit)
AirStagingPlatformUnit = ReferenzUmhuellen('AirStagingPlatformUnit', AirStagingPlatformUnit)
EnergyCreationUnit     = ReferenzUmhuellen('EnergyCreationUnit',     EnergyCreationUnit)
EnergyStorageUnit      = ReferenzUmhuellen('EnergyStorageUnit',      EnergyStorageUnit)
MassCollectionUnit     = ReferenzUmhuellen('MassCollectionUnit',     MassCollectionUnit)
MassFabricationUnit    = ReferenzUmhuellen('MassFabricationUnit',    MassFabricationUnit)
RadarUnit              = ReferenzUmhuellen('RadarUnit',              RadarUnit)
SonarUnit              = ReferenzUmhuellen('SonarUnit',              SonarUnit)
ShieldStructureUnit    = ReferenzUmhuellen('ShieldStructureUnit',    ShieldStructureUnit)

local altFactoryUnit = FactoryUnit

FactoryUnit = Class(altFactoryUnit) {

    -- Fabriken leiten sich schon vor unserem Hook von StructureUnit ab
    -- (defaultunits.lua Z. 2046), bekommen die Umhuellung oben also NICHT.
    -- Deshalb hier noch einmal.
    OnStartBeingBuilt = function(self, builder, layer)

        ReferenzSchreiben(self, builder)

        return altFactoryUnit.OnStartBeingBuilt(self, builder, layer)
    end,

    LaunchUpgradeThread = function(self, aiBrain)

        if AufstiegWarten(self, aiBrain) then
            AufstiegNachholen(self, aiBrain, altFactoryUnit)
            return
        end

        return altFactoryUnit.LaunchUpgradeThread(self, aiBrain)
    end,
}
