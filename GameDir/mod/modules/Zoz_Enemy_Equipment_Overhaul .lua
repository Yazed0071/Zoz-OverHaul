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




this.Camera_Locator_PackList = {
    afgh_slopedTown 	= {"/Assets/tpp/pack/zoz/zoz_SlopedTown_Cameras_custom.fpk"},
    afgh_village 		= {"/Assets/tpp/pack/zoz/zoz_Village_Cameras_custom.fpk"},
    afgh_enemyBase 		= {"/Assets/tpp/pack/zoz/zoz_enemyBase_Cameras_custom.fpk"},
    afgh_field 			= {"/Assets/tpp/pack/zoz/zoz_Field_Cameras_custom.fpk"},
    afgh_fort 			= {"/Assets/tpp/pack/zoz/zoz_fort_Cameras_custom.fpk"},
    afgh_commFacility 	= {"/Assets/tpp/pack/zoz/zoz_commFacility_Cameras_custom.fpk"},
    afgh_remnants 		= {"/Assets/tpp/pack/zoz/zoz_Remenants_Cameras_custom.fpk"},
    afgh_tent 			= {"/Assets/tpp/pack/zoz/zoz_Tent_Cameras_custom.fpk"},
    afgh_powerPlant 	= {"/Assets/tpp/pack/zoz/zoz_powerPlant_Cameras_custom.fpk"},
    afgh_sovietBase 	= {"/Assets/tpp/pack/zoz/zoz_sovietBase_Cameras_custom.fpk"},
    afgh_citadel 		= {"/Assets/tpp/pack/zoz/zoz_citadel_Cameras_custom.fpk"},

    mafr_flowStation  	= {"/Assets/tpp/pack/zoz/zoz_flowStation_Cameras_custom.fpk"},
    mafr_pfCamp 		= {"/Assets/tpp/pack/zoz/zoz_pfCamp_Cameras_custom.fpk"},
    mafr_lab 			= {"/Assets/tpp/pack/zoz/zoz_lab_Cameras_custom.fpk"},
}
this.BlockNameToLocation = {
    [3041980042] = "mafr_flowStation",
    [1844257133] = "mafr_pfCamp",
    [3163996055] = "afgh_citadel",
    [2041687118] = "mafr_lab",
    [1464583031] = "afgh_slopedTown",
    [2636505666] = "afgh_village",
    [1187220508] = "afgh_enemyBase",
    [3875782426] = "afgh_field",
    [1881950023] = "afgh_fort",
    [1151111627] = "afgh_commFacility",
    [3270833862] = "afgh_remnants",
    [2016038145] = "afgh_tent",
    [3657571649] = "afgh_powerPlant",
    [352694746]  = "afgh_sovietBase",
}

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
					this.RequestNoticeGimmick(Zoz_overhaul_Ivars.getClosestCp(), bAlarmId, gameObjectId)
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
		Block = {
			{
				msg = "OnChangeLargeBlockState",
				func = function(blockName, blockStatus)
					if Ivars.Zoz_Enemy_Equipment_Camera:Is("OFF") or
					   (TppMission.IsFreeMission(vars.missionCode) and Ivars.Zoz_Enemy_Equipment_Camera:Is("Mission")) or
					   (not TppMission.IsFreeMission(vars.missionCode) and Ivars.Zoz_Enemy_Equipment_Camera:Is("FreeRoom")) then
						return
					end
					local location = this.BlockNameToLocation[blockName]
					if location and this.Camera_Locator_PackList[location] then
						TppScriptBlock.Load("Zoz_Camera_Free_Locator", location, true)
					else
						TppScriptBlock.Unload("Zoz_Camera_Free_Locator")
					end
				end
			},
			{
				msg = "OnScriptBlockStateTransition",
				func = function(blockName, blockState)
					if blockName == 2173424513 and blockState == ScriptBlock.TRANSITION_ACTIVATED then
						this.SetupCameraGrade()
						this.SetUpCameraCp()
					end
				end
			},
		},
		UI = {
			{
				msg = "EndFadeIn",
				func = function(fadeInName, unk1)
					if Ivars.Zoz_Enemy_Equipment_Camera:Is("OFF") or
					   (TppMission.IsFreeMission(vars.missionCode) and Ivars.Zoz_Enemy_Equipment_Camera:Is("Mission")) or
					   (not TppMission.IsFreeMission(vars.missionCode) and Ivars.Zoz_Enemy_Equipment_Camera:Is("FreeRoom")) then
						return
					end
					if fadeInName == StrCode32("FadeInOnGameStart") then
						for location, _ in pairs(this.Camera_Locator_PackList) do
							if Tpp.IsLoadedLargeBlock(location) then
								TppScriptBlock.Load("Zoz_Camera_Free_Locator", location, true)
								this.SetUpCameraCp()
							end
						end
					end
				end
			},
		},
    }
