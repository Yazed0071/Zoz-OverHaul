local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local missionID = TppMission.GetMissionID()

local NULL_ID = GameObject.NULL_ID


this.registerIvars={
    "Zoz_BGM_Phase_Select",
    "Zoz_BGM_Select_Stop",
}

this.langStrings={
	eng={
        Zoz_BGM_Phase_Select = "Select Phase BGM",
        Zoz_BGM_Select_Stop = "Stop BGM",
    },
    help={
		eng={
            Zoz_BGM_Phase_Select = "Select the desired Phase BGM and hit the action button!",
            Zoz_BGM_Select_Stop = "Stop the playing BGM, hit the action button!",
        }
    }
}

this.Zoz_BGM_Phase_List = {
	"None",
    "bgm_paz_escape",
	"bgm_MGR_Time",
	"bgm_Deja_Vu",
    "bgm_fob_neutral",
    "ITSTHEFREAKINBAT",
}

this.Zoz_BGM_Phase_Select = {
    save = IvarProc.CATEGORY_EXTERNAL,
    settings = this.Zoz_BGM_Phase_List,
    OnSelect = function(self)
        local newSettings = {}
        for _, Phase_List in ipairs(this.Zoz_BGM_Phase_List) do
            table.insert(newSettings, Phase_List)
        end
        self.settings = newSettings
    end,
    OnActivate = function(self, setting)
        TppSound.SetPhaseBGM(self.settings[setting + 1])

		InfCore.DebugPrint("Music selected!")
    end
}

this.Zoz_BGM_Select_Stop = {
    inMission=true,
    range={max=0},--DYNAMIC
    GetSettingText=function()
        return " "
    end,
    OnActivate = function(self, setting)
        TppSound.StopSceneBGM(Ivars.Zoz_BGM_Select)
		InfCore.DebugPrint("Music Stopped!")
        TppSound.ResetPhaseBGM()
    end
}


function this.OnAllocate()end
function this.OnInitialize()end

function this.PlayCPOnlyRadio(Label)
    if string.find(Zoz_overhaul_Ivars.getClosestCpString(), "_cp") then
        InfCore.Log("Zoz_Overhaul Log: Zoz_Support_Enemy_Overhaul.PlayCPOnlyRadio(" .. Label..") in CP: " .. Zoz_overhaul_Ivars.getClosestCpString())
        GameObject.SendCommand( Zoz_overhaul_Ivars.getClosestCp(),{ id = "RequestRadio", label=Label } )
    end
end

function this.GetSoldierList()
    local soldierList={}
    for cpName, cpSoldiers in pairs(mvars.ene_soldierDefine) do
        for index, soldierName in ipairs(cpSoldiers) do
            if GameObject.GetGameObjectId(soldierName)~=GameObject.NULL_ID and not TppEnemy.IsNeutralized(soldierName) then
                table.insert(soldierList,soldierName)
            end
        end
    end
    return soldierList
end

function this.GetClosestSoldierMath(gameObjectList)
    local playerPos=TppPlayer.GetPosition()
    local closestDist = 65526
    local closest
    for index, name in ipairs(gameObjectList) do
        local gameObjectId = GameObject.GetGameObjectId(name)
        local position = GameObject.SendCommand(gameObjectId, {id = "GetPosition"})
        position = TppMath.Vector3toTable(position)
        local distSqr = TppMath.FindDistance(playerPos,position)
        if distSqr < closestDist then
            closestDist = distSqr
            closest = name
        end
    end
    return closest
end

function this.GetClosestSoldier()
	local soldierList = this.GetSoldierList()
	local closestSoldierName = this.GetClosestSoldierMath(soldierList)
	return closestSoldierName
end

function this.IsCanCommunicate(gameObjectId)
    if gameObjectId==NULL_ID then
        InfCore.Log("Zoz_Overhaul Log: "..tostring(gameObjectId).." doesn't real")
        return false
    end
    if TppEnemy.IsNeutralized(gameObjectId) then
        InfCore.Log("Zoz_Overhaul Log: "..tostring(gameObjectId).." is neutralized")
        return false
    end
    local vehicleGameObjectId = GameObject.SendCommand(gameObjectId,{id="GetVehicleGameObjectId"})
    if vehicleGameObjectId~=NULL_ID then
        InfCore.Log("Zoz_Overhaul Log: "..tostring(gameObjectId).." rides "..tostring(vehicleGameObjectId))
        return false
    end
    return true
