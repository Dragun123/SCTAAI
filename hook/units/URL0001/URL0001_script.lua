#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0001/UAL0001_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Aeon Commander Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local oldURL0001 = URL0001
URL0001 = Class(oldURL0001) {
    PlayCommanderWarpInEffect = function(self)
        if not self.Dead then
            self:HideBone(0, true)
            self:SetUnSelectable(false)
            self:SetBusy(true)
            self:SetBlockCommandQueue(true)
            self:ForkThread(self.WarpInEffectThread)
        end
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        oldURL0001.OnStopBeingBuilt(self, builder, layer)
        local aiBrain = self:GetAIBrain()
		if aiBrain.SCTAAI then
            local position = self:GetPosition()
				CreateUnitHPR('corcom', self:GetArmy(), (position.x), (position.y+1), (position.z), 0, 0, 0)  
                self:Destroy()
        end
        self:ForkThread(self.PlayCommanderWarpInEffect) --should only be used for testing out the drop animation
    end,

}

TypeClass = URL0001