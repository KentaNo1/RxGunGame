--[[
    CREATED BY:
    https://store.rxscripts.xyz/

    JOIN DIS FOR MORE SCRIPTS:
    https://discord.gg/DHnjcW96an
--]]

function HideBoard(src)
    TriggerClientEvent("cl_boards:hideBoard", src)
end

function ShowScoreboard(src, nuiFocus)
    local top20PlayerStats = Server.GetCurrentTop20PlayerStats()
    TriggerClientEvent("cl_boards:showBoard", src, top20PlayerStats, Boards.Scoreboard, Server.GetStats(src), nuiFocus)
end

function ShowLeaderBoard(src)
    local top20PlayerStats = Database.GetTop20PlayerStats()
    TriggerClientEvent("cl_boards:showBoard", src, top20PlayerStats, Boards.Leaderboard, nil, false)
end

RegisterNetEvent("sv_boards:showBoard", function(type, nuiFocus)
    local src = source

    if type == Boards.Scoreboard then
        ShowScoreboard(src, nuiFocus)
    elseif type == Boards.Leaderboard then
        ShowLeaderBoard(src)
    end
end)