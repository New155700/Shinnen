-- เพิ่ม error handling
pcall(function()
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    -- ... rest of code
end)

-- หรือลองใช้ executor อื่น เช่��: Synapse X, KRNL, Fluxusrepeatt task.wait() until game:IsLoaded()

local BaseURL = "https://raw.githubusercontent.com/New155700/Shinnen/main/Games/"
local ScriptURL = BaseURL .. game.PlaceId .. ".lua"

local ok,res = pcall(game.HttpGet, game, ScriptURL)

if ok and res and not res:find("404") then
    loadstring(res)()
else
    warn("Game not supported")
end
