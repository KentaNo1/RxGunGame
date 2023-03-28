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
