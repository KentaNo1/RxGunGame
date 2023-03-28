--[[
BY Rejox#7975 © RX
--]]

local zones = nil

function InitializeZones()
    if zones ~= nil then
        return
    else
        zones = {}
    end

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
                LocalPlayer.state:set("outsideZone", false, true)
            else
                LocalPlayer.state:set("outsideZone", true, true)

                CreateThread(function()
                    local maximumOutOfZoneTime = Config.Maps[map].MaximumOutOfZoneTime

                    while LocalPlayer.state.outsideZone and maximumOutOfZoneTime > 0 do
                        Wait(1000)
                        maximumOutOfZoneTime = maximumOutOfZoneTime - 1

                        print(maximumOutOfZoneTime)

                        if maximumOutOfZoneTime == 0 then
                            TriggerServerEvent("sv_game:leaveGunGame")
                        end
                    end
                end)
            end
        end)
    end
end

function DeleteZones()
    for map, zone in pairs(zones) do
        zone:destroy()
    end
end