end

function this.GetClosestFromPlayer(SoldierId)
	local playerPos = {}
	playerPos = TppPlayer.GetPosition()

    if SoldierId == nil then
        return
    end
	local command = {
		id="GetPosition",
	}
	local enemyPosVector3 = GameObject.SendCommand(SoldierId, command)
	local enemyPos = {}
	enemyPos = TppMath.Vector3toTable( enemyPosVector3 )

	
	local distance = math.sqrt(TppMath.FindDistance( playerPos, enemyPos ))
    
    InfCore.Log("Zoz Log: DITANCE " .. distance)
	return distance
end

function this.GetClosestSoldierSpeak(label)
	local soldierList = this.GetSoldierList()
	local closestSoldierName = this.GetClosestSoldierMath(soldierList)
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", closestSoldierName )
	local command = { id = "CallVoice", dialogueName = "DD_vox_ene", parameter= label }
    
	GameObject.SendCommand( gameObjectId, command )
end


function this.GetSoldierListCQC()
    local soldierList={}
    for cpName, cpSoldiers in pairs(mvars.ene_soldierDefine) do
        for index, soldierName in ipairs(cpSoldiers) do
            if GameObject.GetGameObjectId(soldierName)~=GameObject.NULL_ID  then
                table.insert(soldierList,soldierName)
            end
        end
    end
    return soldierList
end

function this.GetClosestSoldierMathCQC(gameObjectList)
    local playerPos=TppPlayer.GetPosition()
    local closestDist=65526
    local closest
    for _, name in ipairs(gameObjectList) do
        local gameObjectId=GameObject.GetGameObjectId(name)
        local position=GameObject.SendCommand(gameObjectId, {id="GetPosition"})
        position=TppMath.Vector3toTable(position)
        local distSqr=TppMath.FindDistance(playerPos,position)
        if distSqr < closestDist then
            closestDist = distSqr
            closest = name
        end
    end
    return closest
end

function this.GetClosestSoldierCQC(label)
	local soldierList = this.GetSoldierListCQC()
	local closestSoldierName = this.GetClosestSoldierMathCQC(soldierList)
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", closestSoldierName )
	local command = { id="CallVoice", dialogueName="DD_vox_ene", parameter= label }
	if not TppEnemy.IsNeutralized(gameObjectId) then
		GameObject.SendCommand( gameObjectId, command )
	end
end

function this.GetSecondClosestSoldierMath(gameObjectList)
    local playerPos = TppPlayer.GetPosition()
    local closestDist = 65526
    local secondClosestDist = 65526
    local closest, secondClosest

    for index, name in ipairs(gameObjectList) do
        local gameObjectId = GameObject.GetGameObjectId(name)
        local position = GameObject.SendCommand(gameObjectId, { id = "GetPosition" })
        position = TppMath.Vector3toTable(position)
        local distSqr = TppMath.FindDistance(playerPos, position)

        -- Check for closest and second closest
        if distSqr < closestDist then
            secondClosestDist = closestDist
            secondClosest = closest
            closestDist = distSqr
            closest = name
        elseif distSqr < secondClosestDist then
            secondClosestDist = distSqr
            secondClosest = name
        end
    end

    return secondClosest
end


function this.GetSecondClosestSoldierSpeak(label)
    local soldierList = this.GetSoldierList()
    local secondClosestSoldierName = this.GetSecondClosestSoldierMath(soldierList)

    if secondClosestSoldierName then
        local gameObjectId = GameObject.GetGameObjectId("TppSoldier2", secondClosestSoldierName)
        local command = { id = "CallVoice", dialogueName = "DD_vox_ene", parameter = label }
        GameObject.SendCommand(gameObjectId, command)
    else
        InfCore.Log("Zoz_Overhaul Log: No second closest soldier found")
    end
end


function this.OnLoad()
	InfCore.Log("Zoz_Overhaul Log: Zoz_Support_Enemy_Overhaul.OnLoad()")
end

return this