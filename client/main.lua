local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(0)
    end
end)

RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
end)

TeleportToWaypoint = function()
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
            local WaypointHandle = GetFirstBlipInfoId(8)

            if DoesBlipExist(WaypointHandle) then
                local coords = GetBlipInfoIdCoord(WaypointHandle)
                local x,y,z = coords.x,coords.y,coords.z 
                local bottom,top = GetHeightmapBottomZForPosition(x,y), GetHeightmapTopZForPosition(x,y)
                local steps = (top-bottom)/100
                local foundGround
                local height = bottom + 0.0
                while not foundGround and height < top  do 
                    SetPedCoordsKeepVehicle(PlayerPedId(), x,y, height )
                    foundGround, zPos = GetGroundZFor_3dCoord(x,y, height )
                    height = height + steps
                    Wait(0)
                end 
                SetPedCoordsKeepVehicle(PlayerPedId(), x,y, height )
                print('TP(Marker/GPS)',vector3(x,y, height))
                    
                ESX.ShowNotification("Teleported.")
            else
                ESX.ShowNotification("Please place your waypoint.")
            end
        else
            ESX.ShowNotification("You do not have rights to do this.")
        end
    end)
end
