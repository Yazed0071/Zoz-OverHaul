local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local missionID = TppMission.GetMissionID()
local GetGameObjectId = GameObject.GetGameObjectId
local SendCommand = GameObject.SendCommand

local PHASE_ALERT = TppGameObject.PHASE_ALERT
local PHASE_EVASION = TppGameObject.PHASE_EVASION
local PHASE_CAUTION = TppGameObject.PHASE_CAUTION
local PHASE_SNEAK = TppGameObject.PHASE_SNEAK

local NULL_ID = GameObject.NULL_ID
local PLAYER_ID = 0

local function GetWeaponType(gameObjectId)
    if not gameObjectId or gameObjectId == NULL_ID then return nil end
    return GameObject.GetTypeIndex(gameObjectId)
end

this.IsAirGun = function(gameObjectId)
    return GetWeaponType(gameObjectId) == TppGameObject.GAME_OBJECT_TYPE_GATLINGGUN
end

this.IsMortar = function(gameObjectId)
    return GetWeaponType(gameObjectId) == TppGameObject.GAME_OBJECT_TYPE_MORTAR
end

this.IsMachineGun = function(gameObjectId)
    return GetWeaponType(gameObjectId) == TppGameObject.GAME_OBJECT_TYPE_MACHINEGUN
end

local function HandleFultonAlert(gameObjectId, sourceId)
    InfCore.Log("Zoz: Checking alarm for object "..tostring(gameObjectId))
    if Gimmick.CallBurglarAlarm(gameObjectId, this.burgularAlarmRange, this.burgularAlarmTime) then
        InfCore.Log("Zoz: Alarm activated - "..tostring(gameObjectId))
        this.RequestNoticeGimmick(Zoz_overhaul_Ivars.getClosestCp(), gameObjectId, sourceId)
    end
end

function this.RequestNoticeGimmick(cp, gimmickId, sourceId)
    SendCommand(cp, {
        id = "RequestNotice",
        type = 0,
        targetId = gimmickId,
        sourceId = sourceId
    })
    InfCore.Log("Zoz: CP alerted about "..tostring(gimmickId))
end

function this.Messages()
    return StrCode32Table{
        GameObject = {
            {
                msg = "WarningGimmick",
                func = function(_, irSensorId)
                    InfCore.Log("Zoz: IR sensor triggered - "..tostring(irSensorId))
                    this.RequestNoticeGimmick(Zoz_overhaul_Ivars.getClosestCp(), irSensorId, PLAYER_ID)
                end
            },
            {
                msg = "BurglarAlarmTrap",
                func = function(_, bAlarmId, _, gameObjectId)
                    InfCore.Log("Zoz: Physical alarm triggered - "..tostring(bAlarmId))
                    this.RequestNoticeGimmick(Zoz_overhaul_Ivars.getClosestCp(), bAlarmId, gameObjectId)
                end
            },
            {
                msg = "FultonInfo",
                func = function(gameObjectId, fultonedPlayer)
                    if fultonedPlayer == PLAYER_ID then
                        InfCore.Log("Zoz: Player fulton detected - "..tostring(gameObjectId))
                        if Tpp.IsFultonContainer(gameObjectId) 
                        or this.IsAirGun(gameObjectId) 
                        or Tpp.IsGatlingGun(gameObjectId) 
                        or this.IsMortar(gameObjectId) 
                        or this.IsMachineGun(gameObjectId) then
                            HandleFultonAlert(gameObjectId, fultonedPlayer)
                        end
                    end
                end
            },
            {
                msg = "FultonFailed",
                func = function(gameObjectId)
                    InfCore.Log("Zoz: Fulton failed - "..tostring(gameObjectId))
                    if Tpp.IsFultonContainer(gameObjectId) 
                    or this.IsAirGun(gameObjectId) 
                    or Tpp.IsGatlingGun(gameObjectId) 
                    or this.IsMortar(gameObjectId) 
                    or this.IsMachineGun(gameObjectId) then
                        HandleFultonAlert(gameObjectId, PLAYER_ID)
                    end
                end
            },
        },
        Timer = {
            {
                msg = "Finish",
                sender = "fultonedbyenemy",
                func = function()
                    InfCore.Log("Zoz: Fulton timer expired")
                    mvars.fultonedbyenemy = true
                end
            },
        },
        Player = {
            {
                msg = "PlayerFulton",
                func = function(_, targetId)
                    InfCore.Log("Zoz: Player initiated fulton - "..tostring(targetId))
                    if Tpp.IsFultonContainer(targetId) then
                        mvars.fultonedbyenemy = false
                        GkEventTimerManager.Start("fultonedbyenemy", 8)
                    end
                end
            }
        },
    }
