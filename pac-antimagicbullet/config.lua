Config = {}

-- [[----------------------Log System---------------------------]]
Config.Tolerance = 3 -- If the player kills more than the number of times you set and does not see it, they will be banned from the server

-- [[----------------------Log System---------------------------]]
Config.SendWebhook = true
Config.WebhookURL = "https://discord.com/api/webhooks/1278141327049101414/MqG52NF57dqawkrKEHxv8kNdXAQso5nlH6gU0heVm81Ro9_Wak3TnAB8n424zBBtV7Fq"

-- [[----------------------Punishment---------------------------]]
Config.Ban = false -- If this setting is true, you can use your own ban system.
Config.DropMessage = "Magic bullet Or Ghost Peek Detected." -- If you set ban setting to false you can select your own drop message.
Config.BanFunction = function(source)
    -- You can trigger your ban event.
end