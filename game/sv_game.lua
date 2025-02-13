--[[
BY Rejox#7975 © RX
--]]

GlobalState[States.Global.GameActive] = false
GlobalState[States.Global.CurrentMap] = nil
GlobalState[States.Global.PlayersInGame] = 0
GlobalState[States.Global.RoundTimeLeft] = nil

GunGame = {}
GunGame.Players = {}

local finishing = false

function LeaveGunGame(src)
    if GunGame.Players[src] then
        GunGame.Players[src] = nil
    end

    TriggerClientEvent("cl_game:leaveGunGame", src)
    Wait(300)

    SetPlayerRoutingBucket(src, Config.DefaultRoutingBucket)

    Server.SetInGame(src, false)
    Server.UpdatePlayersInGame(-1)
    Database.UpdatePlayerStats(src)
    Server.ResetPlayerStates(src)
end

local function sendPlayerToNewGame(src)
    Server.UpdatePlayersInGame(1)
    TriggerClientEvent("cl_game:sendToNewGame", src)
    Wait(300)
    Server.ResetPlayerStates(src)
end

local function finishGame(winnerId)
    if not finishing then
        finishing = true
        Server.SetGameActive(false)

        if not winnerId then
            Server.Notify(-1, _L('nobody_won'))
        else
            Server.GivePrizeWinner(winnerId)
            Server.Notify(-1, _L('won_game', GetPlayerName(winnerId)))
        end

        for src, player in pairs(GunGame.Players) do
            ShowScoreboard(src, true)
        end

        Wait(10000)

        finishing = false

        while not GetIsGameActive() do Wait(100) end

        for src, player in pairs(GunGame.Players) do
            sendPlayerToNewGame(src)

            HideBoard(src)
        end
    end
end

local function startGame(map)
    Server.SetCurrentMap(map)
    Server.SetPlayersInGame(0)
    Server.SetCurrentRoundTime(Config.Maps[map].RoundTime)
    Server.SetGameActive(true)

    CreateThread(function()
        while GetIsGameActive() and GetRoundTimeLeft() > 0 do
            Wait(1000)
            GlobalState[States.Global.RoundTimeLeft] = GlobalState[States.Global.RoundTimeLeft] - 1
        end

        finishGame()
    end)
end

RegisterNetEvent("sv_game:joinGunGame", function ()
    local src = source

    if not GunGame.Players[src] then
        GunGame.Players[src] = true
    end

    Server.ResetPlayerStates(src)

    TriggerClientEvent("cl_game:joinGunGame", src)
    Wait(300)

    SetPlayerRoutingBucket(src, Config.GunGameRoutingBucket)

    Server.SetInGame(src, true)
    Server.UpdatePlayersInGame(1)
end)

RegisterNetEvent("sv_game:leaveGunGame", function ()
    local src = source

    LeaveGunGame(src)
end)

RegisterNetEvent("sv_game:onDeath", function(victimId, killerId)
    Server.SetDeaths(victimId, Server.GetDeaths(victimId) + 1)

    local currentVictimLevel = Server.GetCurrentLevel(victimId)

    if currentVictimLevel > 1 then
        Server.SetCurrentLevel(victimId, currentVictimLevel - 1)
        Server.Notify(victimId, _L('level_changed', currentVictimLevel - 1))
    end

    if killerId and killerId ~= 0 then
        Server.SetKills(killerId, Server.GetKills(killerId) + 1)

        local currentKillerLevel = Server.GetCurrentLevel(killerId)

        if currentKillerLevel == #Config.Levels then
            finishGame(killerId)
            return
        end

        if currentKillerLevel < #Config.Levels then
            Server.SetCurrentLevel(killerId, currentKillerLevel + 1)
            Server.Notify(killerId, _L('level_changed', currentKillerLevel + 1))
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1000)

        if not finishing and not GetIsGameActive() then
            local randomMap = math.random(1, #Config.Maps)
            startGame(randomMap)
        end
    end
end)

exports('StartGame', function(random, map)
    local map = map or nil
    if random then
        map = math.random(1, #Config.Maps)
    end
    startGame(map)
end)

exports('IsGameFinishing', function()
    return finishing
end)