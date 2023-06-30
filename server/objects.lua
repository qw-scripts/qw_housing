local db = require 'server.db'
lib.callback.register('houses:server:getObjects', function(_, id)
    local props = db.selectPropsByHouseId(id)
    return props
end)

lib.callback.register('houses:server:createNewProp', function(_, data)
    local settings = json.encode(data.settings)
    local created = db.createProp(data.id, data.model, data.x, data.y, data.z, data.rx, data.ry, data.rz, settings)
    
    if created ~= 0 then
        return true, created
    end

    return false, nil
end)

lib.callback.register('houses:server:updateProp', function(_, data)
    local updated = db.updatePropPosition(data.x, data.y, data.z, data.rx, data.ry, data.rz, data.id)
    
    if updated ~= 0 then
        return true
    end

    return false
end)

lib.callback.register('houses:server:deleteProp', function(_, data)
    local deleted = db.deleteProp(data.id)
    
    if deleted ~= 0 then
        return true
    end

    return false
end)

lib.callback.register('houses:server:registerStash', function(_, data)
    local stashId = ('%s_%s_%s'):format(data.model, data.id, data.houseId)
    exports.ox_inventory:RegisterStash(stashId, 'Stash', data.slots, data.weight, false)
    return stashId
end)