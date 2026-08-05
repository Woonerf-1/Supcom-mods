-- mergeHelper.lua
--
-- Generic loader for merging objects (e.g. Tooltips, KeyMappings, etc.)
-- from a base file and multiple custom subfolders.
-- makes it possible for having multiple factions

local customDirectories = {
    'nomads',
}

function LoadMerged(basePath, fileName, objectName)
    -- Load base object into global table
    _G[objectName] = import('/loud' .. basePath .. '/' .. fileName .. '.lua')[objectName]

    -- Merge each custom directory
    for _, dir in ipairs(customDirectories) do
        local customFile = basePath .. '/custom/' .. dir .. '/' .. fileName .. '.lua'

        -- Try to import; if it fails, skip
        local ok, mod = pcall(import, customFile)
        if ok and mod and mod[objectName] then
            _G[objectName] = table.merged(_G[objectName], mod[objectName])
        end
    end
end