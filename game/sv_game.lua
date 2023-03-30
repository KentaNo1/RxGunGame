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

    CreateThread(function()
        while GetIsGameActive() and GetRoundTimeLeft() > 0 do
            Wait(1000)
            GlobalState[States.Global.RoundTimeLeft] = GlobalState[States.Global.RoundTimeLeft] - 1
        end

        finishGame()
    end)
end

RegisterNetEvent("sv_game:joinGunGame", function ()
    local src = source
    
    Server.SetCurrentLevel(src, 1)

    TriggerClientEvent("cl_game:joinGunGame", src)
    Wait(300)

    SetPlayerRoutingBucket(src, Config.GunGameRoutingBucket)

    Server.SetInGame(src, true)
    Server.UpdatePlayersInGame(1)
end)

RegisterNetEvent("sv_game:leaveGunGame", function ()
    local src = source

    TriggerClientEvent("cl_game:leaveGunGame", src)
    Wait(300)

    SetPlayerRoutingBucket(src, Config.DefaultRoutingBucket)

    Server.SetInGame(src, false)
    Server.UpdatePlayersInGame(-1)
end)

RegisterNetEvent("sv_game:onDeath", function(victimId, killerId)
    local currentKillerLevel = Server.GetCurrentLevel(killerId)

    if currentKillerLevel < #Config.Levels then
        Server.SetCurrentLevel(killerId, currentKillerLevel + 1)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source

    if Player(src).state[States.Player.InGame] then
        Server.UpdatePlayersInGame(-1)
    end
end)

CreateThread(function()
    while true do
        Wait(1000)

        if not GetIsGameActive() then
            startGame("Island")
        end 
    end
end)