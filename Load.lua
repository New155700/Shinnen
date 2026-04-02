-- [[ SHINNEN HUB | MASTER LOADER V4 ]] --
local currentId = tostring(game.PlaceId)
-- ตรวจสอบลิงก์ให้ตรงกับ Github (เช็คตัวเล็ก/ใหญ่ของชื่อ Shinnen ด้วย)
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapConfig = {
    ["100400297022629"] = "Games1.lua",
    ["96255502718881"] = "Games2.lua",
    ["14469379009"] = "Games3.lua"
}

local fileName = MapConfig[currentId]

if fileName then
    -- ใช้ pcall เพื่อป้องกันสคริปต์พังเงียบ
    local success, content = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)
    
    if success and content then
        local func, err = loadstring(content)
        if func then
            func() -- เริ่มทำงาน
        else
            warn("Syntax Error in " .. fileName .. ": " .. tostring(err))
        end
    else
        warn("Failed to fetch " .. fileName .. " from GitHub. Check URL!")
    end
else
    -- ถ้าไม่ตรงแมพ ให้เตือนแทนการ Kick เพื่อดูผลการรัน
    warn("SHINNEN HUB: This Map ID (" .. currentId .. ") is not in Whitelist.")
end
