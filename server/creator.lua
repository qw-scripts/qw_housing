local db = require 'server.db'

lib.callback.register('housing:server:create', function(source, data)
    local price = data.price
    local shell = data.shell
    local coords = data.coords

    local newHouse = db.createHouse(price, shell, coords.x, coords.y, coords.z)

    if newHouse ~= 0 then
        AllHouses[#AllHouses+1] = {
            id = newHouse,
            price = price,
            shell = shell,
            owned = false,
            owner = nil,
            locked = true,
            x = coords.x,
            y = coords.y,
            z = coords.z
        }
        Wait(200)
        TriggerClientEvent('housing:client:refreshPoints', -1)
        return true
    end

    return false
end)

lib.callback.register('housing:server:getHouses', function(source)
    return AllHouses
end)


lib.addCommand('house:new', {
    help = 'create a new house',
    restricted = 'group.admin'
}, function(source, args, raw)
    TriggerClientEvent('housing:client:new', source)
end)