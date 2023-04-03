--[[
BY Rejox#7975 © RX
--]]

-- [[ DON'T TOUCH THIS UNLESS YOU KNOW WHAT YOU'RE DOING ]] --
function Server.Notify(src, message)
    TriggerClientEvent("chat:addMessage", src, { args = { "^1GunGame", message } })
end

function Server.GivePrizeWinner(src)
    local prize = GetCurrentMap().Prize
    Server.Notify(src, string.format(Locales[Config.Locale].won_prize, prize))
end