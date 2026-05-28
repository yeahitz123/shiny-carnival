-- UhhhhhhReanim Executor Folder Scanner
print("🔐 Loading UhhhhhhReanim executor folder scanner...")

-- ================== CONFIG ==================
local baseUrl = "https://shiny-carnival-kappa.vercel.app/"

local ownerData = game:HttpGet(baseUrl .. "owner.txt")
local blacklistData = game:HttpGet(baseUrl .. "blacklisted.txt")

local OWNER_USERNAME = ownerData:match("^%s*(.-)%s*$")

local BlacklistedPlayers = {}
for line in blacklistData:gmatch("[^\r\n]+") do
    local trimmed = line:match("^%s*(.-)%s*$")
    if trimmed and trimmed ~= "" then
        table.insert(BlacklistedPlayers, trimmed)
    end
end

-- Access Check
local player = game.Players.LocalPlayer
if player.Name ~= OWNER_USERNAME then
    if table.find(BlacklistedPlayers, player.Name) then
        player:Kick("You are blacklisted.")
        return
    end
    warn("❌ Access denied. Owner only.")
    return
end

print("✅ Owner access granted for " .. player.Name)

-- ================== EXECUTOR FOLDER SCAN ==================
print("🔍 Checking for UhhhhhhReanim folder in executor workspace...")

local folderName = "UhhhhhhReanim"

if not isfolder(folderName) then
    warn("❌ UhhhhhhReanim folder not found in executor workspace.")
    print("Create the folder next to your executor.")
    return
end

print("✅ Found UhhhhhhReanim folder! Scanning contents...")

local files = listfiles(folderName)

print("📂 Found " .. #files .. " items.")

for _, filePath in ipairs(files) do
    local fileName = filePath:match("([^/\\]+)$")
    
    print("\n📄 File: " .. fileName)
    
    if fileName:lower():find("%.lua$") or fileName:lower():find("%.luau$") then
        local success, content = pcall(function()
            return readfile(filePath)
        end)
        
        if success and content and #content > 0 then
            print("   📜 Lua file (" .. #content .. " chars)")
            local preview = content:sub(1, 450)
            if #content > 450 then 
                preview = preview .. "\n... (truncated)" 
            end
            print(preview)
        else
            print("   ⚠️ Could not read file")
        end
    else
        print("   🔹 Other file type")
    end
end

print("\n✅ Executor folder scan finished!")
