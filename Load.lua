-- [[ SHINNEN HUB | ADVANCED ID CHECK ]] --
local currentId = tostring(game.PlaceId) -- แปลงเป็นตัวหนังสือกันพลาด
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

-- พิมพ์เลขไอดีลงในเครื่องหมาย "" เพื่อความแม่นยำ
local MapScripts = {
    ["100400297022629"] = "Games1.lua",
    ["96255502718881"] = "Games2.lua"
}

print("Checking Server ID: " .. currentId)

local fileName = MapScripts[currentId]

if fileName then
    print("Map Found! Loading: " .. fileName)
    local success, result = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)
    
    if success and result then
        loadstring(result)()
    else
        warn("GitHub connection failed!")
    end
else
    -- ถ้ายังไม่เจออีก รอบนี้จะเด้งบอกเลขที่ 'เครื่องคุณอ่านได้จริง'
    game.Players.LocalPlayer:Kick("ID MISMATCH! Your ID is: " .. currentId)
end
