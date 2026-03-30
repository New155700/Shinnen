-- [[ SHINNEN HUB | V38 STABLE VERSION ]] --
-- ไฟล์นี้ต้องอยู่ใน GitHub: New155700/Shinnen/main/Games1.lua

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Win = Rayfield:CreateWindow({
    Name = "Shinnen Hub | V38 MASTER",
    LoadingTitle = "👿 Syncing with Cloud...",
    LoadingSubtitle = "by Shinnen Custom👿",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false 
})

-- [[ SETTINGS ]] --
local plr = game.Players.LocalPlayer
_G.State = {
    AttackSpeed = false, AutoClick = false,
    StickyTP = false, UnderTP = false, AutoNearest = false,
    HitboxEnabled = false, HitboxSize = 20,
    EspEnabled = false, SpeedEnabled = false, SpeedValue = 16,
    Target = nil
}

-- [[ TABS ]] --
local TabCombat = Win:CreateTab("Combat & TP", 4483362458)
local TabVisual = Win:CreateTab("ESP & Graphics", 4483362458)

-- COMBAT
TabCombat:CreateToggle({Name = "ตีไว (Attack Injection)", CurrentValue = false, Callback = function(v) _G.State.AttackSpeed = v end})
TabCombat:CreateToggle({Name = "คลิกซ้ายออโต้ (Turbo)", CurrentValue = false, Callback = function(v) _G.State.AutoClick = v end})
TabCombat:CreateToggle({Name = "ล็อกเป้าคนใกล้สุด", CurrentValue = false, Callback = function(v) _G.State.AutoNearest = v end})
TabCombat:CreateToggle({Name = "🔥 วาร์ปติดตัว (Sticky)", CurrentValue = false, Callback = function(v) _G.State.StickyTP = v if v then _G.State.UnderTP = false end end})

-- VISUAL
TabVisual:CreateToggle({Name = "เปิดระบบมอง (ESP)", CurrentValue = false, Callback = function(v) _G.State.EspEnabled = v end})

-- [[ CORE ENGINE ]] --
local function GetNearest()
    local closest, dist = nil, math.huge
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d closest = v.Name end
        end
    end
    return closest
end

game:GetService("RunService").Heartbeat:Connect(function()
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = plr.Character.HumanoidRootPart
    
    if _G.State.AutoNearest then _G.State.Target = GetNearest() end
    
    if _G.State.Target then
        local t = game.Players:FindFirstChild(_G.State.Target)
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            if _G.State.StickyTP then
                hrp.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
            end
        end
    end

    if _G.State.AttackSpeed then
        local tool = plr.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in ipairs(tool:GetDescendants()) do
                if v:IsA("NumberValue") and (v.Name:lower():find("wait") or v.Name:lower():find("delay")) then v.Value = 0 end
            end
        end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if _G.State.AutoClick or _G.State.StickyTP then
        local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end
end)

Rayfield:Notify({Title = "V38 LOADED", Content = "Script is Ready!", Duration = 5})
