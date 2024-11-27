fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version "1.2.0"

ox_lib "locale"

author "PEEVEE"
description "discord.gg/jRgkb5sM3w"

client_scripts {
    "@ox_lib/init.lua",
    "client/client.lua",
}

ui_page "web/build/index.html"

files {
    "web/build/index.html",
    "web/build/**/*",
    'locales/*.json',
    "shared/*.lua",
}
