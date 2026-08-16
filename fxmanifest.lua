[fx_version]
version '1.0.3-1'
author 'Emilio Ranucoli'
description 'FiveM Cooking System for ESX/QB-Core'

[dependencies]
qb-core.lua
esx
ox_lib (>= 3.0.0)

[client]
files {
    client/*.lua,
    client/*.yml,
    client/*.sc
}

[server]
files {
    server/*.lua,
    data/*.lua
}

[packages]
mx-legacy = "*"
qb-core = "*"
esx = "*"
osval = "*"

[info]
website "https://ranuk.dev"
license "proprietary"

[scripts]
client = 'client/main.lua',
server = 'server/main.lua'