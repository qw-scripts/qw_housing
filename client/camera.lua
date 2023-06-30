local MainCamera = nil
local inCam = false
local startingCoords = nil
curPos = nil

local function CreateEditCamera()
	local rot = GetEntityRotation(cache.ped)
	local pos = GetEntityCoords(cache.ped, true)
	MainCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z + 1.3, rot.x, rot.y, rot.z, 60.00, false, 0)
	SetCamActive(MainCamera, true)
	RenderScriptCams(true, true, 500, true, true)
end

function EnableEditMode()
	local pos = GetEntityCoords(cache.ped, true)
    startingCoords = pos
	curPos = {x = pos.x, y = pos.y, z = pos.z}
	SetEntityVisible(cache.ped, false)
	FreezeEntityPosition(cache.ped, true)
	SetEntityCollision(cache.ped, false, false)
	CreateEditCamera()
end

local function SetDefaultCamera()
	RenderScriptCams(false, true, 500, true, true)
	SetCamActive(MainCamera, false)
	DestroyCam(MainCamera, true)
	DestroyAllCams(true)
    MainCamera = nil
end

function DisableEditMode()
    SetEntityCoords(cache.ped, startingCoords.x, startingCoords.y, startingCoords.z, false, false, false, false)
	SetEntityVisible(cache.ped, true)
	FreezeEntityPosition(cache.ped, false)
	SetEntityCollision(cache.ped, true, true)
    startingCoords = nil
	SetDefaultCamera()
	EnableAllControlActions(0)
end


local function degToRad( degs )
    return degs * 3.141592653589793 / 180
end

function GetObjectCoords()
    local rotation = GetCamRot(MainCamera, 2)
    local xVect = 2.5 * math.sin( degToRad( rotation.z ) ) * -1.0
    local yVect = 2.5 * math.cos( degToRad( rotation.z ) )
    local zVect = 2.5 * math.tan( degToRad( rotation.x ) - degToRad( rotation.y ))
    return xVect, yVect, zVect
end

local function CheckRotationInput()
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(MainCamera, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		local new_z = rotation.z + rightAxisX*-1.0*(2.0)*(4.0+0.1)
		local new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(2.0)*(4.0+0.1)), -20.5)
		SetCamRot(MainCamera, new_x, 0.0, new_z, 2)
	end
end

local function CheckMovementInput()
	local rotation = GetCamRot(MainCamera, 2)

	local xVect = 0.05 * math.sin( degToRad( rotation.z ) ) * -1.0
    local yVect = 0.05 * math.cos( degToRad( rotation.z ) )
    local zVect = 0.05 * math.tan( degToRad( rotation.x ) - degToRad( rotation.y ))

    if IsControlPressed( 1, 32) or IsDisabledControlPressed(1, 32) then -- W
		curPos.x = curPos.x + xVect
		curPos.y = curPos.y + yVect
		curPos.z = curPos.z + zVect
    end

    if IsControlPressed( 1, 33) or IsDisabledControlPressed(1, 33) then -- S
		curPos.x = curPos.x - xVect
        curPos.y = curPos.y - yVect
        curPos.z = curPos.z - zVect
	end

    if IsControlPressed( 1, 34) or IsDisabledControlPressed(1, 34) then -- A
        curPos.x = curPos.x - yVect
        curPos.y = curPos.y + xVect
    end

    if IsControlPressed( 1, 35) or IsDisabledControlPressed(1, 35) then -- D
        curPos.x = curPos.x + yVect
        curPos.y = curPos.y - xVect
    end

	SetCamCoord(MainCamera, curPos.x, curPos.y, curPos.z)
end

CreateThread(function()
    while true do
        if MainCamera and inDecorMode then
            CheckRotationInput()
            CheckMovementInput()
        end
        Wait(0)
    end
end)

CreateThread(function()
	while true do
		if MainCamera and inDecorMode then
			local camPos = GetCamCoord(MainCamera)
			local dist = #(vector3(camPos.x, camPos.y, camPos.z) - startingCoords)
			if dist > 50.0 then
				CloseMenu()
				QBCore.Functions.Notify("Out of Range", 'error')
			end
		end
        Wait(7)
	end
end)