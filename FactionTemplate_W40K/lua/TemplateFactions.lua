-- Faction entries of this template (data only). Custom Factions reads Key, DisplayName, the icons and TooltipID
-- in the lobby. A playable faction also needs Category, FactionInUnitBp, InitialUnit, DefaultSkin, loading screen
-- fields and the Custom Factions fields (see the Nomads mod for a complete entry).

Factions = {
    {
        Key = 'imperium',
        DisplayName = "Imperium",
        CampaignFileDesignator = 'I',
        TooltipID = 'lob_imperium',
        SoundPrefix = 'UEF',
        TransmissionLogColor = 'ffc9a227',
        Icon      = '/mods/factiontemplate_w40k/textures/ui/common/widgets/faction-icons-alpha_bmp/imperium_ico.png',   -- 24 x 24
        SmallIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-sm/imperium_ico.png',                   -- 18 x 18
        LargeIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-lg/imperium_ico.png',                   -- 60 x 60
    },
    {
        Key = 'orks',
        DisplayName = "Orks",
        CampaignFileDesignator = 'O',
        TooltipID = 'lob_orks',
        SoundPrefix = 'UEF',
        TransmissionLogColor = 'ff4c8a2e',
        Icon      = '/mods/factiontemplate_w40k/textures/ui/common/widgets/faction-icons-alpha_bmp/orks_ico.png',   -- 24 x 24
        SmallIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-sm/orks_ico.png',                   -- 18 x 18
        LargeIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-lg/orks_ico.png',                   -- 60 x 60
    },
    {
        Key = 'eldar',
        DisplayName = "Eldar",
        CampaignFileDesignator = 'E',
        TooltipID = 'lob_eldar',
        SoundPrefix = 'UEF',
        TransmissionLogColor = 'ff2a9a9a',
        Icon      = '/mods/factiontemplate_w40k/textures/ui/common/widgets/faction-icons-alpha_bmp/eldar_ico.png',   -- 24 x 24
        SmallIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-sm/eldar_ico.png',                   -- 18 x 18
        LargeIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-lg/eldar_ico.png',                   -- 60 x 60
    },
    {
        Key = 'necrons',
        DisplayName = "Necrons",
        CampaignFileDesignator = 'C',
        TooltipID = 'lob_necrons',
        SoundPrefix = 'UEF',
        TransmissionLogColor = 'ff2fbf4f',
        Icon      = '/mods/factiontemplate_w40k/textures/ui/common/widgets/faction-icons-alpha_bmp/necrons_ico.png',   -- 24 x 24
        SmallIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-sm/necrons_ico.png',                   -- 18 x 18
        LargeIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-lg/necrons_ico.png',                   -- 60 x 60
    },
    {
        Key = 'tyranids',
        DisplayName = "Tyranids",
        CampaignFileDesignator = 'Y',
        TooltipID = 'lob_tyranids',
        SoundPrefix = 'UEF',
        TransmissionLogColor = 'ff9a2f5a',
        Icon      = '/mods/factiontemplate_w40k/textures/ui/common/widgets/faction-icons-alpha_bmp/tyranids_ico.png',   -- 24 x 24
        SmallIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-sm/tyranids_ico.png',                   -- 18 x 18
        LargeIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-lg/tyranids_ico.png',                   -- 60 x 60
    },
    {
        Key = 'chaos',
        DisplayName = "Chaos",
        CampaignFileDesignator = 'H',
        TooltipID = 'lob_chaos',
        SoundPrefix = 'UEF',
        TransmissionLogColor = 'ff8a1c1c',
        Icon      = '/mods/factiontemplate_w40k/textures/ui/common/widgets/faction-icons-alpha_bmp/chaos_ico.png',   -- 24 x 24
        SmallIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-sm/chaos_ico.png',                   -- 18 x 18
        LargeIcon = '/mods/factiontemplate_w40k/textures/ui/common/faction_icon-lg/chaos_ico.png',                   -- 60 x 60
    },
}