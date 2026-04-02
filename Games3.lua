-- [[ N-SHINNEN : SMART CONTROLS & INSTANT BYPASS V9 ]] --

local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/49f2dcb1a4bf968cba35f5521c684bb6/raw/ae4518df255ca958f4a07b5e066ed9df1ad26cea/HiSHINUI"))()
local Win = Library:CreateWindow("🔥 N-SHINNEN V9 SMART")

local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

getgenv().Speed = 16
getgenv().Distance = 100
getgenv().AutoE = false

---------------------------------------------------------
-- [ ระบบ Mobile Joystick แยกทัชจอ (Independent Touch) ]
---------------------------------------------------------
local controlGui = Instance.new("ScreenGui", game.CoreGui)
controlGui.Name = "N_Shinnen_SmartControls"
controlGui.DisplayOrder = 10 -- ให้ปุ่มอยู่เลเยอร์บนสุดเพื่อไม่ให้ทับกับระบบหมุนจอ

local joyBase = Instance.new("Frame", controlGui)
joyBase.Size = UDim2.new(0, 130, 0, 130)
joyBase.Position = UDim2.new(0, 40, 1, -200)
joyBase.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
joyBase.BackgroundTransparency = 0.5
Instance.new("UICorner", joyBase).CornerRadius = UDim.new(1, 0)

local joyStick = Instance.new("Frame", joyBase)
joyStick.Size = UDim2.new(0, 50, 0, 50)
joyStick.Position = UDim2.new(0.5, 0, 0.5, 0)
joyStick.AnchorPoint = Vector2.new(0.5, 0.5)
joyStick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", joyStick).CornerRadius = UDim.new(1, 0)

local jumpBtn = Instance.new("TextButton", controlGui)
jumpBtn.Size = UDim2.new(0, 85, 0, 85)
jumpBtn.Position = UDim2.new(1, -120, 1, -200)
jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
jumpBtn.BackgroundTransparency = 0.5
jumpBtn.Text = "JUMP"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.Font = Enum.Font.GothamBlack
Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(1, 0)

-- Logic เดินและกระโดดผ่าน Humanoid State
local isDragging, moveDir = false, Vector2.new(0, 0)
local joyInput = nil

joyBase.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        isDragging = true; joyInput = input
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then isDragging = false; joyInput = nil end
        end)
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

jumpBtn.MouseButton1Click:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- สั่งกระโดดผ่านสถานะตัวละคร
    end
end)

RunService.RenderStepped:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        local hum = plr.Character.Humanoid
        hum.WalkSpeed = getgenv().Speed
        
        if isDragging and moveDir.Magnitude > 0 then
            local cam = workspace.CurrentCamera
            local lookVector = cam.CFrame.LookVector
            local rightVector = cam.CFrame.RightVector
            local walkDir = (rightVector * moveDir.X) + (Vector3.new(lookVector.X, 0, lookVector.Z).Unit * -moveDir.Y)
            hum:Move(walkDir, false)
        end
    end
end)

---------------------------------------------------------
-- [ ระบบ Instant Bypass Proximity ]
---------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
                v.MaxActivationDistance = getgenv().Distance
                if getgenv().AutoE then
                    v:InputHoldBegin()
                    v:InputHoldEnd()
                end
            end
        end
    end
end)

---------------------------------------------------------
-- [ เมนู UI ]
---------------------------------------------------------
local MainTab = Win:CreateTab("Settings")
local ControlSec = MainTab:CreateSection("🕹️ Mobile UI")

ControlSec:CreateToggle("แสดงปุ่มเดินและกระโดด", function(v)
    controlGui.Enabled = v
end)

local FarmSec = MainTab:CreateSection("⚡ Farm System")

FarmSec:CreateToggle("Auto Bypass (กดทันที)", function(v)
    getgenv().AutoE = v
end)

FarmSec:CreateSlider("ความเร็วเดิน", 16, 500, 16, function(v)
    getgenv().Speed = v
end)

FarmSec:CreateSlider("ระยะการกด", 10, 500, 100, function(v)
    getgenv().Distance = v
end)

Library:Notify("N-SHINNEN V9", "แยกปุ่มเดินและระบบกระโดดอัจฉริยะแล้ว!", 5)
