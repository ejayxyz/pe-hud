local showMap, showBars = false, false

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
		if minutes == 9 then
			minutes = "0" .. minutes
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
RegisterNUICallback('close', function(data)
	SendNUIMessage({ action = 'hide' })
	SetNuiFocus(false, false)
end)

RegisterNUICallback('change', function(data)
    TriggerEvent('PE:change', data.action)
end)

RegisterNUICallback('reset', function(data)
	SendNUIMessage({action = 'test'})
end)

local mic = false

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
		if not mic then
			mic = true
			SendNUIMessage({action = 'microphoneT'})
		else
			mic = false
			SendNUIMessage({action = 'microphoneT'})
		end
    end
end)


-- Opening Menu
RegisterCommand('hud', function()
	SendNUIMessage({ action = 'show' })
    SetNuiFocus(true, true)
end)

RegisterKeyMapping('hud', 'Open the hud menu', 'keyboard', 'f7')

-- Handler
AddEventHandler('playerSpawned', function(spawn)
	DisplayRadar(false)
end)


local level = 33
local microphone = level

Citizen.CreateThread(function()
	while true do
		if IsControlPressed(0, 20) then
			if microphone == 33 then
				microphone = microphone + 33
			elseif microphone == 66 then
				microphone = microphone + 34
			elseif microphone == 100 then
				microphone = level
			end
		end

		SendNUIMessage({
			action = "microphone",
			microphone = microphone
		})
		Citizen.Wait(100)
	end
end)