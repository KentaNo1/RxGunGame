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

    return kills / deaths
end