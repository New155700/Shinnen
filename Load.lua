-- [[ SHINNEN HUB | MASTER LOADER & SECURITY ]] --
local currentId = tostring(game.PlaceId)
local plr = game:GetService("Players").LocalPlayer
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

-- [ 📋 ตารางแมพที่อนุญาต ]
-- ถ้า ID ตรงกับในนี้ จะไปดึงไฟล์ .lua ชื่อนั้นๆ มาจาก GitHub ของคุณ
local MapConfig = {
    ["286090429"] = "Games2.lua", -- Murder Mystery 2
    ["142823291"] = "Games1.lua", -- Arsenal (ตัวอย่าง)
    ["155615604"] = "Games3.lua", -- Prison Life (ตัวอย่าง)
    -- เพิ่ม ID แมพอื่นๆ ที่นี่...
}

local fileName = MapConfig[currentId]

if fileName then
    -- 🚀 ระบบดึงไฟล์สคริปต์จาก GitHub ตามแมพที่ตรวจเจอ
    local success, content = pcall(function() 
        return game:HttpGet(baseUrl .. fileName) 
    end)

    if success and content and content ~= "" then
        local func, err = loadstring(content)
        if func then
            print("✅ [SHINNEN]: Loading specific script for " .. currentId)
            func() -- รันสคริปต์ของแมพนั้น
        else
            -- ถ้าไฟล์ใน GitHub เขียนผิด (Syntax Error) จะเตะออก
            plr:Kick("🚨 [SHINNEN ERROR]: สคริปต์ในไฟล์ " .. fileName .. " มีจุดผิด")
        end
    else
        -- ถ้าดึงไฟล์จาก GitHub ไม่ได้ (ชื่อไฟล์ผิดหรือเซิร์ฟเวอร์ล่ม) จะเตะออก
        plr:Kick("🚨 [SHINNEN ERROR]: ไม่สามารถดึงสคริปต์จาก GitHub ได้")
    end
else
    -- ❌ ถ้าแมพที่รันอยู่ "ไม่มีในตาราง MapConfig" ให้เตะออกทันที
    plr:Kick("🚨 [SHINNEN SECURITY]: แมพนี้ไม่ได้รับอนุญาตให้ใช้งาน (ID: " .. currentId .. ")")
end
