local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local missionID = TppMission.GetMissionID()

local NULL_ID = GameObject.NULL_ID

this.registerMenus={
    "Zoz_Enemy_Overhaul",
    "Zoz_Enemy_Radio_Overhaul",
    "Zoz_Enemy_Voice_Overhaul",
    "Zoz_Enemy_Equipment_Overhaul",
    "Zoz_Enemy_Phase_Music_Overhaul",
}

this.Zoz_Enemy_Overhaul={
    parentRefs={"Zoz_Overhaul.safeSpaceMenu","Zoz_Overhaul.inMissionMenu"},
    options={
        "Zoz_Enemy_Overhaul.Zoz_Enemy_Radio_Overhaul",
        "Zoz_Enemy_Overhaul.Zoz_Enemy_Voice_Overhaul",
        "Zoz_Enemy_Overhaul.Zoz_Enemy_Equipment_Overhaul",
        "Zoz_Enemy_Overhaul.Zoz_Enemy_Phase_Music_Overhaul",
    }
}

this.registerIvars={
    -- Enemy_Radio
    "Zoz_Enemy_Radio_Report_Broken_Communication",
    "Zoz_Enemy_Radio_Extra_Camera_Lines",
    "Zoz_Enemy_Radio_Report_UAV_Down",
    "Zoz_Enemy_Radio_Repeat_Last",
    "Zoz_Enemy_Radio_Cancel_Prisoner_Search",
    "Zoz_Enemy_Radio_Report_Damage_From_Gunship",
    "Zoz_Enemy_Radio_Announce_Shift_Change",

    -- Enemy_Voice
    "Zoz_Enemy_Voice_Enemy_Reaction_Player_Vehicle",
    "Zoz_Enemy_Voice_Enemy_Reaction_Player_Aim",
    "Zoz_Enemy_Voice_Enemy_Reaction_Player_RPG",
    "Zoz_Enemy_Voice_Enemy_Player_Restrain",
    "Zoz_Enemy_Voice_Enemy_Surrender",

    -- Enemy_Equipment
    "Zoz_Enemy_Equipment_Fulton",
    "Zoz_Enemy_Equipment_Camera",
    "Zoz_Enemy_Equipment_Ir_Sensors",
    "Zoz_Enemy_Equipment_burglar_alarm",

    -- Enemy_Phase_Music_Overhaul
    "Zoz_BGM_Phase_Select",
    "Zoz_BGM_Select_Stop",
}

this.Zoz_Enemy_Radio_Overhaul={
    parentRefs={"Zoz_Enemy_Overhaul.safeSpaceMenu","Zoz_Enemy_Overhaul.inMissionMenu"},
    options={
        "Ivars.Zoz_Enemy_Radio_Report_Broken_Communication",
        "Ivars.Zoz_Enemy_Radio_Extra_Camera_Lines",
        "Ivars.Zoz_Enemy_Radio_Report_UAV_Down",
        "Ivars.Zoz_Enemy_Radio_Repeat_Last",
        "Ivars.Zoz_Enemy_Radio_Cancel_Prisoner_Search",
        "Ivars.Zoz_Enemy_Radio_Report_Damage_From_Gunship",
        "Ivars.Zoz_Enemy_Radio_Announce_Shift_Change",
    }
}

this.Zoz_Enemy_Voice_Overhaul={
    parentRefs={"Zoz_Enemy_Overhaul.safeSpaceMenu", "Zoz_Enemy_Overhaul.inMissionMenu"},
    options={
        "Ivars.Zoz_Enemy_Voice_Enemy_Reaction_Player_Vehicle",
        "Ivars.Zoz_Enemy_Voice_Enemy_Reaction_Player_Aim",
        "Ivars.Zoz_Enemy_Voice_Enemy_Reaction_Player_RPG",
        "Ivars.Zoz_Enemy_Voice_Enemy_Player_Restrain",
        "Ivars.Zoz_Enemy_Voice_Enemy_Surrender",
    }
}

