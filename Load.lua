-- [[ SHINNEN HUB | SECURE MASTER LOADER V4 ]] --
-- ระบบตรวจสอบไอดีแมพ: ถ้าไม่ตรงในลิสต์ "เตะออกทันที" --

local currentId = tostring(game.PlaceId)
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

-- [1] รายชื่อไอดีแมพที่อนุญาต (Whitelist)
local MapConfig = {
    ["100400297022629"] = "Games1.lua", -- แมพที่ 1
    ["96255502718881"]  = "Games2.lua", -- แมพที่ 2
    ["14469379009"]     = "Games3.lua"  -- แมพที่ 3
}

-- [2] ระบบตรวจสอบความถูกต้อง (Security Check)
local fileName = MapConfig[currentId]

if not fileName then
    -- ถ้าไอดีแมพไม่ตรงกับที่ตั้งไว้ ให้ทำการ "เตะ" ทันที
    local kickMessage = "\n👿 SHINNEN HUB SECURITY 👿\n\nขออภัย! สคริปต์นี้ไม่รองรับแมพนี้\nID: " .. currentId .. "\nกรุณาเข้าเล่นในแมพที่กำหนดเท่านั้น"
    game.Players.LocalPlayer:Kick(kickMessage)
    return -- หยุดการทำงานของสคริปต์ทั้งหมด
end

-- [3] ระบบล้าง UI เก่า (กรณีรันซ้ำในแมพที่ถูกต้อง)
pcall(function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "Rayfield" then v:Destroy() end
    end
end)

-- [4] ฟังก์ชันโหลดโค้ดจาก Cloud (แบบสดใหม่เสมอ)
local function LoadShinnenCloud()
    local finalUrl = baseUrl .. fileName .. "?t=" .. os.time()
    
    print("👿 Shinnen Hub: Authorized Access [Map: " .. currentId .. "]")
    
    local success, content = pcall(function() 
        return game:HttpGet(finalUrl) 
    end)

    if success and content then
        local func, err = loadstring(content)
        if func then
            func() -- รันสคริปต์หลักจาก GitHub
            print("👿 Shinnen Hub: Script Loaded!")
        else
            warn("👿 Shinnen Hub: Script Error -> " .. tostring(err))
        end
    else
        warn("👿 Shinnen Hub: Connection Fail!")
    end
end

-- เริ่มการทำงาน
LoadShinnenCloud()
