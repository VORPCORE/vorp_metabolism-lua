RegisterNetEvent('vorpmetabolism:useItem', function(index, label)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)

    if (Config["ItemsToUse"][index]["Thirst"] ~= 0) then
        local newThirst = PlayerStatus["Thirst"] + Config["ItemsToUse"][index]["Thirst"]

        if (newThirst > 1000) then
            newThirst = 1000
        end

        if (newThirst < 0) then
            newThirst = 0
        end
        PlayerStatus["Thirst"] = newThirst
    end
    if (Config["ItemsToUse"][index]["Hunger"] ~= 0) then
        local newHunger = PlayerStatus["Hunger"] + Config["ItemsToUse"][index]["Hunger"]

        if (newHunger > 1000) then
            newHunger = 1000
        end

        if (newHunger < 0) then
            newHunger = 0
        end

        PlayerStatus["Hunger"] = newHunger
    end
    if (Config["ItemsToUse"][index]["Metabolism"] ~= 0) then
        local newMetabolism = PlayerStatus["Metabolism"] + Config["ItemsToUse"][index]["Metabolism"]

        if (newMetabolism > 10000) then
            newMetabolism = 10000
        end

        if (newMetabolism < -10000) then
            newMetabolism = -10000
        end

        PlayerStatus["Metabolism"] = newMetabolism
    end
    if (Config["ItemsToUse"][index]["Stamina"] ~= 0) then
        local stamina = GetAttributeCoreValue(PlayerPedId(), 1)
        local newStamina = stamina + Config["ItemsToUse"][index]["Stamina"]

        if (newStamina > 100) then
            newStamina = 100
        end

        Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 1, newStamina) -- SetAttributeCoreValue native
    end
    if (Config["ItemsToUse"][index]["InnerCoreHealth"] ~= 0) then
        local health = GetAttributeCoreValue(PlayerPedId(), 0)
        local newhealth = health + Config["ItemsToUse"][index]["InnerCoreHealth"]

        if (newhealth > 100) then
            newhealth = 100
        end

        Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, newhealth) -- SetAttributeCoreValue native
    end
    if (Config["ItemsToUse"][index]["OuterCoreHealth"] ~= 0) then
        local health = GetEntityHealth(PlayerPedId())
        local newhealth = health + Config["ItemsToUse"][index]["OuterCoreHealth"]

        --[[    if (newhealth > 150) then
            newhealth = 150
        end ]] --
        SetEntityHealth(PlayerPedId(), newhealth, 0)
    end
    -- Golds
    if (Config["ItemsToUse"][index]["OuterCoreHealthGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 0, Config["ItemsToUse"][index]["OuterCoreHealthGold"], true)
    end
    if (Config["ItemsToUse"][index]["InnerCoreHealthGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 0, Config["ItemsToUse"][index]["InnerCoreHealthGold"], true)
    end

    if (Config["ItemsToUse"][index]["OuterCoreStaminaGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 1, Config["ItemsToUse"][index]["OuterCoreStaminaGold"], true)
    end
    if (Config["ItemsToUse"][index]["InnerCoreStaminaGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 1, Config["ItemsToUse"][index]["InnerCoreStaminaGold"], true)
    end

    if (Config["ItemsToUse"][index]["Animation"] == "eat") then
        PlayAnimEat(Config["ItemsToUse"][index]["PropName"])
    elseif (Config["ItemsToUse"][index]["Animation"] == "stew") then
        PlayAnimStew(Config["ItemsToUse"][index]["PropName"])
    elseif (Config["ItemsToUse"][index]["Animation"] == "drink") then
        PlayAnimDrink(Config["ItemsToUse"][index]["PropName"])
    elseif (Config["ItemsToUse"][index]["Animation"] == "coffee") then
        PlayAnimCoffee(Config["ItemsToUse"][index]["PropName"])
    elseif (Config["ItemsToUse"][index]["Animation"] == "syringe") then
        PlayAnimSyringe(Config["ItemsToUse"][index]["PropName"])
    elseif (Config["ItemsToUse"][index]["Animation"] == "bandage") then
        PlayAnimBandage(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Effect"] ~= "") then
        ScreenEffect(Config["ItemsToUse"][index]["Effect"], Config["ItemsToUse"][index]["EffectDuration"])
    end
end)

function ScreenEffect(effect, durationMinutes)
    local durationMilliseconds = durationMinutes * 60000 -- Convert minutes to milliseconds
    AnimpostfxPlay(effect)
    Wait(durationMilliseconds)
    AnimpostfxStop(effect)
end

function PlayAnimCoffee(propName)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local coffeeProp = CreateObject(joaat(propName), playerCoords.x, playerCoords.y, playerCoords.z, true, true, false)
    Citizen.InvokeNative(0x669655FFB29EF1A9, coffeeProp, 0, "CTRL_cupFill", 1.0)
    TaskItemInteraction_2(PlayerPedId(), GetHashKey("CONSUMABLE_COFFEE"), coffeeProp, GetHashKey("P_MUGCOFFEE01X_PH_R_HAND"), GetHashKey("DRINK_COFFEE_HOLD"), 1, 0, -1082130432)
end

function PlayAnimBandage(propName)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local dict = "mini_games@story@mob4@heal_jules@bandage@arthur"
    local anim = "tourniquet_slow"

    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        Wait(100)
    end

    local hashItem = GetHashKey(propName)

    local prop = CreateObject(hashItem, playerCoords.x, playerCoords.y, playerCoords.z, true, true, false)
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_HAND")

    Wait(1000)

    TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, 8.0, 5000, 31, 0.0, false, false, false)
    AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.10, 0.0, 0.03, 0.0, -60.0, -90.0, true, true, false, true, 1, true)
    Wait(6000)

    DeleteObject(prop)
    ClearPedSecondaryTask(PlayerPedId())
end

function PlayAnimSyringe(propName)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local dict = "mech_inventory@item@stimulants@inject@quick"
    local anim = "quick_stimulant_inject_lhand"

    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        Wait(100)
    end

    local hashItem = GetHashKey(propName)

    local prop = CreateObject(hashItem, playerCoords.x, playerCoords.y, playerCoords.z, true, true, false)
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_HAND")

    Wait(1000)

    TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, 8.0, 5000, 31, 0.0, false, false, false)
    AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.10, 0.0, 0.03, 0.0, -80.0, -90.0, true, true, false, true, 1, true)
    Wait(2000) -- 6000

    DeleteObject(prop)
    ClearPedSecondaryTask(PlayerPedId())
end

function PlayAnimStew(propName)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local stewProp = CreateObject(propName, playerCoords.x, playerCoords.y, playerCoords.z, true, true, false)
    local stewSpoonProp = CreateObject("p_beefstew_spoon01x", playerCoords.x, playerCoords.y, playerCoords.z, true, true, false)
    Citizen.InvokeNative(0x669655FFB29EF1A9, stewProp, 0, "Stew_Fill", 1.0)
    Citizen.InvokeNative(0xCAAF2BCCFEF37F77, stewProp, 20)
    Citizen.InvokeNative(0xCAAF2BCCFEF37F77, stewSpoonProp, 82)
    -- https://github.com/femga/rdr3_discoveries/blob/ab8efca7aaf8f3e3b3b5a76893ac4787ad676dbf/animations/scenarios/scenario_attached_props.lua
    TaskItemInteraction_2(playerPed, 599184882, stewProp, joaat("p_bowl04x_stew_PH_L_HAND"), -583731576, 1, 0, -1.0)
    TaskItemInteraction_2(playerPed, 599184882, stewSpoonProp, joaat("p_spoon01x_PH_R_HAND"), -583731576, 1, 0, -1.0)
    -- https://github.com/femga/rdr3_discoveries/tree/master/tasks/TASK_ITEM_INTERACTION#-4-item_interaction_state_name--item_interaction_propid--1
    Citizen.InvokeNative(0xB35370D5353995CB, playerPed, -583731576, 1.0)
end

function PlayAnimDrink(propName)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local dict = "amb_rest_drunk@world_human_drinking@male_a@idle_a"
    local anim = "idle_a"

    if (not IsPedMale(PlayerPedId())) then
        dict = "amb_rest_drunk@world_human_drinking@female_a@idle_b"
        anim = "idle_b"
    end

    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        Wait(100)
    end

    local hashItem = GetHashKey(propName)

    local prop = CreateObject(hashItem, playerCoords.x, playerCoords.y, playerCoords.z, true, true, false)
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_HAND") -- SKEL_R_Finger12

    Wait(1000)

    TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, 8.0, 5000, 31, 0.0, false, false, false)
    AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.08, -0.04, -0.05, -75.0, 0.0, 0.0, true, true, false, true, 1, true)
    -- AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.02, -0.018, 0.10, 15.0, 175.0, 0.0, true, true, false, true, 1, true)
    Wait(5300) -- 6000

    DeleteObject(prop)
    ClearPedSecondaryTask(PlayerPedId())
end

function PlayAnimEat(propName)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local dict = "mech_inventory@clothing@bandana"
    local anim = "NECK_2_FACE_RH"

    --if (!IsPedMale(PlayerPedId())) then
    --    dict = "amb_rest_drunk@world_human_drinking@female_a@idle_b"
    --    anim = "idle_b"
    --end

    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        Wait(100)
    end

    local hashItem = GetHashKey(propName)

    local prop = CreateObject(hashItem, playerCoords.x, playerCoords.y, playerCoords.z + 0.2, true, true, false)
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_HAND") -- SKEL_R_Finger12

    Wait(1000)

    TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, 8.0, 5000, 31, 0.0, false, false, false)
    AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.08, -0.04, -0.05, -75.0, 0.0, 0.0, true, true, false, true, 1, true)
    -- AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.02, 0.028, 0.001, 15.0, 175.0, 0.0, true, true, false, true, 1, true)
    Wait(5300) -- 6000

    DeleteObject(prop)
    ClearPedSecondaryTask(PlayerPedId())
end

-- On Resource Start
AddEventHandler('onResourceStart', function(resourceName)
    if Config.DevMode then
        if (GetCurrentResourceName() == resourceName) then
            TriggerServerEvent("vorpmetabolism:GetStatus")
        end
    end
end)