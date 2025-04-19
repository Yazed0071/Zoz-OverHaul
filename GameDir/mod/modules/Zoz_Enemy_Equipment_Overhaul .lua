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

function this.OnAllocate()
end
function this.OnInitialize()
end



function this.OnMissionCanStart()
    InfCore.Log("Zoz Log: Zoz_Enemy_Equipment_Overhaul.OnMissionCanStart()")
	local missionCode = TppMission.GetMissionID()
    if TppMission.IsHardMission(missionCode) then
        missionCode = TppMission.GetNormalMissionCodeFromHardMission(missionCode)
    end
    if not this.MISSION_PACKS.UAVs[missionCode] then
        return
    end
	if this.SECURITY_LIST.UAVs[missionCode] then
        InfCore.Log("Zoz Log: UAV info: ")
        for _, uavInfo in ipairs(this.SECURITY_LIST.UAVs[missionCode]) do
			local gameId = GetGameObjectId(uavInfo.name)
			TppMarker2System.DisableMarker{gameObjectId=gameId}
			TppMarker2System.SetMarkerImportant{gameObjectId=gameId ,isImportant=false}
        end
    end
end

function this.RequestNoticeGimmick(cp, gimmickId, sourceId)
    local command = {id = "RequestNotice", type = 0, targetId = gimmickId, sourceId = sourceId}
    SendCommand(cp, command)
end

this.IsAirGun = function(gameObjectId)
    if gameObjectId == nil then
        return
    end
    if gameObjectId == NULL_ID then
        return
    end
    local gameObjectType = GameObject.GetTypeIndex(gameObjectId)
    return gameObjectType == TppGameObject.GAME_OBJECT_TYPE_GATLINGGUN
end

this.IsMortar = function(gameObjectId)
    if gameObjectId == nil then
        return
    end
    if gameObjectId == NULL_ID then
        return
    end
    local gameObjectType = GameObject.GetTypeIndex(gameObjectId)
    return gameObjectType == TppGameObject.GAME_OBJECT_TYPE_MORTAR
end
this.IsMachineGun = function(gameObjectId)
    if gameObjectId == nil then
        return
    end
    if gameObjectId == NULL_ID then
        return
    end
    local gameObjectType = GameObject.GetTypeIndex(gameObjectId)
    return gameObjectType == TppGameObject.GAME_OBJECT_TYPE_MACHINEGUN
end

this.zoz_afgh_gimmickIdentifierParamTableExtra={
	afgh_zoz_village_Generator = {
		type = TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,
		locatorName = "zoz_afgh_gnrt002_gim_n0000|srt_afgh_gnrt002",
		dataSetName = "/Assets/tpp/level/location/afgh/block_large/village/zoz_village_asset.fox2",
		gimmickType = TppGimmick.GIMMICK_TYPE.GNRT,
		blockLarge  = "afgh_village",
	},
}

this.zoz_afgh_gimmickPowerCutConnectTableExtra = {
	afgh_zoz_village_Generator = {
		powerCutAreaName = "zoz_PowerCutArea_village1",
		cpName = "afgh_village_cp",
	},
}

this.MISSION_PACKS = {
    CCTV = {
        [10020] = {
            -- PHANTOM LIMBS
            "/Assets/tpp/pack/zoz/zoz_SlopedTown_Cameras_custom.fpk",
            "/Assets/tpp/pack/zoz/zoz_Village_Cameras_custom.fpk"
        },
        [10033] = {
            -- OVER THE FENCE
            "/Assets/tpp/pack/zoz/zoz_enemyBase_Cameras_custom.fpk"
        },
        [10036] = {
            -- A HERO’S WAY
            "/Assets/tpp/pack/zoz/zoz_Field_Cameras_custom.fpk"
        },
        [10040] = {
            -- WHERE DO THE BEES SLEEP?
            "/Assets/tpp/pack/zoz/zoz_fort_Cameras_custom.fpk"
        },
        [10041] = {
            -- RED BRASS
            "/Assets/tpp/pack/zoz/zoz_Village_Cameras_custom.fpk",
            "/Assets/tpp/pack/zoz/zoz_enemyBase_Cameras_custom.fpk"
        },
        [10043] = {
            -- C2W
            "/Assets/tpp/pack/zoz/zoz_Village_Cameras_custom.fpk",
            "/Assets/tpp/pack/zoz/zoz_commFacility_Cameras_custom.fpk"
        },
        [10044] = {
            -- OCCUPATION FORCES
            "/Assets/tpp/pack/zoz/zoz_fort_Cameras_custom.fpk"
        },
        [10045] = {
            -- TO KNOW TOO MUCH
            "/Assets/tpp/pack/zoz/zoz_Field_Cameras_custom.fpk"
        },
        [10052] = {
            -- ANGEL WITH BROKEN WINGS
            "/Assets/tpp/pack/zoz/zoz_Tent_Cameras_custom.fpk",
            "/Assets/tpp/pack/zoz/zoz_Remenants_Cameras_custom.fpk"
        },
        [10070] = {
            -- HELLBOUND
            "/Assets/tpp/pack/zoz/zoz_powerPlant_Cameras_custom.fpk",
            "/Assets/tpp/pack/zoz/zoz_sovietBase_Cameras_custom.fpk"
        },
        [10080] = {
            -- PITCH DARK
            "/Assets/tpp/pack/zoz/zoz_flowStation_Cameras_custom.fpk"
        },
        [10090] = {
            -- TRAITORS’ CARAVAN
            "/Assets/tpp/pack/zoz/zoz_flowStation_Cameras_custom.fpk",
            "/Assets/tpp/pack/zoz/zoz_pfCamp_Cameras_custom.fpk"
        },
        [10093] = {
            -- CURSED LEGACY
            "/Assets/tpp/pack/zoz/zoz_lab_Cameras_custom.fpk"
        },
        [10130] = {
            -- CODE TALKER
            "/Assets/tpp/pack/zoz/zoz_lab_Cameras_custom.fpk"
        }
    },
    UAVs = {
        [10033] = {
            -- OVER THE FENCE
            "/Assets/tpp/pack/zoz/zoz_afgh_uav_enemyBase.fpk"
        },
        [10040] = {
            -- WHERE DO THE BEES SLEEP?
            "/Assets/tpp/pack/zoz/zoz_afgh_uav_bridge.fpk",
            "/Assets/tpp/pack/zoz/zoz_afgh_uav_fort.fpk"
        },
        [10041] = {
            -- RED BRASS
            "/Assets/tpp/pack/zoz/zoz_afgh_uav_enemyBase.fpk"
        },
        [10044] = {
            -- OCCUPATION FORCES
            "/Assets/tpp/pack/zoz/zoz_afgh_uav_fort.fpk"
        },
        [10052] = {
            -- ANGEL WITH BROKEN WINGS
            "/Assets/tpp/pack/zoz/zoz_afgh_uav_Tent.fpk"
        },
		[10070] = {
            -- HELLBOUND (Power Plant)
            "/Assets/tpp/pack/zoz/zoz_afgh_uav_powerPlant.fpk",
            "/Assets/tpp/pack/zoz/zoz_afgh_uav_sovietBase.fpk"
        },
        [10080] = {
            -- PITCH DARK
            "/Assets/tpp/pack/zoz/zoz_mafr_uav_flowStation.fpk"
        },
        [10090] = {
            -- TRAITORS’ CARAVAN
            "/Assets/tpp/pack/zoz/zoz_mafr_uav_flowStation.fpk",
            --"/Assets/tpp/pack/zoz/zoz_pfCamp_Cameras_custom.fpk"
        }, 
        [10130] = {
            -- CODE TALKER (Lab)
            "/Assets/tpp/pack/zoz/zoz_mafr_uav_lab.fpk"
        },
        [10150] = {
            -- SKULL FACE (citadel)
            "/Assets/tpp/pack/zoz/zoz_afgh_uav_citadel.fpk"
        }
    }
}

