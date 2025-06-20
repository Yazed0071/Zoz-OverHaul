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


this.registerIvars={
	"Zoz_Player_Overhaul_LOOK_QUIET",
	"Zoz_Player_Overhaul_Snake_Deploy_Line",
	"Zoz_Player_Overhaul_Snake_DD_Line",
	"Zoz_Player_Overhaul_Ocelot_Interaction",
	--"Zoz_Player_Overhaul_Player_FOB_respawn",
}

this.langStrings={
	eng={
		Zoz_Player_Overhaul_LOOK_QUIET = "Look at quiet",
		Zoz_Player_Overhaul_Snake_Deploy_Line = "Snake Lines on Sortie",
		Zoz_Player_Overhaul_Snake_DD_Line = "Snake Lines with DD",
		Zoz_Player_Overhaul_Ocelot_Interaction = "Interact with Ocelot",
		--Zoz_Player_Overhaul_Player_FOB_respawn = "Respawn after death",
	},
	help={
		eng={
			Zoz_Player_Overhaul_LOOK_QUIET = "Look at quiet in sortie prep",
			Zoz_Player_Overhaul_Snake_Deploy_Line = "Snake will say a random line out of three when deploying",
			Zoz_Player_Overhaul_Snake_DD_Line = "Snake will say Lines to D_Dog depending on events in game\nCurrent lines:\nWhen Snake gets in/out of a 4 wheel drive\nWhen gets in/out of support heli",
			Zoz_Player_Overhaul_Ocelot_Interaction = "Interact with ocelot on Mother Base using the action button\nOcelot must be enabled in\nMother Base menu -> Show charactes menu -> Enable Ocelot",
			--Zoz_Player_Overhaul_Player_FOB_respawn = "Respawn after death similar to FOB mode",
		}
	}
}

