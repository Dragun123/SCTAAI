
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local SBC = '/lua/editor/SorianBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'SCTAAIFactoryBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SCTAAI T1Engineer LandFac',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 95,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.5}},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 10, 'FACTORY TECH1' } }, -- Stop after 10 facs have been built.
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                FactionIndex = 6,
                BuildStructures = {
                    'T1LandFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Engineer AirFac',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 90,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.8}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH1' } }, -- Don't build air fac immediately.
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, 'FACTORY TECH1' } }, -- Stop after 5 facs have been built.
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                FactionIndex = 6,
                BuildStructures = {
                    'T1AirFactory',
                }
            }
        }
    },
}