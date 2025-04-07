local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local NULL_ID=GameObject.NULL_ID
local missionID = TppMission.GetMissionID()

this.registerMenus={
	"Zoz_Support_Radio_Overhaul",
	"Zoz_Support_Radio_Overhaul_mtbs",
	"Zoz_Support_Radio_Overhaul_Pilot",
}

this.registerIvars={
	"Zoz_Support_Radio_Pilot_React_Damage",
	"Zoz_Support_Radio_Pilot_Taxi_Radio",
	"Zoz_Support_Radio_Pilot_Abort_Radio",
	"Zoz_Support_Radio_Pilot_On_Landing",
	"Zoz_Support_Radio_mtbs_announce_OrderBox",
	"Zoz_Support_Radio_mtbs_announce_near_quest",
	"Zoz_Support_Radio_mtbs_announce_quest_complete",
	"Zoz_Support_Radio_mtbs_announce_FOB_Invasion",
}

this.Zoz_Support_Radio_Overhaul={
	parentRefs={"Zoz_Overhaul.safeSpaceMenu","Zoz_Overhaul.inMissionMenu"},
	options={
		"Zoz_Support_Radio_Overhaul.Zoz_Support_Radio_Overhaul_mtbs",
		"Zoz_Support_Radio_Overhaul.Zoz_Support_Radio_Overhaul_Pilot",
	}
}
this.Zoz_Support_Radio_Overhaul_mtbs={
	parentRefs={"Zoz_Support_Radio_Overhaul.safeSpaceMenu","Zoz_Support_Radio_Overhaul.inMissionMenu"},
	options={
		"Ivars.Zoz_Support_Radio_mtbs_announce_OrderBox",
		"Ivars.Zoz_Support_Radio_mtbs_announce_near_quest",
		"Ivars.Zoz_Support_Radio_mtbs_announce_quest_complete",
		"Ivars.Zoz_Support_Radio_mtbs_announce_FOB_Invasion",
	}
}
this.Zoz_Support_Radio_Overhaul_Pilot={
	parentRefs={"Zoz_Support_Radio_Overhaul.safeSpaceMenu","Zoz_Support_Radio_Overhaul.inMissionMenu"},
	options={
		"Ivars.Zoz_Support_Radio_Pilot_React_Damage",
		"Ivars.Zoz_Support_Radio_Pilot_Taxi_Radio",
		"Ivars.Zoz_Support_Radio_Pilot_Abort_Radio",
		"Ivars.Zoz_Support_Radio_Pilot_On_Landing",
	}
}

this.langStrings={
	eng={
		Zoz_Support_Radio_Overhaul = "Support Radio Overhaul",
		Zoz_Support_Radio_Overhaul_mtbs = "Support Radio",
		Zoz_Support_Radio_mtbs_announce_OrderBox = "When an Order Box appears",
		Zoz_Support_Radio_mtbs_announce_near_quest = "When in side op area",
		Zoz_Support_Radio_mtbs_announce_quest_complete ="When side op completed",
		Zoz_Support_Radio_mtbs_announce_FOB_Invasion = "When FOB invaded",


		Zoz_Support_Radio_Overhaul_Pilot = "Pequod Radio",
		Zoz_Support_Radio_Pilot_React_Damage = "Reaction to damage",
		Zoz_Support_Radio_Pilot_Taxi_Radio = "On MotherBase Taxi",
		Zoz_Support_Radio_Pilot_Abort_Radio = "On aborting mission",
		Zoz_Support_Radio_Pilot_On_Landing = "On Landing",
	},
	help={
		eng={
			Zoz_Support_Radio_Overhaul = "Toggle individual options for Support Radio",
			Zoz_Support_Radio_Overhaul_mtbs = "Toggle individual options for miller and ocelot Support Radio.",
			Zoz_Support_Radio_mtbs_announce_OrderBox = "When accepting a mission in free room",
			Zoz_Support_Radio_mtbs_announce_near_quest = "When in a side op area (it's radius)",
			Zoz_Support_Radio_mtbs_announce_quest_complete ="When side op completed",
			Zoz_Support_Radio_mtbs_announce_FOB_Invasion = "When FOB invaded or a supported FOB is also invaded",

			Zoz_Support_Radio_Overhaul_Pilot = "Toggle individual options for Pequod.",
			Zoz_Support_Radio_Pilot_React_Damage = "Play an audio when the support heli takes damage",
			Zoz_Support_Radio_Pilot_Taxi_Radio = "Play an audio when moving between platforms on MotherBase using the support heli",
			Zoz_Support_Radio_Pilot_Abort_Radio = "Play an audio when the player aborts the mission",
			Zoz_Support_Radio_Pilot_On_Landing = "play an audio when the support heli start landing",
		},
	},
}

