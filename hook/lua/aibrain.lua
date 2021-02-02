

local SCTAAIBrainClass = AIBrain
AIBrain = Class(SCTAAIBrainClass) {

    OnCreateAI = function(self, planName)
        SCTAAIBrainClass.OnCreateAI(self, planName)
        local per = ScenarioInfo.ArmySetup[self.Name].AIPersonality
        --LOG('Oncreate')
        if string.find(per, 'scta') then
            --LOG('* AI-RNG: This is SCTA')
            self.SCTAAI = true

        end
    end,

}