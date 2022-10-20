RegisterCommand('vente', function(source, args, rawCommand)

    if IsPedSittingInAnyVehicle(PlayerPedId()) then

        ESX.ShowNotification("~r~Vous ne pouvez pas vendre dans une voiture")

        return

    end

    local pos = GetEntityCoords(PlayerPedId())
    local name = GetNameOfZone(pos.x, pos.y, pos.z)

    print(name)

    for _, v in pairs(Config.Zones) do

        if v == name then

            CreateMenu(eSellToNpc)

        end

    end

end, false)