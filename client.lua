Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2500)
        TriggerServerEvent('syncpos:sync', GetEntityCoords(GetPlayerPed(-1)))
    end
end)

RegisterCommand('savepos', function(source, args, raw)
    TriggerServerEvent('syncpos:manualSave')
end)


RegisterNetEvent('syncpos:spawn')
AddEventHandler('syncpos:spawn', function(x, y, z)

    SetEntityCoords(GetPlayerPed(-1), x, y, z, 1, 0, 0, 1)

end)

RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('syncpos:spawn')
end)