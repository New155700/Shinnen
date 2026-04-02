-- [[ SHINNEN HUB | MASTER LOADER V4 ]] --
local currentId = tostring(game.PlaceId)
-- สำคัญ: เช็คตัว S ในชื่อ Shinnen ให้ตรงกับใน GitHub เป๊ะๆ
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapConfig = {
    ["100400297022629"] = "Games1.lua", -- ไอดีแมพที่ 1
    ["96255502718881"]  = "Games2.lua", -- ไอดีแมพที่ 2
    ["14469379009"]     = "Games3.lua"  -- ไอดีแมพที่ 3
}

local fileName = MapConfig[currentId]

if fileName then
    -- ดึงโค้ดจาก GitHub มาเช็คก่อนรัน
    local success, content = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)
    
    if success and content then
        local func, err = loadstring(content)
        if func then
            func() -- รันไฟล์ลูก (Games.lua)
        else
            warn("Syntax Error in " .. fileName .. ": " .. tostring(err))
        end
    else
        warn("Failed to fetch " .. fileName .. ". Check your GitHub URL!")
    end
else
    -- ถ้าแมพไม่ตรง ให้แจ้งเตือนใน F9
    warn("This Map ID (" .. currentId .. ") is not in the whitelist.")
end
