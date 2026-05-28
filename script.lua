-- UhhhhhhReanim Executor Folder Scanner + Colored Output
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

-- ================== COLORED PRINT MODULE ==================
--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local Modules = {
    Colors = {
        ["Green"] = "0,255,0",
        ["Cyan"] = "33, 161, 163",
        ["Yellow"] = "255,255,0",
        ["Red"] = "255,0,0",
        ["White"] = "255,255,255"
    }
}

Modules.ChangeColor = function() 
    game:GetService("RunService").Heartbeat:Connect(function()
    	if game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster") then 
	        for _, v in pairs(game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster"):GetDescendants()) do 
	            if v:IsA("TextLabel") then 
	                v.RichText = true 
	            end 
	        end 
	    end
    end)
end

Modules.print = function(color, text, size)
	if not Modules.Colors[color] then 
		warn("Color was not found!")
		return 
	end 
	
    local Text = '<font color="rgb(' .. Modules.Colors[color] .. ')"'
    if size then
        Text = Text .. ' size="' .. tostring(size) .. '"'
    end
    Text = Text .. '>' .. tostring(text) .. '</font>'
    print(Text)
end

Modules.ChangeColor()

-- ================== EXECUTOR FOLDER SCAN ==================
Modules.print("Cyan", "🔍 Checking for UhhhhhhReanim folder in executor workspace...")

local folderName = "UhhhhhhReanim"

if not isfolder(folderName) then
    Modules.print("Red", "❌ UhhhhhhReanim folder not found in executor workspace.")
    Modules.print("Yellow", "Create the folder next to your executor.")
    return
end

Modules.print("Green", "✅ Found UhhhhhhReanim folder! Scanning contents...")

local files = listfiles(folderName)

Modules.print("Cyan", "📂 Found " .. #files .. " items.")

for _, filePath in ipairs(files) do
    local fileName = filePath:match("([^/\\]+)$")
    
    Modules.print("White", "\n📄 File: " .. fileName)
    
    if fileName:lower():find("%.lua$") or fileName:lower():find("%.luau$") then
        local success, content = pcall(function()
            return readfile(filePath)
        end)
        
        if success and content and #content > 0 then
            Modules.print("Green", "   📜 Lua file (" .. #content .. " chars)")
            local preview = content:sub(1, 450)
            if #content > 450 then 
                preview = preview .. "\n... (truncated)" 
            end
            print(preview)  -- raw print for code preview
        else
            Modules.print("Red", "   ⚠️ Could not read file")
        end
    else
        Modules.print("Yellow", "   🔹 Other file type")
    end
end

Modules.print("Green", "\n✅ Executor folder scan finished!")
