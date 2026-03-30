-- [[ SHINNEN HUB | PRO LOADER ]] --
local currentId = game.PlaceId
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local MapScripts = {
    [85638494463963] = "Games1.lua",
    [96255502718881] = "Games2.lua", -- เช็คเลขนี้ให้ตรงกับหน้าจอที่เคยเด้ง
}

if MapScripts[currentId] then
    local fileName = MapScripts[currentId]
    local success, result = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)
    
    if success and result then
        print("Loading: " .. fileName)
        loadstring(result)()
    else
        warn("Download Failed!")
    end
else
    -- ถ้าไอดีไม่ตรง ให้เด้งออกพร้อมบอกเลขที่ถูกต้อง
    game:GetService("Players").LocalPlayer:Kick("ID NOT FOUND: " .. tostring(currentId))
end
