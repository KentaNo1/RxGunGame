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

    local activeMap = GlobalState.ActiveMap

    zone = PolyZone:Create(Config.Maps[activeMap].Zone, { 
        name = activeMap,
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
                local maximumOutOfZoneTime = Config.Maps[activeMap].MaximumOutOfZoneTime

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
    zone:destroy()
end