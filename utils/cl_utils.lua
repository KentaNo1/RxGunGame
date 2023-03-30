--[[
BY Rejox#7975 © RX
--]]

Client = {}

function DrawScreenText(text, x, y, scale, font, center, outline, rectangle)
    if center then SetTextCentre(true) end
    if font then SetTextFont(font) else SetTextFont(4) end
    SetTextScale(scale, scale)
    if outline then SetTextOutline() end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
    if rectangle then
        print(json.encode(rectangle))
        DrawRect(rectangle.x, rectangle.y, rectangle.w, rectangle.h, 0, 0, 0, 100)
    end
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(pX, pY, pZ, x, y, z, 1)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(7)
        SetTextColour(255, 0, 0, 200)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function ShowHelpNotification(msg)
    AddTextEntry('helpNotification', msg)

    BeginTextCommandDisplayHelp('helpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function SecondsToSecondsAndMinutes(seconds)
    local minutes = math.floor(seconds / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

function RequestWeapon(weapon)
    local weaponHash = GetHashKey(weapon)
    
    if not IsWeaponValid(weaponHash) then
        return
    end

    if not HasWeaponAssetLoaded(weaponHash) then
        RequestWeaponAsset(weaponHash, 31, 0)
        while not HasWeaponAssetLoaded(weaponHash) do
            Wait(1)
        end
    end

    return weapon
end

function Client.GetInGame()
    return LocalPlayer.state[States.Player.InGame]
end

function Client.GetCurrentLevelWeapon()
    local currentLevel = LocalPlayer.state[States.Player.CurrentLevel]
    local weapon = RequestWeapon(Config.Levels[currentLevel].Weapon)

    return weapon
end

function Client.GetOutsideZone()
    return LocalPlayer.state[States.Player.OutsideZone]
end

function Client.SetOutsideZone(outside)
    LocalPlayer.state:set(States.Player.OutsideZone, outside, true)
end

function Client.GetKills()
    return LocalPlayer.state[States.Player.Kills]
end

function Client.GetDeaths()
    return LocalPlayer.state[States.Player.Deaths]
end

function Client.GetKDRatio()
    local kills = Client.GetKills()
    local deaths = Client.GetDeaths()

    if deaths == 0 then
        return kills
    end

    return math.floor(kills / deaths * 100) / 100
end

function Client.GetCurrentLevel()
    return LocalPlayer.state[States.Player.CurrentLevel]
end



