ESX = nil

AddEventHandle('onServerResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    while (function()
        if ESX == nil then
            return true
        end

        ESX.RegisterServerCallback('error:sellDrug', sellDrug)
    end)() do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(64)
    end
end)

function sellDrug(source, cb, drug)
    local xPlayer = ESX.GetPlayerFromId(source)

    if ESX.Table.Find(Config.drugs, function(drugName) if drugName == name) then
        local item = xPlayer.getInventoryItem(drug)

        if item == nil then
            cb(true, _U("not_have_item", drug))
        end
        
        if item.count < 1 then
            cb(true, _U("not_have_enough_item", drug))
        else
            xPlayer.removeInventoryItem(drug, math.random(1, inv))
            xPlayer.addAccountMoney('black_money', nb*item.price)
            xPlayer.showNotification(_U("sold_item", nb, drug, nb * item.price))
            cb(false)
        end
    end
end