end

local FULTON_LEVELS = {
    Normal = {
        [1] = {level = 1, wormhole = false},
        [2] = {level = 2, wormhole = false},
        [3] = {level = 3, wormhole = false},
        [4] = {level = 3, wormhole = true},
    }
}

function this.SetUpEnemy()
    if TppMission.IsFOBMission(vars.missionCode) then
        InfCore.Log("Zoz: Skipping Setup - FOB Mission")
        return 
    end
    
    if not GameObject.DoesGameObjectExistWithTypeName"TppSoldier2" then
        InfCore.Log("Zoz: Aborting Setup - No Soldiers Found")
        return 
    end

    if not Ivars.Zoz_Enemy_Equipment_Fulton:Is"OFF" then
        InfCore.Log("Zoz: Configuring Enemy Fulton...")
        local fultonLevel = 1
        local isWormHole = false

        if Ivars.Zoz_Enemy_Equipment_Fulton:Is"Normal" then
            local revengeLevel = TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.FULTON)
            InfCore.Log("Zoz: Normal Mode - Revenge Level "..revengeLevel)
            local config = FULTON_LEVELS.Normal[math.min(revengeLevel, 4)] or FULTON_LEVELS.Normal[4]
            fultonLevel = config.level
            isWormHole = config.wormhole
        elseif Ivars.Zoz_Enemy_Equipment_Fulton:Is"Balloon" then
            InfCore.Log("Zoz: Forcing Balloon Fulton")
            fultonLevel = 3
        elseif Ivars.Zoz_Enemy_Equipment_Fulton:Is"Wormhole" then
            InfCore.Log("Zoz: Forcing Wormhole Fulton")
            fultonLevel = 3
            isWormHole = true
        end

        InfCore.Log(string.format("Zoz: Fulton Level %d | Wormhole: %s", fultonLevel, tostring(isWormHole)))
        SendCommand(
            {type = "TppCommandPost2"},
            {id = "SetFultonLevel", fultonLevel = fultonLevel, isWormHole = isWormHole}
        )
    end
end

function this.LoadLibraries()
    InfCore.Log("Zoz: Hooking Fulton System...")
    local originalOnFultoned = TppMission.OnPlayerFultoned
    TppMission.OnPlayerFultoned = function(playerId, staffId, fultonExecuteId, espParam)
        if fultonExecuteId == 1 and mvars.fultonedbyenemy then
            InfCore.Log("Zoz: ENEMY FULTON INTERCEPT!")
            TppMission.OnPlayerDead()
        else
            originalOnFultoned(playerId, staffId, fultonExecuteId, espParam)
        end
    end
end

function this.Init(missionTable)
    if TppMission.IsFOBMission(vars.missionCode) then 
        InfCore.Log("Zoz: FOB Mission - Module Disabled")
        return 
    end
    
    InfCore.Log("Zoz: Initializing Equipment Overhaul")
    this.burgularAlarmRange = 2
    this.burgularAlarmTime = 10
    mvars.fultonedbyenemy = true

    if Ivars.mbDDEquipNonLethal:Is(1) then
        InfCore.Log("Zoz: Equipping Non-Lethal Grenades")
        SendCommand(
            {type = "TppSoldier2"},
            {
                id = "RegistGrenadeId",
                grenadeId = TppEquip.EQP_SWP_StunGrenade_G03,
                stunId = TppEquip.EQP_SWP_StunGrenade_G03,
                isNoKill = true
            }
        )
    end

    this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnLoad()
    InfCore.Log("Zoz: Enemy Equipment Module Loaded")
end

function this.OnAllocate() end
function this.OnInitialize() end
function this.OnMessage() end

return this