--[[
BY Rejox#7975 © RX
--]]

RegisterCommand(Config.ResetLeaderboardCommand, function(source, args, rawCommand)
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