this.Zoz_Enemy_Equipment_Overhaul={
    parentRefs={"Zoz_Enemy_Overhaul.safeSpaceMenu"},
    options={
        "Ivars.Zoz_Enemy_Equipment_Fulton",
        "Ivars.Zoz_Enemy_Equipment_Camera",
        "Ivars.Zoz_Enemy_Equipment_Ir_Sensors",
        "Ivars.Zoz_Enemy_Equipment_burglar_alarm",
    }
}

this.Zoz_Enemy_Phase_Music_Overhaul={
    parentRefs={"Zoz_Enemy_Overhaul.safeSpaceMenu", "Zoz_Enemy_Overhaul.inMissionMenu"},
    options={
        "Ivars.Zoz_BGM_Phase_Select",
        "Ivars.Zoz_BGM_Select_Stop",
    }
}

this.Zoz_BGM_Phase_List = {
    "None",
    "bgm_paz_escape",
    "ITSTHEFREAKINBAT",
}

-- Enemy_Radio
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

-- Enemy_Voice
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

-- Enemy_Equipment
this.Zoz_Enemy_Equipment_Fulton={
    save=IvarProc.CATEGORY_EXTERNAL,
    settings={"OFF","Normal","Balloon","Wormhole"},
    default=1,
}

this.Zoz_Enemy_Equipment_Camera={
    save=IvarProc.CATEGORY_EXTERNAL,
    settings={"OFF", "ON"},
    default=1,
} 

this.Zoz_Enemy_Equipment_Ir_Sensors = {
    save=IvarProc.CATEGORY_EXTERNAL,
    settings={"OFF","FreeRoom","Mission","ALL"},
    default=3,
}

this.Zoz_Enemy_Equipment_burglar_alarm = {
    save=IvarProc.CATEGORY_EXTERNAL,
    settings={"OFF","FreeRoom","Mission","ALL"},
    default=3,
}

-- Enemy_Phase_Music_Overhaul
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
        InfCore.Log("Zoz: Music selected!")
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
        InfCore.Log("Zoz: Music Stopped!")
        TppSound.ResetPhaseBGM()
    end
}

