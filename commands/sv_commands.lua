--[[
    CREATED BY:
    https://store.rxscripts.xyz/

    JOIN DIS FOR MORE SCRIPTS:
    https://discord.gg/DHnjcW96an
--]]

RegisterCommand(Config.Commands.ResetLeaderboard.Command, function(source, args, rawCommand)
    local src = source

    if src == 0 then
        MySQL.Async.execute("DELETE FROM gungame_stats", {}, function()
        end)
    else
        if IsPlayerAceAllowed(src, 'gungame.admin') then
            MySQL.Async.execute("DELETE FROM gungame_stats", {}, function()
                Server.Notify(src, _L('leaderboard_reset'))
            end)
        else
            Server.Notify(src, _L('no_permission'))
        end
    end
end, false)

RegisterCommand(Config.Commands.LeaveGame.Command, function(source, args, rawCommand)
    local src = source

    if Server.GetInGame(src) then
       LeaveGunGame(src)
    else
        Server.Notify(src, _L('not_ingame'))
    end
end, false)

RegisterCommand(Config.Commands.ShowLeaderboard.Command, function(source, args, rawCommand)
    local src = source

    ShowLeaderBoard(src)
end, false)