--[[
BY Rejox#7975 © RX
--]]

Server = {}

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