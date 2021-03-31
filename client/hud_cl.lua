

Citizen.CreateThread(function()
	while true do
        local ped, health = PlayerPedId(), nil
		if IsEntityDead(ped) then
			health = GetEntityHealth(ped) - 201
		else
			health = GetEntityHealth(ped) - 100
		end

		local stamina = nil
		if IsEntityInWater(ped) and IsPedSwimming(ped) then
			stamina = 10 * GetPlayerUnderwaterTimeRemaining(PlayerId())
			if stamina <= 0 then
				stamina = 0
			end
		else
			stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
		end

		print(stamina)		

		local armor = GetPedArmour(ped)

		local id = GetPlayerServerId(PlayerId())
		SendNUIMessage({
			action = "hud",
			health = health,
			armor = armor,
			stamina = stamina,
			oxygen = oxygen,
			id = id,
		})
		Citizen.Wait(400)
	end
end)

--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)
        local ped = PlayerPedId()
		if IsEntityDead(ped) then
			local health = (GetEntityHealth(ped) - 201)
			local armor = GetPedArmour(ped)
			local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
			local id = GetPlayerServerId(PlayerId())
			SendNUIMessage({
                action = "hud",
                health = health,
                armor = armor,
                stamina = stamina,
				id = id,
			})
		else
			local health = GetEntityHealth(ped) - 100
			local armor = GetPedArmour(ped)
			local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
			local id = GetPlayerServerId(PlayerId())
			SendNUIMessage({
                action = "hud",
                health = health,
                armor = armor,
                stamina = stamina,
				id = id,
			})
		end
	end
end)]]

RegisterNUICallback('close', function(data)
	SetNuiFocus(false, false)
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
	elseif action == "map" then
		mapToggle()
    end
end)



RegisterCommand('hud', function()
    SetNuiFocus(true, true)
end)

-- Functions
function mapToggle()
	if not showMap then
		showMap = true
		DisplayRadar(false)
	else
		showMap = false
		DisplayRadar(true)
	end
end