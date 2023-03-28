--[[
BY Rejox#7975 © RX
--]]

local zones = {}

for map, values in pairs(Config.Maps) do
    zones[map] = PolyZone:Create(values.Zone, { 
        name = map,
        minZ = 0,
        maxZ = 150,
        debugPoly = true,
        debugColors = {
            walls = { 255, 0, 0 },
            outline = { 0, 0, 0 },
            grid = { 0, 255, 0 },
        }
    })

    zones[map]:onPlayerInOut(function(inside, point)
        if inside then
            print("Entered zone: " .. map)
        else
            print("Exited zone: " .. map)
        end
    end)
end
