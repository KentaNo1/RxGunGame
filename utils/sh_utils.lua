--[[
    CREATED BY:
    https://store.rxscripts.xyz/

    JOIN DISCORD FOR MORE SCRIPTS:
    https://discord.gg/DHnjcW96an
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

function GetKDRatio(kills, deaths)
    if deaths == 0 then
        return string.format("%.2f", kills)
    else
        return string.format("%.2f", kills / deaths)
    end
end