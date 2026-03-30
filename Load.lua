-- [[ SHINNEN HUB | FIXED LOADER ]] --
local currentId = game.PlaceId
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapScripts = {
    [85638494463963] = "Games1.lua",
    [96255502718881] = "Games2.lua",
}

if MapScripts[currentId] then
    local fileName = MapScripts[currentId]
    local success, content = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)
    
    if success and content then
        loadstring(content)()
    else
        warn("Shinnen Hub: หาไฟล์ " .. fileName .. " ไม่เจอ!")
    end
else
    -- เปลี่ยนจาก Kick เป็นแจ้งเตือนแทนเพื่อเช็คเลขไอดี
    warn("Shinnen Hub: แมพไอดี " .. tostring(currentId) .. " ยังไม่ได้เพิ่มในสคริปต์!")
end
