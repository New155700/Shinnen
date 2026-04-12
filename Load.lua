-- [[ 🔥 SHINNEN HUB | MASTER LOADER V7 PRO ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local plr = Players.LocalPlayer
local currentId = game.PlaceId 

-- [ 🔗 ลิงก์หลัก GitHub ของคุณ ]
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

-- [ 📋 ตารางแมพ (ล็อค ID ให้ตรงไฟล์) ]
local MapConfig = {
    [113745337705295] = "Games1.lua", -- ID แมพตำรวจจับโจร
    [142823291]       = "Games2.lua", -- ID แมพ Murder Mystery 2
    [14469379009]     = "Games3.lua", -- ID แมพแข่งกันกินอาหารเป็นทีม
}

-- [ 🧹 ระบบล้าง UI เก่าป้องกันบัค (Clear Old UI) ]
pcall(function()
    -- รองรับ Executor ทุกรูปแบบ
    local targetGui = (gethui and gethui()) or CoreGui
    for _, v in pairs(targetGui:GetChildren()) do
        if v:IsA("ScreenGui") and (v.Name == "N_FOV_GUI" or v.Name == "ShinnenUI" or v.Name == "N_ESP_FOLDER" or v.Name == "N_MobileAutoE") then
            v:Destroy()
        end
    end
end)

-- [ 🚀 ระบบโหลดไฟล์ (Smart Loader & Anti-Cache) ]
local fileName = MapConfig[currentId]

if fileName then
    -- ใช้ tick() เพื่อป้องกันบัค GitHub Cache (บังคับโหลดไฟล์อัปเดตใหม่ล่าสุดเสมอ)
    local fetchUrl = baseUrl .. fileName .. "?t=" .. tostring(tick())
    
    local success, content = pcall(function() 
        return game:HttpGet(fetchUrl) 
    end)

    if success and content and content ~= "" then
        -- ตรวจสอบว่าลิงก์ตายหรือไม่
        if content:match("404: Not Found") then
            plr:Kick("🚨 [ERROR]: ไม่พบไฟล์ " .. fileName .. " ใน GitHub (404 Not Found)")
            return
        end

        local func, err = loadstring(content)
        if func then
            print("✅ [SHINNEN PRO]: ดึงข้อมูลสำเร็จ! กำลังรัน -> " .. fileName)
            -- รันไฟล์ด้วย pcall เผื่อโค้ดในไฟล์หลักมีปัญหา เกมจะได้ไม่ค้าง
            local runSuccess, runErr = pcall(func)
            if not runSuccess then
                warn("🚨 [RUNTIME ERROR]: โค้ดในไฟล์ " .. fileName .. " มีปัญหาตอนทำงาน: " .. tostring(runErr))
            end
        else
            -- บอกตำแหน่ง Syntax Error ชัดเจน
            plr:Kick("🚨 [SYNTAX ERROR]: โค้ดใน " .. fileName .. " มีจุดพิมพ์ผิด\n\n" .. tostring(err))
        end
    else
        plr:Kick("🚨 [HTTP ERROR]: ไม่สามารถเชื่อมต่อ GitHub ได้ ลองเช็คเน็ตหรือลิงก์ดูครับ")
    end
else
    -- ❌ ถ้า ID แมพไม่ตรง เตะออกพร้อมบอก ID ที่ถูกต้อง ให้ก๊อปไปตั้งค่าได้เลย
    plr:Kick("🚨 [SECURITY]: แมพนี้ไม่ได้รับอนุญาต!\n\nโปรดนำ ID แมพนี้ไปเพิ่มใน MapConfig: " .. tostring(currentId))
end
