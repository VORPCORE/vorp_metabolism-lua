local VorpCore = exports.vorp_core:GetCore()
local T    = Translation.Langs[Config.Langs]

CreateThread(function()
    for i = 1, #Config.ItemsToUse, 1 do
        exports.vorp_inventory:registerUsableItem(Config["ItemsToUse"][i]["Name"], function(data)
            local itemLabel = data.item.label
            local usedItems = Config["ItemsToUse"][i]
            local notification
            TriggerClientEvent("vorpmetabolism:useItem", data.source, i, itemLabel, usedItems.GiveBackItem, usedItems.GiveBackItemAmount)
            notification = string.format(T.OnUseItem, itemLabel)
            exports.vorp_inventory:subItemById(data.source, data.item.mainid)

            if usedItems.GiveBackItem and usedItems.GiveBackItem ~= "" then
                local giveBackItemAmount = tonumber(usedItems.GiveBackItemAmount)
                if exports.vorp_inventory:canCarryItem(data.source, usedItems.GiveBackItem, usedItems.GiveBackItemAmount) then
                    notification = string.format(T.OnUseItemWithReturn, itemLabel, usedItems.GiveBackItemLabel, giveBackItemAmount)
                    exports.vorp_inventory:addItem(data.source, usedItems.GiveBackItem, usedItems.GiveBackItemAmount)
                else
                    notification = string.format(T.CantCarry, itemLabel, giveBackItemAmount, usedItems.GiveBackItemLabel)
                end
            end
            VorpCore.NotifyTip(data.source, notification, 4000)
            exports.vorp_inventory:closeInventory(data.source)
        end)
    end
end)

RegisterNetEvent("vorpmetabolism:SaveLastStatus", function(status)
    local _source = source
    local UserCharacter = VorpCore.getUser(_source).getUsedCharacter
    UserCharacter.setStatus(status)
end)

RegisterNetEvent("vorpmetabolism:GetStatus", function()
    local _source = source
    local UserCharacter = VorpCore.getUser(_source).getUsedCharacter
    local s_status = UserCharacter.status
    if (#s_status > 5) then
        TriggerClientEvent("vorpmetabolism:StartFunctions", _source, s_status)
    else
        local status = json.encode({
            ['Hunger'] = Config["FirstHungerStatus"],
            ['Thirst'] = Config["FirstThirstStatus"],
            ['Metabolism'] = Config["FirstMetabolismStatus"]
        })
        UserCharacter.setStatus(status)
        TriggerClientEvent("vorpmetabolism:StartFunctions", _source, status)
    end
end)