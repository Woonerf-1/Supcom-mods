-- Faction entries of this template (data only). Custom Factions reads Key, DisplayName, the icons and TooltipID
-- in the lobby. A playable faction also needs Category, FactionInUnitBp, InitialUnit, DefaultSkin, loading screen
-- fields and the Custom Factions fields (see the Nomads mod for a complete entry).

Factions = {
    {
        Key = 'zerg',
        DisplayName = "Zerg",
        CampaignFileDesignator = 'Z',
        TooltipID = 'lob_zerg',
        SoundPrefix = 'UEF',
        TransmissionLogColor = 'ff7a3fa0',
        Icon      = '/mods/factiontemplate_starcraft/textures/ui/common/widgets/faction-icons-alpha_bmp/zerg_ico.png',   -- 24 x 24
        SmallIcon = '/mods/factiontemplate_starcraft/textures/ui/common/faction_icon-sm/zerg_ico.png',                   -- 18 x 18
        LargeIcon = '/mods/factiontemplate_starcraft/textures/ui/common/faction_icon-lg/zerg_ico.png',                   -- 60 x 60
    },
    {
        Key = 'protoss',
        DisplayName = "Protoss",
        CampaignFileDesignator = 'P',
        TooltipID = 'lob_protoss',
        SoundPrefix = 'UEF',
        TransmissionLogColor = 'ffd4a62a',
        Icon      = '/mods/factiontemplate_starcraft/textures/ui/common/widgets/faction-icons-alpha_bmp/protoss_ico.png',   -- 24 x 24
        SmallIcon = '/mods/factiontemplate_starcraft/textures/ui/common/faction_icon-sm/protoss_ico.png',                   -- 18 x 18
        LargeIcon = '/mods/factiontemplate_starcraft/textures/ui/common/faction_icon-lg/protoss_ico.png',                   -- 60 x 60
    },
    {
        Key = 'terran',
        DisplayName = "Terran",
        CampaignFileDesignator = 'T',
        TooltipID = 'lob_terran',
        SoundPrefix = 'UEF',
        TransmissionLogColor = 'ff3f6fa8',
        Icon      = '/mods/factiontemplate_starcraft/textures/ui/common/widgets/faction-icons-alpha_bmp/terran_ico.png',   -- 24 x 24
        SmallIcon = '/mods/factiontemplate_starcraft/textures/ui/common/faction_icon-sm/terran_ico.png',                   -- 18 x 18
        LargeIcon = '/mods/factiontemplate_starcraft/textures/ui/common/faction_icon-lg/terran_ico.png',                   -- 60 x 60
    },
}