function this.MissionPrepare()
    if
        InfMain.IsOnlineMission(vars.missionCode) or vars.missionCode < 5 or
            (vars.locationCode == TppDefine.LOCATION_ID.GNTN)
     then
        return
    end
    --TppScriptBlock.RegisterCommonBlockPackList("Zoz_Camera_Free_Locator", this.Camera_Locator_PackList)
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

this.SECURITY_LIST = {
    CCTV = {
        [10020] = {
            -- PHANTOM LIMBS (SlopedTown + Village)
            {name = "Camera_SlopedTown_0", cp = "afgh_slopedTown_cp"},
            {name = "Camera_SlopedTown_1", cp = "afgh_slopedTown_cp"},
            {name = "Camera_SlopedTown_2", cp = "afgh_slopedTown_cp"},
            {name = "Camera_Village_0", cp = "afgh_village_cp"},
            {name = "Camera_Village_1", cp = "afgh_village_cp"},
            {name = "Camera_Village_2", cp = "afgh_village_cp"},
            {name = "Camera_Village_3", cp = "afgh_village_cp"}
        },
        [10033] = {
            -- OVER THE FENCE (Enemy Base)
            {name = "Camera_enemyBase_0", cp = "afgh_enemyBase_cp"},
            {name = "Camera_enemyBase_1", cp = "afgh_enemyBase_cp"},
            {name = "Camera_enemyBase_2", cp = "afgh_enemyBase_cp"},
            {name = "Camera_enemyBase_3", cp = "afgh_enemyBase_cp"},
            {name = "Camera_enemyBase_4", cp = "afgh_enemyBase_cp"}
        },
        [10036] = {
            -- A HERO'S WAY (Field)
            {name = "Camera_Field_0", cp = "afgh_field_cp"},
            {name = "Camera_Field_1", cp = "afgh_field_cp"},
            {name = "Camera_Field_2", cp = "afgh_field_cp"},
            {name = "Camera_Field_3", cp = "afgh_field_cp"}
        },
        [10040] = {
            -- WHERE DO THE BEES SLEEP? (Fort)
            {name = "Camera_fort_0", cp = "afgh_fort_cp"},
            {name = "Camera_fort_1", cp = "afgh_fort_cp"},
            {name = "Camera_fort_2", cp = "afgh_fort_cp"}
        },
        [10041] = {
            -- RED BRASS (All Locations)
            {name = "Camera_Village_0", cp = "afgh_village_cp"},
            {name = "Camera_Village_1", cp = "afgh_village_cp"},
            {name = "Camera_Village_2", cp = "afgh_village_cp"},
            {name = "Camera_Village_3", cp = "afgh_village_cp"},
            {name = "Camera_enemyBase_0", cp = "afgh_enemyBase_cp"},
            {name = "Camera_enemyBase_1", cp = "afgh_enemyBase_cp"},
            {name = "Camera_enemyBase_2", cp = "afgh_enemyBase_cp"},
            {name = "Camera_enemyBase_3", cp = "afgh_enemyBase_cp"},
            {name = "Camera_enemyBase_4", cp = "afgh_enemyBase_cp"}
        },
        [10043] = {
            -- C2W (Village + Comm Facility)
            {name = "Camera_Village_0", cp = "afgh_village_cp"},
            {name = "Camera_Village_1", cp = "afgh_village_cp"},
            {name = "Camera_Village_2", cp = "afgh_village_cp"},
            {name = "Camera_Village_3", cp = "afgh_village_cp"},
            {name = "Camera_commFacility_0", cp = "afgh_commFacility_cp"},
            {name = "Camera_commFacility_1", cp = "afgh_commFacility_cp"}
        },
        [10044] = {
            -- OCCUPATION FORCES (Fort)
            {name = "Camera_fort_0", cp = "afgh_fort_cp"},
            {name = "Camera_fort_1", cp = "afgh_fort_cp"},
            {name = "Camera_fort_2", cp = "afgh_fort_cp"}
        },
        [10045] = {
            -- TO KNOW TOO MUCH (Field + Remnants)
            {name = "Camera_Field_0", cp = "afgh_field_cp"},
            {name = "Camera_Field_1", cp = "afgh_field_cp"},
            {name = "Camera_Field_2", cp = "afgh_field_cp"},
            {name = "Camera_Field_3", cp = "afgh_field_cp"},
            {name = "Camera_Remenants_0", cp = "afgh_remnants_cp"}
        },
        [10052] = {
            -- ANGEL WITH BROKEN WINGS (Tent + Remnants)
            {name = "Camera_Tent_0", cp = "afgh_tent_cp"},
            {name = "Camera_Tent_1", cp = "afgh_tent_cp"},
            {name = "Camera_Tent_2", cp = "afgh_tent_cp"},
            {name = "Camera_Tent_3", cp = "afgh_tent_cp"},
            {name = "Camera_Remenants_0", cp = "afgh_remnants_cp"}
        },
        [10070] = {
            -- HELLBOUND (Power Plant + Soviet Base)
            {name = "Camera_powerPlant_0", cp = "afgh_powerPlant_cp"},
            {name = "Camera_powerPlant_1", cp = "afgh_powerPlant_cp"},
            {name = "Camera_powerPlant_2", cp = "afgh_powerPlant_cp"},
            {name = "Camera_powerPlant_3", cp = "afgh_powerPlant_cp"},
            {name = "Camera_sovietBase_0", cp = "afgh_sovietBase_cp"},
            {name = "Camera_sovietBase_1", cp = "afgh_sovietBase_cp"},
            {name = "Camera_sovietBase_2", cp = "afgh_sovietBase_cp"},
            {name = "Camera_sovietBase_3", cp = "afgh_sovietBase_cp"},
            {name = "Camera_sovietBase_4", cp = "afgh_sovietBase_cp"}
        },
        [10080] = {
            -- PITCH DARK (Flow Station)
            {name = "Camera_flowStation_0", cp = "mafr_flowStation_cp"},
            {name = "Camera_flowStation_1", cp = "mafr_flowStation_cp"},
            {name = "Camera_flowStation_2", cp = "mafr_flowStation_cp"},
            {name = "Camera_flowStation_3", cp = "mafr_flowStation_cp"},
            {name = "Camera_flowStation_4", cp = "mafr_flowStation_cp"}
        },
        [10090] = {
            -- TRAITORS' CARAVAN (Flow Station + PF Camp)
            {name = "Camera_flowStation_0", cp = "mafr_flowStation_cp"},
            {name = "Camera_flowStation_1", cp = "mafr_flowStation_cp"},
            {name = "Camera_flowStation_2", cp = "mafr_flowStation_cp"},
            {name = "Camera_flowStation_3", cp = "mafr_flowStation_cp"},
            {name = "Camera_pfCamp_0", cp = "mafr_pfCamp_cp"},
            {name = "Camera_pfCamp_1", cp = "mafr_pfCamp_cp"},
            {name = "Camera_pfCamp_2", cp = "mafr_pfCamp_cp"},
            {name = "Camera_pfCamp_3", cp = "mafr_pfCamp_cp"},
            {name = "Camera_pfCamp_4", cp = "mafr_pfCamp_cp"}
        },
        [10093] = {
            -- CURSED LEGACY (Lab)
            {name = "Camera_lab_0", cp = "mafr_lab_cp"},
            {name = "Camera_lab_1", cp = "mafr_lab_cp"},
            {name = "Camera_lab_2", cp = "mafr_lab_cp"},
            {name = "Camera_lab_3", cp = "mafr_lab_cp"},
            {name = "Camera_lab_4", cp = "mafr_lab_cp"}
        },
        [10130] = {
            -- CODE TALKER (Lab)
            {name = "Camera_lab_0", cp = "mafr_lab_cp"},
            {name = "Camera_lab_1", cp = "mafr_lab_cp"},
            {name = "Camera_lab_2", cp = "mafr_lab_cp"},
            {name = "Camera_lab_3", cp = "mafr_lab_cp"},
            {name = "Camera_lab_4", cp = "mafr_lab_cp"}
        }
    },
    UAVs = {
        [10033] = {
            -- OVER THE FENCE
            {name = "zoz_uav_enemyBase_0000",cp = "afgh_enemyBase_cp",DeployRoute = "rt_enemyBase_UAV_d_0000",sendM = "zoz_uav_enemyBase_0000_Start",PatrolRoute = "rt_enemyBase_UAV_a_0000",CombatRoute = "rt_enemyBase_UAV_a_0000"}, -- _a_ for ALL
            {name = "zoz_uav_enemyBase_0001",cp = "afgh_enemyBase_cp",DeployRoute = "rt_enemyBase_UAV_d_0001",sendM = "zoz_uav_enemyBase_0001_Start",PatrolRoute = "rt_enemyBase_UAV_p_0001",CombatRoute = "rt_enemyBase_UAV_c_0001"},
            {name = "zoz_uav_enemyBase_0002",cp = "afgh_enemyBase_cp",DeployRoute = "rt_enemyBase_UAV_d_0002",sendM = "zoz_uav_enemyBase_0002_Start",PatrolRoute = "rt_enemyBase_UAV_p_0002",CombatRoute = "rt_enemyBase_UAV_c_0002"},
            {name = "zoz_uav_enemyBase_0003",cp = "afgh_enemyBase_cp",DeployRoute = "rt_enemyBase_UAV_d_0003",sendM = "zoz_uav_enemyBase_0003_Start",PatrolRoute = "rt_enemyBase_UAV_p_0003",CombatRoute = "rt_enemyBase_UAV_c_0003"}
        },
        [10040] = {
            -- WHERE DO THE BEES SLEEP?
            {name = "zoz_uav_bridge_0000",cp = "afgh_bridge_cp",DeployRoute = "rt_bridge_UAV_d_0000",sendM = "zoz_uav_bridge_0000_Start",PatrolRoute = "rt_bridge_UAV_p_0000",CombatRoute = "rt_bridge_UAV_c_0000"},
            {name = "zoz_uav_bridge_0001",cp = "afgh_bridge_cp",DeployRoute = "rt_bridge_UAV_d_0001",sendM = "zoz_uav_bridge_0001_Start",PatrolRoute = "rt_bridge_UAV_p_0001",CombatRoute = "rt_bridge_UAV_c_0001"},
            {name = "zoz_uav_bridge_0002",cp = "afgh_bridge_cp",DeployRoute = "rt_bridge_UAV_d_0002",sendM = "zoz_uav_bridge_0002_Start",PatrolRoute = "rt_bridge_UAV_p_0002",CombatRoute = "rt_bridge_UAV_c_0002"},
            {name = "zoz_uav_bridge_0003",cp = "afgh_bridge_cp",DeployRoute = "rt_bridge_UAV_d_0003",sendM = "zoz_uav_bridge_0003_Start",PatrolRoute = "rt_bridge_UAV_p_0003",CombatRoute = "rt_bridge_UAV_c_0003"},
            {name = "zoz_uav_fort_0000",cp = "afgh_fort_cp",DeployRoute = "rt_fort_UAV_d_0000",sendM = "zoz_uav_fort_0000_Start",PatrolRoute = "rt_fort_UAV_p_0000",CombatRoute = "rt_fort_UAV_c_0000"},
            {name = "zoz_uav_fort_0001",cp = "afgh_fort_cp",DeployRoute = "rt_fort_UAV_d_0001",sendM = "zoz_uav_fort_0001_Start",PatrolRoute = "rt_fort_UAV_p_0001",CombatRoute = "rt_fort_UAV_c_0001"},
            {name = "zoz_uav_fort_0002",cp = "afgh_fort_cp",DeployRoute = "rt_fort_UAV_d_0002",sendM = "zoz_uav_fort_0002_Start",PatrolRoute = "rt_fort_UAV_p_0002",CombatRoute = "rt_fort_UAV_c_0002"}
        },
        [10041] = {
            -- RED BRASS
            {name = "zoz_uav_enemyBase_0000",cp = "afgh_enemyBase_cp",DeployRoute = "rt_enemyBase_UAV_d_0000",sendM = "zoz_uav_enemyBase_0000_Start",PatrolRoute = "rt_enemyBase_UAV_a_0000",CombatRoute = "rt_enemyBase_UAV_a_0000"}, -- _a_ for ALL
            {name = "zoz_uav_enemyBase_0001",cp = "afgh_enemyBase_cp",DeployRoute = "rt_enemyBase_UAV_d_0001",sendM = "zoz_uav_enemyBase_0001_Start",PatrolRoute = "rt_enemyBase_UAV_p_0001",CombatRoute = "rt_enemyBase_UAV_c_0001"},
            {name = "zoz_uav_enemyBase_0002",cp = "afgh_enemyBase_cp",DeployRoute = "rt_enemyBase_UAV_d_0002",sendM = "zoz_uav_enemyBase_0002_Start",PatrolRoute = "rt_enemyBase_UAV_p_0002",CombatRoute = "rt_enemyBase_UAV_c_0002"},
            {name = "zoz_uav_enemyBase_0003",cp = "afgh_enemyBase_cp",DeployRoute = "rt_enemyBase_UAV_d_0003",sendM = "zoz_uav_enemyBase_0003_Start",PatrolRoute = "rt_enemyBase_UAV_p_0003",CombatRoute = "rt_enemyBase_UAV_c_0003"}
        },
        [10044] = {
            -- OCCUPATION FORCES
            {name = "zoz_uav_fort_0000",cp = "afgh_fort_cp",DeployRoute = "rt_fort_UAV_d_0000",sendM = "zoz_uav_fort_0000_Start",PatrolRoute = "rt_fort_UAV_p_0000",CombatRoute = "rt_fort_UAV_c_0000"},
            {name = "zoz_uav_fort_0001",cp = "afgh_fort_cp",DeployRoute = "rt_fort_UAV_d_0001",sendM = "zoz_uav_fort_0001_Start",PatrolRoute = "rt_fort_UAV_p_0001",CombatRoute = "rt_fort_UAV_c_0001"},
            {name = "zoz_uav_fort_0002",cp = "afgh_fort_cp",DeployRoute = "rt_fort_UAV_d_0002",sendM = "zoz_uav_fort_0002_Start",PatrolRoute = "rt_fort_UAV_p_0002",CombatRoute = "rt_fort_UAV_c_0002"}
        },
        [10052] = {
            -- ANGEL WITH BROKEN WINGS
            {name = "zoz_uav_tent_0000",cp = "afgh_tent_cp",DeployRoute = "rt_tent_UAV_d_0000",sendM = "zoz_uav_tent_0000_Start",PatrolRoute = "rt_tent_UAV_p_0000",CombatRoute = "rt_tent_UAV_c_0000"},
            {name = "zoz_uav_tent_0001",cp = "afgh_tent_cp",DeployRoute = "rt_tent_UAV_d_0001",sendM = "zoz_uav_tent_0001_Start",PatrolRoute = "rt_tent_UAV_p_0001",CombatRoute = "rt_tent_UAV_c_0001"},
            {name = "zoz_uav_tent_0002",cp = "afgh_tent_cp",DeployRoute = "rt_tent_UAV_d_0002",sendM = "zoz_uav_tent_0002_Start",PatrolRoute = "rt_tent_UAV_p_0002",CombatRoute = "rt_tent_UAV_c_0002"},
            {name = "zoz_uav_tent_0003",cp = "afgh_tent_cp",DeployRoute = "rt_tent_UAV_d_0003",sendM = "zoz_uav_tent_0003_Start",PatrolRoute = "rt_tent_UAV_p_0003",CombatRoute = "rt_tent_UAV_c_0003"}
        },
		[10070] = {
            -- HELLBOUND
            {name = "zoz_uav_powerPlant_0000",cp = "afgh_powerPlant_cp",DeployRoute = "rt_powerPlant_UAV_d_0000",sendM = "zoz_uav_powerPlant_0000_Start",PatrolRoute = "rt_powerPlant_UAV_p_0000",CombatRoute = "rt_powerPlant_UAV_c_0000"},
            {name = "zoz_uav_powerPlant_0001",cp = "afgh_powerPlant_cp",DeployRoute = "rt_powerPlant_UAV_d_0001",sendM = "zoz_uav_powerPlant_0001_Start",PatrolRoute = "rt_powerPlant_UAV_p_0001",CombatRoute = "rt_powerPlant_UAV_c_0001"},

            {name = "zoz_uav_sovietBase_0000",cp = "afgh_sovietBase_cp",DeployRoute = "rt_sovietBase_UAV_d_0000",sendM = "zoz_uav_sovietBase_0000_Start",PatrolRoute = "rt_sovietBase_UAV_p_0000",CombatRoute = "rt_sovietBase_UAV_c_0000"},
            {name = "zoz_uav_sovietBase_0001",cp = "afgh_sovietBase_cp",DeployRoute = "rt_sovietBase_UAV_d_0001",sendM = "zoz_uav_sovietBase_0001_Start",PatrolRoute = "rt_sovietBase_UAV_p_0001",CombatRoute = "rt_sovietBase_UAV_c_0001"},
            {name = "zoz_uav_sovietBase_0002",cp = "afgh_sovietBase_cp",DeployRoute = "rt_sovietBase_UAV_d_0002",sendM = "zoz_uav_sovietBase_0002_Start",PatrolRoute = "rt_sovietBase_UAV_p_0002",CombatRoute = "rt_sovietBase_UAV_c_0002"},
            {name = "zoz_uav_sovietBase_0003",cp = "afgh_sovietBase_cp",DeployRoute = "rt_sovietBase_UAV_d_0003",sendM = "zoz_uav_sovietBase_0003_Start",PatrolRoute = "rt_sovietBase_UAV_p_0003",CombatRoute = "rt_sovietBase_UAV_c_0003"}


        },
        [10080] = {
            -- PITCH DARK (Flow Station)
            {name = "zoz_uav_flowStation_0000",cp = "mafr_flowStation_cp",DeployRoute = "rt_flowStation_UAV_d_0000",sendM = "zoz_uav_flowStation_0000_Start",PatrolRoute = "rt_flowStation_UAV_p_0000",CombatRoute = "rt_flowStation_UAV_c_0000"},
            {name = "zoz_uav_flowStation_0001",cp = "mafr_flowStation_cp",DeployRoute = "rt_flowStation_UAV_d_0001",sendM = "zoz_uav_flowStation_0001_Start",PatrolRoute = "rt_flowStation_UAV_p_0001",CombatRoute = "rt_flowStation_UAV_c_0001"},
            {name = "zoz_uav_flowStation_0002",cp = "mafr_flowStation_cp",DeployRoute = "rt_flowStation_UAV_d_0002",sendM = "zoz_uav_flowStation_0002_Start",PatrolRoute = "rt_flowStation_UAV_p_0002",CombatRoute = "rt_flowStation_UAV_c_0002"},
        },
        [10090] = {
            -- TRAITORS’ CARAVAN (Flow Station)
            {name = "zoz_uav_flowStation_0000",cp = "mafr_flowStation_cp",DeployRoute = "rt_flowStation_UAV_d_0000",sendM = "zoz_uav_flowStation_0000_Start",PatrolRoute = "rt_flowStation_UAV_p_0000",CombatRoute = "rt_flowStation_UAV_c_0000"},
            {name = "zoz_uav_flowStation_0001",cp = "mafr_flowStation_cp",DeployRoute = "rt_flowStation_UAV_d_0001",sendM = "zoz_uav_flowStation_0001_Start",PatrolRoute = "rt_flowStation_UAV_p_0001",CombatRoute = "rt_flowStation_UAV_c_0001"},
            {name = "zoz_uav_flowStation_0002",cp = "mafr_flowStation_cp",DeployRoute = "rt_flowStation_UAV_d_0002",sendM = "zoz_uav_flowStation_0002_Start",PatrolRoute = "rt_flowStation_UAV_p_0002",CombatRoute = "rt_flowStation_UAV_c_0002"},
        },
        [10130] = {
            -- CODE TALKER (Lab)
            {name = "zoz_uav_lab_0000",cp = "mafr_lab_cp",DeployRoute = "rt_lab_UAV_d_0000",sendM = "zoz_uav_lab_0000_Start",PatrolRoute = "rt_lab_UAV_p_0000",CombatRoute = "rt_lab_UAV_c_0000"},
            {name = "zoz_uav_lab_0001",cp = "mafr_lab_cp",DeployRoute = "rt_lab_UAV_d_0001",sendM = "zoz_uav_lab_0001_Start",PatrolRoute = "rt_lab_UAV_p_0001",CombatRoute = "rt_lab_UAV_c_0001"},
            {name = "zoz_uav_lab_0002",cp = "mafr_lab_cp",DeployRoute = "rt_lab_UAV_d_0002",sendM = "zoz_uav_lab_0002_Start",PatrolRoute = "rt_lab_UAV_p_0002",CombatRoute = "rt_lab_UAV_c_0002"},
            {name = "zoz_uav_lab_0003",cp = "mafr_lab_cp",DeployRoute = "rt_lab_UAV_d_0003",sendM = "zoz_uav_lab_0003_Start",PatrolRoute = "rt_lab_UAV_p_0003",CombatRoute = "rt_lab_UAV_c_0003"},
            {name = "zoz_uav_lab_0004",cp = "mafr_lab_cp",DeployRoute = "rt_lab_UAV_d_0004",sendM = "zoz_uav_lab_0004_Start",PatrolRoute = "rt_lab_UAV_p_0004",CombatRoute = "rt_lab_UAV_c_0004"},
        },
        [10150] = {
            -- SKULL FACE (citadel)
            {name = "zoz_uav_citadel_0000",cp = "afgh_citadel_cp",DeployRoute = "rt_citadel_UAV_d_0000",sendM = "zoz_uav_citadel_0000_Start",PatrolRoute = "rt_citadel_UAV_p_0000",CombatRoute = "rt_citadel_UAV_c_0000"},
            {name = "zoz_uav_citadel_0001",cp = "afgh_citadel_cp",DeployRoute = "rt_citadel_UAV_d_0001",sendM = "zoz_uav_citadel_0001_Start",PatrolRoute = "rt_citadel_UAV_p_0001",CombatRoute = "rt_citadel_UAV_c_0001"},
            {name = "zoz_uav_citadel_0002",cp = "afgh_citadel_cp",DeployRoute = "rt_citadel_UAV_d_0002",sendM = "zoz_uav_citadel_0002_Start",PatrolRoute = "rt_citadel_UAV_p_0002",CombatRoute = "rt_citadel_UAV_c_0002"},
        }
    },
    IRSensors = {
        "afgh_bridge_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "afgh_bridge_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003",
        "afgh_bridge_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0002|srt_mtbs_trap003",
        "afgh_bridge_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0003|srt_mtbs_trap003",
        "afgh_citadel_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "afgh_citadel_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003",
        "afgh_citadel_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0002|srt_mtbs_trap003",
        "afgh_citadel_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0003|srt_mtbs_trap003",
        "afgh_citadel_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0004|srt_mtbs_trap003",
        "afgh_citadel_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0005|srt_mtbs_trap003",
        "afgh_enemyBase_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "afgh_enemyBase_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003",
        "afgh_enemyBase_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0002|srt_mtbs_trap003",
        "afgh_enemyBase_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0003|srt_mtbs_trap003",
        "afgh_enemyBase_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0004|srt_mtbs_trap003",
        "afgh_fort_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "afgh_fort_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003",
        "afgh_fort_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0002|srt_mtbs_trap003",
        "afgh_powerPlant_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "afgh_powerPlant_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003",
        "afgh_powerPlant_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0002|srt_mtbs_trap003",
        "afgh_powerPlant_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0003|srt_mtbs_trap003",
        "afgh_powerPlant_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0004|srt_mtbs_trap003",
        "afgh_sovietBase_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "afgh_sovietBase_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003",
        "afgh_sovietBase_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0002|srt_mtbs_trap003",
        "afgh_sovietBase_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0003|srt_mtbs_trap003",
        "afgh_tent_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "afgh_tent_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003",
        "afgh_tent_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0002|srt_mtbs_trap003",
        "afgh_tent_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0003|srt_mtbs_trap003",
        "mafr_banana_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "mafr_banana_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003",
        "mafr_banana_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0002|srt_mtbs_trap003",
        "mafr_banana_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0003|srt_mtbs_trap003",
        "mafr_diamond_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "mafr_diamond_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003",
        "mafr_diamond_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0002|srt_mtbs_trap003",
        "mafr_flowStation_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "mafr_flowStation_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003",
        "mafr_flowStation_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0002|srt_mtbs_trap003",
        "mafr_flowStation_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0003|srt_mtbs_trap003",
        "mafr_flowStation_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0004|srt_mtbs_trap003",
        "mafr_hill_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "mafr_lab_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "mafr_lab_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003",
        "mafr_lab_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0002|srt_mtbs_trap003",
        "mafr_lab_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0003|srt_mtbs_trap003",
        "mafr_lab_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0004|srt_mtbs_trap003",
        "mafr_pfCamp_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0000|srt_mtbs_trap003",
        "mafr_pfCamp_item0000|cl00pl1_mb_fndt_plnt_gimmick2|mtbs_trap003_gim_n0001|srt_mtbs_trap003"
    },
    BurglarAlarm = {
        "SovietBase|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "SovietBase|Container|alm0_main0_def_v00_gim_n0001|srt_alm0_main0_def_v00",
        "SovietBase|Container|alm0_main0_def_v00_gim_n0002|srt_alm0_main0_def_v00",
        "SovietBase|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "SovietBase|Container|alm0_main0_def_v00_gim_n0003|srt_alm0_main0_def_v00",
        "SovietBase|Container|alm0_main0_def_v00_gim_n0004|srt_alm0_main0_def_v00",
        "SovietBase|Container|alm0_main0_def_v00_gim_n0005|srt_alm0_main0_def_v00",
        "SovietBase|Container|alm0_main0_def_v00_gim_n0006|srt_alm0_main0_def_v00",
        "SovietBase|Container|alm0_main0_def_v00_gim_n0007|srt_alm0_main0_def_v00",
        "SovietBase|Container|alm0_main0_def_v00_gim_n0008|srt_alm0_main0_def_v00",
        "SovietBase|Container|alm0_main0_def_v00_gim_n0009|srt_alm0_main0_def_v00",
        "SovietBase|Container|alm0_main0_def_v00_gim_n0010|srt_alm0_main0_def_v00",
        "Citadel|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "Citadel|Container|alm0_main0_def_v00_gim_n0001|srt_alm0_main0_def_v00",
        "Citadel|Container|alm0_main0_def_v00_gim_n0002|srt_alm0_main0_def_v00",
        "Citadel|Container|alm0_main0_def_v00_gim_n0003|srt_alm0_main0_def_v00",
        "Citadel|Container|alm0_main0_def_v00_gim_n0004|srt_alm0_main0_def_v00",
        "Citadel|Container|alm0_main0_def_v00_gim_n0005|srt_alm0_main0_def_v00",
        "Citadel|Container|alm0_main0_def_v00_gim_n0006|srt_alm0_main0_def_v00",
        "Citadel|Container|alm0_main0_def_v00_gim_n0007|srt_alm0_main0_def_v00",
        "Citadel|Container|alm0_main0_def_v00_gim_n0008|srt_alm0_main0_def_v00",
        "Citadel|Container|alm0_main0_def_v00_gim_n0009|srt_alm0_main0_def_v00",
        "Citadel|Container|alm0_main0_def_v00_gim_n0010|srt_alm0_main0_def_v00",
        "Tent|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "Remnants|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "enemyBase|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "enemyBase|Container|alm0_main0_def_v00_gim_n0001|srt_alm0_main0_def_v00",
        "enemyBase|Container|alm0_main0_def_v00_gim_n0002|srt_alm0_main0_def_v00",
        "enemyBase|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "enemyBase|Container|alm0_main0_def_v00_gim_n0003|srt_alm0_main0_def_v00",
        "enemyBase|Container|alm0_main0_def_v00_gim_n0004|srt_alm0_main0_def_v00",
        "enemyBase|Container|alm0_main0_def_v00_gim_n0005|srt_alm0_main0_def_v00",
        "enemyBase|Container|alm0_main0_def_v00_gim_n0006|srt_alm0_main0_def_v00",
        "commonFacility|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "commonFacility|Container|alm0_main0_def_v00_gim_n0001|srt_alm0_main0_def_v00",
        "bridge|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "bridge|Container|alm0_main0_def_v00_gim_n0001|srt_alm0_main0_def_v00",
        "bridge|Container|alm0_main0_def_v00_gim_n0002|srt_alm0_main0_def_v00",
        "bridge|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "bridge|Container|alm0_main0_def_v00_gim_n0003|srt_alm0_main0_def_v00",
        "bridge|Container|alm0_main0_def_v00_gim_n0004|srt_alm0_main0_def_v00",
        "bridge|Container|alm0_main0_def_v00_gim_n0005|srt_alm0_main0_def_v00",
        "bridge|Container|alm0_main0_def_v00_gim_n0006|srt_alm0_main0_def_v00",
        "flowStation|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "flowStation|Container|alm0_main0_def_v00_gim_n0001|srt_alm0_main0_def_v00",
        "flowStation|Container|alm0_main0_def_v00_gim_n0002|srt_alm0_main0_def_v00",
        "flowStation|Container|alm0_main0_def_v00_gim_n0003|srt_alm0_main0_def_v00",
        "flowStation|Container|alm0_main0_def_v00_gim_n0004|srt_alm0_main0_def_v00",
        "flowStation|Container|alm0_main0_def_v00_gim_n0005|srt_alm0_main0_def_v00",
        "swamp|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "swamp|Container|alm0_main0_def_v00_gim_n0001|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0001|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0002|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0003|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0004|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0005|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0006|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0007|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0008|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0009|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0010|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0011|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0012|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0013|srt_alm0_main0_def_v00",
        "airport|Container|alm0_main0_def_v00_gim_n0014|srt_alm0_main0_def_v00",
        "hill|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "hill|Container|alm0_main0_def_v00_gim_n0001|srt_alm0_main0_def_v00",
        "hill|Container|alm0_main0_def_v00_gim_n0002|srt_alm0_main0_def_v00",
        "hill|Container|alm0_main0_def_v00_gim_n0003|srt_alm0_main0_def_v00",
        "hill|Container|alm0_main0_def_v00_gim_n0004|srt_alm0_main0_def_v00",
        "diamond|Container|alm0_main0_def_v00_gim_n0000|srt_alm0_main0_def_v00",
        "diamond|Container|alm0_main0_def_v00_gim_n0001|srt_alm0_main0_def_v00",
        "diamond|Container|alm0_main0_def_v00_gim_n0002|srt_alm0_main0_def_v00",
        "diamond|Container|alm0_main0_def_v00_gim_n0003|srt_alm0_main0_def_v00",
        "diamond|Container|alm0_main0_def_v00_gim_n0004|srt_alm0_main0_def_v00",
        "diamond|Container|alm0_main0_def_v00_gim_n0005|srt_alm0_main0_def_v00"
    }
}

