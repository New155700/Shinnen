-- [[ SHINNEN HUB | DUAL-MAP MASTER LOADER ]] --
-- GitHub: New155700 / Repo: Shinnen

local currentId = tostring(game.PlaceId)
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

-- [1] รายชื่อไอดีแมพ (ใส่ไอดีเกมของคุณตรงนี้)
local MapConfig = {
    ["100400297022629"] = "Games1.lua", -- เปลี่ยนเลขไอดีให้ตรงกับแมพที่ 1
    ["96255502718881"]  = "Games2.lua"  -- เปลี่ยนเลขไอดีให้ตรงกับแมพที่ 2
}

-- [2] ระบบล้าง UI เก่า (กันบัคเมนูซ้อน)
pcall(function()
    if game.CoreGui:FindFirstChild("Rayfield") then game.CoreGui.Rayfield:Destroy() end
    if game.CoreGui:FindFirstChild("ShinnenInfo") then game.CoreGui.ShinnenInfo:Destroy() end
end)

-- [3] ค้นหาไฟล์ที่ต้องโหลด
local fileName = MapConfig[currentId] or "Games1.lua" -- ถ้าไม่เจอไอดีแมพ ให้โหลด Games1 เป็นตัวหลัก

-- [4] ฟังก์ชันดึงข้อมูลจาก Cloud
local function ExecuteCloudScript()
    -- เพิ่ม ?t= สุ่มเวลา เพื่อป้องกัน GitHub จำ Cache เก่า (สำคัญมากสำหรับการอัปเดต)
    local finalUrl = baseUrl .. fileName .. "?t=" .. os.time()
    
    print("👿 Shinnen Hub: Detecting Map ID [" .. currentId .. "]")
    print("👿 Shinnen Hub: Loading -> " .. fileName)

    local success, content = pcall(function() 
        return game:HttpGet(finalUrl) 
    end)

    if success and content then
        local func, err = loadstring(content)
        if func then
            -- เริ่มทำงานสคริปต์
            func() 
        else
            warn("👿 Shinnen Hub: Script Error in " .. fileName .. " -> " .. tostring(err))
        end
    else
        warn("👿 Shinnen Hub: Connection Fail! (404 or Internet Issue)")
    end
end

-- เริ่มการทำงาน
ExecuteCloudScript()
