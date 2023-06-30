fx_version "cerulean"

description "housing resource"
author "qw-scripts"
version '1.0.0'
repository 'https://github.com/qw-scripts/qw_housing'

lua54 'yes'

games {
  "gta5",
  "rdr3"
}

ui_page 'web/build/index.html'

client_script "client/**/*"
server_scripts {'@oxmysql/lib/MySQL.lua', "server/**/*"}
shared_scripts {'@ox_lib/init.lua', 'config.lua'}

files {
	'web/build/index.html',
	'web/build/**/*',
  'props.json'
}