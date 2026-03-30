main Scripts = {
    [85638494463963] = "Games1.lua",
    [96255502718881] = "Games2.lua"
}

local name = Scripts[game.PlaceId]
local url = "https://raw.githubusercontent.com/New155700/Shinnen/main/Games1.lua"

if name then
    loadstring(game:HttpGet(url .. name))()
else
    -- ถ้าเลขไม่ตรง ไม่ต้องเด้ง แต่ให้โชว์เลขใน F9 จะได้รู้ว่าเลขอะไรกันแน่
    print("Map ID Not Found: " .. tostring(game.PlaceId))
end
