--[[
    CREATED BY:
    https://store.rxscripts.xyz/

    JOIN DISCORD FOR MORE SCRIPTS:
    https://discord.gg/DHnjcW96an
--]]

fx_version 'cerulean'
games { 'gta5' }

author 'rxscripts'
name 'RxGunGame'
repository 'RxGunGame'
description 'RX | FFA GunGame'
version '1.0.1'

shared_script {
    '@ox_lib/init.lua',
    'config.lua',
    'utils/sh_utils.lua',
    'init.lua',
    'locales/*.lua',
}

client_scripts {
    'utils/cl_utils.lua',
    'boards/cl_boards.lua',
    'zones/cl_zones.lua',
    'game/cl_game.lua',
    'lobby/cl_lobby.lua',
    'commands/cl_commands.lua',
    'events/cl_events.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'utils/sv_utils.lua',
    'configurable/sv_functions.lua',
    'boards/sv_boards.lua',
    'game/sv_game.lua',
    'commands/sv_commands.lua',
    'events/sv_events.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
}

lua54 'yes'