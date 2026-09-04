Config = {}

-- Framework selection: 'esx' or 'qbcore'
Config.Framework = 'esx'

-- Language / Locale for the resource (e.g., 'en', 'es', 'it')
Config.Locale = 'es'

-- Enable debug mode (prints extra logs)
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

-- Economy settings
Config.Economy = {
    Currency = '$', -- Currency symbol
    Tax = 0.1,      -- Tax rate (10%)
}

-- Permissions settings
Config.Permissions = {
    -- ACE permission for the cooking command
    Command = 'command.coccion'
}

-- Discord webhook for logging
Config.Discord = {
    Enabled = true,
    WebhookURL = '', -- Set your Discord webhook URL here
    LogCooking = true,       -- Log cooking attempts
    LogLevelUp = true,       -- Log level ups
    LogCheatAttempts = true, -- Log cheat attempts
    LogColor = 0x00d4ff,     -- Cyan
    CheatColor = 0xff0000,   -- Red
    LevelUpColor = 0xffd700  -- Gold
}

-- Anti-cheat settings
Config.AntiCheat = {
    Enabled = true,
    CooldownBetweenCooks = 3000, -- ms minimum between cook attempts (anti-spam)
    MaxCookingDistance = 3.0,    -- meters from cooking marker
    VerifyIngredients = true,    -- server-side ingredient check
    LogCheatAttempts = true
}

-- Visual settings
Config.Visuals = {
    -- Cooking locations (blips + markers)
    Locations = {
        { name = 'Restaurant Kitchen', coords = vector3(298.5, -1296.2, 29.4), blip = 93, blipColor = 47 },
        { name = 'Vespucci Kitchen', coords = vector3(-1135.0, -1538.0, 4.4), blip = 93, blipColor = 47 },
        { name = 'Sandy Shores Diner', coords = vector3(1961.0, 3741.0, 32.3), blip = 93, blipColor = 47 },
    },
    Marker = {
        Type = 1, -- cylinder
        Scale = vector3(1.0, 1.0, 0.5),
        Color = { r = 0, g = 212, b = 255, a = 150 }, -- cyan
        BobUpDown = true,
        FaceCamera = false,
        Rotate = true
    },
    Particles = {
        Enabled = true,
        Smoke = {
            Dict = 'core',
            Name = 'exp_grd_flare',
            Offset = vector3(0.0, 0.0, 0.8),
            Scale = 0.5
        },
        Fire = {
            Dict = 'core',
            Name = 'ent_amb_fire',
            Offset = vector3(0.0, 0.0, 0.6),
            Scale = 0.3
        },
        Done = {
            Dict = 'scr_rcbarry2',
            Name = 'scr_clown_bullets',
            Offset = vector3(0.0, 0.0, 1.0),
            Scale = 0.6
        }
    },
    Animation = {
        Dict = 'anim@amb@business@coc@coc_unpack_cut@',
        Name = 'fullcut_cycle_c6a_cokeboard',
        Duration = 4000 -- loop
    }
}

-- Cooking settings
Config.Cooking = {
    MinLevel = 1,
    ExperiencePerCook = 10,
    MaxLevel = 100,
    CookingTime = 5000, -- ms
    -- Progress bar settings
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
            job_grade = nil,
            cost = 5,   -- Cost to make
            price = 15  -- Price to sell
        },
        ['burger'] = {
            name = 'Burger',
            ingredients = { 'bread', 'meat', 'lettuce', 'tomato' },
            level_required = 5,
            experience = 25,
            cooking_time = 7000,
            job_required = false,
            job_name = nil,
            job_grade = nil,
            cost = 8,
            price = 20
        },
        ['pizza'] = {
            name = 'Pizza',
            ingredients = { 'dough', 'tomato_sauce', 'cheese', 'pepperoni' },
            level_required = 10,
            experience = 40,
            cooking_time = 10000,
            job_required = true,
            job_name = 'chef',
            job_grade = 1,
            cost = 10,
            price = 25
        },
        ['steak'] = {
            name = 'Steak',
            ingredients = { 'meat', 'salt', 'pepper', 'butter' },
            level_required = 15,
            experience = 50,
            cooking_time = 12000,
            job_required = true,
            job_name = 'chef',
            job_grade = 2,
            cost = 15,
            price = 35
        },
        ['soup'] = {
            name = 'Soup',
            ingredients = { 'vegetables', 'water', 'salt', 'herbs' },
            level_required = 3,
            experience = 20,
            cooking_time = 6000,
            job_required = false,
            job_name = nil,
            job_grade = nil,
            cost = 4,
            price = 12
        },
        ['salad'] = {
            name = 'Salad',
            ingredients = { 'lettuce', 'tomato', 'cucumber', 'olive_oil' },
            level_required = 2,
            experience = 18,
            cooking_time = 4000,
            job_required = false,
            job_name = nil,
            job_grade = nil,
            cost = 3,
            price = 10
        },
        ['cake'] = {
            name = 'Cake',
            ingredients = { 'flour', 'sugar', 'eggs', 'butter', 'vanilla' },
            level_required = 20,
            experience = 75,
            cooking_time = 15000,
            job_required = true,
            job_name = 'chef',
            job_grade = 3,
            cost = 12,
            price = 30
        }
    }
}