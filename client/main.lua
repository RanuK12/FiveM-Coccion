local ESX = nil
local QBCore = nil
local playerData = {}
local currentCooking = false
local cookingProgress = 0
local currentRecipe = nil
local cookingThread = nil
local progressBar = nil

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
    
    -- Check if ox_lib is available for progress bar
    if Config.Cooking.ProgressBar.Enabled and Config.Cooking.ProgressBar.Type == 'ox_lib' then
        local success, result = pcall(function()
            return exports.ox_lib
        end)
        if not success then
            print('[Coccion] ox_lib not found, falling back to framework progress bar')
            Config.Cooking.ProgressBar.Type = Config.Framework
        end
    end
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
    -- Get all recipes from server
    TriggerServerEvent('coccion:getAllRecipes')
    
    -- Create menu elements
    local elements = {
        {title = _U('menu.close'), description = _U('menu.close_desc'), value = 'close'}
    }
    
    -- Add recipes based on player's level and job
    for recipeName, recipeData in pairs(Config.Cooking.Recipes) do
        local canCook, reason = canCookRecipe(recipeData, playerData.level, playerData.job)
        
        if canCook then
            local description = _U('cooking.level_required') .. ": " .. recipeData.level_required .. 
                              " | " .. _U('cooking.experience') .. ": " .. recipeData.experience .. 
                              " | " .. _U('cooking.time') .. ": " .. (recipeData.cooking_time / 1000) .. "s"
            
            table.insert(elements, {
                title = recipeData.name,
                description = description,
                value = recipe.recipe
            })
        else
            -- Add recipe with disabled state if player can't cook it
            local description = _U('cooking.cannot_cook') .. ": " .. reason
            
            table.insert(elements, {
                title = recipeData.name,
                description = description,
                value = recipe.recipe .. '_disabled'
            })
        end
    end
    
    -- Show menu based on framework
    if Config.Framework == 'esx' then
        ESX.UI.Menu.Open('default', 'coccion', 'cooking_menu', {
            title = _U('cooking.title'),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value == 'close' then
                menu.close()
            elseif data.current.value:sub(-9) == '_disabled' then
                TriggerEvent('chatMessage', '[INFO]', {255, 255, 0}, _U('cooking.cannot_cook'))
            else
                startCooking(data.current.value)
                menu.close()
            end
        end, function(data, menu)
            menu.close()
        end)
    elseif Config.Framework == 'qbcore' then
        local options = {
            {
                header = _U('cooking.title'),
                isMenuHeader = true
            }
        }
        
        for _, element in ipairs(elements) do
            local isDisabled = element.value:sub(-9) == '_disabled'
            table.insert(options, {
                title = element.title,
                description = element.description,
                disabled = isDisabled,
                onSelect = function()
                    if not isDisabled then
                        startCooking(element.value)
                        closeContext()
                    end
                end
            })
        end
        
        exports['qb-menu']:openMenu(options)
    else
        -- Fallback for other frameworks
        local title = _U('cooking.title')
        local message = "Available recipes:\n\n"
        
        for _, element in ipairs(elements) do
            if element.value ~= 'close' then
                local isDisabled = element.value:sub(-9) == '_disabled'
                local status = isDisabled and " (Cannot cook)" or ""
                message = message .. element.title .. status .. "\n"
            end
        end
        
        TriggerEvent('chatMessage', '[COOKING]', {255, 255, 255}, message)
    end
end

-- Show player cooking data
function showPlayerCookingData()
    local stats = getCookingStats(playerData)
    
    if stats then
        local message = string.format(
            _U('cooking.current_level') .. ": %d\n" ..
            _U('cooking.experience') .. ": %d/%d (%.1f%%)\n" ..
            _U('cooking.next_level') .. ": " .. _U('cooking.experience_needed'),
            stats.level,
            stats.experience_since_last_level,
            stats.experience_needed_for_next_level,
            stats.progress_to_next_level
        )
        
        if Config.Framework == 'esx' then
            ESX.ShowNotification(message)
        elseif Config.Framework == 'qbcore' then
            QBCore.Functions.Notify(message, 'primary')
        else
            TriggerEvent('chatMessage', '[COOKING]', {255, 255, 255}, message)
        end
    end
end

-- Start cooking process
function startCooking(recipeName)
    local recipe = Config.Cooking.Recipes[recipeName]
    
    if not recipe then
        TriggerEvent('chatMessage', '[ERROR]', {255, 0, 0}, 'Invalid recipe!')
        return
    end
    
    -- Check job requirement if specified
    if recipe.job_required then
        if not hasRequiredJob(recipe.job_name, recipe.job_grade) then
            TriggerEvent('chatMessage', '[ERROR]', {255, 0, 0}, 'You need to be a ' .. recipe.job_name .. ' to cook this!')
            return
        end
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
    
    -- Check if player has required level
    if playerData.level < recipe.level_required then
        TriggerEvent('chatMessage', '[ERROR]', {255, 0, 0}, 'You need to be level ' .. recipe.level_required .. ' to cook this!')
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
    
    -- Show progress bar if enabled
    if Config.Cooking.ProgressBar.Enabled then
        showProgressBar(recipe)
    end
    
    -- Start cooking thread
    cookingThread = Citizen.CreateThread(function()
        local incrementTime = recipe.cooking_time / 100 -- 100 steps for progress
        
        while currentCooking and cookingProgress < 100 do
            Citizen.Wait(incrementTime)
            cookingProgress = cookingProgress + 1
            
            -- Update progress bar if using ox_lib
            if Config.Cooking.ProgressBar.Type == 'ox_lib' and progressBar then
                exports.ox_lib:progression(progressBar, math.floor(cookingProgress))
            end
            
            if cookingProgress >= 100 then
                -- Cooking completed
                currentCooking = false
                cookingProgress = 0
                
                -- Hide progress bar
                if Config.Cooking.ProgressBar.Enabled then
                    hideProgressBar()
                end
                
                -- Add cooked item
                local cookedItemName = recipeName .. '_cooked'
                addItem(cookedItemName, 1)
                
                -- Add experience
                addExperience(recipe.experience)
                
                TriggerEvent('chatMessage', '[SUCCESS]', {0, 255, 0}, 'Cooking completed! You gained ' .. recipe.experience .. ' experience.')
                
                -- Trigger server event to save data
                TriggerServerEvent('coccion:savePlayerData', recipe.experience)
            end
        end
        
        -- Clean up if cooking was interrupted
        if currentCooking then
            currentCooking = false
            cookingProgress = 0
            if Config.Cooking.ProgressBar.Enabled then
                hideProgressBar()
            end
        end
    end)
end

-- Show progress bar
function showProgressBar(recipe)
    if Config.Cooking.ProgressBar.Type == 'ox_lib' then
        -- Create ox_lib progress bar
        progressBar = exports.ox_lib:progressBar({
            duration = recipe.cooking_time,
            label = 'Cooking ' .. recipe.name,
            position = Config.Cooking.ProgressBar.Position,
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                mouse = false,
                combat = true
            },
            anim = {
                dict = 'mp_player_inteatburger',
                clip = 'mp_player_int_eat_burger'
            },
            prop = {
                model = `prop_cs_plate_01`,
                pos = vec3(0.020000, 0.020000, -0.020000),
                rot = vec3(0.000000, 0.000000, 0.000000)
            }
        })
        
        -- Listen for cancel event
        if progressBar then
            RegisterNUICallback('ox_lib:progress:cancel', function()
                if currentCooking then
                    currentCooking = false
                    cookingProgress = 0
                    hideProgressBar()
                    TriggerEvent('chatMessage', '[INFO]', {255, 255, 0}, 'Cooking cancelled.')
                end
            end)
        end
    else
        -- Use framework-specific progress bar
        if Config.Framework == 'esx' then
            ESX.ShowProgressBar(recipe.cooking_time / 1000, 'Cooking ' .. recipe.name)
        elseif Config.Framework == 'qbcore' then
            QBCore.Functions.Progressbar('cooking', 'Cooking ' .. recipe.name, recipe.cooking_time, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                if currentCooking then
                    currentCooking = false
                    cookingProgress = 0
                end
            end, function() -- Cancel
                if currentCooking then
                    currentCooking = false
                    cookingProgress = 0
                    TriggerEvent('chatMessage', '[INFO]', {255, 255, 0}, 'Cooking cancelled.')
                end
            end)
        end
    end
