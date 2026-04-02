-- [[ N-SHINNEN : FULL OPTIMIZED & SMOOTH MOBILE CONTROLS ]] --

-- 1. ดึง UI Library ตัวล่าสุดของพี่ (HiSHINUI)
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/49f2dcb1a4bf968cba35f5521c684bb6/raw/ae4518df255ca958f4a07b5e066ed9df1ad26cea/HiSHINUI"))()
local Win = Library:CreateWindow("🔥 N-SHINNEN MOBILE")

-- 2. ตัวแปรพื้นฐาน
local plr = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

getgenv().Speed = 16
getgenv().Distance = 50
getgenv().AutoE = false
getgenv().ClickAmount = 1 

---------------------------------------------------------
-- [ ระบบหน้าต่างลอย Floating Button ]
---------------------------------------------------------
local floatGui = Instance.new("ScreenGui", game.CoreGui)
floatGui.Name = "FloatingAutoE"
floatGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", floatGui)
toggleBtn.Size = UDim2.new(0, 100, 0, 100) -- ปรับเป็นวงกลม
toggleBtn.Position = UDim2.new(0.5, -50, 0, 50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.Text = "E: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextSize = 16

local uiCornerFloat = Instance.new("UICorner", toggleBtn)
uiCornerFloat.CornerRadius = UDim.new(1, 0)

local btnStroke = Instance.new("UIStroke", toggleBtn)
btnStroke.Thickness = 3
btnStroke.Color = Color3.fromRGB(255, 50, 50)

-- ระบบลากปุ่มลอย (Mobile Friendly)
local dragging, dragInput, dragStart, startPos
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = toggleBtn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

---------------------------------------------------------
-- [ ระบบจอยสติ๊ก (Joystick) ]
---------------------------------------------------------
local controlGui = Instance.new("ScreenGui", game.CoreGui)
controlGui.Name = "CustomMobileControls"
controlGui.Enabled = false

local joyBase = Instance.new("Frame", controlGui)
joyBase.Size = UDim2.new(0, 130, 0, 130)
joyBase.Position = UDim2.new(0, 50, 1, -180)
joyBase.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
joyBase.BackgroundTransparency = 0.6
Instance.new("UICorner", joyBase).CornerRadius = UDim.new(1, 0)

local joyStick = Instance.new("Frame", joyBase)
joyStick.Size = UDim2.new(0, 55, 0, 55)
joyStick.Position = UDim2.new(0.5, 0, 0.5, 0)
joyStick.AnchorPoint = Vector2.new(0.5, 0.5)
joyStick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
joyStick.BackgroundTransparency = 0.4
Instance.new("UICorner", joyStick).CornerRadius = UDim.new(1, 0)

local isDraggingJoy, moveDir = false, Vector2.new(0, 0)
local joyInput = nil

joyBase.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingJoy = true; joyInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == joyInput and isDraggingJoy then
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
        isDraggingJoy = false; joyInput = nil
        joyStick:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Back", 0.15)
        moveDir = Vector2.new(0, 0)
    end
end)

RunService.RenderStepped:Connect(function()
    if isDraggingJoy and plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum and moveDir.Magnitude > 0 then
            local cam = workspace.CurrentCamera
            local moveVector = (cam.CFrame.RightVector * moveDir.X) + (cam.CFrame.LookVector * -moveDir.Y)
            hum:Move(Vector3.new(moveVector.X, 0, moveVector.Z), false)
        end
    end
end)

---------------------------------------------------------
-- [ Logic & งานเบื้องหลัง ]
---------------------------------------------------------

local function SyncAutoE(state)
    getgenv().AutoE = state
    toggleBtn.Text = state and "E: ON" or "E: OFF"
    toggleBtn.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
    btnStroke.Color = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
end

toggleBtn.MouseButton1Click:Connect(function()
    SyncAutoE(not getgenv().AutoE)
end)

-- Loop WalkSpeed
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = getgenv().Speed
            end
        end)
    end
end)

-- Loop Auto E
task.spawn(function()
    while task.wait() do
        if getgenv().AutoE then
            pcall(function()
                for i = 1, getgenv().ClickAmount do
                    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
            end)
        end
    end
end)

---------------------------------------------------------
-- [ สร้างเมนูหน้าต่างหลัก ]
---------------------------------------------------------

local MainTab = Win:CreateTab("Main Settings")
local ControlSec = MainTab:CreateSection("🕹️ Mobile Controls")

ControlSec:CreateToggle("Bypass Joystick", function(v)
    controlGui.Enabled = v
end)

local FarmSec = MainTab:CreateSection("⚡ Farm System")

FarmSec:CreateToggle("Auto Press E (Keyboard)", function(v)
    SyncAutoE(v) -- ซิงค์กับปุ่มลอยด้วย
end)

FarmSec:CreateToggle("Super Speed Click (x100)", function(v)
    getgenv().ClickAmount = v and 100 or 1
end)

FarmSec:CreateSlider("Walk Speed", 16, 250, 16, function(v)
    getgenv().Speed = v
end)

FarmSec:CreateSlider("Reach Distance", 10, 300, 50, function(v)
    getgenv().Distance = v
    pcall(function()
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                prompt.MaxActivationDistance = v
                prompt.HoldDuration = 0
            end
        end
    end)
end)
