--[[
BY Rejox#7975 © RX
--]]

-- HELPER COMMANDS FOR DEV --
RegisterCommand('leavegungame', function (source, args, raw)
    TriggerServerEvent("sv_game:leaveGunGame")
end)

RegisterCommand('tptogungame', function (source, args, raw)
    SetEntityCoords(PlayerPedId(), Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z)
end)

local function spawnPlayer()
    local playerPed = PlayerPedId()
    local randomSpawnPoint = Config.Maps[GlobalState[States.Global.CurrentMap]].SpawnPoints[math.random(1, #Config.Maps[GlobalState[States.Global.CurrentMap]].SpawnPoints)]

    NetworkResurrectLocalPlayer(randomSpawnPoint, false, false)

    local currentLevel = LocalPlayer.state[States.Player.CurrentLevel]
    local weapon = RequestWeapon(Config.Levels[currentLevel].Weapon)
    GiveWeaponToPed(playerPed, GetHashKey(weapon), 250, false, true)
    SetPedInfiniteAmmo(playerPed, true, GetHashKey(weapon))

    CreateThread(function()
        while not LocalPlayer.state[States.Player.InGame] do Wait(0) end

        SetEntityAlpha(playerPed, 102, false)
        SetLocalPlayerAsGhost(true)

        Wait(3000)

        SetEntityAlpha(playerPed, 255, false)
        SetLocalPlayerAsGhost(false)
    end)
end

local function onDeath(victimPed, killerPed)
    local victimId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victimPed))
    local killerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killerPed))

    TriggerServerEvent("sv_game:onDeath", victimId, killerId)
end

RegisterNetEvent("cl_game:joinGunGame", function ()
    DoScreenFadeOut(300)
    while not IsScreenFadedOut() do Wait(0) end

    InitializeZone()
    spawnPlayer()

    while not LocalPlayer.state[States.Player.InGame] do Wait(0) end

    CreateThread(function()
        while LocalPlayer.state[States.Player.InGame] do
            Wait(0)

            local playerPed = PlayerPedId()

            local currentWeapon = GetSelectedPedWeapon(playerPed)
            local currentLevel = LocalPlayer.state[States.Player.CurrentLevel]
            local levelWeapon = Config.Levels[currentLevel].Weapon

            if currentWeapon ~= GetHashKey(levelWeapon) then
                local weapon = RequestWeapon(levelWeapon)
                GiveWeaponToPed(playerPed, GetHashKey(weapon), 250, false, true)
                SetPedInfiniteAmmo(playerPed, true, GetHashKey(weapon))
            end
        end
    end)

    DoScreenFadeIn(300)
end)

RegisterNetEvent("cl_game:leaveGunGame", function ()
    DoScreenFadeOut(300)
    while not IsScreenFadedOut() do Wait(0) end

    NetworkResurrectLocalPlayer(Config.JoinLobby.Coords, false, false)
    DeleteZone()

    while LocalPlayer.state[States.Player.InGame] do Wait(0) end
    DoScreenFadeIn(300)
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event == "CEventNetworkEntityDamage" then
        local victim, attacker, victimDied, weapon = data[1], data[2], data[4], data[7]
        if not IsEntityAPed(victim) or not IsEntityAPed(attacker) then return end
        if victimDied and NetworkGetPlayerIndexFromPed(victim) == PlayerId() and IsEntityDead(PlayerPedId()) then
            onDeath(victim, attacker)
        end
    end
end)