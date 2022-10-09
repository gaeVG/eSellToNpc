function spawnClient(name, x, y, z, h)

    local hash = GetHashKey(name)

    RequestModel(hash)

    while not HasModelLoaded(hash) do Wait(500) end

    local pnj = CreatePed(6, hash, x, y, z, h, true, false)

    return pnj

end

function createBlip(x, y, z)

    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite (blip, 51)
    SetBlipScale  (blip, 1.0)
    SetBlipDisplay(blip, 4)
    SetBlipColour (blip, 1)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Client")
    EndTextCommandSetBlipName(blip)

    return blip

end

function startSell(drug)

    ESX.ShowNotification("Recherche d'un client ...")
    local canSell = true

    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, true)

    SetTimeout(math.random(Config.minTime, Config.maxTime), function()
    
        ClearPedTasks(PlayerPedId())

        ESX.ShowAdvancedNotification("???", "Vente : ~r~"..drug, "j'ai trouvé un client, dirige toi vers lui", "CHAR_LJT")

        local pos = GetEntityCoords(PlayerPedId())

        local pnj = spawnClient("a_m_y_genstreet_01", pos.x+math.random(7, 15), pos.y+math.random(7, 15), pos.z)

        local pos2 = GetEntityCoords(pnj)

        local blip = createBlip(pos2.x, pos2.y, pos2.z)
        
        TaskGoToEntity(pnj, PlayerPedId(), 60000, 4.0, 2.0, 0, 0)

        CreateThread(function()

            local wait = 1000
            local dst
        
            while canSell do 

                pos = GetEntityCoords(PlayerPedId())
                pos2 = GetEntityCoords(pnj)
                dst = #(pos - pos2)

                if dst <= 2 then 

                    wait = 0

                    ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour vendre ta ~r~drogue")

                    if IsControlJustPressed(0, 51) then 

                        TriggerServerEvent('error:sellDrug', drug)
                        RemoveBlip(blip)
                        TaskWanderStandard(pnj)
                        canSell = false

                    end

                else wait = 1000

                end

                Wait(wait)
            end
        
        end)
    
    end)

end


function getAllDrugs()

    local all_btn = {}

    for _,v in pairs(Config.drugs) do 

        table.insert(all_btn, {

            name = "Vente de drogue : ~r~"..v.label,
            ask = '~p~>',
            askX = true,
            data = v.name

        })

    end

    return all_btn

end