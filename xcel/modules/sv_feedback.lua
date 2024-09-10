RegisterServerEvent("XCEL:adminTicketFeedback")
AddEventHandler("XCEL:adminTicketFeedback", function(AdminID, FeedBackType, Message)
    local AdminID = XCEL.getUserId(AdminID)
    local AdminSource = XCEL.getSourceFromUserId(AdminID)
    local AdminName = XCEL.GetPlayerName(AdminID)

    local FeedBackType = FeedBackType
    local PlayerID = XCEL.getUserId(source) -- source now refers to the player
    local PlayerName = XCEL.GetPlayerName(PlayerID) -- source now refers to the player

    -- Check and replace nil values with "N/A" for local variables
    local AdminID = AdminID or "N/A"
    local AdminName = AdminName or "N/A"
    local PlayerName = PlayerName or "N/A"
    local PlayerID = PlayerID or "N/A"
    local FeedBackType = FeedBackType or "N/A"

    if Message == "" then
        Message = "No Feedback Provided."
    end

    local feedbackInfo = "> Player Name: **" .. PlayerName .. "**\n" ..
                         "> Player PermID: **" .. PlayerID .. "**\n" ..
                         "> Feedback Type: **" .. FeedBackType .. "**\n" ..
                         "> Admin Perm ID**: " .. AdminID .. "**\n" ..
                         "> Admin Name**: " .. AdminName .. "**\n" ..
                         "> Message: **" .. Message .. "**\n"

    XCEL.sendWebhook('feedback', 'XCEL Feedback Logs', feedbackInfo)

    if FeedBackType == "good" then
        XCEL.giveBankMoney(AdminID, 25000)
        XCELclient.notify(AdminSource, {"~g~You have received £25000 for a good feedback."})
        XCELclient.notify(source, {"~g~You have given a Good feedback."})
    elseif FeedBackType == "neutral" then
        XCEL.giveBankMoney(AdminID, 10000)
        XCELclient.notify(AdminSource, {"~g~You have received £10000 for a neutral feedback."})
        XCELclient.notify(source, {"~y~You have given a Neutral feedback."})
    elseif FeedBackType == "bad" then
        XCEL.giveBankMoney(AdminID, 5000)
        XCELclient.notify(AdminSource, {"~g~You have received £5000 for a bad feedback."})
        XCELclient.notify(source, {"~r~You have given a Bad feedback."})
    end
end)



RegisterServerEvent("XCEL:adminTicketNoFeedback")
AddEventHandler("XCEL:adminTicketNoFeedback", function(PlayerSource, AdminPermID)
    if PlayerSource == nil then
        return
    end
    local AdminID = XCEL.getUserId(source) -- 'source' here is the admin who receives the feedback
    local AdminName = XCEL.GetPlayerName(AdminID)
    local AdminPermID = XCEL.getUserId(AdminID)
    local PlayerID = XCEL.getUserId(PlayerSource)
    local PlayerName = XCEL.GetPlayerName(PlayerID)
    if FeedBackType == "good" then
        XCEL.giveBankMoney(AdminPermID, 25000)
        XCELclient.notify(AdminID, {"~g~You have received £25000 for a good feedback."})
        XCELclient.notify(source, {"~g~You have given a Good feedback."})
    elseif FeedBackType == "neutral" then
        XCEL.giveBankMoney(AdminPermID, 10000)
        XCELclient.notify(AdminID, {"~g~You have received £10000 for a good feedback."})
        XCELclient.notify(source, {"~y~You have given a Neutral feedback."})
    elseif FeedBackType == "bad" then
        XCEL.giveBankMoney(AdminPermID, 5000)
        XCELclient.notify(AdminID, {"~g~You have received £5000 for a good feedback."})
        XCELclient.notify(source, {"~r~You have given a Bad feedback."})
    end
    XCEL.sendWebhook('feedback', 'XCEL Feedback Logs', "> Player Name: **"..XCEL.GetPlayerName(AdminID).."**\n> Player PermID: **"..user_id.."**\n> **Feedback Type**"..FeedbackType.."\n> **Admin Perm ID: **"..AdminPermID)
end)