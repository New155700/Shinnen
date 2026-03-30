-- [[ SHINNEN HUB | V16 RGB TOGGLE EDITION ]] --
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Win = Rayfield:CreateWindow({
    Name = "Shinnen Hub | V1 Custom",
    LoadingTitle = "Splitting Toggles...👿",
    LoadingSubtitle = "by Shinnen Custom👿",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false 
})

-- [[ SETTINGS ]] --
local plr = game.Players.LocalPlayer
local SpeedEnabled = false
local CustomSpeed = 16 
local HitboxEnabled = false
local HitboxRGB = false -- ตัวแปรใหม่สำหรับเปิด-ปิดสีรุ้ง
local AntiFallEnabled = false
local AttackSpeedEnabled = false
local HitboxSize = Vector3.new(4.5, 4.5, 4.5)

-- [[ TABS ]] --
local TabMain = Win:CreateTab("Combat & Movement", 4483362458)
local TabTp = Win:CreateTab("Teleport", 4483362458)
local TabVisual = Win:CreateTab("Graphics & UI", 4483362458)

-- [[ 1. COMBAT & HITBOX (แยกเปิด-ปิด RGB และ Hitbox) ]] --
TabMain:CreateSection("Hitbox Settings")

TabMain:CreateToggle({
    Name = "เปิดระบบ Hitbox (ขนาด 4.5)",
    CurrentValue = false,
    Callback = function(v) HitboxEnabled = v end
})

TabMain:CreateToggle({
    Name = "เปิดแสง RGB ให้ Hitbox (Rainbow)",
    CurrentValue = false,
    Callback = function(v) HitboxRGB = v end
})

TabMain:CreateToggle({
    Name = "เปิดระบบตีไว (Fast Attack)",
    CurrentValue = false,
    Callback = function(v) AttackSpeedEnabled = v end
})

-- [[ 2. MOVEMENT & PROTECTION ]] --
TabMain:CreateSection("Movement")

TabMain:CreateToggle({
    Name = "เปิดระบบวิ่งไว (Fixed Speed)",
    CurrentValue = false,
    Callback = function(v) SpeedEnabled = v end
})

TabMain:CreateSlider({
   Name = "ระดับความเร็ว",
   Range = {16, 250},
   Increment = 2,
   CurrentValue = 16,
   Callback = function(Value) CustomSpeed = Value end,
})

TabMain:CreateToggle({
    Name = "ล็อกตัวไม่ให้ล้ม (Anti-Ragdoll)",
    CurrentValue = false,
    Callback = function(v) AntiFallEnabled = v end
})

