--[[
    File    :   /lua/AI/AIBaseTemplates/SCTAAI.lua
    Author  :   SoftNoob
    Summary :
        Lists AIs to be included into the lobby, see /lua/AI/CustomAIs_v2/SorianAI.lua for another example.
        Loaded in by /lua/ui/lobby/aitypes.lua, this loads all lua files in /lua/AI/CustomAIs_v2/
]]

BaseBuilderTemplate {
    BaseTemplateName = 'SCTAAI',
    Builders = {
        -- List all our builder grous here
        -- ACU
        'SCTAAICommanderBuilder',
        
        -- Unit Builders
        'SCTAAILandBuilder',
        'SCTAAIAirBuilder',
        'SCTAAILandFormers',
        'SCTAAIAirFormers',
        
        -- Buildings etc
        'SCTAAIEnergyBuilder',
        'SCTAAIEngineerMassBuilder',
        'SCTAAIFactoryBuilders',
    },
    NonCheatBuilders = {
        -- Specify builders that are _only_ used by non-cheating AI (e.g. scouting)
    },
    BaseSettings = { },
    ExpansionFunction = function(aiBrain, location, markerType)
        -- This is used if you want to make stuff outside of the starting location.
        return 0
    end,
    
    FirstBaseFunction = function(aiBrain)
        local per = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if per == 'sctaai' or per == 'sctaaicheat' then
            return 1000, 'SCTAAI'
        end
        return -1
    end,
}