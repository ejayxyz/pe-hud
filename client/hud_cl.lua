local showMap, showBars, isOpen, movieHud, isPaused = false, false, false, false, false
local healthActive, shieldActive, staminaActive, oxygenActive, microphoneActive, timeActive, movieActive, idActive = false, false, false, false, false, false, false, false
local healthSwitch, shieldSwitch, staminaSwitch, oxygenSwitch, microphoneSwitch, timeSwitch, movieSwitch, idSwitch = false, false, false, false, false, false, false, false
local whisper, normal, scream = 33, 66, 100 
local microphone = normal

-- Main Thread
Citizen.CreateThread(function()
	while true do
        local health = nil
		local oxygen = 10 * GetPlayerUnderwaterTimeRemaining(PlayerId())
		local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
		local armor, id = GetPedArmour(PlayerPedId()), GetPlayerServerId(PlayerId())
		local minutes, hours =  GetClockMinutes(), GetClockHours()
		local players = #GetActivePlayers() * 100 / Config.MaxPlayers
		if IsEntityDead(PlayerPedId()) then
			health = 0
		else
			health = GetEntityHealth(PlayerPedId()) - 100
		end
		if (minutes <= 9) then
			minutes = "0" .. minutes
		end
		if (hours <= 9) then
			hours = "0" .. hours
		end

		if IsPauseMenuActive() and not isPaused and not isOpen then
			if not healthActive then
				healthActive = true
				SendNUIMessage({action = 'healthHide'})
			end
			if not shieldActive then
				shieldActive = true
				SendNUIMessage({action = 'armorHide'})
			end
			if not staminaActive then
				staminaActive = true
				SendNUIMessage({action = 'staminaHide'})
			end
			if oxygenActive then
				oxygenActive = false
				SendNUIMessage({action = 'oxygenHide'})
			end
			if microphoneActive then
				microphoneActive = false
				SendNUIMessage({action = 'microphoneHide'})
			end
			if timeActive then
				timeActive = false
				SendNUIMessage({action = 'timeHide'})
			end
			if idActive then
				idActive = false
				SendNUIMessage({action = 'idHide'})
			end
			if movieActive then
				movieActive = false
				SendNUIMessage({action = 'movieHide'})
			end
			isPaused = true
		elseif not IsPauseMenuActive() and isPaused and not movieHud then
			if healthActive and not healthSwitch then
				healthActive = false
				SendNUIMessage({action = 'healthT'})
			end
			if shieldActive and not shieldSwitch then
				shieldActive = false
				SendNUIMessage({action = 'armorT'})
			end
			if staminaActive and not staminaSwitch then
				staminaActive = false
				SendNUIMessage({action = 'staminaT'})
			end
			if not oxygenActive and oxygenSwitch then
				oxygenActive = true
				SendNUIMessage({action = 'oxygenT'})
			end
			if not microphoneActive and microphoneSwitch then
				microphoneActive = true
				SendNUIMessage({action = 'microphoneT'})
			end
			if not timeActive and timeSwitch then
				timeActive = true
				SendNUIMessage({action = 'timeT'})
			end
			if not movieActive and movieSwitch then
				movieActive = true
				SendNUIMessage({action = 'movieT'})
			end
			if not idActive and idSwitch then
				idActive = true
				SendNUIMessage({action = 'idT'})
			end
			isPaused = false
		elseif not IsPauseMenuActive() and movieHud and isPaused then
			if not healthActive then
				healthActive = true
				SendNUIMessage({action = 'healthHide'})
			end
			if not shieldActive then
				shieldActive = true
				SendNUIMessage({action = 'armorHide'})
			end
			if not staminaActive then
				staminaActive = true
				SendNUIMessage({action = 'staminaHide'})
			end
			if oxygenActive then
				oxygenActive = false
				SendNUIMessage({action = 'oxygenHide'})
			end
			if microphoneActive then
				microphoneActive = false
				SendNUIMessage({action = 'microphoneHide'})
			end
			if timeActive then
				timeActive = false
				SendNUIMessage({action = 'timeHide'})
			end
			if idActive then
				idActive = false
				SendNUIMessage({action = 'idHide'})
			end
			movieActive = true
			SendNUIMessage({action = 'movieT'})
			isPaused = false
		end
		SendNUIMessage({
			action = "hud",
			health = health,
			armor = armor,
			stamina = stamina,
			oxygen = oxygen,
			id = id,
			players = players,
			time = hours .. " : " .. minutes
		})
		Citizen.Wait(420)
	end
end)