this.langStrings={
    eng={
        Zoz_Enemy_Overhaul = "Enemy Overhaul",

        Zoz_Enemy_Radio_Overhaul = "Enemy Radio",
        Zoz_Enemy_Radio_Report_Broken_Communication = "CP Report broken Communication equipment",
        Zoz_Enemy_Radio_Extra_Camera_Lines = "Extra CCTV and UAV Lines",
        Zoz_Enemy_Radio_Report_UAV_Down = "CP Report UAV down",
        Zoz_Enemy_Radio_Repeat_Last = "CP Request repeat",
        Zoz_Enemy_Radio_Cancel_Prisoner_Search = "Request to cancel the search of a prisoner",
        Zoz_Enemy_Radio_Report_Damage_From_Gunship = "Report fire from enemy gunship",
        Zoz_Enemy_Radio_Announce_Shift_Change = "Announce Shift Change",

        Zoz_Enemy_Voice_Overhaul = "Enemy Voice",
        Zoz_Enemy_Voice_Enemy_Reaction_Player_Vehicle = "Enemy react to Player's Vehicle",
        Zoz_Enemy_Voice_Enemy_Reaction_Player_Aim = "Enemy react to Player when in Hold up",
        Zoz_Enemy_Voice_Enemy_Reaction_Player_RPG = "Enemy react to Player when aiming an RPG",
        Zoz_Enemy_Voice_Enemy_Player_Restrain = "Enemy react to restrain",
        Zoz_Enemy_Voice_Enemy_Surrender = "Enemy Surrender",

        Zoz_Enemy_Equipment_Overhaul = "Enemy Equipment",
        Zoz_Enemy_Equipment_Fulton = "Equip Fulton",
        Zoz_Enemy_Equipment_Camera = "Security Cameras",
        Zoz_Enemy_Equipment_Ir_Sensors = "Ir Sensors",
        Zoz_Enemy_Equipment_burglar_alarm = "Burglar Alarm",

        Zoz_Enemy_Phase_Music_Overhaul = "Enemy Phase BGM menu",
        Zoz_BGM_Phase_Select = "Select Phase BGM",
        Zoz_BGM_Select_Stop = "Stop BGM",
    },
    help={
        eng={
            Zoz_Enemy_Overhaul = "Toggle individual options for Enemy Overhaul",

            Zoz_Enemy_Radio_Overhaul = "Toggle individual options for Enemy Radio",
            Zoz_Enemy_Radio_Report_Broken_Communication = "The CP will report the Communication equipment was destroyed and enemy soldiers will go to Alert statue (Caution Phase)",
            Zoz_Enemy_Radio_Extra_Camera_Lines = "Adds an extra line when spotted by a security camera or UAV",
            Zoz_Enemy_Radio_Report_UAV_Down = "CP will report that a UAV was destroyed and enemy soldiers will go to Alert statue (Caution Phase)",
            Zoz_Enemy_Radio_Repeat_Last = "CP will ask the soldier to repeat if a radio call wasn't successful during Combat (Alert Phase)",
            Zoz_Enemy_Radio_Cancel_Prisoner_Search = "Enemy soldier will request to cancel the search of a lost prisoner 3 minutes after he was reported (Only SIDE OPS)",
            Zoz_Enemy_Radio_Report_Damage_From_Gunship = "Soldiers will report to CP when they get damaged from support heli",
            Zoz_Enemy_Radio_Announce_Shift_Change = "CP will announce shift changes",

            Zoz_Enemy_Voice_Overhaul = "Toggle individual options for Enemy Voice.",
            Zoz_Enemy_Voice_Enemy_Reaction_Player_Vehicle = "Enemy will react to Player's Vehicle\nArmored Vehicle and tank only",
            Zoz_Enemy_Voice_Enemy_Reaction_Player_Aim = "Enemy will react to the player aiming at them during a hold up",
            Zoz_Enemy_Voice_Enemy_Reaction_Player_RPG = "Enemy react to Player when aiming an RPG\n has 15 seconds cooldown",
            Zoz_Enemy_Voice_Enemy_Player_Restrain = "Enemy will react to the player when restraining them during Alert Phase",
            Zoz_Enemy_Voice_Enemy_Surrender = "Enemy will surrender when they are the last.\nThis will depend on their combat level.\nLevel 1 and 2: 75% chance\nLevel 3: 50% chance\nLevel 4 and 5: 25% chance\nFully armored enemies will never surrender",

            Zoz_Enemy_Equipment_Overhaul = "Toggle individual options for Enemy Equipment",
            Zoz_Enemy_Equipment_Fulton="Makes the enemy able to fulton the player when unconscious if toggled on.",
            Zoz_Enemy_Equipment_Camera = "When toggled on, surveillance cameras will spawn.\nTHIS OPTION IS FOR MAIN MISSIONS ONLY",
            Zoz_Enemy_Equipment_Ir_Sensors = "Enables Ir Sensors in FOB to be in Afghanistan and Africa!",
            Zoz_Enemy_Equipment_burglar_alarm = "Enables Burglar Alarm in FOB to be in Afghanistan and Africa!",

            Zoz_Enemy_Phase_Music_Overhaul = "Toggle individual options for Phase music!",
            Zoz_BGM_Phase_Select = "Select the desired Phase BGM and hit the action button!",
            Zoz_BGM_Select_Stop = "Stop the playing BGM, hit the action button!",

        },
    },
}

function this.OnAllocate()
    InfCore.Log("Zoz: OnAllocate called")
end

function this.OnInitialize()
    InfCore.Log("Zoz: OnInitialize called")
