local currentProperty = nil
local lastCoords = nil
local lastHeading = nil
local exitPoint = nil
local canDecorateMenu = nil

CurrentPropId = nil


local function leaveProperty()
    if not currentProperty or inDecorMode then return end
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end
    if canDecorateMenu then exports['qb-radialmenu']:RemoveOption(canDecorateMenu) end
    SetEntityCoords(cache.ped, lastCoords)
    SetEntityHeading(cache.ped, (lastHeading - 180))

    if DoesEntityExist(currentProperty) then
        DeleteEntity(currentProperty)
        currentProperty = nil
        lastCoords = nil
        lastHeading = nil
    end
    DespawnProps()
    CurrentPropId = nil
    exitPoint:remove()
    exitPoint = nil
    DoScreenFadeIn(1000)
end

local function createExitPoint(coords)
    exitPoint = lib.points.new({
        coords = coords,
        distance = 1,
    })

    function exitPoint:onEnter()
        lib.showTextUI('**[E]** - Exit')
    end

    function exitPoint:onExit()
        lib.hideTextUI()
    end

    function exitPoint:nearby()
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
            lib.hideTextUI()
            leaveProperty()
        end
    end
end

RegisterNetEvent("houses:client:toggleDecorate", function(data)
    local isOwner = lib.callback.await('housing:server:isOwner', false, data.owner)
    if isOwner and currentProperty then
        UseDecorateMenu(data.houseId)
    end
end)

function EnterProperty(data)
    local canEnter, message = lib.callback.await('houses:server:canEnter', 100, data.id)

    if not canEnter then
        QBCore.Functions.Notify(message, 'error')
        return
    end

    lib.hideTextUI()
    lastCoords = GetEntityCoords(cache.ped)
    lastHeading = GetEntityHeading(cache.ped)

    if not data.shell then return end

    local propertyData = Config.ShellData[data.shell]

    local shellCoords = data.coords - vector3(0.0, 0.0, Config.MinZ)
    local offset = propertyData.exit
    local model = joaat(data.shell)

    lib.requestModel(model, 1000)

    local object = CreateObject(model, shellCoords.x, shellCoords.y, shellCoords.z, false, true, true)
    FreezeEntityPosition(object, true)

    local offsetCoords = GetOffsetFromEntityInWorldCoords(object, offset.x, offset.y, offset.z)

    currentProperty = object
    CurrentPropId = data.id

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end

    SetEntityCoords(cache.ped, offsetCoords)
    SetEntityHeading(cache.ped, offsetCoords.w)

    createExitPoint(offsetCoords)
    Wait(100)

    
    DoScreenFadeIn(1000)
    SpawnPropertyObjects(data.id)
    local isOwner = lib.callback.await('housing:server:isOwner', false, data.owner)
    if isOwner then
        canDecorateMenu = exports['qb-radialmenu']:AddOption({
            id = 'can_decorate',
            title = 'Decorate',
            icon = 'paint-roller',
            type = 'client',
            event = 'houses:client:toggleDecorate',
            shouldClose = true,
            houseId = data.id,
            owner = data.owner,
        }, canDecorateMenu)
    end
end

CreateThread(function()
    while true do
        local wait = currentProperty and 0 or 5000
        if currentProperty then
            SetRainLevel(0.0)
            SetWeatherTypePersist('CLEAR')
            SetWeatherTypeNow('CLEAR')
            SetWeatherTypeNowPersist('CLEAR')
            NetworkOverrideClockTime(22, 0, 0)
        end
        Wait(wait)
    end
end)