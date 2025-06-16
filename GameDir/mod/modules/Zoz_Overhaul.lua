local this={}
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

this.registerMenus={
	"Zoz_Overhaul",

	"Zoz_Enemy_Overhaul",
	"Zoz_Enemy_Radio_Overhaul",
	"Zoz_Enemy_Voice_Overhaul",
	"Zoz_Enemy_Equipment_Overhaul",
	"Zoz_Enemy_Phase_Music_Overhaul",

	"Zoz_Idroid_Overhaul",
	"Zoz_Idroid_Overhaul_Notification",
	"Zoz_Idroid_Overhaul_Audio_Notification",

	"Zoz_Player_Overhaul",

	"Zoz_Support_Radio_Overhaul",
	"Zoz_Support_Radio_Overhaul_mtbs",
	"Zoz_Support_Radio_Overhaul_Pilot",
}

this.Zoz_Overhaul={
	parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
	options={
		"Zoz_Overhaul.Zoz_Idroid_Overhaul",
        "Zoz_Overhaul.Zoz_Support_Radio_Overhaul",
		"Zoz_Overhaul.Zoz_Enemy_Overhaul",
		"Zoz_Overhaul.Zoz_Player_Overhaul",
	}
}

this.Zoz_Enemy_Overhaul={
	options={
		"Zoz_Overhaul.Zoz_Enemy_Radio_Overhaul",
		"Zoz_Overhaul.Zoz_Enemy_Voice_Overhaul",
        "Zoz_Overhaul.Zoz_Enemy_Equipment_Overhaul",
        "Zoz_Overhaul.Zoz_Enemy_Phase_Music_Overhaul",
	}
}

this.Zoz_Idroid_Overhaul={
	options={
		"Zoz_Overhaul.Zoz_Idroid_Overhaul_Notification",
		"Zoz_Overhaul.Zoz_Idroid_Overhaul_Audio_Notification",
	}
}

this.Zoz_Support_Radio_Overhaul={
	options={
		"Zoz_Overhaul.Zoz_Support_Radio_Overhaul_mtbs",
		"Zoz_Overhaul.Zoz_Support_Radio_Overhaul_Pilot",
	}
}





this.Zoz_Enemy_Radio_Overhaul={
	options={
		"Zoz_Enemy_Radio_Overhaul.Zoz_Enemy_Radio_Report_Broken_Communication",
		"Zoz_Enemy_Radio_Overhaul.Zoz_Enemy_Radio_Extra_Camera_Lines",
		"Zoz_Enemy_Radio_Overhaul.Zoz_Enemy_Radio_Report_UAV_Down",
		"Zoz_Enemy_Radio_Overhaul.Zoz_Enemy_Radio_Repeat_Last",
		"Zoz_Enemy_Radio_Overhaul.Zoz_Enemy_Radio_Cancel_Prisoner_Search",
		"Zoz_Enemy_Radio_Overhaul.Zoz_Enemy_Radio_Report_Damage_From_Gunship",
		"Zoz_Enemy_Radio_Overhaul.Zoz_Enemy_Radio_Announce_Shift_Change",
	}
}

this.Zoz_Enemy_Voice_Overhaul={
	options={
		"Zoz_Enemy_Voice_Overhaul.Zoz_Enemy_Voice_Enemy_Reaction_Player_Vehicle",
        "Zoz_Enemy_Voice_Overhaul.Zoz_Enemy_Voice_Enemy_Reaction_Player_Aim",
        "Zoz_Enemy_Voice_Overhaul.Zoz_Enemy_Voice_Enemy_Reaction_Player_RPG",
        "Zoz_Enemy_Voice_Overhaul.Zoz_Enemy_Voice_Enemy_Player_Restrain",
        "Zoz_Enemy_Voice_Overhaul.Zoz_Enemy_Voice_Enemy_Surrender",
	}
}

this.Zoz_Enemy_Equipment_Overhaul={
	options={
		"Zoz_Enemy_Equipment_Overhaul .Zoz_Enemy_Equipment_Fulton",
        "Zoz_Enemy_Equipment_Overhaul .Zoz_Enemy_Equipment_Camera",
        "Zoz_Enemy_Equipment_Overhaul .Zoz_Enemy_Equipment_Ir_Sensors",
        "Zoz_Enemy_Equipment_Overhaul .Zoz_Enemy_Equipment_burglar_alarm",
	}
}

this.Zoz_Enemy_Phase_Music_Overhaul={
	options={
        "Zoz_Enemy_Overhaul.Zoz_BGM_Phase_Select",
        "Zoz_Enemy_Overhaul.Zoz_BGM_Select_Stop",
	}
}


this.Zoz_Support_Radio_Overhaul_mtbs={
	options={
		"Zoz_Support_Radio_Overhaul.Zoz_Support_Radio_mtbs_announce_OrderBox",
		"Zoz_Support_Radio_Overhaul.Zoz_Support_Radio_mtbs_announce_near_quest",
		"Zoz_Support_Radio_Overhaul.Zoz_Support_Radio_mtbs_announce_quest_complete",
		"Zoz_Support_Radio_Overhaul.Zoz_Support_Radio_mtbs_announce_FOB_Invasion",
	}
}
this.Zoz_Support_Radio_Overhaul_Pilot={
	options={
		"Zoz_Support_Radio_Overhaul.Zoz_Support_Radio_Pilot_React_Damage",
		"Zoz_Support_Radio_Overhaul.Zoz_Support_Radio_Pilot_Taxi_Radio",
		"Zoz_Support_Radio_Overhaul.Zoz_Support_Radio_Pilot_Abort_Radio",
		"Zoz_Support_Radio_Overhaul.Zoz_Support_Radio_Pilot_On_Landing",
	}
}

