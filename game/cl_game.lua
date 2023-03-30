--[[
BY Rejox#7975 © RX
--]]

local isDead = false

-- HELPER COMMANDS FOR DEV --
RegisterCommand('leavegungame', function (source, args, raw)
    TriggerServerEvent("sv_game:leaveGunGame")
end)

RegisterCommand('tptogungame', function (source, args, raw)
    SetEntityCoords(PlayerPedId(), Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z)
end)

local function revivePlayer()
    local playerPed = PlayerPedId()

    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    ClearPedBloodDamage(playerPed)
    SetPlayerSprint(PlayerId(), true)
    ResetPedMovementClipset(playerPed, 0.0)
    ClearPedTasksImmediately(playerPed)

    if isDead then
        StopScreenEffect("DeathFailOut")
        isDead = false
    end
end

local function spawnPlayer()
    DoScreenFadeOut(300)
    while not IsScreenFadedOut() do Wait(0) end

    local playerPed = PlayerPedId()
    local randomSpawnPoint = GetRandomSpawnPoint()

    revivePlayer()
    NetworkResurrectLocalPlayer(randomSpawnPoint, false, false)

    CreateThread(function()
        while not Client.GetInGame() do Wait(0) end

        SetEntityAlpha(playerPed, 102, false)
        SetLocalPlayerAsGhost(true)

        Wait(GetCurrentMap().InvincibleOnSpawnTime * 1000)

        SetEntityAlpha(playerPed, 255, false)
        SetLocalPlayerAsGhost(false)
    end)

    DoScreenFadeIn(300)
end

local function onDeath(victimPed, killerPed)
    local victimId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victimPed))
    local killerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killerPed))

    TriggerServerEvent("sv_game:onDeath", victimId, killerId)

    StartScreenEffect("DeathFailOut", 0, false)
    isDead = true

    local respawnTimer = GetCurrentMap().RespawnTime
    while respawnTimer > 0 do
        Wait(1000)
        respawnTimer = respawnTimer - 1
    end

    if Client.GetInGame() then
        spawnPlayer()
    end
end

RegisterNetEvent("cl_game:joinGunGame", function ()
    spawnPlayer()
    InitializeZone()

    while not Client.GetInGame() do Wait(0) end

    CreateThread(function()
        while Client.GetInGame() do
            Wait(0)

            local playerPed = PlayerPedId()

            local currentWeapon = GetSelectedPedWeapon(playerPed)
            local levelWeapon = Client.GetCurrentLevelWeapon()

            if currentWeapon ~= GetHashKey(levelWeapon) then
                if HasPedGotWeapon(playerPed, levelWeapon, false) then
                    SetCurrentPedWeapon(playerPed, levelWeapon, true)
                else
                    GiveWeaponToPed(playerPed, GetHashKey(levelWeapon), 9999, false, true)
                end

                currentWeapon = GetSelectedPedWeapon(playerPed)
            end

            if GetAmmoInPedWeapon(playerPed, currentWeapon) == 0 then
                SetPedAmmo(playerPed, currentWeapon, 9999)
            end

            local _, currentAmmoInClip = GetAmmoInClip(playerPed, currentWeapon)
            if currentAmmoInClip == 0 then
                TaskReloadWeapon(playerPed)
            end
        end
    end)
end)

RegisterNetEvent("cl_game:leaveGunGame", function ()
    local playerPed = PlayerPedId()

    DoScreenFadeOut(300)
    while not IsScreenFadedOut() do Wait(0) end

    NetworkResurrectLocalPlayer(Config.JoinLobby.Coords, false, false)
    revivePlayer()
    DeleteZone()
    
    while Client.GetInGame() do Wait(0) end

    RemoveAllPedWeapons(playerPed, true)

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