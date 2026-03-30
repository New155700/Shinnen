-- [[ SHINNEN HUB | FIXED LOADER ]] --
local currentId = game.PlaceId
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapScripts = {
    [85638494463963] = "Games1.lua",
    [96255502718881] = "Games2.lua",
}

if MapScripts[currentId] then
    local fileName = MapScripts[currentId]
    local success, result = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)
    
    if success and result then
        print("Shinnen Hub: Loading " .. fileName)
        loadstring(result)()
    else
        game.Players.LocalPlayer:Kick("Shinnen Hub: โหลดไฟล์จาก GitHub ไม่สำเร็จ!")
    end
else
    -- ถ้าเลขไม่ตรง จะเด้งออกทันทีตามที่คุณต้องการ
    game.Players.LocalPlayer:Kick("Shinnen Hub: ไม่พบไอดีแมพนี้ในระบบ (" .. tostring(currentId) .. ")")
end
