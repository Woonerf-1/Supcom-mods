-- Auszug aus BrewLAN for LOUD, siehe lua\README.md

function AssistThread(self)
    while true do
        if self:IsIdleState() then
            --Insert some kind of table sort for most damaged here
            local units = self:GetAIBrain():GetUnitsAroundPoint(categories.SELECTABLE, self:GetPosition(), 30, 'Ally' )
            for i, v in units do
                if v:GetHealthPercent() != 1 then
                    IssueRepair({self}, v)
                end
            end
        end
        WaitTicks(30)
    end
end
