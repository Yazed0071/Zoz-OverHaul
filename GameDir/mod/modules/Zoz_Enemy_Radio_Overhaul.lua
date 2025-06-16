local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local missionID = TppMission.GetMissionID()
local PHASE_ALERT = TppGameObject.PHASE_ALERT
local PHASE_EVASION = TppGameObject.PHASE_EVASION
local PHASE_CAUTION = TppGameObject.PHASE_CAUTION
local PHASE_SNEAK = TppGameObject.PHASE_SNEAK

local NULL_ID = GameObject.NULL_ID



function this.OnAllocate()end
function this.OnInitialize()end


this.registerIvars= {
	-- Enemy_Radio
	"Zoz_Enemy_Radio_Report_Broken_Communication",
	"Zoz_Enemy_Radio_Extra_Camera_Lines",
	"Zoz_Enemy_Radio_Report_UAV_Down",
	"Zoz_Enemy_Radio_Repeat_Last",
	"Zoz_Enemy_Radio_Cancel_Prisoner_Search",
	"Zoz_Enemy_Radio_Report_Damage_From_Gunship",
	"Zoz_Enemy_Radio_Announce_Shift_Change",
}

this.langStrings={
	eng={
		Zoz_Enemy_Radio_Report_Broken_Communication = "CP Report broken Communication equipment",
		Zoz_Enemy_Radio_Extra_Camera_Lines = "Extra CCTV and UAV Lines",
		Zoz_Enemy_Radio_Report_UAV_Down = "CP Report UAV down",
		Zoz_Enemy_Radio_Repeat_Last = "CP Request repeat",
		Zoz_Enemy_Radio_Cancel_Prisoner_Search = "Request to cancel the search of a prisoner",
		Zoz_Enemy_Radio_Report_Damage_From_Gunship = "Report fire from enemy gunship",
		Zoz_Enemy_Radio_Announce_Shift_Change = "Announce Shift Change",
	},
	help={
		eng={
			Zoz_Enemy_Radio_Report_Broken_Communication = "The CP will report the Communication equipment was destroyed and enemy soldiers will go to Alert statue (Caution Phase)",
			Zoz_Enemy_Radio_Extra_Camera_Lines = "Adds an extra line when spotted by a security camera or UAV",
			Zoz_Enemy_Radio_Report_UAV_Down = "CP will report that a UAV was destroyed and enemy soldiers will go to Alert statue (Caution Phase)",
			Zoz_Enemy_Radio_Repeat_Last = "CP will ask the soldier to repeat if a radio call wasn't successful during Combat (Alert Phase)",
			Zoz_Enemy_Radio_Cancel_Prisoner_Search = "Enemy soldier will request to cancel the search of a lost prisoner 3 minutes after he was reported (Only SIDE OPS)",
			Zoz_Enemy_Radio_Report_Damage_From_Gunship = "Soldiers will report to CP when they get damaged from support heli",
			Zoz_Enemy_Radio_Announce_Shift_Change = "CP will announce shift changes",
		},
	},
}

