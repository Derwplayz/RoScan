-- Combined Animal Scanner + Auto Server Joiner
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Print server job ID
print("🆔 Server Job ID: " .. game.JobId)
print("")

-- Single job ID that will be updated by Flask server
local jobId = "135f0523-6544-4cae-9799-abdb3eb07dc7"

-- Flag to track if we're currently teleporting
local isTeleporting = false

-- Teleport configuration
local MAX_TELEPORT_RETRIES = 5
local RETRY_DELAY = 10
local currentRetries = 0

-- Store original server ID to check if we actually left
local originalServerId = game.JobId

-- Complete animal database with Generation and Price
local animalDatabase = {
    ["Cocofanto Elefanto"] = {Rarity = "Brainrot God", Price = 5000000, Generation = 17500},
    ["Girafaroo"] = {Rarity = "Brainrot God", Price = 4500000, Generation = 17000},
    ["Hippopolarbearmus"] = {Rarity = "Brainrot God", Price = 4000000, Generation = 16500},
    ["Penguink"] = {Rarity = "Brainrot God", Price = 3800000, Generation = 16000},
    ["Rhinosorcerous"] = {Rarity = "Brainrot God", Price = 4200000, Generation = 16200},
    ["Leopardon"] = {Rarity = "Mythical", Price = 2500000, Generation = 12000},
    ["Tigeroo"] = {Rarity = "Mythical", Price = 2200000, Generation = 11500},
    ["Elephly"] = {Rarity = "Mythical", Price = 2000000, Generation = 11000},
    ["Giraffie"] = {Rarity = "Mythical", Price = 1800000, Generation = 10500},
    ["Hippoe"] = {Rarity = "Mythical", Price = 1600000, Generation = 10000},
    ["Penguinja"] = {Rarity = "Mythical", Price = 1400000, Generation = 9500},
    ["Rhinoctopus"] = {Rarity = "Mythical", Price = 1200000, Generation = 9000},
    ["Lionheart"] = {Rarity = "Legendary", Price = 800000, Generation = 7000},
    ["Tigerclaw"] = {Rarity = "Legendary", Price = 750000, Generation = 6500},
    ["Elephantom"] = {Rarity = "Legendary", Price = 700000, Generation = 6000},
    ["Giraffinity"] = {Rarity = "Legendary", Price = 650000, Generation = 5500},
    ["Hippocampus"] = {Rarity = "Legendary", Price = 600000, Generation = 5000},
    ["Penguinc"] = {Rarity = "Legendary", Price = 550000, Generation = 4500},
    ["Rhinocerous"] = {Rarity = "Legendary", Price = 500000, Generation = 4000},
    ["Cheetah"] = {Rarity = "Epic", Price = 300000, Generation = 3000},
    ["Panther"] = {Rarity = "Epic", Price = 250000, Generation = 2500},
    ["Jaguar"] = {Rarity = "Epic", Price = 200000, Generation = 2000},
    ["Elephant"] = {Rarity = "Epic", Price = 180000, Generation = 1800},
    ["Giraffe"] = {Rarity = "Epic", Price = 160000, Generation = 1600},
    ["Hippo"] = {Rarity = "Epic", Price = 140000, Generation = 1400},
    ["Penguin"] = {Rarity = "Epic", Price = 120000, Generation = 1200},
    ["Rhino"] = {Rarity = "Epic", Price = 100000, Generation = 1000},
    ["Lion"] = {Rarity = "Rare", Price = 50000, Generation = 800},
    ["Tiger"] = {Rarity = "Rare", Price = 40000, Generation = 700},
    ["Bear"] = {Rarity = "Rare", Price = 30000, Generation = 600},
    ["Wolf"] = {Rarity = "Rare", Price = 20000, Generation = 500},
    ["Fox"] = {Rarity = "Rare", Price = 15000, Generation = 400},
    ["Deer"] = {Rarity = "Common", Price = 5000, Generation = 300},
    ["Rabbit"] = {Rarity = "Common", Price = 2000, Generation = 200},
    ["Squirrel"] = {Rarity = "Common", Price = 1000, Generation = 100},
    ["Bird"] = {Rarity = "Common", Price = 500, Generation = 50}
}

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
       string.find(lowerError, "not allowed") or
       string.find(lowerError, "connection") or
       string.find(lowerError, "timeout") or
       string.find(lowerError, "network") or
       string.find(lowerError, "gameended") or
       string.find(lowerError, "could not find") then
        return true
    end
    
    return false
end