end

function this.MissionPrepare()
	if InfMain.IsOnlineMission(vars.missionCode) or vars.missionCode < 5 or (vars.locationCode == TppDefine.LOCATION_ID.GNTN) then
		return
	end
	TppScriptBlock.RegisterCommonBlockPackList( "Zoz_Camera_Free_Locator", this.Camera_Locator_PackList )
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

local FULTON_LEVELS = {
    Normal = {
        [1] = {level = 1, wormhole = false},
        [2] = {level = 3, wormhole = false},
        [3] = {level = 3, wormhole = true},
    }
}

this.SECURITY_LIST = {
	CCTVList = {
		{
			name = "Camera_Citadel_0",
			cp = "afgh_citadel_cp",
		},
		{
			name = "Camera_Citadel_1",
			cp = "afgh_citadel_cp",
		},
		{
			name = "Camera_Citadel_2",
			cp = "afgh_citadel_cp",
		},
		{
			name = "Camera_Citadel_3",
			cp = "afgh_citadel_cp",
		},
		{
			name = "Camera_Citadel_4",
			cp = "afgh_citadel_cp",
		},
		{
			name = "Camera_Citadel_5",
			cp = "afgh_citadel_cp",
		},
		{
			name = "Camera_Village_0",
			cp = "afgh_village_cp",
		},
		{
			name = "Camera_Village_1",
			cp = "afgh_village_cp",
		},
		{
			name = "Camera_Village_2",
			cp = "afgh_village_cp",
		},
		{
			name = "Camera_Village_3",
			cp = "afgh_village_cp",
		},
		{
			name = "Camera_SlopedTown_0",
			cp = "afgh_slopedTown_cp",
		},
		{
			name = "Camera_SlopedTown_1",
			cp = "afgh_slopedTown_cp",
		},
		{
			name = "Camera_SlopedTown_2",
			cp = "afgh_slopedTown_cp",
		},
		{
			name = "Camera_Field_0",
			cp = "afgh_field_cp",
		},
		{
			name = "Camera_Field_1",
			cp = "afgh_field_cp",
		},
		{
			name = "Camera_Field_2",
			cp = "afgh_field_cp",
		},
		{
			name = "Camera_Field_3",
			cp = "afgh_field_cp",
		},
		{
			name = "Camera_commFacility_0",
			cp = "afgh_commFacility_cp",
		},
		{
			name = "Camera_commFacility_1",
			cp = "afgh_commFacility_cp",
		},
		{
			name = "Camera_enemyBase_0",
			cp = "afgh_enemyBase_cp",
		},
		{
			name = "Camera_enemyBase_1",
			cp = "afgh_enemyBase_cp",
		},
		{
			name = "Camera_enemyBase_2",
			cp = "afgh_enemyBase_cp",
		},
		{
			name = "Camera_enemyBase_3",
			cp = "afgh_enemyBase_cp",
		},
		{
			name = "Camera_enemyBase_4",
			cp = "afgh_enemyBase_cp",
		},
		{
			name = "Camera_fort_0",
			cp = "afgh_fort_cp",
		},
		{
			name = "Camera_fort_1",
			cp = "afgh_fort_cp",
		},
		{
			name = "Camera_fort_2",
			cp = "afgh_fort_cp",
		},
		{
			name = "Camera_Remenants_0",
			cp = "afgh_remnants_cp",
		},
		{
			name = "Camera_Remenants_1",
			cp = "afgh_remnants_cp",
		},
		{
			name = "Camera_Remenants_2",
			cp = "afgh_remnants_cp",
		},
		{
			name = "Camera_Remenants_3",
			cp = "afgh_remnants_cp",
		},
		{
			name = "Camera_Tent_0",
			cp = "afgh_tent_cp",
		},
		{
			name = "Camera_Tent_1",
			cp = "afgh_tent_cp",
		},
		{
			name = "Camera_Tent_2",
			cp = "afgh_tent_cp",
		},
		{
			name = "Camera_Tent_3",
			cp = "afgh_tent_cp",
		},
		{
			name = "Camera_powerPlant_0",
			cp = "afgh_powerPlant_cp",
		},
		{
			name = "Camera_powerPlant_1",
			cp = "afgh_powerPlant_cp",
		},
		{
			name = "Camera_powerPlant_2",
			cp = "afgh_powerPlant_cp",
		},
		{
			name = "Camera_powerPlant_3",
			cp = "afgh_powerPlant_cp",
		},
		{
			name = "Camera_sovietBase_0",
			cp = "afgh_sovietBase_cp",
		},
		{
			name = "Camera_sovietBase_1",
			cp = "afgh_sovietBase_cp",
		},
		{
			name = "Camera_sovietBase_2",
			cp = "afgh_sovietBase_cp",
		},
		{
			name = "Camera_sovietBase_3",
			cp = "afgh_sovietBase_cp",
		},
		{
			name = "Camera_sovietBase_4",
			cp = "afgh_sovietBase_cp",
		},
		{
			name = "Camera_flowStation_0",
			cp = "mafr_flowStation_cp",
		},
		{
			name = "Camera_flowStation_1",
			cp = "mafr_flowStation_cp",
		},
		{
			name = "Camera_flowStation_2",
			cp = "mafr_flowStation_cp",
		},
		{
			name = "Camera_flowStation_3",
			cp = "mafr_flowStation_cp",
		},
		{
			name = "Camera_flowStation_4",
			cp = "mafr_flowStation_cp",
		},
		{
			name = "Camera_flowStation_5",
			cp = "mafr_flowStation_cp",
		},
		{
			name = "Camera_pfCamp_0",
			cp = "mafr_pfCamp_cp",
		},
		{
			name = "Camera_pfCamp_1",
			cp = "mafr_pfCamp_cp",
		},
		{
			name = "Camera_pfCamp_2",
			cp = "mafr_pfCamp_cp",
		},
		{
			name = "Camera_pfCamp_3",
			cp = "mafr_pfCamp_cp",
		},
		{
			name = "Camera_pfCamp_4",
			cp = "mafr_pfCamp_cp",
		},
		{
			name = "Camera_pfCamp_5",
			cp = "mafr_pfCamp_cp",
		},
		{
			name = "Camera_pfCamp_6",
			cp = "mafr_pfCamp_cp",
		},
		{
			name = "Camera_pfCamp_7",
			cp = "mafr_pfCamp_cp",
		},
		{
			name = "Camera_pfCamp_8",
			cp = "mafr_pfCamp_cp",
		},
		{
			name = "Camera_lab_0",
			cp = "mafr_lab_cp",
		},
		{
			name = "Camera_lab_1",
			cp = "mafr_lab_cp",
		},
		{
			name = "Camera_lab_2",
			cp = "mafr_lab_cp",
		},
		{
			name = "Camera_lab_3",
			cp = "mafr_lab_cp",
		},
		{
			name = "Camera_lab_4",
			cp = "mafr_lab_cp",
		},
	},
}

