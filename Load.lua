-- Shinnen Hub Success Loader (100% Fixed)
-- รายการ ID แมพที่รองรับ (ตัวอย่าง)
local SupportedMaps = {
    [123456789] = "Games.lua",  -- ใส่ ID แมพ และชื่อไฟล์สคริปต์
    [987654321] = "Games1.lua"
}

local currentPlaceId = game.PlaceId

if SupportedMaps[currentPlaceId] then
    -- ถ้าเจอ ID แมพในรายการ ให้ทำการโหลดสคริปต์
    local fileName = SupportedMaps[currentPlaceId]
    local url = "https://raw.githubusercontent.com/New155700/Shinnen/main/" .. fileName
    
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        loadstring(content)()
    else
        warn("ไม่สามารถโหลดสคริปต์ได้: " .. tostring(content))
    end
else
    -- ถ้าแมพไม่ถูกต้อง ให้เตะออก
    game.Players.LocalPlayer:Kick("สคริปต์นี้ไม่รองรับแมพนี้ (Unsupported Map)")
end
