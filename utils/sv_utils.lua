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
    return Player(src).state[States.Player.CurrentLevel] ~= nil and Player(src).state[States.Player.CurrentLevel] or 1
end

function Server.UpdatePlayersInGame(count)
    if GlobalState[States.Global.PlayersInGame] == 0 and count < 0 then
        return
    end
    GlobalState[States.Global.PlayersInGame] = GlobalState[States.Global.PlayersInGame] + count
end

function Server.SetCurrentLevel(src, level)
    Player(src).state:set(States.Player.CurrentLevel, level, true)
end

function Server.SetInGame(src, inGame)
    Player(src).state:set(States.Player.InGame, inGame, true)
end

function Server.GetKills(src)
    return Player(src).state[States.Player.Kills] ~= nil and Player(src).state[States.Player.Kills] or 0
end

function Server.SetKills(src, kills)
    Player(src).state:set(States.Player.Kills, kills, true)
end

function Server.GetDeaths(src)
    return Player(src).state[States.Player.Deaths] ~= nil and Player(src).state[States.Player.Deaths] or 0
end

function Server.SetDeaths(src, deaths)
    Player(src).state:set(States.Player.Deaths, deaths, true)
end

function Server.GetInGame(src)
    return Player(src).state[States.Player.InGame]
end

function Server.GetStats(src)
    local kills = Server.GetKills(src)
    local deaths = Server.GetDeaths(src)
    local kd = GetKDRatio(kills, deaths)

    return {
        kills = kills,
        deaths = deaths,
        kd = kd,
    }
end

function Server.ResetPlayerStates(src)
    Server.SetCurrentLevel(src, 1)
    Server.SetKills(src, 0)
    Server.SetDeaths(src, 0)
end

function Server.GetCurrentTop20PlayerStats()
    local top20PlayerStats = {}
    
    for k, v in pairs(GunGame.Players) do
        local stats = Server.GetStats(k)

        top20PlayerStats[#top20PlayerStats+1] = {
            name = GetPlayerName(k),
            kills = stats.kills,
            deaths = stats.deaths,
            kd = stats.kd,
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
    local playerName = GetPlayerName(src)
    local stats = Server.GetStats(src)

    MySQL.Async.execute('INSERT INTO `gungame_stats` (`identifier`, `playername`, `kills`, `deaths`) VALUES (@identifier, @playername, @kills, @deaths) ON DUPLICATE KEY UPDATE `playername` = @playername, `kills` = `kills` + @kills, `deaths` = `deaths` + @deaths', {
        ['@identifier'] = license,
        ['@playername'] = playerName,
        ['@kills'] = stats.kills,
        ['@deaths'] = stats.deaths
    })
end

function Database.GetTop20PlayerStats()
    local top20PlayerStats = {}

    local result = MySQL.query.await('SELECT * FROM `gungame_stats` ORDER BY `kills` DESC LIMIT 20')
    if result then
        for k, v in pairs(result) do
            top20PlayerStats[#top20PlayerStats+1] = {
                name = v.playername,
                kills = v.kills,
                deaths = v.deaths,
                kd = GetKDRatio(v.kills, v.deaths),
            }
        end
    end
    
    return top20PlayerStats
end