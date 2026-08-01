fx_version 'cerulean'
lua54 'yes'

game 'gta5'

author 'Emilio Ranucoli'
description 'FiveM resource for cooking system supporting ESX and QB-Core'
version '1.0.0'

shared_scripts {
    'config.lua',
    'locales/en.json',
    'locales/es.json',
    'shared/main.lua',
}

client_scripts {
    'client/main.lua',
    'client/visuals.lua',
}

server_scripts {
    'server/main.lua',
    'server/anticheat.lua',
    'server/webhook.lua',
}