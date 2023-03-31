--[[
BY Rejox#7975 © RX
--]]

RegisterCommand(Config.Commands.ResetLeaderboard.Command, function(source, args, rawCommand)
    local src = source

    if src == 0 then
        MySQL.Async.execute("DELETE FROM gungame_stats", {}, function()
        end)
    else
        if IsPlayerAceAllowed(src, 'gungame.admin') then
            MySQL.Async.execute("DELETE FROM gungame_stats", {}, function()
                TriggerClientEvent('chat:addMessage', src, {
                    args = {"^1GunGame: ^0Leaderboard has been reset!"}
                })
            end)
        else
            TriggerClientEvent('chat:addMessage', src, {
                args = {"^1GunGame: ^0You don't have permissions to use this command!"}
            })
        end
    end
end, false)

RegisterCommand(Config.Commands.LeaveGame.Command, function(source, args, rawCommand)
    local src = source

    if Server.GetInGame(src) then
       LeaveGunGame(src) 
    else
        Server.Notify(src, "You are not in a Gun Game!")
    end
end, false)

RegisterCommand(Config.Commands.ShowLeaderboard.Command, function(source, args, rawCommand)
    local src = source

    ShowLeaderBoard(src)
end, false)