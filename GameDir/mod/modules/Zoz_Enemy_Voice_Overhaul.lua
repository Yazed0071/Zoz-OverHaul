local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local missionID = TppMission.GetMissionID()
local IsTypeString = Tpp.IsTypeString
local GetGameObjectId = GameObject.GetGameObjectId
local SendCommand = GameObject.SendCommand

local PHASE_ALERT = TppGameObject.PHASE_ALERT
local PHASE_EVASION = TppGameObject.PHASE_EVASION
local PHASE_CAUTION = TppGameObject.PHASE_CAUTION
local PHASE_SNEAK = TppGameObject.PHASE_SNEAK

local NULL_ID = GameObject.NULL_ID

function this.OnAllocate()end
function this.OnInitialize()end

function this.SetEnableSendMessageAimedFromPlayer()
    InfCore.Log("Zoz_Overhaul Log: Enabling AimedFromPlayer messages for CP soldiers")
    for cpName, cpSoldiers in pairs(mvars.ene_soldierDefine) do
        InfCore.Log("Zoz_Overhaul Log: Processing CP - "..tostring(cpName))
        for index, soldierName in ipairs(cpSoldiers) do
            local gameObjectId = GetGameObjectId(soldierName)
            if gameObjectId ~= NULL_ID then
                InfCore.Log("Zoz_Overhaul Log: Enabling AimedFromPlayer for "..tostring(soldierName))
                SendCommand(gameObjectId, { id = "SetEnableSendMessageAimedFromPlayer", enabled = true })
            else
                InfCore.Log("Zoz_Overhaul Log: Invalid GameObjectID for "..tostring(soldierName))
            end
        end
    end
end

function this.GetAllAliveSoldiersInCp()
    InfCore.Log("Zoz_Overhaul Log: Counting alive soldiers in CP")
    mvars.aliveSoldierName = nil
    local enemyAlive = 0
    local enemyNeutralized = 0
    local closestCp = Zoz_overhaul_Ivars.getClosestCp()

    for cpName, cpSoldiers in pairs(mvars.ene_soldierDefine) do
        if GetGameObjectId(cpName) == closestCp then
            InfCore.Log("Zoz_Overhaul Log: Processing CP - "..tostring(cpName))
            for _, soldierName in ipairs(cpSoldiers) do
                if not TppEnemy.IsNeutralized(soldierName) then
                    InfCore.Log("Zoz_Overhaul Log: Alive soldier - "..tostring(soldierName))
                    enemyAlive = enemyAlive + 1
                    if enemyAlive == 1 then
                        mvars.aliveSoldierName = soldierName
                        InfCore.Log("Zoz_Overhaul Log: First alive soldier set to "..tostring(soldierName))
                    end
                else
                    InfCore.Log("Zoz_Overhaul Log: Neutralized soldier - "..tostring(soldierName))
                    enemyNeutralized = enemyNeutralized + 1
                end
            end
        end
    end
    InfCore.Log(string.format("Zoz_Overhaul Log: CP Status - Alive: %d, Neutralized: %d", enemyAlive, enemyNeutralized))
    return enemyAlive
end

function this.SetSoldierSurrender(soldierId)
    InfCore.Log("Zoz_Overhaul Log: SetSoldierSurrender called for ID: "..tostring(soldierId))
    if not Tpp.IsSoldier(soldierId) then
        InfCore.Log("Zoz_Overhaul Log: Invalid soldier ID, aborting")
        return
    end
    if Ivars.Zoz_Enemy_Voice_Enemy_Surrender:Is(0) then
        InfCore.Log("Zoz_Overhaul Log: Surrender disabled via Ivars")
        return
    end

    local makeSurrender = function()
        InfCore.Log("Zoz_Overhaul Log: Executing surrender routine")
        if mvars.aliveSoldierName then
            local gameObjectId = GetGameObjectId("TppSoldier2", mvars.aliveSoldierName)
            InfCore.Log("Zoz_Overhaul Log: Processing soldier - "..tostring(mvars.aliveSoldierName))

            if not Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT) then
                InfCore.Log("Zoz_Overhaul Log: Setting force holdup for "..tostring(mvars.aliveSoldierName))
                SendCommand(gameObjectId, { id = "SetForceHoldup" })
                SendCommand(gameObjectId, { id = "SetEverDown", enabled = true })
                InfCore.Log("Zoz_Overhaul Log: Starting surrender timer")
                GkEventTimerManager.Start("Soldier_GiveUp", 2)
            end
        end
    end

    if not Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT) and this.GetAllAliveSoldiersInCp() == 1 then
        InfCore.Log("Zoz_Overhaul Log: Surrender conditions met")
        if not TppEnemy.IsArmor(mvars.aliveSoldierName) then
            local randomValue = math.random(1, 100)
            local revengeLevel = TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT)
            InfCore.Log(string.format("Zoz_Overhaul Log: Surrender check - Random: %d, RevengeLv: %d", randomValue, revengeLevel))

            if (revengeLevel < 3 and randomValue >= 25) or
               (revengeLevel == 3 and randomValue <= 50) or
               (revengeLevel > 3 and randomValue <= 25) then
                InfCore.Log("Zoz_Overhaul Log: Surrender triggered")
                makeSurrender()
            else
                InfCore.Log("Zoz_Overhaul Log: Surrender check failed")
            end
        else
            InfCore.Log("Zoz_Overhaul Log: Armored unit cannot surrender")
        end
    end
