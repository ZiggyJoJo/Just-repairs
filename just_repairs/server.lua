ESX             = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('just_repairs:checkmoney')
AddEventHandler('just_repairs:checkmoney', function (cost)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= cost then
		xPlayer.removeMoney(cost)
		TriggerClientEvent('just_repairs:success', source)
	else
		moneyleft = cost - xPlayer.getMoney()
		TriggerClientEvent('just_repairs:notenoughmoney', source, moneyleft)
	end
end)