function this.SetUpZozFulton()
    local fultonLevel = 1
    local isWormHole = false
    local FULTON_LEVELS = {
        Normal = {
            [1] = {level = 1, wormhole = false},
            [2] = {level = 3, wormhole = false},
            [3] = {level = 3, wormhole = true}
        }
    }
    if Ivars.Zoz_Enemy_Equipment_Fulton:Is "Normal" then
        local revengeLevel = TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.FULTON)
        if FULTON_LEVELS.Normal[revengeLevel] then
            for _, config in ipairs(FULTON_LEVELS.Normal[revengeLevel]) do
                fultonLevel = config.level
                isWormHole = config.wormhole
            end
        end
    elseif Ivars.Zoz_Enemy_Equipment_Fulton:Is "Balloon" then
        fultonLevel = 3
    elseif Ivars.Zoz_Enemy_Equipment_Fulton:Is "Wormhole" then
        fultonLevel = 3
        isWormHole = true
    end
    SendCommand(
        {type = "TppCommandPost2"},
        {id = "SetFultonLevel", fultonLevel = fultonLevel, isWormHole = isWormHole}
    )
end

function this.SetUpZozCam()
    local missionCode = TppMission.GetMissionID()
    if TppMission.IsHardMission(missionCode) then
        missionCode = TppMission.GetNormalMissionCodeFromHardMission(missionCode)
    end
    if not this.MISSION_PACKS.CCTV[missionCode] then
        return
    end

    local revengeConfig

    if not Ivars.mbDDEquipNonLethal:Is(1) then
        if TppRevenge.IsUsingGunCamera() then
            revengeConfig = {
                [1] = {
                    {id = "SetDevelopLevel", developLevel = 6}
                },
                [2] = {
                    {id = "SetDevelopLevel", developLevel = 6}
                },
                [3] = {
                    {id = "SetDevelopLevel", developLevel = 7}
                },
                [4] = {
                    {id = "SetDevelopLevel", developLevel = 8}
                },
                [5] = {
                    {id = "SetDevelopLevel", developLevel = 8}
                }
            }
        else
            revengeConfig = {
                [1] = {
                    {id = "SetDevelopLevel", developLevel = 3}
                },
                [2] = {
                    {id = "SetDevelopLevel", developLevel = 3}
                },
                [3] = {
                    {id = "SetDevelopLevel", developLevel = 5}
                },
                [4] = {
                    {id = "SetDevelopLevel", developLevel = 6}
                },
                [5] = {
                    {id = "SetDevelopLevel", developLevel = 6}
                }
            }
        end
    else
        revengeConfig = {
            [1] = {
                {id = "SetNormalCamera"},
                {id = "SetDevelopLevel", developLevel = 3}
            },
            [2] = {
                {id = "SetNormalCamera"},
                {id = "SetDevelopLevel", developLevel = 3}
            },
            [3] = {
                {id = "SetNormalCamera"},
                {id = "SetDevelopLevel", developLevel = 5}
            },
            [4] = {
                {id = "SetNormalCamera"},
                {id = "SetDevelopLevel", developLevel = 6}
            },
            [5] = {
                {id = "SetNormalCamera"},
                {id = "SetDevelopLevel", developLevel = 6}
            }
        }
    end
    if this.SECURITY_LIST.CCTV[missionCode] then
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
        InfCore.Log("Zoz info: Cameras info: ")
        for _, camInfo in ipairs(this.SECURITY_LIST.CCTV[missionCode]) do
            InfCore.Log("Zoz info: Cameras name: " .. camInfo.name)
            InfCore.Log("Zoz info: Cameras Command Post: " .. camInfo.cp)
            local gameObjectId = GetGameObjectId(camInfo.name)
            if gameObjectId ~= NULL_ID then
                SendCommand(gameObjectId, {id = "SetCommandPost", cp = camInfo.cp})
            end
        end

        if TppRevenge.IsUsingGunCamera() then
            InfCore.Log("Zoz info: Gun Camera")
        else
            InfCore.Log("Zoz info: Normal Camera")
        end
    end
