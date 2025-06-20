local this = {}
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

this.registerIvars={
	"Zoz_Enemy_Voice_Enemy_Reaction_Player_Vehicle",
    "Zoz_Enemy_Voice_Enemy_Reaction_Player_Aim",
    "Zoz_Enemy_Voice_Enemy_Reaction_Player_RPG",
    "Zoz_Enemy_Voice_Enemy_Player_Restrain",
    "Zoz_Enemy_Voice_Enemy_Surrender",
}

this.langStrings={
	eng={
		Zoz_Enemy_Voice_Enemy_Reaction_Player_Vehicle = "Enemy react to Player's Vehicle",
        Zoz_Enemy_Voice_Enemy_Reaction_Player_Aim = "Enemy react to Player when in Hold up",
        Zoz_Enemy_Voice_Enemy_Reaction_Player_RPG = "Enemy react to Player when aiming an RPG",
        Zoz_Enemy_Voice_Enemy_Player_Restrain = "Enemy react to restrain",
        Zoz_Enemy_Voice_Enemy_Surrender = "Enemy Surrender",
	},
	help={
		eng={
			
            Zoz_Enemy_Voice_Enemy_Reaction_Player_Vehicle = "Enemy will react to Player's Vehicle\nArmored Vehicle and tank only",
            Zoz_Enemy_Voice_Enemy_Reaction_Player_Aim = "Enemy will react to the player aiming at them during a hold up",
            Zoz_Enemy_Voice_Enemy_Reaction_Player_RPG = "Enemy react to Player when aiming an RPG\n has 15 seconds cooldown",
            Zoz_Enemy_Voice_Enemy_Player_Restrain = "Enemy will react to the player when restraining them during Alert Phase",
            Zoz_Enemy_Voice_Enemy_Surrender = "Enemy will surrender when they are the last.\nThis will depend on their combat level.\nLevel 1 and 2: 75% chance\nLevel 3: 50% chance\nLevel 4 and 5: 25% chance\nFully armored enemies will never surrender",
		}
	}
}

this.Zoz_Enemy_Voice_Enemy_Reaction_Player_Vehicle={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Enemy_Voice_Enemy_Reaction_Player_Aim={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Enemy_Voice_Enemy_Player_Restrain={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}
this.Zoz_Enemy_Voice_Enemy_Surrender={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
} 
this.Zoz_Enemy_Voice_Enemy_Reaction_Player_RPG={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=1,
}

function this.OnAllocate()end
function this.OnInitialize()end

function this.SetEnableSendMessageAimedFromPlayer()
	for cpName, cpSoldiers in pairs(mvars.ene_soldierDefine) do
        for index, soldierName in ipairs(cpSoldiers) do
            if GetGameObjectId(soldierName)~=GameObject.NULL_ID  then
                local gameObjectId = GetGameObjectId( soldierName )
				SendCommand( gameObjectId, { id = "SetEnableSendMessageAimedFromPlayer", enabled=true } )
            end
        end
    end
end

function this.GetAllAliveSoldiersInCp()

	mvars.aliveSoldierName = nil
	local enemyAlive = 0
	local enemyNeutralized = 0

	for cpName, cpSoldiers in pairs(mvars.ene_soldierDefine) do
		if GetGameObjectId(cpName) == Zoz_Overhaul.getClosestCp() then
			InfCore.Log("Zoz Log: cpName: " .. tostring(cpName))
			for _, soldierName in ipairs(cpSoldiers) do
				if not TppEnemy.IsNeutralized(soldierName) then
					InfCore.Log("Zoz Log: enemyAlive: " .. tostring(soldierName))
					enemyAlive = enemyAlive + 1
					if enemyAlive == 1 then
						mvars.aliveSoldierName = soldierName
					end
				else
					InfCore.Log("Zoz Log: enemyNeutralized: " .. tostring(soldierName))
					enemyNeutralized = enemyNeutralized + 1
				end
			end
		end
	end

	return enemyAlive
end

function this.SetSoldierSurrender(soldierId)
	InfCore.Log("Zoz Log: Zoz_Enemy_Voice_Overhaul.SetSoldierSurrender() Enter")
	if not Tpp.IsSoldier(soldierId) then
		return
	end
	if Ivars.Zoz_Enemy_Voice_Enemy_Surrender:Is(0) then
		return
	end

	local makeSurrender = function ()
		InfCore.Log("Zoz Log: local this.makeSurrender Enter")
		if mvars.aliveSoldierName then
			local gameObjectId = GetGameObjectId("TppSoldier2", mvars.aliveSoldierName)

			if not Zoz_Overhaul.IsNotPhase(PHASE_ALERT) then
				SendCommand(gameObjectId, { id = "SetForceHoldup" })
				InfCore.Log("Zoz Log: SetForceHoldup: " .. tostring(mvars.aliveSoldierName))
				SendCommand(gameObjectId, { id = "SetEverDown", enabled = true })
				GkEventTimerManager.Start("Soldier_GiveUp", 2)
			end
		end
	end

	if not Zoz_Overhaul.IsNotPhase(PHASE_ALERT) and this.GetAllAliveSoldiersInCp() == 1 then
		if not TppEnemy.IsArmor(mvars.aliveSoldierName) then
			local randomValue = math.random(1, 100)
			InfCore.Log("Zoz Log: randomValue == " .. randomValue)
			InfCore.Log("Zoz Log: TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) == " .. TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT))

			local revengeLevel = TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT)
			InfCore.Log("Zoz Log: GetDistanceFromPlayer == " .. Zoz_Enemy_Overhaul.GetDistanceFromPlayer( mvars.aliveSoldierName, "TppSoldier2" ))
			if Zoz_Enemy_Overhaul.GetDistanceFromPlayer( mvars.aliveSoldierName, "TppSoldier2" ) > 411.8 then -- Around 20m
				InfCore.Log"Zoz Log: wow soldier too far"
			elseif revengeLevel < 3 and randomValue >= 25 then
				makeSurrender()
			elseif revengeLevel == 3 and randomValue <= 50 then
				makeSurrender()
			elseif revengeLevel > 3 and randomValue <= 25 then
				makeSurrender()
			else
				InfCore.Log"Zoz Log: wow soldier very brave"
			end
		end
	end
	InfCore.Log("Zoz Log: Zoz_Enemy_Voice_Overhaul.SetSoldierSurrender() Exit")
