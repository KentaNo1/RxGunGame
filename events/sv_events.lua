--[[
BY Rejox#7975 © RX
--]]

local licensesLeftInGame = {}

AddEventHandler('playerDropped', function()
    local src = source

    if Server.GetInGame(src) then
        if GunGame.Players[src] then
            GunGame.Players[src] = nil
        end

        Server.UpdatePlayersInGame(-1)
        Database.UpdatePlayerStats(src)
        licensesLeftInGame[#licensesLeftInGame+1] = GetLicense(src)
    end
end)

-- AddEventHandler('playerSpawned', function()
--     local src = source

--     local license = GetLicense(src)

--     for k, v in pairs(licensesLeftInGame) do
--         if v == license then
--             TriggerServerEvent("sv_game:joinGunGame")
--             table.remove(licensesLeftInGame, k)
--             return
--         end
--     end
-- end)