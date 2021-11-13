local QBCore = exports['qb-core']:GetCoreObject()

local IsPlayerAbleToVape        = false
local FadeIn                    = false
local FadeOut                   = false

RegisterNetEvent("chino_vape:StartVaping")
RegisterNetEvent("chino_vape:VapeAnimFix")
RegisterNetEvent("chino_vape:StopVaping")
RegisterNetEvent("chino_vape:Drag")
RegisterNetEvent("chino_vape:Smoke")

AddEventHandler("chino_vape:StartVaping", function()

	local ped = GetPlayerPed(-1)

	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		
		if IsPedOnFoot(ped) then
			
			if IsPlayerAbleToVape == false then
			
				PlayerIsAbleToVape()
				TriggerEvent("chino_vape:HelpFadeIn", 0)
				exports['dopeNotify2']:Alert("ESTADO", "<span style='color:#c7c7c7'>Has comenzado a usar tu <span style='color:#069a19'><b>VAPE</b></span>, eso puede relajarte!", 5000, 'success')
				Wait(Config['HelpTextLength'])
				TriggerEvent("chino_vape:HelpFadeOut", 0)
			
			else
			
				exports['dopeNotify2']:Alert("ERROR", "<span style='color:#c7c7c7'>Ya estas usando un <span style='color:#ff0000'>VAPE</span>!", 5000, 'error')
			
			end
		
		else

			exports['dopeNotify2']:Alert("ERROR", "<span style='color:#c7c7c7'>No puedes usar un <span style='color:#ff0000'>VAPE</span> en el coche!", 5000, 'error')
		
		end
	else

		exports['dopeNotify2']:Alert("ERROR", "<span style='color:#c7c7c7'>No puedes vapear si estas <span style='color:#ff0000'>muerto</span>!", 5000, 'error')

	end

end)

AddEventHandler("chino_vape:VapeAnimFix", function(source)

	local ped = GetPlayerPed(-1)
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"

	while (not HasAnimDictLoaded(ad)) do

		RequestAnimDict(ad)

	  Wait(1)

	end

	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)

end)

AddEventHandler("chino_vape:StopVaping", function(source)

	if IsPlayerAbleToVape == true then

		PlayerIsUnableToVape()
		exports['dopeNotify2']:Alert("ERROR", "<span style='color:#c7c7c7'>Has dejado de <span style='color:#ff0000'>VAPEAR</span>!", 5000, 'error')

	else

		exports['dopeNotify2']:Alert("ERROR", "<span style='color:#c7c7c7'>No estas usando un <span style='color:#ff0000'>VAPE</span>!", 5000, 'error')

	end
end)

AddEventHandler("chino_vape:Drag", function()

	if IsPlayerAbleToVape then

		local ped = GetPlayerPed(-1)
		local PedPos = GetEntityCoords(ped)
		local ad = "mp_player_inteat@burger"
		local anim = "mp_player_int_eat_burger"

		if (DoesEntityExist(ped) and not IsEntityDead(ped)) then

			while (not HasAnimDictLoaded(ad)) do
				RequestAnimDict(ad)
			  Wait(1)
			end

			local VapeFailure = math.random(1,Config['FailureOdds'])

			if VapeFailure == 1 then

				TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
				PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
				Wait(250)
				AddExplosion(PedPos.x, PedPos.y, PedPos.z+1.00, 34, 0.00, true, false, 1.00)
				ApplyDamageToPed(ped, 200, false)
				TriggerServerEvent("chino_vape:Fail", 0)

			else

				TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
				PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
				Wait(950)
				TriggerServerEvent("chino_vape:Smoke", PedToNet(ped))
			  	Wait(Config['VapeHangTime']-1000)
				TriggerEvent("chino_vape:VapeAnimFix", 0)

			end

		end

	else

		exports['dopeNotify2']:Alert("ERROR", "<span style='color:#c7c7c7'>Necesitas estar usando un <span style='color:#ff0000'>VAPE</span>!", 5000, 'error')

	end

end)

AddEventHandler("chino_vape:HelpFadeIn", function()

	if FadeIn == false then

		FadeIn = true
		DisplayText = true

		while FadeIn do

			if Config['HelpTextStartingAlpha'] <= 255 then

				Config['HelpTextStartingAlpha'] = Config['HelpTextStartingAlpha']+5

				if Config['HelpTextStartingAlpha'] >= 255 then

					FadeIn = false
					break

				end

			end

		  Wait(1)

		end

	end
end)

AddEventHandler("chino_vape:HelpFadeOut", function()

	if FadeOut == false then

		FadeOut = true

		while FadeOut do

			if Config['HelpTextStartingAlpha'] >= 1 then

				Config['HelpTextStartingAlpha'] = Config['HelpTextStartingAlpha']-5

				if Config['HelpTextStartingAlpha'] <= 0 then

					FadeOut = false
					DisplayText = false
					break

				end

			end

		  Wait(1)

		end

	end

end)

