local Scripts = {
    [85638494463963] = "Games1.lua",
    [96255502718881] = "Games2.lua"
}

local currentId = game.PlaceId
local fileName = Scripts[currentId]
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

if fileName then
    loadstring(game:HttpGet(baseUrl .. fileName))()
else
    -- ถ้าหาไอดีไม่เจอ ให้เด้งออกและบอกเลขไอดีมาเลย จะได้แก้ถูก
    game.Players.LocalPlayer:Kick("ID NOT FOUND: " .. tostring(currentId))
end
