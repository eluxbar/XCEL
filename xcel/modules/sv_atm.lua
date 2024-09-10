local cfg = module("cfg/atms")
local organcfg = module("cfg/cfg_organheist")
local lang = XCEL.lang

RegisterServerEvent("XCEL:Withdraw")
AddEventHandler('XCEL:Withdraw', function(amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    local amount = tonumber(amount)
    if amount > 0 then  
        if user_id ~= nil then
            if XCEL.tryWithdraw(user_id, amount) then
                XCELclient.notify(source, {"~g~You have withdrawn £"..getMoneyStringFormatted(amount)})
                XCELclient.playAnim(source,{false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
            else 
                XCELclient.notify(source, {"~r~You do not have enough money to withdraw."})
            end
        end
    end
end)
RegisterServerEvent("XCEL:Deposit")
AddEventHandler('XCEL:Deposit', function(amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    local amount = tonumber(amount)
    if amount > 0 then  
        if user_id ~= nil then
            if XCEL.tryDeposit(user_id, amount) then
                XCELclient.notify(source, {"~g~You have deposited £"..getMoneyStringFormatted(amount)})
                XCELclient.playAnim(source,{false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
            else 
                XCELclient.notify(source, {"~r~You do not have enough money to deposit."})
            end
        end
    end
end)

RegisterServerEvent("XCEL:WithdrawAll")
AddEventHandler('XCEL:WithdrawAll', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local amount = XCEL.getBankMoney(XCEL.getUserId(source))
    if amount > 0 then  
        if user_id ~= nil then
            if XCEL.tryWithdraw(user_id, amount) then
                XCELclient.notify(source, {"~g~You have withdrawn £"..getMoneyStringFormatted(amount)})
                XCELclient.playAnim(source,{false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
            else 
                XCELclient.notify(source, {"~r~You do not have enough money to withdraw."})
            end
        end
    end
end)

RegisterServerEvent("XCEL:DepositAll")
AddEventHandler('XCEL:DepositAll', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local amount = XCEL.getMoney(XCEL.getUserId(source))
    if amount > 0 then  
        if user_id ~= nil then
            if XCEL.tryDeposit(user_id, amount) then
                XCELclient.notify(source, {"~g~You have deposited £"..getMoneyStringFormatted(amount)})
                XCELclient.playAnim(source,{false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
            else 
                XCELclient.notify(source, {"~r~You do not have enough money to deposit."})
            end
        end
    end
end)

