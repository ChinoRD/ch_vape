local QBCore = exports['qb-core']:GetCoreObject()

-- inicio de eventos

RegisterNetEvent("chino_vape:Fail")
RegisterServerEvent("chino_vape:Smoke")

QBCore.Functions.CreateCallback('chino_vape:CheckVaper', function(source, cb)
    local xPlayer    = QBCore.Functions.GetPlayer(source)
	local result     = 0
	
	local vaper      = xPlayer.Functions.GetItemByName('vaper')
	local vaperb     = xPlayer.Functions.GetItemByName('vaper_blue')
	local vaperg     = xPlayer.Functions.GetItemByName('vaper_green')

	if (vaper.count > 0) or (vaperb.count > 0) or (vaperg.count > 0) then
		result = 1
		cb(result)	
	else
		result = 2
		cb(result)
	end

	print(xPlayer.Functions.GetItemByName('vaper').count)
end)

AddEventHandler("chino_vape:Fail", function()
	TriggerClientEvent('dopeNotify2', source, "ERROR", "<span style='color:#c7c7c7'>Te exploto un <span style='color:#ff0000'>VAPE</span> un vape en la cara!", 5000, 'error')
end)

AddEventHandler("chino_vape:Smoke", function(entity)
	TriggerClientEvent("chino_vape:Smoke", -1, entity)
end)

-- fin de eventos

-- Inicio de los items

QBCore.Functions.CreateUseableItem("vaper_blue", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerEvent("chino_vape:OpenMenu")
end)

QBCore.Functions.CreateUseableItem("vaper_green", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerEvent("chino_vape:OpenMenu")
end)

QBCore.Functions.CreateUseableItem("vaper", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerEvent("chino_vape:OpenMenu")
end)

-- fin de los items