end

function this.SetUpZozUAV()
    local missionCode = TppMission.GetMissionID()
    if TppMission.IsHardMission(missionCode) then
        missionCode = TppMission.GetNormalMissionCodeFromHardMission(missionCode)
    end
    if not this.MISSION_PACKS.UAVs[missionCode] and not TppStory.IsMissionCleard(10121) then
        return
    end

    local revengeLv = TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.NIGHT_C)
    local isNonLethal = Ivars.mbDDEquipNonLethal:Is(1)

    local lethalDevelopLevel = {
        [1] = TppUav.DEVELOP_LEVEL_LMG_0,
        [2] = TppUav.DEVELOP_LEVEL_LMG_0,
        [3] = TppUav.DEVELOP_LEVEL_LMG_1,
        [4] = TppUav.DEVELOP_LEVEL_LMG_2,
        [5] = TppUav.DEVELOP_LEVEL_LMG_2
    }

    local nonLethalDevelopLevel = {
        [1] = TppUav.DEVELOP_LEVEL_SMOKE_0,
        [2] = TppUav.DEVELOP_LEVEL_SMOKE_1,
        [3] = TppUav.DEVELOP_LEVEL_SMOKE_2,
        [4] = TppUav.DEVELOP_LEVEL_SLEEP_0,
        [5] = TppUav.DEVELOP_LEVEL_SLEEP_0
    }

    local function GetEmpLevel(revengeLv)
        if revengeLv <= 2 then
            return 0
        elseif revengeLv >= 3 then
            return 1
        end
    end

    local developLevel = isNonLethal and nonLethalDevelopLevel or lethalDevelopLevel
    if this.SECURITY_LIST.UAVs[missionCode] then
        InfCore.Log("Zoz Log: UAV info: ")
        for _, uavInfo in ipairs(this.SECURITY_LIST.UAVs[missionCode]) do
            InfCore.Log("Zoz Log: UAV name: " .. uavInfo.name)
            InfCore.Log("Zoz Log: UAV Command Post: " .. uavInfo.cp)
            InfCore.Log("Zoz Log: UAV Level: " .. developLevel[revengeLv])
            InfCore.Log("Zoz Log: UAV emp Level: " .. GetEmpLevel(revengeLv))
            local gameId = GetGameObjectId(uavInfo.name)
            if gameId ~= NULL_ID then
                SendCommand(gameId, {id = "SetEnabled", enabled = false})
                if developLevel[revengeLv] then
                    SendCommand(
                        gameId,
                        {
                            id = "SetDevelopLevel",
                            developLevel = developLevel[revengeLv],
                            empLevel = GetEmpLevel(revengeLv)
                        }
                    )
                end
            end
        end
    end
