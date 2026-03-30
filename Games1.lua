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

    -- [[ CORE LOOP ]] --
    game:GetService("RunService").Heartbeat:Connect(function()
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
        local hrp = plr.Character.HumanoidRootPart
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")

        if AutoTargetNearest then TargetPlayer = GetNearestPlayer() end
        if SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
            hrp.Velocity = Vector3.new(hum.MoveDirection.X * CustomSpeed, hrp.Velocity.Y, hum.MoveDirection.Z * CustomSpeed)
        end
        if AttackSpeedEnabled then
            local tool = plr.Character:FindFirstChildOfClass("Tool")
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

    game:GetService("RunService").RenderStepped:Connect(function()
        if AutoClickEnabled or AutoTpKill or UnderTP then
            local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
        if HitboxEnabled then
            for _, v in ipairs(game.Players:GetPlayers()) do
                if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(HitboxSizeValue, HitboxSizeValue, HitboxSizeValue)
                    v.Character.HumanoidRootPart.Transparency, v.Character.HumanoidRootPart.CanCollide = 0.85, false
                end
            end
        end
    end)

    -- [[ MOVEMENT ]] --
    TabMain:CreateSection("Movement")
    TabMain:CreateToggle({Name = "เปิดวิ่งอัดฉีด (Velocity)", CurrentValue = false, Callback = function(v) SpeedEnabled = v end})
    TabMain:CreateSlider({Name = "ความแรง", Range = {16, 500}, Increment = 5, CurrentValue = 16, Callback = function(v) CustomSpeed = v end})
    TabMain:CreateButton({Name = "💀 รีตัวด่วน", Callback = function() if plr.Character then plr.Character.Humanoid.Health = 0 end end})

    Rayfield:Notify({Title = "V34 RECOVERY LOADED", Content = "Stable Version Active!", Duration = 5})
end)
en tool:Activate() end
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
