-- [[ SHINNEN HUB | V34 RECOVERY & STABLE EDITION ]] --
local function SafeRun(func)
    local success, err = pcall(func)
    if not success then warn("Shinnen Error: "..tostring(err)) end
end

SafeRun(function()
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

    local Win = Rayfield:CreateWindow({
        Name = "Shinnen Hub | V34 RECOVERY",
        LoadingTitle = "👿 System Recovery Active...",
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
    local EspEnabled = false
    local TargetPlayer = nil

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

    -- [[ 2. TARGETING ]] --
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
    TabAura:CreateToggle({Name = "🔥 วาร์ปติดตัวปกติ (Sticky TP)", CurrentValue = false, Callback = function(v) AutoTpKill = v if v then UnderTP = false end end})
    TabAura:CreateToggle({Name = "มุดวาร์ป 'ใต้เท้า' (Under-TP)", CurrentValue = false, Callback = function(v) UnderTP = v if v then AutoTpKill = false end end})

    -- [[ 3. VISUAL & ESP ]] --
    TabVisual:CreateToggle({Name = "เปิดระบบมอง (ESP)", CurrentValue = false, Callback = function(v) EspEnabled = v end})
    TabVisual:CreateToggle({Name = "เปิดภาพสวย Ultra HD", CurrentValue = false, Callback = function(v)
        game:GetService("Lighting").Brightness = v and 2.5 or 1
        game:GetService("Lighting").GlobalShadows = v
    end})
    TabVisual:CreateSlider({Name = "ปลดล็อก FPS", Range = {60, 360}, Increment = 10, CurrentValue = 60, Callback = function(v) setfpscap(v) end})

    -- ระบบ ESP แบบกันหลุด (Safe ESP)
    local function CreateESP(p)
        local tracer, nameTag
        pcall(function()
            tracer = Drawing.new("Line")
            nameTag = Drawing.new("Text")
        end)
        if not tracer then return end -- ถ้าเครื่องไม่รองรับ Drawing ให้หยุดฟังก์ชันนี้

        game:GetService("RunService").RenderStepped:Connect(function()
            if EspEnabled and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local pos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    tracer.From = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y)
                    tracer.To = Vector2.new(pos.X, pos.Y)
                    tracer.Visible = true
                    nameTag.Position = Vector2.new(pos.X, pos.Y - 30)
                    nameTag.Text = p.Name
                    nameTag.Visible = true
                else
                    tracer.Visible, nameTag.Visible = false, false
                end
            else
                tracer.Visible, nameTag.Visible = false, false
                if not p.Parent then tracer:Destroy() nameTag:Destroy() end
            end
        end)
    end

    for _, v in ipairs(game.Players:GetPlayers()) do if v ~= plr then CreateESP(v) end end
    game.Players.PlayerAdded:Connect(function(v) if v ~= plr then CreateESP(v) end end)
-- [[ SHINNEN HUB | V36 ALL-IN-ONE ULTIMATE ]] --
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Win = Rayfield:CreateWindow({
    Name = "Shinnen Hub | V36 ULTIMATE",
    LoadingTitle = "👿 Injecting All Systems...",
    LoadingSubtitle = "by Shinnen Custom👿",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false 
})

-- [[ 🟢 1. SETTINGS & STATE ]] --
local plr = game.Players.LocalPlayer
local State = {
    AttackSpeed = false,
    AutoClick = false,
    StickyTP = false,
    UnderTP = false,
    AutoNearest = false,
    HitboxEnabled = false,
    HitboxSize = 20,
    EspEnabled = false,
    CustomSpeed = 16,
    SpeedEnabled = false,
    Target = nil
}

-- [[ 🔵 2. HELPER FUNCTIONS ]] --
local function GetNearest()
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

-- [[ 🟠 3. UI TABS ]] --
local TabCombat = Win:CreateTab("Combat & TP", 4483362458)
local TabVisual = Win:CreateTab("Visual & ESP", 4483362458)
local TabMisc = Win:CreateTab("Movement & Info", 4483362458)

-- COMBAT & TP
TabCombat:CreateSection("Attack Settings")
TabCombat:CreateToggle({Name = "เปิดตีไว (Attack Injection)", CurrentValue = false, Callback = function(v) State.AttackSpeed = v end})
TabCombat:CreateToggle({Name = "คลิกซ้ายออโต้ (Turbo Click)", CurrentValue = false, Callback = function(v) State.AutoClick = v end})

TabCombat:CreateSection("Teleport Systems")
TabCombat:CreateToggle({Name = "ล็อกเป้าคนใกล้สุด (Auto Nearest)", CurrentValue = false, Callback = function(v) State.AutoNearest = v end})
TabCombat:CreateToggle({Name = "🔥 วาร์ปติดตัวปกติ (Sticky TP)", CurrentValue = false, Callback = function(v) State.StickyTP = v if v then State.UnderTP = false end end})
TabCombat:CreateToggle({Name = "มุดวาร์ปใต้เท้า (Under-TP)", CurrentValue = false, Callback = function(v) State.UnderTP = v if v then State.StickyTP = false end end})

TabCombat:CreateSection("Hitbox")
TabCombat:CreateToggle({Name = "เปิดระบบ Hitbox", CurrentValue = false, Callback = function(v) State.HitboxEnabled = v end})
TabCombat:CreateSlider({Name = "ขนาด Hitbox", Range = {1, 100}, Increment = 1, CurrentValue = 20, Callback = function(v) State.HitboxSize = v end})

-- VISUAL & ESP
TabVisual:CreateSection("ESP Settings")
TabVisual:CreateToggle({Name = "เปิดระบบมอง (ESP Name/Tracer)", CurrentValue = false, Callback = function(v) State.EspEnabled = v end})

TabVisual:CreateSection("Graphics")
TabVisual:CreateToggle({Name = "เปิดภาพสวย Ultra HD", CurrentValue = false, Callback = function(v)
    game:GetService("Lighting").Brightness = v and 2.5 or 1
    game:GetService("Lighting").GlobalShadows = v
end})
TabVisual:CreateSlider({Name = "ปลดล็อก FPS", Range = {60, 360}, Increment = 10, CurrentValue = 60, Callback = function(v) setfpscap(v) end})

-- MOVEMENT
TabMisc:CreateToggle({Name = "เปิดวิ่งอัดฉีด (Velocity)", CurrentValue = false, Callback = function(v) State.SpeedEnabled = v end})
TabMisc:CreateSlider({Name = "ความเร็ว", Range = {16, 500}, Increment = 5, CurrentValue = 16, Callback = function(v) State.CustomSpeed = v end})
TabMisc:CreateButton({Name = "💀 รีตัวด่วน", Callback = function() if plr.Character then plr.Character.Humanoid.Health = 0 end end})

-- [[ 🔴 4. CORE ENGINE ]] --

-- ESP Drawing (Safe Check)
local function CreateESP(p)
    local tracer, nameTag
    pcall(function() tracer = Drawing.new("Line") nameTag = Drawing.new("Text") end)
    if not tracer then return end
    game:GetService("RunService").RenderStepped:Connect(function()
        if State.EspEnabled and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
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
            if not p.Parent then tracer:Destroy() nameTag:Destroy() end
        end
    end)
end
for _, v in ipairs(game.Players:GetPlayers()) do if v ~= plr then CreateESP(v) end end
game.Players.PlayerAdded:Connect(function(v) if v ~= plr then CreateESP(v) end end)

-- Heartbeat Loop (Movement & TP)
game:GetService("RunService").Heartbeat:Connect(function()
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp, hum = plr.Character.HumanoidRootPart, plr.Character.Humanoid

    if State.AutoNearest then State.Target = GetNearest() end
    
    if State.Target then
        local t = game.Players:FindFirstChild(State.Target)
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            if State.StickyTP then hrp.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
            elseif State.UnderTP then hrp.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, -4.5, 0) end
        end
    end

    if State.SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
        hrp.Velocity = Vector3.new(hum.MoveDirection.X * State.CustomSpeed, hrp.Velocity.Y, hum.MoveDirection.Z * State.CustomSpeed)
    end

    if State.AttackSpeed then
        local tool = plr.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in ipairs(tool:GetDescendants()) do
                if v:IsA("NumberValue") and (v.Name:lower():find("wait") or v.Name:lower():find("delay")) then v.Value = 0 end
            end
        end
    end
end)

-- RenderStepped (Click & Hitbox)
game:GetService("RunService").RenderStepped:Connect(function()
    if State.AutoClick or State.StickyTP or State.UnderTP then
        local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end
    if State.HitboxEnabled then
        for _, v in ipairs(game.Players:GetPlayers()) do
            if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local p = v.Character.HumanoidRootPart
                p.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                p.Transparency, p.CanCollide = 0.85, false
            end
        end
    end
end)

-- Info Display
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

Rayfield:Notify({Title = "V36 READY", Content = "Copy and Enjoy!", Duration = 5})
