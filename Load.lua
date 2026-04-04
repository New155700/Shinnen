-- [[ SHINNEN HUB | MASTER LOADER V5 (ANT-ERROR & KICK) ]] --
local currentId = tostring(game.PlaceId)
local plr = game:GetService("Players").LocalPlayer

-- [ 🔗 ใส่ URL หลักที่เก็บไฟล์ GitHub ของคุณ ]
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

-- [ 📋 ตารางแมพ (ตัวอย่าง: MM2 ไปที่ Games2.lua) ]
local MapConfig = {
    ["142823291"] = "Games2.lua", -- Murder Mystery 2
    ["100400297022629"] = "Games1.lua", -- แมพกินอาหาร
}

local fileName = MapConfig[currentId]

if fileName then
    -- 🚀 ระบบดึงไฟล์สคริปต์
    local success, content = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)

    if success and content and content ~= "" then
        -- ตรวจสอบและคอมไพล์โค้ด
        local func, err = loadstring(content)
        if func then
            print("✅ N-SHINNEN HUB : Loading " .. fileName)
            func() 
        else
            -- ❌ ถ้าโค้ดในไฟล์ GitHub มีจุดผิด (Syntax Error) จะเตะออกทันที
            plr:Kick("🚨 [SHINNEN ERROR]: สคริปต์ในไฟล์ " .. fileName .. " มีจุดผิด ไม่สามารถรันได้")
        end
    else
        -- ❌ ถ้าดึงไฟล์จาก GitHub ไม่สำเร็จ (เช่น พิมพ์ชื่อไฟล์ผิด) จะเตะออกทันที
        plr:Kick("🚨 [SHINNEN ERROR]: ไม่สามารถดึงไฟล์ " .. fileName .. " จาก GitHub ได้ (Check URL/FileName)")
    end
else
    -- ❌ กรณีรันในแมพที่ไม่ได้ตั้งค่าไว้ใน MapConfig
    -- หากต้องการให้รันที่ไหนก็ได้ให้เอา plr:Kick ออกแล้วเปลี่ยนเป็นโหลดสคริปต์อื่นแทน
    plr:Kick("🚨 [SHINNEN ERROR]: แมพนี้ไม่ได้รับอนุญาตให้ใช้งาน (Unsupported Place ID: " .. currentId .. ")")
end
