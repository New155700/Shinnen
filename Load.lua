-- [[ SHINNEN HUB | 100% WORKING LOADER ]] --
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"
local currentId = game.PlaceId

local MapScripts = {
    [85638494463963] = "Games1.lua",
    [96255502718881] = "Games2.lua"
}

local fileName = MapScripts[currentId]

if fileName then
    -- ถ้าเจอไอดี ให้โหลดไฟล์นั้นทันที
    loadstring(game:HttpGet(baseUrl .. fileName))()
else
    -- ถ้าไม่เจอไอดี ให้บังคับโหลด Games1.lua ไปก่อน (กันเหนียว)
    warn("ID Not Found ("..tostring(currentId).."), Force Loading Games1")
    loadstring(game:HttpGet(baseUrl .. "Games1.lua"))()
end
