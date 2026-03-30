-- [[ SHINNEN HUB | OFFICIAL LOADER ]] --
local currentId = game.PlaceId
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapScripts = {
    [85638494463963] = "Games1.lua",
    [96255502718881] = "Games2.lua"
}

if MapScripts[currentId] then
    local fileName = MapScripts[currentId]
    print("Shinnen Hub: Found Map! Loading " .. fileName)
    loadstring(game:HttpGet(baseUrl .. fileName))()
else
    -- ถ้าหาไอดีไม่เจอ ให้เด้งออกและบอกเลขไอดีที่หน้าจอ
    game:GetService("Players").LocalPlayer:Kick("ID NOT FOUND: " .. tostring(currentId))
end
