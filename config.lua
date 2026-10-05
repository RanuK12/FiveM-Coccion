-- ============================================
-- FRAMEWORK CONFIGURATION
-- ============================================
-- Selecciona el framework a usar: 'esx' o 'qbcore'.
Config = {}
Config.Framework = {
    Name = "ESX", -- "ESX" or "QB-Core"
    Permissions = {
        Admin = "admin",
        Chef = "chef",
        Cook = "cook"
    }
}

-- ============================================
-- DEBUG MODE
-- ============================================
-- Activa logs detallados para desarrollo y depuración.
Config.Debug = false

-- ============================================
-- DISCORD LOGGING
-- ============================================
-- Configuración para enviar logs a Discord.
Config.Discord = {
    Enabled = true,
    WebhookURL = '', -- URL del webhook de Discord
    LogCooking = true,       -- Log de intentos de cocción
    LogLevelUp = true,       -- Log de ascensos de nivel
    LogCheatAttempts = true, -- Log de intentos de cheat
    LogColor = 0x00d4ff,     -- Cyan
    CheatColor = 0xff0000,   -- Red
    LevelUpColor = 0xffd700  -- Gold
}

-- ============================================
-- ANTI-CHEAT SETTINGS
-- ============================================
Config.AntiCheat = {
    Enabled = true,
    CooldownBetweenCooks = 3000, -- Tiempo mínimo entre intentos de cocción (anti-spam, en milisegundos)
    MaxCookingDistance = 3.0,    -- Distancia máxima permitida desde el marcador de cocina (en metros)
    VerifyIngredients = true,    -- Verificación de ingredientes en el servidor
    LogCheatAttempts = true     -- Registrar intentos de cheat
}

-- ============================================
-- VISUAL SETTINGS
-- ============================================
Config.Visuals = {
    Locations = {
        { name = 'Restaurant Kitchen', coords = { x = 250.0, y = 250.0, z = 100.0 }, blip = 93, blipColor = 47 },
        { name = 'Vespucci Kitchen', coords = { x = -1135.0, y = -1538.0, z = 4.4 }, blip = 93, blipColor = 47 },
        { name = 'Sandy Shores Diner', coords = { x = 1961.0, y = 3741.0, z = 32.3 }, blip = 93, blipColor = 47 }
    },
    Marker = {
        Type = 1, -- Tipo de marcador (cilindro)
        Scale = { x = 1.0, y = 1.0, z = 0.5 },
        Color = { r = 0, g = 212, b = 255, a = 150 }, -- Cian
        BobUpDown = true,
        FaceCamera = false,
        Rotate = true
    },
    Particles = {
        Enabled = true,
        Smoke = {
            Dict = 'core',
            Name = 'exp_grd_flare',
            Offset = { x = 0.0, y = 0.0, z = 0.8 },
            Scale = 0.5
        },
        Fire = {
            Dict = 'core',
            Name = 'ent_amb_fire',
            Offset = { x = 0.0, y = 0.0, z = 0.6 },
            Scale = 0.3
        },
        Done = {
            Dict = 'scr_rcbarry2',
            Name = 'scr_clown_bullets',
            Offset = { x = 0.0, y = 0.0, z = 1.0 },
            Scale = 0.6
        }
    },
    Animation = {
        Dict = 'anim@amb@business@coc@coc_unpack_cut@',
        Name = 'fullcut_cycle_c6a_cokeboard',
        Duration = 4000 -- Duración de la animación
    }
}

-- ============================================
-- COOKING SETTINGS
-- ============================================
Config.Cooking = {
    MinLevel = 1, -- Nivel mínimo para empezar
    MaxLevel = 100, -- Nivel máximo alcanzable
    ExperiencePerCook = 10, -- Experiencia otorgada por cada cocción
    CookingTime = 5000, -- Tiempo de cocción en milisegundos
    
    -- Configuración de la barra de progreso
    ProgressBar = {
        Enabled = true,
        Type = 'ox_lib', -- Opciones: 'ox_lib', 'esx', 'qbcore'
        Position = 'middle', -- Opciones: 'middle', 'bottom'
        Color = '#00d4ff', -- Color en hexadecimal
        Width = 300,
        Height = 20
    },
    
    -- Configuración de las recetas disponibles
    Recipes = {
        {
            Name = "Pasta",
            Ingredients = {"harina", "agua", "sal"},
            Level = 1,
            Time = 30,
            Price = 50,
            Job = "chef"
        },
        {
            Name = "Pizza",
            Ingredients = {"harina", "queso", "carne"},
            Level = 2,
            Time = 60,
            Price = 80,
            Job = "chef"
        },
        {
            Name = "Hamburguesa",
            Ingredients = {"pan", "carne", "verdura"},
            Level = 1,
            Time = 45,
            Price = 60,
            Job = "cook"
        },
        {
            Name = "Ensalada",
            Ingredients = {"verdura", "agua"},
            Level = 1,
            Time = 15,
            Price = 30,
            Job = "cook"
        },
        {
            Name = "Bistec",
            Ingredients = {"carne", "sal", "mantequilla"},
            Level = 3,
            Time = 90,
            Price = 120,
            Job = "chef"
        },
        {
            Name = "Sopa",
            Ingredients = {"verdura", "agua", "sal"},
            Level = 2,
            Time = 40,
            Price = 45,
            Job = "cook"
        },
        {
            Name = "Pastel",
            Ingredients = {"harina", "azucar", "huevo", "leche"},
            Level = 4,
            Time = 120,
            Price = 150,
            Job = "chef"
        }
    }
}