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
}

client_scripts {
    '@PolyZone/client.lua',
    'lobby/cl_lobby.lua',
    'zones/cl_zones.lua',
}
server_scripts {
    'server.lua',
}

dependencies {
    'PolyZone'
}

lua54 'yes'
