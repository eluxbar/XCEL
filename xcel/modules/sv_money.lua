local lang = XCEL.lang
--Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)

MySQL.createCommand("XCEL/money_init_user","INSERT IGNORE INTO xcel_user_moneys(user_id,wallet,bank,offshore) VALUES(@user_id,@wallet,@bank,@offshore)")
MySQL.createCommand("XCEL/get_money","SELECT wallet,bank,offshore FROM xcel_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("XCEL/set_money","UPDATE xcel_user_moneys SET wallet = @wallet, bank = @bank, offshore = @offshore WHERE user_id = @user_id")

-- get money
-- cbreturn nil if error
function XCEL.getMoney(user_id)
  local tmp = XCEL.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

    -- get offshore
    function XCEL.getOffshoreMoney(user_id)
      local tmp = XCEL.getUserTmpTable(user_id)
      if tmp then
        return tmp.offshore or 0
      else
        return 0
      end
    end
  
    -- set offshore money
    function XCEL.setOffshoreMoney(user_id,value)
      local tmp = XCEL.getUserTmpTable(user_id)
      if tmp then
        tmp.offshore = value
      end
  
    -- update client display
    local source = XCEL.getUserSource(user_id)
    if source ~= nil then
      TriggerClientEvent('XCEL:setDisplayOffshore', source, tmp.offshore)
    end
  end
  
      -- give offshore money
      function XCEL.giveOffshoreMoney(user_id,amount)
        local money = XCEL.getOffshoreMoney(user_id)
        XCEL.setOffshoreMoney(user_id,money+amount)
      end

-- set money
function XCEL.setMoney(user_id,value)
  local tmp = XCEL.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = XCEL.getUserSource(user_id)
  if source ~= nil then
    XCELclient.setDivContent(source,{"money",lang.money.display({Comma(XCEL.getMoney(user_id))})})
    TriggerClientEvent('XCEL:initMoney', source, XCEL.getMoney(user_id), XCEL.getBankMoney(user_id))
  end
end

-- try a payment
-- return true or false (debited if true)
function XCEL.tryPayment(user_id,amount)
  local money = XCEL.getMoney(user_id)
  if amount >= 0 and money >= amount then
    XCEL.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function XCEL.tryBankPayment(user_id,amount)
  local bank = XCEL.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    XCEL.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function XCEL.giveMoney(user_id,amount)
  local money = XCEL.getMoney(user_id)
  XCEL.setMoney(user_id,money+amount)
end

-- get bank money
function XCEL.getBankMoney(user_id)
  local tmp = XCEL.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function XCEL.setBankMoney(user_id,value)
  local tmp = XCEL.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = XCEL.getUserSource(user_id)
  if source ~= nil then
    XCELclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(XCEL.getBankMoney(user_id))})})
    TriggerClientEvent('XCEL:initMoney', source, XCEL.getMoney(user_id), XCEL.getBankMoney(user_id))
  end
end

-- give bank money
function XCEL.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = XCEL.getBankMoney(user_id)
    XCEL.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function XCEL.tryWithdraw(user_id,amount)
  local money = XCEL.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    XCEL.setBankMoney(user_id,money-amount)
    XCEL.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function XCEL.tryDeposit(user_id,amount)
  if amount > 0 and XCEL.tryPayment(user_id,amount) then
    XCEL.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function XCEL.tryFullPayment(user_id,amount)
  local money = XCEL.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return XCEL.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if XCEL.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return XCEL.tryPayment(user_id, amount)
    end
  end

  return false
end

local startingCash = 0
local startingBank = 10000000

