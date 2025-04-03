fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'
author 'VORP'
description 'A Metabolism Script With HUD For VORP Core Framework'
repository 'https://github.com/VORPCORE/vorp_metabolism-lua'

shared_scripts {
  'config.lua',
  'languages/translation.lua'
}

client_script 'client/*.lua'

server_script 'server/*.lua'

files {
  'ui/hud.html',
  'ui/css/style.css',
  'ui/js/circle-progress.js',
  'ui/js/circle-progress.min.js',
  'ui/img/*.png'
}

ui_page 'ui/hud.html'

version '1.2'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_metabolism-lua'
