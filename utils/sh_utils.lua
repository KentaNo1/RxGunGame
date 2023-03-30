--[[
BY Rejox#7975 © RX
--]]

Boards = {
    Scoreboard = "scoreboard",
    Leaderboard = "leaderboard"
}

function GetIsGameActive()
    return GlobalState[States.Global.GameActive]
end

function GetCurrentMap()
    return Config.Maps[GlobalState[States.Global.CurrentMap]]
end

function GetRandomSpawnPoint()
    local spawnPoints = GetCurrentMap().SpawnPoints
    local randomSpawnPoint = spawnPoints[math.random(1, #spawnPoints)]

    return randomSpawnPoint
end

function GetPlayersInGame()
    return GlobalState[States.Global.PlayersInGame]
end

function GetRoundTimeLeft()
    return GlobalState[States.Global.RoundTimeLeft]
end