end

function this.SetUpIRBurglarLevel()
    if not TppStory.IsMissionCleard(10121) then
        return
    end
    local configByLevel = {
        [2] = {irSensorLevel = 1, burglarAlarmRange = 1},
        [3] = {irSensorLevel = 2, burglarAlarmRange = 2},
        [4] = {irSensorLevel = 2, burglarAlarmRange = 2},
        [5] = {irSensorLevel = 3, burglarAlarmRange = 3}
    }

    local revengeStealthLevel = configByLevel[TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.STEALTH)]

    if revengeStealthLevel then
        this.burgularAlarmRange = revengeStealthLevel.burglarAlarmRange
        Gimmick.SetGimmickLevels(revengeStealthLevel.irSensorLevel, revengeStealthLevel.burglarAlarmRange)
    else
        for _, sensorName in ipairs(this.SECURITY_LIST.IRSensors) do
            if type(sensorName) == "string" then
                Gimmick.InvisibleGimmick(
                    TppGameObject.GAME_OBJECT_TYPE_IR_SENSOR,
                    sensorName,
                    "/Assets/tpp/level/mission2/free/Zoz_Afgh_Ir_Sensors.fox2",
                    true
                )
                Gimmick.InvisibleGimmick(
                    TppGameObject.GAME_OBJECT_TYPE_IR_SENSOR,
                    sensorName,
                    "/Assets/tpp/level/mission2/free/Zoz_Mafr_Ir_Sensors.fox2",
                    true
                )
            end
        end
        for _, alarmName in ipairs(this.SECURITY_LIST.BurglarAlarm) do
            if type(alarmName) == "string" then
                Gimmick.InvisibleGimmick(
                    TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,
                    alarmName,
                    "/Assets/tpp/level/mission2/custom/alm_afgh.fox2",
                    true
                )
                Gimmick.InvisibleGimmick(
                    TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,
                    alarmName,
                    "/Assets/tpp/level/mission2/custom/alm_mafr.fox2",
                    true
                )
            end
        end
        return
    end
