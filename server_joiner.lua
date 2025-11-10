-- Combined Animal Scanner + Auto Server Joiner
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

-- Print server job ID
print("🆔 Server Job ID: " .. game.JobId)
print("")

-- Single job ID that will be updated by Flask server
local jobId = "2a655ef3-869c-4dbd-86aa-3f0b8068111c"

-- Flag to track if we're currently teleporting
local isTeleporting = false

-- Function to check for specific teleport errors
local function isRetryableError(errorMessage)
    local lowerError = string.lower(tostring(errorMessage))
    
    -- Check for common teleport errors that should trigger a retry
    if string.find(lowerError, "server is full") or
       string.find(lowerError, "server full") or
       string.find(lowerError, "game is full") or
       string.find(lowerError, "cannot join") or
       string.find(lowerError, "failed to join") or
       string.find(lowerError, "not found") or
       string.find(lowerError, "invalid place") or
       string.find(lowerError, "teleport failed") or
       string.find(lowerError, "don't have permission") or
       string.find(lowerError, "do not have permission") or
       string.find(lowerError, "permission") or
       string.find(lowerError, "access denied") or
       string.find(lowerError, "not allowed") then
        return true
    end
    
    return false
end

-- Function to restart the entire script
local function restartScript()
    print("🔄 Restarting script in 5 seconds...")
    
    for i = 5, 1, -1 do
        print("   Restarting in: " .. i .. " seconds")
        wait(1)
    end
    
    print("🚀 Restarting script now!")
    
    -- Clear any existing connections to avoid memory leaks
    isTeleporting = false
    
    -- Re-execute the main process
    main()
end

-- [REST OF YOUR LUA SCRIPT CODE WOULD GO HERE - I'M SHORTENING FOR BREVITY]
-- Complete animal database with Generation and Price
local animalDatabase = {
    ["Cocofanto Elefanto"] = {Rarity = "Brainrot God", Price = 5000000, Generation = 17500},
    -- ... (include all your animal data here)
}

-- Function to check if UUID (player plot)
local function isUUID(name)
    local uuidPattern = "^[a-f0-9]+%-[a-f0-9]+%-[a-f0-9]+%-[a-f0-9]+%-[a-f0-9]+$"
    return name:match(uuidPattern) ~= nil
end

-- [INCLUDE ALL YOUR OTHER FUNCTIONS HERE: formatNumber, saveScanData, scanForValuableAnimals]

-- Function to join next server with error handling
local function joinNextServer()
    if isTeleporting then
        print("⚠️ Already attempting to teleport, skipping...")
        return
    end
    
    isTeleporting = true
    print("🚀 Trying to join server: " .. jobId)
    
    local success, errorMessage = pcall(function()
        TeleportService:TeleportToPlaceInstance(109983668079237, jobId, Players.LocalPlayer)
    end)
    
    if success then
        print("✅ Teleport initiated!")
    else
        print("❌ Teleport failed: " .. tostring(errorMessage))
        isTeleporting = false
        
        -- Check if this is a retryable error
        if isRetryableError(errorMessage) then
            print("🔄 Retryable error detected, restarting script...")
            wait(2)
            restartScript()
        else
            print("⚠️ Non-retryable error, continuing with normal flow...")
        end
    end
end

-- Main execution function
local function main()
    print("🎯 Starting Combined Animal Scanner + Auto Server Joiner")
    print("==========================================")

    -- Step 1: Scan for animals in current server
    scanForValuableAnimals()

    print("\n" .. string.rep("=", 50))
    print("⏰ Waiting 60 seconds before server hop...")

    -- Wait 60 seconds before switching servers
    for i = 60, 1, -1 do
        if i % 10 == 0 or i <= 5 then
            print("   Next server hop in: " .. i .. " seconds")
        end
        wait(1)
    end

    print("\n" .. string.rep("=", 50))
    print("🔄 Preparing to switch servers...")

    -- Step 2: Join the server specified in the jobId variable
    joinNextServer()
end

-- Start the main execution
main()
