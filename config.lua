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
    Progress bar settings
    ProgressBar = {
        Enabled = true,
        Type = 'ox_lib', -- Options: 'ox_lib', 'esx', 'qbcore'
        Position = 'middle', -- Options: 'middle', 'bottom'
        Color = '#00d4ff', -- Hex color
        Width = 300,
        Height = 20
    },
    Recipes = {
        -- Basic recipes
        ['pasta'] = {
            name = 'Pasta',
            ingredients = { 'pasta', 'tomato_sauce' },
            level_required = 1,
            experience = 15,
            cooking_time = 5000,
            job_required = false,
            job_name = nil,
            job_grade = nil
        },
        ['burger'] = {
            name = 'Burger',
            ingredients = { 'bread', 'meat', 'lettuce', 'tomato' },
            level_required = 5,
            experience = 25,
            cooking_time = 7000,
            job_required = false,
            job_name = nil,
            job_grade = nil
        },
        ['pizza'] = {
            name = 'Pizza',
            ingredients = { 'dough', 'tomato_sauce', 'cheese', 'pepperoni' },
            level_required = 10,
            experience = 40,
            cooking_time = 10000,
            job_required = true,
            job_name = 'chef',
            job_grade = 1
        },
        ['steak'] = {
            name = 'Steak',
            ingredients = { 'meat', 'salt', 'pepper', 'butter' },
            level_required = 15,
            experience = 50,
            cooking_time = 12000,
            job_required = true,
            job_name = 'chef',
            job_grade = 2
        },
        ['soup'] = {
            name = 'Soup',
            ingredients = { 'vegetables', 'water', 'salt', 'herbs' },
            level_required = 3,
            experience = 20,
            cooking_time = 6000,
            job_required = false,
            job_name = nil,
            job_grade = nil
        },
        ['salad'] = {
            name = 'Salad',
            ingredients = { 'lettuce', 'tomato', 'cucumber', 'olive_oil' },
            level_required = 2,
            experience = 18,
            cooking_time = 4000,
            job_required = false,
            job_name = nil,
            job_grade = nil
        },
        ['cake'] = {
            name = 'Cake',
            ingredients = { 'flour', 'sugar', 'eggs', 'butter', 'vanilla' },
            level_required = 20,
            experience = 75,
            cooking_time = 15000,
            job_required = true,
            job_name = 'chef',
            job_grade = 3
        }
    }
}