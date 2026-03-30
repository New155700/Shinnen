-- [[ SHINNEN HUB | V16 RGB TOGGLE EDITION ]] --
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Win = Rayfield:CreateWindow({
    Name = "Shinnen Hub | V1 Custom",
    LoadingTitle = "Splitting Toggles...👿👿",
    LoadingSubtitle = "by Shinnen Custom 👿👿",
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
    Name = "วาร์ปจุดแรกสุด (Original CF)",
    Callback = function() if plr.Character then plr.Character.HumanoidRootPart.CFrame = posOriginal end end
})

TabTp:CreateButton({
    Name = "วาร์ป 2vs2 (จุดที่ 1)",
    Callback = function() if plr.Character then plr.Character.HumanoidRootPart.CFrame = pos2vs2_1 end end
})

TabTp:CreateButton({
    Name = "วาร์ป 2vs2 (จุดที่ 2)",
    Callback = function() if plr.Character then plr.Character.HumanoidRootPart.CFrame = pos2vs2_2 end end
})

-- [[ 4. GRAPHICS & FPS ]] --
TabVisual:CreateToggle({
    Name = "โหมดภาพสวยคมชัด (High Graphics)",
    CurrentValue = false,
    Callback = function(v)
        local lighting = game:GetService("Lighting")
        if v then
            lighting.Brightness = 2.5
            lighting.FogEnd = 100000
            local bloom = lighting:FindFirstChild("ShinnenBloom") or Instance.new("BloomEffect", lighting)
            bloom.Intensity = 0.5
            bloom.Enabled = true
        else
            lighting.Brightness = 1
            if lighting:FindFirstChild("ShinnenBloom") then lighting.ShinnenBloom.Enabled = false end
        end
    end
})

TabVisual:CreateSlider({
   Name = "ปลดล็อก FPS",
   Range = {60, 360},
   Increment = 10,
   CurrentValue = 60,
   Callback = function(v) setfpscap(v) end,
})

-- [[ CORE SYSTEM INJECTION ]] --
game:GetService("RunService").Heartbeat:Connect(function()
    pcall(function()
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if char and hum and hrp then
            if SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
                hrp.Velocity = Vector3.new(hum.MoveDirection.X * CustomSpeed, hrp.Velocity.Y, hum.MoveDirection.Z * CustomSpeed)
            end
            if AntiFallEnabled and (hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.FallingDown) then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            if AttackSpeedEnabled then
                local tool = char:FindFirstChildWhichIsA("Tool")
                if tool then
                    for _, v in pairs(tool:GetDescendants()) do
                        if v:IsA("NumberValue") and (v.Name:lower():find("cooldown") or v.Name:lower():find("wait")) then
                            v.Value = 0.01
                        end
                    end
                end
            end
        end
    end)
end)

-- [[ DYNAMIC HITBOX LOOP ]] --
task.spawn(function()
    while task.wait(0.5) do
        local Color = Color3.fromHSV(tick() % 5 / 5, 1, 1) 
        
        pcall(function()
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local TargetPart = v.Character.HumanoidRootPart
                    
                    if HitboxEnabled then
                        TargetPart.Size = HitboxSize
                        TargetPart.CanCollide = false
                        TargetPart.Transparency = 0.8 -- ความจางคงที่เพื่อความสบายตา
                        
                        -- เช็กว่าเปิด RGB หรือไม่
                        if HitboxRGB then
                            TargetPart.Color = Color
                            TargetPart.Material = Enum.Material.Neon
                        else
                            TargetPart.Color = Color3.fromRGB(255, 0, 0) -- สีแดงปกติถ้าไม่เปิด RGB
                            TargetPart.Material = Enum.Material.Plastic
                        end
                    else
                        -- คืนค่าเดิมถ้าปิด Hitbox
                        TargetPart.Size = Vector3.new(2, 2, 1)
                        TargetPart.Transparency = 1
                    end
                end
            Custom
        end)
    end
end)

Rayfield:Notify({Title = "V1 Final Updated", Content = "แยกปุ่มเปิด-ปิด Hitbox และ RGB เรียบร้อยครับ", Duration = 5})