end

function this.CheckEnemyDistance(gameObjectId)
    InfCore.Log("Zoz_Overhaul Log: Checking distance for ID: "..tostring(gameObjectId))
    local command = { id = "GetPosition" }
    local position = SendCommand(gameObjectId, command)

    if position == nil then
        InfCore.Log("Zoz_Overhaul Log: Failed to get position for ID: "..tostring(gameObjectId))
        return
    end

    local point1 = TppMath.Vector3toTable(position)
    local point2 = TppPlayer.GetPosition()
    local dist = TppMath.FindDistance(point1, point2)
    
    InfCore.Log(string.format("Zoz_Overhaul Log: Distance check - Soldier: (%.2f,%.2f,%.2f) Player: (%.2f,%.2f,%.2f) Distance: %.2fm",
        point1[1], point1[2], point1[3],
        point2[1], point2[2], point2[3],
        dist
    ))
    return dist
end

this.GetStatus = function(enemyName)
    InfCore.Log("Zoz_Overhaul Log: GetStatus for "..tostring(enemyName))
    if IsTypeString(enemyName) then
        enemyName = GetGameObjectId(enemyName)
    end
    local status = SendCommand(enemyName, { id = "GetStatus" })
    InfCore.Log("Zoz_Overhaul Log: Status result - "..tostring(status))
    return status
end