AddEventHandler("chino_vape:Smoke", function(c_ped)

	if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
		createdSmoke = UseParticleFxAssetNextCall(Config['ParticleAsset'])
		createdPart = StartParticleFxLoopedOnEntityBone(Config['Particle'], NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), 20279), Config['SmokeSize'], 0.0, 0.0, 0.0)
		Wait(Config['VapeHangTime'])
		while DoesParticleFxLoopedExist(createdSmoke) do
			StopParticleFxLooped(createdSmoke, 1)
			Wait(0)
		end
		while DoesParticleFxLoopedExist(createdPart) do
			StopParticleFxLooped(createdPart, 1)
			Wait(0)
		end
		while DoesParticleFxLoopedExist(Config['Particle']) do
			StopParticleFxLooped(Config['Particle'], 1)
			Wait(0)
		end
		while DoesParticleFxLoopedExist(Config['ParticleAsset']) do
			StopParticleFxLooped(Config['ParticleAsset'], 1)
			Wait(0)
		end
		Wait(Config['VapeHangTime']*3)
		RemoveParticleFxFromEntity(NetToPed(c_ped))

	end

end)

Citizen.CreateThread(function()

	while true do

		local ped = GetPlayerPed(-1)

		if IsPedInAnyVehicle(ped, true) then
			PlayerIsEnteringVehicle()
		end

		if IsPlayerAbleToVape then

			if IsControlPressed(0, Config['DragControl']) then
				Wait(Config['ButtonHoldTime'])
				TriggerServerEvent('hud:server:RelieveStress', math.random(14, 18))
				if IsControlPressed(0, Config['DragControl']) then
					TriggerEvent("chino_vape:Drag", 0)
				end
				Wait(Config['VapeCoolDownTime'])
			end

			if IsControlPressed(0, Config['RestingAnim']) then
			  	Wait(Config['ButtonHoldTime'])
				if IsControlPressed(0, Config['RestingAnim']) then
					TriggerEvent("chino_vape:VapeAnimFix", 0)
				end
				Wait(1000)
			end

		end

		Wait(1)

	end
end)

Citizen.CreateThread(function()

	while true do

		if IsPlayerAbleToVape then

			if DisplayText then

				local ped = GetPlayerPed(-1)
				local pedPos = GetEntityCoords(ped)
				exports['okokNotify']:Alert("VAPE", "<span style='color:#c7c7c7'>Preciona <span style='color:#ff0000'>[X]</span> Para dejar de vapear!", 8000, 'neutral')
				exports['okokNotify']:Alert("VAPE", "<span style='color:#c7c7c7'>Preciona <span style='color:#069a19'><b>[E]</b></span> Para empezar a vapear!!", 8000, 'neutral')

			end

		end

		Wait(1)

	end

end)

-- Fin Loops

-- Inicio Funciones

PlayerIsAbleToVape = function()
	IsPlayerAbleToVape = true
	local ped = GetPlayerPed(-1)
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"

	while (not HasAnimDictLoaded(ad)) do
		RequestAnimDict(ad)
	  Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)

	local x,y,z = table.unpack(GetEntityCoords(ped))
	local prop_name = "ba_prop_battle_vape_01"
	VapeMod = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(VapeMod, ped, GetPedBoneIndex(ped, 18905), 0.08, -0.00, 0.03, -150.0, 90.0, -10.0, true, true, false, true, 1, true)
end

PlayerIsEnteringVehicle = function()
	IsPlayerAbleToVape = false
	local ped = GetPlayerPed(-1)
	local ad = "anim@heists@humane_labs@finale@keycards"
	DeleteObject(VapeMod)
	TaskPlayAnim(ped, ad, "exit", 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end

PlayerIsUnableToVape = function()
	IsPlayerAbleToVape = false
	local ped = GetPlayerPed(-1)
	DeleteObject(VapeMod)
	ClearPedTasksImmediately(ped)
	ClearPedSecondaryTask(ped)
end


RegisterNetEvent("chino_vape:OpenMenu")
AddEventHandler("chino_vape:OpenMenu", function()
    openMenu({
        {
            header = "MENU DE VAPEAR",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "Iniciar a vaper",
            txt = "Preciona para inicar a vapear",
            params = {
                event = "chino_vape:StartVaping",
            }
        },
		{
            header = "Dejar de vapear",
            txt = "Preciona para dejar de vapear",
            params = {
                event = "chino_vape:StopVaping",
            }
        },
    })
end)

-- Fin Funciones

-- Inicio Comandos

RegisterCommand('Vapear', function()
	QBCore.Functions.TriggerCallback('chino_vape:CheckVaper',function(cb)
		if cb == 1 then
			TriggerEvent("chino_vape:OpenMenu")
		else
			exports['dopeNotify2']:Alert("ERROR", "<span style='color:#c7c7c7'>No tienes un <span style='color:#ff0000'>VAPE</span>!", 5000, 'error')
		end

	end)
end)

-- Fin Comandos