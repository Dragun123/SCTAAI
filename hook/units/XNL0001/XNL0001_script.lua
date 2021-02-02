local oldXNL0001 = XNL0001
XNL0001 = Class(oldXNL0001) {
    PlayCommanderWarpInEffect = function(self)  -- part of initial dropship animation
        if not self.Dead then
        self:SetUnSelectable(false)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self.PlayCommanderWarpInEffectFlag = true
        self:ForkThread(self.DoMeteorAnim)
        end
    end,


    OnStopBeingBuilt = function(self, builder, layer)
        oldXNL0001.OnStopBeingBuilt(self, builder, layer)
        local aiBrain = self:GetAIBrain()
		if aiBrain.SCTAAI then
            local position = self:GetPosition()
			CreateUnitHPR('corcom', self:GetArmy(), (position.x), (position.y+1), (position.z), 0, 0, 0)  
            self:Destroy()
        end
        self:ForkThread(self.PlayCommanderWarpInEffect) --should only be used for testing out the drop animation
    end,

}

TypeClass = XNL0001
