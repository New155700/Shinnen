-- [[ N-SHINNEN : TURBO E + MASTER MOBILE CONTROLS V7 ]] --

local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/49f2dcb1a4bf968cba35f5521c684bb6/raw/ae4518df255ca958f4a07b5e066ed9df1ad26cea/HiSHINUI"))()
local Win = Library:CreateWindow("🔥 N-SHINNEN TURBO + JOY")

local plr = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

getgenv().Speed = 16
getgenv().Distance = 50
getgenv().AutoE = false
getgenv().TurboMode = false
getgenv().ClickAmount = 1

---------------------------------------------------------
-- [ ระบบปุ่มเดินและกระโดด (Mobile UI) ]
---------------------------------------------------------
local controlGui = Instance.new("ScreenGui", game.CoreGui)
controlGui.Name = "N_Shinnen_Controls"
controlGui.ResetOnSpawn = false
controlGui.Enabled = true -- << เปิดไว้ให้เลยตั้งแต่รัน

-- จอยสติ๊ก (Joystick Base)
local joyBase = Instance.new("Frame", controlGui)
joyBase.Size = UDim2.new(0, 140, 0, 140)
joyBase.Position = UDim2.new(0, 50, 1, -220)
joyBase.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
joyBase.BackgroundTransparency = 0.6
Instance.new("UICorner", joyBase).CornerRadius = UDim.new(1, 0)
local joyStroke = Instance.new("UIStroke", joyBase)
joyStroke.Thickness = 2
joyStroke.Color = Color3.fromRGB(0, 255, 200) -- นีออนเขียวฟ้า

local joyStick = Instance.new("Frame", joyBase)
joyStick.Size = UDim2.new(0, 60, 0, 60)
joyStick.Position = UDim2.new(0.5, 0, 0.5, 0)
joyStick.AnchorPoint = Vector2.new(0.5, 0.5)
joyStick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
joyStick.BackgroundTransparency = 0.3
Instance.new("UICorner", joyStick).CornerRadius = UDim.new(1, 0)

-- ปุ่มกระโดด (Jump Button)
local jumpBtn = Instance.new("TextButton", controlGui)
jumpBtn.Size = UDim2.new(0, 90, 0, 90)
jumpBtn.Position = UDim2.new(1, -140, 1, -220)
jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
jumpBtn.BackgroundTransparency = 0.6
jumpBtn.Text = "JUMP"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.Font = Enum.Font.GothamBlack
jumpBtn.TextSize = 18
Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(1, 0)
local jumpStroke = Instance.new("UIStroke", jumpBtn)
jumpStroke.Thickness = 2
jumpStroke.Color = Color3.fromRGB(0, 255, 200)

-- ระบบจอยสติ๊กทำงาน
local isDragging, moveDir = false, Vector2.new(0, 0)
local joyInput = nil

joyBase.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        joyStick:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Back", 0.1)
        moveDir = Vector2.new(0, 0)
    end
end)

jumpBtn.MouseButton1Click:Connect(function()
    if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
        plr.Character:FindFirstChildOfClass("Humanoid").Jump = true
    end
end)

RunService.RenderStepped:Connect(function()
    if isDragging and plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum and moveDir.Magnitude > 0 then
            local cam = workspace.CurrentCamera
            local moveVector = (cam.CFrame.RightVector * moveDir.X) + (cam.CFrame.LookVector * -moveDir.Y)
            hum:Move(Vector3.new(moveVector.X, 0, moveVector.Z), false)
        end
    end
end)

---------------------------------------------------------
-- [ ระบบปุ่มลอย Turbo E ]
---------------------------------------------------------
local floatGui = Instance.new("ScreenGui", game.CoreGui)
floatGui.Name = "TurboFloating"
floatGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", floatGui)
toggleBtn.Size = UDim2.new(0, 100, 0, 100)
toggleBtn.Position = UDim2.new(0.5, -50, 0, 50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleBtn.Text = "TURBO: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextSize = 14
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local turboStroke = Instance.new("UIStroke", toggleBtn)
turboStroke.Thickness = 3
turboStroke.Color = Color3.fromRGB(255, 50, 50)

local draggingF, dragInputF, dragStartF, startPosF
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingF = true; dragStartF = input.Position; startPosF = toggleBtn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if draggingF and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartF
        toggleBtn.Position = UDim2.new(startPosF.X.Scale, startPosF.X.Offset + delta.X, startPosF.Y.Scale, startPosF.Y.Offset + delta.Y)
    end
end)
toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingF = false end
end)

local function SyncAutoE(state)
    getgenv().AutoE = state
    toggleBtn.Text = state and "TURBO: ON" or "TURBO: OFF"
    toggleBtn.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
    turboStroke.Color = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
end

toggleBtn.MouseButton1Click:Connect(function()
    SyncAutoE(not getgenv().AutoE)
end)

---------------------------------------------------------
-- [ Master Logic ]
---------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                    v.ClickablePrompt = true
                    v.RequiresLineOfSight = false
                    v.MaxActivationDistance = getgenv().Distance
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if getgenv().AutoE then
            pcall(function()
                local count = getgenv().TurboMode and 40 or getgenv().ClickAmount
                for i = 1, count do
                    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
            end)
        end
    end
end)

---------------------------------------------------------
-- [ เมนู UI ]
---------------------------------------------------------
local MainTab = Win:CreateTab("Settings")
local JoySec = MainTab:CreateSection("🕹️ Mobile Controls")

JoySec:CreateToggle("แสดงปุ่มเดินและกระโดด", function(v)
    controlGui.Enabled = v
end)

local FarmSec = MainTab:CreateSection("⚡ Turbo Click System")

FarmSec:CreateToggle("Auto Turbo E (Instant)", function(v)
    SyncAutoE(v)
end)

FarmSec:CreateToggle("โหมดกด 1 ครั้ง = 40 ครั้ง", function(v)
    getgenv().TurboMode = v
end)

FarmSec:CreateSlider("ความเร็วเดิน", 16, 500, 16, function(v)
    getgenv().Speed = v
end)

FarmSec:CreateSlider("ระยะกด (Reach)", 10, 500, 50, function(v)
    getgenv().Distance = v
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = getgenv().Speed
            end
        end)
    end
end)

Library:Notify("N-SHINNEN", "ระบบ Turbo + ปุ่มเดินมาแล้วครับลูกพี่!", 5)
