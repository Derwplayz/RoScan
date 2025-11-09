-- Auto Server Joiner - Reads from GitHub
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local GITHUB_RAW_URL = "https://raw.githubusercontent.com/Derwplayz/RoScan/main/job_ids.txt"

local jobIds = {}
local currentIndex = 1
local failedAttempts = 0

local function loadJobIds()
    print("📥 Loading job IDs from GitHub...")
    
    local success, result = pcall(function()
        local response = HttpService:GetAsync(GITHUB_RAW_URL)
        
        -- Split by new lines
        local ids = {}
        for line in response:gmatch("[^\r\n]+") do
            if #line > 10 then  -- Basic UUID validation
                table.insert(ids, line)
            end
        end
        
        return ids
    end)
    
    if success and #result > 0 then
        jobIds = result
        failedAttempts = 0
        print("✅ Loaded " .. #jobIds .. " job IDs from GitHub")
        return true
    else
        failedAttempts = failedAttempts + 1
        print("❌ Failed to load from GitHub (attempt " .. failedAttempts .. ")")
        return false
    end
end

local function joinNextServer()
    -- Reload if empty or too many failures
    if #jobIds == 0 or failedAttempts > 3 then
        loadJobIds()
    end
    
    if #jobIds > 0 then
        if currentIndex > #jobIds then
            currentIndex = 1
        end
        
        local jobId = jobIds[currentIndex]
        print("🚀 [" .. currentIndex .. "/" .. #jobIds .. "] Joining: " .. jobId)
        
        local success, errorMsg = pcall(function()
            TeleportService:TeleportToPlaceInstance(109983668079237, jobId, game.Players.LocalPlayer)
        end)
        
        if success then
            print("✅ Teleport initiated!")
            currentIndex = currentIndex + 1
            return true
        else
            print("❌ Teleport failed: " .. tostring(errorMsg))
            currentIndex = currentIndex + 1
            return false
        end
    else
        print("❌ No job IDs available")
        return false
    end
end

-- Main execution
print("🎯 GitHub Auto Server Joiner Started!")
print("📁 Repository: Derwplayz/RoScan")

-- Load initial job IDs
loadJobIds()

-- Join first server immediately
joinNextServer()

-- Continue joining servers every minute
while true do
    wait(60)
    joinNextServer()
end
