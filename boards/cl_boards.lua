--[[
    CREATED BY:
    https://store.rxscripts.xyz/

    JOIN DISCORD FOR MORE SCRIPTS:
    https://discord.gg/DHnjcW96an
--]]

local isScoreboardOpen = false

local function hideBoard()
    SendNUIMessage({
        action = "hideBoard"
    })
    SetNuiFocus(false, false)
end

function InitializeScoreboard()
    CreateThread(function()
        while Client.GetInGame() do
            Wait(0)

            if IsControlPressed(0, Config.Keybinds.OpenScoreboardInGame) then
                if not isScoreboardOpen then
                    TriggerServerEvent("sv_boards:showBoard", Boards.Scoreboard, false)
                    isScoreboardOpen = true
                end
            else
                if isScoreboardOpen then
                    hideBoard()
                    isScoreboardOpen = false
                end
            end
        end
    end)
end

RegisterNetEvent("cl_boards:showBoard", function(players, type, playerStats, nuiFocus)
    if type == Boards.Scoreboard then
        SendNUIMessage({
            action = "showBoard",
            topPlayers = json.encode(players),
            board = type,
            personalStats = json.encode(playerStats),
            currentMap = GetCurrentMap().Label
        })
    elseif type == Boards.Leaderboard then
        SendNUIMessage({
            action = "showBoard",
            topPlayers = json.encode(players),
            board = type
        })

        CreateThread(function()
            while true do
                Wait(0)

                if IsControlPressed(0, 243) or IsControlPressed(0, 177) then
                    hideBoard()
                    break
                end
            end
        end)
    end

    if nuiFocus then
        SetNuiFocus(true, true)
    end
end)

RegisterNetEvent("cl_boards:hideBoard", function()
    hideBoard()
end)