local isPaused, showHUD, showMAP = false, false, false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)
        local ped = PlayerPedId()
		if IsPedFatallyInjured(ped) then
			local health = (GetEntityHealth(ped) - 201)
			local armor = GetPedArmour(ped)
			local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
			SendNUIMessage({
                action = "hud",
                health = health,
                armor = armor,
                stamina = stamina,
			})
		else
			local health = GetEntityHealth(ped) - 100
			local armor = GetPedArmour(ped)
			local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
			SendNUIMessage({
                action = "hud",
                health = health,
                armor = armor,
                stamina = stamina,
			})
		end
	end
end)

RegisterNUICallback('change', function(data)
    TriggerEvent('PE:change', data.action)
end)

RegisterNetEvent('PE:change')
AddEventHandler('PE:change', function(action)
    if action == "health" then
		SendNUIMessage({action = 'healthT'})
    elseif action == "armor" then
		SendNUIMessage({action = 'armorT'})
    elseif action == "stamina" then
		SendNUIMessage({action = 'staminaT'})
    end
end)

RegisterCommand('hud', function()
    SendNUIMessage({action = color})
    SetNuiFocus(true, true)
end)

RegisterNUICallback('close', function(data)
SetNuiFocus(false, false)
end)