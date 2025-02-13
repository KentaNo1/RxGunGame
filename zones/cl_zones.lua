--[[
    CREATED BY:
    https://store.rxscripts.xyz/

    JOIN DIS FOR MORE SCRIPTS:
    https://discord.gg/DHnjcW96an
--]]

Zone = nil
IsInsideZone = false

function DeleteZone()
    if Zone then
        Zone:remove()
        Zone = nil
    end
end

function InitializeZone()
    if Zone ~= nil then
        DeleteZone()
    end

    local currentMap = GetCurrentMap()

    Zone = lib.zones.poly({
        points = currentMap.Zone,
        thickness = 150,
        debug = true,
        onEnter = function()
            Client.SetOutsideZone(false)
            StopScreenEffect("Rampage")
        end,
        onExit = function()
            Client.SetOutsideZone(true)

            StartScreenEffect("Rampage", 0, false)

            local maximumOutOfZoneTime = GetCurrentMap().MaximumOutOfZoneTime

            CreateThread(function()
                while maximumOutOfZoneTime > 0 and Client.GetInGame() and Client.GetOutsideZone() do
                    Wait(0)
                    DrawScreenText(_L('leaving', maximumOutOfZoneTime), 0.5, 0.83, 0.7, 4, true, true)
                end
            end)

            CreateThread(function()
                while maximumOutOfZoneTime > 0 and Client.GetInGame() and Client.GetOutsideZone() do
                    Wait(1000)
                    maximumOutOfZoneTime = maximumOutOfZoneTime - 1
                end

                if Client.GetInGame() and Client.GetOutsideZone() then
                    TriggerServerEvent("sv_game:leaveGunGame")
                    Wait(300)
                    StopScreenEffect("Rampage")
                end
            end)
        end
    })
end