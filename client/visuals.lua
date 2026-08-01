-- FiveM-Coccion Visual Effects
-- Blips, 3D markers, animations, and particles for cooking locations

local blips = {}
local currentPtfx = nil

-- ============================================
-- BLIPS - Map icons for cooking locations
-- ============================================
Citizen.CreateThread(function()
    for _, loc in ipairs(Config.Visuals.Locations) do
        local blip = AddBlipForCoord(loc.coords.x, loc.coords.y, loc.coords.z)
        SetBlipSprite(blip, loc.blip or 93)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.75)
        SetBlipColour(blip, loc.blipColor or 47)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(loc.name or 'Kitchen')
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, blip in ipairs(blips) do
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end
    end
end)

-- ============================================
-- 3D MARKERS - Visual cooking spots
-- ============================================
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleep = 1000

        for _, loc in ipairs(Config.Visuals.Locations) do
            local dist = #(playerCoords - loc.coords)
            if dist < 30.0 then
                sleep = 0
                local marker = Config.Visuals.Marker
                DrawMarker(
                    marker.Type,
                    loc.coords.x, loc.coords.y, loc.coords.z - 0.2,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    marker.Scale.x, marker.Scale.y, marker.Scale.z,
                    marker.Color.r, marker.Color.g, marker.Color.b, marker.Color.a,
                    marker.BobUpDown, marker.FaceCamera, 2,
                    marker.Rotate, nil, nil, false
                )
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- ============================================
-- HELP TEXT - Show instruction when near kitchen
-- ============================================
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleep = 1000

        for _, loc in ipairs(Config.Visuals.Locations) do
            local dist = #(playerCoords - loc.coords)
            if dist < 2.5 then
                sleep = 0
                SetTextComponentFormat('STRING')
                AddTextComponentString('Press ~INPUT_CONTEXT~ to open Cooking Menu')
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- ============================================
-- ANIMATION - Play cooking animation
-- ============================================
function playCookingAnimation()
    local playerPed = PlayerPedId()
    local anim = Config.Visuals.Animation

    RequestAnimDict(anim.Dict)
    while not HasAnimDictLoaded(anim.Dict) do
        Citizen.Wait(10)
    end

    TaskPlayAnim(playerPed, anim.Dict, anim.Name, 8.0, -8.0, anim.Duration, 1, 0, false, false, false)

    Citizen.SetTimeout(anim.Duration + 500, function()
        StopAnimTask(playerPed, anim.Dict, anim.Name, 1.0)
        RemoveAnimDict(anim.Dict)
    end)
end

function stopCookingAnimation()
    local playerPed = PlayerPedId()
    local anim = Config.Visuals.Animation
    StopAnimTask(playerPed, anim.Dict, anim.Name, 1.0)
    RemoveAnimDict(anim.Dict)
end

-- ============================================
-- PARTICLES - Smoke, fire, and completion effects
-- ============================================
function startCookingParticles()
    if not Config.Visuals.Particles.Enabled then return end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local smoke = Config.Visuals.Particles.Smoke
    local fire = Config.Visuals.Particles.Fire

    RequestNamedPtfxAsset(smoke.Dict)
    while not HasNamedPtfxAssetLoaded(smoke.Dict) do
        Citizen.Wait(5)
    end
    RequestNamedPtfxAsset(fire.Dict)
    while not HasNamedPtfxAssetLoaded(fire.Dict) do
        Citizen.Wait(5)
    end

    UseParticleFxAssetNextCall(smoke.Dict)
    local smokeFx = StartParticleFxLoopedAtCoord(
        smoke.Name,
        coords.x + smoke.Offset.x,
        coords.y + smoke.Offset.y,
        coords.z + smoke.Offset.z,
        0.0, 0.0, 0.0,
        smoke.Scale,
        false, false, false, false
    )

    UseParticleFxAssetNextCall(fire.Dict)
    local fireFx = StartParticleFxLoopedAtCoord(
        fire.Name,
        coords.x + fire.Offset.x,
        coords.y + fire.Offset.y,
        coords.z + fire.Offset.z,
        0.0, 0.0, 0.0,
        fire.Scale,
        false, false, false, false
    )

    currentPtfx = { smoke = smokeFx, fire = fireFx, smokeDict = smoke.Dict, fireDict = fire.Dict }
end

function stopCookingParticles()
    if currentPtfx then
        if currentPtfx.smoke then StopParticleFxLooped(currentPtfx.smoke, false) end
        if currentPtfx.fire then StopParticleFxLooped(currentPtfx.fire, false) end
        RemoveNamedPtfxAsset(currentPtfx.smokeDict)
        RemoveNamedPtfxAsset(currentPtfx.fireDict)
        currentPtfx = nil
    end
end

function playCompletionParticles()
    if not Config.Visuals.Particles.Enabled then return end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local done = Config.Visuals.Particles.Done

    RequestNamedPtfxAsset(done.Dict)
    while not HasNamedPtfxAssetLoaded(done.Dict) do
        Citizen.Wait(5)
    end

    UseParticleFxAssetNextCall(done.Dict)
    StartParticleFxNonLoopedAtCoord(
        done.Name,
        coords.x + done.Offset.x,
        coords.y + done.Offset.y,
        coords.z + done.Offset.z,
        0.0, 0.0, 0.0,
        done.Scale,
        false, false, false
    )

    Citizen.SetTimeout(3000, function()
        RemoveNamedPtfxAsset(done.Dict)
    end)
end

-- ============================================
-- EVENT HANDLERS - trigger visuals from cooking
-- ============================================
RegisterNetEvent('coccion:startCookingVisuals')
AddEventHandler('coccion:startCookingVisuals', function()
    playCookingAnimation()
    startCookingParticles()
end)

RegisterNetEvent('coccion:stopCookingVisuals')
AddEventHandler('coccion:stopCookingVisuals', function(success)
    stopCookingAnimation()
    stopCookingParticles()
    if success then
        playCompletionParticles()
    end
end)

-- Proximity check with E key to open menu
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        for _, loc in ipairs(Config.Visuals.Locations) do
            local dist = #(coords - loc.coords)
            if dist < 2.5 then
                if IsControlJustReleased(0, 38) then -- E key
                    TriggerEvent('coccion:openMenu')
                end
            end
        end
    end
end)