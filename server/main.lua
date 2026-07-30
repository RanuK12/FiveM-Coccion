local ESX = nil
local QBCore = nil
local playerCookingData = {}

-- Initialize framework
Citizen.CreateThread(function()
    if Config.Framework == 'esx' then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    elseif Config.Framework == 'qbcore' then
        while QBCore == nil do
            QBCore = exports['qb-core']:GetCoreObject()
            Citizen.Wait(0)
        end
    end
    
    -- Load saved cooking data
    loadPlayerCookingData()
end)

-- Load player cooking data from database
function loadPlayerCookingData()
    if Config.Framework == 'esx' then
        ESX.RegisterServerCallback('coccion:getPlayerData', function(source, cb)
            local identifier = GetPlayerIdentifier(source)
            
            if not playerCookingData[identifier] then
                playerCookingData[identifier] = {
                    level = 1,
                    experience = 0
                }
                
                -- Save to database
                MySQL.Async.execute('INSERT INTO coccion_player_data (identifier, level, experience) VALUES (?, ?, ?)', {
                    identifier,
                    playerCookingData[identifier].level,
                    playerCookingData[identifier].experience
                })
            end
            
            cb(playerCookingData[identifier])
        end)
    elseif Config.Framework == 'qbcore' then
        QBCore.Functions.CreateCallback('coccion:getPlayerData', function(source, cb)
            local Player = QBCore.Functions.GetPlayer(source)
            local identifier = Player.PlayerData.citizenid
            
            if not playerCookingData[identifier] then
                playerCookingData[identifier] = {
                    level = 1,
                    experience = 0
                }
                
                -- Save to database
                MySQL.Async.execute('INSERT INTO coccion_player_data (identifier, level, experience) VALUES (?, ?, ?)', {
                    identifier,
                    playerCookingData[identifier].level,
                    playerCookingData[identifier].experience
                })
            end
            
            cb(playerCookingData[identifier])
        end)
    end
end

-- Update player cooking data
function updatePlayerData(identifier, data)
    playerCookingData[identifier] = data
    
    if Config.Framework == 'esx' then
        MySQL.Async.execute('UPDATE coccion_player_data SET level = ?, experience = ? WHERE identifier = ?', {
            data.level,
            data.experience,
            identifier
        })
    elseif Config.Framework == 'qbcore' then
        MySQL.Async.execute('UPDATE coccion_player_data SET level = ?, experience = ? WHERE identifier = ?', {
            data.level,
            data.experience,
            identifier
        })
    end
end

-- Add experience to player
function addExperience(identifier, amount)
    if not playerCookingData[identifier] then
        playerCookingData[identifier] = {
            level = 1,
            experience = 0
        }
    end
    
    playerCookingData[identifier].experience = playerCookingData[identifier].experience + amount
    
    -- Check for level up
    local expNeeded = playerCookingData[identifier].level * 100
    if playerCookingData[identifier].experience >= expNeeded then
        playerCookingData[identifier].level = playerCookingData[identifier].level + 1
        playerCookingData[identifier].experience = playerCookingData[identifier].experience - expNeeded
        
        TriggerClientEvent('chatMessage', getPlayerFromIdentifier(identifier), '[COOKING]', {255, 215, 0}, 'Congratulations! You reached level ' .. playerCookingData[identifier].level .. '!')
    end
    
    updatePlayerData(identifier, playerCookingData[identifier])
end

-- Get player from identifier
function getPlayerFromIdentifier(identifier)
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        if GetPlayerIdentifier(playerId) == identifier then
            return playerId
        end
    end
    return nil
end

-- Server commands
RegisterCommand('setcookinglevel', function(source, args)
    if IsPlayerAceAllowed(source, 'command.coccion') then
        local target = tonumber(args[1])
        local level = tonumber(args[2])
        
        if target and level then
            local identifier = GetPlayerIdentifier(target)
            if playerCookingData[identifier] then
                playerCookingData[identifier].level = level
                updatePlayerData(identifier, playerCookingData[identifier])
                
                TriggerClientEvent('chatMessage', target, '[ADMIN]', {255, 0, 0}, 'Your cooking level has been set to ' .. level .. ' by an administrator.')
                TriggerEvent('chatMessage', source, '[ADMIN]', {0, 255, 0}, 'You set cooking level for ' .. target .. ' to ' .. level .. '.')
            else
                TriggerEvent('chatMessage', source, '[ERROR]', {255, 0, 0}, 'Player not found in cooking data.')
            end
        else
            TriggerEvent('chatMessage', source, '[ERROR]', {255, 0, 0}, 'Usage: /setcookinglevel [playerId] [level]')
        end
    else
        TriggerEvent('chatMessage', source, '[ERROR]', {255, 0, 0}, 'You do not have permission to use this command.')
    end
end)

-- Register exports
exports('GetPlayerCookingData', function(identifier)
    return playerCookingData[identifier] or {level = 1, experience = 0}
end)

exports('AddCookingExperience', function(identifier, amount)
    addExperience(identifier, amount)
end)