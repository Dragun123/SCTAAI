local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local SBC = '/lua/editor/SorianBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'SCTAAILandFormers',
    BuildersType = 'PlatoonFormBuilder', -- A PlatoonFormBuilder is for builder groups of units.
    Builder {
        BuilderName = 'SCTAAI Land Attack',
        PlatoonTemplate = 'SCTAAILandAttack', -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 100,
        InstanceCount = 200,
        BuilderType = 'Any',
        BuilderData = {
            NeverGuardBases = true,
            NeverGuardEngineers = false,
            UseFormation = 'AttackFormation',
        },        
        BuilderConditions = { },
    },
}