end

function this.deployUAVs(cpId, phase, oldPhaseId)
    if not Ivars.Zoz_Enemy_Equipment_Uav:Is "OFF" and not TppMission.IsBossBattle() then
        local missionCode = TppMission.GetMissionID()
        local revengeStealthLevel = TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.STEALTH)
        if TppMission.IsHardMission(missionCode) then
            missionCode = TppMission.GetNormalMissionCodeFromHardMission(missionCode)
        end
        if phase > PHASE_SNEAK and oldPhaseId == PHASE_SNEAK or revengeStealthLevel >= 3 then
            if this.SECURITY_LIST.UAVs[missionCode] then
                InfCore.Log("Zoz log: UAVs deployed")
                if phase ==  PHASE_ALERT or phase ==  PHASE_CAUTION and oldPhaseId == TppGameObject.PHASE_SNEAK then
                    if not mvars.HQUAVRadio then
                        mvars.HQUAVRadio = true
                        Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ_HQR0140")
                    end
                end
                for _, uavInfo in ipairs(this.SECURITY_LIST.UAVs[missionCode]) do
                    local gameId = GetGameObjectId(uavInfo.name)
                    if gameId ~= NULL_ID and cpId == GetGameObjectId(uavInfo.cp) then
                        if oldPhaseId == PHASE_SNEAK then
                            SendCommand(gameId, {id = "SetEnabled", enabled = true})
                            SendCommand(gameId, {id = "SetPatrolRoute", route = uavInfo.DeployRoute})
                            SendCommand(gameId, {id = "SetCombatRoute", route = uavInfo.DeployRoute})
                            SendCommand(gameId, {id = "SetCommandPost", cp = uavInfo.cp})
                        end
                    end
                end
            end
        end
    end
