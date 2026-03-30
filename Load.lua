-- Shinnen Hub Success Loader (100% Fixed)
local Success, Error = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/New155700/Shinnen/main/Games"))()
end)

if not Success then
    warn("Loader Error: " .. tostring(Error))
    -- กรณี Link ด้านบนมีปัญหา จะลอง Link สำรองแบบระบุหัว Branch
    loadstring(game:HttpGet("https://raw.githubusercontent.com/New155700/Shinnen/refs/heads/main/Games.lua"))()
end
