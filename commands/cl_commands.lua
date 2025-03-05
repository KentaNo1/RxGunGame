--[[
    CREATED BY:
    https://store.rxscripts.xyz/

    JOIN DISCORD FOR MORE SCRIPTS:
    https://discord.gg/DHnjcW96an
--]]

TriggerEvent('chat:addSuggestions', {
    { name = "/" .. Config.Commands.LeaveGame.Command, help = Config.Commands.LeaveGame.Label },
    { name = "/" .. Config.Commands.ShowLeaderboard.Command, help = Config.Commands.ShowLeaderboard.Label },
    { name = "/" .. Config.Commands.ResetLeaderboard.Command, help = Config.Commands.ResetLeaderboard.Label },
})