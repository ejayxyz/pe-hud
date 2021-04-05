local showMap, showBars, isOpen = false, false, false
local whisper, normal, scream = 33, 66, 100 
local microphone = normal

-- Main Thread
Citizen.CreateThread(function()
	while true do
        local ped, health = PlayerPedId(), nil
		if IsEntityDead(ped) then
			health = GetEntityHealth(ped) - 201
		else
			health = GetEntityHealth(ped) - 100
		end
		local oxygen = 10 * GetPlayerUnderwaterTimeRemaining(PlayerId())
		local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
		local armor, id = GetPedArmour(ped), GetPlayerServerId(PlayerId())
		local minutes, hours =  GetClockMinutes(), GetClockHours()
		local players = #GetActivePlayers() * 100 / Config.MaxPlayers
		local time = {}
		if minutes <= 9 then
			minutes = "0" .. minutes
		end
		if hours <= 9 then
			hours = "0" .. hours
		end
		time.hours = hours
		time.minutes = minutes
		SendNUIMessage({
			action = "hud",
			health = health,
			armor = armor,
			stamina = stamina,
			oxygen = oxygen,
			id = id,
			players = players,
			time = time.hours .. " : " .. time.minutes,
			
		})
		Citizen.Wait(400)
	end
end)

-- NUI + Events
RegisterNUICallback('close', function(event)
	SendNUIMessage({ action = 'hide' })
	SetNuiFocus(false, false)
	isOpen = false
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
	elseif action == "oxygen" then
		SendNUIMessage({action = 'oxygenT'})
	elseif action == "id" then
		SendNUIMessage({action = 'idT'})
	elseif action == "map" then
		if not showMap then
			showMap = true
			DisplayRadar(true)
		else
			showMap = false
			DisplayRadar(false)
		end
	elseif action == "movie" then
		SendNUIMessage({action = 'movieT'})
	elseif action == "time" then
		SendNUIMessage({action = 'timeT'})
	elseif action == "microphone" then
		SendNUIMessage({action = 'microphoneT'})
    end
end)


-- Opening Menu
RegisterCommand('hud', function()
	if not isOpen then
		isOpen = true
		SendNUIMessage({ action = 'show' })
		SetNuiFocus(true, true)
	end
end)

RegisterKeyMapping('hud', 'Open the hud menu', 'keyboard', 'f7')

RegisterCommand('+levelVoice', function()
	if microphone == 33 then
		microphone = normal
		SendNUIMessage({
			action = "microphone",
			microphone = microphone
		})
	elseif microphone == 66 then
		microphone = scream
		SendNUIMessage({
			action = "microphone",
			microphone = microphone
		})
	elseif microphone == 100 then
		microphone = whisper
		SendNUIMessage({
			action = "microphone",
			microphone = microphone
		})
	end
end)

RegisterKeyMapping('+levelVoice', 'Do not use', 'keyboard', Config.VoiceChange)

-- Handler
AddEventHandler('playerSpawned', function(spawn)
	DisplayRadar(false)
end)

Citizen.CreateThread(function()
    while isOpen do
        Citizen.Wait(100)
        DisableControlAction(0, 322, true)
		DisableControlAction(0, 168, true)
    end
end)

