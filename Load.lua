-- [[ SHINNEN HUB | OFFICIAL MASTER LOADER ]] --
local currentId = tostring(game.PlaceId)
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

-- เคลียร์ของเก่าก่อนรัน (เพื่อความลื่นและป้องกัน UI ซ้อน)
pcall(function()
    if game.CoreGui:FindFirstChild("Rayfield") then game.CoreGui.Rayfield:Destroy() end
    if game.CoreGui:FindFirstChild("ShinnenInfo") then game.CoreGui.ShinnenInfo:Destroy() end
end)

-- รายชื่อแมพและไฟล์สคริปต์
local MapScripts = {
    ["100400297022629"] = "Games1.lua", -- ไฟล์สำหรับแมพ A
    ["96255502718881"] = "Games2.lua"  -- ไฟล์สำหรับแมพ B
}

local fileName = MapScripts[currentId] or "Games1.lua" -- ถ้าไม่เจอ ID ให้ดึง Games1 เป็นค่าเริ่มต้น

print("👿 Shinnen Hub: Syncing with " .. fileName)

-- ระบบโหลดแบบป้องกัน Cache (Anti-Cache) เพื่อให้ดึงไฟล์ล่าสุดเสมอ
local success, content = pcall(function() 
    return game:HttpGet(baseUrl .. fileName .. "?t=" .. os.time()) 
end)

if success and content then
    local func, err = loadstring(content)
    if func then
        -- ส่งผ่านตัวแปร Global เพื่อให้สคริปต์ในไฟล์คุยกับ Loader ได้ (ถ้าจำเป็น)
        _G.ShinnenVersion = "V37-Latest"
        func() 
    else
        warn("👿 Shinnen Hub: Script Error -> " .. tostring(err))
    end
else
    -- กรณีฉุกเฉิน: ถ้า GitHub ล่มหรือหาไฟล์ไม่เจอ
    warn("👿 Shinnen Hub: Connection Error! Checking Alternative...")
    pcall(function()
        loadstring(game:HttpGet(baseUrl .. "Games1.lua"))()
    end)
end