this.Zoz_Support_Radio_mtbs_announce_OrderBox={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Support_Radio_mtbs_announce_near_quest={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Support_Radio_mtbs_announce_quest_complete={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Support_Radio_mtbs_announce_FOB_Invasion={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Support_Radio_Pilot_React_Damage={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Support_Radio_Pilot_Taxi_Radio={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Support_Radio_Pilot_Abort_Radio={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Support_Radio_Pilot_On_Landing={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}


function this.LoadLibraries()
    local ShowAnnounceLog = TppUI.ShowAnnounceLog
    TppUI.ShowAnnounceLog = function(announceId,param1,param2,delayTime,missionSubGoalNumber) -- value if announceId comes from TppUi.ANNOUNCE_LOG_TYPE
		ShowAnnounceLog(announceId,param1,param2,delayTime,missionSubGoalNumber)
		if Ivars.Zoz_Support_Radio_mtbs_announce_near_quest:Is(1) then
			if announceId== "fobNoticeIntruder" and Ivars.Zoz_Support_Radio_mtbs_announce_FOB_Invasion:Is(1) then
				TppRadio.Play( "f2000_rtrg1030",{delayTime = "long"} )
			elseif announceId== "fobReqHelp" and Ivars.Zoz_Support_Radio_mtbs_announce_FOB_Invasion:Is(1) then
				TppRadio.Play( "f2000_rtrg1040",{delayTime = "long"} )
			elseif announceId == "quest_complete" and Ivars.Zoz_Support_Radio_mtbs_announce_quest_complete:Is(1)then
				TppRadio.Play( "frer1000_103634",{delayTime = "long"} )
			end
		end
    end
end


function this.OnAllocate()end

function this.PilotRadioPlay(r)
	InfCore.Log("Zoz_Overhaul Log: Zoz_Support_Radio_Overhaul.PilotRadioPlay(".. r .. ")")
	TppRadio.Play(r)
end

this.CheckDistPlayerToLocator = function(iden, key)	
	local position1 = TppPlayer.GetPosition()
	local position2, rotQuat = Tpp.GetLocatorByTransform( iden, key )
	local point2 = TppMath.Vector3toTable( position2 )
	mvars.zoz_ClosestOrderBox = point2

	local dist = 0

	dist = math.sqrt(TppMath.FindDistance( position1, point2 ))
	
	InfCore.Log("Zoz log: player dist = "..dist)

	return dist
end

this.EspionageBoxGimmick = {
	"box_s10033_00",
	"box_s10033_01",
	"box_s10036_00",
	"box_s10036_01",
	"box_s10036_02",
	"box_s10040_00",
	"box_s10041_00",
	"box_s10041_01",
	"box_s10041_02",
	"box_s10041_03",
	"box_s10043_00",
	"box_s10044_00",
	"box_s10044_01",
	"box_s10045_00",
	"box_s10052_00",
	"box_s10054_00",
	"box_s10054_01",
	"box_s10054_02",
	"box_s10156_00",
	"box_s10081_00",
	"box_s10082_00",
	"box_s10085_00",
	"box_s10085_01",
	"box_s10086_00",
	"box_s10090_00",
	"box_s10091_00",
	"box_s10093_00",
	"box_s10093_01",
	"box_s10093_02",
	"box_s10100_00",
	"box_s10100_01",
	"box_s10100_02",
	"box_s10110_00",
	"box_s10120_00",
	"box_s10121_00",
	"box_s10130_00",
	"box_s10171_00",
	"box_s10171_01",
	"box_s10195_00",
	"box_s10195_01",
	"box_s10200_00",
	"box_s10211_00",
	"box_s10211_01",
}

this.EspionageBoxHashToName = {}
for _, name in ipairs(this.EspionageBoxGimmick) do
	this.EspionageBoxHashToName[StrCode32(name)] = name
end

function this.OnInitialize()
	
end

function this.Messages()
    return StrCode32Table{
		GameObject = {
			{
				msg = "EspionageBoxGimmickOnGround",
				func = function (gameObjectId, locatorUpper, locatorLower)
					GkEventTimerManager.Start("zoz_EspionageBoxGimmickOnGround_Timer", 1.5)
				end
			},
			{
				msg = "DescendToLandingZone",
				func = function (heliId, landingZone)
					GkEventTimerManager.Start("zoz_DescendToLandingZone", 3)
				end
			},
			{
				msg = "Damage",
				func = function (damagedId, attackId, attackerId, damageMessageFlag)
					if damagedId == 7168 and not GkEventTimerManager.IsTimerActive("zoz_Heli_Damage_Announce_cooldown") and Ivars.Zoz_Support_Radio_Pilot_React_Damage:Is(1) then -- 7168 support heli, 
						GkEventTimerManager.Start("zoz_Heli_Damage_Announce_cooldown", 20)
						if attackId == 366 or  attackId == 307 or attackId == 380 then -- 366 ATK_30102 (bullets) or 307 ATK_Tankgun_12_7mmHeavyMachineGun_West (Turrents on tanks)
							this.PilotRadioPlay("support_heli_TakenDamge_Bullets") 
						elseif attackId == 266 or attackId == 301 then -- 266 ATK_Sad (Gatling_Gun) or 301 ATK_Tankgun_20mmAutoCannon (Armored Vehicles)
							this.PilotRadioPlay("support_heli_TakenDamge_RpgDanger")
						elseif attackId == 432 then -- ATK_80103 (RPG)
							this.PilotRadioPlay("support_heli_TakenDamge_Rpg")
						elseif attackId == 307 or attackId == 264 then -- 307 ATK_Tankgun_12_7mmHeavyMachineGun_West (Turrents on tanks) or 264 ATK_Nad (AntiAir)
							this.PilotRadioPlay("support_heli_TakenDamge_BulletsDanger")
						end
					end
				end
			},
			{
				msg = "RequestedHeliTaxi",
				func = function( gameObjectId, currentLandingZoneName, nextLandingZoneName )
					if Ivars.Zoz_Support_Radio_Pilot_Taxi_Radio:Is(1) then
						TppRadio.Play("support_heli_Taxi", { delayTime = "long" })
					end
				end
			},
			{
				msg = "StartedPullingOut",
				func = function (arg0)
					if arg0 == 7168 then
						mvars.Zoz_Open_Door_Pilot_Radio = false
						if mvars.HeliAskAbort == true and Ivars.Zoz_Support_Radio_Pilot_Abort_Radio:Is(1) then
							if Tpp.IsNotAlert() then
								TppRadio.Play("support_heli_abort_normal", { delayTime = "long" })
							else
								TppRadio.Play("support_heli_abort_alert", { delayTime = "long" })
							end
						end
					end
				end
			},
			{
				msg = "StartedMoveToLandingZone",
				func = function (gameId, landingZone)
					if gameId == 7168 then -- Support Heli
						mvars.Zoz_Open_Door_Pilot_Radio = false
					end
				end
			},
		},
		Timer = {
			{
				msg = "Finish",
				sender = "zoz_EspionageBoxGimmickOnGround_Timer",
				func = 	function()
					if mvars.order_box_isAllOnGround and Ivars.Zoz_Support_Radio_mtbs_announce_OrderBox:Is(1) then
						InfCore.Log("Zoz Log: mvars.order_box_isAllOnGround: true")
						if mvars.Zoz_OnAmmoStackEmpty then
							TppRadio.Play("f1000_rtrg0480")
						else
							TppRadio.Play("f1000_rtrg0500")
						end
					else
						InfCore.Log("Zoz Log: mvars.order_box_isAllOnGround: false")
					end
				end
			},
			{
				msg = "Finish",
				sender = "zoz_DescendToLandingZone",
				func = 	function()
					if mvars.Zoz_Open_Door_Pilot_Radio == false and Ivars.Zoz_Support_Radio_Pilot_On_Landing:Is(1) then
						mvars.Zoz_Open_Door_Pilot_Radio = true
						InfCore.Log("zoz_DescendToLandingZonezoz_DescendToLandingZonezoz_DescendToLandingZonezoz_DescendToLandingZonezoz_DescendToLandingZone")
						if Tpp.IsNotAlert() then
							this.PilotRadioPlay("support_heli_Opening_Door")
						else
							this.PilotRadioPlay("support_heli_Force_Landing")
						end
					end
				end
			},
		},
		Radio = {
			{
				msg = "Finish",
				func = function (arg0, unk1)
					if arg0 == 2700484891 then
						mvars.HeliAskAbort = true
					end
				end
			}
		},
		Player = {
			{
				msg = "PlayerHeliGetOff",
				func = function ()
					mvars.HeliAskAbort = false
				end
			},
			{
				msg = "OnAmmoStackEmpty",
				func = function (playerIndex, belongsToPlayer)
					if playerIndex == 0 then
						mvars.Zoz_OnAmmoStackEmpty = true
					end
				end
			},
		},
		UI = {
			{
				msg = "QuestAreaAnnounceText",
				func = 	function(arg0)
					if Ivars.Zoz_Support_Radio_mtbs_announce_near_quest:Is(1) and not (vars.locationCode == TppDefine.LOCATION_ID.MTBS) then
						TppRadio.Play( "f2000_rtrg1910" , { delayTime = "long" } )
					end
				end
			},
		},
    }
end

function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
	if TppMission.IsFOBMission(vars.missionCode)  then
		return
	end
    Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText)
end

function this.OnMissionCanStart()
    InfCore.Log("Zoz Log: Zoz_Support_Radio_Overhaul.OnMissionCanStart()")
	if TppMission.IsFreeMission(vars.missionCode) then
		--[[
		function order_box_block.OnInitializeOrderBoxBlock( order_box_block, orderBoxList )
			local closestBox = nil
			local closestDist = nil
			mvars.zoz_HeadedToOrderBox = false
			
			for key, value in pairs(orderBoxList) do
				InfCore.Log("Zoz Log: Found order box = " .. value)
				
				local dist = this.CheckDistPlayerToLocator("OrderBoxIdentifier", value)
				if not closestDist or dist < closestDist then
					closestDist = dist
					closestBox = value
				end
			end
			if closestBox then
				InfCore.Log("Zoz Log: Closest box = " .. closestBox)
				InfCore.Log("Zoz Log: Closest box dist = " .. closestDist)
		
				if closestDist > 1500 then
					InfCore.Log("Zoz Log: Closest order box is too far!")
					TppRadio.Play("f1000_rtrg0490")
				else
					if mvars.Zoz_OnAmmoStackEmptythen then
						TppRadio.Play("f1000_rtrg0480")
					else
						TppRadio.Play("f1000_rtrg0500")
					end
				end
			else
				InfCore.Log("Zoz Log: No order boxes found.")
			end
		end
		]]
	end
end



function this.Init(missionTable)
	if TppMission.IsFOBMission(vars.missionCode) then
		return
	end
	InfCore.Log("Zoz Log: Zoz_Support_Radio_Overhaul.Init()")
	mvars.Zoz_Open_Door_Pilot_Radio = false
	this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

return this