-- [[ 3. TELEPORT (ดึงค่าแม่นยำจาก V14) ]] --
local posOriginal = CFrame.new(256.114014, -160, -2032.05005, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local pos2vs2_1 = CFrame.new(218.5952, -80.5689316, -1911.20142, 0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, 0.707134247)
local pos2vs2_2 = CFrame.new(285.697601, -80.7534561, -1911.35657, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)

TabTp:CreateButton({
-- [[ SHINNEN HUB | V33 OPTIMIZED ESP EDITION ]] --
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Win = Rayfield:CreateWindow({
    Name = "Shinnen Hub | V33 LITE + ESP",
    LoadingTitle = "👿 Injecting Optimized Systems...",
    LoadingSubtitle = "by Shinnen Custom👿",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false 
})

-- [[ SETTINGS ]] --
local plr = game.Players.LocalPlayer
local SpeedEnabled, CustomSpeed = false, 16
local HitboxEnabled, HitboxSizeValue = false, 20
local AttackSpeedEnabled, AutoClickEnabled = false, false
local AutoTpKill, UnderTP, AutoTargetNearest = false, false, false
local EspEnabled = false -- ระบบมอง
local TargetPlayer, SavedLocation, AntiStatus = nil, nil, false

-- [[ TABS ]] --
local TabMain = Win:CreateTab("Combat & Movement", 4483362458)
local TabAura = Win:CreateTab("Kill Aura Systems", 4483362458)
local TabVisual = Win:CreateTab("Visual & ESP", 4483362458)

-- [[ 1. COMBAT & ATTACK ]] --
TabMain:CreateSection("Attack Injection")
TabMain:CreateToggle({Name = "เปิดระบบตีไว (Attack Injection)", CurrentValue = false, Callback = function(v) AttackSpeedEnabled = v end})
TabMain:CreateToggle({Name = "เปิดคลิกซ้ายออโต้ (Turbo Click)", CurrentValue = false, Callback = function(v) AutoClickEnabled = v end})

TabMain:CreateSection("Hitbox Settings")
TabMain:CreateToggle({Name = "เปิดระบบ Hitbox (ขาวจาง)", CurrentValue = false, Callback = function(v) HitboxEnabled = v end})
TabMain:CreateSlider({Name = "ปรับขนาด Hitbox", Range = {1, 100}, Increment = 1, CurrentValue = 20, Callback = function(v) HitboxSizeValue = v end})

-- [[ 2. KILL AURA & TELEPORT ]] --
TabAura:CreateSection("Targeting")
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

TabAura:CreateToggle({Name = "ล็อกเป้าคนใกล้สุด (Auto Nearest)", CurrentValue = false, Callback = function(v) AutoTargetNearest = v end})
TabAura:CreateSection("TP Options")
TabAura:CreateToggle({Name = "🔥 วาร์ปติดตัวปกติ (Sticky TP)", CurrentValue = false, Callback = function(v) AutoTpKill = v if v then UnderTP = false end end})
TabAura:CreateToggle({Name = "มุดวาร์ป 'ใต้เท้า' (Under-TP)", CurrentValue = false, Callback = function(v) UnderTP = v if v then AutoTpKill = false end end})

-- [[ 3. VISUAL & ESP SYSTEM ]] --
TabVisual:CreateSection("ESP Settings (มองทะลุ)")
TabVisual:CreateToggle({
    Name = "เปิดระบบมอง (ESP Name/Tracer)",
    CurrentValue = false,
    Callback = function(v) EspEnabled = v end
})

TabVisual:CreateSection("Environment")
TabVisual:CreateToggle({Name = "เปิดภาพสวย Ultra HD", CurrentValue = false, Callback = function(v)
    local L = game:GetService("Lighting")
    L.Brightness = v and 2.5 or 1
    L.GlobalShadows = v
end})
TabVisual:CreateSlider({Name = "ปลดล็อก FPS", Range = {60, 360}, Increment = 10, CurrentValue = 60, Callback = function(v) setfpscap(v) end})

-- ระบบ ESP โค้ดแบบรีดประสิทธิภาพ
local function CreateESP(p)
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.new(1, 1, 1)
    tracer.Thickness = 1
    tracer.Transparency = 0.7

    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = Color3.new(1, 1, 1)
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Outline = true

    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if EspEnabled and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local hrp = p.Character.HumanoidRootPart
            local pos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                -- Tracer
                tracer.From = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y)
                tracer.To = Vector2.new(pos.X, pos.Y)
                tracer.Visible = true

                -- Name
                nameTag.Position = Vector2.new(pos.X, pos.Y - 30)
                nameTag.Text = p.Name .. " [" .. math.floor(p:DistanceFromCharacter(hrp.Position)) .. "m]"
                nameTag.Visible = true
            else
                tracer.Visible = false
                nameTag.Visible = false
            end
        else
            tracer.Visible = false
            nameTag.Visible = false
            if not p.Parent then
                tracer:Destroy()
                nameTag:Destroy()
                connection:Disconnect()
            end
        end
    end)
end

for _, v in ipairs(game.Players:GetPlayers()) do if v ~= plr then CreateESP(v) end end
game.Players.PlayerAdded:Connect(function(v) if v ~= plr then CreateESP(v) end end)

-- Info HUD
local InfoLabel = Instance.new("TextLabel", Instance.new("ScreenGui", game.CoreGui))
InfoLabel.Parent.Name = "ShinnenInfo"
InfoLabel.Size, InfoLabel.Position = UDim2.new(0, 250, 0, 100), UDim2.new(0, 10, 0, 10)
InfoLabel.BackgroundTransparency, InfoLabel.TextColor3 = 1, Color3.new(1,1,1)
InfoLabel.TextSize, InfoLabel.Font = 16, Enum.Font.Code
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1/game:GetService("RunService").RenderStepped:Wait())
        InfoLabel.Text = string.format("Developer: Shinnen Custom\nFPS: %d\nDate: %s\nTime: %s", fps, os.date("%x"), os.date("%X"))
    end
end)

-- [[ CORE SYSTEM ]] --
local function InitSystem(char)
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    game:GetService("RunService").Heartbeat:Connect(function()
        if not char.Parent then return end
        if AutoTargetNearest then TargetPlayer = GetNearestPlayer() end
        if SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
            hrp.Velocity = Vector3.new(hum.MoveDirection.X * CustomSpeed, hrp.Velocity.Y, hum.MoveDirection.Z * CustomSpeed)
        end
        if AttackSpeedEnabled then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                for _, v in ipairs(tool:GetDescendants()) do
                    if v:IsA("NumberValue") and (v.Name:lower():find("wait") or v.Name:lower():find("delay")) then v.Value = 0 end
                end
            end
        end
        if TargetPlayer then
            local target = game.Players:FindFirstChild(TargetPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                if AutoTpKill then hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                elseif UnderTP then hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, -4.5, 0) end
            end
        end
    end)
end

plr.CharacterAdded:Connect(InitSystem)
if plr.Character then task.spawn(InitSystem, plr.Character) end

-- Render Loop
game:GetService("RunService").RenderStepped:Connect(function()
    if AutoClickEnabled or AutoTpKill or UnderTP then
        local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end
    if HitboxEnabled then
        for _, v in ipairs(game.Players:GetPlayers()) do
            if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local part = v.Character.HumanoidRootPart
                part.Size = Vector3.new(HitboxSizeValue, HitboxSizeValue, HitboxSizeValue)
                part.Transparency, part.CanCollide = 0.85, false
            end
        end
    end
end)

-- Movement
TabMain:CreateSection("Movement")
TabMain:CreateToggle({Name = "เปิดวิ่งอัดฉีด (Velocity)", CurrentValue = false, Callback = function(v) SpeedEnabled = v end})
TabMain:CreateSlider({Name = "ความแรง", Range = {16, 500}, Increment = 5, CurrentValue = 16, Callback = function(v) CustomSpeed = v end})
TabMain:CreateButton({Name = "💀 รีตัวด่วน", Callback = function() if plr.Character then plr.Character.Humanoid.Health = 0 end end})

Rayfield:Notify({Title = "V33 LITE + ESP", Content = "ESP & Optimized Systems Ready!", Duration = 5})
