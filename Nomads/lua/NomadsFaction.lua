-- Fraktionseintrag der Nomads, siehe doc.claude\mods\Nomads.md Abschnitt 3
-- Quelle: nomads-4-loud\shadow\lua\CustomFactions\Nomads.lua (FactionList[1]).
-- Geaendert: Fraktions-Icons, Veteranen-Logo, Untaetig-Symbole und Ladefilm zeigen absolut auf diesen Mod
-- (UIUtil.UIFile uebernimmt vorhandene absolute Pfade unveraendert).
-- Die uebrigen Pfade betreffen das Spiel und werden mit dem Spielteil angepasst.

Faction = {
    Key = 'nomads',
    Category = 'NOMADS',
    FactionInUnitBp = 'Nomads',
    DisplayName = "<LOC _NOMADS>Nomads",
    SoundPrefix = 'Nomads',
    InitialUnit = 'XNL0001',
    CampaignFileDesignator = 'N',
    TransmissionLogColor = 'ff0000ff',
    Icon = "/mods/nomads/textures/ui/common/widgets/faction-icons-alpha_bmp/nomads_ico.dds",
    VeteranIcon = "/mods/nomads/textures/ui/common/game/veteran-logo_bmp/nomads-veteran_bmp.dds",
    SmallIcon = "/mods/nomads/textures/ui/common/faction_icon-sm/nomads_ico.dds",
    LargeIcon = "/mods/nomads/textures/ui/common/faction_icon-lg/nomads_ico.dds",
    TooltipID = 'lob_nomads',
    DefaultSkin = 'nomads',
    loadingMovie = '/mods/nomads/movies/nomads_load.sfd',     -- Ladebildschirm (gamemain.lua Z. 447-455)
    loadingColor = 'FFbadbdb',
    loadingTexture = '/UEF_load.dds',
    IdleEngTextures = {
        T1 = '/mods/nomads/textures/ui/common/icons/units/xnl0105_icon.dds',
        T2 = '/mods/nomads/textures/ui/common/icons/units/xnl0208_icon.dds',
        T2F = '/mods/nomads/textures/ui/common/icons/units/xnl0209_icon.dds',
        T3 = '/mods/nomads/textures/ui/common/icons/units/xnl0309_icon.dds',
        SCU = '/mods/nomads/textures/ui/common/icons/units/xnl0301_icon.dds',
    },
    IdleFactoryTextures = {
        LAND = {
            '/mods/nomads/textures/ui/common/icons/units/xnb0101_icon.dds',
            '/mods/nomads/textures/ui/common/icons/units/xnb0201_icon.dds',
            '/mods/nomads/textures/ui/common/icons/units/xnb0301_icon.dds',
        },
        AIR = {
            '/mods/nomads/textures/ui/common/icons/units/xnb0102_icon.dds',
            '/mods/nomads/textures/ui/common/icons/units/xnb0202_icon.dds',
            '/mods/nomads/textures/ui/common/icons/units/xnb0302_icon.dds',
        },
        NAVAL = {
            '/mods/nomads/textures/ui/common/icons/units/xnb0103_icon.dds',
            '/mods/nomads/textures/ui/common/icons/units/xnb0203_icon.dds',
            '/mods/nomads/textures/ui/common/icons/units/xnb0303_icon.dds',
        },
        GATE = {
            '/mods/nomads/textures/ui/common/faction_icon-sm/nomads_ico.dds',
            '/mods/nomads/textures/ui/common/faction_icon-sm/nomads_ico.dds',
            '/mods/nomads/textures/ui/common/icons/units/xnb0304_icon.dds',
        },
    },
    -- Vorlagen: Buchstaben-Praefixe der Gebaeude-IDs (fraktionsneutrale Umrechnung in Custom Factions,
    -- construction.lua/ConvertID). Wert aus nomads-4-loud\shadow\lua\ui\game\construction.lua.
    BuildingPrefixes = { 'xna', 'xnb', 'xnc', 'xnl', 'xno', 'xns', 'xny', 'znb' },

    -- Die folgenden Felder liest LOUD selbst nicht; ausgewertet werden sie von den fraktionsneutralen Hooks in
    -- Custom Factions (doc.claude\uebergabe\CustomFactions\README.md, Abschnitt Felder).

    -- Vorab-Bau (CF aibrain.lua). Quelle: nomads-4-loud\shadow\lua\CustomFactions\Nomads.lua Z. 51-60.
    PreBuildUnits = {
        MassExtractors = { 'xnb1103', 'xnb1103', 'xnb1103', 'xnb1103', },
        Regular = { 'xnb0101', 'xnb1101', 'xnb1101', 'xnb1101', 'xnb1101', },
    },
    BaseTemplatesFile = '/mods/nomads/lua/AI/NomadsAIFiles/BaseTemplates.lua',
    BuildingTemplatesFile = '/mods/nomads/lua/AI/NomadsAIFiles/BuildingTemplates.lua',
    UpgradeTemplatesFile = '/mods/nomads/lua/AI/NomadsAIFiles/UpgradeTemplates.lua',
    PlatoonTemplateKey = 'Nomads',

    -- KI-Basis-Layouts: Gebaeudetypen wie UEF (CF basetemplates.lua / Loud_*_Templates.lua)
    LayoutFallback = 1,

    -- Sprueche: Nummern vergibt Custom Factions fortlaufend ab 65 (CF taunt.lua / sorianutilities.lua)
    TauntsFile = '/mods/nomads/lua/NomadsTaunts.lua',

    -- Adjacency-Strahl (CF EffectUtilities.lua). Quelle: nomads-4-loud\hook\lua\EffectUtilities.lua.
    AdjacencyBeam = '/mods/nomads/effects/emitters/nomads_adjacency_beam.bp',
}