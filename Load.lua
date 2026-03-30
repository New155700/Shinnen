-- [[ SHINNEN HUB | FIXED LOADER ]] --
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"
local currentId = game.PlaceId

local MapScripts = {
    [16281635412] = "Games1.lua",
    [100400297022629] = "Games2.lua", -- DUEL Warriors
}

if MapScripts[currentId] then
    local fileName = MapScripts[currentId]
    -- รวมร่างลิงก์ให้ถูกต้อง: baseUrl + fileName
    local finalUrl = baseUrl .. fileName
    
    local success, content = pcall(function()
        return game:HttpGet(finalUrl)
    end)

    if success then
        loadstring(content)()
    else
        warn("Shinnen Hub: หาไฟล์ " .. fileName .. " ไม่เจอ!")
    end
else
    warn("Shinnen Hub: ID แมพนี้ยังไม่ได้เพิ่มลงในสคริปต์ -> " .. tostring(currentId))
end
