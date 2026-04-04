 [[ SHINNEN HUB | MASTER LOADER V5 ]] --
local currentId = tostring(game.PlaceId)

-- [ 🔗 ใส่ URL หลักที่เก็บไฟล์ GitHub ของคุณ ]
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

-- [ 📋 ตารางแมพ (แมพไหนรันไฟล์ไหน) ]
local MapConfig = {
    ["100400297022629"] = "Games1.lua", 
    ["286090429"] = "Games2.lua", 
    ["14469379009"] = "Games3.lua", 
    -- เพิ่ม ID แมพต่อไปได้ที่นี่...
}

local fileName = MapConfig[currentId]

if fileName then
    -- 🚀 ระบบดึงไฟล์สคริปต์เฉพาะแมพ
    local success, content = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)

    if success and content then
        -- ตรวจสอบและรัน UI ใหม่
        local func, err = loadstring(content)
        if func then
            print("✅ N-SHINNEN HUB : โหลดไฟล์ " .. fileName .. " สำเร็จ")
            func() 
        else
            warn("❌ สคริปต์ในไฟล์ " .. fileName .. " มีจุดผิด: " .. tostring(err))
        end
    else
        warn("❌ ไม่สามารถดึงไฟล์ " .. fileName .. " จาก GitHub ได้")
    end
else
    -- 🌐 กรณีรันแมพที่ไม่ได้ตั้งค่าไว้ (โหลด UI กลาง)
    print("❓ ไม่พบค่าเฉพาะแมพ โหลด UI มาตรฐาน...")
    pcall(function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/ca3ee71cb4c922c5055bca31b4fa9578/raw/145adea59e4bfc4c4273b7e8b6b925d8969cae49/HIUISHINNEN"))()
    end)
end
