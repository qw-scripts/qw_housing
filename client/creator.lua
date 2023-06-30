RegisterNetEvent("housing:client:new", function()
    if GetInvokingResource() then return end
    local levelOptions = {}

    for k, v in pairs(Config.Shells) do
        table.insert(levelOptions, {label = v, value = v})
    end

    local input = lib.inputDialog('House Creator', {
        {type = 'number', label = 'House Price', description = 'price to purchase the House', icon = 'dollar-sign', required = true, min = 1, default = 1},
        {type = 'select', label = 'House Shell', description = 'pick a shell', required = true, options = levelOptions},
      })
       
      if not input then return end

      local currentCoords = GetEntityCoords(cache.ped)

      local data = {
        price = input[1],
        shell = input[2],
        coords = currentCoords
      }

      local created = lib.callback.await('housing:server:create', 100, data)

      if created then
        QBCore.Functions.Notify('House Created', 'success')
      end
end)