--[[
BY Rejox#7975 © RX
--]]

Server = {}

function GetLicense(src)
    local identifiers = GetPlayerIdentifiers(src)

    for k, v in pairs(identifiers) do
        if string.match(v, 'license') then
            return v
        end
    end
end

function Server.GetCurrentLevel(src)
    return Player(src).state[States.Player.CurrentLevel]
end

function Server.UpdatePlayersInGame(count)
    GlobalState[States.Global.PlayersInGame] = GlobalState[States.Global.PlayersInGame] + count
end

function Server.SetCurrentLevel(src, level)
    Player(src).state:set(States.Player.CurrentLevel, level, true)
end

function Server.SetInGame(src, inGame)
    Player(src).state:set(States.Player.InGame, inGame, true)
end

function Server.GetKills(src)
    return Player(src).state[States.Player.Kills]
end

function Server.SetKills(src, kills)
    Player(src).state:set(States.Player.Kills, kills, true)
end

function Server.GetDeaths(src)
    return Player(src).state[States.Player.Deaths]
end

function Server.SetDeaths(src, deaths)
    Player(src).state:set(States.Player.Deaths, deaths, true)
end

function Server.GetKDRatio(src)
    local kills = Server.GetKills(src)
    local deaths = Server.GetDeaths(src)

    if deaths == 0 then
        return kills
    end

    return math.floor(kills / deaths * 100) / 100
end

function Server.ResetPlayerStates(src)
    Server.SetCurrentLevel(src, 1)
    Server.SetKills(src, 0)
    Server.SetDeaths(src, 0)
end

function Server.GetCurrentTop20PlayerStats()
    local top20PlayerStats = {}
    
    for k, v in pairs(GunGame.Players) do
        top20PlayerStats[#top20PlayerStats+1] = {
            name = GetPlayerName(k),
            kills = Server.GetKills(k),
            deaths = Server.GetDeaths(k),
            kd = Server.GetKDRatio(k),
        }
    end

    table.sort(top20PlayerStats, function(a, b)
        return a.kills > b.kills
    end)

    for i = 21, #top20PlayerStats do
        top20PlayerStats[i] = nil
    end

    return top20PlayerStats
end

Database = {}

function Database.UpdatePlayerStats(src)
    local license = GetLicense(src)
    local kills = Server.GetKills(src) ~= nil and Server.GetKills(src) or 0
    local deaths = Server.GetDeaths(src) ~= nil and Server.GetDeaths(src) or 0

    MySQL.Async.execute('INSERT INTO `gungame_stats` (`identifier`, `kills`, `deaths`) VALUES (@identifier, @kills, @deaths) ON DUPLICATE KEY UPDATE `kills` = `kills` + @kills, `deaths` = `deaths` + @deaths', {
        ['@identifier'] = license,
        ['@kills'] = kills,
        ['@deaths'] = deaths
    })
end