local db = require 'server.db'
local props = {}
AllHouses = {}

function getProperties()
    AllHouses = db.selectAllHouses()
    for i = 1, #AllHouses do
          local house = AllHouses[i]
          house.locked = true
    end
end

lib.callback.register('housing:server:getProps', function(source)
    return props
end)

lib.callback.register('houses:server:toggleLock', function(source, houseId)
    for i = 1, #AllHouses do
        local house = AllHouses[i]
        if house.id == houseId then
            if house.locked then
                house.locked = false
            else
                house.locked = true
            end
            return house.locked, house.locked and 'property locked' or 'property unlocked'
        end
    end
    return false, 'property not found'
end)

lib.callback.register('houses:server:canEnter', function(source, houseId)
    for i = 1, #AllHouses do
        local house = AllHouses[i]
        if house.id == houseId then
            if house.locked then
                return false, 'property locked'
            else
                return true
            end
        end
    end
    return false, 'property not found'
end)

lib.callback.register('housing:server:isOwner', function(source, owner)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end

    local CID = player.PlayerData.citizenid
    
    if owner == CID then
        return true
    end

    return false
end)

lib.callback.register('houses:server:purchase', function(source, houseId, price)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end

    local CID = player.PlayerData.citizenid
    local cash = player.PlayerData.money.cash
    local bank = player.PlayerData.money.bank

    if bank > price then
        player.Functions.RemoveMoney('bank', price, 'property-purchase')
    elseif cash > price then
        player.Functions.RemoveMoney('cash', price, 'property-purchase')
    else
        return false
    end

    local newOwner = db.updateNewOwner(CID, houseId)

    if newOwner ~= 0 then
        for i = 1, #AllHouses do
            local house = AllHouses[i]
            if house.id == houseId then
               house.owned = true
               house.owner = CID
               TriggerClientEvent('housing:client:refreshPoints', -1)
                return true
            end
        end
    end

    return false
end)

local function loadProps()
    local data = LoadResourceFile(GetCurrentResourceName(), 'props.json')
    if data then
        local jsonData = json.decode(data)
        print('Loaded ' .. #jsonData .. ' props')
        props = jsonData
    end
end

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
      Wait(100)
      getProperties()
      loadProps()
   end
end)