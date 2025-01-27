local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local missionID = TppMission.GetMissionID()
local IsTypeString=Tpp.IsTypeString
local GetGameObjectId = GameObject.GetGameObjectId
local SendCommand = GameObject.SendCommand

local PHASE_ALERT = TppGameObject.PHASE_ALERT
local PHASE_EVASION = TppGameObject.PHASE_EVASION
local PHASE_CAUTION = TppGameObject.PHASE_CAUTION
local PHASE_SNEAK = TppGameObject.PHASE_SNEAK

local NULL_ID = GameObject.NULL_ID


function this.OnAllocate()end
function this.OnInitialize()end

function this.RequestNoticeGimmick(cp,gimmickId, sourceId)
	InfCore.Log("Zoz Log: Zoz_Enemy_Equipment_Overhaul.RequestNoticeGimmick")
	local command = { id = "RequestNotice", type = 0, targetId = gimmickId, sourceId = sourceId }
	SendCommand( cp, command )
end

this.IsAirGun = function( gameObjectId )
	if gameObjectId == nil then
		return
	end
	if gameObjectId == NULL_ID then return end
	local gameObjectType = GameObject.GetTypeIndex(gameObjectId)
	return gameObjectType == TppGameObject.GAME_OBJECT_TYPE_GATLINGGUN
end

this.IsMortar = function( gameObjectId )
	if gameObjectId == nil then
		return
	end
	if gameObjectId == NULL_ID then return end
	local gameObjectType = GameObject.GetTypeIndex(gameObjectId)
	return gameObjectType == TppGameObject.GAME_OBJECT_TYPE_MORTAR
end
this.IsMachineGun = function( gameObjectId )
	if gameObjectId == nil then
		return
	end
	if gameObjectId == NULL_ID then return end
	local gameObjectType = GameObject.GetTypeIndex(gameObjectId)
	return gameObjectType == TppGameObject.GAME_OBJECT_TYPE_MACHINEGUN
end

function this.Messages()
    return StrCode32Table{
		GameObject = {
			{

				msg = "WarningGimmick",
				func = function (irSensorId, irHash, irDataSetName, gameObjectId)
					this.RequestNoticeGimmick(Zoz_overhaul_Ivars.getClosestCp(), irSensorId, 0) -- 0 is The Player
				end
			},
			{
				msg = "BurglarAlarmTrap",

				func = function (bAlarmId, bAlarmHash, bAlarmDataSetName, gameObjectId)
					this.RequestNoticeGimmick(Zoz_overhaul_Ivars.getClosestCp(), bAlarmId, gameObjectId) -- 0 is The Player
				end
			},
			{
				msg="FultonInfo",func=function(gameObjectId, fultonedPlayer)
					if fultonedPlayer == 0 then
						if Tpp.IsFultonContainer(gameObjectId) or this.IsAirGun( gameObjectId ) or Tpp.IsGatlingGun(gameObjectId) or this.IsMortar( gameObjectId ) or this.IsMachineGun( gameObjectId ) then
							if Gimmick.CallBurglarAlarm(gameObjectId,this.burgularAlarmRange,this.burgularAlarmTime)==true then
								this.RequestNoticeGimmick(Zoz_overhaul_Ivars.getClosestCp(), gameObjectId, fultonedPlayer) -- fultonedPlayer is The Player
							end
						end
					end
				end
			},
			{
				msg="FultonFailed",
				func=function(gameObjectId)
				  if Tpp.IsFultonContainer(gameObjectId) or this.IsAirGun( gameObjectId ) or Tpp.IsGatlingGun(gameObjectId) or this.IsMortar( gameObjectId ) or this.IsMachineGun( gameObjectId ) then
					if Gimmick.CallBurglarAlarm(gameObjectId,this.burgularAlarmRange,this.burgularAlarmTime)==true then
						this.RequestNoticeGimmick(Zoz_overhaul_Ivars.getClosestCp(), gameObjectId, 0)
					end
				  end
				end
			},
		},
		Timer = {
			{
				msg = "Finish",
				sender = "fultonedbyenemy",
				func = 	function()
					mvars.fultonedbyenemy = true
				end
			},
		},
		Player = {
			{
				msg = "PlayerFulton",
				func = function (arg0, arg1)
					if Tpp.IsFultonContainer(arg1) then
						mvars.fultonedbyenemy = false
						GkEventTimerManager.Start("fultonedbyenemy", 8)
					end
				end
			}
		},
    }
end

function this.LoadLibraries()
    local onPlayerFultoned = TppMission.OnPlayerFultoned
    TppMission.OnPlayerFultoned = function(playerId, staffId, fultonExecuteId, espParam)
      if fultonExecuteId == 1 and mvars.fultonedbyenemy == true then
		TppMission.OnPlayerDead()
      else
        onPlayerFultoned()
      end
    end
end


function this.SetUpEnemy()
	if TppMission.IsFOBMission(vars.missionCode) then
		return
	end
	if not GameObject.DoesGameObjectExistWithTypeName"TppSoldier2" then
		return
	end

	if not Ivars.Zoz_Enemy_Equipment_Fulton:Is"OFF" then
		local fultonLevel = 1
		local isWormHole = false

		if Ivars.Zoz_Enemy_Equipment_Fulton:Is"Normal" then
			if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.FULTON) == 1 then
				fultonLevel = 1
			elseif TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.FULTON) == 2 then
				fultonLevel = 2
			elseif TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.FULTON) == 3 then
				fultonLevel = 3
			elseif TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.FULTON) >= 4 then
				fultonLevel = 3
				isWormHole = true
			end
		elseif Ivars.Zoz_Enemy_Equipment_Fulton:Is"Balloon" then
			isWormHole = false
			fultonLevel = 3
		elseif Ivars.Zoz_Enemy_Equipment_Fulton:Is"Wormhole" then
			isWormHole = true
			fultonLevel = 3
		end

		local typeCp = {type="TppCommandPost2"}
		local command = {id="SetFultonLevel", fultonLevel=fultonLevel, isWormHole=isWormHole}
		SendCommand(typeCp, command)
	end
end

function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
	if TppMission.IsFOBMission(vars.missionCode)  then
		return
	end
    Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText)
end

function this.Init(missionTable)
	if TppMission.IsFOBMission(vars.missionCode) then
		return
	end
	this.burgularAlarmRange = 2
	this.burgularAlarmTime = 10
	mvars.fultonedbyenemy = true

	if Ivars.mbDDEquipNonLethal:Is(1) then
		SendCommand({type="TppSoldier2"},{id="RegistGrenadeId",grenadeId=TppEquip.EQP_SWP_StunGrenade_G03,isNoKill=true,stunId=TppEquip.EQP_SWP_StunGrenade_G03,isNoKill=true})
	end

	this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end


function this.OnLoad()
	InfCore.Log("Zoz_Overhaul Log: Zoz_Support_Enemy_Equipment_Overhaul.OnLoad()")
end

return this