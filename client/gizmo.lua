local usingGizmo = false
local hasFocus = false
inDecorMode = false
cachedProps = nil

local function toggleNuiFrame(bool)
  usingGizmo = bool
  hasFocus = bool
  SetNuiFocus(bool, bool)
end

function UseDecorateMenu(id)
  EnableEditMode()
  inDecorMode = true
  if not cachedProps then
    local props = lib.callback.await('housing:server:getProps', false)
    cachedProps = props
  end
  SendNUIMessage({
    action = 'setAllProps',
    data = {
      allProps = cachedProps
    }
  })
  SendNUIMessage({
    action = 'setCurrentProps',
    data = {
      currentProps = GetCurrentPropertyObjects()
    }
  })
  SendNUIMessage({
    action = 'openObjectMenu',
    data = true
  })
  SetNuiFocus(true, true)
  hasFocus = true
end

function useGizmo(handle)
  if not handle or not DoesEntityExist(handle) then
    return
  end
  SendNUIMessage({
    action = 'setGizmoEntity',
    data = {
      handle = handle,
      model = joaat(GetEntityModel(handle)),
      position = GetEntityCoords(handle),
      rotation = GetEntityRotation(handle)
    }
  })

  toggleNuiFrame(true)

  while usingGizmo do
    SendNUIMessage({
      action = 'setCameraPosition',
      data = {
        position = GetFinalRenderedCamCoord(),
        rotation = GetFinalRenderedCamRot()
      }
    })
    Wait(0)
  end

  return {
    handle = handle,
    position = GetEntityCoords(handle),
    rotation = GetEntityRotation(handle)
  }
end

RegisterNUICallback('moveEntity', function(data, cb)
  local entity = data.handle
  local position = data.position
  local rotation = data.rotation

  SetEntityCoords(entity, position.x, position.y, position.z, false, false, false, false)
  SetEntityRotation(entity, rotation.x, rotation.y, rotation.z, 2, true)
  if data.snap then
    PlaceObjectOnGroundProperly(entity)
  end
  cb('ok')
end)

RegisterNUICallback('changeFocus', function (data, cb)
  hasFocus = not hasFocus
  SetNuiFocus(hasFocus, hasFocus)
  cb('ok')
end)

RegisterNUICallback('finishEdit', function(data, cb)
  usingGizmo = false
  SendNUIMessage({
    action = 'setGizmoEntity',
    data = {
      handle = nil,
    }
  })
  cb('ok')
end)

function CloseMenu()
  DisableEditMode()
  if CurrentlyEditing and DoesEntityExist(CurrentlyEditing) then
    SetEntityAsMissionEntity(CurrentlyEditing, false, true)
    DeleteObject(CurrentlyEditing)
    CurrentlyEditing = nil
  end
  inDecorMode = false
  toggleNuiFrame(false)
  SendNUIMessage({
    action = 'openObjectMenu',
    data = false
  })
  SendNUIMessage({
    action = 'setGizmoEntity',
    data = {
      handle = nil,
    }
  })
  if PreviewObject then
    SetEntityAsMissionEntity(PreviewObject, false, true)
    DeleteObject(PreviewObject)
    PreviewObject = nil
  end
end

RegisterNUICallback('close', function(data, cb)
  CloseMenu()
  cb('ok')
end)

exports("useGizmo", useGizmo)

CreateThread(function()
  while true do
    local wait = inDecorMode and 0 or 1000
    -- right click
    if IsControlJustReleased(0, 25) and not hasFocus and inDecorMode then
      SetNuiFocus(true, true)
      hasFocus = true
    end
    Wait(wait)
  end
end)
