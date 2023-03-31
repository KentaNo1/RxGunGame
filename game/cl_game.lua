--[[
BY Rejox#7975 © RX
--]]

local isDead = false

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

    local levelWeapon = Client.GetCurrentLevelWeapon()
    GiveWeaponToPed(playerPed, GetHashKey(levelWeapon), 9999, false, true)

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

function OnDeath(victimPed, killerPed)
    local victimId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victimPed))
    local killerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killerPed))

    TriggerServerEvent("sv_game:onDeath", victimId, killerId)

    StartScreenEffect("DeathFailOut", 0, false)
    isDead = true

    local respawnTimer = GetCurrentMap().RespawnTime

    CreateThread(function()
        while respawnTimer > 0 and Client.GetInGame() do
            Wait(0)
            DrawScreenText("~s~Respawning in ~r~" .. respawnTimer .. " ~s~seconds", 0.5, 0.83, 0.7, 4, true, true)
        end
    end)

    CreateThread(function()
        while respawnTimer > 0 and Client.GetInGame() do
            Wait(1000)
            respawnTimer = respawnTimer - 1
        end
    
        if Client.GetInGame() and isDead then
            spawnPlayer()
        end
    end)
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
            
            local stats = Client.GetStats()
            local currentLevel = Config.Levels[stats.level]
            local nextLevel = Config.Levels[stats.level + 1]
            local nextWeapon = nextLevel and nextLevel.WeaponLabel or "None"

            local rectangle = { x = 0.0, y = 0.46, w = 0.138, h = 0.25 }
            DrawScreenText("~s~Kills: ~r~" .. stats.kills .. "\n~s~Deaths: ~r~" .. stats.deaths .. "\n~s~Level: ~r~" .. currentLevel.Label .. "\n~s~K/D: ~r~" .. stats.kd, 0.01, 0.35, 0.4, 4, false, false, rectangle)
            DrawScreenText("\n~s~Current \n~r~" .. currentLevel.WeaponLabel .. "\n~s~Next \n~r~" .. nextWeapon, 0.01, 0.45, 0.4, 4, false, false, rectangle2)
        end
    end)

    InitializeScoreboard()
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

Citizen.CreateThread(function()
    print("^2Successfully loaded ^5" .. GetCurrentResourceName() .. " ^2by ^5Rejox#7975 ^6(https://discord.gg/fyzcj8dAkq)")
end)