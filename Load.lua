local Scripts = {
    [85638494463963] = "Games1.lua",
    [85638494463963] = "Games2.lua"
}

local name = Scripts[game.PlaceId]
local url = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

if name then
    loadstring(game:HttpGet(url .. name))()
else
    game.Players.LocalPlayer:Kick("ID NOT FOUND: " .. tostring(game.PlaceId))
end
