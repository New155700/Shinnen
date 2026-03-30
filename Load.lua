local currentId = game.PlaceId
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"
local MapScripts = {
    [85638494463963] = "Games1.lua",
    [96255502718881] = "Games2.lua",
}

if MapScripts[currentId] then
    print("Shinnen Hub: Loading " .. MapScripts[currentId])
    loadstring(game:HttpGet(baseUrl .. MapScripts[currentId]))()
else
    print("Shinnen Hub: ID NOT FOUND -> " .. tostring(currentId))
end
