local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"
local currentId = game.PlaceId

-- 1. รายชื่อแมพที่อนุญาตให้เข้าใช้งาน (Whitelist)
local MapScripts = {
    [16281635412] = "Games1.lua",   -- แมพแรกที่คุณทำ
    [100400297022629] = "Games2.lua",   -- แมพที่สอง (สร้างไฟล์ชื่อนี้รอไว้)
}

-- 2. ตรวจสอบไอดีแมพ
if MapScripts[currentId] then
    -- ถ้าเข้าแมพที่ถูกต้อง ระบบจะไปดึงสคริปต์ของแมพนั้นมาใช้
    local fileName = MapScripts[currentId]
    loadstring(game:HttpGet(baseUrl .. fileName))()
else
    -- 3. ถ้าเข้าแมพที่ไม่อยู่ในรายการ ให้เตะออกทันที (Kick)
    game.Players.LocalPlayer:Kick("Shinnen Hub: แมพนี้ไม่ได้รับอนุญาตให้ใช้งานสคริปต์!")
end
