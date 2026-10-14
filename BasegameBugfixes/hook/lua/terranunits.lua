-- Rueckfall fuer unsichtbare Fatboys, siehe doc.claude\mods\BasegameBugfixes.md B-04

local OldTMobileFactoryUnit = TMobileFactoryUnit

TMobileFactoryUnit = Class(OldTMobileFactoryUnit) {

    StopBeingBuiltEffects = function(self, builder, layer)

        if not self.BeingBuiltShowBoneTriggered then
            self:ShowBone(0, true)
            self:HideLandBones()
        end

        self.BeingBuiltShowBoneTriggered = nil

        OldTMobileFactoryUnit.StopBeingBuiltEffects(self, builder, layer)
    end,
}
