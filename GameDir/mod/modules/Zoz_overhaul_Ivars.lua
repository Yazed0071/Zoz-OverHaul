local this={}

this.registerMenus={
	"Zoz_Overhaul",
}

this.Zoz_Overhaul={
	parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
	options={
		"Zoz_Idroid_Overhaul.Zoz_Idroid_Overhaul",
        "Zoz_Support_Radio_Overhaul.Zoz_Support_Radio_Overhaul",
		"Zoz_Enemy_Overhaul.Zoz_Enemy_Overhaul",
	}
}

this.langStrings={
	eng={
		Zoz_Overhaul="Zoz Overhaul",
	},
	help={
		eng={
			Zoz_Overhaul="Toggle individual options for zoz overhaul mod.",
		},
	},
}

this.MISSION_PACKS = {
	[10020] ={ "/Assets/tpp/pack/zoz/s10020_custom_pack.fpk"}, -- PHANTOM LIMBS
	[10036] ={ "/Assets/tpp/pack/zoz/s10036_custom_pack.fpk"}, -- A HERO’S WAY
	[10043] ={ "/Assets/tpp/pack/zoz/s10043_custom_pack.fpk"}, -- C2W
	[10033] ={ "/Assets/tpp/pack/zoz/s10033_custom_pack.fpk"}, -- OVER THE FENCE
	[10040] ={ "/Assets/tpp/pack/zoz/s10040_custom_pack.fpk"}, -- WHERE DO THE BEES SLEEP?
	[10041] ={ "/Assets/tpp/pack/zoz/s10041_custom_pack.fpk"}, -- RED BRASS
	[10052] ={ "/Assets/tpp/pack/zoz/s10052_custom_pack.fpk"}, -- ANGEL WITH BROKEN WINGS
	[10070] ={ "/Assets/tpp/pack/zoz/s10070_custom_pack.fpk"}, -- HELLBOUND
	[10080] ={ "/Assets/tpp/pack/zoz/s10080_custom_pack.fpk"}, -- PITCH DARK
	[10090] ={ "/Assets/tpp/pack/zoz/s10090_custom_pack.fpk"}, -- TRAITORS’ CARAVAN
	[10130] ={ "/Assets/tpp/pack/zoz/s10130_custom_pack.fpk"}, -- CODE TALKER
	[10045] ={ "/Assets/tpp/pack/zoz/s10045_custom_pack.fpk"}, -- TO KNOW TOO MUCH
	[10093] ={ "/Assets/tpp/pack/zoz/s10093_custom_pack.fpk"}, -- CURSED LEGACY
}

this.SECURITY_LIST = {
	CCTVList = {
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
			name = "Camera_Field_0",
			cp = "afgh_field_cp",
		},
		{
			name = "Camera_Field_1",
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
			name = "Camera_fort_0",
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
	},
}

function this.SetupCamera()
    -- Configuration table for revenge level settings
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

    -- Set command posts for each CCTV camera
    for _, camInfo in ipairs(this.SECURITY_LIST.CCTVList) do
        local gameObjectId = GameObject.GetGameObjectId(camInfo.name)
        if gameObjectId ~= GameObject.NULL_ID then
            GameObject.SendCommand(gameObjectId, {id = "SetCommandPost", cp = camInfo.cp})
        end
    end

    -- Apply security camera settings based on revenge level
    local revengeLevel = TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.STEALTH)
    if revengeLevel >= 1 and revengeLevel <= 5 then
        local commands = revengeConfig[revengeLevel]
        if commands then
            local securityCameras = {type = "TppSecurityCamera2"}
            for _, command in ipairs(commands) do
                GameObject.SendCommand(securityCameras, command)
            end
        end
    end
end

this.SetUpEnemy = function ()
	this.SetupCamera()
end

function this.AddMissionPacks(missionCode,packPaths)
	if InfMain.IsOnlineMission(missionCode) or missionCode < 5 or (vars.locationCode == TppDefine.LOCATION_ID.GNTN) then
		return
	end

	packPaths[#packPaths + 1] = "/Assets/tpp/pack/zoz/Zoz_Overhaul.fpk"

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

	if TppMission.IsHardMission(missionCode)then
	  missionCode=TppMission.GetNormalMissionCodeFromHardMission(missionCode)
	end
	if not Ivars.Zoz_Enemy_Equipment_Camera:Is"OFF" then
		if this.MISSION_PACKS[missionCode] then
			packPaths[#packPaths + 1] = "/Assets/tpp/pack/zoz/mis_common_zoz_cctv.fpk"
			for _, packPath in ipairs(this.MISSION_PACKS[missionCode]) do
			  	packPaths[#packPaths + 1] = packPath
			end
		end
	end
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