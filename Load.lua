-- [[ SHINNEN HUB | ULTIMATE STABLE LOADER ]] --
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- แจ้งเตือนว่าสคริปต์เริ่มทำงานแล้ว
Rayfield:Notify({Title = "Shinnen Hub", Content = "กำลังตรวจสอบไอดีแมพ...", Duration = 3})

local currentId = tonumber(game.PlaceId)
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

-- รายการแมพ
local MapScripts = {
    [16281635412] = "Games1.lua",
    [100400297022629] = "Games2.lua",
}

if MapScripts[currentId] then
    local fileName = MapScripts[currentId]
    Rayfield:Notify({Title = "Success", Content = "กำลังโหลดไฟล์: " .. fileName, Duration = 3})
    
    -- โหลดไฟล์จาก GitHub
    local success, content = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)

    if success and content then
        loadstring(content)()
    else
        Rayfield:Notify({Title = "Error", Content = "หาไฟล์ใน GitHub ไม่เจอ! เช็คชื่อไฟล์ด่วน", Duration = 5})
    end
else
    -- ถ้าไม่เจอไอดี ให้บอกเลขไอดีกลางหน้าจอเลย ไม่ต้องเปิด F9
    Rayfield:Notify({Title = "ID Not Found", Content = "แมพนี้ไอดี: " .. tostring(currentId) .. " (ยังไม่ได้เพิ่มใน Load.lua)", Duration = 10})
    print("คัดลอกเลขนี้ไปใส่ใน GitHub: " .. tostring(currentId))
end