end

function this.SetUAVsRoutes(gameObjectId, routeID, nodeNo, msgID)
    if not Ivars.Zoz_Enemy_Equipment_Uav:Is "OFF" then
        local missionCode = TppMission.GetMissionID()
        if TppMission.IsHardMission(missionCode) then
            missionCode = TppMission.GetNormalMissionCodeFromHardMission(missionCode)
        end
        if this.SECURITY_LIST.UAVs[missionCode] then
            for _, uavInfo in ipairs(this.SECURITY_LIST.UAVs[missionCode]) do
                local gameId = GetGameObjectId(uavInfo.name)
                if gameId ~= NULL_ID then
                    if gameObjectId == gameId then
                        SendCommand(gameId, {id = "SetPatrolRoute", route = uavInfo.PatrolRoute})
                        SendCommand(gameId, {id = "SetCombatRoute", route = uavInfo.CombatRoute})
                    else
                    end
                end
            end
        end
    end
end

function this.Messages()
    return StrCode32Table {
        GameObject = {
            {msg = "ChangePhase", func = this.deployUAVs},
            {msg = "RoutePoint2", func = this.SetUAVsRoutes},
            {
                msg = "WarningGimmick",
                func = function(irSensorId, irHash, irDataSetName, gameObjectId)
                    this.RequestNoticeGimmick(Zoz_overhaul_Ivars.getClosestCp(), irSensorId, 0) -- 0 is The Player
                end
            },
            {
                msg = "BurglarAlarmTrap",
                func = function(bAlarmId, bAlarmHash, bAlarmDataSetName, gameObjectId)
                    this.RequestNoticeGimmick(Zoz_overhaul_Ivars.getClosestCp(), bAlarmId, gameObjectId)
                end
            },
            {
                msg = "FultonInfo",
                func = function(gameObjectId, fultonedPlayer)
                    if fultonedPlayer == 0 then
                        if
                            Tpp.IsFultonContainer(gameObjectId) or this.IsAirGun(gameObjectId) or
                                Tpp.IsGatlingGun(gameObjectId) or
                                this.IsMortar(gameObjectId) or
                                this.IsMachineGun(gameObjectId)
                         then
                            if
                                Gimmick.CallBurglarAlarm(gameObjectId, this.burgularAlarmRange, this.burgularAlarmTime) ==
                                    true
                             then
                                this.RequestNoticeGimmick(
                                    Zoz_overhaul_Ivars.getClosestCp(),
                                    gameObjectId,
                                    fultonedPlayer
                                ) -- fultonedPlayer is The Player
                            end
                        end
                    end
                end
            },
            {
                msg = "FultonFailed",
                func = function(gameObjectId)
                    if
                        Tpp.IsFultonContainer(gameObjectId) or this.IsAirGun(gameObjectId) or
                            Tpp.IsGatlingGun(gameObjectId) or
                            this.IsMortar(gameObjectId) or
                            this.IsMachineGun(gameObjectId)
                     then
                        if
                            Gimmick.CallBurglarAlarm(gameObjectId, this.burgularAlarmRange, this.burgularAlarmTime) ==
                                true
                         then
                            this.RequestNoticeGimmick(Zoz_overhaul_Ivars.getClosestCp(), gameObjectId, 0)
                        end
                    end
                end
            }
        },
        Timer = {
            {
                msg = "Finish",
                sender = "fultonedbyenemy",
                func = function()
                    mvars.fultonedbyenemy = true
                end
            }
        },
        Player = {
            {
                msg = "PlayerHoldWeapon",
                func = function()
                    -- FOR DEBUG + math.random(100,150)
                    
                end
            },
            {
                msg = "PlayerFulton",
                func = function(arg0, arg1)
                    if Tpp.IsFultonContainer(arg1) then
                        mvars.fultonedbyenemy = false
                        GkEventTimerManager.Start("fultonedbyenemy", 8)
                    end
                end
            }
        },
    }
