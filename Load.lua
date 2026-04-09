-- [[ SHINNEN HUB | MASTER LOADER V6 : MM2 EDITION ]] --
local plr = game:GetService("Players").LocalPlayer
local currentId = game.PlaceId 

-- [ 🔗 ลิงก์หลัก GitHub ของพี่ ]
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

-- [ 📋 ตารางแมพ (ล็อค ID ให้ตรงไฟล์) ]
local MapConfig = {
    [113745337705295] = "Games1.lua", -- ID แมพตำรวจจับโจร
    [142823291] = "Games2.lua", -- ID แมพ Murder Mystery 2 หลัก
    [14469379009] = "Games3.lua", -- ID แมพแข่งกันกินอาหารเป็นทีม
}

-- ระบบล้าง UI เก่าป้องกันบัค
pcall(function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and (v.Name == "N_FOV_GUI" or v.Name == "ShinnenUI") then
            v:Destroy()
        end
    end
end)

local fileName = MapConfig[currentId]

if fileName then
    local success, content = pcall(function() return game:HttpGet(baseUrl .. fileName) end)
    if success and content and content ~= "" then
        local func, err = loadstring(content)
        if func then
            print("✅ [SHINNEN]: กำลังดึงข้อมูลจาก -> " .. fileName)
            func() 
        else
            plr:Kick("🚨 [ERROR]: โค้ดใน GitHub มีจุดผิด (Syntax Error)")
        end
    else
        plr:Kick("🚨 [ERROR]: ไม่สามารถเชื่อมต่อ GitHub หรือหาไฟล์ " .. fileName .. " ไม่เจอ")
    end
else
    -- ❌ ถ้า ID แมพไม่ตรงตามที่ตั้งไว้ ให้เตะออกทันที ไม่โหลดมั่ว
    plr:Kick("🚨 [SECURITY]: แมพนี้ไม่ได้รับอนุญาต (ID: " .. tostring(currentId) .. ")")
end
