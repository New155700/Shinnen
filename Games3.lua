-- [[ N-SHINNEN : LOADER & UI BRIDGE ]] --

-- 1. ดึง Library
local URL = "https://gist.githubusercontent.com/New155700/3b4ee43d4cccb63f00fe75702086590a/raw/99d545c6d6784de87103009ddfd81f55f1f4bac2/Shinen"
local success, NScanner = pcall(function()
    return loadstring(game:HttpGet(URL))()
end)

if not success then return end

-- 2. สร้างหน้าต่าง และหน้าเมนู
local Win = NScanner:CreateWindow("N-SHINNEN HUB")
local MainTab = Win:CreateTab("Main Settings")

-- 3. ตัวแปรพื้นฐาน
local plr = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

getgenv().Speed = 16
getgenv().Distance = 50
getgenv().AutoE = false

---------------------------------------------------------
-- [ ระบบหน้าต่างลอย Floating Button ]
---------------------------------------------------------
local floatGui = Instance.new("ScreenGui")
floatGui.Name = "FloatingAutoE"
floatGui.ResetOnSpawn = false
floatGui.Parent = game.CoreGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0.5, -60, 0, 20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleBtn.Text = "Auto E : OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
local uiCornerFloat = Instance.new("UICorner")
uiCornerFloat.CornerRadius = UDim.new(0, 8)
uiCornerFloat.Parent = toggleBtn
toggleBtn.Parent = floatGui

-- Drag Logic
local dragToggle, dragInput2, dragStart2, startPos2
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true; dragStart2 = input.Position; startPos2 = toggleBtn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput2 = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput2 and dragToggle then
        local delta = input.Position - dragStart2
        toggleBtn.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
    end
end)
toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = false
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    getgenv().AutoE = not getgenv().AutoE
    toggleBtn.Text = getgenv().AutoE and "Auto E : ON" or "Auto E : OFF"
    toggleBtn.BackgroundColor3 = getgenv().AutoE and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(255, 50, 50)
end)

---------------------------------------------------------
-- [ ระบบ UI Controls (จอยสติ๊ก) ]
---------------------------------------------------------
local controlGui = Instance.new("ScreenGui")
controlGui.Enabled = false
controlGui.Parent = game.CoreGui

local joyBase = Instance.new("Frame")
joyBase.Size = UDim2.new(0, 130, 0, 130)
joyBase.Position = UDim2.new(0, 50, 1, -200)
joyBase.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
joyBase.BackgroundTransparency = 0.5
local uiCornerBase = Instance.new("UICorner")
uiCornerBase.CornerRadius = UDim.new(1, 0)
uiCornerBase.Parent = joyBase
joyBase.Parent = controlGui

local joyStick = Instance.new("Frame")
joyStick.Size = UDim2.new(0, 50, 0, 50)
joyStick.Position = UDim2.new(0.5, 0, 0.5, 0)
joyStick.AnchorPoint = Vector2.new(0.5, 0.5)
joyStick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
local uiCornerStick = Instance.new("UICorner")
uiCornerStick.CornerRadius = UDim.new(1, 0)
uiCornerStick.Parent = joyStick
joyStick.Parent = joyBase

local isDragging, moveDirX, moveDirY, dragInput = false, 0, 0, nil
joyBase.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true; dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and isDragging then
        local baseCenter = joyBase.AbsolutePosition + (joyBase.AbsoluteSize / 2)
        local delta = Vector2.new(input.Position.X, input.Position.Y) - baseCenter
        local maxRadius = joyBase.AbsoluteSize.X / 2
        if delta.Magnitude > maxRadius then delta = delta.Unit * maxRadius end
        joyStick.Position = UDim2.new(0.5, delta.X, 0.5, delta.Y)
        moveDirX, moveDirY = delta.X / maxRadius, delta.Y / maxRadius
    end
end)
UIS.InputEnded:Connect(function(input)
    if input == dragInput then
        isDragging = false; dragInput = nil
        joyStick:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Back", 0.2)
        moveDirX, moveDirY = 0, 0
    end
end)

RunService.RenderStepped:Connect(function()
    if isDragging and plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local cam = workspace.CurrentCamera
            local forward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
            local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit
            hum:Move((right * moveDirX) + (forward * -moveDirY), false)
        end
    end
end)

---------------------------------------------------------
-- [ วงจรทำงานหลัก ]
---------------------------------------------------------

-- Speed Loop
task.spawn(function()
    while task.wait() do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                plr.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = getgenv().Speed
            end
        end)
    end
end)

-- Reach Loop (ระยะกด)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                    v.MaxActivationDistance = getgenv().Distance
                    v.RequiresLineOfSight = false
                end
            end
        end)
    end
end)

-- Auto E Loop
task.spawn(function()
    while task.wait() do
        if getgenv().AutoE then
            pcall(function()
                VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)
        end
    end
end)

---------------------------------------------------------
-- [ การตั้งค่าหน้าเมนู UI ]
---------------------------------------------------------

MainTab:AddToggle("🕹️ เปิดระบบควบคุม", false, function(v)
    controlGui.Enabled = v
end)

MainTab:AddSlider("📏 ระยะกด (Reach)", 10, 500, 50, function(v)
    getgenv().Distance = tonumber(v)
end)

MainTab:AddInput("⚡ ความเร็วเดิน", function(v)
    getgenv().Speed = tonumber(v) or 16
end)

MainTab:AddToggle("⌨️ Auto Press E", false, function(v)
    getgenv().AutoE = v
end)

NScanner:Notify("N-SHINNEN", "อัปเดตระบบเสร็จสมบูรณ์!", 5)
