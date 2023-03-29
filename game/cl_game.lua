--[[
BY Rejox#7975 © RX
--]]

-- HELPER COMMANDS FOR DEV --
RegisterCommand('leavegungame', function (source, args, raw)
    TriggerServerEvent("sv_game:leaveGunGame")
end)

RegisterNetEvent("cl_game:joinGunGame", function ()
    DoScreenFadeOut(300)
    while not IsScreenFadedOut() do Wait(0) end

    InitializeZone()

    while not LocalPlayer.state[States.Player.InGame] do Wait(0) end
    DoScreenFadeIn(300)
end)

RegisterNetEvent("cl_game:leaveGunGame", function ()
    DoScreenFadeOut(300)
    while not IsScreenFadedOut() do Wait(0) end

    DeleteZone()

    while LocalPlayer.state[States.Player.InGame] do Wait(0) end
    DoScreenFadeIn(300)
end)