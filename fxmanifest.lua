fx_version 'cerulean'

game 'gta5'

lua54 'yes'

author 'RanuK12'

description 'FiveM Cooking Resource'

version '1.0.1'

client_scripts {
    'client/main.lua',
    'client/visuals.lua'
}

server_scripts {
    'server/main.lua',
    'server/webhook.lua',
    'server/anticheat.lua'
}

shared_scripts {
    'config.lua',
    'shared/main.lua'
}

files {
    'locales/en.json',
    'locales/es.json'
}
dependencies {
    ".esx",
    ".qb-core"
}
