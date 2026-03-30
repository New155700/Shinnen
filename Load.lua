-- กำหนด URL หลักของ Repository คุณ
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/987654321"

-- ตารางตรวจสอบ ID ของแมพ (PlaceId)
-- รูปแบบ: [ID ของแมพ] = "ชื่อไฟล์ที่ต้องการรัน"
local MapScripts = {
    [123456789] = "Games.lua",  -- เปลี่ยน 123456789 เป็น ID แมพจริง
    [987654321] = "Games1.lua", -- เพิ่มแมพอื่นๆ ได้ที่นี่
}

local currentId = game.PlaceId

-- ตรวจสอบว่าแมพปัจจุบันอยู่ในรายการที่รองรับหรือไม่
if MapScripts[currentId] then
    local fileName = MapScripts[currentId]
    local fullUrl = baseUrl .. fileName
    
    -- พยายามดึงโค้ดจาก GitHub
    local success, scriptContent = pcall(function()
        return game:HttpGet(fullUrl)
    end)
    
    if success and scriptContent then
        -- รันสคริปต์ที่ดึงมาได้
        local run, err = loadstring(scriptContent)
        if run then
            run()
        else
            warn("Error in script syntax: " .. tostring(err))
        end
    else
        warn("Failed to fetch script from GitHub")
    end
else
    -- ถ้า ID แมพไม่ตรงกับที่ตั้งไว้ ให้เด้งออก (Kick)
    game.Players.LocalPlayer:Kick("❌ แมพนี้ไม่รองรับสคริปต์ (Unsupported Map ID: " .. currentId .. ")")
end
