local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local SBC = '/lua/editor/SorianBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'SCTAAIAirBuilder',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SCTAAI Factory Bomber',
        PlatoonTemplate = 'T1AirBomber',
        Priority = 80,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.0, 0.7}},
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAI Factory Intie',
        PlatoonTemplate = 'T1AirFighter',
        Priority = 90,
        BuilderConditions = { -- Only make inties if the enemy air is strong.
            { SBC, 'HaveRatioUnitsWithCategoryAndAlliance', { false, 1.5, categories.AIR * categories.ANTIAIR, categories.AIR * categories.MOBILE, 'Enemy'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.0, 0.7}},
        },
        BuilderType = 'Air',
    },
}