this.Zoz_Enemy_Radio_Report_Broken_Communication={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Enemy_Radio_Extra_Camera_Lines={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Enemy_Radio_Report_UAV_Down={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Enemy_Radio_Repeat_Last={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Enemy_Radio_Cancel_Prisoner_Search={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Enemy_Radio_Report_Damage_From_Gunship={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Enemy_Radio_Announce_Shift_Change={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}


function this.Messages()
    return StrCode32Table{
		GameObject = {
			{
				msg = "BreakGimmick",
				func = function( gameObjectId , gameObjectName , name, attackerId)
					if gameObjectName == StrCode32("afgh_cmmn002_cmmn001_gim_n0000|srt_afgh_cmmn002_cmmn001") -- if TppGimmick.GIMMICK_TYPE.CMMN then doesn't work :(
						or gameObjectName == StrCode32("afgh_cmmn002_cmmn002_gim_n_0000|srt_afgh_cmmn002_cmmn002") -- some share the exact same locator name.
						or gameObjectName == StrCode32("afgh_cmmn002_cmmn002_gim_n0000|srt_afgh_cmmn002_cmmn002")
						or gameObjectName == StrCode32("afgh_cmmn002_cmmn001_gim_n0001|srt_afgh_cmmn002_cmmn001") and not GkEventTimerManager.IsTimerActive("code102useable") then
						GkEventTimerManager.Start("code102useable", 3)
					end
				end
			},
			{
				msg = "RadioEnd",
				func = function ( gameObjectId, cpGameObjectId, speechLabel, isSuccess )
					if speechLabel == StrCode32( "CPR0022" ) or speechLabel == 3691244289 then -- when spotted by camera and UAV only
						if Ivars.Zoz_Enemy_Radio_Extra_Camera_Lines:Is(1) then
							Zoz_Enemy_Overhaul.PlayCPOnlyRadio("CPR0022_1") -- Responding to intruder!
						end
					elseif speechLabel == StrCode32( "ZOZ0000" ) or speechLabel == StrCode32( "ZOZ_CPR0037_0" ) or speechLabel == StrCode32( "ZOZ_CPR0037_1" ) and Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT) and Zoz_overhaul_Ivars.IsNotPhase(PHASE_EVASION) then
						GameObject.SendCommand( Zoz_overhaul_Ivars.getClosestCp(), { id = "SetPhase", phase = TppGameObject.PHASE_CAUTION } )

						local e=Zoz_overhaul_Ivars.GetCpSubType(Zoz_overhaul_Ivars.getClosestCp())
  						local n="cmmn_ene_soviet"
  						if e=="SOVIET_A"or e=="SOVIET_B"then
  						  n="cmmn_ene_soviet"
  						elseif e=="PF_A"then
  						  n="cmmn_ene_cfa"
  						elseif e=="PF_B"then
  						  n="cmmn_ene_zrs"
  						elseif e=="PF_C"then
  						  n="cmmn_ene_coyote"
  						elseif e=="DD_A"then
  						  return
  						elseif e=="DD_PW"then
  						  n="cmmn_ene_pf"
  						elseif e=="DD_FOB"then
  						  n="cmmn_ene_pf"
  						elseif e=="SKULL_AFGH"then
  						  n="cmmn_ene_xof"
  						else
  						  return
  						end
  						TppUiCommand.AnnounceLogViewLangId("announce_phase_to_caution",n)
					elseif isSuccess ~= 1 and not Tpp.IsNotAlert() and Ivars.Zoz_Enemy_Radio_Repeat_Last:Is(1) then
						Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ_CPI0110")-- Repeat that last
					elseif isSuccess and speechLabel == StrCode32( "CPR0230" ) or speechLabel == StrCode32( "CPR0250" ) or speechLabel == StrCode32( "CPR0270" ) then
						GkEventTimerManager.Start("Announce_PrisonerNotFound", 180)
						InfCore.Log("Zoz_Overhaul Log: Timer Announce_PrisonerNotFound Start")
					end
				end
			},
			{
				msg = "Neutralize",
				func = function(gameObjectId, attackerId, neutralizeType, neutralizeCause)
					if Tpp.IsUav(gameObjectId) and Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT) and Zoz_overhaul_Ivars.IsNotPhase(PHASE_EVASION) and Ivars.Zoz_Enemy_Radio_Report_UAV_Down:Is(1) then
						GkEventTimerManager.Start("Announce_UAVFeedDown", 6)
					end
				end
			},
			{
				msg = "Damage",
				func = function (damagedId, attackId, attackerId, damageMessageFlag)
					if Ivars.Zoz_Enemy_Radio_Report_Damage_From_Gunship:Is(1) then
						if Tpp.IsSoldier(damagedId) then 
							if mvars.gunShipReported == false and attackerId == 7168 or attackerId == 0 and attackId == 269 and mvars.gunShipReported == false then -- heli or player and ATK_HeliMiniGun
								mvars.gunShipReported = true
								GkEventTimerManager.Start("gunShipReported_Timer", 5)
							end
						end
					end
				end
			},
		},
		Timer = {
			{ 	msg = "Finish",
				sender = "Announce_UAVFeedDown",
				func = 	function()
					Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ0000") -- UAV Feed is down 
				end
			},
			{ 	msg = "Finish",
				sender = "gunShipReported_Timer",
				func = 	function()
					Zoz_Enemy_Overhaul.PlayCPOnlyRadio("CPR0210") -- Taking fire by enemy gunship!
				end
			},
			{ 	msg = "Finish",
				sender = "code102useable",
				func = 	function()
					if Ivars.Zoz_Enemy_Radio_Report_Broken_Communication:Is(1) then
						if Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT) then
							local options = {"ZOZ_CPR0037_0", "ZOZ_CPR0037_1"}
							Zoz_Enemy_Overhaul.PlayCPOnlyRadio(options[math.random(#options)]) -- CODE 102/ NETWORK DOWN
						else
							Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ_CPR0038_1") -- CODE 102! CODE 102!
						end
					end
				end
			},
			{ 	msg = "Finish",
				sender = "Announce_PrisonerNotFound",
				func = 	function()
					InfCore.Log("Zoz_Overhaul Log: Timer Announce_PrisonerNotFound Finish")
					if Ivars.Zoz_Enemy_Radio_Cancel_Prisoner_Search:Is(1) then
						if Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT) or Zoz_overhaul_Ivars.IsNotPhase(PHASE_EVASION) and not (missionID >= 10010) or not (missionID <= 11151 ) then
							InfCore.Log("Zoz_Overhaul Log: Second")
							local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", Zoz_Enemy_Overhaul.GetClosestSoldier() )
							if not Zoz_Enemy_Overhaul.IsCanCommunicate(gameObjectId) then
								Zoz_Enemy_Overhaul.PlayCPOnlyRadio("CPR0081") -- no sign of prisoner standing down
								InfCore.Log("Zoz_Overhaul Log: CannotCommunicate")
							else
								InfCore.Log("Zoz_Overhaul Log: IsCanNotCanCommunicate")
								local command = { id="CallRadio", label="CPR0081", stance="Stand", isHqRadio=false } -- no sign of prisoner standing down
								GameObject.SendCommand( gameObjectId, command )
							end
						end
					end
				end
			},
			{ 	msg = "Finish",
				sender = "Announce_ShiftChange",
				func = 	function()
					if Ivars.Zoz_Enemy_Radio_Announce_Shift_Change:Is(1) and not Zoz_overhaul_Ivars.IsNotPhase(PHASE_SNEAK) then
						Zoz_Enemy_Overhaul.PlayCPOnlyRadio("CPR0330") -- Situation normal: Announcing shift change
					end
				end
			},
		},
		Weather={
			{
				msg="Clock",sender="ShiftChangeAtMorning",func=function(n,n)
					GkEventTimerManager.Start("Announce_ShiftChange", 10)
				end
			},
			{
				msg="Clock",sender="ShiftChangeAtNight",func=function(n,n)
					GkEventTimerManager.Start("Announce_ShiftChange", 10)
				end
			},

			{
				msg="Clock",sender="ShiftChangeAtMidNight",func=function(n,n)
					GkEventTimerManager.Start("Announce_ShiftChange", 10)
				end
			}
		},
		Block = {
			{
				msg = "OnScriptBlockStateTransition",
				func = function(blockName, blockState)
					if blockName == StrCode32( "reinforce_block" ) and blockState == ScriptBlock.TRANSITION_ACTIVATED then
						InfCore.Log("Zoz_Overhaul Log: RequestLoadReinforce")
						if TppReinforceBlock._HasVehicle() then
							if mvars.reinforce_reinforceType==TppReinforceBlock.REINFORCE_TYPE.EAST_TANK or mvars.reinforce_reinforceType==TppReinforceBlock.REINFORCE_TYPE.WEST_TANK then
								Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ_HQR0110") -- : HQ has deployed tank
							else
								Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ_HQR0120") -- : HQ has deployed armored vehicle
							end
						else
							Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ_HQR0100") -- : HQ has deployed helicopter
						end
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

function this.Init(missionTable)
	if TppMission.IsFOBMission(vars.missionCode) then
		return
	end
	mvars.RequestLoadReinforceVehicle = false
	mvars.gunShipReported = false
	this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end


function this.OnLoad()
	InfCore.Log("Zoz_Overhaul Log: Zoz_Support_Enemy_Overhaul.OnLoad()")
end

return this