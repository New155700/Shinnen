-- [[ SHINNEN HUB | RECOVERY LOAD ]] --
local currentId = game.PlaceId
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapScripts = {
    [100400297022629] = "Games1.lua",
    [96255502718881] = "Games2.lua"
}

if MapScripts[currentId] then
    local fileName = MapScripts[currentId]
    local success, result = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)
    
    if success and result then
        loadstring(result)()
    else
        warn("Shinnen Hub: Download Error!")
    end
else
    -- ถ้าหาไอดีไม่เจอ ให้เด้งบอกเลขไอดีทันที (จะได้เอาเลขไปแก้ใน GitHub ได้)
    game.Players.LocalPlayer:Kick("ID NOT FOUND: " .. tostring(currentId))
end