end

function this.AddMissionPacks(missionCode, packPaths)
    if InfMain.IsOnlineMission(missionCode) or missionCode < 5 or (vars.locationCode == TppDefine.LOCATION_ID.GNTN) then
        return
    end

    if not Ivars.Zoz_Enemy_Equipment_Fulton:Is "OFF" then
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

    if not Ivars.Zoz_Enemy_Equipment_Ir_Sensors:Is "OFF" then
        packPaths[#packPaths + 1] = "/Assets/tpp/pack/zoz/mis_common_zoz_Ir_Sensor.fpk"
        local isFreeRoom = Ivars.Zoz_Enemy_Equipment_Ir_Sensors:Is "FreeRoom"
        local isMission = Ivars.Zoz_Enemy_Equipment_Ir_Sensors:Is "Mission"
        local isAll = Ivars.Zoz_Enemy_Equipment_Ir_Sensors:Is "ALL"
        local isFreeRoomMission = TppMission.IsFreeMission(vars.missionCode)

        if isFreeRoom and isFreeRoomMission then
            AddLocationPacks(
                "/Assets/tpp/pack/zoz/zoz_afgh_Ir_Sensor.fpk",
                "/Assets/tpp/pack/zoz/zoz_mafr_Ir_Sensor.fpk",
                true
            )
        elseif isMission and not isFreeRoomMission then
            AddLocationPacks(
                "/Assets/tpp/pack/zoz/zoz_afgh_Ir_Sensor.fpk",
                "/Assets/tpp/pack/zoz/zoz_mafr_Ir_Sensor.fpk",
                true
            )
        elseif isAll then
            AddLocationPacks(
                "/Assets/tpp/pack/zoz/zoz_afgh_Ir_Sensor.fpk",
                "/Assets/tpp/pack/zoz/zoz_mafr_Ir_Sensor.fpk",
                true
            )
        end
    end

    if
        not Ivars.Zoz_Enemy_Equipment_burglar_alarm:Is "OFF" then
        packPaths[#packPaths + 1] = "/Assets/tpp/pack/zoz/zoz_common_alm.fpk"
        local isFreeRoom = Ivars.Zoz_Enemy_Equipment_burglar_alarm:Is "FreeRoom"
        local isMission = Ivars.Zoz_Enemy_Equipment_burglar_alarm:Is "Mission"
        local isAll = Ivars.Zoz_Enemy_Equipment_burglar_alarm:Is "ALL"
        local isFreeRoomMission = TppMission.IsFreeMission(vars.missionCode)

        if isFreeRoom and isFreeRoomMission then
            AddLocationPacks("/Assets/tpp/pack/zoz/alm_afgh.fpk", "/Assets/tpp/pack/zoz/alm_mafr.fpk", true)
        elseif isMission and not isFreeRoomMission then
            AddLocationPacks("/Assets/tpp/pack/zoz/alm_afgh.fpk", "/Assets/tpp/pack/zoz/alm_mafr.fpk", true)
        elseif isAll then
            AddLocationPacks("/Assets/tpp/pack/zoz/alm_afgh.fpk", "/Assets/tpp/pack/zoz/alm_mafr.fpk", true)
        end
    end
    if TppMission.IsHardMission(missionCode) then
        missionCode = TppMission.GetNormalMissionCodeFromHardMission(missionCode)
    end
    if not Ivars.Zoz_Enemy_Equipment_Camera:Is "OFF" then
        if this.MISSION_PACKS.CCTV[missionCode] then
            packPaths[#packPaths + 1] = "/Assets/tpp/pack/zoz/zoz_common_cam_GameObject.fpk"
            for _, packPath in ipairs(this.MISSION_PACKS.CCTV[missionCode]) do
                packPaths[#packPaths + 1] = packPath
            end
        end
    end
    if
        not Ivars.Zoz_Enemy_Equipment_Uav:Is "OFF"  then
        if this.MISSION_PACKS.UAVs[missionCode] then
            packPaths[#packPaths + 1] = "/Assets/tpp/pack/zoz/zoz_common_uav_GameObject.fpk"
            for _, packPath in ipairs(this.MISSION_PACKS.UAVs[missionCode]) do
                packPaths[#packPaths + 1] = packPath
            end
        end
    end
end

function this.SetUpEnemy()
    if TppMission.IsFOBMission(vars.missionCode) then
        InfCore.Log("Zoz Log: Zoz_Enemy_Equipment_Overhaul.SetUpEnemy() RETURNED")
        return
    end
    InfCore.Log("Zoz Log: Zoz_Enemy_Equipment_Overhaul.SetUpEnemy()")

    if not Ivars.Zoz_Enemy_Equipment_Fulton:Is "OFF" then
        this.SetUpZozFulton()
    end
    if not Ivars.Zoz_Enemy_Equipment_Camera:Is "OFF" then
        this.SetUpZozCam()
    end
    if not Ivars.Zoz_Enemy_Equipment_Uav:Is "OFF" then
        this.SetUpZozUAV()
    end
end

function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
    if TppMission.IsFOBMission(vars.missionCode) then
        return
    end
    Tpp.DoMessage(
        this.messageExecTable,
        TppMission.CheckMessageOption,
        sender,
        messageId,
        arg0,
        arg1,
        arg2,
        arg3,
        strLogText
    )
end

function this.Init(missionTable)
    if TppMission.IsFOBMission(vars.missionCode) then
        return
    end

    mvars.fultonedbyenemy = true

    if not Ivars.Zoz_Enemy_Equipment_Ir_Sensors:Is "OFF" then
        this.SetUpIRBurglarLevel()
    end

    if not Ivars.Zoz_Enemy_Equipment_burglar_alarm:Is "OFF" then
        this.burgularAlarmTime = 10
        this.SetUpIRBurglarLevel()
    end

    if not Ivars.Zoz_Enemy_Equipment_Uav:Is"OFF" then
        mvars.HQUAVRadio = false
    end

    if Ivars.mbDDEquipNonLethal:Is(1) then
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

    local gimmickIdentifierTable=InfUtil.CopyTable(afgh_gimmick.gimmickIdentifierParamTable)
    gimmickIdentifierTable.afgh_zoz_village_Generator=this.zoz_afgh_gimmickIdentifierParamTableExtra.afgh_zoz_village_Generator

    local gimmickPowerCutConnectTable=InfUtil.CopyTable(afgh_gimmick.gimmickPowerCutConnectTable)
	gimmickPowerCutConnectTable.afgh_zoz_village_Generator=this.zoz_afgh_gimmickPowerCutConnectTableExtra.afgh_zoz_village_Generator

    TppGimmick.SetUpIdentifierTable(gimmickIdentifierTable)
    TppGimmick.SetUpConnectPowerCutTable(gimmickPowerCutConnectTable)
    this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

this.OnChangeSVars = function()
    local getSequenceName = TppSequence.GetSequenceNameWithIndex(TppSequence.GetCurrentSequenceIndex())
    InfCore.Log("Zoz Log: Current Sequence: " .. tostring(getSequenceName))
    if TppMission.IsBossBattle() then
        InfCore.Log("Zoz Log: Disable UAVS!!!")
    end
end

return this
