local isBagAttacged = false 
local bagEntity = nil 

RegisterCommand("hemsbag", function()
    local playerPed = GetPlayerPed(-1)
    
    if isBagAttached then
        DetachEntity(bagEntity, true, true)
        DeleteObject(bagEntity)
        isBagAttached = false
        TriggerEvent("chatMessage", "^2Success:", {255, 255, 255}, "You put the bag away!")
    else
        if DoesEntityExist(bagEntity) then
            TriggerEvent("chatMessage", "^3Error:", {255, 255, 255}, "You already have a bag placed on the ground!")
            return
        end
        
        local coords = GetEntityCoords(playerPed)
        local boneIndex = GetPedBoneIndex(playerPed, 24816)
        local model = GetHashKey("prop_cs_heist_bag_02")
        
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
        
        bagEntity = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)
        AttachEntityToEntity(bagEntity, playerPed, boneIndex, 0.12, 0.0, 0.06, 0.0, 270.0, 0.0, true, true, false, true, 1, true)
        isBagAttached = true
        TriggerEvent("chatMessage", "^2Success:", {255, 255, 255}, "You attached the bag to your back!")
    end
end)

RegisterCommand("placebag", function()
    if isBagAttached and DoesEntityExist(bagEntity) then
        local playerPed = GetPlayerPed(-1)
        local coords = GetEntityCoords(playerPed, true)
        local forwardVector = GetEntityForwardVector(playerPed)
        local placementCoords = coords + forwardVector * 2.0
        DetachEntity(bagEntity, true, true)
        SetEntityCoords(bagEntity, placementCoords.x, placementCoords.y, placementCoords.z)
        PlaceObjectOnGroundProperly(bagEntity)
        isBagAttached = false 
        TriggerEvent("chatMessage", "^2Success:", {255, 255, 255}, "You placed the bag on the ground!")
    else
        TriggerEvent("chatMessage", "^3Error:", {255, 255, 255}, "You do not have a bag attached!")
    end
end)

RegisterCommand("pickupbag", function()
    if not isBagAttached and DoesEntityExist(bagEntity) then
        local playerPed = GetPlayerPed(-1)
        local boneIndex = GetPedBoneIndex(playerPed, 24816) 
        AttachEntityToEntity(bagEntity, playerPed, boneIndex, 0.12, 0.0, 0.06, 0.0, 270.0, 0.0, true, true, false, true, 1, true)
        isBagAttached = true
        TriggerEvent("chatMessage", "^2Success:", {255, 255, 255}, "You picked up the bag and attached it to your back!")
    else
        TriggerEvent("chatMessage", "^3Error:", {255, 255, 255}, "You cannot pick up the bag at this time!")
    end
end)