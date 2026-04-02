-- [[ SHINNEN HUB | MASTER LOADER V4 ]] --
local currentId = tostring(game.PlaceId)
-- ตรวจสอบ: URL นี้ต้องเข้าได้จริง ลองเอาไปวางใน Browser ดูครับ
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapConfig = {
    ["100400297022629"] = "Games1.lua",
    ["96255502718881"]  = "Games2.lua",
    ["14469379009"]     = "Games3.lua" 
}

local fileName = MapConfig[currentId]

if fileName then
    local success, content = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)
    
    if success and content then
        local func, err = loadstring(content)
        if func then
            func() -- ไปรันไฟล์ Games...lua
        else
            warn("Syntax Error in " .. fileName .. ": " .. err)
        end
    else
        -- ถ้าดึงไฟล์ไม่ได้ มันจะฟ้องใน F9 ทันที
        warn("HTTP ERROR: Cannot find " .. fileName .. " at " .. baseUrl)
    end
else
    warn("WHITELIST ERROR: Map ID " .. currentId .. " is not registered.")
end
