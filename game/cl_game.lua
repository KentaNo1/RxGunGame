--[[
BY Rejox#7975 © RX
--]]

-- HELPER COMMANDS FOR DEV --
RegisterCommand('leavegungame', function (source, args, raw)
    TriggerServerEvent("sv_game:leaveGunGame")
end)

RegisterNetEvent("cl_game:joinGunGame", function ()
    InitializeZone()
end)

RegisterNetEvent("cl_game:leaveGunGame", function ()
    DeleteZone()
end)