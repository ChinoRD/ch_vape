--- NO VENDER PORFAVOR -- 
fx_version 'cerulean'
game 'gta5'

version '1.0.0'

description 'https://github.com/ChinoRD/ch_vape'


client_scripts{
	'config/*.lua',
	'client/*.lua'
}

server_scripts{
	'config/*.lua',
	'server/*.lua',
}

dependencies {
	'qb-core',
	-- Si quieres cambiar el scripts de framework elemina esta linea de codigo (DESDE LA 20)
	-- https://github.com/qbcore-framework
}
