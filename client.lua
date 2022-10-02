local inRepairShop = false
local uiVisible = false
local repairing = false

local function RepairBlips(coords, type, label, job, blipOptions)
    if job then return end
    if blip == false then return end
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, blipOptions.sprite or 357)
    SetBlipScale(blip, blipOptions.scale or 0.8)
    SetBlipColour(blip, blipOptions.colour ~= nil and blipOptions.colour or type == 'car' and Config.BlipColors.Car or type == 'boat' and Config.BlipColors.Boat or Config.BlipColors.Aircraft)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
end

for k, v in pairs(Config.RepairShops) do

    exports["bt-polyzone"]:AddBoxZone(v.zone.name, vector3(v.zone.x, v.zone.y, v.zone.z), v.zone.l, v.zone.w, {
        name = v.zone.name,
        heading = v.zone.h,
        debugPoly = false,
        minZ = v.zone.minZ,
        maxZ = v.zone.maxZ
	    }
    )

    if v.blip ~= false then
        RepairBlips(vector3(v.zone.x, v.zone.y, v.zone.z), v.type, v.label, v.job, v.blip)
    end

end

RegisterNetEvent('just_repairs:enteredRepair')
AddEventHandler('just_repairs:enteredRepair', function (price)
	Citizen.CreateThread(function ()
        local check = false
        local veh = nil
        local driver = nil
        local vehClass = nil
        local Ped = PlayerPedId()
		while inRepairShop do
			Citizen.Wait(0)
            if IsPedSittingInAnyVehicle(Ped) then
                if check == false then 
                    check = true
                    veh = GetVehiclePedIsUsing(Ped)
                    driver = GetPedInVehicleSeat(veh, -1)
                    vehClass = GetVehicleClass(veh)
                end
                if driver == Ped then
                    local bodyHealth = GetVehicleBodyHealth(veh)
                    local engineHealth = GetVehicleEngineHealth(veh)
                    repairCost = math.ceil((((1000 - bodyHealth) + (1000 - engineHealth)) * Config.CostFactor) * Config.ClassRepairMultiplier[vehClass])
                    if uiVisible == false and repairCost > 0 then
                        lib.showTextUI("[E] Fix Vehicle for $".. repairCost, {icon = "fa-solid fa-screwdriver-wrench"})
                        uiVisible = true
                    elseif uiVisible == false and repairCost == 0 then
                        uiVisible = true
                        repairing = false
                        lib.showTextUI("Nothing to repair")
                    end
                    if repairCost > 0 then 
                        if IsControlJustPressed(1, 38) and repairing == false then
                            check = true
                            repairing = true
                            TriggerServerEvent('just_repairs:checkmoney',repairCost)
                        end
                    end
                else 
                    Citizen.Wait(2000)
                    check = false
                    repairing = false
                end
            else 
                repairing = false
                uiVisible = false
                lib.hideTextUI()
                check = false
            end
		end
	end)
end)

RegisterNetEvent('bt-polyzone:enter')
AddEventHandler('bt-polyzone:enter', function(name)
    for k, v in pairs(Config.RepairShops) do
        if v.zone.name == name then
            inRepairShop = true
            TriggerEvent('just_repairs:enteredRepair')
            break
        end
    end
end)

RegisterNetEvent('bt-polyzone:exit')
AddEventHandler('bt-polyzone:exit', function(name)
    for k, v in pairs(Config.RepairShops) do
        if v.zone.name == name then
            inRepairShop = false
            Citizen.Wait(100)
            uiVisible = false
            lib.hideTextUI()
            break
        end
    end
end)

RegisterNetEvent('just_repairs:success')
AddEventHandler('just_repairs:success', function ()
	local car = GetVehiclePedIsUsing(PlayerPedId())

    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'car_repair', 0.1)
    if lib.progressBar({
		duration = (Config.RepairTime * 1000),
		label = "Repairing Vehicle",
		useWhileDead = false,
		canCancel = true,
		disable  = {
			move = true,
			car = true,
		},
	}) then
        SetVehicleEngineHealth(car, 1000)
        SetVehicleFixed(car)
        lib.notify({
			title = "Your vehicle has been fixed!",
			description = "Maybe you should take some driving lessons...",
			status = "inform"
		})
        uiVisible = false
    end
end)

RegisterNetEvent('just_repairs:notenoughmoney')
AddEventHandler('just_repairs:notenoughmoney', function (moneyleft)
    lib.notify({
        title = "You don't have enough money!",
        description = "You need: $"..moneyleft,
        status = "error"
    })
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end