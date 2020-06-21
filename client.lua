local previousHealth = GetEntityHealth(GetPlayerPed(-1))
Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1000)
        health = GetEntityHealth(GetPlayerPed(-1))
        if(health ~= previousHealth) then
            TriggerServerEvent('syncpos:sync', GetEntityCoords(GetPlayerPed(-1)))
        end
    end

end)

Citizen.CreateThread(function()

    while true do
        Citizen.Wait((15) * 1000)
        TriggerServerEvent('syncpos:sync', GetEntityCoords(GetPlayerPed(-1)))
    end

end)


RegisterCommand('savepos', function(source, args, raw)
    TriggerServerEvent('syncpos:manualSave')
end)


RegisterNetEvent('syncpos:clientspawn')
AddEventHandler('syncpos:spawn', function(x, y, z)

    SetEntityCoords(GetPlayerPed(-1), x, y, z, 1, 0, 0, 1)

end)

RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('syncpos:spawn')
end)
