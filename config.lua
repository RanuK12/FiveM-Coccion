--[[ 
    fivem-coccion – Configuración centralizada
    Todos los valores modificables están aquí; ningún número mágico en client/ o server/. 
]]

-- Configuración global del sistema
Config = Config or {}

-- Framework: "esx" o "qb"
Config.Framework = "esx"

-- Idioma de los locales (es, en, etc.)
Config.Locale = "es"

-- Coordenadas de las estaciones de cocina (vector3)
Config.CookingStations = {
    { x = 110.0, y = -1580.0, z = 30.0 },
    { x = -560.0, y = 285.0, z = 82.0 }
}

-- Tiempo (en segundos) para cada acción
Config.Times = {
    Chop = 5,
    Mix  = 8,
    Cook = 12
}

-- Precio de venta de cada plato (en dinero del servidor)
Config.Prices = {
    Hamburger = 150,
    Pizza     = 200,
    Salad     = 100
}

-- Permisos requeridos para usar la cocina (acepta grupos ESX o jobs QB)
Config.Permissions = {
    esx = "chef",
    qb  = "chef"
}

-- Toggles de cada feature (true = activado)
Config.Features = {
    EnableChopping   = true,
    EnableMixing     = true,
    EnableCooking    = true,
    EnableDelivery   = false,
    EnableNotifications = true
}

-- Otros ajustes globales
Config.Debug = false