
local GetEconomyStored = moho.aibrain_methods.GetEconomyStored
local GetEconomyStoredRatio = moho.aibrain_methods.GetEconomyStoredRatio
local GetEconomyTrend = moho.aibrain_methods.GetEconomyTrend
local GetEconomyIncome = moho.aibrain_methods.GetEconomyIncome
local GetEconomyRequested = moho.aibrain_methods.GetEconomyRequested
local GetUnitsAroundPoint = moho.aibrain_methods.GetUnitsAroundPoint
local GetNumUnitsAroundPoint = moho.aibrain_methods.GetNumUnitsAroundPoint
local MakePlatoon = moho.aibrain_methods.MakePlatoon
local AssignUnitsToPlatoon = moho.aibrain_methods.AssignUnitsToPlatoon
local PlatoonExists = moho.aibrain_methods.PlatoonExists
local GetListOfUnits = moho.aibrain_methods.GetListOfUnits
local GetPlatoonPosition = moho.platoon_methods.GetPlatoonPosition
local PlatoonExists = moho.aibrain_methods.PlatoonExists
local GetMostRestrictiveLayer = import('/lua/ai/aiattackutilities.lua').GetMostRestrictiveLayer

function CommanderBehaviorSCTA(platoon)
    for _, v in platoon:GetPlatoonUnits() do
        if not v.Dead and not v.CommanderThread then
            v.CommanderThread = v:ForkThread(CommanderThreadSCTA, platoon)
        end
    end
end


function CommanderThreadSCTA(cdr, platoon)
    if platoon.PlatoonData.aggroCDR then
        local mapSizeX, mapSizeZ = GetMapSize()
        local size = mapSizeX
        if mapSizeZ > mapSizeX then
            size = mapSizeZ
        end
        cdr.Mult = (size / 2) / 100
    end

    SetCDRHome(cdr, platoon)

    local aiBrain = cdr:GetAIBrain()
    aiBrain:BuildScoutLocationsSorian()
    if not SUtils.CheckForMapMarkers(aiBrain) then
        SUtils.AISendChat('all', ArmyBrains[aiBrain:GetArmyIndex()].Nickname, 'badmap')
    end

    moveOnNext = false
    moveWait = 0
    local Mult = cdr.Mult or 1
    local Delay = platoon.PlatoonData.Delay or 165
    local WaitTaunt = 600 + Random(1, 600)
    while not cdr.Dead do
        if Mult > 1 and (SBC.GreaterThanGameTime(aiBrain, 1200) or not SBC.EnemyToAllyRatioLessOrEqual(aiBrain, 1.0) or not SBC.ClosestEnemyLessThan(aiBrain, 750) or not SUtils.CheckForMapMarkers(aiBrain)) then
            Mult = 1
        end
        WaitTicks(1)

        -- Overcharge
        if Mult == 1 and not cdr.Dead and not cdr.Upgrading and SBC.GreaterThanGameTime(aiBrain, Delay) and
        UCBC.HaveGreaterThanUnitsWithCategory(aiBrain,  1, 'FACTORY') and aiBrain:GetNoRushTicks() <= 0 then
            CDRSCTADGun(aiBrain, cdr)
        end
        WaitTicks(1)

        -- Run Away
        if not cdr.Dead then CDRRunAwaySorian(aiBrain, cdr) end
        WaitTicks(1)

        -- Go back to base
        if not cdr.Dead then CDRReturnHomeSorian(aiBrain, cdr, Mult) end
        WaitTicks(1)

        if not cdr.Dead and cdr:IsIdleState() and moveOnNext then
            CDRHideBehavior(aiBrain, cdr)
            moveOnNext = false
        end
        WaitTicks(1)

        if not cdr.Dead and cdr:IsIdleState() and not cdr.GoingHome and not cdr.Fighting and not cdr.Upgrading and not cdr:IsUnitState("Building")
        and not cdr:IsUnitState("Attacking") and not cdr:IsUnitState("Repairing") and not cdr.UnitBeingBuiltBehavior and not cdr:IsUnitState("Upgrading")
        and not cdr:IsUnitState("Enhancing") and not moveOnNext then
            moveWait = moveWait + 1
            if moveWait >= 10 then
                moveWait = 0
                moveOnNext = true
            end
        else
            moveWait = 0
        end
        WaitTicks(1)

        -- Call platoon resume building deal...
        if not cdr.Dead and cdr:IsIdleState() and not cdr.GoingHome and not cdr.Fighting and not cdr.Upgrading and not cdr:IsUnitState("Building")
        and not cdr:IsUnitState("Attacking") and not cdr:IsUnitState("Repairing") and not cdr.UnitBeingBuiltBehavior and not cdr:IsUnitState("Upgrading")
        and not cdr:IsUnitState("Enhancing") and not (SUtils.XZDistanceTwoVectorsSq(cdr.CDRHome, cdr:GetPosition()) > 100)
        and not cdr:IsUnitState('BlockCommandQueue') then
            if not cdr.EngineerBuildQueue or table.getn(cdr.EngineerBuildQueue) == 0 then
                local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
                aiBrain:AssignUnitsToPlatoon(pool, {cdr}, 'Unassigned', 'None')
            elseif cdr.EngineerBuildQueue and table.getn(cdr.EngineerBuildQueue) ~= 0 then
                if not cdr.NotBuildingThread then
                    cdr.NotBuildingThread = cdr:ForkThread(platoon.WatchForNotBuildingSorian)
                end
            end
        end
        WaitSeconds(1)

        if not cdr.Dead and GetGameTimeSeconds() > WaitTaunt and (not aiBrain.LastVocTaunt or GetGameTimeSeconds() - aiBrain.LastVocTaunt > WaitTaunt) then
            SUtils.AIRandomizeTaunt(aiBrain)
            WaitTaunt = 600 + Random(1, 900)
        end
    end