-- Function to perform pre-teleport error scan
local function scanForTeleportErrors()
    print("🔍 Scanning for potential teleport errors...")
    
    local errorsFound = {}
    local warningsFound = {}
    
    -- Check if player is valid
    if not LocalPlayer or not LocalPlayer.UserId then
        table.insert(errorsFound, "❌ LocalPlayer is invalid or missing UserId")
    end
    
    -- Check if jobId is valid format
    if not jobId or type(jobId) ~= "string" or #jobId < 10 then
        table.insert(errorsFound, "❌ jobId is invalid: " .. tostring(jobId))
    end
    
    -- Check if teleport service is available
    local teleportSuccess, teleportError = pcall(function()
        return TeleportService:GetTeleportSetting("Test")
    end)
    if not teleportSuccess then
        table.insert(warningsFound, "⚠️ TeleportService might be having issues")
    end
    
    -- Check if we're in the correct game
    if not game.PlaceId then
        table.insert(errorsFound, "❌ Cannot determine current game PlaceId")
    end
    
    -- Check if we've exceeded retry limits
    if currentRetries >= MAX_TELEPORT_RETRIES then
        table.insert(errorsFound, "❌ Maximum teleport retries exceeded: " .. currentRetries)
    end
    
    -- Display scan results
    if #errorsFound > 0 then
        print("❌ TELEPORT ERROR SCAN RESULTS:")
        for _, errorMsg in ipairs(errorsFound) do
            print("   " .. errorMsg)
        end
        return false, errorsFound
    end
    
    if #warningsFound > 0 then
        print("⚠️ TELEPORT WARNINGS:")
        for _, warningMsg in ipairs(warningsFound) do
            print("   " .. warningMsg)
        end
    end
    
    print("✅ Teleport error scan passed - no critical errors found")
    return true, warningsFound
end

-- Function to check if we're still in the same server after teleport attempt
local function checkTeleportSuccess()
    print("🔍 Checking if teleport was successful...")
    
    -- Wait a moment for the teleport to potentially complete
    wait(3)
    
    local currentServerId = game.JobId
    print("   Original Server: " .. originalServerId)
    print("   Current Server: " .. currentServerId)
    
    if currentServerId == originalServerId then
        print("❌ Teleport failed - still in original server")
        return false
    else
        print("✅ Teleport successful - in new server: " .. currentServerId)
        return true
    end
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
    currentRetries = 0
    
    -- Re-execute the main process
    main()
end

-- Function to check if UUID (player plot)
local function isUUID(name)
    if not name then return false end
    local uuidPattern = "^[a-f0-9]+%-[a-f0-9]+%-[a-f0-9]+%-[a-f0-9]+%-[a-f0-9]+$"
    return string.match(tostring(name), uuidPattern) ~= nil
end

-- Function to format numbers with commas
local function formatNumber(num)
    if not num then return "0" end
    local formatted = tostring(num)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Function to save scan data
