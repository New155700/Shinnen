-- [[ SHINNEN HUB | THE REAL LOADER ]] --
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/Load.lua"
local currentId = game.PlaceId

-- 1. รายชื่อแมพ (ต้องระบุว่า ID นี้ ให้ไปเปิดไฟล์ชื่ออะไร)
local MapScripts = {
    [16281635412] = "Games1.lua",      -- ไอดีแมพแรก
    [100400297022629] = "Games2.lua",   -- ไอดีแมพ DUEL Warriors
}

-- 2. ตัวสั่งรัน
if MapScripts[currentId] then
    -- ถ้าไอดีตรง มันจะเอา baseUrl มาต่อกับชื่อไฟล์ เช่น .../main/Games2.lua
    local fileName = MapScripts[currentId]
    loadstring(game:HttpGet(baseUrl .. fileName))() 
else
    -- ถ้าไอดีไม่ตรง ให้พิมพ์บอกเลขไอดีจริงใน F9 (ช่วยให้คุณก๊อปไปเพิ่มเองได้ง่าย)
    warn("Shinnen Hub: ID นี้ยังไม่ได้เพิ่มลงในสคริปต์ -> " .. tostring(currentId))
end
