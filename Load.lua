local Scripts = {
    [85638494463963] = "Games1.lua",
    [96255502718881] = "Games2.lua"  -- แก้เลขนี้ให้เป็น 96255502718881 (เลขจากรูป 5165)
}

local name = Scripts[game.PlaceId]
local url = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

if name then
    loadstring(game:HttpGet(url .. name))()
else
    -- ถ้าหาไม่เจอ ให้มัน print เลขออกมาดูใน F9 แทนการ Kick จะได้ไม่เด้ง
    warn("ID NOT FOUND: " .. tostring(game.PlaceId))
end
