local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local SBC = '/lua/editor/SorianBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'SCTAAICommanderBuilder', -- Globally unique key that the AI base template file uses to add the contained builders to your AI.
    BuildersType = 'EngineerBuilder', -- The kind of builder this is.  One of 'EngineerBuilder', 'PlatoonFormBuilder', or 'FactoryBuilder'.
    -- The initial build order
    Builder {
        BuilderName = 'SCTAAI Initial Commander BO', -- Names need to be GLOBALLY unique.  Prefixing the AI name will help avoid name collisions with other AIs.
        PlatoonTemplate = 'CommanderBuilder', -- Specify what platoon template to use, see the PlatoonTemplates folder.
        Priority = 1000, -- Make this super high priority.  The AI chooses the highest priority builder currently available.
        BuilderConditions = { -- The build conditions determine if this builder is available to be used or not.
                { IBC, 'NotPreBuilt', {}}, -- Only run this if the base isn't pre-built.
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddBehaviors = {'CommanderBehaviorImproved'} --CommanderBehaviorSCTA -- Add a behaviour to the Commander unit once its done with it's BO.
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, }, -- Flag this builder to be only run once.
        BuilderData = {
            Construction = {
                FactionIndex = 6,
                BuildStructures = {
                    'T1LandFactory',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI ACU T1Mex',
        PlatoonTemplate = 'CommanderBuilder',
        Priority = 100,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        BuilderConditions = { 
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 40, -500, 1, 0, 'AntiSurface', 1 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                FactionIndex = 6,
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI ACU T1Pgen',
        PlatoonTemplate = 'CommanderBuilder',
        Priority = 90,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'LessThanEnergyTrend', { 0.0 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENERGYPRODUCTION * categories.TECH2 }},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                FactionIndex = 6,
                BuildStructures = {
                    'T1EnergyProduction',
                }
            }
        }
    },
}