end



function this.CheckEnemyDistance(gameObjectId)


	Fox.Log("::Get GameObject Pos")
	local gameObjectId =  gameObjectId 
	local command = { id = "GetPosition" }
	local position = SendCommand( gameObjectId, command )

	if position == nil then
		return
	end

	local point1 = TppMath.Vector3toTable( position )
	local point2 = TppPlayer.GetPosition()

	Fox.Log("position1 = "..point1[1]..","..point1[2]..","..point1[3])
	Fox.Log("position2 = "..point2[1]..","..point2[2]..","..point2[3])

	local dist = TppMath.FindDistance( point1, point2 )
	Fox.Log("dist : "..dist )
	return dist

end

this.GetStatus = function( enemyName )

	if IsTypeString( enemyName ) then
		enemyName = GetGameObjectId( enemyName )
	end
	
	local Status = SendCommand( enemyName, { id = "GetStatus" } )
	
	return Status
end


function this.Messages()
    return StrCode32Table{
		GameObject = {
			{
				msg = "ChangePhase",
				func = function(gameObjectId,phaseId,oldPhaseId)
					if phaseId == TppGameObject.PHASE_ALERT and Ivars.Zoz_Enemy_Voice_Enemy_Reaction_Player_Vehicle:Is(1) then
						if PlayerInfo.OrCheckStatus{PlayerStatusEx.ON_APC} then
							Zoz_Enemy_Overhaul.GetClosestSoldierSpeak("EVR085")
						elseif PlayerInfo.OrCheckStatus{PlayerStatusEx.ON_TANK} then
							Zoz_Enemy_Overhaul.GetClosestSoldierSpeak("EVR084")
						end
					end
				end
			},
			{
				msg = "AimedFromPlayer",
				func = function(AimedAt,isFound)
					local distance = this.CheckEnemyDistance(AimedAt)
					local status= this.GetStatus(AimedAt)
					if status == EnemyState.STAND_HOLDUP and distance <=20 and SendCommand(AimedAt,{id="IsDoneHoldup"}) and not GkEventTimerManager.IsTimerActive("HoldUp_EV_Cooldowwn") and Ivars.Zoz_Enemy_Voice_Enemy_Reaction_Player_Aim:Is(1) then
						local gameObjectId = AimedAt
						local command = { id="CallVoice", dialogueName="DD_vox_ene", parameter= "EVR071" }
						SendCommand( gameObjectId, command )
						GkEventTimerManager.Start("HoldUp_EV_Cooldowwn", 5)
					end
				end
			},
			{
				msg = "Restraint",
				func = function (soldierId, releaseType, restraintType)
					if Ivars.Zoz_Enemy_Voice_Enemy_Player_Restrain:Is(0) then
						return
					end
					if releaseType == 0 then
						mvars.IsEnemyRestrained = true
					else
						mvars.IsEnemyRestrained = false
					end
					InfCore.Log("Zoz Log: GameObject msg = \"Restraint\",")
					mvars.zoz_restrained_sol = soldierId

					InfCore.Log("Zoz Log: TppGameObject.NPC_STATE_NORMAL")
					GkEventTimerManager.Start("HoldUp_EV_Cooldowwn", 3)
					GkEventTimerManager.Start("SoldierSpeak_Restrained", 5)
				end
			},
			{
				msg = "Neutralize",
				func = function (gameId, attackerId, neutralizeType, neutralizeCause)
					this.SetSoldierSurrender(gameId)
				end
			},
			{
				msg = "Conscious",
				func = function (gameId, wakerUpper, arg2)
					this.SetSoldierSurrender(gameId)
				end
			},
			{
				msg = "Dying",
				func = function (soldierId, attackerId)
					this.SetSoldierSurrender(soldierId)
				end
			},
			{
				msg = "RadioEnd",
				func = function ( gameObjectId, cpGameObjectId, speechLabel, isSuccess )
					if speechLabel == StrCode32( "CPR0130" ) or speechLabel == StrCode32("CPR0038") then
						Zoz_Enemy_Overhaul.GetClosestSoldierSpeak("EVR190") -- DAAAMNM ITTTT
					end
				end
			},

			{
				msg = "SaluteRaiseMorale",
				func = function (saluter)
					mvars.MtbsSaluter = saluter
				end
			}
		},
		Timer = {
			{
				msg = "Finish", sender = "HoldUp_EV_Cooldowwn",
				func = function ()
					
				end
			},
			{
				msg = "Finish", sender = "Soldier_GiveUp",
				func = function ()
					local gameObjectId = GetGameObjectId("TppSoldier2", mvars.aliveSoldierName)
					SendCommand( gameObjectId, { id = "CallVoice", dialogueName = "DD_vox_ene", parameter= "EVC440" } ) --・EVC440:Don't shoot; Soldier surrenders to the player after his surrounding comrades are all eliminated.
				end
			},
			{
				msg = "Finish", sender = "SoldierSpeak_Restrained",
				func = function ()
					if not Tpp.IsNotAlert() and mvars.IsEnemyRestrained then
						GkEventTimerManager.Start("EVC420_Timer", 3)
						if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) <= 3 then
							Zoz_Enemy_Overhaul.GetClosestSoldierCQC("EVC430")
						else
							Zoz_Enemy_Overhaul.GetClosestSoldierCQC("EVC431")
						end
					end
				end
			},
			{
				msg = "Finish", sender = "EVC420_Timer",
				func = function ()
					if not Tpp.IsNotAlert() and mvars.IsEnemyRestrained then
						Zoz_Enemy_Overhaul.GetSecondClosestSoldierSpeak("EVC420")
						
					end
				end
			},
			{
				msg = "Finish", sender = "EVF030_Timer",
				func = function ()
					mvars.MtbsSaluter = nil
				end
			},
		},
		Player = {
			{
				msg = "PlayerHoldWeapon",
				func = function (equipId, equipType, hasGunLight, isSheild)
					if Ivars.Zoz_Enemy_Voice_Enemy_Reaction_Player_RPG:Is(1) then
						if equipType == TppEquip.EQP_TYPE_Missile and not Tpp.IsNotAlert() and not GkEventTimerManager.IsTimerActive("EVR083_Timer") then -- EQP_TYPE_Missile
							Zoz_Enemy_Overhaul.GetClosestSoldierSpeak("EVR083") -- INCOMING!!
							GkEventTimerManager.Start("EVR083_Timer", 15)
						end
					end
				end
			},
			{
				msg = "OnPlayerStaminaOut",
				func = function (playerIndex, isSelfInflicted)
					if TppLocation.IsMotherBase()then
						if isSelfInflicted and Zoz_Enemy_Overhaul.GetClosestFromPlayer(mvars.MtbsSaluter) < 20 then
							GkEventTimerManager.Start("EVF030_Timer", 15)
							Zoz_Enemy_Overhaul.GetClosestSoldierSpeak("EVF030") -- Boss, I don't think that's...
						end
					end
				end
			},
			{
				msg = "PlayerDamaged",
				func = function (playerIndex, attackId, attackerId)
					if TppLocation.IsMotherBase() and mvars.MtbsSaluter ~= nil then
						if Zoz_Enemy_Overhaul.GetClosestFromPlayer(mvars.MtbsSaluter) < 20 then
							GkEventTimerManager.Start("EVF030_Timer", 15)
							if attackId == TppDamage.ATK_PushPlayer then -- From Ocelot mostly
								Zoz_Enemy_Overhaul.GetClosestSoldierSpeak("EVR220")
							else
								Zoz_Enemy_Overhaul.GetClosestSoldierSpeak("EVF030") -- Boss, I don't think that's...
							end
						end
					end
				end
			},
		},
    }
end

function this.SetUpEnemy()
	if TppMission.IsFOBMission(vars.missionCode) then
		return
	end
	if not GameObject.DoesGameObjectExistWithTypeName"TppSoldier2" then
		return
	end
	this.SetEnableSendMessageAimedFromPlayer()
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
	mvars.IsEnemyRestrained = false
	this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end


function this.OnLoad()
	InfCore.Log("Zoz_Overhaul Log: Zoz_Support_Enemy_Voice_Overhaul.OnLoad()")
end

return this