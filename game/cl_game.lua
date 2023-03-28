--[[
BY Rejox#7975 © RX
--]]

RegisterNetEvent("cl_game:joinGunGame", function ()
    InitializeZones()
end)

RegisterNetEvent("cl_game:leaveGunGame", function ()
    DeleteZones()
end)