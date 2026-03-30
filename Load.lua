-- [[ SHINNEN HUB | FIXED ID ]] --
local currentId = tonumber(game.PlaceId)
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapScripts = {
    ["100400297022629"] = "Games1.lua",
    ["96255502718881"] = "Games2.lua"
}

-- เช็คแบบแปลงเป็นตัวหนังสือเพื่อความแม่นยำ 100%
local fileName = MapScripts[tostring(currentId)]

if fileName then
    local success, result = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)
    if success and result then
        loadstring(result)()
    end
else
    -- ถ้ายังไม่เจอ ให้มันเด้งบอกเลขที่ระบบมองเห็นจริงๆ
    game.Players.LocalPlayer:Kick("SYSTEM ID: " .. tostring(currentId))
end
