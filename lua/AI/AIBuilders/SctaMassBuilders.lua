local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local SBC = '/lua/editor/SorianBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'SCTAAIEngineerMassBuilder',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SCTAAI T1Engineer Mex',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 100,
        InstanceCount = 2, -- The max number concurrent instances of this builder.
        BuilderConditions = { },
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
}