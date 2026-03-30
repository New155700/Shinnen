-- [[ SHINNEN HUB | V40 OFFICIAL CLOUD VERSION ]] --
-- ไฟล์นี้สำหรับ: https://raw.githubusercontent.com/New155700/Shinnen/main/Games1.lua

-- [1] ระบบป้องกันการรันซ้อน (Clean Up)
pcall(function()
    if game.CoreGui:FindFirstChild("Rayfield") then game.CoreGui.Rayfield:Destroy() end
    if game.CoreGui:FindFirstChild("ShinnenInfo") then game.CoreGui.ShinnenInfo:Destroy() end
end)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Win = Rayfield:CreateWindow({
    Name = "Shinnen Hub | V40 MASTER",
    LoadingTitle = "👿 Syncing with Cloud Systems...",
    LoadingSubtitle = "by Shinnen Custom👿",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false 
})

-- [2] ตัวแปรระบบ (Global State)
local plr = game.Players.LocalPlayer
_G.ShinnenState = {
    SpeedEnabled = false, CustomSpeed = 16,
    HitboxEnabled = false, HitboxSizeValue = 20,
    AttackSpeedEnabled = false, AutoClickEnabled = false,
    AutoTpKill = false, UnderTP = false, AutoTargetNearest = false,
    EspEnabled = false, TargetPlayer = nil
}

-- [3] ฟังก์ชันช่วยเหลือ
local function GetNearestPlayer()
    local closest, dist = nil, math.huge
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hum = v.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local d = plr:DistanceFromCharacter(v.Character.HumanoidRootPart.Position)
                if d < dist then dist = d closest = v.Name end
            end
        end
    end
    return closest
end

-- [4] สร้าง TABS
local TabMain = Win:CreateTab("Combat & Movement", 4483362458)
local TabAura = Win:CreateTab("Kill Aura Systems", 4483362458)
local TabVisual = Win:CreateTab("Visual & ESP", 4483362458)

-- COMBAT SECTION
TabMain:CreateSection("Attack Injection")
TabMain:CreateToggle({Name = "เปิดระบบตีไว (Attack Injection)", CurrentValue = false, Callback = function(v) _G.ShinnenState.AttackSpeedEnabled = v end})
TabMain:CreateToggle({Name = "เปิดคลิกซ้ายออโต้ (Turbo Click)", CurrentValue = false, Callback = function(v) _G.ShinnenState.AutoClickEnabled = v end})

TabMain:CreateSection("Hitbox Settings")
TabMain:CreateToggle({Name = "เปิดระบบ Hitbox (ขาวจาง)", CurrentValue = false, Callback = function(v) _G.ShinnenState.HitboxEnabled = v end})
TabMain:CreateSlider({Name = "ปรับขนาด Hitbox", Range = {1, 100}, Increment = 1, CurrentValue = 20, Callback = function(v) _G.ShinnenState.HitboxSizeValue = v end})

-- AURA SECTION
TabAura:CreateSection("Targeting")
TabAura:CreateToggle({Name = "ล็อกเป้าคนใกล้สุด (Auto Nearest)", CurrentValue = false, Callback = function(v) _G.ShinnenState.AutoTargetNearest = v end})
TabAura:CreateSection("TP Options")
TabAura:CreateToggle({Name = "🔥 วาร์ปติดตัวปกติ (Sticky TP)", CurrentValue = false, Callback = function(v) _G.ShinnenState.AutoTpKill = v if v then _G.ShinnenState.UnderTP = false end end})
TabAura:CreateToggle({Name = "มุดวาร์ป 'ใต้เท้า' (Under-TP)", CurrentValue = false, Callback = function(v) _G.ShinnenState.UnderTP = v if v then _G.ShinnenState.AutoTpKill = false end end})

-- VISUAL SECTION
TabVisual:CreateSection("ESP Settings")
TabVisual:CreateToggle({Name = "เปิดระบบมอง (ESP Name/Tracer)", CurrentValue = false, Callback = function(v) _G.ShinnenState.EspEnabled = v end})
TabVisual:CreateSection("Environment")
TabVisual:CreateToggle({Name = "เปิดภาพสวย Ultra HD", CurrentValue = false, Callback = function(v)
    game:GetService("Lighting").Brightness = v and 2.5 or 1
    game:GetService("Lighting").GlobalShadows = v
end})
TabVisual:CreateSlider({Name = "ปลดล็อก FPS", Range = {60, 360}, Increment = 10, CurrentValue = 60, Callback = function(v) setfpscap(v) end})

