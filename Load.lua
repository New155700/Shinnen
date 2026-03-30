-- [[ SHINNEN HUB | RE-FIXED LOADER ]] --
local currentId = game.PlaceId
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"


-- 1. รายชื่อแมพ (เช็คตัวสะกด Games1.lua ให้ตรงกับใน GitHub)
local MapScripts = {
    [85638494463963] = "Games1.lua",     -- แมพเก่าของคุณ
    [96255502718881] = "Games2.lua",  -- แมพ DUEL Warriors (เลขที่มันฟ้องว่าเด้ง)
}

-- 2. ระบบดึงไฟล์
if MapScripts[currentId] then
    local fileName = MapScripts[currentId]
    -- ลิงก์ที่ถูกต้องคือ baseUrl ต่อด้วยชื่อไฟล์
    local finalUrl = baseUrl .. fileName
    
    -- รันสคริปต์
    loadstring(game:HttpGet(finalUrl))()
else
    -- ถ้าหาไอดีไม่เจอ ให้เตะออก (ตามที่คุณต้องการ)
    game.Players.LocalPlayer:Kick("Shinnen Hub: ไม่พบไอดีแมพนี้ (" .. tostring(currentId) .. ")")
end
