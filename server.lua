
local positions = {}

local autoSave = true
local timeOut = 60  -- Delay between saving positions in database (in seconds)

local printInfo = false -- Print 'Saved location for: ..' ?
-- Not recommended, only use for debugging


RegisterServerEvent('syncpos:sync')
AddEventHandler('syncpos:sync', function(vec)
    savePosition(source, vec)
end)

RegisterServerEvent('syncpos:manualSave')
AddEventHandler('syncpos:manualSave', function()
    steamId = GetPlayerIdentifier(source, 0)
    if(steamId ~= nil) then
        x, y, z = table.unpack(positions[steamId])
        encoded = '{' .. x .. ', ' .. y .. ', ' .. z .. '}'
        MySQL.Async.execute('UPDATE users SET lastpos = "' .. encoded .. '" WHERE identifier = "' .. steamId .. '";', {}, function(success)
            if(success == 0) then
                print("MySQL failure")
            end 
        end)
    else
        print("Failed to save position for " .. steamId)
    end
end)

RegisterServerEvent('syncpos:spawn')
AddEventHandler('syncpos:spawn', function()

    local steamId = GetPlayerIdentifier(source, 0)
    cachedPos = positions[steamId]
    if(cachedPos ~= nil) then
        x, y, z = table.unpack(positions[steamId])
        TriggerClientEvent('syncpos:spawn', source, x, y, z)
    else
        MySQL.Async.fetchScalar('SELECT lastpos FROM users WHERE identifier = "' .. steamId .. '";', {}, function(result)
            
            array = json.decode(result)
            TriggerClientEvent('syncpos:spawn', source, array[1], array[2], array[3])
        
        end)
    end

end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('[SyncPos] [<ALERT>] Saving all positions due to resource stop')
    mysqlSync()
  end)


function savePosition(playerId, positionVec)
    local steamId = GetPlayerIdentifier(playerId, 0)
    positions[steamId] = positionVec
    -- This function caches the players last location 
    -- It will get saved manually or via AutoSave function
end

function mysqlSync()

    local queryString = ''

    for k,v in pairs(positions) do
        if(printInfo) then
            print('[SyncPos] Saving location for ' .. k)
        end
        x, y, z = table.unpack(v)
        encoded = '{' .. x .. ', ' .. y .. ', ' .. z .. '}'
        queryString = queryString .. 'UPDATE users SET lastpos = "' .. encoded .. '" WHERE identifier = "' .. k .. '";'

    end

    MySQL.Async.execute(queryString)

end

Citizen.CreateThread(function()

    while autoSave do
        Citizen.Wait((timeOut) * 1000)
        mysqlSync()
    end

end)
