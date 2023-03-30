--[[
BY Rejox#7975 © RX
--]]

TriggerEvent('chat:addSuggestions', {
    { name = "/" .. Config.LeaveCommand, help = "Leave GunGame" },
    { name = "/" .. Config.ResetLeaderboardCommand, help = "Reset GunGame Leaderboard (Admin)" },
    { name = "/" .. Config.LeaderboardCommand, help = "Show GunGame Leaderboard" },
})

-- DEV COMMANDS -- 
RegisterCommand('tptogungame', function (source, args, raw)
    SetEntityCoords(PlayerPedId(), Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z)
end)