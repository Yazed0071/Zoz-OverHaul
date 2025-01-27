local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local missionID = TppMission.GetMissionID()

this.registerMenus={
	"Zoz_Idroid_Overhaul",
	"Zoz_Idroid_Overhaul_Notification",
	"Zoz_Idroid_Overhaul_Audio_Notification",
}

this.Zoz_Idroid_Overhaul={
	parentRefs={"Zoz_Overhaul.safeSpaceMenu","Zoz_Overhaul.inMissionMenu"},
	options={
		"Zoz_Idroid_Overhaul.Zoz_Idroid_Overhaul_Notification",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_Overhaul_Audio_Notification",
	}
}

this.registerIvars={
    "Zoz_Idroid_announce_enemyRecovered",
	"Zoz_Idroid_announce_destroy_APC",
	"Zoz_Idroid_announce_destroy_vehicle",
	"Zoz_Idroid_announce_destroy_truck",
	"Zoz_Idroid_announce_destroy_AntiAirCraftGun",
	"Zoz_Idroid_announce_destroy_heli",
	"Zoz_Idroid_announce_enemyIncrease",
	"Zoz_Idroid_announce_quiet_request",
	"Zoz_Idroid_announce_enemy_checkpoint",
	"Zoz_Idroid_announce_enemyReplacement",
	"Zoz_Idroid_announce_approach_border",
	"Zoz_Idroid_announce_FOB_Alert",

	"Zoz_Idroid_Audio_Welcome_Acc",
	"Zoz_Idroid_Audio_OpenStaffManagement",
	"Zoz_Idroid_Audio_Prepare_Sortie",
	"Zoz_Idroid_Audio_Friendly_Vehicle_Destroyed",
	"Zoz_Idroid_Audio_Heli_Withdrawn",
	"Zoz_Idroid_Audio_OnRequested_AirStrike",
}

this.Zoz_Idroid_Overhaul_Notification={
	parentRefs={"Zoz_Idroid_Overhaul.safeSpaceMenu","Zoz_Idroid_Overhaul.inMissionMenu"},
	options={
		"Ivars.Zoz_Idroid_announce_enemyRecovered",
		"Ivars.Zoz_Idroid_announce_destroy_APC",
		"Ivars.Zoz_Idroid_announce_destroy_vehicle",
		"Ivars.Zoz_Idroid_announce_destroy_truck",
		"Ivars.Zoz_Idroid_announce_destroy_AntiAirCraftGun",
		"Ivars.Zoz_Idroid_announce_destroy_heli",
		"Ivars.Zoz_Idroid_announce_enemyIncrease",
		"Ivars.Zoz_Idroid_announce_quiet_request",
		"Ivars.Zoz_Idroid_announce_enemy_checkpoint",
		"Ivars.Zoz_Idroid_announce_enemyReplacement",
		"Ivars.Zoz_Idroid_announce_approach_border",
		"Ivars.Zoz_Idroid_announce_FOB_Alert",
	}
}

this.Zoz_Idroid_Overhaul_Audio_Notification={
	parentRefs={"Zoz_Idroid_Overhaul.safeSpaceMenu","Zoz_Idroid_Overhaul.inMissionMenu"},
	options={
		"Ivars.Zoz_Idroid_Audio_Welcome_Acc",
		"Ivars.Zoz_Idroid_Audio_OpenStaffManagement",
		"Ivars.Zoz_Idroid_Audio_Prepare_Sortie",
		"Ivars.Zoz_Idroid_Audio_Friendly_Vehicle_Destroyed",
		"Ivars.Zoz_Idroid_Audio_Heli_Withdrawn",
		"Ivars.Zoz_Idroid_Audio_OnRequested_AirStrike",
	}
}

