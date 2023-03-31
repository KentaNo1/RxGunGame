--[[
BY Rejox#7975 © RX
--]]

local joinNPC = nil

CreateThread(function()
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

    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - vector3(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z))
        if distance <= 15.0 then
            local gameActive = GetIsGameActive()
            DrawMarker(1, Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z - 0.95, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 0.5, 255, 0, 0, 100, 0, 0, 0, 0)

            local textHeight = 0.5
            if Config.JoinLobby.NPC.Active then
                textHeight = 1.3
            end

            if gameActive then
                local playersInGame = GetPlayersInGame()
                local roundTimeLeft = GetRoundTimeLeft()
                local currentMap = GetCurrentMap()
                local maximumPlayers = currentMap.MaximumPlayers
                Draw3DText(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z + textHeight, 
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
                Draw3DText(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z + textHeight - 0.2, "GunGame \n ~r~Preparing Game..")
            end
        end
    end
end)
