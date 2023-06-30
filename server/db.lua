local MySQL = MySQL
local db = {}

local SELECT_HOUSE_BY_ID = 'SELECT * FROM `houses` WHERE `id` = ? LIMIT 1'
--- Get house by id
---@param id number
---@return table | nil
function db.selectHouse(id)
    return  MySQL.single.await(SELECT_HOUSE_BY_ID, { id }) or nil
end

local SELECT_ALL_HOUSES = 'SELECT * FROM `houses`'
--- Get all houses
---@return table
function db.selectAllHouses()
    return MySQL.query.await(SELECT_ALL_HOUSES) or {}
end

local SELECT_PROPS_BY_HOUSE_ID = 'SELECT * FROM `housing_props` WHERE `houseId` = ?'
--- Get props by house id
---@param houseId number
---@return table
function db.selectPropsByHouseId(houseId)
    return MySQL.query.await(SELECT_PROPS_BY_HOUSE_ID, { houseId }) or {}
end

local CREATE_NEW_HOUSE = 'INSERT INTO `houses` (`price`, `shell`, `x`, `y`, `z`) VALUES (?, ?, ?, ?, ?)'
--- Create new house
---@param price number
---@param shell string
---@param x number
---@param y number
---@param z number
---@return number
function db.createHouse(price, shell, x, y, z)
    return MySQL.prepare.await(CREATE_NEW_HOUSE, { price, shell, x, y, z })
end

local UPDATE_NEW_OWNER = 'UPDATE `houses` SET `owned` = 1, `owner` = ? WHERE `id` = ?'
--- Update new owner
---@param owner string
---@param houseId number
---@return number
function db.updateNewOwner(owner, houseId)
    return MySQL.prepare.await(UPDATE_NEW_OWNER, { owner, houseId })
end

local CREATE_NEW_PROP = 'INSERT INTO `housing_props` (`houseId`, `model`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `propSettings`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
--- Create new prop
---@param houseId number
---@param model string
---@param x number
---@param y number
---@param z number
---@param rx number
---@param ry number
---@param rz number
---@param settings string
---@return number
function db.createProp(houseId, model, x, y, z, rx, ry, rz, settings)
    return MySQL.prepare.await(CREATE_NEW_PROP, { houseId, model, x, y, z, rx, ry, rz, settings })
end

local DELETE_PROP = 'DELETE FROM `housing_props` WHERE `id` = ?'
--- Delete prop
---@param id number
---@return number
function db.deleteProp(id)
    return MySQL.prepare.await(DELETE_PROP, { id })
end

local UPDATE_PROP_POSITION = 'UPDATE `housing_props` SET `x` = ?, `y` = ?, `z` = ?, `rx` = ?, `ry` = ?, `rz` = ? WHERE `id` = ?'
--- Update prop position
---@param x number
---@param y number
---@param z number
---@param rx number
---@param ry number
---@param rz number
---@param id number
---@return number
function db.updatePropPosition(x, y, z, rx, ry, rz, id)
    return MySQL.prepare.await(UPDATE_PROP_POSITION, { x, y, z, rx, ry, rz, id })
end


return db