--[[
BY Rejox#7975 © RX
--]]

Config = {}

Config.Keybinds = {
    OpenScoreboardInGame = 48, -- Z by default
}

Config.Commands = {
    ShowLeaderboard = {
        Label = "Show GunGame Leaderboard",
        Command = "gungame:leaderboard",
    },
    LeaveGame = {
        Label = "Leave GunGame",
        Command = "gungame:leave",
    },
    ResetLeaderboard = {
        Label = "Reset GunGame Leaderboard (Admins Only)",
        Command = "gungame:resetleaderboard",
    },
}

Config.JoinLobby = {
    Blip = {
        Active = true,
        Label = "GunGame Lobby",
        Sprite = 110,
        Color = 1,
        Scale = 0.8,
    },
    NPC = {
        Active = true,
        Model = "g_m_y_mexgoon_03",
        Coords = vector4(5086.3765, -5177.2197, 2.0638, 88.4565)
    },
    Coords = vector4(5086.4097, -5177.2280, 2.0630, 173.7285)
}

Config.Levels = {
    [1] = {
        Label = "One",
        Weapon = "WEAPON_PISTOL",
        WeaponLabel = "Pistol",
    },
    [2] = {
        Label = "Two",
        Weapon = "WEAPON_HEAVYPISTOL",
        WeaponLabel = "Heavy Pistol",
    },
    [3] = {
        Label = "Final",
        Weapon = "WEAPON_KNIFE",
        WeaponLabel = "Knife",
    }
}
    
Config.Maps = {
    ["Island"] = {
        Label = "Cayo Perico",
        RespawnTime = 3, -- In Seconds
        RoundTime = 720, -- In Seconds
        InvincibleOnSpawnTime = 3, -- In Seconds
        MaximumOutOfZoneTime = 5, -- In Seconds
        MaximumPlayers = 16,
        SpawnPoints = {
            vector4(5121.3940, -5083.2788, 2.3973, 162.5292),
            vector4(5109.5957, -5165.5435, 2.1872, 335.3054),
            vector4(5115.4712, -5204.9810, 2.4243, 337.9229),
            vector4(5165.0151, -5198.4321, 3.8627, 35.9599),
            vector4(5155.9648, -5134.2744, 2.3072, 181.1134),
            vector4(5183.5293, -5131.9673, 3.3319, 102.1844),
            vector4(5203.2148, -5119.3423, 6.1443, 244.2429),
        },
        Zone = {
            vector2(5115.9438476562, -5073.5717773438),
            vector2(5108.1323242188, -5123.3901367188),
            vector2(5107.052734375, -5194.888671875),
            vector2(5108.8174, -5251.2764),
            vector2(5135.9262695312, -5293.611328125),
            vector2(5176.1103515625, -5292.875),
            vector2(5227.7583007812, -5261.6484375),
            vector2(5226.427734375, -5105.4755859375),
            vector2(5167.0122070312, -5074.8315429688)
        }
    }
}

-- [[ DON'T TOUCH THIS UNLESS YOU KNOW WHAT YOU'RE DOING ]] --
-- Routing Buckets
Config.DefaultRoutingBucket = 0
Config.GunGameRoutingBucket = 29

-- States
States = {}

-- GlobalStates
States.Global = {
    GameActive = 'RX:GunGame:ActiveGame',
    CurrentMap = 'RX:GunGame:CurrentMap',
    PlayersInGame = 'RX:GunGame:PlayersInGame',
    RoundTimeLeft = 'RX:GunGame:RoundTimeLeft',
}

-- PlayerStates
States.Player = {
    InGame = 'RX:GunGame:InGame',
    CurrentLevel = 'RX:GunGame:CurrentLevel',
    OutsideZone = 'RX:GunGame:OutsideZone',
    Kills = 'RX:GunGame:Kills',
    Deaths = 'RX:GunGame:Deaths',
}