function this.Messages()
    return StrCode32Table{
        GameObject = {
            {
                msg = "ChangePhase",
                func = function(gameObjectId, phaseId, oldPhaseId)
                    InfCore.Log(string.format("Zoz_Overhaul Log: ChangePhase - From %s to %s",
                        TppGameObject.GetPhaseName(oldPhaseId), TppGameObject.GetPhaseName(phaseId)))
                    if phaseId == PHASE_ALERT and Ivars.Zoz_Enemy_Voice_Enemy_Reaction_Player_Vehicle:Is(1) then
                        InfCore.Log("Zoz_Overhaul Log: Alert phase vehicle reaction check")
                        if PlayerInfo.OrCheckStatus{PlayerStatusEx.ON_APC} then
                            InfCore.Log("Zoz_Overhaul Log: Player on APC - triggering EVR085")
                            Zoz_Enemy_Overhaul.GetClosestSoldierSpeak("EVR085")
                        elseif PlayerInfo.OrCheckStatus{PlayerStatusEx.ON_TANK} then
                            InfCore.Log("Zoz_Overhaul Log: Player on Tank - triggering EVR084")
                            Zoz_Enemy_Overhaul.GetClosestSoldierSpeak("EVR084")
                        end
                    end
                end
            },
            {
                msg = "AimedFromPlayer",
                func = function(AimedAt, isFound)
                    InfCore.Log("Zoz_Overhaul Log: AimedFromPlayer - ID: "..tostring(AimedAt).." Found: "..tostring(isFound))
                    local distance = this.CheckEnemyDistance(AimedAt)
                    local status = this.GetStatus(AimedAt)
                    
                    InfCore.Log(string.format("Zoz_Overhaul Log: AimedCheck - Status: %s, Distance: %.2f, Cooldown: %s",
                        tostring(status), distance, tostring(GkEventTimerManager.IsTimerActive("HoldUp_EV_Cooldowwn"))))
                    
                    if status == EnemyState.STAND_HOLDUP and distance <= 20 
                        and SendCommand(AimedAt, {id = "IsDoneHoldup"}) 
                        and not GkEventTimerManager.IsTimerActive("HoldUp_EV_Cooldowwn") 
                        and Ivars.Zoz_Enemy_Voice_Enemy_Reaction_Player_Aim:Is(1) then
                        InfCore.Log("Zoz_Overhaul Log: Triggering hold-up voice line")
                        local command = { id = "CallVoice", dialogueName = "DD_vox_ene", parameter = "EVR071" }
                        SendCommand(AimedAt, command)
                        GkEventTimerManager.Start("HoldUp_EV_Cooldowwn", 5)
                    end
                end
            },
            {
                msg = "Restraint",
                func = function(soldierId, releaseType, restraintType)
                    InfCore.Log(string.format("Zoz_Overhaul Log: Restraint - ID: %s, Type: %s, Release: %s",
                        tostring(soldierId), tostring(restraintType), tostring(releaseType)))
                    if Ivars.Zoz_Enemy_Voice_Enemy_Player_Restrain:Is(0) then
                        InfCore.Log("Zoz_Overhaul Log: Restraint reactions disabled")
                        return
                    end
                    mvars.IsEnemyRestrained = (releaseType == 0)
                    InfCore.Log("Zoz_Overhaul Log: Restraint state - "..tostring(mvars.IsEnemyRestrained))
                    mvars.zoz_restrained_sol = soldierId
                    GkEventTimerManager.Start("HoldUp_EV_Cooldowwn", 3)
                    GkEventTimerManager.Start("SoldierSpeak_Restrained", 5)
                end
            },
        },
        Timer = {
            {
                msg = "Finish", sender = "Soldier_GiveUp",
                func = function()
                    InfCore.Log("Zoz_Overhaul Log: Soldier_GiveUp timer finished")
                    if mvars.aliveSoldierName then
                        local gameObjectId = GetGameObjectId("TppSoldier2", mvars.aliveSoldierName)
                        InfCore.Log("Zoz_Overhaul Log: Playing surrender voice EVC440")
                        SendCommand(gameObjectId, { id = "CallVoice", dialogueName = "DD_vox_ene", parameter = "EVC440" })
                    end
                end
            },
        },
        Player = {
            {
                msg = "PlayerHoldWeapon",
                func = function(equipId, equipType, hasGunLight, isSheild)
                    InfCore.Log(string.format("Zoz_Overhaul Log: PlayerHoldWeapon - Type: %d, Light: %s, Shield: %s",
                        equipType, tostring(hasGunLight), tostring(isSheild)))
                    if Ivars.Zoz_Enemy_Voice_Enemy_Reaction_Player_RPG:Is(1) then
                        if equipType == 8 and not Tpp.IsNotAlert() 
                            and not GkEventTimerManager.IsTimerActive("EVR083_Timer") 
                            and GkEventTimerManager.IsTimerActive("EVR083_Enable") then
                            InfCore.Log("Zoz_Overhaul Log: Triggering RPG reaction EVR083")
                            Zoz_Enemy_Overhaul.GetClosestSoldierSpeak("EVR083")
                            GkEventTimerManager.Start("EVR083_Timer", 15)
                        end
                    end
                end
            },
        },
    }
end

function this.SetUpEnemy()
    InfCore.Log("Zoz_Overhaul Log: SetUpEnemy started")
    if TppMission.IsFOBMission(vars.missionCode) then
        InfCore.Log("Zoz_Overhaul Log: FOB mission detected, aborting setup")
        return
    end
    if not GameObject.DoesGameObjectExistWithTypeName"TppSoldier2" then
        InfCore.Log("Zoz_Overhaul Log: No soldiers found, aborting setup")
        return
    end
    InfCore.Log("Zoz_Overhaul Log: Setting up enemy messages")
    this.SetEnableSendMessageAimedFromPlayer()
end

function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
    InfCore.Log(string.format("Zoz_Overhaul Log: Received message - Sender: %s, ID: %s",
        tostring(sender), tostring(messageId)))
    if TppMission.IsFOBMission(vars.missionCode) then
        InfCore.Log("Zoz_Overhaul Log: FOB mission, ignoring message")
        return
    end
    Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText)
end

function this.Init(missionTable)
    InfCore.Log("Zoz_Overhaul Log: Initializing enemy voice overhaul")
    if TppMission.IsFOBMission(vars.missionCode) then
        InfCore.Log("Zoz_Overhaul Log: FOB mission detected, aborting init")
        return
    end
    mvars.IsEnemyRestrained = false
    InfCore.Log("Zoz_Overhaul Log: Creating message exec table")
    this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnLoad()
    InfCore.Log("Zoz_Overhaul Log: Voice overhaul module loaded")
end

return this