AddEventHandler("XCEL:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("XCEL/money_init_user", {user_id = user_id, wallet = startingCash, bank = startingBank, offshore = 0}, function(affected)
    local tmp = XCEL.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("XCEL/get_money", {user_id = user_id}, function(rows, affected)
        if rows and #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
          tmp.offshore = rows[1].offshore
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("XCEL:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = XCEL.getUserTmpTable(user_id)
  if tmp and tmp.wallet and tmp.bank and tmp.offshore then
    MySQL.execute("XCEL/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank, offshore = tmp.offshore})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("XCEL:save", function()
  for k,v in pairs(XCEL.user_tmp_tables) do
    if v.wallet and v.bank then
      MySQL.execute("XCEL/set_money", {user_id = k, wallet = v.wallet, bank = v.bank, offshore = v.offshore})
    end
  end
end)

RegisterNetEvent('XCEL:giveCashToPlayer')
AddEventHandler('XCEL:giveCashToPlayer', function(nplayer)
  local source = source
  local user_id = XCEL.getUserId(source)
  if user_id ~= nil then
    if nplayer ~= nil then
      local nuser_id = XCEL.getUserId(nplayer)
      if nuser_id ~= nil then
        XCEL.prompt(source,lang.money.give.prompt(),"",function(source,amount)
          local amount = parseInt(amount)
          if amount > 0 and XCEL.tryPayment(user_id,amount) then
            XCEL.giveMoney(nuser_id,amount)
            XCELclient.notify(source,{lang.money.given({getMoneyStringFormatted(math.floor(amount))})})
            XCELclient.notify(nplayer,{lang.money.received({getMoneyStringFormatted(math.floor(amount))})})
            XCEL.sendWebhook('give-cash', "XCEL Give Cash Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..XCEL.GetPlayerName(nuser_id).."**\n> Target PermID: **"..nuser_id.."**\n> amount: **£"..getMoneyStringFormatted(amount).."**")
          else
            XCELclient.notify(source,{lang.money.not_enough()})
          end
        end)
      else
        XCELclient.notify(source,{lang.common.no_player_near()})
      end
    else
      XCELclient.notify(source,{lang.common.no_player_near()})
    end
  end
end)


function Comma(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

RegisterServerEvent("XCEL:takeamount")
AddEventHandler("XCEL:takeamount", function(amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.tryFullPayment(user_id,amount) then
      XCELclient.notify(source,{'~g~Paid £'..getMoneyStringFormatted(amount)..'.'})
      return
    end
end)

RegisterServerEvent("XCEL:bankTransfer")
AddEventHandler("XCEL:bankTransfer", function(id, amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    local target_id = tonumber(id)
    local transfer_amount = tonumber(amount)
    if target_id ~= user_id then
      if XCEL.getUserSource(target_id) then
          if XCEL.tryBankPayment(user_id, transfer_amount) then
              XCEL.giveBankMoney(target_id, transfer_amount)
              XCELclient.notify(source, {"You have transferred ~g~£"..getMoneyStringFormatted(transfer_amount).."~w~ to ~g~"..XCEL.GetPlayerName(target_id).."~w~."})
              XCELclient.notify(XCEL.getUserSource(target_id), {"You have received ~g~£"..getMoneyStringFormatted(transfer_amount).."~w~ from ~g~"..XCEL.GetPlayerName(user_id).."~w~."})
              TriggerClientEvent("XCEL:PlaySound", source, "apple")
              TriggerClientEvent("XCEL:PlaySound", XCEL.getUserSource(target_id), "apple")
              XCEL.sendWebhook('bank-transfer', "XCEL Bank Transfer Logs", "> Player Name: **" .. XCEL.GetPlayerName(user_id) .. "**\n> Player PermID: **" .. user_id .. "**\n> Target Name: **" .. XCEL.GetPlayerName(XCEL.getUserSource(target_id)) .. "**\n> Target PermID: **" .. target_id .. "**\n> Amount: **£" .. transfer_amount .. "**")
          else
            XCELclient.notify(source, {"~r~Insufficient funds."})
          end
      else
        XCELclient.notify(source, {"~r~Player is not online."})
      end
    else
      XCELclient.notify(source, {"~r~Unable to transfer to yourself."})
    end
end)


RegisterServerEvent('XCEL:requestPlayerBankBalance')
AddEventHandler('XCEL:requestPlayerBankBalance', function()
    local user_id = XCEL.getUserId(source)
    local bank = XCEL.getBankMoney(user_id)
    local wallet = XCEL.getMoney(user_id)
    local offshore = XCEL.getOffshoreMoney(user_id)
    TriggerClientEvent('XCEL:setDisplayMoney', source, wallet)
    TriggerClientEvent('XCEL:setDisplayBankMoney', source, bank)
    TriggerClientEvent('XCEL:initMoney', source, wallet, bank)
    TriggerClientEvent('XCEL:setDisplayOffshore', source, offshore)
end)

local cache = {}

AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        cache[source] = XCEL.getDiscordAvatar(user_id)
        TriggerClientEvent('XCEL:addProfilePictures',-1,source,cache[source])
        TriggerClientEvent('XCEL:setProfilePictures',source,cache)
        TriggerClientEvent('XCEL:gotProfilePicture',source,cache[source])
    end
end)

function XCEL.getAvatar(id)
    if cache[XCEL.getUserSource(id)] then
        return cache[XCEL.getUserSource(id)]
    end
    return XCEL.getDiscordAvatar(id)
end