--[[
BY Rejox#7975 © RX
--]]

RegisterNetEvent("sv_game:joinGunGame", function ()
    local src = source

    TriggerClientEvent("cl_game:joinGunGame", src)
end)

RegisterNetEvent("sv_game:leaveGunGame", function ()
    local src = source

    TriggerClientEvent("cl_game:leaveGunGame", src)
end)