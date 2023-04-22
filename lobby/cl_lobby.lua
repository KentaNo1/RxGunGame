--[[
BY Rejox#7975 © RX
--]]

local joinNPC = nil

CreateThread(function()
    if not Config.RxGamesBridge then
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
    
        if Config.JoinLobby.NPC.Active then
            if not joinNPC or not DoesEntityExist(joinNPC) then
                local joinNPC = Config.JoinLobby.NPC
                RequestModel(joinNPC.Model)
                while not HasModelLoaded(joinNPC.Model) do
                    Wait(0)
                end
        
                joinNPC = CreatePed(4, joinNPC.Model, vector4(joinNPC.Coords.x, joinNPC.Coords.y, joinNPC.Coords.z - 1.0, joinNPC.Coords.w), false, false)
                SetEntityInvincible(joinNPC, true)
                SetEntityCanBeDamaged(joinNPC, false)
                SetBlockingOfNonTemporaryEvents(joinNPC, true)
                SetEntityAsMissionEntity(joinNPC, true, true)
                FreezeEntityPosition(joinNPC, true)
                PlaceObjectOnGroundProperly(joinNPC)
                SetPedCanBeTargetted(joinNPC, false)
                GiveWeaponToPed(joinNPC, RequestWeapon("WEAPON_ASSAULTRIFLE"), 999, false, false)
                SetCurrentPedWeapon(joinNPC, "WEAPON_ASSAULTRIFLE", true)
                SetPedDropsWeaponsWhenDead(joinNPC, false)
            end
        end 
    end

    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - vector3(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z))
        if distance <= 15.0 then
            local gameActive = GetIsGameActive()
            if not Config.RxGamesBridge then
                DrawMarker(1, Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z - 0.95, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 0.5, 255, 0, 0, 100, 0, 0, 0, 0)
            end

            local textHeight = 0.5
            if Config.JoinLobby.NPC.Active then
                textHeight = 1.3
            end

            local gameName = Locales[Config.Locale].game_name
            local preparingGame = Locales[Config.Locale].preparing_game

            if gameActive then
                local playersInGame = GetPlayersInGame()
                local roundTimeLeft = GetRoundTimeLeft()
                local currentMap = GetCurrentMap()
                local maximumPlayers = currentMap.MaximumPlayers
                local map = Locales[Config.Locale].map
                local players = Locales[Config.Locale].players
                local timeLeft = Locales[Config.Locale].time_left
                Draw3DText(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z + textHeight, 
                    gameName .. " \n ~r~" .. map .. ": ~HC_28~" .. currentMap.Label .. " \n ~r~" .. players .. ": ~HC_28~" .. playersInGame .. "/~HC_28~" .. maximumPlayers .. " \n ~r~" .. timeLeft .. ": ~HC_28~" .. SecondsToSecondsAndMinutes(roundTimeLeft)
                )
                if distance <= 1.7 then
                    if not Client.GetInGame() then
                        if playersInGame >= maximumPlayers then
                            ShowHelpNotification(Locales[Config.Locale].game_full)
                        else
                            ShowHelpNotification(Locales[Config.Locale].press_to_join)
                            if IsControlJustPressed(0, 38) then
                                TriggerServerEvent("sv_game:joinGunGame")
                            end
                        end 
                    end
                end
            else
                if not Config.RxGamesBridge then
                    Draw3DText(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z + textHeight - 0.2, gameName .. " \n ~r~" .. preparingGame)
                end
            end
        end
    end
end)
