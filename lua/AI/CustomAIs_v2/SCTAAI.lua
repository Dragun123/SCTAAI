--[[
    File    :   /lua/AI/CustomAIs_v2/SCTAAI.lua
    Author  :   SoftNoob
    Summary :
        Lists AIs to be included into the lobby, see /lua/AI/CustomAIs_v2/SorianAI.lua for another example.
        Loaded in by /lua/ui/lobby/aitypes.lua, this loads all lua files in /lua/AI/CustomAIs_v2/
]]

AI = {
	Name = 'SCTAAI',
	Version = '1',
	AIList = {
		{
			key = 'sctaai',
			name = '<LOC SctaAI_0001>AI: SCTA',
		},
	},
	CheatAIList = {
		{
			key = 'sctaaicheat',
			name = '<LOC SctaAI_0003>AIx: SCTA',
		},
	},
}