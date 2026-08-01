-- Discord webhook logger for FiveM-Coccion
-- Centralized function to send logs for cooking, level ups, and cheat attempts

function sendDiscordLog(eventType, source, data)
    if not Config.Discord.Enabled or not Config.Discord.WebhookURL or Config.Discord.WebhookURL == '' then
        return
    end

    local playerName = GetPlayerName(source) or 'Unknown'
    local identifier = GetPlayerIdentifier(source) or 'unknown-id'
    local embed = {}
    local color = Config.Discord.LogColor or 0x00d4ff

    if eventType == 'cook' then
        if not Config.Discord.LogCooking then return end
        embed = {
            {
                ['title'] = '\ud83c\udf5d Cooking Attempt',
                ['description'] = string.format('**Player:** %s (%s)\n**Recipe:** %s', playerName, identifier, data.recipe),
                ['color'] = color,
                ['footer'] = { ['text'] = os.date('%Y-%m-%d %H:%M:%S') }
            }
        }
    elseif eventType == 'levelup' then
        if not Config.Discord.LogLevelUp then return end
        embed = {
            {
                ['title'] = '\ud83c\udfc6 Level Up',
                ['description'] = string.format('**Player:** %s (%s)\n**New Level:** %d', playerName, identifier, data.newLevel),
                ['color'] = Config.Discord.LevelUpColor or 0xffd700,
                ['footer'] = { ['text'] = os.date('%Y-%m-%d %H:%M:%S') }
            }
        }
    elseif eventType == 'cheat' then
        if not Config.Discord.LogCheatAttempts then return end
        embed = {
            {
                ['title'] = '\ud83d\udea8 Cheat Attempt',
                ['description'] = string.format('**Player:** %s (%s)\n**Type:** %s\n**Details:** %s', playerName, identifier, data.type, data.details),
                ['color'] = Config.Discord.CheatColor or 0xff0000,
                ['footer'] = { ['text'] = os.date('%Y-%m-%d %H:%M:%S') }
            }
        }
    end

    PerformHttpRequest(Config.Discord.WebhookURL, function(err, text, headers) end, 'POST',
        json.encode({ embeds = embed, username = 'Coccion Logger' }),
        { ['Content-Type'] = 'application/json' })
end

-- Hook into existing events
AddEventHandler('coccion:addExperience', function(amount)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    -- Assuming player data is stored in playerCookingData (server/main.lua)
    local playerData = playerCookingData[identifier]
    if playerData then
        local newLevel = playerData.level
        sendDiscordLog('levelup', source, { newLevel = newLevel })
    end
end)

-- Listen to approved cooking event from anticheat
AddEventHandler('coccion:cookApproved', function(source, recipeName)
    sendDiscordLog('cook', source, { recipe = recipeName })
    -- Forward to original cooking handler (if any) – keep original behavior
    TriggerEvent('coccion:startCooking', source, recipeName)
end)
