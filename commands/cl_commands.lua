--[[
BY Rejox#7975 © RX
--]]

TriggerEvent('chat:addSuggestions', {
    { name = "/" .. Config.Commands.LeaveGame.Command, help = Config.Commands.LeaveGame.Label },
    { name = "/" .. Config.Commands.ShowLeaderboard.Command, help = Config.Commands.ShowLeaderboard.Label },
    { name = "/" .. Config.Commands.ResetLeaderboard.Command, help = Config.Commands.ResetLeaderboard.Label },
})

-- DEV COMMANDS -- 
RegisterCommand('tptogungame', function (source, args, raw)
    SetEntityCoords(PlayerPedId(), Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z)
end)