end


function CDRSCTADGun(aiBrain, cdr)
    local weapBPs = cdr:GetBlueprint().Weapon
    local weapon

    for k, v in weapBPs do
        if v.Label == 'DGun' then
            weapon = v
            break
        end
    end

    cdr.UnitBeingBuiltBehavior = false

    -- Added for ACUs starting near each other
    if GetGameTimeSeconds() < 60 then
        return
    end

    -- Increase distress on non-water maps
    local distressRange = 60
    if cdr:GetHealthPercent() > 0.8 and aiBrain:GetMapWaterRatio() < 0.4 then
        distressRange = 100
    end

    -- Increase attack range for a few mins on small maps
    local maxRadius = weapon.MaxRadius + 10
    local mapSizeX, mapSizeZ = GetMapSize()
    if cdr:GetHealthPercent() > 0.8
        and GetGameTimeSeconds() < 660
        and GetGameTimeSeconds() > 243
        and mapSizeX <= 512 and mapSizeZ <= 512
        and ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality ~= 'turtle'
        and ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality ~= 'defense'
        and ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality ~= 'rushnaval'
        then
        maxRadius = 256
    end

    -- Take away engineers too
    local cdrPos = cdr.CDRHome
    local numUnits = aiBrain:GetNumUnitsAroundPoint(categories.LAND - categories.SCOUT, cdrPos, (maxRadius), 'Enemy')
    local distressLoc = aiBrain:BaseMonitorDistressLocation(cdrPos)
    local overCharging = false

    -- Don't move if upgrading

    if Utilities.XZDistanceTwoVectors(cdrPos, cdr:GetPosition()) > maxRadius then
        return
    end

    if numUnits > 0 or (not cdr.DistressCall and distressLoc and Utilities.XZDistanceTwoVectors(distressLoc, cdrPos) < distressRange) then
        if cdr.UnitBeingBuilt then
            cdr.UnitBeingBuiltBehavior = cdr.UnitBeingBuilt
        end
        local plat = aiBrain:MakePlatoon('', '')
        aiBrain:AssignUnitsToPlatoon(plat, {cdr}, 'support', 'None')
        plat:Stop()
        local priList = {
            categories.EXPERIMENTAL,
            categories.TECH3 * categories.INDIRECTFIRE,
            categories.TECH3 * categories.MOBILE,
            categories.TECH2 * categories.INDIRECTFIRE,
            categories.MOBILE * categories.TECH2,
            categories.TECH1 * categories.INDIRECTFIRE,
            categories.TECH1 * categories.MOBILE,
            categories.ALLUNITS
        }

        local target
        local continueFighting = true
        local counter = 0
        local cdrThreat = cdr:GetBlueprint().Defense.SurfaceThreatLevel or 75
        local enemyThreat
        repeat
            overCharging = false
            if counter >= 5 or not target or target.Dead or Utilities.XZDistanceTwoVectors(cdrPos, target:GetPosition()) > maxRadius then
                counter = 0
                searchRadius = 30
                repeat
                    searchRadius = searchRadius + 30
                    for k, v in priList do
                        target = plat:FindClosestUnit('Support', 'Enemy', true, v)
                        if target and Utilities.XZDistanceTwoVectors(cdrPos, target:GetPosition()) <= searchRadius then
                            local cdrLayer = cdr:GetCurrentLayer()
                            local targetLayer = target:GetCurrentLayer()
                            if not (cdrLayer == 'Land' and (targetLayer == 'Air' or targetLayer == 'Sub' or targetLayer == 'Seabed')) and
                               not (cdrLayer == 'Seabed' and (targetLayer == 'Air' or targetLayer == 'Water')) then
                                break
                            end
                        end
                        target = false
                    end
                until target or searchRadius >= maxRadius

                if target then
                    local targetPos = target:GetPosition()

                    -- If inside base dont check threat, just shoot!
                    if Utilities.XZDistanceTwoVectors(cdr.CDRHome, cdr:GetPosition()) > 45 then
                        enemyThreat = aiBrain:GetThreatAtPosition(targetPos, 1, true, 'AntiSurface')
                        enemyCdrThreat = aiBrain:GetThreatAtPosition(targetPos, 1, true, 'Commander')
                        friendlyThreat = aiBrain:GetThreatAtPosition(targetPos, 1, true, 'AntiSurface', aiBrain:GetArmyIndex())
                        if enemyThreat - enemyCdrThreat >= friendlyThreat + (cdrThreat / 1.5) then
                            break
                        end
                    end

                    if aiBrain:GetEconomyStored('ENERGY') >= weapon.EnergyRequired and target and not target.Dead then
                        overCharging = true
                        IssueClearCommands({cdr})
                        IssueOverCharge({cdr}, target)
                    elseif target and not target.Dead then -- Commander attacks even if not enough energy for overcharge
                        IssueClearCommands({cdr})
                        IssueMove({cdr}, targetPos)
                        IssueMove({cdr}, cdr.CDRHome)
                    end
                elseif distressLoc then
                    enemyThreat = aiBrain:GetThreatAtPosition(distressLoc, 1, true, 'AntiSurface')
                    enemyCdrThreat = aiBrain:GetThreatAtPosition(distressLoc, 1, true, 'Commander')
                    friendlyThreat = aiBrain:GetThreatAtPosition(distressLoc, 1, true, 'AntiSurface', aiBrain:GetArmyIndex())
                    if enemyThreat - enemyCdrThreat >= friendlyThreat + (cdrThreat / 3) then
                        break
                    end
                    if distressLoc and (Utilities.XZDistanceTwoVectors(distressLoc, cdrPos) < distressRange) then
                        IssueClearCommands({cdr})
                        IssueMove({cdr}, distressLoc)
                        IssueMove({cdr}, cdr.CDRHome)
                    end
                end
            end

            if overCharging then
                while target and not target.Dead and not cdr.Dead and counter <= 5 do
                    WaitSeconds(0.5)
                    counter = counter + 0.5
                end
            else
                WaitSeconds(5)
                counter = counter + 5
            end

            distressLoc = aiBrain:BaseMonitorDistressLocation(cdrPos)
            if cdr.Dead then
                return
            end

            if aiBrain:GetNumUnitsAroundPoint(categories.LAND - categories.SCOUT, cdrPos, maxRadius, 'Enemy') <= 0
                and (not distressLoc or Utilities.XZDistanceTwoVectors(distressLoc, cdrPos) > distressRange) then
                continueFighting = false
            end
            -- If com is down to yellow then dont keep fighting
            if (cdr:GetHealthPercent() < 0.75) and Utilities.XZDistanceTwoVectors(cdr.CDRHome, cdr:GetPosition()) > 30 then
                continueFighting = false
            end
        until not continueFighting or not aiBrain:PlatoonExists(plat)

        IssueClearCommands({cdr})

        -- Finish the unit
        if cdr.UnitBeingBuiltBehavior and not cdr.UnitBeingBuiltBehavior:BeenDestroyed() and cdr.UnitBeingBuiltBehavior:GetFractionComplete() < 1 then
            IssueRepair({cdr}, cdr.UnitBeingBuiltBehavior)
        end
        cdr.UnitBeingBuiltBehavior = false
    end
end