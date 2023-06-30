local currentPropertyObjects = {}
local createdInProperty = {}
local previewObjectName = nil
CurrentlyEditing = nil
PreviewObject = nil

local function joinTables()
    local newTable = {}
    for _,v in pairs(currentPropertyObjects) do
        table.insert(newTable, v)
    end
    for _,v in pairs(createdInProperty) do
        table.insert(newTable, v)
    end
    return newTable
end

function GetCurrentPropertyObjects()
    return joinTables()
end

RegisterNUICallback('previewModel', function(data, cb)
    local model = data.model
    previewObjectName = model

    if PreviewObject then
        SetEntityAsMissionEntity(PreviewObject, false, true)
        DeleteObject(PreviewObject)
        PreviewObject = nil
    end

    lib.requestModel(joaat(model))
    local xVect, yVect, zVect = GetObjectCoords()

    PreviewObject = CreateObject(model, curPos.x + xVect, curPos.y + yVect, curPos.z + zVect, false, true, true)
    FreezeEntityPosition(PreviewObject, true)
    SetEntityAlpha(PreviewObject, 150, false)
    SetEntityCollision(PreviewObject, false, false)
    cb('ok')
end)

RegisterNUICallback('editCurrentModel', function(_, cb)
    if not PreviewObject or not previewObjectName then return end
    local model = previewObjectName
    if PreviewObject then
        SetEntityAsMissionEntity(PreviewObject, false, true)
        DeleteObject(PreviewObject)
        PreviewObject = nil
    end
    lib.requestModel(joaat(model))

    local xVect, yVect, zVect = GetObjectCoords()
    local obj = CreateObject(model, curPos.x + xVect, curPos.y + yVect, curPos.z + zVect, false, true, true)
    FreezeEntityPosition(obj, true)
    SetEntityCollision(obj, false, false)

    CurrentlyEditing = obj
    local data = useGizmo(obj)
    CurrentlyEditing = nil
    if not data or not DoesEntityExist(data.handle) then return end
    SetEntityCollision(data.handle, true, true)
    local settings = Config.PropSettings[model] or {}
    local propCreated, insertId = lib.callback.await('houses:server:createNewProp', 100, {
        model = model,
        x = data.position.x,
        y = data.position.y,
        z = data.position.z,
        rx = data.rotation.x,
        ry = data.rotation.y,
        rz = data.rotation.z,
        id = CurrentPropId,
        settings = settings
    })

    if propCreated and insertId then
        createdInProperty[#createdInProperty + 1] = {
            handle = obj,
            id = insertId,
            model = model,
        }
        previewObjectName = nil
    else
        SetEntityAsMissionEntity(obj, false, true)
        DeleteObject(obj)
    end
    cb('ok')
end)

RegisterNUICallback('editExisting', function (data, cb)
    if not DoesEntityExist(data.handle) then return end
    local lastPosition = GetEntityCoords(data.handle)
    local lastRotation = GetEntityRotation(data.handle, 2)
    local id = data.id
    local handle = data.handle
    local objData = useGizmo(handle)
    if not objData then return end
    local updated = lib.callback.await('houses:server:updateProp', 100, {
        x = objData.position.x,
        y = objData.position.y,
        z = objData.position.z,
        rx = objData.rotation.x,
        ry = objData.rotation.y,
        rz = objData.rotation.z,
        id = id
    })

    if not updated then
        SetEntityCoords(handle, lastPosition.x, lastPosition.y, lastPosition.z, false, false, false, false)
        SetEntityRotation(handle, lastRotation.x, lastRotation.y, lastRotation.z, 2, true)
    end
end)

RegisterNUICallback('removeProp', function (data, cb)
    local id = data.id
    local deleted = lib.callback.await('houses:server:deleteProp', 100, {
        id = id
    })

    if deleted then
        local found = false
        for i = 1, #currentPropertyObjects do
            local prop = currentPropertyObjects[i]
            if prop.id == id then
                found = true
                SetEntityAsMissionEntity(prop.handle, false, true)
                DeleteObject(prop.handle)
                table.remove(currentPropertyObjects, i)
            end
        end
        if not found then
            for i = 1, #createdInProperty do
                local prop = createdInProperty[i]
                if prop.id == id then
                    SetEntityAsMissionEntity(prop.handle, false, true)
                    DeleteObject(prop.handle)
                    table.remove(createdInProperty, i)
                end
            end
        end
    end
end)


function SpawnPropertyObjects(id)
    local props = lib.callback.await('houses:server:getObjects', false, id)
    if #props == 0 then return end
    local hasContainer = false

    for i = 1, #props do
        local prop = props[i]
        local coords = vec3(prop.x, prop.y, prop.z)
        local rotation = vec3(prop.rx, prop.ry, prop.rz)
        local model = prop.model
        local settings = json.decode(prop.propSettings)

        lib.requestModel(joaat(model))
        local obj = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, false, true, true)
        SetEntityRotation(obj, rotation.x, rotation.y, rotation.z, 2, true)
        FreezeEntityPosition(obj, true)
        SetModelAsNoLongerNeeded(model)

        if settings and settings.type then
            local type = settings.type
            if type == 'storage' and not hasContainer then
                local stashId = lib.callback.await('houses:server:registerStash', 100, {
                    model = model,
                    id = prop.id,
                    houseId = id,
                    slots = settings.slots or 30,
                    weight = settings.weight or 10000,
                })

                if stashId then
                    exports.ox_target:addLocalEntity(obj, {
                        {
                            label = 'Open Stash',
                            name = ('open_stash_%s'):format(stashId),
                            icon = 'fas fa-box',
                            distance = 1.5,
                            onSelect = function()
                                exports.ox_inventory:openInventory('stash', stashId)
                            end
                        }
                    })
                    hasContainer = true
                end
            end
        end

        currentPropertyObjects[#currentPropertyObjects + 1] = {
            handle = obj,
            id = prop.id,
            model = model,
        }
    end
end

function DespawnProps()
    for i = 1, #currentPropertyObjects do
        local prop = currentPropertyObjects[i]
        SetEntityAsMissionEntity(prop.handle, false, true)
        DeleteObject(prop.handle)
    end
    for i = 1, #createdInProperty do
        local prop = createdInProperty[i]
        SetEntityAsMissionEntity(prop.handle, false, true)
        DeleteObject(prop.handle)
    end
    currentPropertyObjects = {}
    createdInProperty = {}
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DespawnProps()
    end
end)