function this.SetupCameraGrade()
    local revengeConfig = {
        [1] = {
            {id = "SetNormalCamera"},
            {id = "SetDevelopLevel", developLevel = 5}
        },
        [2] = {
            {id = "SetNormalCamera"},
            {id = "SetDevelopLevel", developLevel = 6}
        },
        [3] = {
            {id = "SetDevelopLevel", developLevel = 6},
            {id = "SetNormalCamera"}
        },
        [4] = {
            {id = "SetGunCamera"},
            {id = "SetDevelopLevel", developLevel = 7}
        },
        [5] = {
            {id = "SetGunCamera"},
            {id = "SetDevelopLevel", developLevel = 8}
        },
    }
    local revengeLevel = TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.STEALTH)
    if revengeLevel >= 1 and revengeLevel <= 5 then
        local commands = revengeConfig[revengeLevel]
        if commands then
            local securityCameras = {type = "TppSecurityCamera2"}
            for _, command in ipairs(commands) do
                SendCommand(securityCameras, command)
            end
        end
    end
end

function this.SetUpCameraCp()
	for _, camInfo in ipairs(this.SECURITY_LIST.CCTVList) do
        local gameObjectId = GetGameObjectId(camInfo.name)
        if gameObjectId ~= GameObject.NULL_ID then
            SendCommand(gameObjectId, {id = "SetCommandPost", cp = camInfo.cp})
        end
    end
end

