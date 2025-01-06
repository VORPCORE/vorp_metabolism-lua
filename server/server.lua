local VorpCore = exports.vorp_core:GetCore()

CreateThread(function()
    for i = 1, #Config.ItemsToUse, 1 do
        exports.vorp_inventory:registerUsableItem(Config["ItemsToUse"][i]["Name"], function(data)
            local itemLabel = data.item.label
            TriggerClientEvent("vorpmetabolism:useItem", data.source, i, itemLabel)
            exports.vorp_inventory:subItemById(data.source, data.item.mainid)
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
