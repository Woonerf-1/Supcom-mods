-- PlayTest - vier Unterkommandanten je ACU. NUR FUER TESTPARTIEN.
-- Erlaeuterung: siehe hooks.md

local SCUS = {
    { Id = 'uel0301', Name = 'UEF'      },
    { Id = 'ual0301', Name = 'Aeon'     },
    { Id = 'url0301', Name = 'Cybran'   },
    { Id = 'xsl0301', Name = 'Seraphim' },
}

-- Ablagepunkte relativ zum ACU, im Kreuz.
local ABSTAND = 6

local VERSATZ = {
    {  ABSTAND,  0 },
    { -ABSTAND,  0 },
    {  0,  ABSTAND },
    {  0, -ABSTAND },
}


local function SpawneUnterkommandanten()

    WaitSeconds(1)

    local gesamt = 0

    for armee, brain in ArmyBrains do

        local kommandanten = brain:GetListOfUnits(categories.COMMAND, false)

        if not kommandanten or table.getn(kommandanten) == 0 then

            LOG('PLAYTEST: Armee '..armee..' ('..tostring(brain.Nickname)
                ..') hat keinen ACU - uebersprungen')

        else
            local acu = kommandanten[1]
            local pos = acu:GetPosition()

            for i, scu in SCUS do

                local x = pos[1] + VERSATZ[i][1]
                local z = pos[3] + VERSATZ[i][2]
                local y = GetTerrainHeight(x, z)

                local ok, ergebnis = pcall(CreateUnitHPR, scu.Id, armee, x, y, z, 0, 0, 0)

                if ok and ergebnis then
                    gesamt = gesamt + 1
                else
                    WARN('PLAYTEST: '..scu.Id..' fuer Armee '..armee
                        ..' konnte nicht erzeugt werden: '..tostring(ergebnis))
                end
            end

            LOG('PLAYTEST: Armee '..armee..' ('..tostring(brain.Nickname)
                ..') - vier SCUs beim ACU abgesetzt')
        end
    end

    LOG('PLAYTEST: insgesamt '..gesamt..' Unterkommandanten erzeugt')
end


do
    local OldBeginSession = BeginSession

    function BeginSession()

        OldBeginSession()

        ForkThread(SpawneUnterkommandanten)
    end
end
