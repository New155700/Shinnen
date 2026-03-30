local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"
local currentId = tostring(game.PlaceId)

-- รายการแมพเฉพาะทาง (ถ้ามีไฟล์แยกแมพ)
local MapScripts = {
    ["123456789"] = "Games.lua",
    ["987654321"] = "Games1.lua", -- แมพที่คุณรันติด
}

if MapScripts[currentId] then
    -- ถ้าเจอไอดีแมพในลิสต์ ให้โหลดไฟล์เฉพาะแมพนั้น
    loadstring(game:HttpGet(baseUrl .. MapScripts[currentId]))()
else
    -- ถ้าไม่เจอ (แมพอื่นๆ ทั่วไป) ให้โหลดไฟล์หลัก (Universal) แทน
    -- คุณต้องสร้างไฟล์ชื่อ Main.lua ไว้ใน GitHub ด้วยนะครับ
    loadstring(game:HttpGet(baseUrl .. "Main.lua"))()
end
.. ")")
end
