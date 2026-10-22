-- Nomads: Baeume und das Schwarze Loch, siehe doc.claude\mods\Nomads.md (Abschnitt Hooks).
-- Ersetzt den alten Hook, der LOUDs Tree fast vollstaendig durch einen FAF-Umbau ersetzte (ohne
-- Prop.OnDamage, ohne Feuer-Uebergreifen). Jetzt nur ein Wrapper um LOUDs Tree.OnDamage
-- (lua.scd, lua/proptree.lua Z. 35 ff.): die Nomads-Schadensarten BlackholeDamage / BlackholeDeathNuke
-- ziehen den Baum ins Schwarze Loch und loesen ihn auf; alles andere behandelt LOUD.

local NomadsEffectTemplate = import('/mods/nomads/lua/nomadseffecttemplate.lua')

local oldTree = Tree

Tree = Class(oldTree) {

    OnDamage = function(self, instigator, armormod, direction, type)
        if type == 'BlackholeDamage' or type == 'BlackholeDeathNuke' then
            if not self.BlackholeSuckedIn then
                self.BlackholeSuckedIn = true
                if instigator and instigator.NukeEntity and instigator.NukeEntity.OnPropBeingSuckedIn then
                    instigator.NukeEntity:OnPropBeingSuckedIn(self)
                end
                for _, v in NomadsEffectTemplate.TreeDisintegrate or {} do
                    CreateEmitterAtBone(self, 0, -1, v)
                end
                self:Destroy()
            end
            return
        end
        oldTree.OnDamage(self, instigator, armormod, direction, type)
    end,
}
