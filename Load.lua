-- [[ SHINNEN HUB | FIXED LOADER ]] --
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"
local currentId = tonumber(game.PlaceId) -- แปลงเป็นตัวเลขให้ชัวร์

local MapScripts = {
    [16281635412] = "Games1.lua",
    [100400297022629] = "Games2.lua",
}

-- ตรวจสอบว่าไอดีอยู่ในรายการไหม
if MapScripts[currentId] then
    local success, err = pcall(function()
        loadstring(game:HttpGet(baseUrl .. MapScripts[currentId]))()
    end)
    
    if not success then
        -- ถ้าโหลดไฟล์ไม่ได้ (เช่น ชื่อไฟล์ผิด) ให้แจ้งเตือนแทนเตะ
        warn("Shinnen Hub: ไม่สามารถโหลดไฟล์ " .. MapScripts[currentId] .. " ได้")
    end
else
    -- แก้ไข: ถ้าไม่เจอไอดี ให้พิมพ์บอกใน F9 แทนการ Kick (เพื่อเช็กเลขไอดีจริง)
    print("Your current PlaceId is: " .. tostring(currentId))
    warn("แมพนี้ยังไม่ได้ลงทะเบียน! กรุณาก๊อปเลขด้านบนไปใส่ใน Load.lua")
    
    -- ถ้าอยากให้เตะเฉพาะตอนมั่นใจแล้วค่อยเปิดบรรทัดล่างนี้ครับ
    -- game.Players.LocalPlayer:Kick("แมพนี้ไม่ได้รับอนุญาต!")
end
