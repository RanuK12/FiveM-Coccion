--[[=====================================================================
    fivem-coccion – Configuración centralizada
    Todo lo que pueda cambiarse sin tocar client.lua / server.lua
===================================================================]]

-- Framework a usar: "esx" o "qb"
Config.Framework = "esx"

-- Idioma de los locales (archivo en locales/)
Config.Locale = "es"

-- Coordenadas de las estaciones de cocina (vector3)
Config.CookingStations = {
  { x = 110.0, y = -1580.0, z = 30.0 },   -- Ejemplo 1
  { x = -1200.0, y = -1500.0, z = 5.0 }   -- Ejemplo 2
}

-- Tiempo (en segundos) que tarda cada receta
Config.CookTime = {
  ["hamburguesa"] = 10,
  ["pizza"] = 15,
  ["ensalada"] = 5
}

-- Precio de venta (en dinero del servidor)
Config.SellPrice = {
  ["hamburguesa"] = 12,
  ["pizza"] = 20,
  ["ensalada"] = 8
}

-- Permisos necesarios para usar la cocina (acepta grupos ESX o jobs QB)
Config.Permissions = {
  ["esx"] = {"chef", "manager"},
  ["qb"]  = {"chef", "manager"}
}

-- Toggles de cada feature (true = activado)
Config.EnableHungerThirst = true   -- Afecta hambre/sed al comer
Config.EnableEffects    = true   -- Efectos visuales/sónicos al cocinar
Config.EnableDebug      = false  -- Logs de debug en consola

--[[=====================================================================
    FIN DE CONFIGURACIÓN
===================================================================]]