function this.AddMissionPacks(missionCode,packPaths)
	if InfMain.IsOnlineMission(missionCode) or missionCode < 5 or (vars.locationCode == TppDefine.LOCATION_ID.GNTN) then
		return
	end

	if not Ivars.Zoz_Enemy_Equipment_Fulton:Is"OFF" then
		packPaths[#packPaths + 1] = "/Assets/tpp/pack/zoz/Zoz_Online_Animation.fpk"
	end

	local function AddLocationPacks(basePathAfghan, basePathAfrica, condition)
		if condition then
			if TppLocation.IsAfghan() then
				packPaths[#packPaths + 1] = basePathAfghan
			elseif TppLocation.IsMiddleAfrica() then
				packPaths[#packPaths + 1] = basePathAfrica
			end
		end
	end

	if not Ivars.Zoz_Enemy_Equipment_Ir_Sensors:Is"OFF" then
		packPaths[#packPaths + 1] = "/Assets/tpp/pack/zoz/mis_common_zoz_Ir_Sensor.fpk"
		local isFreeRoom = Ivars.Zoz_Enemy_Equipment_Ir_Sensors:Is"FreeRoom"
		local isMission = Ivars.Zoz_Enemy_Equipment_Ir_Sensors:Is"Mission"
		local isAll = Ivars.Zoz_Enemy_Equipment_Ir_Sensors:Is"ALL"
		local isFreeRoomMission = TppMission.IsFreeMission(vars.missionCode)

		if isFreeRoom and isFreeRoomMission then
			AddLocationPacks("/Assets/tpp/pack/zoz/zoz_afgh_Ir_Sensor.fpk", "/Assets/tpp/pack/zoz/zoz_mafr_Ir_Sensor.fpk", true)
		elseif isMission and not isFreeRoomMission then
			AddLocationPacks("/Assets/tpp/pack/zoz/zoz_afgh_Ir_Sensor.fpk", "/Assets/tpp/pack/zoz/zoz_mafr_Ir_Sensor.fpk", true)
		elseif isAll then
			AddLocationPacks("/Assets/tpp/pack/zoz/zoz_afgh_Ir_Sensor.fpk", "/Assets/tpp/pack/zoz/zoz_mafr_Ir_Sensor.fpk", true)
		end
	end

	if not Ivars.Zoz_Enemy_Equipment_burglar_alarm:Is"OFF" then
		packPaths[#packPaths + 1] = "/Assets/tpp/pack/zoz/zoz_common_alm.fpk"
		local isFreeRoom = Ivars.Zoz_Enemy_Equipment_burglar_alarm:Is"FreeRoom"
		local isMission = Ivars.Zoz_Enemy_Equipment_burglar_alarm:Is"Mission"
		local isAll = Ivars.Zoz_Enemy_Equipment_burglar_alarm:Is"ALL"
		local isFreeRoomMission = TppMission.IsFreeMission(vars.missionCode)

		if isFreeRoom and isFreeRoomMission then
			AddLocationPacks("/Assets/tpp/pack/zoz/alm_afgh.fpk", "/Assets/tpp/pack/zoz/alm_mafr.fpk", true)
		elseif isMission and not isFreeRoomMission then
			AddLocationPacks("/Assets/tpp/pack/zoz/alm_afgh.fpk", "/Assets/tpp/pack/zoz/alm_mafr.fpk", true)
		elseif isAll then
			AddLocationPacks("/Assets/tpp/pack/zoz/alm_afgh.fpk", "/Assets/tpp/pack/zoz/alm_mafr.fpk", true)
		end
	end
	if not Ivars.Zoz_Enemy_Equipment_Camera:Is"OFF" then
		if GameObject.DoesGameObjectExistWithTypeName"TppSecurityCamera2" then
			return
		end
		packPaths[#packPaths + 1] = "/Assets/tpp/pack/zoz/mis_common_zoz_cctv_ScriptBlockData.fpk"
		packPaths[#packPaths + 1] ="/Assets/tpp/pack/zoz/mis_common_zoz_cctv.fpk"
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
            local revengeLevel = TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.FULTON)
            if FULTON_LEVELS.Normal[revengeLevel] then
                for _, config in ipairs(FULTON_LEVELS.Normal[revengeLevel]) do
                    fultonLevel = config.level
                    isWormHole = config.wormhole
                end
            end
        elseif Ivars.Zoz_Enemy_Equipment_Fulton:Is"Balloon" then
            fultonLevel = 3
        elseif Ivars.Zoz_Enemy_Equipment_Fulton:Is"Wormhole" then
            fultonLevel = 3
            isWormHole = true
        end

        SendCommand(
            {type = "TppCommandPost2"},
            {id = "SetFultonLevel", fultonLevel = fultonLevel, isWormHole = isWormHole}
        )
    end
	
	if not Ivars.Zoz_Enemy_Equipment_Camera:Is"OFF" then
		this.SetupCameraGrade()
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
        SendCommand({type = "TppSoldier2"},{id = "RegistGrenadeId",grenadeId = TppEquip.EQP_SWP_StunGrenade_G03,stunId = TppEquip.EQP_SWP_StunGrenade_G03,isNoKill = true})
    end

    this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

return this