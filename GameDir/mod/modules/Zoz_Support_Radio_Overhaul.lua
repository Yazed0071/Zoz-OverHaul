local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.registerIvars={
	"Zoz_Support_Radio_mtbs_announce_OrderBox",
	"Zoz_Support_Radio_mtbs_announce_near_quest",
	"Zoz_Support_Radio_mtbs_announce_quest_complete",
	"Zoz_Support_Radio_mtbs_announce_FOB_Invasion",

	"Zoz_Support_Radio_Pilot_React_Damage",
	"Zoz_Support_Radio_Pilot_Taxi_Radio",
	"Zoz_Support_Radio_Pilot_Abort_Radio",
	"Zoz_Support_Radio_Pilot_On_Landing",
}

this.langStrings={
	eng={
		Zoz_Support_Radio_mtbs_announce_OrderBox = "When an Order Box appears",
		Zoz_Support_Radio_mtbs_announce_near_quest = "When in side op area",
		Zoz_Support_Radio_mtbs_announce_quest_complete ="When side op completed",
		Zoz_Support_Radio_mtbs_announce_FOB_Invasion = "When FOB invaded",


		Zoz_Support_Radio_Pilot_React_Damage = "Reaction to damage",
		Zoz_Support_Radio_Pilot_Taxi_Radio = "On MotherBase Taxi",
		Zoz_Support_Radio_Pilot_Abort_Radio = "On aborting mission",
		Zoz_Support_Radio_Pilot_On_Landing = "On Landing",
	},
	help={
		eng={
			Zoz_Support_Radio_mtbs_announce_OrderBox = "When accepting a mission in free room",
			Zoz_Support_Radio_mtbs_announce_near_quest = "When in a side op area (it's radius)",
			Zoz_Support_Radio_mtbs_announce_quest_complete ="When side op completed",
			Zoz_Support_Radio_mtbs_announce_FOB_Invasion = "When FOB invaded or a supported FOB is also invaded",

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
    local showAnnounceLog = TppUI.ShowAnnounceLog
    TppUI.ShowAnnounceLog = function(announceId,param1,param2,delayTime,missionSubGoalNumber) -- value if announceId comes from TppUi.ANNOUNCE_LOG_TYPE
		showAnnounceLog(announceId,param1,param2,delayTime,missionSubGoalNumber)
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
				sender = "SupportHeli",
				func = function (damagedId, attackId, attackerId, damageMessageFlag)
					if not GkEventTimerManager.IsTimerActive("zoz_Heli_Damage_Announce_cooldown") and Ivars.Zoz_Support_Radio_Pilot_React_Damage:Is(1) then -- 7168 support heli, 
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
				sender = "SupportHeli",
				func = function (arg0)
					mvars.Zoz_Open_Door_Pilot_Radio = false
					if mvars.HeliAskAbort == true and Ivars.Zoz_Support_Radio_Pilot_Abort_Radio:Is(1) then
						if Tpp.IsNotAlert() then
							TppRadio.Play("support_heli_abort_normal", { delayTime = "long" })
						else
							TppRadio.Play("support_heli_abort_alert", { delayTime = "long" })
						end
					end
				end
			},
			{
				msg = "StartedMoveToLandingZone",
				sender = "SupportHeli",
				func = function (gameId, landingZone)
					
					mvars.Zoz_Open_Door_Pilot_Radio = false
					if 
						landingZone == StrCode32("lz_cliffTown_I0000|lz_cliffTown_I_0000")
						or landingZone == StrCode32("lz_commFacility_I0000|lz_commFacility_I_0000")
						or landingZone == StrCode32("lz_enemyBase_I0000|lz_enemyBase_I_0000")
						or landingZone == StrCode32("lz_field_I0000|lz_field_I_0000")
						or landingZone == StrCode32("lz_fort_I0000|lz_fort_I_0000")
						or landingZone == StrCode32("lz_remnants_I0000|lz_remnants_I_0000")
						or landingZone == StrCode32("lz_slopedTown_I0000|lz_slopedTown_I_0000")
						or landingZone == StrCode32("lz_tent_I0000|lz_tent_I_0000")
						or landingZone == StrCode32("lz_waterway_I0000|lz_waterway_I_0000")
						or landingZone == StrCode32("lz_banana_I0000|lz_banana_I_0000")
						or landingZone == StrCode32("lz_diamond_I0000|lz_diamond_I_0000")
						or landingZone == StrCode32("lz_flowStation_I0000|lz_flowStation_I_0000")
						or landingZone == StrCode32("lz_hill_I0000|lz_hill_I_0000")
						or landingZone == StrCode32("lz_pfCamp_I0000|lz_pfCamp_I_0000")
						or landingZone == StrCode32("lz_savannah_I0000|lz_savannah_I_0000")
						or landingZone == StrCode32("lz_swamp_I0000|lz_swamp_I_0000")
					then
						TppRadio.Play("f1000_rtrg0070")
					else
						if math.random(0,1) == 0 then
						else
							TppRadio.Play("f1000_rtrg1810")
						end
					end

				end
			},
			{
				msg = "LostControl",
				sender = "SupportHeli",
				func = function( heliId, sequenceName, attackerId )
					if sequenceName == StrCode32("End") then
						if mvars.Zoz_SupportHeli_LostControl == nil then
							mvars.Zoz_SupportHeli_LostControl = 0
						elseif mvars.Zoz_SupportHeli_LostControl == 0 then
							mvars.Zoz_SupportHeli_LostControl = mvars.Zoz_SupportHeli_LostControl + 1
							TppRadio.Play("f1000_rtrg1910")
						elseif mvars.Zoz_SupportHeli_LostControl == 1 then
							mvars.Zoz_SupportHeli_LostControl = mvars.Zoz_SupportHeli_LostControl + 1
							TppRadio.Play("f1000_rtrg1920")
						elseif mvars.Zoz_SupportHeli_LostControl > 1 then
							TppRadio.Play("f1000_rtrg1930")
						end
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
			{
				msg = "Finish",
				sender = "zoz_player_looking_at_Sky_OnUpdate",
				func = function ()
					if vars.weather==TppDefine.WEATHER.SUNNY then
						GkEventTimerManager.Start("zoz_player_looking_at_Sky_OnUpdate", 1)
						if TppClock.GetTimeOfDay() == "night" then
							if this.isPlayerLookingAtMoon() then
								if math.random(0,1) == 0 then
									TppRadio.ChangeIntelRadio( {zoz_intel_sky = "f2000_esrg0010"} )
								else
									TppRadio.ChangeIntelRadio( {zoz_intel_sky = "f2000_esrg0020"} )
								end
							elseif this.isPlayerLookingAtSouthernStar() then
								TppRadio.ChangeIntelRadio( {zoz_intel_sky = "f2000_esrg0030"} )
							elseif this.isPlayerLookingAtBigDipper() then
								TppRadio.ChangeIntelRadio( {zoz_intel_sky = "f2000_esrg0040"} )
							else
								TppRadio.ChangeIntelRadio( {zoz_intel_sky = "Invalid"} )
							end
						else
							if this.isPlayerLookingAtSun() then
								TppRadio.ChangeIntelRadio( {zoz_intel_sky = "f2000_esrg0050"} )
							else
								TppRadio.ChangeIntelRadio( {zoz_intel_sky = "Invalid"} )
							end
						end
					else
						TppRadio.ChangeIntelRadio( {zoz_intel_sky = "Invalid"} )
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
			},
			{
				msg = "Start",
				func = function (arg0, unk1)
					local time = TppClock.GetTime("string")
					InfCore.Log("Zoz Log: 1.1 Sun Angle at time: " .. time .. " is Player's current rotX: " .. vars.playerCameraRotation[0] .." rotY: " .. vars.playerCameraRotation[1])
        			--InfCore.Log("Zoz Log: 1.1 Current Big Dipper rot based on time: " .. time .. " is rotX: " .. moonRotX .. " rotY: " .. moonRotY)
				end
			},
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
			{
				msg = "OnBinocularsMode",
				func = function (playerIndex)
					GkEventTimerManager.Start("zoz_player_looking_at_Sky_OnUpdate", 1)
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

function this.isPlayerLookingAtMoon()
	local playerRotX = vars.playerCameraRotation[0]
	local playerRotY = vars.playerCameraRotation[1]
	local hour, minute, second = TppClock.GetTime("time")
	local moonRotX, moonRotY = this.getMoonRotation(hour, minute, second)

	local dx = math.abs(playerRotX - moonRotX)
	local dy = math.abs(playerRotY - moonRotY)
	return dx <= 5.0 and dy <= 5.0 -- talorance
end

function this.isPlayerLookingAtBigDipper()
	local playerRotX = vars.playerCameraRotation[0]
	local playerRotY = vars.playerCameraRotation[1]
	local hour, minute, second = TppClock.GetTime("time")
	local dipperRotX, dipperRotY = this.getBigDipperRotation(hour, minute, second)

	local dx = math.abs(playerRotX - dipperRotX)
	local dy = math.abs(playerRotY - dipperRotY)
	return dx <= 8.0 and dy <= 10.0

end


function this.getBigDipperRotation(hour, minute, second)
    local bigDipperData = {
        ["18:42"] = { rotX = -6.9085721969604,  rotY = 148.17375183105 },
        ["19:00"] = { rotX = -8.9854412078857,  rotY = 149.23345947266 },
        ["20:00"] = { rotX = -12.249096870422,  rotY = 147.99320983887 },
        ["21:00"] = { rotX = -20.365287780762,  rotY = 153.66854858398 },
        ["22:00"] = { rotX = -26.342384338379,  rotY = 159.51071166992 },
        ["23:00"] = { rotX = -30.509784698486,  rotY = 166.73170471191 },
        ["00:00"] = { rotX = -33.047172546387,  rotY = 176.4246673584 },
        ["01:00"] = { rotX = -32.550998687744,  rotY = -173.99708557129 },
        ["02:00"] = { rotX = -29.863538742065,  rotY = -164.57972717285 },
        ["03:00"] = { rotX = -25.297010421753,  rotY = -157.5059967041 },
        ["04:00"] = { rotX = -18.294591903687,  rotY = -151.71820068359 },
        ["05:00"] = { rotX = -10.21568107605,   rotY = -148.45471191406 },
        ["05:39"] = { rotX = -9.5811433792114,  rotY = -147.26655578613 }
    }

    local function timeToSeconds(h, m)
        return h * 3600 + m * 60
    end

    local function interpolate(a, b, t)
        return a + (b - a) * t
    end

    local currentTimeSec = timeToSeconds(hour, minute) + second

    -- Convert all time keys to seconds
    local keys = {}
    for timeStr, _ in pairs(bigDipperData) do
        local h, m = timeStr:match("^(%d+):(%d+)$")
        local timeSec = timeToSeconds(tonumber(h), tonumber(m))
        table.insert(keys, { key = timeStr, sec = timeSec })
    end

    table.sort(keys, function(a, b) return a.sec < b.sec end)

    for i = 1, #keys - 1 do
        local t1 = keys[i]
        local t2 = keys[i + 1]
        if currentTimeSec >= t1.sec and currentTimeSec <= t2.sec then
            local frac = (currentTimeSec - t1.sec) / (t2.sec - t1.sec)
            local rot1 = bigDipperData[t1.key]
            local rot2 = bigDipperData[t2.key]
            local rotX = interpolate(rot1.rotX, rot2.rotX, frac)
            local rotY = interpolate(rot1.rotY, rot2.rotY, frac)
            return rotX, rotY
        end
    end

    -- Clamp to bounds if outside range
    if currentTimeSec < keys[1].sec then
        local d = bigDipperData[keys[1].key]
        return d.rotX, d.rotY
    elseif currentTimeSec > keys[#keys].sec then
        local d = bigDipperData[keys[#keys].key]
        return d.rotX, d.rotY
    end

end

function this.isPlayerLookingAtSouthernStar()
	local playerRotX = vars.playerCameraRotation[0]
	local playerRotY = vars.playerCameraRotation[1]
	local hour, minute, second = TppClock.GetTime("time")
	local starRotX, starRotY = this.getSouthernStarRotation(hour, minute, second)

	local dx = math.abs(playerRotX - starRotX)
	local dy = math.abs(playerRotY - starRotY)
	return dx <= 5.0 and dy <= 5.0
end

function this.getSouthernStarRotation(hour, minute, second)
    local southernStarData = {
        ["19:10"] = { rotX = -3.2641334533691,  rotY = 29.337450027466 },
        ["20:00"] = { rotX = -9.2431716918945,  rotY = 27.936141967773 },
        ["21:00"] = { rotX = -16.008527755737,  rotY = 24.908044815063 },
        ["22:00"] = { rotX = -22.05818939209,   rotY = 20.305973052979 },
        ["23:00"] = { rotX = -26.007719039917,  rotY = 13.721521377563 },
        ["00:00"] = { rotX = -28.976842880249,  rotY = 6.2573952674866 },
        ["01:00"] = { rotX = -29.719203948975,  rotY = -2.0490293502808 },
        ["02:00"] = { rotX = -28.203830718994,  rotY = -10.49315071106 },
        ["03:00"] = { rotX = -24.188280105591,  rotY = -17.918357849121 },
        ["04:00"] = { rotX = -19.051404953003,  rotY = -23.180116653442 },
        ["05:00"] = { rotX = -12.741689682007,  rotY = -27.022262573242 },
        ["05:39"] = { rotX = -8.1011505126953,  rotY = -28.659158706665 }
    }

    local function timeToSeconds(h, m)
        return h * 3600 + m * 60
    end

    local function interpolate(a, b, t)
        return a + (b - a) * t
    end

    local currentTimeSec = timeToSeconds(hour, minute) + second

    local keys = {}
    for timeStr, _ in pairs(southernStarData) do
        local h, m = timeStr:match("^(%d+):(%d+)$")
        local timeSec = timeToSeconds(tonumber(h), tonumber(m))
        table.insert(keys, { key = timeStr, sec = timeSec })
    end

    table.sort(keys, function(a, b) return a.sec < b.sec end)

    for i = 1, #keys - 1 do
        local t1 = keys[i]
        local t2 = keys[i + 1]
        if currentTimeSec >= t1.sec and currentTimeSec <= t2.sec then
            local frac = (currentTimeSec - t1.sec) / (t2.sec - t1.sec)
            local r1 = southernStarData[t1.key]
            local r2 = southernStarData[t2.key]
            local rotX = interpolate(r1.rotX, r2.rotX, frac)
            local rotY = interpolate(r1.rotY, r2.rotY, frac)
            return rotX, rotY
        end
    end

    -- Clamp to edge values if time is out of range
    if currentTimeSec < keys[1].sec then
        local d = southernStarData[keys[1].key]
        return d.rotX, d.rotY
    elseif currentTimeSec > keys[#keys].sec then
        local d = southernStarData[keys[#keys].key]
        return d.rotX, d.rotY
    end

end

function this.getMoonRotation(hour, minute, second)
    local moonData = {
        ["18:45"] = { rotX = -10.112244606018, rotY = 133.80073547363 },
        ["19:00"] = { rotX = -13.205896377563, rotY = 131.48655700684 },
        ["20:00"] = { rotX = -25.182399749756, rotY = 121.95249176025 },
        ["21:00"] = { rotX = -36.597461700439, rotY = 110.71015930176 },
        ["22:00"] = { rotX = -47.002696990967, rotY = 96.152732849121 },
        ["23:00"] = { rotX = -54.979316711426, rotY = 75.94652557373 },
        ["00:00"] = { rotX = -59.013034820557, rotY = 49.493663787842 },
        ["01:00"] = { rotX = -56.964824676514, rotY = 21.29271697998 },
        ["02:00"] = { rotX = -49.897331237793, rotY = -0.94521617889404 },
        ["03:00"] = { rotX = -40.09920501709, rotY = -17.050487518311 },
        ["04:00"] = { rotX = -28.894006729126, rotY = -29.034572601318 },
        ["05:00"] = { rotX = -17.044258117676, rotY = -38.909687042236 },
        ["05:30"] = { rotX = -10.984118461609, rotY = -43.455749511719 }
    }

    local function timeToSeconds(h, m, s)
        return h * 3600 + m * 60 + s
    end

    local function interpolate(a, b, t)
        return a + (b - a) * t
    end

    -- Convert all time keys to seconds
    local keysInSec = {}
    for k, _ in pairs(moonData) do
        local h, m = k:match("^(%d+):(%d+)$")
        local totalSec = timeToSeconds(tonumber(h), tonumber(m), 0)
        table.insert(keysInSec, { key = k, sec = totalSec })
    end

    table.sort(keysInSec, function(a, b) return a.sec < b.sec end)

    local currentSec = timeToSeconds(hour, minute, second)

    -- Handle wrap-around past midnight (e.g., 23:00 -> 00:00)
    for i = 1, #keysInSec - 1 do
        local t1 = keysInSec[i]
        local t2 = keysInSec[i + 1]
        if currentSec >= t1.sec and currentSec <= t2.sec then
            local frac = (currentSec - t1.sec) / (t2.sec - t1.sec)
            local d1 = moonData[t1.key]
            local d2 = moonData[t2.key]
            local rotX = interpolate(d1.rotX, d2.rotX, frac)
            local rotY = interpolate(d1.rotY, d2.rotY, frac)
            return rotX, rotY
        end
    end

    -- If current time is before first or after last point, clamp or wrap
    local first = keysInSec[1]
    local last = keysInSec[#keysInSec]
    if currentSec < first.sec then
        return moonData[first.key].rotX, moonData[first.key].rotY
    elseif currentSec > last.sec then
        return moonData[last.key].rotX, moonData[last.key].rotY
    end
end

function this.getSunRotation(hour, minute, second)
    local sunData = {
        ["07:10"] = { rotX = -9.0634145736694,  rotY = 121.69772338867 },
        ["08:00"] = { rotX = -18.756258010864,  rotY = 113.59075164795 },
        ["09:00"] = { rotX = -29.459711074829,  rotY = 102.20551300049 },
        ["10:00"] = { rotX = -38.819499969482,  rotY = 88.054695129395 },
        ["11:00"] = { rotX = -45.616630554199,  rotY = 69.976936340332 },
        ["12:00"] = { rotX = -48.610084533691,  rotY = 48.436325073242 },
        ["13:00"] = { rotX = -47.004390716553,  rotY = 26.222829818726 },
        ["14:00"] = { rotX = -41.277549743652,  rotY = 6.9682269096375 },
        ["15:00"] = { rotX = -32.593154907227,  rotY = -8.3259048461914 },
        ["16:00"] = { rotX = -22.147037506104,  rotY = -20.398700714111 },
        ["17:00"] = { rotX = -10.804758071899,  rotY = -30.518253326416 },
        ["17:20"] = { rotX = -6.8329071998596,  rotY = -33.577178955078 }
    }

    local function timeToSeconds(h, m)
        return h * 3600 + m * 60
    end

    local function interpolate(a, b, t)
        return a + (b - a) * t
    end

    local currentTimeSec = timeToSeconds(hour, minute) + second

    local keys = {}
    for timeStr, _ in pairs(sunData) do
        local h, m = timeStr:match("^(%d+):(%d+)$")
        local timeSec = timeToSeconds(tonumber(h), tonumber(m))
        table.insert(keys, { key = timeStr, sec = timeSec })
    end

    table.sort(keys, function(a, b) return a.sec < b.sec end)

    for i = 1, #keys - 1 do
        local t1 = keys[i]
        local t2 = keys[i + 1]
        if currentTimeSec >= t1.sec and currentTimeSec <= t2.sec then
            local frac = (currentTimeSec - t1.sec) / (t2.sec - t1.sec)
            local r1 = sunData[t1.key]
            local r2 = sunData[t2.key]
            local rotX = interpolate(r1.rotX, r2.rotX, frac)
            local rotY = interpolate(r1.rotY, r2.rotY, frac)
            return rotX, rotY
        end
    end

    -- Clamp to nearest bounds
    if currentTimeSec < keys[1].sec then
        local d = sunData[keys[1].key]
        return d.rotX, d.rotY
    elseif currentTimeSec > keys[#keys].sec then
        local d = sunData[keys[#keys].key]
        return d.rotX, d.rotY
    end

end

function this.isPlayerLookingAtSun()
	local playerRotX = vars.playerCameraRotation[0]
	local playerRotY = vars.playerCameraRotation[1]
	local hour, minute, second = TppClock.GetTime("time")
	local sunRotX, sunRotY = this.getSunRotation(hour, minute, second)

	local dx = math.abs(playerRotX - sunRotX)
	local dy = math.abs(playerRotY - sunRotY)
	return dx <= 5.0 and dy <= 5.0
end



function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
	if TppMission.IsFOBMission(vars.missionCode)  then
		return
	end
    Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText)
end

--function this.OnMissionCanStart()
--    InfCore.Log("Zoz Log: Zoz_Support_Radio_Overhaul.OnMissionCanStart()")
--	if TppMission.IsFreeMission(vars.missionCode) then
--		--[[
--		function order_box_block.OnInitializeOrderBoxBlock( order_box_block, orderBoxList )
--			local closestBox = nil
--			local closestDist = nil
--			mvars.zoz_HeadedToOrderBox = false
--			
--			for key, value in pairs(orderBoxList) do
--				InfCore.Log("Zoz Log: Found order box = " .. value)
--				
--				local dist = this.CheckDistPlayerToLocator("OrderBoxIdentifier", value)
--				if not closestDist or dist < closestDist then
--					closestDist = dist
--					closestBox = value
--				end
--			end
--			if closestBox then
--				InfCore.Log("Zoz Log: Closest box = " .. closestBox)
--				InfCore.Log("Zoz Log: Closest box dist = " .. closestDist)
--		
--				if closestDist > 1500 then
--					InfCore.Log("Zoz Log: Closest order box is too far!")
--					TppRadio.Play("f1000_rtrg0490")
--				else
--					if mvars.Zoz_OnAmmoStackEmptythen then
--						TppRadio.Play("f1000_rtrg0480")
--					else
--						TppRadio.Play("f1000_rtrg0500")
--					end
--				end
--			else
--				InfCore.Log("Zoz Log: No order boxes found.")
--			end
--		end
--		]]
--	end
--end



function this.Init(missionTable)
	if TppMission.IsFOBMission(vars.missionCode) then
		return
	end
	InfCore.Log("Zoz Log: Zoz_Support_Radio_Overhaul.Init()")
	mvars.Zoz_Open_Door_Pilot_Radio = false
	this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

return this