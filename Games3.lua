-- [[ N-SHINNEN : NEON SMART CONTROLS & TURBO BYPASS V10 ]] --

local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/49f2dcb1a4bf968cba35f5521c684bb6/raw/ae4518df255ca958f4a07b5e066ed9df1ad26cea/HiSHINUI"))()
local Win = Library:CreateWindow("🔥 N-SHINNEN V10 NEON")

local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

getgenv().Speed = 16
getgenv().Distance = 100
getgenv().AutoE = false
getgenv().TurboAmount = 10 -- ตั้งค่ากด 1 เป็น 10 ครั้ง

---------------------------------------------------------
-- [ ระบบ Mobile UI ดีไซน์ใหม่ (Neon Style) ]
---------------------------------------------------------
local controlGui = Instance.new("ScreenGui", game.CoreGui)
controlGui.Name = "N_Shinnen_NeonControls"
controlGui.DisplayOrder = 999

-- สร้างจอยสติ๊ก (Joystick Base)
local joyBase = Instance.new("Frame", controlGui)
joyBase.Size = UDim2.new(0, 140, 0, 140)
joyBase.Position = UDim2.new(0, 50, 1, -220)
joyBase.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
joyBase.BackgroundTransparency = 0.4
Instance.new("UICorner", joyBase).CornerRadius = UDim.new(1, 0)
local joyStroke = Instance.new("UIStroke", joyBase)
joyStroke.Thickness = 3
joyStroke.Color = Color3.fromRGB(0, 255, 255) -- สีนีออนฟ้า

local joyStick = Instance.new("Frame", joyBase)
joyStick.Size = UDim2.new(0, 60, 0, 60)
joyStick.Position = UDim2.new(0.5, 0, 0.5, 0)
joyStick.AnchorPoint = Vector2.new(0.5, 0.5)
joyStick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
joyStick.BackgroundTransparency = 0.2
Instance.new("UICorner", joyStick).CornerRadius = UDim.new(1, 0)
local innerStroke = Instance.new("UIStroke", joyStick)
innerStroke.Thickness = 2
innerStroke.Color = Color3.fromRGB(0, 0, 0)

-- ปุ่มกระโดด (Neon Jump)
local jumpBtn = Instance.new("TextButton", controlGui)
jumpBtn.Size = UDim2.new(0, 100, 0, 100)
jumpBtn.Position = UDim2.new(1, -150, 1, -220)
jumpBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
jumpBtn.BackgroundTransparency = 0.4
jumpBtn.Text = "JUMP"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.Font = Enum.Font.GothamBlack
jumpBtn.TextSize = 18
Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(1, 0)
local jumpStroke = Instance.new("UIStroke", jumpBtn)
jumpStroke.Thickness = 3
jumpStroke.Color = Color3.fromRGB(255, 0, 127) -- สีนีออนชมพู/แดง

-- Logic การควบคุม
local isDragging, moveDir = false, Vector2.new(0, 0)
local joyInput = nil

joyBase.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        isDragging = true; joyInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == joyInput and isDragging then
        local center = joyBase.AbsolutePosition + (joyBase.AbsoluteSize / 2)
        local delta = Vector2.new(input.Position.X, input.Position.Y) - center
        local maxDist = joyBase.AbsoluteSize.X / 2
        if delta.Magnitude > maxDist then delta = delta.Unit * maxDist end
        joyStick.Position = UDim2.new(0.5, delta.X, 0.5, delta.Y)
        moveDir = delta / maxDist
    end
end)

UIS.InputEnded:Connect(function(input)
    if input == joyInput then
        isDragging = false; joyInput = nil
        joyStick:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Back", 0.15)
        moveDir = Vector2.new(0, 0)
    end
end)

jumpBtn.MouseButton1Click:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

---------------------------------------------------------
-- [ ระบบ Turbo Auto E (Instant x10) ]
---------------------------------------------------------
task.spawn(function()
    while task.wait(0.05) do -- วนลูปไวขึ้น
        if getgenv().AutoE then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                    v.MaxActivationDistance = getgenv().Distance
                    
                    -- ตรวจสอบระยะตัวละคร
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local root = plr.Character.HumanoidRootPart
                        local promptPart = v.Parent:IsA("BasePart") and v.Parent or root
                        if (root.Position - promptPart.Position).Magnitude <= v.MaxActivationDistance then
                            -- ส่งคำสั่งกดรัว 10 ครั้งในทีเดียว
                            for i = 1, getgenv().TurboAmount do
                                v:InputHoldBegin()
                                v:InputHoldEnd()
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ระบบเดิน (แยกทัช)
RunService.RenderStepped:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        local hum = plr.Character.Humanoid
        hum.WalkSpeed = getgenv().Speed
        
        if isDragging and moveDir.Magnitude > 0 then
            local cam = workspace.CurrentCamera
            local look = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local walkDir = (right * moveDir.X) + (Vector3.new(look.X, 0, look.Z).Unit * -moveDir.Y)
            hum:Move(walkDir, false)
        end
    end
end)

---------------------------------------------------------
-- [ เมนู UI ]
---------------------------------------------------------
local MainTab = Win:CreateTab("Settings")
local StyleSec = MainTab:CreateSection("🕹️ Neon Controls")

StyleSec:CreateToggle("แสดงจอยสติ๊ก & ปุ่มกระโดด", function(v)
    controlGui.Enabled = v
end)

local FarmSec = MainTab:CreateSection("⚡ Turbo Farm (Instant)")

FarmSec:CreateToggle("Auto Turbo E (x10 Speed)", function(v)
    getgenv().AutoE = v
end)

FarmSec:CreateSlider("ความเร็วเดิน", 16, 500, 16, function(v)
    getgenv().Speed = v
end)

FarmSec:CreateSlider("ระยะการกด (Reach)", 10, 800, 100, function(v)
    getgenv().Distance = v
end)

Library:Notify("N-SHINNEN V10", "ระบบ Turbo E x10 และจอยสติ๊กนีออน พร้อมซิ่ง!", 5)
