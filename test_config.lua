--[[ 
    Test para validar la configuración de config.lua
]]

-- Cargar la configuración
local config = dofile('config.lua')

print('Framework:', config.Framework)
print('Locale:', config.Locale)
print('CookingStations[1]:', config.CookingStations[1].x, config.CookingStations[1].y, config.CookingStations[1].z)
print('Times.Chop:', config.Times.Chop)
print('Times.Mix:', config.Times.Mix)
print('Times.Cook:', config.Times.Cook)
print('Prices.Hamburger:', config.Prices.Hamburger)
print('Prices.Pizza:', config.Prices.Pizza)
print('Prices.Salad:', config.Prices.Salad)
print('Permissions.esx:', config.Permissions.esx)
print('Permissions.qb:', config.Permissions.qb)
print('Features.EnableChopping:', config.Features.EnableChopping)
print('Features.EnableMixing:', config.Features.EnableMixing)
print('Features.EnableCooking:', config.Features.EnableCooking)
print('Features.EnableDelivery:', config.Features.EnableDelivery)
print('Features.EnableNotifications:', config.Features.EnableNotifications)
print('Debug:', config.Debug)