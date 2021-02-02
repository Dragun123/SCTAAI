local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local SBC = '/lua/editor/SorianBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'SCTAAIAirFormers',
    BuildersType = 'PlatoonFormBuilder', -- A PlatoonFormBuilder is for builder groups of units.
    Builder {
        BuilderName = 'SCTAAI Air Attack',
        PlatoonTemplate = 'BomberAttack',
        Priority = 100,
        InstanceCount = 2,
        BuilderType = 'Any',        
        BuilderConditions = { },
    },
    Builder {
        BuilderName = 'SCTAAI Air Intercept',
        PlatoonTemplate = 'AntiAirHunt',
        Priority = 100,
        InstanceCount = 200,
        BuilderType = 'Any',     
        BuilderConditions = { },
    },
}