--[[
    File    :   /lua/AI/PlattonTemplates/SCTAAITemplates.lua
    Author  :   SoftNoob
    Summary :
        Responsible for defining a mapping from AIBuilders keys -> Plans (Plans === platoon.lua functions)
]]

PlatoonTemplate {
    Name = 'SCTAAILandAttack',
    Plan = 'StrikeForceAI', -- The platoon function to use.
    GlobalSquads = {
        { categories.MOBILE * categories.LAND - categories.EXPERIMENTAL - categories.ENGINEER, -- Type of units.
          2, -- Min number of units.
          20, -- Max number of units.
          'attack', -- platoon types: 'support', 'attack', 'scout',
          'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

PlatoonTemplate {
    Name = 'T1LandScoutMod',
    FactionSquads = {
        UEF = {
            { 'uel0101', 1, 1, 'scout', 'none' }
        },
        Aeon = {
            { 'ual0101', 1, 1, 'scout', 'none' }
        },
        Cybran = {
            { 'url0101', 1, 1, 'scout', 'none' }
        },
        Seraphim = {
            { 'xsl0101', 1, 1, 'scout', 'none' }
        },
        Arm = {
            { 'armflea', 1, 1, 'scout', 'none' }
        },
        Core = {
            { 'corfav', 1, 1, 'scout', 'none' }
        },
    }
}

PlatoonTemplate {
    Name = 'T1LandDFBotMod',
    FactionSquads = {
        UEF = {
            { 'uel0106', 1, 1, 'attack', 'None' }
        },
        Aeon = {
            { 'ual0106', 1, 1, 'attack', 'None' }
        },
        Cybran = {
            { 'url0106', 1, 1, 'attack', 'None' }
        },
        Seraphim = {
            { 'xsl0201', 1, 1, 'attack', 'None' }
        },
        Nomads = {
            { 'xnl0106', 1, 1, 'Attack', 'none' }
        },
        Arm = {
            { 'armpw', 1, 1, 'attack', 'none' }
        },
        Core = {
            { 'corgator', 1, 1, 'attack', 'none' }
        },
    }
}

PlatoonTemplate {
    Name = 'T1LandArtilleryMod',
    FactionSquads = {
        UEF = {
            { 'uel0103', 1, 1, 'Attack', 'none' }
        },
        Aeon = {
            { 'ual0103', 1, 1, 'Attack', 'none' }
        },
        Cybran = {
            { 'url0103', 1, 1, 'Attack', 'none' }
        },
        Seraphim = {
            { 'xsl0103', 1, 1, 'Attack', 'none' }
        },
        Arm = {
            { 'armham', 1, 1, 'attack', 'none' }
        },
        Core = {
            { 'corlevlr', 1, 1, 'attack', 'none' }
        },
    }
}

PlatoonTemplate {
    Name = 'T1BuildEngineerMod',
    FactionSquads = {
        UEF = {
            { 'uel0105', 1, 1, 'support', 'None' }
        },
        Aeon = {
            { 'ual0105', 1, 1, 'support', 'None' }
        },
        Cybran = {
            { 'url0105', 1, 1, 'support', 'None' }
        },
        Seraphim = {
            { 'xsl0105', 1, 1, 'support', 'None' }
        },
        Arm = {
            { 'armck', 1, 1, 'support', 'None' }
        },
        Core = {
            { 'corcv', 1, 1, 'support', 'None' }
        },
    }
}