-- [[ SHINNEN HUB | FINAL DEBUG ]] --
print("Starting Shinnen Hub...")

local success, result = pcall(function()
    local currentId = game.PlaceId
    local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"
    local MapScripts = {
        [85638494463963] = "Games1.lua",
        [96255502718881] = "Games2.lua",
    }

    if MapScripts[currentId] then
        local fileName = MapScripts[currentId]
        print("Found Map! Loading: " .. fileName)
        loadstring(game:HttpGet(baseUrl .. fileName))()
    else
        game.Players.LocalPlayer:Kick("ID NOT FOUND: " .. tostring(currentId))
    end
end)

if not success then
    print("FATAL ERROR: " .. tostring(result))
    warn("สคริปต์พังเพราะ: " .. tostring(result))
end
