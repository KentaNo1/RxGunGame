--[[
BY Rejox#7975 © RX
--]]

local zone = nil

function InitializeZone()
    if zone ~= nil then
        return
    else
        zone = {}
    end

    local currentMap = GetCurrentMap()

    zone = PolyZone:Create(currentMap.Zone, { 
        name = currentMap.Label,
        minZ = 0,
        maxZ = 150,
        debugPoly = true,
        debugColors = {
            walls = { 255, 0, 0 },
            outline = { 0, 0, 0 },
            grid = { 0, 255, 0 },
        }
    })

    zone:onPlayerInOut(function(inside, point)
        if inside then
            Client.SetOutsideZone(false)
        else
            Client.SetOutsideZone(true)

            CreateThread(function()
                local maximumOutOfZoneTime = GetCurrentMap().MaximumOutOfZoneTime

                while Client.GetOutsideZone() and maximumOutOfZoneTime > 0 do
                    Wait(1000)
                    maximumOutOfZoneTime = maximumOutOfZoneTime - 1

                    if maximumOutOfZoneTime == 0 then
                        TriggerServerEvent("sv_game:leaveGunGame")
                    end
                end
            end)
        end
    end)
end

function DeleteZone()
    if zone then
        zone:destroy()
        zone = nil
    end
end