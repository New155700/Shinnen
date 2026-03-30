local MapScripts = {
    [85638494463963] = "Games1.lua",
    [96255502718881] = "Games2.lua"
}

local scriptName = MapScripts[game.PlaceId]

if scriptName then
    local url = "https://raw.githubusercontent.com/New155700/Shinnen/main/" .. scriptName
    loadstring(game:HttpGet(url))()
else
    game.Players.LocalPlayer:Kick("ไม่รองรับแมพนี้ไอดี: " .. tostring(game.PlaceId))
end