this.Zoz_Idroid_Overhaul_Notification={
	options={
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_enemyRecovered",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_destroy_APC",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_destroy_vehicle",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_destroy_truck",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_destroy_heli",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_destroy_AntiAirCraftGun",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_destroy_WatchTower",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_enemyIncrease",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_quiet_request",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_enemy_checkpoint",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_enemyReplacement",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_approach_border",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_announce_FOB_Alert",
	}
}

this.Zoz_Idroid_Overhaul_Audio_Notification={
	options={
		"Zoz_Idroid_Overhaul.Zoz_Idroid_Audio_Welcome_Acc",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_Audio_OpenStaffManagement",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_Audio_Prepare_Sortie",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_Audio_Friendly_Vehicle_Destroyed",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_Audio_Heli_Withdrawn",
		"Zoz_Idroid_Overhaul.Zoz_Idroid_Audio_OnRequested_AirStrike",
	}
}

this.Zoz_Player_Overhaul={
	options={
		"Zoz_Player_Overhaul.Zoz_Player_Overhaul_LOOK_QUIET",
		"Zoz_Player_Overhaul.Zoz_Player_Overhaul_Snake_Deploy_Line",
		"Zoz_Player_Overhaul.Zoz_Player_Overhaul_Snake_DD_Line",
		"Zoz_Player_Overhaul.Zoz_Player_Overhaul_Ocelot_Interaction",
		--"Zoz_Player_Overhaul.Zoz_Player_Overhaul_Player_FOB_respawn",
	}
}


this.langStrings={
	eng={
		Zoz_Overhaul="Zoz Overhaul",
		Zoz_Enemy_Overhaul = "Enemy Overhaul",
        Zoz_Enemy_Radio_Overhaul = "Enemy Radio",
        Zoz_Enemy_Voice_Overhaul = "Enemy Voice",
		Zoz_Enemy_Equipment_Overhaul = "Enemy Equipment",
		Zoz_Enemy_Phase_Music_Overhaul = "Enemy Phase BGM menu",

		Zoz_Idroid_Overhaul = "Idroid Overhaul",
		Zoz_Idroid_Overhaul_Notification = "Idroid Notifications",
		Zoz_Idroid_Overhaul_Audio_Notification = "Idroid Audio Notifications",

		Zoz_Player_Overhaul = "Player OverHaul",

		Zoz_Support_Radio_Overhaul = "Support Radio Overhaul",
		Zoz_Support_Radio_Overhaul_mtbs = "Support Radio",


		Zoz_Support_Radio_Overhaul_Pilot = "Pequod Radio",
		Zoz_Support_Radio_Pilot_React_Damage = "Reaction to damage",
		Zoz_Support_Radio_Pilot_Taxi_Radio = "On MotherBase Taxi",
		Zoz_Support_Radio_Pilot_Abort_Radio = "On aborting mission",
		Zoz_Support_Radio_Pilot_On_Landing = "On Landing",
	},
	help={
		eng={
			Zoz_Overhaul="Toggle individual options for zoz overhaul mod.",

			Zoz_Enemy_Overhaul = "Toggle individual options for Enemy Overhaul",
            Zoz_Enemy_Radio_Overhaul = "Toggle individual options for Enemy Radio",
			Zoz_Enemy_Voice_Overhaul = "Toggle individual options for Enemy Voice.",
			Zoz_Enemy_Equipment_Overhaul = "Toggle individual options for Enemy Equipment",
			Zoz_Enemy_Phase_Music_Overhaul = "Toggle individual options for Phase music!",

			Zoz_Idroid_Overhaul = "Toggle individual options for Idroid.",

			Zoz_Player_Overhaul = "Toggle individual options for Player OverHaul",

			Zoz_Support_Radio_Overhaul = "Toggle individual options for Support Radio",
			Zoz_Support_Radio_Overhaul_mtbs = "Toggle individual options for miller and ocelot Support Radio.",
			Zoz_Support_Radio_Overhaul_Pilot = "Toggle individual options for Pequod.",
		},
	},
}




function this.AddMissionPacks(missionCode,packPaths)
	if InfMain.IsOnlineMission(missionCode) or missionCode < 5 or (vars.locationCode == TppDefine.LOCATION_ID.GNTN) then
		return
	end

	packPaths[#packPaths + 1] = "/Assets/tpp/pack/zoz/Zoz_Overhaul.fpk"
end

function this.IsNotPhase(phase)
	if vars.playerPhase ~= phase then
	  return true
	else
	  return false
	end
end

function this.GetCpSubType(t)
	if mvars.ene_soldierIDList then
	  local n=mvars.ene_soldierIDList[t]
	  if n~=nil then
		for n,t in pairs(n)do
		  return this.GetSoldierSubType(n)
		end
	  end
	end
	if mvars.ene_cpList then
	  local n=mvars.ene_cpList[t]
	  local e=this.subTypeOfCp[n]
	  if e~=nil then
		return e
	  end
	end
	return this.GetSoldierSubType(nil)
end
function this.GetSoldierSubType(n,e)
	local e=nil
	if mvars.ene_soldierSubType then
	  e=mvars.ene_soldierSubType[n]
	end
	return e
end


this.getClosestCp = function()
	local x,y,z=vars.playerPosX,vars.playerPosY,vars.playerPosZ
	local closestCp= InfMain.GetClosestCp{x,y,z}
	local cp = GameObject.GetGameObjectId( closestCp )
	return cp
end

this.getClosestCpString = function()
	local x,y,z=vars.playerPosX,vars.playerPosY,vars.playerPosZ
	local closestCp= InfMain.GetClosestCp{x,y,z}
	local cp = tostring(closestCp)
	return cp
end

return this