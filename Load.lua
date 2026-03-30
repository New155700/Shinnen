-- [[ SHINNEN HUB | FORCE LOAD GAMES1 ]] --
local url = "https://raw.githubusercontent.com/New155700/Shinnen/main/Games1.lua"

print("Shinnen Hub: Connecting...")

local success, result = pcall(function()
    return game:HttpGet(url)
end)

if success then
    print("Shinnen Hub: Loading Games1.lua"
    loadstring(result)()
else
    warn("Shinnen Hub: Error - " .. tostring(result))
end
