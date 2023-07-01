local housingPoints = {}
local lockHouseMenu = nil

local function pruchaseHouse(data)
    lib.registerContext({
        id = 'purchase_house',
        title = 'Purchase Property',
        options = {
            {
                title = 'Make the Purchase',
                description = ('buy this property for **$%s**'):format(data.price),
                icon = 'dollar-sign',
                onSelect = function()
                    local purchased = lib.callback.await('houses:server:purchase', 100, data.id, data.price)

                    if purchased then
                        QBCore.Functions.Notify('Property purchased', 'success')
                    end
                end,
            },
        }
    })

    lib.showContext('purchase_house')
end

RegisterNetEvent("houses:client:togglePropertyLock", function(data)
    local state, message = lib.callback.await('houses:server:toggleLock', 100, data.houseId)

    if state then
        QBCore.Functions.Notify(message, 'success')
    else
        QBCore.Functions.Notify(message, 'error')
    end
end)

local function placePoints()
    local locations = lib.callback.await('housing:server:getHouses', 100)

    if locations then
        for _, v in pairs(locations) do
            local coords = vec3(v.x, v.y, v.z)

            local point = lib.points.new({
                coords = coords,
                distance = 1.5,
                shell = v.shell,
                owned = v.owned,
                owner = v.owner,
                price = v.price,
                houseId = v.id
            })

            function point:onEnter()
                if not self.owned then
                    lib.showTextUI(('**[E]** - Purchase (**$%s**)'):format(self.price))
                else
                    local isOwner = lib.callback.await('housing:server:isOwner', false, self.owner)
                    if isOwner then
                        lockHouseMenu = exports['qb-radialmenu']:AddOption({
                            id = 'lock_property',
                            title = 'Lock/Unlock Property',
                            icon = 'lock',
                            type = 'client',
                            event = 'houses:client:togglePropertyLock',
                            shouldClose = true,
                            houseId = self.houseId
                        }, lockHouseMenu)
                    end
                end
            end

            function point:onExit()
                lib.hideTextUI()
                if lockHouseMenu then exports['qb-radialmenu']:RemoveOption(lockHouseMenu) end
            end

            function point:nearby()
                if self.currentDistance < 1.0 and IsControlJustReleased(0, 38) then
                    if not self.owned then
                        lib.hideTextUI()
                        pruchaseHouse({ price = self.price, id = self.houseId })
                    else
                        EnterProperty({ 
                            id = self.houseId,
                            shell = self.shell,
                            owner = self.owner,
                            coords = coords
                         })
                    end
                end
            end

            table.insert(housingPoints, point)
        end
    end
end

local function removePoints()
    lib.hideTextUI()
    for _, v in pairs(housingPoints) do
        v:remove()
    end
    housingPoints = {}
end

RegisterNetEvent("housing:client:refreshPoints", function()
    if lockHouseMenu then exports['qb-radialmenu']:RemoveOption(lockHouseMenu) end
    removePoints()
    Wait(500)
    placePoints()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() 
    Wait(1000)
    placePoints()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        placePoints()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if lockHouseMenu then exports['qb-radialmenu']:RemoveOption(lockHouseMenu) end
        removePoints()
    end
end)
