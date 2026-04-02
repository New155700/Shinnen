-- [[ SHINNEN HUB | MASTER LOADER V4 ]] --
local currentId = tostring(game.PlaceId)

-- URL หลักที่เก็บไฟล์ของพี่ (เปลี่ยนจาก blob เป็น raw)
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapConfig = {
    ["100400297022629"] = "Games1.lua",
    ["96255502718881"]  = "Games2.lua",
    ["14469379009"]     = "Games3.lua"
}

local fileName = MapConfig[currentId]

if fileName then
    -- ถ้ามีรหัสแมพตรงกับในตาราง ให้โหลดไฟล์นั้นมารัน
    local success, content = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)

    if success and content then
        local func = loadstring(content)
        if func then
            func() -- สั่งรันไฟล์ Games...lua
        end
    end
else
    -- ถ้าเข้าแมพอื่นที่ไม่มีในตาราง ให้โหลด UI เปล่าๆ หรือแจ้งเตือน
    print("N-SHINNEN: ไม่รองรับแมพนี้ (รหัสแมพ: " .. currentId .. ")")
end