this.langStrings={
	eng={
		Zoz_Idroid_Overhaul = "Idroid Overhaul",

		Zoz_Idroid_Overhaul_Notification = "Idroid Notifications",
		Zoz_Idroid_announce_enemyRecovered = "Enemy recovred",
		Zoz_Idroid_announce_destroy_APC = "Destroy APC",
		Zoz_Idroid_announce_destroy_vehicle = "Destroy vehicle",
		Zoz_Idroid_announce_destroy_truck = "Destroy truck",
		Zoz_Idroid_announce_destroy_AntiAirCraftGun = "Destroy AntiAirCraftGun",
		Zoz_Idroid_announce_destroy_heli = "Destroy heli",
		Zoz_Idroid_announce_enemyIncrease = "Enemy Increase",
		Zoz_Idroid_announce_quiet_request = "Quiet request",
		Zoz_Idroid_announce_enemy_checkpoint = "Enemy checkpoint",
		Zoz_Idroid_announce_enemyReplacement = "Enemy shift change",
		Zoz_Idroid_announce_approach_border = "Approach border",
		Zoz_Idroid_announce_FOB_Alert = "Intruder on FOB",

		Zoz_Idroid_Overhaul_Audio_Notification = "Idroid Audio Notifications",
		Zoz_Idroid_Audio_Welcome_Acc = "ACC Welcome Message",
		Zoz_Idroid_Audio_OpenStaffManagement = "On opening Staff Management",
		Zoz_Idroid_Audio_Prepare_Sortie = "On Sortie prep",
		Zoz_Idroid_Audio_OnRequested_AirStrike = "On AirStrike or Weather Modification",
		Zoz_Idroid_Audio_Friendly_Vehicle_Destroyed = "Friendly Vehicle Destroyed",
		Zoz_Idroid_Audio_Heli_Withdrawn = "Support Heli Dismissed",
	},
	help={
		eng={
			Zoz_Idroid_Overhaul = "Toggle individual options for Idroid.",
			Zoz_Idroid_announce_enemyRecovered = "Announce when enemy regains consciousness",
			Zoz_Idroid_announce_destroy_APC = "Announce when an enemy Armored Vehicle is destroyed",
			Zoz_Idroid_announce_destroy_vehicle = "Announce when an enemy 4 wheel drive is destroyed",
			Zoz_Idroid_announce_destroy_truck = "Announce when an enemy truck drive is destroyed",
			Zoz_Idroid_announce_destroy_AntiAirCraftGun = "Announce when an Anti Air Craft gun is destroyed",
			Zoz_Idroid_announce_destroy_heli = "Announce when an enemy helicopter is destroyed",
			Zoz_Idroid_announce_enemyIncrease = "Announce when enemy reinfrocement spawn",
			Zoz_Idroid_announce_quiet_request = "Announce when quiet's health drop below 25",
			Zoz_Idroid_announce_enemy_checkpoint = "Announce when enemy sets a checkpoint",
			Zoz_Idroid_announce_enemyReplacement = "Announce when enemy changes shift",
			Zoz_Idroid_announce_approach_border = "Announce when approaching the boarder between Angola and Zaire in Africa",
			Zoz_Idroid_announce_FOB_Alert = "an intruder on FOB",

			Zoz_Idroid_Audio_Welcome_Acc = "Play an audio when hitting Continue from the main menu into the ACC",
			Zoz_Idroid_Audio_OpenStaffManagement = "Play an audio when Staff Management menu is opened",
			Zoz_Idroid_Audio_Prepare_Sortie = "Play an audio when On Sortie prep",
			Zoz_Idroid_Audio_Friendly_Vehicle_Destroyed = "Play an audio when a Friendly Vehicle Destroyed",
			Zoz_Idroid_Audio_Heli_Withdrawn = "Play an audio when the Support Heli Dismissed",
			Zoz_Idroid_Audio_OnRequested_AirStrike = "Play an audio when calling for Fire Support or Modifying Weather",
		},
	},
}

