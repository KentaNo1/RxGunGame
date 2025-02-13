--[[
    CREATED BY:
    https://store.rxscripts.xyz/

    JOIN DIS FOR MORE SCRIPTS:
    https://discord.gg/DHnjcW96an
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

            local gameName = _L('game_name')
            local preparingGame = _L('preparing_game')

            if gameActive then
                local playersInGame = GetPlayersInGame()
                local roundTimeLeft = GetRoundTimeLeft()
                local currentMap = GetCurrentMap()
                local maximumPlayers = currentMap.MaximumPlayers
                local map = _L('map')
                local players = _L('players')
                local timeLeft = _L('time_left')
                Draw3DText(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z + textHeight,
                    gameName .. " \n ~r~" .. map .. ": ~HC_28~" .. currentMap.Label .. " \n ~r~" .. players .. ": ~HC_28~" .. playersInGame .. "/~HC_28~" .. maximumPlayers .. " \n ~r~" .. timeLeft .. ": ~HC_28~" .. SecondsToSecondsAndMinutes(roundTimeLeft)
                )
                if distance <= 1.7 then
                    if not Client.GetInGame() then
                        if playersInGame >= maximumPlayers then
                            ShowHelpNotification(_L('game_full'))
                        else
                            ShowHelpNotification(_L('press_to_join'))
                            if IsControlJustPressed(0, 38) then
                                TriggerServerEvent("sv_game:joinGunGame")
                            end
                        end
                    end
                end
            else
                Draw3DText(Config.JoinLobby.Coords.x, Config.JoinLobby.Coords.y, Config.JoinLobby.Coords.z + textHeight - 0.2, gameName .. " \n ~r~" .. preparingGame)
            end
        end
    end
end)
