--[[
BY Rejox#7975 © RX
--]]

if Config.JoinLobby.Blip.Active then
    local lobbyBlip = AddBlipForCoord(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z)
    SetBlipSprite(lobbyBlip, Config.JoinLobby.Blip.Sprite)
    SetBlipDisplay(lobbyBlip, 4)
    SetBlipScale(lobbyBlip, Config.JoinLobby.Blip.Scale)
    SetBlipColour(lobbyBlip, Config.JoinLobby.Blip.Color)
    SetBlipAsShortRange(lobbyBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.JoinLobby.Blip.Label)
    EndTextCommandSetBlipName(lobbyBlip)
end

CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - vector3(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z))
        if distance <= 15.0 then
            local gameActive = GetIsGameActive()
            DrawMarker(1, Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z - 0.95, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 0.5, 255, 0, 0, 100, 0, 0, 0, 0)

            if gameActive then
                local playersInGame = GetPlayersInGame()
                local roundTimeLeft = GetRoundTimeLeft()
                local currentMap = GetCurrentMap()
                local maximumPlayers = currentMap.MaximumPlayers
    
                Draw3DText(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z + 0.5, 
                    "GunGame \n ~r~Map: ~HC_28~" .. currentMap.Label .. " \n ~r~Players: ~HC_28~" .. playersInGame .. "/~HC_28~" .. maximumPlayers .. " \n ~r~Time left: ~HC_28~" .. SecondsToSecondsAndMinutes(roundTimeLeft)
                )
                if distance <= 1.7 then
                    if not Client.GetInGame() then
                        if playersInGame >= maximumPlayers then
                            ShowHelpNotification("GunGame is full")
                        else
                            ShowHelpNotification("Press ~INPUT_CONTEXT~ to join the GunGame lobby")
                            if IsControlJustPressed(0, 38) then
                                TriggerServerEvent("sv_game:joinGunGame")
                            end
                        end 
                    end
                end
            else
                Draw3DText(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z + 0.5, "GunGame \n ~r~Preparing Game..")
            end
        end
    end
end)
