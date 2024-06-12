# g5_trafico

## qb-inventory
Adicionar a export abaixo em `@qb-inventory/server/functions.lua`

## Export
```lua
---Gets the inventory capacity
---@return number weight of backpack capacity
local function GetBackPackCapacity()
    return Config.MaxInventoryWeight
end

exports("GetBackPackCapacity", GetBackPackCapacity)
```