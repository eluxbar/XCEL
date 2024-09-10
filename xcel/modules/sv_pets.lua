
--
local ownedPets = {
    ["bear"] = {
        awaitingHealthReduction = false,
        name = "Bear",
        id = "bear",
        ownedSkills = {
            teleport = true,
        },
    },
}

local disabledAbilities = {
    attack = false,
}


AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    local user_id = XCEL.getUserId(source)
    if first_spawn then
        TriggerClientEvent('XCEL:buildPetCFG', source, ownedPets, disabledAbilities, petStore)
    end
end)

RegisterServerEvent('XCEL:receivePetCommand')
AddEventHandler("XCEL:receivePetCommand", function(id, M, L, zz)
    local source = source
    local user_id = XCEL.getUserId(source)
    -- check if permid owns this pet
    TriggerClientEvent('XCEL:receivePetCommand', source, M, L, zz)
end)

RegisterServerEvent('XCEL:startPetAttack')
AddEventHandler("XCEL:startPetAttack", function(id, M, Y)
    local source = source
    local user_id = XCEL.getUserId(source)
    -- check if permid owns this pet and that attacks aren't disabled
    TriggerClientEvent('XCEL:sendClientRagdollPet', Y, user_id, XCEL.GetPlayerName(user_id))
    TriggerClientEvent('XCEL:startPetAttack', source, id)
end)

RegisterCommand('pet', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id == 1 then
        TriggerClientEvent('XCEL:togglePetMenu', source)
    end
end)
