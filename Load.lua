print("1. เริ่มทำงาน Master Loader...")

local currentId = tostring(game.PlaceId)
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/" -- เช็คตัว S ใหญ่/เล็กดีๆ

local MapConfig = {
    ["100400297022629"] = "Games1.lua",
    ["96255502718881"] = "Games2.lua",
    ["14469379009"] = "Games3.lua"
}

local fileName = MapConfig[currentId]
print("2. ตรวจสอบแมพไอดี: " .. currentId)

if fileName then
    print("3. พบไฟล์ที่ต้องโหลด: " .. fileName)
    
    local success, content = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)
    
    if success then
        print("4. ดึงข้อมูลจาก GitHub สำเร็จ!")
        local func, err = loadstring(content)
        if func then
            print("5. โหลดโค้ดลงเครื่องสำเร็จ กำลังเริ่มรันเมนู...")
            func()
        else
            warn("!!! Syntax Error (โค้ดข้างในไฟล์พัง): " .. tostring(err))
        end
    else
        warn("!!! Http Error (ดึงไฟล์ไม่ได้): " .. tostring(content))
    end
else
    warn("!!! แมพไอดีนี้ไม่อยู่ในลิสต์ Whitelist")
end
