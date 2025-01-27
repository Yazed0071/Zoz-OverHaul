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

function this.LoadLibraries()
    InfCore.Log("Zoz_Overhaul Log: Overriding ShowAnnounceLog")
    local ShowAnnounceLog = TppUI.ShowAnnounceLog
    TppUI.ShowAnnounceLog = function(announceId,param1,param2,delayTime,missionSubGoalNumber)
        InfCore.Log("Zoz_Overhaul Log: ShowAnnounceLog called - "..tostring(announceId)..
                    " p1:"..tostring(param1).." p2:"..tostring(param2))
        ShowAnnounceLog(announceId,param1,param2,delayTime,missionSubGoalNumber)
        if announceId == "quest_delete" then
            InfCore.Log("Zoz_Overhaul Log: Quest deleted notification handled")
        end
    end
end

function this.Messages()
    return StrCode32Table{
        GameObject = {
            {
                msg = "BreakGimmick",
                func = function(gameObjectId, gameObjectName, name, attackerId)
                    InfCore.Log("Zoz_Overhaul Log: BreakGimmick - "..tostring(gameObjectName)..
                                " by attacker:"..tostring(attackerId))
                    if gameObjectName == StrCode32("afgh_cmmn002_cmmn001_gim_n0000|srt_afgh_cmmn002_cmmn001")
                        or gameObjectName == StrCode32("afgh_cmmn002_cmmn002_gim_n_0000|srt_afgh_cmmn002_cmmn002")
                        or gameObjectName == StrCode32("afgh_cmmn002_cmmn002_gim_n0000|srt_afgh_cmmn002_cmmn002")
                        or gameObjectName == StrCode32("afgh_cmmn002_cmmn001_gim_n0001|srt_afgh_cmmn002_cmmn001")
                        and not GkEventTimerManager.IsTimerActive("code102useable") then
                        InfCore.Log("Zoz_Overhaul Log: Starting code102useable timer")
                        GkEventTimerManager.Start("code102useable", 3)
                    end
                end
            },
            {
                msg = "RadioEnd",
                func = function(gameObjectId, cpGameObjectId, speechLabel, isSuccess)
                    InfCore.Log("Zoz_Overhaul Log: RadioEnd - label:"..tostring(speechLabel)..
                                " success:"..tostring(isSuccess))
                    if speechLabel == StrCode32("CPR0022") or speechLabel == 3691244289 then
                        InfCore.Log("Zoz_Overhaul Log: Handling camera/UAV radio end")
                        if Ivars.Zoz_Enemy_Radio_Extra_Camera_Lines:Is(1) then
                            Zoz_Enemy_Overhaul.PlayCPOnlyRadio("CPR0022_1")
                        end
                    elseif speechLabel == StrCode32("ZOZ0000") or speechLabel == StrCode32("ZOZ_CPR0037_0") 
                        or speechLabel == StrCode32("ZOZ_CPR0037_1") 
                        and Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT) 
                        and Zoz_overhaul_Ivars.IsNotPhase(PHASE_EVASION) then
                        InfCore.Log("Zoz_Overhaul Log: Setting phase to CAUTION")
                        GameObject.SendCommand(Zoz_overhaul_Ivars.getClosestCp(), { id = "SetPhase", phase = TppGameObject.PHASE_CAUTION })

                        local cpSubType = Zoz_overhaul_Ivars.GetCpSubType(Zoz_overhaul_Ivars.getClosestCp())
                        InfCore.Log("Zoz_Overhaul Log: CP SubType - "..tostring(cpSubType))
                        local factionName = "cmmn_ene_soviet"
                        if cpSubType == "SOVIET_A" or cpSubType == "SOVIET_B" then
                            factionName = "cmmn_ene_soviet"
                        elseif cpSubType == "PF_A" then
                            factionName = "cmmn_ene_cfa"
                        elseif cpSubType == "PF_B" then
                            factionName = "cmmn_ene_zrs"
                        elseif cpSubType == "PF_C" then
                            factionName = "cmmn_ene_coyote"
                        elseif cpSubType == "DD_A" then
                            InfCore.Log("Zoz_Overhaul Log: Skipping DD_A faction")
                            return
                        elseif cpSubType == "DD_PW" or cpSubType == "DD_FOB" then
                            factionName = "cmmn_ene_pf"
                        elseif cpSubType == "SKULL_AFGH" then
                            factionName = "cmmn_ene_xof"
                        else
                            InfCore.Log("Zoz_Overhaul Log: Unknown faction type - "..tostring(cpSubType))
                            return
                        end
                        InfCore.Log("Zoz_Overhaul Log: Announcing phase change for "..factionName)
                        TppUiCommand.AnnounceLogViewLangId("announce_phase_to_caution", factionName)
                    elseif isSuccess ~= 1 and not Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT) 
                        and Ivars.Zoz_Enemy_Radio_Repeat_Last:Is(1) 
                        and not (vars.locationCode == TppDefine.LOCATION_ID.GNTN) then
                        InfCore.Log("Zoz_Overhaul Log: Repeating last radio message")
                        Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ_CPI0110")
                    elseif isSuccess and (speechLabel == StrCode32("CPR0230") 
                        or speechLabel == StrCode32("CPR0250") 
                        or speechLabel == StrCode32("CPR0270")) 
                        and TppMission.IsFreeMission(vars.missionCode) 
                        and Ivars.Zoz_Enemy_Radio_Cancel_Prisoner_Search:Is(1) then
                        InfCore.Log("Zoz_Overhaul Log: Starting prisoner search timer")
                        GkEventTimerManager.Start("Announce_PrisonerNotFound", 180)
                    end
                end
            },
            {
                msg = "Neutralize",
                func = function(gameObjectId, attackerId, neutralizeType, neutralizeCause)
                    InfCore.Log(string.format("Zoz_Overhaul Log: Neutralize - ID:%s Type:%s Cause:%s", 
                        tostring(gameObjectId), tostring(neutralizeType), tostring(neutralizeCause)))
                    if Tpp.IsUav(gameObjectId) and Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT) 
                        and Zoz_overhaul_Ivars.IsNotPhase(PHASE_EVASION) 
                        and Ivars.Zoz_Enemy_Radio_Report_UAV_Down:Is(1) then
                        InfCore.Log("Zoz_Overhaul Log: UAV neutralized - sending report")
                        Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ0000")
                    end
                end
            },
            {
                msg = "Damage",
                func = function(damagedId, attackId, attackerId, damageMessageFlag)
                    InfCore.Log(string.format("Zoz_Overhaul Log: Damage - Target:%s Attacker:%s AttackType:%s", 
                        tostring(damagedId), tostring(attackerId), tostring(attackId)))
                    if Ivars.Zoz_Enemy_Radio_Report_Damage_From_Gunship:Is(1) then
                        if Tpp.IsSoldier(damagedId) then 
                            if (attackerId == 7168 or attackerId == 0) and attackId == 269 
                                and not mvars.gunShipReported then
                                InfCore.Log("Zoz_Overhaul Log: Gunship damage detected - starting report timer")
                                mvars.gunShipReported = true
                                GkEventTimerManager.Start("gunShipReported_Timer", 5)
                            end
                        end
                    end
                end
            },
            {
                msg = "RequestLoadReinforce",
                func = function()
                    InfCore.Log("Zoz_Overhaul Log: Reinforce requested - Vehicle:"..
                                tostring(mvars.RequestLoadReinforceVehicle))
                    if not mvars.RequestLoadReinforceVehicle then
                        mvars.RequestLoadReinforceVehicle = true
                        if TppReinforceBlock._HasHeli() then
                            InfCore.Log("Zoz_Overhaul Log: Helicopter reinforcement")
                            Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ_HQR0100")
                        elseif TppReinforceBlock._HasVehicle() then
                            InfCore.Log("Zoz_Overhaul Log: Vehicle reinforcement - Type:"..
                                        tostring(mvars.reinforce_reinforceType))
                            if mvars.reinforce_reinforceType == TppReinforceBlock.REINFORCE_TYPE.EAST_TANK 
                                or mvars.reinforce_reinforceType == TppReinforceBlock.REINFORCE_TYPE.WEST_TANK then
                                Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ_HQR0110")
                            else
                                Zoz_Enemy_Overhaul.PlayCPOnlyRadio("ZOZ_HQR0120")
                            end
                        end
                    end 
                end,
            },
        },
        Timer = {
            {   msg = "Finish",
                sender = "gunShipReported_Timer",
                func = function()
                    InfCore.Log("Zoz_Overhaul Log: Gunship report timer completed")
                    Zoz_Enemy_Overhaul.PlayCPOnlyRadio("CPR0210")
                end
            },
            {   msg = "Finish",
                sender = "code102useable",
                func = function()
                    InfCore.Log("Zoz_Overhaul Log: code102useable timer completed - PhaseAlert:"..
                                tostring(Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT)))
                    if Ivars.Zoz_Enemy_Radio_Report_Broken_Communication:Is(1) then
                        if Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT) then
                            local options = {"ZOZ_CPR0037_0", "ZOZ_CPR0037_1"}
                            local selected = options[math.random(#options)]
                            InfCore.Log("Zoz_Overhaul Log: Selecting radio option - "..selected)
                            Zoz_Enemy_Overhaul.PlayCPOnlyRadio(selected)
                        else
                            local options = {"CPR0038", "ZOZ_CPR0038_1"}
                            local selected = options[math.random(#options)]
                            InfCore.Log("Zoz_Overhaul Log: Alert phase radio option - "..selected)
                            Zoz_Enemy_Overhaul.PlayCPOnlyRadio(selected)
                        end
                    end
                end
            },
            {   msg = "Finish",
                sender = "Announce_PrisonerNotFound",
                func = function()
                    InfCore.Log("Zoz_Overhaul Log: Prisoner search timer completed - CurrentPhase:"..
                                TppGameObject.GetPhaseName(vars.playerPhase))
                    if Zoz_overhaul_Ivars.IsNotPhase(PHASE_ALERT) 
                        or Zoz_overhaul_Ivars.IsNotPhase(PHASE_EVASION) 
                        and TppMission.IsFreeMission(vars.missionCode) then
                        local closestSoldier = Zoz_Enemy_Overhaul.GetClosestSoldier()
                        InfCore.Log("Zoz_Overhaul Log: Closest soldier ID:"..tostring(closestSoldier))
                        local gameObjectId = GameObject.GetGameObjectId("TppSoldier2", closestSoldier)
                        
                        if not Zoz_Enemy_Overhaul.IsCanCommunicate(gameObjectId) then
                            InfCore.Log("Zoz_Overhaul Log: Soldier cannot communicate - sending HQ radio")
                            Zoz_Enemy_Overhaul.PlayCPOnlyRadio("CPR0081")
                        else
                            InfCore.Log("Zoz_Overhaul Log: Direct radio command to soldier")
                            local command = { 
                                id = "CallRadio", 
                                label = "CPR0081", 
                                stance = "Stand", 
                                isHqRadio = false 
                            }
                            GameObject.SendCommand(gameObjectId, command)
                        end
                    end
                end
            },
            {   msg = "Finish",
                sender = "Announce_ShiftChange",
                func = function()
                    InfCore.Log("Zoz_Overhaul Log: Handling shift change announcement")
                    if Ivars.Zoz_Enemy_Radio_Announce_Shift_Change:Is(1) 
                        and not Zoz_overhaul_Ivars.IsNotPhase(PHASE_SNEAK) then
                        Zoz_Enemy_Overhaul.PlayCPOnlyRadio("CPR0330")
                    end
                end
            },
        },
        Weather = {
            {
                msg = "Clock",
                sender = "ShiftChangeAtMorning",
                func = function(n,n)
                    InfCore.Log("Zoz_Overhaul Log: Morning shift change detected")
                    GkEventTimerManager.Start("Announce_ShiftChange", 10)
                end
            },
            {
                msg = "Clock",
                sender = "ShiftChangeAtNight",
                func = function(n,n)
                    InfCore.Log("Zoz_Overhaul Log: Night shift change detected")
                    GkEventTimerManager.Start("Announce_ShiftChange", 10)
                end
            },
            {
                msg = "Clock",
                sender = "ShiftChangeAtMidNight",
                func = function(n,n)
                    InfCore.Log("Zoz_Overhaul Log: Midnight shift change detected")
                    GkEventTimerManager.Start("Announce_ShiftChange", 10)
                end
            }
        },
    }
end

function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
    if TppMission.IsFOBMission(vars.missionCode) then
        InfCore.Log("Zoz_Overhaul Log: Skipping message handling for FOB mission")
        return
    end
    InfCore.Log("Zoz_Overhaul Log: Handling message - "..tostring(messageId)..
                " from "..tostring(sender))
    Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, 
        arg0, arg1, arg2, arg3, strLogText)
end

function this.Init(missionTable)
    InfCore.Log("Zoz_Overhaul Log: Initializing enemy overhaul - MissionID:"..tostring(missionID))
    if TppMission.IsFOBMission(vars.missionCode) then
        InfCore.Log("Zoz_Overhaul Log: Aborting init for FOB mission")
        return
    end
    InfCore.Log("Zoz_Overhaul Log: Initializing reinforcement variables")
    mvars.RequestLoadReinforceVehicle = false
    mvars.gunShipReported = false
    this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnLoad()
    InfCore.Log("Zoz_Overhaul Log: OnLoad() - Current mission code: "..tostring(vars.missionCode))
end

return this