-- Nomads-Texte in LOC einhaengen, siehe doc.claude\mods\Nomads.md Abschnitt "Texte".
-- LOUD laedt nur /loc/<sprache>/strings_db.lua (lua/system/Localization.lua Z. 18-45).
-- Install() umhuellt die globale LOC einmal je Lua-State: nur fuer Schluessel aus NomadsStrings,
-- alles andere geht unveraendert an LOUDs LOC.

function Install()
    if rawget(_G, '__NomadsLocInstalled') then
        return
    end
    rawset(_G, '__NomadsLocInstalled', true)

    local Strings = import('/mods/nomads/lua/NomadsStrings.lua').Strings
    local OldLOC = rawget(_G, 'LOC')
    local LocExpand = rawget(_G, 'LocExpand')

    if not OldLOC then
        return
    end

    rawset(_G, 'LOC', function(s)
        if type(s) == 'string' and string.sub(s, 1, 5) == '<LOC ' then
            local i = string.find(s, '>')
            if i then
                local r = Strings[string.sub(s, 6, i - 1)]
                if r then
                    if LocExpand then return LocExpand(r) end
                    return r
                end
            end
        end
        return OldLOC(s)
    end)
end