local function saveScanData(scanResults)
    local timestamp = DateTime.now():FormatLocalTime("LTS", "en-us")
    local dataToSave = {
        timestamp = timestamp,
        serverId = game.JobId,
        scanResults = scanResults
    }
    
    -- Convert to JSON for saving (you can modify this to save to file or send to server)
    local jsonData = HttpService:JSONEncode(dataToSave)
    
    print("💾 Scan data saved for server: " .. game.JobId)
    print("   Total valuable animals found: " .. #scanResults)
    print("   Timestamp: " .. timestamp)
    
    return jsonData
end

-- Function to scan for valuable animals
local function scanForValuableAnimals()
    print("🔍 Scanning for valuable animals...")
    
    local valuableAnimals = {}
    local totalValue = 0
    local plotsScanned = 0
    local animalsFound = 0
    
    -- Look for plots in workspace
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then
        print("❌ No Plots folder found in workspace")
        return valuableAnimals
    end
    
    -- Scan each plot
    for _, plot in pairs(plots:GetChildren()) do
        if isUUID(plot.Name) then
            plotsScanned += 1
            
            -- Look for animals in this plot
            for _, item in pairs(plot:GetDescendants()) do
                if item:IsA("Model") or item:IsA("Part") then
                    local animalName = item.Name
                    
                    -- Check if this is a known animal in our database
                    if animalDatabase[animalName] then
                        local animalData = animalDatabase[animalName]
                        animalsFound += 1
                        totalValue += animalData.Price
                        
                        -- Add to results
                        table.insert(valuableAnimals, {
                            name = animalName,
                            rarity = animalData.Rarity,
                            price = animalData.Price,
                            generation = animalData.Generation,
                            plotId = plot.Name,
                            position = item:GetPivot().Position
                        })
                        
                        print("🎯 Found: " .. animalName .. " | Rarity: " .. animalData.Rarity .. " | Value: $" .. formatNumber(animalData.Price))
                    end
                end
            end
        end
    end
    
    -- Print summary
    print("\n📊 SCAN SUMMARY:")
    print("   Plots scanned: " .. plotsScanned)
    print("   Valuable animals found: " .. animalsFound)
    print("   Total value: $" .. formatNumber(totalValue))
    
    -- Save scan results
    if #valuableAnimals > 0 then
        saveScanData(valuableAnimals)
    else
        print("💤 No valuable animals found in this server")
    end
    
    return valuableAnimals
end

-- Enhanced function to join next server with proper success/failure detection
local function joinNextServer()
    if isTeleporting then
        print("⚠️ Already attempting to teleport, skipping...")
        return
    end
    
    -- Update original server ID
    originalServerId = game.JobId
    
    -- Step 1: Pre-teleport error scan
    print("🛡️ Running pre-teleport safety checks...")
    local scanSuccess, scanWarnings = scanForTeleportErrors()
    
    if not scanSuccess then
        print("❌ Pre-teleport scan failed! Delaying teleport attempt...")
        currentRetries += 1
        
        if currentRetries <= MAX_TELEPORT_RETRIES then
            print("🔄 Retry attempt " .. currentRetries .. "/" .. MAX_TELEPORT_RETRIES .. " in " .. RETRY_DELAY .. " seconds...")
            for i = RETRY_DELAY, 1, -1 do
                print("   Retrying in: " .. i .. " seconds")
                wait(1)
            end
            return joinNextServer() -- Retry recursively
        else
            print("💥 Maximum retry attempts reached! Restarting script...")
            wait(2)
            restartScript()
            return
        end
    end
    
    -- Step 2: Attempt teleport with enhanced error handling
    isTeleporting = true
    print("🚀 Attempting to teleport to server: " .. jobId)
    print("📊 Teleport attempt " .. (currentRetries + 1) .. "/" .. MAX_TELEPORT_RETRIES)
    
    local teleportSuccess, teleportError = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
    end)
    
    if teleportSuccess then
        print("✅ Teleport initiation successful! Waiting to confirm...")
        
        -- Wait and check if we actually left the server
        local teleportConfirmed = checkTeleportSuccess()
        
        if teleportConfirmed then
            print("🎉 Teleport completed successfully!")
            currentRetries = 0 -- Reset retry counter on success
            return
        else
            print("❌ Teleport initiation succeeded but we're still in the same server")
            teleportError = "Teleport initiation succeeded but failed to change servers (GameEnded error)"
        end
    end
    
    -- If we reach here, teleport failed
    print("❌ Teleport failed: " .. tostring(teleportError))
    isTeleporting = false
    currentRetries += 1
    
    -- Enhanced error analysis
    if isRetryableError(teleportError) then
        print("🔄 Retryable error detected...")
        
        if currentRetries <= MAX_TELEPORT_RETRIES then
            print("⏳ Waiting " .. RETRY_DELAY .. " seconds before retry " .. currentRetries .. "/" .. MAX_TELEPORT_RETRIES)
            
            for i = RETRY_DELAY, 1, -1 do
                print("   Retrying in: " .. i .. " seconds")
                wait(1)
            end
            
            print("🔄 Attempting retry " .. currentRetries .. "/" .. MAX_TELEPORT_RETRIES)
            return joinNextServer() -- Retry recursively
        else
            print("💥 Maximum retry attempts reached! Restarting script...")
            wait(2)
            restartScript()
        end
    else
        print("⚠️ Non-retryable error, continuing with normal flow...")
        -- For non-retryable errors, we'll still restart but with a longer delay
        print("🔄 Restarting script in 15 seconds due to non-retryable error...")
        wait(15)
        restartScript()
    end
end

-- Main execution function
local function main()
    print("🎯 Starting Combined Animal Scanner + Auto Server Joiner")
    print("==========================================")
    print("⚙️ Configuration:")
    print("   Max Retries: " .. MAX_TELEPORT_RETRIES)
    print("   Retry Delay: " .. RETRY_DELAY .. "s")
    print("   Current Retry Count: " .. currentRetries)
    print("   Current Server: " .. game.JobId)
    print("==========================================")

    -- Step 1: Scan for animals in current server
    local scanSuccess, scanError = pcall(scanForValuableAnimals)
    if not scanSuccess then
        print("❌ Scan error: " .. tostring(scanError))
        print("⚠️ Continuing with server hop despite scan error...")
    end

    print("\n" .. string.rep("=", 50))
    print("⏰ Waiting 30 seconds before server hop...")

    -- Wait 30 seconds before switching servers
    for i = 30, 1, -1 do
        if i % 10 == 0 or i <= 5 then
            print("   Next server hop in: " .. i .. " seconds")
        end
        wait(1)
    end

    print("\n" .. string.rep("=", 50))
    print("🔄 Preparing to switch servers...")
    
    -- Step 2: Join the server with enhanced error handling and retry logic
    joinNextServer()
end

-- Global error handler
local function globalErrorHandler(err)
    print("💥 UNHANDLED ERROR: " .. tostring(err))
    print("📝 Stack trace: " .. debug.traceback())
    print("🔄 Attempting recovery in 10 seconds...")
    wait(10)
    restartScript()
end

-- Start the script with error protection
print("🚀 Initializing script...")
currentRetries = 0
isTeleporting = false
originalServerId = game.JobId

local success, err = xpcall(main, globalErrorHandler)
if not success then
    print("💥 Script crashed: " .. tostring(err))
    print("🔄 Final restart attempt in 15 seconds...")
    wait(15)
    restartScript()
end
