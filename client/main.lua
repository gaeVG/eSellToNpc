RegisterCommand('vente', function(source, args, rawCommand)

    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        return ESX.ShowNotification("cannot_sell_in_car")
    end

    local pos = GetEntityCoords(PlayerPedId())
    local name = GetNameOfZone(pos.x, pos.y, pos.z)

    if ESX.Table.Find(zone, function() return zone == name) then
        CreateMenu(eSellToNpc)
    end
end, false)