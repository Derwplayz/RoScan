-- Combined Animal Scanner + Auto Server Joiner
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Print server job ID
print("🆔 Server Job ID: " .. game.JobId)
print("")

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

-- Job IDs for server hopping (will be loaded from Pastefy)
local jobIds = {}
local currentIndex = 1

-- Function to check if UUID (player plot)
local function isUUID(name)
    local uuidPattern = "^[a-f0-9]+%-[a-f0-9]+%-[a-f0-9]+%-[a-f0-9]+%-[a-f0-9]+$"
    return name:match(uuidPattern) ~= nil
end

-- Function to format number with commas
local function formatNumber(num)
    local formatted = tostring(num)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Function to save data using writefile
local function saveScanData(scanResults)
    local timestamp = DateTime.now():FormatLocalTime("Lua", "en-us")
    local fileName = "AnimalScan_" .. game.JobId .. "_" .. HttpService:GenerateGUID(false) .. ".txt"
    
    local fileContent = ""
    
    -- Add header
    fileContent = fileContent .. "=== ANIMAL SCAN RESULTS ===\n"
    fileContent = fileContent .. "Server Job ID: " .. game.JobId .. "\n"
    fileContent = fileContent .. "Scan Time: " .. timestamp .. "\n"
    fileContent = fileContent .. "Total Animals Found: " .. scanResults.totalFound .. "\n"
    fileContent = fileContent .. "Total Value: $" .. formatNumber(scanResults.totalValue) .. "\n\n"
    
    -- Add animals found
    fileContent = fileContent .. "=== ANIMALS FOUND ===\n"
    for _, animal in ipairs(scanResults.animals) do
        fileContent = fileContent .. "✓ " .. animal.name .. " (" .. animal.rarity .. ") in " .. animal.plot .. " - $" .. formatNumber(animal.price) .. " (Gen " .. animal.generation .. ")\n"
    end
    
    -- Save using writefile
    local success, message = pcall(function()
        writefile(fileName, fileContent)
        return true
    end)
    
    if success then
        print("💾 Scan data saved successfully as: " .. fileName)
    else
        print("❌ Failed to save scan data: " .. tostring(message))
    end
end

-- Main scanning function
local function scanForValuableAnimals()
    print("🔍 Scanning for valuable animals...")
    print("")
    
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then
        print("❌ No Plots folder found")
        return
    end
    
    local totalFound = 0
    local totalValue = 0
    local animalsFound = {}
    
    -- Scan each plot
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        local plotName = plot.Name
        
        -- Only scan player plots (UUIDs)
        if isUUID(plotName) then
            -- Recursive function to scan folders
            local function scanFolder(folder)
                for _, item in ipairs(folder:GetChildren()) do
                    -- Check if this item name matches any valuable animal
                    local animalData = animalDatabase[item.Name]
                    if animalData then
                        totalFound = totalFound + 1
                        totalValue = totalValue + animalData.Price
                        
                        -- Store animal data for saving
                        table.insert(animalsFound, {
                            name = item.Name,
                            plot = plotName,
                            rarity = animalData.Rarity,
                            price = animalData.Price,
                            generation = animalData.Generation
                        })
                        
                        -- Print with Generation and Price
                        print("✓ Found " .. item.Name .. " (" .. animalData.Rarity .. ") in " .. plotName .. " - $" .. formatNumber(animalData.Price) .. " (Gen " .. animalData.Generation .. ")")
                    end
                    
                    -- Recursively scan subfolders
                    if item:IsA("Folder") then
                        scanFolder(item)
                    end
                end
            end
            
            -- Start scanning this plot
            scanFolder(plot)
        end
    end
    
    print("")
    print("📊 Scan Complete:")
    print("   Total Animals Found: " .. totalFound)
    print("   Total Value: $" .. formatNumber(totalValue))
    print("   Server Job ID: " .. game.JobId)
    
    -- Save the scan results
    if totalFound > 0 then
        print("")
        saveScanData({
            totalFound = totalFound,
            totalValue = totalValue,
            animals = animalsFound
        })
    else
        print("")
        print("💾 No valuable animals found to save.")
    end
end

-- Function to load job IDs from Pastefy
local function loadJobIds()
    print("🔄 Loading server list from Pastefy...")
    
    local success, result = pcall(function()
        -- Load the job IDs from Pastefy
        local response = game:HttpGet("https://pastefy.app/FHSelDnn/raw")
        
        -- Extract the jobIds table from the loaded script
        local jobIdsTable = {}
        
        -- Find the jobIds table in the loaded script
        for line in response:gmatch("[^\r\n]+") do
            if line:match("local jobIds = {") then
                -- Extract all the IDs from the table
                for id in response:gmatch('"([a-f0-9%-]+)"') do
                    table.insert(jobIdsTable, id)
                end
                break
            end
        end
        
        return jobIdsTable
    end)
    
    if success and #result > 0 then
        jobIds = result
        print("✅ Loaded " .. #jobIds .. " server IDs")
    else
        print("❌ Failed to load server IDs, using fallback list")
        -- Fallback to some default IDs
        jobIds = {
            "954cc406-7c09-4394-8b7f-94e3657b5dcf",
            "c4e49a71-d26b-4d87-bb59-86afe43add05", 
            "b0b1c1b8-579e-4535-bcf1-2509c9d83f61",
        }
    end
end

-- Function to join next server
local function joinNextServer()
    if #jobIds == 0 then
        loadJobIds()
    end
    
    if #jobIds > 0 then
        local jobId = jobIds[currentIndex]
        print("🚀 Trying to join server: " .. jobId)
        
        local success, error = pcall(function()
            TeleportService:TeleportToPlaceInstance(109983668079237, jobId, game.Players.LocalPlayer)
        end)
        
        if success then
            print("✅ Teleport initiated!")
        else
            print("❌ Teleport failed: " .. error)
            -- Try next ID
            currentIndex = currentIndex + 1
            if currentIndex > #jobIds then
                currentIndex = 1
            end
        end
    else
        print("❌ No job IDs available")
    end
end

-- Main execution
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

-- Step 2: Load job IDs and join next server
loadJobIds()
joinNextServer()
