--[[
BY Rejox#7975 © RX
--]]

GlobalState[States.Global.GameActive] = false
GlobalState[States.Global.CurrentMap] = nil
GlobalState[States.Global.PlayersInGame] = 0
GlobalState[States.Global.RoundTimeLeft] = nil

GunGame = {}
GunGame.Players = {}

local function finishGame()
    GlobalState[States.Global.GameActive] = false
    GlobalState[States.Global.CurrentMap] = nil
    GlobalState[States.Global.PlayersInGame] = 0
    GlobalState[States.Global.RoundTimeLeft] = nil
end

local function startGame(map)
    GlobalState[States.Global.CurrentMap] = map
    GlobalState[States.Global.PlayersInGame] = 0
    GlobalState[States.Global.RoundTimeLeft] = Config.Maps[map].RoundTime
    GlobalState[States.Global.GameActive] = true

    Citizen.CreateThread(function()
        while GlobalState[States.Global.GameActive] and GlobalState[States.Global.RoundTimeLeft] > 0 do
            Wait(1000)
            GlobalState[States.Global.RoundTimeLeft] = GlobalState[States.Global.RoundTimeLeft] - 1
        end

        finishGame()
    end)
end

RegisterNetEvent("sv_game:joinGunGame", function ()
    local src = source

    TriggerClientEvent("cl_game:joinGunGame", src)
    Wait(300)

    SetPlayerRoutingBucket(src, Config.GunGameRoutingBucket)

    Player(src).state:set(States.Player.InGame, true, true)
    GlobalState[States.Global.PlayersInGame] = GlobalState[States.Global.PlayersInGame] + 1
end)

RegisterNetEvent("sv_game:leaveGunGame", function ()
    local src = source

    TriggerClientEvent("cl_game:leaveGunGame", src)
    Wait(300)

    SetPlayerRoutingBucket(src, Config.DefaultRoutingBucket)

    Player(src).state:set(States.Player.InGame, false, true)
    GlobalState[States.Global.PlayersInGame] = GlobalState[States.Global.PlayersInGame] - 1
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if not GlobalState[States.Global.GameActive] then
            startGame("Island")
        end 
    end
end)