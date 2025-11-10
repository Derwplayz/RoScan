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
local jobId = "f97d8b80-7f00-4283-b011-1dd8d2d3f92e"

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
    ["Antonio"] = {Rarity = "Brainrot God", Price = 6000000, Generation = 18500},
    ["Girafa Celestre"] = {Rarity = "Brainrot God", Price = 7500000, Generation = 20000},
    ["Gattatino Nyanino"] = {Rarity = "Brainrot God", Price = 7500000, Generation = 35000},
    ["Chihuanini Taconini"] = {Rarity = "Brainrot God", Price = 8500000, Generation = 45000},
    ["Tralalero Tralala"] = {Rarity = "Brainrot God", Price = 10000000, Generation = 50000},
    ["Matteo"] = {Rarity = "Brainrot God", Price = 10000000, Generation = 50000},
    ["Los Crocodillitos"] = {Rarity = "Brainrot God", Price = 12500000, Generation = 55000},
    ["Tigroligre Frutonni"] = {Rarity = "Brainrot God", Price = 14000000, Generation = 60000},
    ["Odin Din Din Dun"] = {Rarity = "Brainrot God", Price = 15000000, Generation = 75000},
    ["Alessio"] = {Rarity = "Brainrot God", Price = 17500000, Generation = 85000},
    ["Tralalita Tralala"] = {Rarity = "Brainrot God", Price = 20000000, Generation = 100000},
    ["Unclito Samito"] = {Rarity = "Brainrot God", Price = 20000000, Generation = 75000},
    ["Tipi Topi Taco"] = {Rarity = "Brainrot God", Price = 20000000, Generation = 75000},
    ["Tukanno Bananno"] = {Rarity = "Brainrot God", Price = 22500000, Generation = 100000},
    ["Extinct Ballerina"] = {Rarity = "Brainrot God", Price = 23500000, Generation = 125000},
    ["Orcalero Orcala"] = {Rarity = "Brainrot God", Price = 25000000, Generation = 100000},
    ["Espresso Signora"] = {Rarity = "Brainrot God", Price = 25000000, Generation = 70000},
    ["Trenostruzzo Turbo 3000"] = {Rarity = "Brainrot God", Price = 25000000, Generation = 150000},
    ["Urubini Flamenguini"] = {Rarity = "Brainrot God", Price = 30000000, Generation = 150000},
    ["Trippi Troppi Troppa Trippa"] = {Rarity = "Brainrot God", Price = 30000000, Generation = 175000},
    ["Capi Taco"] = {Rarity = "Brainrot God", Price = 31000000, Generation = 155000},
    ["Las Capuchinas"] = {Rarity = "Brainrot God", Price = 32500000, Generation = 185000},
    ["Gattito Tacoto"] = {Rarity = "Brainrot God", Price = 32500000, Generation = 165000},
    ["Ballerino Lololo"] = {Rarity = "Brainrot God", Price = 35000000, Generation = 200000},
    ["Bulbito Bandito Traktorito"] = {Rarity = "Brainrot God", Price = 35000000, Generation = 205000},
    ["Los Tungtungtungcitos"] = {Rarity = "Brainrot God", Price = 37500000, Generation = 210000},
    ["Pakrahmatmamat"] = {Rarity = "Brainrot God", Price = 37500000, Generation = 215000},
    ["Piccione Macchina"] = {Rarity = "Brainrot God", Price = 40000000, Generation = 225000},
    ["Brr es Teh Patipum"] = {Rarity = "Brainrot God", Price = 40000000, Generation = 225000},
    ["Los Bombinitos"] = {Rarity = "Brainrot God", Price = 42500000, Generation = 220000},
    ["Tractoro Dinosauro"] = {Rarity = "Brainrot God", Price = 42500000, Generation = 230000},
    ["Orcalita Orcala"] = {Rarity = "Brainrot God", Price = 45000000, Generation = 240000},
    ["Los Orcalitos"] = {Rarity = "Brainrot God", Price = 45000000, Generation = 235000},
    ["Tartaruga Cisterna"] = {Rarity = "Brainrot God", Price = 45000000, Generation = 250000},
    ["Cacasito Satalito"] = {Rarity = "Brainrot God", Price = 45000000, Generation = 240000},
    ["Corn Corn Corn Sahur"] = {Rarity = "Brainrot God", Price = 45000000, Generation = 250000},
    ["Dug dug dug"] = {Rarity = "Brainrot God", Price = 45500000, Generation = 255000},
    ["Squalanana"] = {Rarity = "Brainrot God", Price = 45000000, Generation = 250000},
    ["Los Tipi Tacos"] = {Rarity = "Brainrot God", Price = 46000000, Generation = 260000},
    ["Crabbo Limonetta"] = {Rarity = "Brainrot God", Price = 46000000, Generation = 235000},
    ["Piccionetta Macchina"] = {Rarity = "Brainrot God", Price = 47000000, Generation = 270000},
    ["Mastodontico Telepiedone"] = {Rarity = "Brainrot God", Price = 47500000, Generation = 275000},
    ["Anpali Babel"] = {Rarity = "Brainrot God", Price = 48000000, Generation = 280000},
    ["Bombardini Tortinii"] = {Rarity = "Brainrot God", Price = 50000000, Generation = 225000},
    ["Brasilini Berimbini"] = {Rarity = "Brainrot God", Price = 55000000, Generation = 285000},
    ["Belula Beluga"] = {Rarity = "Brainrot God", Price = 60000000, Generation = 290000},
    ["Pop Pop Sahur"] = {Rarity = "Brainrot God", Price = 65000000, Generation = 295000},
    ["La Vacca Saturno Saturnita"] = {Rarity = "Secret", Price = 50000000, Generation = 300000},
    ["Sammyni Spyderini"] = {Rarity = "Secret", Price = 75000000, Generation = 325000},
    ["Blackhole Goat"] = {Rarity = "Secret", Price = 75000000, Generation = 400000},
    ["Bisonte Giuppitere"] = {Rarity = "Secret", Price = 75000000, Generation = 300000},
    ["Agarrini la Palini"] = {Rarity = "Secret", Price = 80000000, Generation = 425000},
    ["Chachechi"] = {Rarity = "Secret", Price = 85000000, Generation = 400000},
    ["Los Tortus"] = {Rarity = "Secret", Price = 100000000, Generation = 500000},
    ["Trenostruzzo Turbo 4000"] = {Rarity = "Secret", Price = 100000000, Generation = 310000},
    ["Karkerkar Kurkur"] = {Rarity = "Secret", Price = 100000000, Generation = 300000},
    ["Los Matteos"] = {Rarity = "Secret", Price = 100000000, Generation = 300000},
    ["Los Tralaleritos"] = {Rarity = "Secret", Price = 100000000, Generation = 500000},
    ["La Cucaracha"] = {Rarity = "Secret", Price = 110000000, Generation = 475000},
    ["Guerriro Digitale"] = {Rarity = "Secret", Price = 120000000, Generation = 550000},
    ["Fragola La La La"] = {Rarity = "Secret", Price = 125000000, Generation = 450000},
    ["Extinct Tralalero"] = {Rarity = "Secret", Price = 125000000, Generation = 450000},
    ["Torrtuginni Dragonfrutini"] = {Rarity = "Secret", Price = 125000000, Generation = 350000},
    ["Los Spyderinis"] = {Rarity = "Secret", Price = 125000000, Generation = 425000},
    ["Yess my examine"] = {Rarity = "Secret", Price = 130000000, Generation = 575000},
    ["Extinct Matteo"] = {Rarity = "Secret", Price = 140000000, Generation = 625000},
    ["Dul Dul Dul"] = {Rarity = "Secret", Price = 150000000, Generation = 375000},
    ["Las Tralaleritas"] = {Rarity = "Secret", Price = 150000000, Generation = 650000},
    ["La Karkerkar Combinasion"] = {Rarity = "Secret", Price = 160000000, Generation = 600000},
    ["Job Job Job Sahur"] = {Rarity = "Secret", Price = 175000000, Generation = 700000},
    ["Karker Sahur"] = {Rarity = "Secret", Price = 185000000, Generation = 725000},
    ["Las Vaquitas Saturnitas"] = {Rarity = "Secret", Price = 200000000, Generation = 750000},
    ["Los Karkeritos"] = {Rarity = "Secret", Price = 200000000, Generation = 750000},
    ["Perrito Burrito"] = {Rarity = "Secret", Price = 250000000, Generation = 1000000},
    ["Graipuss Medussi"] = {Rarity = "Secret", Price = 250000000, Generation = 1000000},
    ["Nooo My Hotspot"] = {Rarity = "Secret", Price = 500000000, Generation = 1500000},
    ["Los Jobcitos"] = {Rarity = "Secret", Price = 500000000, Generation = 1500000},
    ["Noo my examine"] = {Rarity = "Secret", Price = 525000000, Generation = 1750000},
    ["La Sahur Combinasion"] = {Rarity = "Secret", Price = 550000000, Generation = 2000000},
    ["To to to Sahur"] = {Rarity = "Secret", Price = 575000000, Generation = 2250000},
    ["Pot Hotspot"] = {Rarity = "Secret", Price = 600000000, Generation = 2500000},
    ["Quesadilla Crocodila"] = {Rarity = "Secret", Price = 700000000, Generation = 3000000},
    ["Quesadillo Vampiro"] = {Rarity = "Secret", Price = 750000000, Generation = 3500000},
    ["Chicleteira Bicicleteira"] = {Rarity = "Secret", Price = 750000000, Generation = 3500000},
    ["Los Nooo My Hotspotsitos"] = {Rarity = "Secret", Price = 1000000000, Generation = 5500000},
    ["La Grande Combinasion"] = {Rarity = "Secret", Price = 1000000000, Generation = 10000000},
    ["Los Chicleteiras"] = {Rarity = "Secret", Price = 1200000000, Generation = 7000000},
    ["67"] = {Rarity = "Secret", Price = 1250000000, Generation = 7500000},
    ["Mariachi Corazoni"] = {Rarity = "Secret", Price = 1750000000, Generation = 12500000},
    ["Los Combinasionas"] = {Rarity = "Secret", Price = 2000000000, Generation = 15000000},
    ["Tacorita Bicicleta"] = {Rarity = "Secret", Price = 2250000000, Generation = 16500000},
    ["Las Sis"] = {Rarity = "Secret", Price = 2500000000, Generation = 17500000},
    ["Chillin Chili"] = {Rarity = "Secret", Price = 2500000000, Generation = 25000000},
    ["Chipso and Queso"] = {Rarity = "Secret", Price = 2500000000, Generation = 25000000},
    ["Nuclearo Dinossauro"] = {Rarity = "Secret", Price = 2500000000, Generation = 15000000},
    ["Money Money Puggy"] = {Rarity = "Secret", Price = 2600000000, Generation = 21000000},
    ["Burrito Bandito"] = {Rarity = "Secret", Price = 800000000, Generation = 4000000},
    ["Los Bros"] = {Rarity = "Secret", Price = 2600000000, Generation = 24000000},
    ["Celularcini Viciosini"] = {Rarity = "Secret", Price = 2750000000, Generation = 22500000},
    ["Los 67"] = {Rarity = "Secret", Price = 2750000000, Generation = 22500000},
    ["Tralaledon"] = {Rarity = "Secret", Price = 3000000000, Generation = 27500000},
    ["Los Hotspotsitos"] = {Rarity = "Secret", Price = 3000000000, Generation = 20000000},
    ["La Extinct Grande"] = {Rarity = "Secret", Price = 3250000000, Generation = 23500000},
    ["Esok Sekolah"] = {Rarity = "Secret", Price = 3500000000, Generation = 30000000},
    ["Los Primos"] = {Rarity = "Secret", Price = 3750000000, Generation = 31000000},
    ["Los Tacoritas"] = {Rarity = "Secret", Price = 4000000000, Generation = 32000000},
    ["Tang Tang Keletang"] = {Rarity = "Secret", Price = 4500000000, Generation = 33500000},
    ["Ketupat Kepat"] = {Rarity = "Secret", Price = 5000000000, Generation = 35000000},
    ["Tictac Sahur"] = {Rarity = "Secret", Price = 6000000000, Generation = 37500000},
    ["La Supreme Combinasion"] = {Rarity = "Secret", Price = 7000000000, Generation = 40000000},
    ["Ketchuru and Musturu"] = {Rarity = "Secret", Price = 7500000000, Generation = 42500000},
    ["Garama and Madundung"] = {Rarity = "Secret", Price = 10000000000, Generation = 50000000},
    ["Spaghetti Tualetti"] = {Rarity = "Secret", Price = 15000000000, Generation = 60000000},
    ["La Secret Combinasion"] = {Rarity = "Secret", Price = 50000000000, Generation = 125000000},
    ["Burguro And Fryuro"] = {Rarity = "Secret", Price = 75000000000, Generation = 150000000},
    ["Dragon Cannelloni"] = {Rarity = "Secret", Price = 200000000000, Generation = 200000000},
    ["Strawberry Elephant"] = {Rarity = "OG", Price = 500000000000, Generation = 350000000},
    ["Zombie Tralala"] = {Rarity = "Secret", Price = 100000000, Generation = 500000},
    ["Vulturino Skeletono"] = {Rarity = "Secret", Price = 110000000, Generation = 500000},
    ["Frankentteo"] = {Rarity = "Secret", Price = 175000000, Generation = 700000},
    ["La Vacca Jacko Linterino"] = {Rarity = "Secret", Price = 225000000, Generation = 850000},
    ["Chicleteirina Bicicleteirina"] = {Rarity = "Secret", Price = 850000000, Generation = 4000000},
    ["Eviledon"] = {Rarity = "Secret", Price = 3850000000, Generation = 31500000},
    ["La Spooky Grande"] = {Rarity = "Secret", Price = 2900000000, Generation = 24500000},
    ["Los Mobilis"] = {Rarity = "Secret", Price = 2700000000, Generation = 22000000},
    ["Meowl"] = {Rarity = "OG", Price = 350000000000, Generation = 275000000},
    ["Mummy Ambalabu"] = {Rarity = "Brainrot God", Price = 45000000, Generation = 250000},
    ["Jackorilla"] = {Rarity = "Secret", Price = 80000000, Generation = 315000},
    ["Cappuccino Clownino"] = {Rarity = "Brainrot God", Price = 48500000, Generation = 285000},
    ["Headless Horseman"] = {Rarity = "Secret", Price = 150000000000, Generation = 175000000},
    ["Noo My Candy"] = {Rarity = "Secret", Price = 90000000, Generation = 5000000},
    ["Skull Skull Skull"] = {Rarity = "Brainrot God", Price = 60000000, Generation = 290000},
    ["Telemorte"] = {Rarity = "Secret", Price = 550000000, Generation = 2000000},
    ["Pumpkini Spyderini"] = {Rarity = "Secret", Price = 165000000, Generation = 650000},
    ["Trickolino"] = {Rarity = "Secret", Price = 235000000, Generation = 900000},
    ["Los Spooky Combinasionas"] = {Rarity = "Secret", Price = 3000000000, Generation = 20000000},
    ["La Casa Boo"] = {Rarity = "Secret", Price = 40000000000, Generation = 100000000},
    ["Mieteteira Bicicleteira"] = {Rarity = "Secret", Price = 2750000000, Generation = 26000000},
    ["Rang Ring Bus"] = {Rarity = "Secret", Price = 1100000000, Generation = 6000000},
    ["Spooky and Pumpky"] = {Rarity = "Secret", Price = 25000000000, Generation = 80000000},
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