end

-- Hide progress bar
function hideProgressBar()
    if Config.Cooking.ProgressBar.Type == 'ox_lib' and progressBar then
        exports.ox_lib:progressBarCancel(progressBar)
        progressBar = nil
    elseif Config.Framework == 'esx' then
        ESX.HideProgressBar()
    elseif Config.Framework == 'qbcore' then
        QBCore.Functions.CancelProgress()
    end
end

-- Check if player has required job
function hasRequiredJob(jobName, jobGrade)
    if not jobName then
        return true -- No job requirement
    end
    
    if Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(PlayerId())
        if xPlayer then
            local job = xPlayer.get('job')
            if job and job.name == jobName and (not jobGrade or job.grade >= jobGrade) then
                return true
            end
        end
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(PlayerId())
        if Player then
            local job = Player.PlayerData.job
            if job and job.name == jobName and (not jobGrade or job.grade.level >= jobGrade) then
                return true
            end
        end
    end
    
    return false
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
    if not currentCooking then
        showCookingMenu()
    else
        TriggerEvent('chatMessage', '[INFO]', {255, 255, 0}, 'You are currently cooking!')
    end
end)

-- Register key mapping
if Config.Framework == 'esx' then
    ESX.RegisterCommand('cooking', 'user', function()
        if not currentCooking then
            showCookingMenu()
        else
            TriggerEvent('chatMessage', '[INFO]', {255, 255, 0}, 'You are currently cooking!')
        end
    end, true)
elseif Config.Framework == 'qbcore' then
    QBCore.Commands.Add('cooking', 'Open cooking menu', {}, false, 'user', function()
        if not currentCooking then
            showCookingMenu()
        else
            TriggerEvent('chatMessage', '[INFO]', {255, 255, 0}, 'You are currently cooking!')
        end
    end)
end

-- Register server event for saving data
RegisterNetEvent('coccion:savePlayerData')
AddEventHandler('coccion:savePlayerData', function(experience)
    TriggerServerEvent('coccion:addExperience', experience)
end)

-- Register exports
exports('GetPlayerData', function()
    return playerData
end)

exports('GetCookingConfig', function()
    return Config
end)

exports('IsCurrentlyCooking', function()
    return currentCooking
end)

exports('GetCurrentRecipe', function()
    return currentRecipe
end)

-- Register exports
exports('GetPlayerData', function()
    return playerData
end)

exports('GetCookingConfig', function()
    return Config
end)