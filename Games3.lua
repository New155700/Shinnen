-- [[ SHINNEN HUB | V61.2 HYPER-DRIVE NUCLEAR ]] --
-- ปรับจูน: Aura ไวระดับมิลลิวินาที + ระบบ Lag ทำลายล้าง (Nuclear) --
-- แก้ไข: เพิ่มระบบป้องกันตกแมพ + โหลดแมพไวขึ้น (ห้ามแก้ส่วนอื่น) --

pcall(function()
    _G.ShinnenActive = false
    task.wait(0.1)
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "Rayfield" then v:Destroy() end
    end
end)

-- [0] ระบบแก้ตกแมพ (Anti-Fall & Map Loader)
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    -- บังคับโหลดพื้นที่รอบตัวละคร (Streaming Optimization)
    if plr.ReplicationFocus == nil then
        plr.ReplicationFocus = hrp
    end
    
    -- ตรวจสอบพื้นผิว: ถ้าไม่มีพื้น ให้ยึดตัวไว้กันตก
    RunService.Heartbeat:Connect(function()
        if _G.ShinnenActive then
            local ray = Ray.new(hrp.Position, Vector3.new(0, -20, 0))
            local hit = workspace:FindPartOnRay(ray, char)
            if not hit then
                hrp.Velocity = Vector3.new(0, 0, 0) -- หยุดแรงโน้มถ่วงชั่วคราวถ้าไม่มีพื้น
            end
        end
    end)
end)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Win = Rayfield:CreateWindow({
    Name = "Shinnen Hub | V61.2 NUCLEAR",
    LoadingTitle = "👿 Map Overclocking & Anti-Fall...",
    LoadingSubtitle = "by New155700",
    ConfigurationSaving = {Enabled = false}
})

-- [1] ตัวแปรระบบ (Fast-Access Global)
_G.ShinnenActive = true
_G.WalkSpeed = 50
_G.AutoAura = false
_G.AuraRange = 100
_G.MaxReach = 500
_G.AntiStatus = true
_G.LagAura = false
_G.LagPower = 2000 

local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- [2] ระบบ NUCLEAR LAG (ถล่มทีมอื่น - โครงสร้างเดิม)
local function CreateNuclearLag(p)
    if p == plr then return end
    task.spawn(function()
        local att = Instance.new("Attachment")
        local emit = Instance.new("ParticleEmitter")
        emit.Texture = "rbxassetid://241381931"
        emit.Size = NumberSequence.new(80, 80)
        emit.Transparency = NumberSequence.new(0.95)
        emit.Lifetime = NumberRange.new(0.05)
        emit.Rate = 0
        emit.RotSpeed = NumberRange.new(50000)
        emit.Speed = NumberRange.new(0)
        emit.Parent = att
        
        local function Attach(char)
            local hrp = char:WaitForChild("HumanoidRootPart", 10)
            if hrp then att.Parent = hrp end
        end
        if p.Character then Attach(p.Character) end
        p.CharacterAdded:Connect(Attach)
        
        RunService.Heartbeat:Connect(function()
            if _G.LagAura and (p.Team ~= plr.Team or p.Team == nil) then
                emit.Rate = _G.LagPower
                emit.Enabled = true
            else
                emit.Enabled = false
            end
        end)
    end)
end

for _, p in pairs(game.Players:GetPlayers()) do CreateNuclearLag(p) end
game.Players.PlayerAdded:Connect(CreateNuclearLag)

-- [3] ระบบ HYPER-DRIVE (Aura & Reach ไวที่สุด - โครงสร้างเดิม)
RunService.RenderStepped:Connect(function()
    if not _G.ShinnenActive then return end
    pcall(function()
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if hum and _G.AntiStatus then
            hum.PlatformStand = false
            hum.Sit = false
            hum.WalkSpeed = _G.WalkSpeed
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Anchored then part.Anchored = false end
            end
        end

        if _G.AutoAura and hrp then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.MaxActivationDistance = _G.MaxReach
                    v.RequiresLineOfSight = false
                    v.HoldDuration = 0
                    
                    local pPos = v.Parent:IsA("BasePart") and v.Parent.Position or v.Parent:GetPivot().Position
                    if (hrp.Position - pPos).Magnitude <= _G.AuraRange then
                        task.spawn(function()
                            v:InputHoldBegin()
                            v:InputHoldEnd()
                        end)
                    end
                end
            end
        end
    end)
end)

-- [4] UI TABS
local TabMain = Win:CreateTab("Main & God Mode")
local TabExploit = Win:CreateTab("💀 Exploits")

TabMain:CreateSection("⚡ Movement & Status")
TabMain:CreateInput({
    Name = "⚡ Speed",
    PlaceholderText = "50",
    Callback = function(v) _G.WalkSpeed = tonumber(v) or 50 end
})

TabMain:CreateToggle({
    Name = "🛡️ ปลดสถานะติดบัค/มึน (Anti-Status)",
    CurrentValue = true,
    Callback = function(v) _G.AntiStatus = v end
})

TabMain:CreateSection("⭕ Reach & Aura")
TabMain:CreateToggle({
    Name = "⭕ เปิด Auto Aura (ไวระดับแสง)",
    CurrentValue = false,
    Callback = function(v) _G.AutoAura = v end
})

TabMain:CreateInput({
    Name = "📏 ระยะขยายปุ่ม (Reach Distance)",
    PlaceholderText = "ใส่ตัวเลขระยะ",
    Callback = function(v) _G.MaxReach = tonumber(v) or 500 end
})

TabExploit:CreateSection("💀 Nuclear Lag (คนอื่นค้าง)")
TabExploit:CreateToggle({
    Name = "💀 เปิด Nuclear Lag (ถล่มทีมอื่น)",
    CurrentValue = false,
    Callback = function(v) _G.LagAura = v end
})

TabExploit:CreateInput({
    Name = "☢️ Nuclear Power",
    PlaceholderText = "ใส่ค่าความแรง",
    Callback = function(v) _G.LagPower = tonumber(v) or 1000 end
})

Rayfield:Notify({Title = "V61.2 READY", Content = "Anti-Fall & Loader Active!", Duration = 5})
