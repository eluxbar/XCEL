MySQL.createCommand("quests/add_id", "INSERT IGNORE INTO xcel_quests SET user_id = @user_id")

AddEventHandler("playerJoining", function()
    local user_id = XCEL.getUserId(source)
    MySQL.execute("quests/add_id", {user_id = user_id})
end)

RegisterServerEvent("XCEL:setQuestCompleted")
AddEventHandler("XCEL:setQuestCompleted", function()
	local source = source
	local user_id = XCEL.getUserId(source)
    local a = exports['xcel']:executeSync("SELECT * FROM xcel_quests WHERE user_id = @user_id", {user_id = user_id})
    for k,v in pairs(a) do
        if v.user_id == user_id then
            if v.quests_completed < 51 and not v.reward_claimed then
                exports['xcel']:execute("UPDATE xcel_quests SET quests_completed = (quests_completed+1) WHERE user_id = @user_id", {user_id = user_id}, function() end)
            else
                XCEL.ACBan(15,user_id,'XCEL:setQuestCompleted')
            end
        end
    end
end)

RegisterServerEvent("XCEL:claimQuestReward")
AddEventHandler("XCEL:claimQuestReward", function()
	local source = source
	local user_id = XCEL.getUserId(source)
    local a = exports['xcel']:executeSync("SELECT * FROM xcel_quests WHERE user_id = @user_id", {user_id = user_id})
    local plathours = 0
    for k,v in pairs(a) do
        if v.user_id == user_id then
            if not v.reward_claimed and v.quests_completed == 50 then
                -- code to give plat days
                MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
                    plathours = rows[1].plathours
                    MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = plathours + 168*2})
                    exports['xcel']:execute("UPDATE xcel_quests SET reward_claimed = true WHERE user_id = @user_id", {user_id = user_id}, function() end)
                end)
            else
                XCEL.ACBan(15,user_id,'XCEL:claimQuestReward')
            end
        end
    end
end)
