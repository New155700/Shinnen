-- [[ SHINNEN HUB | COMPLETE LOADER ]] --
local currentId = game.PlaceId
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapScripts = {
    [85638494463963] = "Games1.lua", -- แมพที่ 1
    [96255502718881] = "Games2.lua"  -- แมพที่ 2 (แก้เลขไม่ให้ซ้ำแล้ว)
}

local fileName = MapScripts[currentId]

if fileName then
    print("Shinnen Hub: Checking Map...")
    local success, content = pcall(function() return game:HttpGet(baseUrl .. fileName) end)
    if success then
        print("Shinnen Hub: Loading " .. fileName)
        loadstring(content)()
    else
        warn("Shinnen Hub: GitHub Connection Error!")
    end
else
    -- ถ้าไม่เจอไอดี ให้บอกเลขใน Console จะได้ก๊อปไปเพิ่มถูก
    warn("Shinnen Hub: ID NOT FOUND -> " .. tostring(currentId))
    -- ถ้าอยากให้รัน Games1 ตลอดแม้ไม่เจอไอดี ให้ลบบรรทัดบนแล้วใช้: loadstring(game:HttpGet(baseUrl .. "Games1.lua"))()
end
