-- Shared functions for both client and server

-- Get localized text
function _U(key, ...)
    local locale = Config.Framework == 'esx' and 'en' or 'es'
    local translations = {}
    
    -- Load translations based on framework
    if Config.Framework == 'esx' then
        translations = json.decode(LoadResourceFile('coccion', 'locales/en.json'))
    else
        translations = json.decode(LoadResourceFile('coccion', 'locales/es.json'))
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
    
    return true
end

-- Format recipe for display
function formatRecipeForDisplay(recipe)
    if not isValidRecipe(recipe) then
        return nil
    end
    
    return {
        name = recipe.name,
        ingredients = table.concat(recipe.ingredients, ', '),
        level_required = recipe.level_required,
        experience = recipe.experience
    }
end