this.Zoz_Idroid_announce_enemyRecovered={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
-- ... [remaining ivar configurations unchanged] ...

function this.OnAllocate()
    InfCore.Log("Zoz_Overhaul Log: Zoz_Idroid_Overhaul.OnAllocate()")
end

function this.OnInitialize()
    InfCore.Log("Zoz_Overhaul Log: Zoz_Idroid_Overhaul.OnInitialize()")
end

function this.LoadLibraries()
    InfCore.Log("Zoz_Overhaul Log: Loading Idroid Overhaul libraries")
    local ShowAnnounceLog = TppUI.ShowAnnounceLog
    TppUI.ShowAnnounceLog = function(announceId,param1,param2,delayTime,missionSubGoalNumber)
        InfCore.Log("Zoz_Overhaul Log: ShowAnnounceLog - "..tostring(announceId)..
                    " p1:"..tostring(param1).." p2:"..tostring(param2))
        ShowAnnounceLog(announceId,param1,param2,delayTime,missionSubGoalNumber)
        if announceId == "mine_quest_log" and param1 == param2 then
            TppUiCommand.AnnounceLogViewLangId("announce_disposal_minefield")
        end
    end
end

function this.IdroidRadioPlay(r)
    InfCore.Log("Zoz_Overhaul Log: Playing radio ID: "..tostring(r))
    TppRadio.Play(r, {isEnqueue = true})
end

function this.Messages()
    return StrCode32Table{
		GameObject = {
			{
				msg = "VehicleBroken",
				func = function(gameObjectId, state)
					if state == StrCode32("End") then
						local type = GameObject.SendCommand(gameObjectId, {id="GetVehicleType"})
						InfCore.Log("Zoz_Overhaul Log: VehicleBroken - Type:"..tostring(type).." ID:"..tostring(gameObjectId))
						
						if gameObjectId == 25600 and Ivars.Zoz_Idroid_Audio_Friendly_Vehicle_Destroyed:Is(1) then
							InfCore.Log("Zoz_Overhaul Log: Friendly vehicle destroyed notification")
							this.IdroidRadioPlay("idrd1000_106444")
						else
							if type==Vehicle.type.EASTERN_WHEELED_ARMORED_VEHICLE or type==Vehicle.type.WESTERN_WHEELED_ARMORED_VEHICLE and Ivars.Zoz_Idroid_announce_destroy_APC:Is(1) then
								InfCore.Log("Zoz_Overhaul Log: APC destroyed announcement")
								TppUiCommand.AnnounceLogViewLangId("announce_destroy_APC")
							elseif type==Vehicle.type.EASTERN_LIGHT_VEHICLE or type==Vehicle.type.WESTERN_LIGHT_VEHICLE and Ivars.Zoz_Idroid_announce_destroy_vehicle:Is(1) then
								InfCore.Log("Zoz_Overhaul Log: Vehicle destroyed announcement")
								TppUiCommand.AnnounceLogViewLangId("announce_destroy_vehicle")
							elseif type==Vehicle.type.EASTERN_TRUCK or type==Vehicle.type.WESTERN_TRUCK and Ivars.Zoz_Idroid_announce_destroy_truck:Is(1) then
								InfCore.Log("Zoz_Overhaul Log: Truck destroyed announcement")
								TppUiCommand.AnnounceLogViewLangId("announce_destroy_truck")
							end
						end
					end
				end
			},
			{
				msg = "LostControl",
				func = function(heliId, sequenceName, attackerId)
					if sequenceName == StrCode32("End") and Ivars.Zoz_Idroid_announce_destroy_heli:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: Helicopter destroyed announcement")
						TppUiCommand.AnnounceLogViewLangId("announce_destroy_heli")
					end
				end
			},
			{
				msg = "BreakGimmick",
				func = function(gameObjectId, locatorName, locatorNameUpper, breakerGameObjectId)
					if Tpp.IsGatlingGun(gameObjectId) and Ivars.Zoz_Idroid_announce_destroy_AntiAirCraftGun:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: Anti-aircraft gun destroyed announcement")
						TppUiCommand.AnnounceLogViewLangId("announce_destroy_AntiAirCraftGun")
					end
				end,
			},
			{
				msg = "ReinforceRespawn",
				func = function(arg0)
					if mvars.ReinforceRespawnCooldown == false and not (vars.locationCode == TppDefine.LOCATION_ID.GNTN) and Ivars.Zoz_Idroid_announce_enemyIncrease:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: Enemy reinforcement spawned")
						mvars.ReinforceRespawnCooldown = true
						TppUiCommand.AnnounceLogViewLangId("announce_enemyIncrease")
						GkEventTimerManager.Start("ReinforceRespawn", 5)
					end
				end
			},
			{
				msg = "Conscious",
				func = function(gameObjectId)
					if Tpp.IsSoldier(gameObjectId) and Ivars.Zoz_Idroid_announce_enemyRecovered:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: Enemy recovered consciousness")
						TppUiCommand.AnnounceLogViewLangId("announce_enemyRecovered")
					end
				end
			},
			{
				msg = "ChangeLife",
				func = function(gameObjectId, hitPoint)
					if (gameObjectId == GameObject.GetGameObjectId"BuddyQuietGameObjectLocator") and Ivars.Zoz_Idroid_announce_quiet_request:Is(1)then
						if hitPoint <= 25 and mvars.QuietSOS == false then
							InfCore.Log("Zoz_Overhaul Log: Quiet health low (HP:"..hitPoint..")")
							mvars.QuietSOS = true
							TppUiCommand.AnnounceLogViewLangId("announce_quiet_request")
						else
							mvars.QuietSOS = false
						end
					end
				end
			},
			{
				msg = "RadioEnd",
				func = function(gameObjectId, cpGameObjectId, speechLabel, isSuccess)
					local e=TppEnemy.GetCpSubType(cpGameObjectId)
					local n="cmmn_ene_soviet"
					-- ... [original cp type handling] ...
					
					if speechLabel == StrCode32("HQR0130") and Ivars.Zoz_Idroid_announce_enemy_checkpoint:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: Enemy checkpoint announcement")
						TppUiCommand.AnnounceLogViewLangId("announce_mission_40_20030_004_from_0_prio_0",n)
					elseif speechLabel == StrCode32("CPR0330") and Ivars.Zoz_Idroid_announce_enemyReplacement:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: Enemy shift change announcement")
						TppUiCommand.AnnounceLogViewLangId("announce_enemyReplacement",n)
					end
				end
			},
			{
				msg = "StartedMoveToLandingZone",
				func = function(gameId, landingZone)
					if gameId == 7168 then
						InfCore.Log("Zoz_Overhaul Log: Support helicopter moving to LZ")
						mvars.IsSupportHeliAttacking = false
					end
				end
			},
			{
				msg = "StartedPullingOut",
				func =function(gameId)
					if gameId == 7168 and mvars.IsSupportHeliAttacking == false and Ivars.Zoz_Idroid_Audio_Heli_Withdrawn:Is(1)then
						InfCore.Log("Zoz_Overhaul Log: Helicopter withdrawal audio")
						this.IdroidRadioPlay("idrd1000_2d1010")
					end
				end
			}
		},
		Timer = {
			{
				msg = "Finish",
				sender = "ReinforceRespawn",
				func = function()
					InfCore.Log("Zoz_Overhaul Log: Reinforce respawn cooldown expired")
					mvars.ReinforceRespawnCooldown = false
				end
			},
		},
		Trap = {
			{
				msg = "Enter",
				sender = "trap_border_a",
				func = function()
					if Ivars.Zoz_Idroid_announce_approach_border:Is(1) then
						mvars.InZaire = false
						if mvars.InAngola == true then
							InfCore.Log("Zoz_Overhaul Log: Approaching border announcement")
							TppUiCommand.AnnounceLogViewLangId("announce_approach_border")
						else
							mvars.InAngola = true
							InfCore.Log("Zoz_Overhaul Log: Entered Angola")
							TppUiCommand.AnnounceLogViewLangId("announce_immigration_angola")
						end
					end
				end,
			},
			{
				msg = "Enter",
				sender = "trap_border_b",
				func = function()
					if Ivars.Zoz_Idroid_announce_approach_border:Is(1) then
						mvars.InAngola = false
						if mvars.InZaire == true then
							InfCore.Log("Zoz_Overhaul Log: Approaching border announcement")
							TppUiCommand.AnnounceLogViewLangId("announce_approach_border")
						else
							mvars.InAngola = false
							mvars.InZaire = true
							InfCore.Log("Zoz_Overhaul Log: Entered Zaire")
							TppUiCommand.AnnounceLogViewLangId("announce_immigration_zaire")
						end
					end
				end,
			},
		},

		Network={
			{
				msg="NoticeSneakMotherBase",
				func=function(n,e)
					if Ivars.Zoz_Idroid_announce_FOB_Alert:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: FOB alert notification")
						if n==FobMode.MODE_ACTUAL then
							TppUI.ShowAnnounceLog"fobNoticeIntruder"
						-- ... [rest of FOB handling] ...
						end
					end
				end
			},
			{
				msg="NoticeSneakSupportedMotherBase",
				func=function()
					if Ivars.Zoz_Idroid_announce_FOB_Alert:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: FOB support request")
						TppUiCommand.AnnounceLogViewLangId("announce_fob_req_help")
					end
				end
			}
		},
		SupportAttack = {
			{
				msg = "OnRequested",
				func = function(playerIndex, supportStrikeId, gradeId)
					if Ivars.Zoz_Idroid_Audio_OnRequested_AirStrike:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: Support attack requested - Type:"..tostring(supportStrikeId))
						if supportStrikeId == 1 then
							this.IdroidRadioPlay("idrd1000_121010")
						elseif supportStrikeId == 5 then
							this.IdroidRadioPlay("idrd1000_1i1010")
						end
					end
				end
			}
		},
		Terminal = {
			{
				msg = "MbDvcActOpenStaffList",
				func = function()
					if Ivars.Zoz_Idroid_Audio_OpenStaffManagement:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: Staff management opened")
						this.IdroidRadioPlay("idrd1000_1j1010")
					end
				end
			},
			{
				msg = "MbDvcActHeliGoHere",
				func = function()
					InfCore.Log("Zoz_Overhaul Log: Helicopter attack ordered")
					mvars.IsSupportHeliAttacking = true
				end
			},
		},
		UI = {
			{
				msg = "TitleMenu",
				func = function(action)
					if action == 3261117285 then
						return
					elseif action == 1439467306 and (vars.missionCode == 40010) or (vars.missionCode == 40020) or (vars.missionCode == 40050) and Ivars.Zoz_Idroid_Audio_Welcome_Acc:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: ACC welcome message played")
						this.IdroidRadioPlay("idrd1000_106552")
						this.IdroidRadioPlay("idrd1000_106553")
					end
				end
			},
			{
				msg = "EndFadeIn",
				func = function(fadeInName, unk1)
					if fadeInName == 3515316815 and Ivars.Zoz_Idroid_Audio_Prepare_Sortie:Is(1) then
						InfCore.Log("Zoz_Overhaul Log: Sortie preparation audio")
						this.IdroidRadioPlay("idrd1000_106556")
					end
				end
			},
		},
    }
end

function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
    InfCore.Log("Zoz_Overhaul Log: Received message - "..
                Tpp.DumpMessage(messageId,arg0,arg1,arg2,arg3,strLogText))
    
    if TppMission.IsFOBMission(vars.missionCode) or (vars.locationCode == TppDefine.LOCATION_ID.GNTN) then
        InfCore.Log("Zoz_Overhaul Log: Skipping message handling for FOB/GNTN")
        return
    end
    
    Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText)
end

function this.OnLoad()
	InfCore.Log("Zoz_Overhaul Log: Zoz_Idroid_Overhaul.OnLoad()")
end

function this.Init(missionTable)
	InfCore.Log("Zoz_Overhaul Log: Initializing Idroid Overhaul")
	
	if TppMission.IsFOBMission(vars.missionCode) or (vars.locationCode == TppDefine.LOCATION_ID.GNTN) then
		InfCore.Log("Zoz_Overhaul Log: Skipping initialization for FOB/GNTN")
		return
	end
	
	InfCore.Log("Zoz_Overhaul Log: Resetting state variables")
	mvars.ReinforceRespawnCooldown = false
	mvars.InAngola = true
	mvars.InZaire = true
	mvars.QuietSOS = false
	mvars.IsSupportHeliAttacking = false

	this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

return this