local currentId = game.PlaceId
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapScripts = {
    [85638494463963] = "Games1.lua", -- แมพเก่า
    [96255502718881] = "Games2.lua", -- แมพ DUEL Warriors (เลขจากรูป 5165)
}

if MapScripts[currentId] then
    local fileName = MapScripts[currentId]
    loadstring(game:HttpGet(baseUrl .. fileName))()
else
    -- ถ้าไม่เจอไอดี ไม่ต้องเตะ! ให้มันบอกเลขมาเลยจะได้แก้ถูก
    warn("Shinnen Hub: ไม่พบไอดีนี้ -> " .. tostring(currentId))
end
nd
