 local permissionCategories = {"Client", "Weapon", "Vehicle", "Blacklist", "Misc"}

 local function givePermissionToPlayer(user_id)
     if not user_id  then return end
     if GetResourceState('xcel-ac') == "started" then
         for group, groupPermissions in pairs(FGconfig) do
             if XCEL.hasGroup(user_id, group) then
                 for _, category in ipairs(permissionCategories) do
                     local categoryConfig = groupPermissions[tostring(category)]
                     if categoryConfig then
                         for _, permission in ipairs(categoryConfig) do
                             exports['xcel-ac']:SetTempPermission(user_id, category, permission, true, true)
                         end
                     end
                 end
                 break
             end
         end
     end
 end

 local function reloadAllPlayers()
     for i, p in pairs(XCEL.getUsers()) do
         givePermissionToPlayer(i)
     end
 end

 CreateThread(function()
     while true do
         Wait(300000)
         reloadAllPlayers()
     end
 end)
 RegisterServerEvent('XCEL:FiveGuard:givePermissionToPlayer', function(user_id)
     givePermissionToPlayer(user_id)
     reloadAllPlayers()
 end)


 local Client = {
     "BypassSpectate", "BypassGodMode", "BypassInvisible", "BypassStealOutfit",
     "BypassInfStamina", "BypassNoclip", "BypassSuperJump", "BypassFreecam",
     "BypassSpeedHack", "BypassTeleport", "BypassNightVision", "BypassThermalVision",
     "BypassOCR", "BypassNuiDevtools", "BypassBlacklistedTextures", "BlipsBypass",
     "BypassCbScanner"
 }

 local Weapon = {
     "BypassWeaponDmgModifier", "BypassInfAmmo", "BypassNoReload", "BypassRapidFire"
 }

 local Vehicle = {
     "BypassVehicleFixAndGodMode", "BypassVehicleHandlingEdit", "BypassVehicleModifier",
     "BypassBulletproofTires"
 }

 local Blacklist = {
     "BypassModelChanger", "BypassWeaponBlacklist"
 }

 local Misc = {
     "FGCommands", "BypassVPN", "BypassExplosion", "BypassClearTasks", "BypassParticle"
 }

 local DefaultStaff = {
     ["Client"] = "BypassSpectate", "BypassGodMode", "BypassInvisible", "BypassNoclip",
 }

 FGconfig = {
     ["Founder"] = {
         ["Client"] = Client,
         ["Weapon"] = Weapon,
         ["Vehicle"] = Vehicle,
         ["Blacklist"] = Blacklist,
         ["Misc"] = Misc
     },
     ["Lead Developer"] = {
         ["Client"] = Client,
         ["Weapon"] = Weapon,
         ["Vehicle"] = Vehicle,
         ["Blacklist"] = Blacklist,
         ["Misc"] = Misc
     },
     ["Developer"] = {
        ["Client"] = Client,
        ["Weapon"] = Weapon,
        ["Vehicle"] = Vehicle,
        ["Blacklist"] = Blacklist,
        ["Misc"] = Misc
    },

 }
