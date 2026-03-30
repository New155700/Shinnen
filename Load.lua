-- [[ SHINNEN HUB | OFFICIAL LOAD ]] --
local currentId = tostring(game.PlaceId)
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapScripts = {
    ["100400297022629"] = "Games1.lua",
    ["96255502718881"] = "Games2.lua"
}

local fileName = MapScripts[currentId]

if fileName then
    print("Shinnen Hub: Loading " .. fileName)
    local success, content = pcall(function() return game:HttpGet(baseUrl .. fileName) end)
    if success then
        loadstring(content)()
    else
        warn("Shinnen Hub: Connection Error!")
    end
else
    -- ถ้าไม่เจอไอดี ให้รัน Games1 เป็นหลัก จะได้ไม่นิ่ง
    loadstring(game:HttpGet(baseUrl .. "Games1.lua"))()
end
