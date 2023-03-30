--[[
BY Rejox#7975 © RX
--]]

RegisterCommand(Config.LeaveCommand, function (source, args, raw)
    TriggerServerEvent("sv_game:leaveGunGame")
end)

-- DEV COMMANDS -- 
RegisterCommand('tptogungame', function (source, args, raw)
    SetEntityCoords(PlayerPedId(), Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z)
end)