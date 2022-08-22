Key = 38 -- E

local inRepairShop = false
local uiVisible = false
local repairing = false

local function RepairBlips(coords, type, label, job, blipOptions)
    if job then return end
    if blip == false then return end
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, blipOptions?.sprite or 357)
    SetBlipScale(blip, blipOptions?.scale or 0.8)
    SetBlipColour(blip, blipOptions?.colour ~= nil and blipOptions.colour or type == 'car' and Config.BlipColors.Car or type == 'boat' and Config.BlipColors.Boat or Config.BlipColors.Aircraft)
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
                        TriggerEvent('cd_drawtextui:ShowUI', 'show', "[E] Fix Vehicle for $".. repairCost .."")
                        uiVisible = true
                    elseif uiVisible == false and repairCost == 0 then
                        uiVisible = true
                        repairing = false
                        TriggerEvent('cd_drawtextui:ShowUI', 'show', "Nothing to repair")
                    end
                    if repairCost > 0 then 
                        if IsControlJustPressed(1, Key) and repairing == false then
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
                TriggerEvent('cd_drawtextui:HideUI')
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
            TriggerEvent('cd_drawtextui:HideUI')
            break
        end
    end
end)

RegisterNetEvent('just_repairs:success')
AddEventHandler('just_repairs:success', function ()
	local car = GetVehiclePedIsUsing(PlayerPedId())

    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'car_repair', 0.1)
    if Config.UseMythicProgbar == true then 
        TriggerEvent("mythic_progbar:client:progress", {
            name = "repair_vehicle",
            duration = (Config.RepairTime * 1000),
            label = "Repairing Vehicle",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(status)
            if not status then
                SetVehicleEngineHealth(car, 1000)
                SetVehicleFixed(car)
                if Config.UseMythicNotify == true then 
                    TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'Your vehicle has been fixed! Maybe you should take some driving lessons...', length = 2500})
                else
                    -- ESX.ShowNotification('Your vehicle has been fixed! Maybe you should take some driving lessons...')
                    TriggerEvent("swt_notifications:Icon", 'Your vehicle has been fixed! Maybe you should take some driving lessons...',"top-right",4000,"green-8","white",true,"mdi-car-wash")
                end
                uiVisible = false
            end
        end)
    else
        local timer2 = true
        local mycie = true
        local timer = Config.RepairTime
        FreezeEntityPosition(car, true)
        Citizen.CreateThread(function()
            while timer2 do
                Citizen.Wait(0)
                Citizen.Wait(1000)
                if(timer > 0)then
                    timer = timer - 1
                elseif (timer == 0) then
                    mycie = false
                    SetVehicleEngineHealth(car, 1000)
                    SetVehicleFixed(car)
                    FreezeEntityPosition(car, false)
                    if Config.UseMythicNotify == true then 
                        TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'Your vehicle has been fixed! Maybe you should take some driving lessons...', length = 2500})
                    else
                        -- ESX.ShowNotification('Your vehicle has been fixed! Maybe you should take some driving lessons...')
                        TriggerEvent("swt_notifications:Icon", 'Your vehicle has been fixed! Maybe you should take some driving lessons...',"top-right",4000,"green-8","white",true,"mdi-car-wash")
                    end
                    uiVisible = false
                    timer2 = false
                end
            end
        end)
        Citizen.CreateThread(function()
            local playerCoord = GetEntityCoords(PlayerPedId())
            while mycie do
                Citizen.Wait(0)
                DrawText3D(playerCoord.x, playerCoord.y, playerCoord.z + 1, '~b~Fixing... ~s~Time:~b~ '.. timer ..' ~s~seconds.')
            end
        end)
    end
end)

RegisterNetEvent('just_repairs:notenoughmoney')
AddEventHandler('just_repairs:notenoughmoney', function (moneyleft)
    if Config.UseMythicNotify == true then 
        TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = "You don't have enough money! You need: $" .. moneyleft .." more.", length = 2500})
    else
        -- ESX.ShowNotification("You don't have enough money! You need: $" .. moneyleft .." more.")
    	TriggerEvent("swt_notifications:Icon", "You don't have enough money! You need: $" .. moneyleft .." more.","top-right",5000,"red","white",true,"mdi-alert-circle-outline")
    end
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