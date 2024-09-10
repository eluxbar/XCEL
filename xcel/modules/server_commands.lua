RegisterCommand('addgroup', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local group = args[2]
        XCEL.addUserGroup(userid,group)
        print('Added Group: ' .. group .. ' to UserID: ' .. userid)
    else 
        print('Incorrect usage: addgroup [permid] [group]')
    end
end)

RegisterCommand('removegroup', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local group = args[2]
        XCEL.removeUserGroup(userid,group)
        print('Removed Group: ' .. group .. ' from UserID: ' .. userid)
    else 
        print('Incorrect usage: addgroup [permid] [group]')
    end
end)

RegisterCommand('ban', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local hours = args[2]
        local reason = table.concat(args," ", 3)
        if reason then 
            XCEL.banConsole(userid,hours,reason)
        else 
            print('Incorrect usage: ban [permid] [hours] [reason]')
        end 
    else 
        print('Incorrect usage: ban [permid] [hours] [reason]')
    end
end)

RegisterCommand('unban', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1])  then
        local userid = tonumber(args[1])
        XCEL.setBanned(userid,false)
        print('Unbanned user: ' .. userid )
    else 
        print('Incorrect usage: unban [permid]')
    end
end)


RegisterCommand('cashtoall', function(source, args)
    if source ~= 0 then return end; -- checks if its the console doing the command!
    if tonumber(args[1])  then -- args[1] is the amount of cash you would give to everyone
        local amount = tonumber(args[1]) -- the value amount = args[1]
        print('Giving £' .. amount .. ' to all users') -- prints to console
        for k,v in pairs(XCEL.getUsers()) do -- XCEL.getUsers() is all the players online
            XCELclient.notify(v, {'~g~You have received £' .. getMoneyStringFormatted(amount) .. ' from the server'}) -- simple notify like i shown before, .. getMoneyStringFormatted(amount) .. if fetching the args[1] but getMoneyStringFormatted just formats it so 1,000,000 isnt 1000000!
            XCEL.giveBankMoney(k, amount) -- gives the money to everyone on the server
        end
    else 
        print('Incorrect usage: cashtoall [amount]')
    end
end)

RegisterCommand('revive', function(source, args)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'group.add.operationsmanager') then
        XCELclient.RevivePlayer(source, {})
    else
        XCELclient.notify(source, {'~r~You do not have permission to use this!'})
    end
end)


 RegisterCommand('newbie', function(source, args)
    local source = source
    local user_id = XCEL.getUserId(source)
    local AlreadyClaimed = XCEL.hasGroup(user_id, 'AlreadyClaimed')
    if not AlreadyClaimed then
        XCEL.giveBankMoney(user_id, '2000000')
        TriggerClientEvent('XCEL:smallAnnouncement', source, 'Welcome To XCEL', "You have received 2 Million because your a newbie, We appreciate your support!\n", 18, 10000)
        XCEL.addUserGroup(user_id, 'AlreadyClaimed')
    else 
        XCELclient.notify(source, {'~r~You Have Already Claimed this!'})   
    end
end)

RegisterCommand('thankyou', function(source, args)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id <= 50 and not XCEL.hasGroup(user_id, 'Rebel') then
        XCEL.addUserGroup(user_id, 'Rebel')
        TriggerClientEvent('XCEL:smallAnnouncement', source, 'XCEL', "Thankyou for being one of our first 50 members, we appreciate your support!\n", 18, 10000)
    end
end)  

RegisterCommand('armour', function(source, args)
    local source = source 
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.ban') then
        XCELclient.setArmour(source, {200})
        XCELclient.notify(source, {'Enjoy Free Armour'})
    else
        XCELclient.notify(source, {'You do not have permission to use this command.'})
    end
end)

RegisterCommand('beta', function(source, args, rawCommand)
    if not XCEL.hasGroup(XCEL.getUserId(source), 'supporter') then 
        XCEL.addUserGroup(XCEL.getUserId(source),'supporter')
        XCELclient.notify(source, {'~g~Thankyou for participating in the beta ❤'})
        XCELclient.notify(source, {'~g~Received Suporter'})
    end
end, false) 

local lastExecutionTime = 0
local cooldownTime = 600

RegisterCommand('mosinall', function(source, args, rawCommand)
    if source ~= 0 then
        local currentTime = os.time()
        if currentTime - lastExecutionTime >= cooldownTime then
            local user_id = XCEL.getUserId(source)
            if XCEL.hasGroup(user_id,"eventmanager")  or XCEL.hasGroup(user_id,"Developer") then
                local weapon = "WEAPON_MOSIN"
                for _, v in pairs(GetPlayers()) do
                    XCELclient.giveWeapons(v, {{[weapon] = {ammo = 250}}})
                    XCELclient.notify(v, {'~g~Mosin was added to your inventory for an event'})
                    XCELclient.notify(v, {'~g~' .. weapon .. ' has been added to your inventory from the server.'})
                end
                lastExecutionTime = currentTime
                print('Weapon ' .. weapon .. ' distributed to all players by Admin ID: ' .. user_id)
            end
        else
            local remainingTime = cooldownTime - (currentTime - lastExecutionTime)
            local minutes = math.floor(remainingTime / 60)
            local seconds = remainingTime % 60
            XCELclient.notify(source, {'~r~Command is on cooldown. Please wait ' .. minutes .. ' minutes and ' .. seconds .. ' seconds.'})
        end
    else
        print('Command /mosinall cannot be run from the console.')
    end
end, false)
