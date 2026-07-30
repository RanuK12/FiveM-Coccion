local ESX = nil
local QBCore = nil
local playerData = {}
local currentCooking = false
local cookingProgress = 0
local currentRecipe = nil

-- Initialize framework
Citizen.CreateThread(function()
    if Config.Framework == 'esx' then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    elseif Config.Framework == 'qbcore' then
        while QBCore == nil do
            QBCore = exports['qb-core']:GetCoreObject()
            Citizen.Wait(0)
        end
    end
    
    -- Initialize player data
    updatePlayerData()
end)

-- Update player data
function updatePlayerData()
    local source = PlayerId()
    
    if Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            playerData = {
                level = xPlayer.get('job') and xPlayer.get('job').name == 'chef' and xPlayer.get('job').grade or 1,
                inventory = xPlayer.getInventory()
            }
        end
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            playerData = {
                level = Player.PlayerData.job and Player.PlayerData.job.name == 'chef' and Player.PlayerData.job.grade.level or 1,
                inventory = Player.PlayerData.items
            }
        end
    end
end

-- Show cooking menu
function showCookingMenu()
    local recipes = {}
    
    for recipeName, recipeData in pairs(Config.Cooking.Recipes) do
        if playerData.level >= recipeData.level_required then
            table.insert(recipes, {
                name = recipeData.name,
                recipe = recipeName,
                level_required = recipeData.level_required,
                experience = recipeData.experience,
                ingredients = table.concat(recipeData.ingredients, ', ')
            })
        end
    end
    
    -- Create menu
    local elements = {
        {title = "Close", description = "Close the cooking menu", value = 'close'}
    }
    
    for _, recipe in ipairs(recipes) do
        table.insert(elements, {
            title = recipe.name,
            description = "Level: " .. recipe.level_required .. " | Exp: " .. recipe.experience,
            value = recipe.recipe
        })
    end
    
    -- Show menu
    ESX.UI.Menu.Open('default', 'coccion', 'cooking_menu', {
        title = "Cooking Menu",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'close' then
            menu.close()
        else
            startCooking(data.current.value)
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

-- Start cooking process
function startCooking(recipeName)
    local recipe = Config.Cooking.Recipes[recipeName]
    
    if not recipe then
        TriggerEvent('chatMessage', '[ERROR]', {255, 0, 0}, 'Invalid recipe!')
        return
    end
    
    -- Check if player has all ingredients
    local hasAllIngredients = true
    for _, ingredient in ipairs(recipe.ingredients) do
        if not hasItem(ingredient) then
            hasAllIngredients = false
            break
        end
    end
    
    if not hasAllIngredients then
        TriggerEvent('chatMessage', '[ERROR]', {255, 0, 0}, 'You don\'t have all the required ingredients!')
        return
    end
    
    -- Start cooking
    currentCooking = true
    cookingProgress = 0
    currentRecipe = recipe
    
    -- Remove ingredients
    for _, ingredient in ipairs(recipe.ingredients) do
        removeItem(ingredient, 1)
    end
    
    -- Start cooking thread
    Citizen.CreateThread(function()
        while currentCooking and cookingProgress < 100 do
            Citizen.Wait(Config.Cooking.CookingTime / 100)
            cookingProgress = cookingProgress + 10
            
            if cookingProgress >= 100 then
                -- Cooking completed
                currentCooking = false
                cookingProgress = 0
                
                -- Add cooked item
                addItem(recipeName .. '_cooked', 1)
                
                -- Add experience
                addExperience(recipe.experience)
                
                TriggerEvent('chatMessage', '[SUCCESS]', {0, 255, 0}, 'Cooking completed! You gained ' .. recipe.experience .. ' experience.')
            end
        end
    end)
end

-- Check if player has item
function hasItem(itemName)
    if Config.Framework == 'esx' then
        for _, item in ipairs(playerData.inventory) do
            if item.name == itemName then
                return item.count > 0
            end
        end
    elseif Config.Framework == 'qbcore' then
        for _, item in ipairs(playerData.inventory) do
            if item.name == itemName then
                return item.amount > 0
            end
        end
    end
    return false
end

-- Remove item from player inventory
function removeItem(itemName, amount)
    if Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(PlayerId())
        xPlayer.removeInventoryItem(itemName, amount)
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(PlayerId())
        Player.Functions.RemoveItem(itemName, amount)
    end
    updatePlayerData()
end

-- Add item to player inventory
function addItem(itemName, amount)
    if Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(PlayerId())
        xPlayer.addInventoryItem(itemName, amount)
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(PlayerId())
        Player.Functions.AddItem(itemName, amount)
    end
    updatePlayerData()
end

-- Add experience to player
function addExperience(amount)
    playerData.level = playerData.level + amount
    TriggerEvent('chatMessage', '[INFO]', {255, 255, 0}, 'You gained ' .. amount .. ' experience! Your current level is: ' .. playerData.level)
end

-- Key binding to open cooking menu
RegisterCommand('cookingmenu', function()
    showCookingMenu()
end)

-- Register exports
exports('GetPlayerData', function()
    return playerData
end)

exports('GetCookingConfig', function()
    return Config
end)