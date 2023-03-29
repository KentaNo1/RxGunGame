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

    local currentMap = GlobalState[States.Global.CurrentMap]

    zone = PolyZone:Create(Config.Maps[currentMap].Zone, { 
        name = currentMap,
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
            LocalPlayer.state:set("outsideZone", false, true)
        else
            LocalPlayer.state:set("outsideZone", true, true)

            CreateThread(function()
                local maximumOutOfZoneTime = Config.Maps[currentMap].MaximumOutOfZoneTime

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

function DeleteZone()
    if zone then
        zone:destroy()
    end
end