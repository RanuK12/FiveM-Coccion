--[[=====================================================================
  fivem-coccion – Configuración central
  Cada opción está documentada línea a línea.
  No modifiques nada fuera de este archivo.
=====================================================================]]--

-- 1️⃣ Framework -----------------------------------------------------------
-- Elige el framework que usa tu servidor: "esx" o "qbcore"
Config.Framework = "esx"   -- "esx" | "qbcore"

-- 2️⃣ Idioma --------------------------------------------------------------
-- Idioma por defecto. Los archivos de locales están en `locales/`.
Config.Locale = "es"       -- "es", "en", "fr", ...

-- 3️⃣ Coordenadas de los puntos de cocina ---------------------------------
-- Cada punto es un vector3(x, y, z). Añade o elimina según tu mapa.
Config.CookingStations = {
  { x = 123.45, y = -456.78, z = 78.90 },   -- ejemplo 1
  -- { x = ..., y = ..., z = ... },        -- ejemplo 2 (descomenta para usar)
}

-- 4️⃣ Tiempos (en milisegundos) -------------------------------------------
Config.Times = {
  prep   = 5000,   -- tiempo de preparación
  cook   = 15000,  -- tiempo de cocción
  serve  = 3000,   -- tiempo de entrega
}

-- 5️⃣ Precios -------------------------------------------------------------
-- Precio que paga el jugador por cada receta.
Config.Prices = {
  burger = 25,
  pizza  = 40,
  taco   = 30,
}

-- 6️⃣ Permisos ------------------------------------------------------------
-- Grupo de permisos necesario para usar la cocina.
Config.Permission = "cocina.use"   -- usa tu sistema de permisos (ACE, ESX, etc.)

-- 7️⃣ Toggles de funcionalidades -----------------------------------------
Config.Features = {
  enableCooking   = true,   -- activar/desactivar todo el sistema
  enableDelivery  = true,   -- activar entregas a clientes
  enableInventory = true,   -- usar inventario del framework
}

-- 8️⃣ Mensajes personalizables (se cargan desde locales, pero puedes sobrescribir)
Config.Messages = {
  notEnoughMoney = "No tienes suficiente dinero.",
  cookingStart   = "Has comenzado a cocinar %s.",
}