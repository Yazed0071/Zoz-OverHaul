local this={}

function this.LoadLibraries()
	TppRevenge.SelectReinforceType=this.SelectReinforceType
end

function this.SelectReinforceType()
  if mvars.reinforce_reinforceType==TppReinforceBlock.REINFORCE_TYPE.HELI then--tex DEBUG
    InfCore.Log("SelectReinforceType already heli")--tex DEBUG
    return TppReinforceBlock.REINFORCE_TYPE.HELI
  end
  if not TppRevenge.IsUsingSuperReinforce()then
    InfCore.Log("SelectReinforceType not superreinforce, REINFORCE_TYPE.NONE")--tex DEBUG
    return TppReinforceBlock.REINFORCE_TYPE.NONE
  end
  local reinforceVehicleTypes={}
  local canuseReinforceVehicle=TppRevenge.CanUseReinforceVehicle()
  if canuseReinforceVehicle and Ivars.forceSuperReinforce:Is()>0 then--tex
    canuseReinforceVehicle=not(vars.missionCode==TppDefine.SYS_MISSION_ID.AFGH_FREE or vars.missionCode==TppDefine.SYS_MISSION_ID.MAFR_FREE)--tex TODO: can't use reinforce vehicle in free mode, reinforce request doesnt fire (VERIFY, I think I can't remember if it's not at all or if it's super rare/inconsistant compared to missions) and forcing reinforce to get around it works for helis but breaks vehicles
  end--
  local canUseReinforceHeli=TppRevenge.CanUseReinforceHeli() and mvars.revenge_isEnabledSuperReinforce--tex added isEnabledSuper, which is only set by quest heli and shouldnt stop other vehicle
  if canuseReinforceVehicle then
    InfCore.Log("SelectReinforceType canuseReinforceVehicle")--tex DEBUG
    --tex DEBUGNOW TppReinforceBlock is after TppRevenge, so cant make this module local  want addon support
    local reinforceVehiclesForLocation={
      AFGH={TppReinforceBlock.REINFORCE_TYPE.EAST_WAV,TppReinforceBlock.REINFORCE_TYPE.EAST_TANK},
      MAFR={TppReinforceBlock.REINFORCE_TYPE.WEST_WAV,TppReinforceBlock.REINFORCE_TYPE.WEST_WAV_CANNON,TppReinforceBlock.REINFORCE_TYPE.WEST_TANK},
      GNTN={TppReinforceBlock.REINFORCE_TYPE.GNTN_LV,TppReinforceBlock.REINFORCE_TYPE.GNTN_WAV_CANNON,TppReinforceBlock.REINFORCE_TYPE.GNTN_WAV,TppReinforceBlock.REINFORCE_TYPE.GNTN_TANK},
    }
    --REWORKED
    local locationName=TppLocation.GetLocationName(vars.locationCode)
    local locationReinforceVehicleTypes=reinforceVehiclesForLocation[string.upper(locationName)]
	if locationReinforceVehicleTypes then
		for index, reinforceType in ipairs(locationReinforceVehicleTypes) do
			table.insert(reinforceVehicleTypes,reinforceType)
		end
	end
    --ORIG
    --    if TppLocation.IsAfghan()then
    --      reinforceVehicleTypes=reinforceVehiclesForLocation.AFGH
    --    elseif TppLocation.IsMiddleAfrica()then
    --      reinforceVehicleTypes=reinforceVehiclesForLocation.MAFR
    --    end
  end
  if canUseReinforceHeli then
    InfCore.Log("SelectReinforceType canuseReinforceHeli")--tex DEBUG
    table.insert(reinforceVehicleTypes,TppReinforceBlock.REINFORCE_TYPE.HELI)
  end
  if#reinforceVehicleTypes==0 then
    InfCore.Log("SelectReinforceType #reinforceVehicleTypes==0")--tex DEBUG
    return TppReinforceBlock.REINFORCE_TYPE.NONE
  end
  local randomVehicleType=math.random(1,#reinforceVehicleTypes)
  InfCore.Log("SelectReinforceType randomVehicleType: "..TppReinforceBlock.REINFORCE_TYPE_NAME[reinforceVehicleTypes[randomVehicleType]+1])--tex DEBUG
  return reinforceVehicleTypes[randomVehicleType]
end

return this