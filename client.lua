local isPaused = false
local showHUD = false
local showMAP = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)
		if IsPedFatallyInjured(PlayerPedId()) then
			local health = (GetEntityHealth(PlayerPedId()) - 201)
			local armor = GetPedArmour(PlayerPedId())
			local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
			SendNUIMessage({action = "hud",
						health = health,
						armor = armor,
						stamina = stamina,
			})
		else
			local health = (GetEntityHealth(PlayerPedId()) - 100)
			local armor = GetPedArmour(PlayerPedId())
			local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
			SendNUIMessage({action = "hud",
						health = health,
						armor = armor,
						stamina = stamina,
			})
		end

		if IsPauseMenuActive() and not isPaused and not showHUD then
			isPaused = true
			SendNUIMessage({
				action = 'showHide'
			})
		elseif not IsPauseMenuActive() and isPaused then
			isPaused = false
			SendNUIMessage({
				action = 'showHide'
			})
		end

	end
end)

RegisterCommand('hud', function()
	TriggerEvent('pe-hud:hud')
end, false)

RegisterKeyMapping('hud', 'Mostrar/Ocultar HUD', 'keyboard', 'f7')

RegisterNetEvent('pe-hud:hud')
AddEventHandler('pe-hud:hud', function()
	if showHUD == false and not isPaused then
		SendNUIMessage({
			action = 'showHide'
		})
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  'El HUD ahora esta oculto'
		})
		Citizen.Wait(300)
		showHUD = true
	elseif showHUD == true and not isPaused then
		SendNUIMessage({
			action = 'showHide'
		})
		exports['t-notify']:Alert({
			style  =  'success',
			message  =  'El HUD ahora es visible'
		})
		Citizen.Wait(300)
		showHUD = false
	end
end)

RegisterCommand('map', function()
	TriggerEvent('pe-hud:map')
end, false)

RegisterKeyMapping('map', 'Mostrar/Ocultar el mapa', 'keyboard', 'f10')

RegisterNetEvent('pe-hud:map')
AddEventHandler('pe-hud:map', function()
	if showMAP == false and not isPaused then
		DisplayRadar(false)
		showMAP = true
	elseif showMAP == true and not isPaused then
		DisplayRadar(true)
		showMAP = false
	end
end)