-- MOVEMENT SECTION
TabMain:CreateSection("Movement")
TabMain:CreateToggle({Name = "เปิดวิ่งอัดฉีด (Velocity)", CurrentValue = false, Callback = function(v) _G.ShinnenState.SpeedEnabled = v end})
TabMain:CreateSlider({Name = "ความแรง", Range = {16, 500}, Increment = 5, CurrentValue = 16, Callback = function(v) _G.ShinnenState.CustomSpeed = v end})

-- [5] ระบบ ESP (Drawing API)
local function CreateESP(p)
    local tracer, nameTag
    pcall(function() tracer = Drawing.new("Line") nameTag = Drawing.new("Text") end)
    if not tracer then return end

    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.ShinnenState.EspEnabled and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local pos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                tracer.From = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y)
                tracer.To = Vector2.new(pos.X, pos.Y)
                tracer.Visible = true
                nameTag.Position = Vector2.new(pos.X, pos.Y - 30)
                nameTag.Text = p.Name .. " [" .. math.floor(plr:DistanceFromCharacter(p.Character.HumanoidRootPart.Position)) .. "m]"
                nameTag.Visible = true
            else tracer.Visible, nameTag.Visible = false, false end
        else
            tracer.Visible, nameTag.Visible = false, false
            if not p.Parent or not game.CoreGui:FindFirstChild("Rayfield") then tracer:Destroy() nameTag:Destroy() end
        end
    end)
end
for _, v in ipairs(game.Players:GetPlayers()) do if v ~= plr then CreateESP(v) end end
game.Players.PlayerAdded:Connect(function(v) if v ~= plr then CreateESP(v) end end)

-- [6] ระบบประมวลผลหลัก (Heartbeat & Render)
game:GetService("RunService").Heartbeat:Connect(function()
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or not game.CoreGui:FindFirstChild("Rayfield") then return end
    local hrp, hum = plr.Character.HumanoidRootPart, plr.Character.Humanoid

    if _G.ShinnenState.AutoTargetNearest then _G.ShinnenState.TargetPlayer = GetNearestPlayer() end
    
    -- Speed System
    if _G.ShinnenState.SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
        hrp.Velocity = Vector3.new(hum.MoveDirection.X * _G.ShinnenState.CustomSpeed, hrp.Velocity.Y, hum.MoveDirection.Z * _G.ShinnenState.CustomSpeed)
    end

    -- TP & Kill System
    if _G.ShinnenState.TargetPlayer then
        local target = game.Players:FindFirstChild(_G.ShinnenState.TargetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if _G.ShinnenState.AutoTpKill then hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
            elseif _G.ShinnenState.UnderTP then hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, -4.5, 0) end
        end
    end

    -- Attack Injection
    if _G.ShinnenState.AttackSpeedEnabled then
        local tool = plr.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in ipairs(tool:GetDescendants()) do
                if v:IsA("NumberValue") and (v.Name:lower():find("wait") or v.Name:lower():find("delay")) then v.Value = 0 end
            end
        end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if not game.CoreGui:FindFirstChild("Rayfield") then return end
    
    if _G.ShinnenState.AutoClickEnabled or _G.ShinnenState.AutoTpKill or _G.ShinnenState.UnderTP then
        local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end

    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local part = v.Character.HumanoidRootPart
            if _G.ShinnenState.HitboxEnabled then
                part.Size = Vector3.new(_G.ShinnenState.HitboxSizeValue, _G.ShinnenState.HitboxSizeValue, _G.ShinnenState.HitboxSizeValue)
                part.Transparency, part.CanCollide = 0.85, false
            else
                part.Size = Vector3.new(2, 2, 1) -- คืนค่าเดิม
                part.Transparency, part.CanCollide = 0, true
            end
        end
    end
end)

-- Info Overlay
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ShinnenInfo"
local InfoLabel = Instance.new("TextLabel", ScreenGui)
InfoLabel.Size, InfoLabel.Position = UDim2.new(0, 250, 0, 100), UDim2.new(0, 10, 0, 10)
InfoLabel.BackgroundTransparency, InfoLabel.TextColor3 = 1, Color3.new(1,1,1)
InfoLabel.TextSize, InfoLabel.Font = 16, Enum.Font.Code
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    while task.wait(0.5) and ScreenGui.Parent do
        local fps = math.floor(1/game:GetService("RunService").RenderStepped:Wait())
        InfoLabel.Text = string.format("Developer: Shinnen Custom\nFPS: %d\nDate: %s\nTime: %s", fps, os.date("%x"), os.date("%X"))
    end
end)

Rayfield:Notify({Title = "V40 LOADED", Content = "Cloud Sync Successful!", Duration = 5})
