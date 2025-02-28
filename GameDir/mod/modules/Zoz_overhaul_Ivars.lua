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