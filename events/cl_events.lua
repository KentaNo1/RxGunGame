--[[
BY Rejox#7975 © RX
--]]

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    if Client.GetInGame() then
        TriggerServerEvent("sv_game:leaveGunGame")
    end
end)