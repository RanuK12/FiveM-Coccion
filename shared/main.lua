-- Shared functions for both client and server

-- Get localized text
function _U(key, ...)
    -- Determine locale based on framework
    local locale = Config.Framework == 'esx' and 'en' or 'es'
    
    -- Load translations
    local translations = {}
    local success, result = pcall(function()
        return json.decode(LoadResourceFile('coccion', 'locales/' .. locale .. '.json'))
    end)
    
    if success and result then
        translations = result
    end
    
    -- Try fallback to English if translation not found in current locale
    if not translations[key] and locale ~= 'en' then
        success, result = pcall(function()
            return json.decode(LoadResourceFile('coccion', 'locales/en.json'))
        end)
        
        if success and result then
            translations = result
        end
    end
    
    if translations and translations[key] then
        local text = translations[key]
        -- Replace placeholders if provided
        if ... then
            for i, value in ipairs({...}) do
                text = text:gsub('{' .. i .. '}', value)
            end
        end
        return text
    end
    
    return key -- Return key if translation not found
end

-- Get recipe by name
function getRecipe(recipeName)
    return Config.Cooking.Recipes[recipeName]
end

-- Get all recipes
function getAllRecipes()
    return Config.Cooking.Recipes
end

-- Get recipes for player level
function getRecipesForLevel(playerLevel)
    local recipes = {}
    
    for recipeName, recipeData in pairs(Config.Cooking.Recipes) do
        if playerLevel >= recipeData.level_required and not (recipeData.job_required and not hasRequiredJob(recipeData.job_name, recipeData.job_grade)) then
            table.insert(recipes, recipeData)
        end
    end
    
    return recipes
end

-- Calculate cooking skill multiplier
function getCookingSkillMultiplier(playerLevel)
    return 1 + (playerLevel * 0.05) -- 5% increase per level
end

-- Get player's progress to next level
function getProgressToNextLevel(currentLevel, currentExperience)
    local expNeeded = currentLevel * 100
    local expSinceLastLevel = currentExperience - ((currentLevel - 1) * 100)
    return (expSinceLastLevel / expNeeded) * 100
end

-- Format experience display
function formatExperience(currentLevel, currentExperience)
    local expNeeded = currentLevel * 100
    local expSinceLastLevel = currentExperience - ((currentLevel - 1) * 100)
    
    return string.format(
        "Level %d (%d/%d exp - %.1f%% to next)", 
        currentLevel, 
        expSinceLastLevel, 
        expNeeded, 
        (expSinceLastLevel / expNeeded) * 100
    )
end

-- Check if player has required level
function hasRequiredLevel(playerLevel, requiredLevel)
    return playerLevel >= requiredLevel
end

-- Calculate experience needed for next level
function getExperienceNeededForNextLevel(currentLevel)
    return currentLevel * 100
end

-- Check if player can level up
function canLevelUp(currentLevel, currentExperience)
    return currentExperience >= getExperienceNeededForNextLevel(currentLevel)
end

-- Get player's cooking level
function getCookingLevel(playerData)
    return playerData.level or 1
end

-- Get player's cooking experience
function getCookingExperience(playerData)
    return playerData.experience or 0
end

-- Validate recipe data
function isValidRecipe(recipe)
    if not recipe or type(recipe) ~= 'table' then
        return false
    end
    
    if not recipe.name or type(recipe.name) ~= 'string' or recipe.name == '' then
        return false
    end
    
    if not recipe.ingredients or type(recipe.ingredients) ~= 'table' or #recipe.ingredients == 0 then
        return false
    end
    
    if not recipe.level_required or type(recipe.level_required) ~= 'number' or recipe.level_required < 1 then
        return false
    end
    
    if not recipe.experience or type(recipe.experience) ~= 'number' or recipe.experience < 1 then
        return false
    end
    
    -- Validate cooking time
    if recipe.cooking_time and (type(recipe.cooking_time) ~= 'number' or recipe.cooking_time < 1000) then
        return false
    end
    
    -- Validate job requirements if specified
    if recipe.job_required then
        if not recipe.job_name or type(recipe.job_name) ~= 'string' or recipe.job_name == '' then
            return false
        end
        
        if recipe.job_grade and type(recipe.job_grade) ~= 'number' then
            return false
        end
    end
    
    return true
end

-- Format recipe for display
function formatRecipeForDisplay(recipe)
    if not isValidRecipe(recipe) then
        return nil
    end
    
    local display = {
        name = recipe.name,
        ingredients = table.concat(recipe.ingredients, ', '),
        level_required = recipe.level_required,
        experience = recipe.experience,
        cooking_time = recipe.cooking_time or 5000
    }
    
    -- Add job info if applicable
    if recipe.job_required then
        display.job_required = true
        display.job_name = recipe.job_name
        display.job_grade = recipe.job_grade or 1
    else
        display.job_required = false
    end
    
    return display
end

-- Check if player can cook a recipe
function canCookRecipe(recipe, playerLevel, playerJob)
    if not isValidRecipe(recipe) then
        return false, "Invalid recipe"
    end
    
    if playerLevel < recipe.level_required then
        return false, "Not high enough level"
    end
    
    if recipe.job_required then
        if not playerJob or playerJob.name ~= recipe.job_name then
            return false, "Not the right job"
        end
        
        if recipe.job_grade and playerJob.grade < recipe.job_grade then
            return false, "Not high enough job grade"
        end
    end
    
    return true, "Can cook"
end

-- Get cooking statistics
function getCookingStats(playerData)
    if not playerData or type(playerData) ~= 'table' then
        return nil
    end
    
    local stats = {
        level = playerData.level or 1,
        experience = playerData.experience or 0,
        experience_needed_for_next_level = (playerData.level or 1) * 100,
        experience_since_last_level = (playerData.experience or 0) - ((playerData.level or 1 - 1) * 100),
        progress_to_next_level = 0
    }
    
    stats.progress_to_next_level = (stats.experience_since_last_level / stats.experience_needed_for_next_level) * 100
    
    return stats
end

-- Sound effects management
function playCookingSound(soundName)
    if not soundName or soundName == '' then
        return
    end
    
    -- Play sound based on framework
    if Config.Framework == 'esx' then
        TriggerEvent('interact:sound', soundName)
    elseif Config.Framework == 'qbcore' then
        TriggerServerEvent('qb-soundserver:PlayOnSource', soundName)
    else
        -- Fallback to FiveM native play sound
        PlaySoundFrontend(-1, soundName, 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
    end
end

-- Notification system
function showNotification(message, type)
    if not message or message == '' then
        return
    end
    
    type = type or 'info'
    
    if Config.Framework == 'esx' then
        ESX.ShowNotification(message)
    elseif Config.Framework == 'qbcore' then
        QBCore.Functions.Notify(message, type)
    else
        -- Fallback to chat message
        TriggerEvent('chatMessage', '[Coccion]', {255, 255, 255}, message)
    end
end