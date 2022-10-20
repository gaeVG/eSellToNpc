function spawnClient(model, coords, heading)
    model = (type(model) == 'number' and model or GetHashKey(model))
    RequestModel(hash)

    while not HasModelLoaded(hash) do Wait(8) end

    return CreatePed(6, model, coords.x, coords.y, coords.z, heading, true, false)
end

function createBlip(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite (blip, Config.blip.sprite)
    SetBlipScale  (blip, Config.blip.scale)
    SetBlipDisplay(blip, Config.blip.display)
    SetBlipColour (blip, Config.blip.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Client")
    EndTextCommandSetBlipName(blip)

    return blip
end

function sellDrug(drug)
    ESX.TriggerServerCallback('sellDrug', function(error, message)
        if error then
            ESX.ShowNotification(message)
        end
    end)
end

function startSell(drug)
    ESX.ShowNotification(_U("customer_search"))
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, true)

    SetTimeout(math.random(Config.minTime, Config.maxTime), function()
        ClearPedTasks(playerPed)

        ESX.ShowAdvancedNotification(
            "???",
            "Vente : ~r~"..drug,
            _U('customer_found'),
            "CHAR_LJT"
        )

        local playerCoords = GetEntityCoords(playerPed)
        local pnj = spawnClient("a_m_y_genstreet_01", (pos + vector3(math.random(7, 15), math.random(7, 15), 0)), math.random(0, 359))
        local pnjCoords = GetEntityCoords(pnj)
        local blip = createBlip(pnjCoords)
        
        TaskGoToEntity(pnj, playerPed, 60000, 4.0, 2.0, 0, 0)

        CreateThread(function()
            local wait, distance

            while (function()
                if distance > 20 then
                    -- Le joueur est trop loin du ped, arrêt de la boucle
                    return false
                end

                if distance <= 2 then 
                    wait = 0

                    ESX.ShowHelpNotification(_U("press_to_sold"))

                    if IsControlJustPressed(0, 51) then 
                        RemoveBlip(blip)
                        TaskWanderStandard(pnj)
                        -- La drogue a été vendue, arrêt de la boucle
                        return false
                    end
                end

                return true
            end)() do
                Wait(wait)
                playercoords = GetEntityCoords(playerPed)
                pnjCoords = GetEntityCoords(pnj)
                distance = #(playerCoords - pnjCoords)
            end
        end)
    end)
end

function getAllDrugs()
    return ESX.Table.Map(drug, function()
        return {
            name = _U("drug_sale", v.label)
            ask = '~p~>',
            askX = true,
            data = v.name
        }
    end)
end