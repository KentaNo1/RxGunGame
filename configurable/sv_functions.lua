--[[
    CREATED BY:
    https://store.rxscripts.xyz/

    JOIN DIS FOR MORE SCRIPTS:
    https://discord.gg/DHnjcW96an
--]]

function Server.Notify(src, message)
    if src == -1 then
        for playerId, _ in pairs(GunGame.Players) do
            FM.utils.notify(playerId, message)
        end
    else
        FM.utils.notify(src, message)
    end
end

function Server.GivePrizeWinner(src)
    local prize = GetCurrentMap().Prize
    Server.Notify(src, _L('won_prize', prize))
end