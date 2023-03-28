--[[
BY Rejox#7975 © RX
--]]

GlobalState.ActiveMap = "Island"
GlobalState.PlayersInGame = 0
GlobalState.RoundTimeLeft = Config.Maps[GlobalState.ActiveMap].RoundTime

RegisterNetEvent("sv_game:joinGunGame", function ()
    local src = source

    GlobalState.PlayersInGame = GlobalState.PlayersInGame + 1

    TriggerClientEvent("cl_game:joinGunGame", src)
end)

RegisterNetEvent("sv_game:leaveGunGame", function ()
    local src = source

    GlobalState.PlayersInGame = GlobalState.PlayersInGame - 1

    TriggerClientEvent("cl_game:leaveGunGame", src)
end)