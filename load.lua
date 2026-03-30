
local BaseURL = "https://raw.githubusercontent.com/New155700/Shinnen/main/Games/"
local ScriptURL = BaseURL .. 96255502718881.PlaceId .. ".lua"

local ok,res = pcall(game.HttpGet, game, ScriptURL)

if ok and res and not res:find("404") then
    loadstring(res)()
else
    warn("Game not supported")
end
