if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Discord = "https://discord.com/invite/v3dAeMKp4N"
local BaseURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/Games/"
local ScriptURL = BaseURL .. game.PlaceId .. ".lua"

-- ⚡ โหลดแบบเร็ว (ไม่บล็อก)
task.spawn(function()
    local ok,res = pcall(game.HttpGet, game, ScriptURL)

    if not ok or not res or res:find("404") then
        pcall(function() setclipboard(Discord) end)
        LocalPlayer:Kick("Game not supported.\nDiscord copied")
        return
    end

    -- ⚡ รันทันที
    local runOk,err = pcall(loadstring(res))
    if not runOk then
        pcall(function() setclipboard(Discord) end)
        LocalPlayer:Kick("Script error.\nJoin Discord")
    end
end)