name = "Advanced Unit rebalence"
version = 1.0
description = "Provides the Cybran with proximity mines, t3 field Engineers as well as stealth field generators as well as the Seraphim with a Restoration field"
copyright = "copytheft"
author = "Colin"
uid = "692d0451-e1b4-4b7c-a33d-2addf36be6cb"
icon = "/mods/nomads-4-loud/icons/nomads.bmp"
selectable = true
enabled = true
exclusive = false
ui_only = false
mountpoints = {
    ['effects'] = '/effects',
    ['env'] = '/env',
    ['loc'] = '/loc',
    ['lua'] = '/lua',
    ['meshes'] = '/meshes',
    ['movies'] = '/movies',
    ['hook'] = '/hook',
    ['projectiles'] = '/projectiles',
    ['sounds'] = '/sounds',
    ['textures'] = '/textures',
    ['units'] = '/units',
}
hooks = {
    '/hook',
    '/sounds',
}