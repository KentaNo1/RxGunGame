--[[
BY Rejox#7975 © RX
--]]

-- [[ DON'T TOUCH THIS UNLESS YOU KNOW WHAT YOU'RE DOING ]] --
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