--[[
BY Rejox#7975 © RX
--]]

GlobalState['RX:GunGame:ActiveGame'] = false
GlobalState['RX:GunGame:CurrentMap'] = nil
GlobalState['RX:GunGame:PlayersInGame'] = 0
GlobalState['RX:GunGame:RoundTimeLeft'] = nil

local function finishGame()
    GlobalState['RX:GunGame:ActiveGame'] = false
    GlobalState['RX:GunGame:CurrentMap'] = nil
    GlobalState['RX:GunGame:PlayersInGame'] = nil
    GlobalState['RX:GunGame:RoundTimeLeft'] = nil
end

local function startGame(map)
    GlobalState['RX:GunGame:CurrentMap'] = map
    GlobalState['RX:GunGame:PlayersInGame'] = 0
    GlobalState['RX:GunGame:RoundTimeLeft'] = Config.Maps[map].RoundTime
    GlobalState['RX:GunGame:ActiveGame'] = true

    Citizen.CreateThread(function()
        while GlobalState['RX:GunGame:ActiveGame'] and GlobalState['RX:GunGame:RoundTimeLeft'] > 0 do
            Wait(1000)
            GlobalState['RX:GunGame:RoundTimeLeft'] = GlobalState['RX:GunGame:RoundTimeLeft'] - 1
        end

        finishGame()
    end)
end

RegisterNetEvent("sv_game:joinGunGame", function ()
    local src = source

    Player(src).state:set("RX:GunGame:inGame", true, true)
    GlobalState['RX:GunGame:PlayersInGame'] = GlobalState['RX:GunGame:PlayersInGame'] + 1

    TriggerClientEvent("cl_game:joinGunGame", src)
end)

RegisterNetEvent("sv_game:leaveGunGame", function ()
    local src = source

    Player(src).state:set("RX:GunGame:inGame", false, true)
    GlobalState['RX:GunGame:PlayersInGame'] = GlobalState['RX:GunGame:PlayersInGame'] - 1

    TriggerClientEvent("cl_game:leaveGunGame", src)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if not GlobalState['RX:GunGame:ActiveGame'] then
            startGame("Island")
        end 
    end
end)