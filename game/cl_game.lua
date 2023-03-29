--[[
BY Rejox#7975 © RX
--]]

-- HELPER COMMANDS FOR DEV --
RegisterCommand('leavegungame', function (source, args, raw)
    TriggerServerEvent("sv_game:leaveGunGame")
end)

local function spawnPlayer()
    local randomSpawnPoint = Config.Maps[GlobalState[States.Global.CurrentMap]].SpawnPoints[math.random(1, #Config.Maps[GlobalState[States.Global.CurrentMap]].SpawnPoints)]

    NetworkResurrectLocalPlayer(randomSpawnPoint, false, false)
end

RegisterNetEvent("cl_game:joinGunGame", function ()
    DoScreenFadeOut(300)
    while not IsScreenFadedOut() do Wait(0) end

    InitializeZone()
    spawnPlayer()

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