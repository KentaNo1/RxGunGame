--[[
BY Rejox#7975 © RX
--]]

fx_version 'cerulean'
games { 'gta5' }

author 'Rejox'
description 'FFA GunGame'
version '1.0.0'

shared_script {
    'config.lua',
    'utils/sh_utils.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    'utils/cl_utils.lua',
    'game/cl_game.lua',
    'lobby/cl_lobby.lua',
    'zones/cl_zones.lua',
    'events/cl_events.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'utils/sv_utils.lua',
    'game/sv_game.lua',
    'events/sv_events.lua',
}

dependencies {
    'oxmysql',
    'PolyZone'
}

lua54 'yes'