this.Zoz_Player_Overhaul_LOOK_QUIET={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Player_Overhaul_Snake_Deploy_Line={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Player_Overhaul_Snake_DD_Line={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Player_Overhaul_Ocelot_Interaction={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
--this.Zoz_Player_Overhaul_Player_FOB_respawn={
--	save=IvarProc.CATEGORY_EXTERNAL,
--	range=Ivars.switchRange,
--	settingNames="set_switch",
--	default=0,
--}

function this.ShowRespawnMenu()
	Player.ResetPadMask{
		settingName = "ClientFallDeath",
	}

	Player.RequestToStopCameraAnimation{}	
	if Player.OnStartRespawnMenu ~= nil then
		Player.OnStartRespawnMenu()
	end

	
	TppUiStatusManager.SetStatus( "PauseMenu", "INVALID" )

	TppUI.OverrideFadeInGameStatus{
		EquipHud = false,
		EquipPanel = false,
		PauseMenu = false,
	}


	TppUI.FadeIn( TppUI.FADE_SPEED.FADE_HIGHESTSPEED )

	local rspPoints = {}
	local numRspPoints = #this.Zoz_respawnPosList

	for i, key in pairs(this.Zoz_respawnPosList) do
		local pos, rot = Tpp.GetLocator( "AfghRespawnPointIdentifier", key ) 
		if pos ~= nil then
			rspPoints[i] = Vector3( pos[1], pos[2], pos[3] )
		end
	end

	TppUiCommand.StartRespawnMenuSetRecord{ wait = 5, record = numRspPoints, respawnPoints = rspPoints }
	this.ChangeRespawnPoint(0, 0.1)
end

this.SetRespawnCamera = function ( param )
	
	Player.BeginRespawnCamera()
	
	Player.SetAroundCameraManualMode(true) 
	
	Player.SetAroundCameraManualModeParams{
		distance = param.distance,							
		target = Vector3(mvars.respawnPlayerPos),
		targetInterpTime = param.interpCamTimeSec,
		ignoreCollisionGameObjectName = "Player"
	}
	Player.RequestToSetCameraRotation { rotX = 15, rotY = mvars.respawnPlayerRotY, interpTime = param.interpCamTimeSec }
	Player.UpdateAroundCameraManualModeParams()
end

this.ChangeRespawnPoint = function (respawnPointId, interpCamTimeSec)

	interpCamTimeSec = interpCamTimeSec or 0.2

	local key = this.Zoz_respawnPosList[respawnPointId + 1]

	if key == nil then
		key = this.Zoz_respawnPosList[1]
	end


	mvars.respawnPlayerPos, mvars.respawnPlayerRotY = Tpp.GetLocator("AfghRespawnPointIdentifier", key)

	if not mvars.respawnPlayerPos then
		return
	end

	TppEffectUtility.CreateWormHoleEffect(
		mvars.respawnPlayerPos[1],
		mvars.respawnPlayerPos[2],
		mvars.respawnPlayerPos[3]
	)

	mvars.respawnPlayerPos[2] = mvars.respawnPlayerPos[2] + 1

	this.SetRespawnCamera{ distance = 5, interpCamTimeSec = interpCamTimeSec }
end

function this.RespawnWarp(info)
  	if not IsTypeTable(info)then
  	  return
  	end
  	local pos=info.pos
  	if not IsTypeTable(pos)or(#pos~=3)then
  	  return
  	end
  	local rotY=foxmath.NormalizeRadian(foxmath.DegreeToRadian(info.rotY or 0))
  	local playerId
	playerId={type="TppPlayer2",index=0}
  	local command={id="WarpAndWaitBlock",pos=pos,rotY=rotY}
  	GameObject.SendCommand(playerId,command)
end

this.RespawnPlayer = function (respawnPointId)

	MotherBaseStage.SetFobClientPlayerRespawnTrg()

	TppUI.UnsetOverrideFadeInGameStatus()


	Player.ResetPadMask{
		settingName = "ClientFallDeath",
	}


	TppMain.EnableAllGameStatus()
	Player.SetAroundCameraManualMode(false)
	this.RespawnWarp{ pos = mvars.respawnPlayerPos,rotY = mvars.respawnPlayerRotY}
	

	TppUiStatusManager.ClearStatus( "PauseMenu" )
	TppUiStatusManager.ClearStatus( "EquipHud" )
	TppUiStatusManager.ClearStatus( "EquipPanel" )

	Player.StartFOBInvincible(0)
end

function this.Messages()
    return StrCode32Table{
		GameObject = {
			 {
			 	msg = "BuddyAppear",
			 	func = function (buddyLocatorId)
			 		if buddyLocatorId == GameObject.GetGameObjectId( "BuddyQuietGameObjectLocator" ) and not GkEventTimerManager.IsTimerActive("zoz_timer_LOOK_QUIET") and Ivars.Zoz_Player_Overhaul_LOOK_QUIET:Is(1) and mvars.AtSortie then
			 			GameObject.SendCommand(
			 				{type="TppPlayer2",index=PlayerInfo.GetLocalPlayerIndex()},
			 				{id="SetSpecialAttackMode",enabled=true,type="MissionPrepare",sequence=PlayerMissionPrepareAction.LOOK_QUIET}
			 			)
			 			if not mvars.LOOK_QUIET then
			 				mvars.LOOK_QUIET = true
			 				Player.CallVoice"PLE0010"
			 			end
						GkEventTimerManager.Start("zoz_timer_LOOK_QUIET", 5.5)
			 		end
			 	end,
			 	option = {isExecMissionClear=true}
			},
			{
				msg = "PlayerGetNear" ,
				func=function(gameObjectId)
					if vars.missionCode==30050 then
						if GameObject.DoesGameObjectExistWithTypeName("TppOcelot2") then
							mvars.zoz_isNearOcelot = true
							if mvars.zoz_ocelotLastSaidGreeting1~=1 then
								--UNIQ2100_1i1010 ・Saying something when the player gets up close (1) What's up? gq_s7u
								GameObject.SendCommand(gameObjectId,{id="CallVoice",dialogueName="DD_Ocelot",parameter="gq_s7u"})
								mvars.zoz_ocelotLastSaidGreeting1 = 1
							else
								--UNIQ2100_1j1010 ・Saying something when the player gets up close (2) Hm? a8aq7_a
								GameObject.SendCommand(gameObjectId,{id="CallVoice",dialogueName="DD_Ocelot",parameter="a8aq7_a"})
								mvars.zoz_ocelotLastSaidGreeting1 = 0
							end
							--・Calling a person's name/Normal: Ocelot 578780155 2FFB4546.wem Ocelot. SNAK1100_4u1010_0_snak
							Player.RegisterActionButtonVoice("a0ffdctv","PlayerCallEnd_CallOcelot")
						end
					end
				end
			},
			{
				msg = "PlayerGetAway" ,
				func=function(gameObjectId)
					if vars.missionCode==30050 then
						if GameObject.DoesGameObjectExistWithTypeName("TppOcelot2") then
							mvars.zoz_isNearOcelot = false
							Player.UnregisterActionButtonVoice()
						end
					end
				end
			},
			{
				msg = "RideHeli",
				func = function (buddyLocatorId)
					if (buddyLocatorId == GameObject.GetGameObjectId"BuddyDogGameObjectLocator") then
						if Ivars.Zoz_Player_Overhaul_Snake_DD_Line:Is(1) then
							Player.CallVoice"awtfcpj" -- ・Buddy commands 10/Normal: Climb: Climb up.
						end
					end
				end
			},
		},
		Timer = {
            {
                msg = "Finish",
                sender = "zoz_timer_LOOK_QUIET",
                func = function()
					if mvars.AtSortie then
						GameObject.SendCommand(
							 {type="TppPlayer2",index=PlayerInfo.GetLocalPlayerIndex()},
							 {id="SetSpecialAttackMode",enabled=true,type="MissionPrepare",sequence=PlayerMissionPrepareAction.IDLE}
						 )
					end
                end
            },
			{
                msg = "Finish",
                sender = "zoz_timer_MissionPrep_End",
                func = function()
					local options = {"PLP0070_5", "b817bb6", "None"}
					local choice = options[math.random(#options)]

					if choice == "None" then
					    return
					else
					    Player.CallVoice(choice)
					end
                end
            }
        },
		UI = {
			{
				msg = "MissionPrep_End",
				func = function (selectedDeployTime)
					if Ivars.Zoz_Player_Overhaul_Snake_Deploy_Line:Is(1) then
						GkEventTimerManager.Start("zoz_timer_MissionPrep_End", 0.3)
					end
				end
			},
			{
				msg = "EndFadeIn",
				func = function(fadeInName)
					if fadeInName == StrCode32("OnMissionPreparationStart") and not GkEventTimerManager.IsTimerActive("zoz_timer_LOOK_QUIET") and Ivars.Zoz_Player_Overhaul_LOOK_QUIET:Is(1) then
						mvars.AtSortie = true
						mvars.LOOK_QUIET = false
						if vars.buddyType==BuddyType.QUIET and mvars.AtSortie then
							mvars.LOOK_QUIET = true
							GameObject.SendCommand(
								{type="TppPlayer2",index=PlayerInfo.GetLocalPlayerIndex()},
								{id="SetSpecialAttackMode",enabled=true,type="MissionPrepare" ,sequence=PlayerMissionPrepareAction.LOOK_QUIET}
							)
							GkEventTimerManager.Start("zoz_timer_LOOK_QUIET", 5.5)
						end
					elseif fadeInName == StrCode32("OnMissionPreparationAbort") then
						mvars.AtSortie = false
					end
				end
			},
			{
					msg = "RespawnClose",
					func = function(respawnPointId)
						--this.RespawnPlayer(respawnPointId)
					end,
				},
				{
					msg = "RespawnChange",
					func = function(respawnPointId)
						--this.ChangeRespawnPoint(respawnPointId)
					end,
				},
		},
		Player = {
			{
				msg="PlayerCallEnd_CallOcelot",
				func=function()
					--・Calling out to the player
					-- UNIQ2100_1f1010 Hey! 2ffb3bf1.wem 3983588162 afs_j_k
					-- UNIQ2100_1g1010 Big Boss. (Eyes meet, and this is said in greeting) 2ffb3bf4.wem 4000365877 i281o9
					-- UNIQ2100_1h1010 You're pretty good. 2ffb3bf7.wem 4017143464 gq_s4s
					--・Supplemental shooting practice lines
					-- UNIQ2100_1k1010 2ffb3c00.wem Something up? 2021151288 adejxjo
					-- UNIQ2100_1l1010 2ffb3c03.wem Just a moment. 2071484145 tjh6yk
					--Reaction when getting up close to Ocelot at the shooting range
					if mvars.zoz_ocelotLastSaidReply== 1 then
						mvars.zoz_ocelotLastSaidReply= 2
						GameObject.SendCommand({ type="TppOcelot2", index=0 },{id="CallVoice",dialogueName="DD_Ocelot",parameter="afs_j_k"})
					elseif mvars.zoz_ocelotLastSaidReply== 2 then
						mvars.zoz_ocelotLastSaidReply= 3
						GameObject.SendCommand({ type="TppOcelot2", index=0 },{id="CallVoice",dialogueName="DD_Ocelot",parameter="i281o9"})
					elseif mvars.zoz_ocelotLastSaidReply== 3 then
						mvars.zoz_ocelotLastSaidReply= 1
						GameObject.SendCommand({ type="TppOcelot2", index=0 },{id="CallVoice",dialogueName="DD_Ocelot",parameter="gq_s4s"})
					else
						mvars.zoz_ocelotLastSaidReply= 1
						GameObject.SendCommand({ type="TppOcelot2", index=0 },{id="CallVoice",dialogueName="DD_Ocelot",parameter="adejxjo"})
					end
					if mvars.zoz_isNearOcelot then
						Player.RegisterActionButtonVoice("a0ffdctv","PlayerCallEnd_CallOcelot")
					end
				end
			},
			{
				msg = "OnVehicleRide_Start",
				func = function (playerIndex, rideFlag, vehicleId)
					if Ivars.Zoz_Player_Overhaul_Snake_DD_Line:Is(1) then
						local vehicleType = GameObject.SendCommand( vehicleId, { id="GetVehicleType", })
						if ( vars.buddyType == BuddyType.DOG ) and vehicleType == Vehicle.type.EASTERN_LIGHT_VEHICLE or vehicleType == Vehicle.type.WESTERN_LIGHT_VEHICLE then
							if Zoz_Overhaul.IsNotPhase(PHASE_ALERT) then
								if rideFlag == 0 then -- Player Get in and 1 is get out
									if mvars.Current_BGM_PHASE_LV == nil or mvars.Current_BGM_PHASE_LV <= 1 then
										Player.CallVoice"b817bb6" --・Buddy commands 4/Normal: Get in: Let's go.
									else
										Player.CallVoice"cjz_5ol" --・Buddy commands 4/Tense: Get in: Let's go. (lowered voice)
									end
								else
									if mvars.Current_BGM_PHASE_LV == nil or mvars.Current_BGM_PHASE_LV <= 1 then
										Player.CallVoice"qx6z6" --・Buddy commands 5/Normal: Get out: We're here.
									else
										Player.CallVoice"ax23v_4"   --・Buddy commands 5/Tense: Get out: We're here. (lowered voice)
									end
								end
							else
								return
							end
						end
					end
				end
			},
			{
				msg = "PlayerHeliGetOff",
				func = function (playerIndex, departingHeliId)
					if Ivars.Zoz_Player_Overhaul_Snake_DD_Line:Is(1) and ( vars.buddyType == BuddyType.DOG ) then
						Player.CallVoice"aldwskf" -- ・Buddy commands 11/Normal: Descend: Climb down.
					end
				end
			},
			{
				msg = "Dead",
				func = function (playerIndex, deathType)
					--this.ShowRespawnMenu()
				end
			},
            {
                msg = "PlayerHoldWeapon",
                func = function()
                    -- FOR DEBUG 
                end
            },

        },
		Sound = {
			{
				msg = "ChangeBgmPhase",
				func = function (bgmPhase)
					mvars.Current_BGM_PHASE_LV = bgmPhase
				end
			},
		},
    }
end

this.Zoz_respawnPosList = {
	"player_spawn_locator_afgh_0000",
}


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
	mvars.LOOK_QUIET = false
	mvars.Current_BGM_PHASE_LV = nil
	
	if vars.missionCode==30050 and Ivars.Zoz_Player_Overhaul_Ocelot_Interaction:Is(1) and Ivars.mbEnableOcelot:Is(1) then
		if GameObject.DoesGameObjectExistWithTypeName("TppOcelot2") then
			GameObject.SendCommand( { type="TppOcelot2", index=0 }, { id = "SetPlayerDistanceCheck", enabled = true, near = 5, far = 7.5 } )
		end
	end
	this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

return this