Citizen.CreateThread(function()
    while isOpen do
        Citizen.Wait(100)
        DisableControlAction(0, 322, true)
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
		if not healthActive then
			healthActive = true
			healthSwitch = true
			SendNUIMessage({action = 'healthHide'})
		else
			healthActive = false
			healthSwitch = false
			SendNUIMessage({action = 'healthT'})
		end
    elseif action == "armor" then
		if not shieldActive then
			shieldActive = true
			shieldSwitch = true
			SendNUIMessage({action = 'armorHide'})
		else
			shieldActive = false
			shieldSwitch = false
			SendNUIMessage({action = 'armorT'})
		end
    elseif action == "stamina" then
		if not staminaActive then
			staminaActive = true
			staminaSwitch = true
			SendNUIMessage({action = 'staminaHide'})
		else
			staminaActive = false
			staminaSwitch = false
			SendNUIMessage({action = 'staminaT'})
		end
	elseif action == "oxygen" then
		if not oxygenActive then
			oxygenActive = true
			oxygenSwitch = true
			SendNUIMessage({action = 'oxygenT'})
		else
			oxygenActive = false
			oxygenSwitch = false
			SendNUIMessage({action = 'oxygenHide'})
		end
	elseif action == "id" then
		if not idActive then
			idActive = true
			idSwitch = true
			SendNUIMessage({action = 'idT'})
		else
			idActive = false
			idSwitch = false
			SendNUIMessage({action = 'idHide'})
		end
	elseif action == "map" then
		if not showMap then
			showMap = true
			DisplayRadar(true)
		else
			showMap = false
			DisplayRadar(false)
		end
	elseif action == "movie" then
		if not movieActive then
			movieActive = true
			movieSwitch = true
			movieHud = true
			if not healthActive then
				healthActive = true
				SendNUIMessage({action = 'healthHide'})
			end
			if not shieldActive then
				shieldActive = true
				SendNUIMessage({action = 'armorHide'})
			end
			if not staminaActive then
				staminaActive = true
				SendNUIMessage({action = 'staminaHide'})
			end
			if oxygenActive then
				oxygenActive = false
				SendNUIMessage({action = 'oxygenHide'})
			end
			if microphoneActive then
				microphoneActive = false
				SendNUIMessage({action = 'microphoneHide'})
			end
			if timeActive then
				timeActive = false
				SendNUIMessage({action = 'timeHide'})
			end
			if idActive then
				idActive = false
				SendNUIMessage({action = 'idHide'})
			end
			SendNUIMessage({action = 'movieT'})
		else
			movieActive = false
			movieSwitch = false
			movieHud = false
			if healthActive and not healthSwitch then
				healthActive = false
				SendNUIMessage({action = 'healthT'})
			end
			if shieldActive and not shieldSwitch then
				shieldActive = false
				SendNUIMessage({action = 'armorT'})
			end
			if staminaActive and not staminaSwitch then
				staminaActive = false
				SendNUIMessage({action = 'staminaT'})
			end
			if not oxygenActive and oxygenSwitch then
				oxygenActive = true
				SendNUIMessage({action = 'oxygenT'})
			end
			if not microphoneActive and microphoneSwitch then
				microphoneActive = true
				SendNUIMessage({action = 'microphoneT'})
			end
			if not timeActive and timeSwitch then
				timeActive = true
				SendNUIMessage({action = 'timeT'})
			end
			if not movieActive and movieSwitch then
				movieActive = true
				SendNUIMessage({action = 'movieT'})
			end
			if not idActive and idSwitch then
				idActive = true
				SendNUIMessage({action = 'idT'})
			end
			SendNUIMessage({action = 'movieHide'})
		end
	elseif action == "time" then
		if not timeActive then
			timeActive = true
			timeSwitch = true
			SendNUIMessage({action = 'timeT'})
		else
			timeActive = false
			timeSwitch = false
			SendNUIMessage({action = 'timeHide'})
		end
	elseif action == "microphone" then
		if not microphoneActive then
			microphoneActive = true
			microphoneSwitch = true
			SendNUIMessage({action = 'microphoneT'})
		else
			microphoneActive = false
			microphoneSwitch = false
			SendNUIMessage({action = 'microphoneHide'})
		end
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

RegisterCommand('+levelVoice', function()
	if (microphone == 33) then
		microphone = normal
		SendNUIMessage({
			action = "microphone",
			microphone = microphone
		})
	elseif (microphone == 66) then
		microphone = scream
		SendNUIMessage({
			action = "microphone",
			microphone = microphone
		})
	elseif (microphone == 100) then
		microphone = whisper
		SendNUIMessage({
			action = "microphone",
			microphone = microphone
		})
	end
end)

RegisterKeyMapping('hud', 'Open the hud menu', 'keyboard', 'f7')

RegisterKeyMapping('+levelVoice', 'Do not use', 'keyboard', Config.VoiceChange)

-- Handler
AddEventHandler('playerSpawned', function()
	DisplayRadar(false)
end)
