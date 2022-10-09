ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('error:sellDrug')
AddEventHandler('error:sellDrug', function(drug)

    local xPlayer = ESX.GetPlayerFromId(source)

    local inv = xPlayer.getInventoryItem(drug).count

    if inv >= 1 then

        local nb = math.random(1, inv)

        xPlayer.removeInventoryItem(drug, nb)

        for _,item in pairs(Config.drugs) do 

            if drug == item.name then 

                xPlayer.addAccountMoney('black_money', nb*item.price)

                xPlayer.showNotification("Vous avez vendu : ~r~"..nb.." "..drug.."~s~ pour "..nb*item.price.."$")

            end

        end

    else

        xPlayer.showNotification("~r~Vous n'avez pas assez de : ~b~"..drug)

        return

    end

end)