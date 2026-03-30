-- [[ SHINNEN HUB | THE ONLY WORKING LOADER ]] --
local currentId = game.PlaceId

-- 1. ตั้งค่าชื่อไฟล์ให้ตรงกับใน GitHub เป๊ะๆ (ตัว G ใหญ่)
local MapScripts = {
    [16281635412] = "Games1.lua",
    [100400297022629] = "Games2.lua",
}

-- 2. เช็คไอดีแมพ
if MapScripts[currentId] then
    local fileName = MapScripts[currentId]
    -- ใช้ลิงก์ตรงแบบ GitHub Raw ห้ามแก้บรรทัดนี้
    local url = "https://raw.githubusercontent.com/New155700/Shinnen/main/" .. fileName
    
    -- สั่งโหลดและรัน
    loadstring(game:HttpGet(url))()
else
    -- ถ้าไม่เจอไอดี ให้เตะออกตามความต้องการเดิมของคุณ
    game.Players.LocalPlayer:Kick("Shinnen Hub: ID " .. tostring(currentId) .. " ยังไม่ได้ลงทะเบียน!")
end