end

function this.PlayCPOnlyRadio(Label)
    InfCore.Log("Zoz: PlayCPOnlyRadio(" .. Label..") in CP: " .. Zoz_overhaul_Ivars.getClosestCpString())
    if string.find(Zoz_overhaul_Ivars.getClosestCpString(), "_cp") then
        GameObject.SendCommand(Zoz_overhaul_Ivars.getClosestCp(),{ id = "RequestRadio", label=Label })
    end
end

function this.GetSoldierList()
    InfCore.Log("Zoz: GetSoldierList called")
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
    InfCore.Log("Zoz: GetClosestSoldierMath called")
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
    InfCore.Log("Zoz: GetClosestSoldier called")
    local soldierList = this.GetSoldierList()
    local closestSoldierName = this.GetClosestSoldierMath(soldierList)
    return closestSoldierName
end

function this.IsCanCommunicate(gameObjectId)
    if gameObjectId==NULL_ID then
        InfCore.Log("Zoz: IsCanCommunicate - Invalid ID")
        return false
    end
    if TppEnemy.IsNeutralized(gameObjectId) then
        InfCore.Log("Zoz: IsCanCommunicate - Neutralized")
        return false
    end
    local vehicleGameObjectId = GameObject.SendCommand(gameObjectId,{id="GetVehicleGameObjectId"})
    if vehicleGameObjectId~=NULL_ID then
        InfCore.Log("Zoz: IsCanCommunicate - In vehicle")
        return false
    end
    return true
end

function this.GetClosestSoldierSpeak(label)
    InfCore.Log("Zoz: GetClosestSoldierSpeak - "..label)
    local soldierList = this.GetSoldierList()
    local closestSoldierName = this.GetClosestSoldierMath(soldierList)
    local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", closestSoldierName )
    local command = { id = "CallVoice", dialogueName = "DD_vox_ene", parameter= label }
    GameObject.SendCommand( gameObjectId, command )
end

function this.GetSoldierListCQC()
    InfCore.Log("Zoz: GetSoldierListCQC called")
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
    InfCore.Log("Zoz: GetClosestSoldierMathCQC called")
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
    InfCore.Log("Zoz: GetClosestSoldierCQC - "..label)
    local soldierList = this.GetSoldierListCQC()
    local closestSoldierName = this.GetClosestSoldierMathCQC(soldierList)
    local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", closestSoldierName )
    local command = { id="CallVoice", dialogueName="DD_vox_ene", parameter= label }
    if not TppEnemy.IsNeutralized(gameObjectId) then
        GameObject.SendCommand( gameObjectId, command )
    end
end

function this.GetSecondClosestSoldierMath(gameObjectList)
    InfCore.Log("Zoz: GetSecondClosestSoldierMath called")
    local playerPos = TppPlayer.GetPosition()
    local closestDist = 65526
    local secondClosestDist = 65526
    local closest, secondClosest

    for index, name in ipairs(gameObjectList) do
        local gameObjectId = GameObject.GetGameObjectId(name)
        local position = GameObject.SendCommand(gameObjectId, { id = "GetPosition" })
        position = TppMath.Vector3toTable(position)
        local distSqr = TppMath.FindDistance(playerPos, position)

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
    InfCore.Log("Zoz: GetSecondClosestSoldierSpeak - "..label)
    local soldierList = this.GetSoldierList()
    local secondClosestSoldierName = this.GetSecondClosestSoldierMath(soldierList)

    if secondClosestSoldierName then
        local gameObjectId = GameObject.GetGameObjectId("TppSoldier2", secondClosestSoldierName)
        local command = { id = "CallVoice", dialogueName = "DD_vox_ene", parameter = label }
        GameObject.SendCommand(gameObjectId, command)
    end
end

function this.OnLoad()
    InfCore.Log("Zoz: EnemyOverhaul loaded")
end

return this