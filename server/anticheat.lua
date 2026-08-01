-- FiveM-Coccion Anti-Cheat System
-- Protects against: spamming, distance exploits, ingredient faking, rapid leveling

local lastCookTime = {}      -- track last cook timestamp per player
local cookAttemptLog = {}    -- track consecutive rapid attempts
local MAX_RAPID_ATTEMPTS = 5 -- before flagging

-- Server-side ingredient validation
-- Overrides the client's claim that they have ingredients
RegisterNetEvent('coccion:requestCook')
AddEventHandler('coccion:requestCook', function(recipeName)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)

    -- === COOLDOWN CHECK ===
    if Config.AntiCheat.Enabled then
        local now = GetGameTimer()
        if lastCookTime[identifier] and (now - lastCookTime[identifier]) < Config.AntiCheat.CooldownBetweenCooks then
            cookAttemptLog[identifier] = (cookAttemptLog[identifier] or 0) + 1

            -- Log cheat attempt
            if Config.Discord.Enabled and Config.Discord.LogCheatAttempts and cookAttemptLog[identifier] >= MAX_RAPID_ATTEMPTS then
                sendDiscordCheatLog(source, identifier, 'RAPID_COOK_SPAM',
                    string.format('Player spamming cook requests (%d rapid attempts). Cooldown bypass detected.',
                        cookAttemptLog[identifier]))
            end

            TriggerClientEvent('coccion:cookRejected', source, 'cooldown')
            return
        end
        lastCookTime[identifier] = now

        -- === DISTANCE CHECK ===
        local nearKitchen = false
        for _, loc in ipairs(Config.Visuals.Locations) do
            local dist = #(coords - loc.coords)
            if dist <= Config.AntiCheat.MaxCookingDistance then
                nearKitchen = true
                break
            end
        end

        if not nearKitchen then
            -- Player trying to cook from too far away — possible teleport/exploit
            if Config.Discord.Enabled and Config.Discord.LogCheatAttempts then
                sendDiscordCheatLog(source, identifier, 'DISTANCE_EXPLOIT',
                    string.format('Player attempted to cook recipe "%s" while not near any kitchen. Coords: %.1f, %.1f, %.1f',
                        recipeName, coords.x, coords.y, coords.z))
            end
            TriggerClientEvent('coccion:cookRejected', source, 'distance')
            return
        end

        -- === INGREDIENT VERIFICATION ===
        if Config.AntiCheat.VerifyIngredients then
            local recipe = Config.Cooking.Recipes[recipeName]
            if recipe and recipe.ingredients then
                local hasAll, missing = verifyIngredientsServer(source, recipe.ingredients)
                if not hasAll then
                    if Config.Discord.Enabled and Config.Discord.LogCheatAttempts then
                        sendDiscordCheatLog(source, identifier, 'FAKE_INGREDIENTS',
                            string.format('Player attempted to cook "%s" without ingredients. Missing: %s',
                                recipeName, table.concat(missing, ', ')))
                    end
                    TriggerClientEvent('coccion:cookRejected', source, 'ingredients')
                    return
                end
            end
        end
    end

    -- Passed all checks — allow cooking and forward to main server handler
    lastCookTime[identifier] = GetGameTimer()
    cookAttemptLog[identifier] = 0 -- reset spam counter on success

    -- Forward to existing cook logic if implemented, or trigger success
    TriggerEvent('coccion:cookApproved', source, recipeName)
end)

-- Verify ingredients server-side by checking player inventory
function verifyIngredientsServer(source, ingredients)
    local xPlayer = nil
    local missing = {}

    if Config.Framework == 'esx' then
        local ESX = exports[Config.ESX.CoreExport]:getSharedObject()
        xPlayer = ESX.GetPlayerFromId(source)
    elseif Config.Framework == 'qbcore' then
        local QBCore = exports[Config.QBCore.CoreExport]:GetCoreObject()
        xPlayer = QBCore.Functions.GetPlayer(source)
    end

    if not xPlayer then
        return false, { 'player_not_found' }
    end

    local inventory = xPlayer.getInventory and xPlayer.getInventory() or xPlayer.PlayerData.items

    for _, ingredient in ipairs(ingredients) do
        local found = false
        for _, item in ipairs(inventory) do
            if item.name == ingredient and (item.count or item.amount or 0) > 0 then
                found = true
                break
            end
        end
        if not found then
            table.insert(missing, ingredient)
        end
    end

    return #missing == 0, missing
end

-- Send cheat log to Discord
function sendDiscordCheatLog(source, identifier, cheatType, details)
    if not Config.Discord.WebhookURL or Config.Discord.WebhookURL == '' then
        return
    end

    local playerName = GetPlayerName(source) or 'Unknown'
    local embed = {
        {
            ['title'] = '🚨 Anti-Cheat Alert',
            ['description'] = '**Type:** ' .. cheatType .. '\n**Player:** ' .. playerName .. '\n**ID:** ' .. identifier .. '\n**Details:** ' .. details,
            ['color'] = Config.Discord.CheatColor or 0xff0000,
            ['footer'] = {
                ['text'] = 'FiveM-Coccion Anti-Cheat | ' .. os.date('%Y-%m-%d %H:%M:%S')
            }
        }
    }

    PerformHttpRequest(Config.Discord.WebhookURL, function(err, text, headers) end, 'POST',
        json.encode({ embeds = embed, username = 'Coccion Anti-Cheat' }),
        { ['Content-Type'] = 'application/json' })
end
