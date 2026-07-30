Config = {}

Config.Framework = 'esx' -- Options: 'esx', 'qbcore'
Config.Debug = false

-- Framework specific settings
Config.ESX = {
    CoreExport = 'es_extended',
    GetPlayer = function(source)
        local ESX = exports[Config.ESX.CoreExport]:getSharedObject()
        return ESX.GetPlayerFromId(source)
    end
}

Config.QBCore = {
    CoreExport = 'qb-core',
    GetPlayer = function(source)
        local QBCore = exports[Config.QBCore.CoreExport]:GetCoreObject()
        return QBCore.Functions.GetPlayer(source)
    end
}

-- Cooking settings
Config.Cooking = {
    MinLevel = 1,
    ExperiencePerCook = 10,
    MaxLevel = 100,
    CookingTime = 5000, -- ms
    Recipes = {
        -- Add recipes here
        ['pasta'] = {
            name = 'Pasta',
            ingredients = { 'pasta', 'tomato_sauce' },
            level_required = 1,
            experience = 15
        },
        ['burger'] = {
            name = 'Burger',
            ingredients = { 'bread', 'meat', 'lettuce', 'tomato' },
            level_required = 5,
            experience = 25
        }
    }
}