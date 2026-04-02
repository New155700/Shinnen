-- [[ N-SHINNEN : FULL OPTIMIZED & SMOOTH MOBILE CONTROLS ]] --

-- 1. ดึง Library (ห้ามเปลี่ยน URL)
local URL = "https://gist.githubusercontent.com/New155700/3b4ee43d4cccb63f00fe75702086590a/raw/99d545c6d6784de87103009ddfd81f55f1f4bac2/Shinen"
local NScanner = loadstring(game:HttpGet(URL))()

-- 2. สร้างหน้าต่าง และหน้าเมนู
local Win = NScanner:CreateWindow()
local MainTab = Win:CreateTab("Main Settings")

-- 3. ตัวแปรพื้นฐาน
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
-- [ ระบบ UI Controls (จอยสติ๊กแบบเนียนพิเศษ) ]
---------------------------------------------------------
local controlGui = Instance.new("ScreenGui")
controlGui.Name = "CustomMobileControls"
controlGui.Enabled = false
controlGui.ResetOnSpawn = false
controlGui.Parent = game.CoreGui

local joyBase = Instance.new("Frame")
joyBase.Size = UDim2.new(0, 140, 0, 140)
joyBase.Position = UDim2.new(0, 40, 1, -210)
joyBase.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
joyBase.BackgroundTransparency = 0.7
joyBase.Active = true 
local uiCornerBase = Instance.new("UICorner")
uiCornerBase.CornerRadius = UDim.new(1, 0)
uiCornerBase.Parent = joyBase
joyBase.Parent = controlGui

local joyStick = Instance.new("Frame")
joyStick.Size = UDim2.new(0, 60, 0, 60)
joyStick.Position = UDim2.new(0.5, 0, 0.5, 0)
joyStick.AnchorPoint = Vector2.new(0.5, 0.5)
joyStick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
joyStick.BackgroundTransparency = 0.4
local uiCornerStick = Instance.new("UICorner")
uiCornerStick.CornerRadius = UDim.new(1, 0)
uiCornerStick.Parent = joyStick
joyStick.Parent = joyBase

local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0, 85, 0, 85)
jumpBtn.Position = UDim2.new(1, -135, 1, -165)
jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
jumpBtn.BackgroundTransparency = 0.7
jumpBtn.Text = "JUMP"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.Font = Enum.Font.GothamBold
jumpBtn.TextSize = 16
jumpBtn.Active = true
jumpBtn.Modal = true 
local uiCornerJump = Instance.new("UICorner")
uiCornerJump.CornerRadius = UDim.new(1, 0)
uiCornerJump.Parent = jumpBtn
jumpBtn.Parent = controlGui

jumpBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local isDragging, moveDir = false, Vector2.new(0, 0)
local dragInput = nil

joyBase.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true; dragInput = input; joyBase.Modal = true 
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and isDragging then
        local baseCenter = joyBase.AbsolutePosition + (joyBase.AbsoluteSize / 2)
        local delta = Vector2.new(input.Position.X, input.Position.Y) - baseCenter
        local maxRadius = joyBase.AbsoluteSize.X / 2
        
        if delta.Magnitude > maxRadius then
            delta = delta.Unit * maxRadius
        end
        
        joyStick.Position = UDim2.new(0.5, delta.X, 0.5, delta.Y)
        -- คำนวณความแรงตามระยะที่ดันจอย (เนียนขึ้น)
        moveDir = delta / maxRadius
    end
end)

UIS.InputEnded:Connect(function(input)
    if input == dragInput then
        isDragging = false; dragInput = nil; joyBase.Modal = false
        joyStick:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Back", 0.15)
        moveDir = Vector2.new(0, 0)
    end
end)

-- ระบบเดินแบบเนียน (Camera Relative)
RunService.RenderStepped:Connect(function()
    if isDragging and plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum and moveDir.Magnitude > 0 then
            local cam = workspace.CurrentCamera
            local camCFrame = cam.CFrame
            
            -- เดินตามกล้องเป๊ะๆ
            local look = camCFrame.LookVector
            local right = camCFrame.RightVector
            
            local moveVector = (right * moveDir.X) + (look * -moveDir.Y)
            hum:Move(Vector3.new(moveVector.X, 0, moveVector.Z), false)
        end
    end
end)

---------------------------------------------------------
-- [ วงจรทำงานหลัก ]
---------------------------------------------------------

task.spawn(function()
    while task.wait() do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                plr.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = getgenv().Speed
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                    v.ClickablePrompt = true
                    v.MaxActivationDistance = getgenv().Distance
                    v.RequiresLineOfSight = false
                end
            end
        end)
    end
end)

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
-- [ เมนู UI ]
---------------------------------------------------------

MainTab:CreateToggle({
    Name = "🕹️ bypass (ปุ่มจอยสติ๊ก)",
    Callback = function(v)
        controlGui.Enabled = v
    end
})

MainTab:CreateToggle({
    Name = "🔥 โหมดกดไวขั้นสุด (x100)",
    Callback = function(v)
        getgenv().ClickAmount = v and 100 or 1
    end
})

MainTab:CreateInput({
    Name = "📏 ระยะกด (Reach Distance)",
    Callback = function(v)
        getgenv().Distance = tonumber(v) or 50
    end
})

MainTab:CreateInput({
    Name = "⚡ ความเร็วเดิน (WalkSpeed)",
    Callback = function(v)
        getgenv().Speed = tonumber(v) or 16
    end
})

MainTab:CreateToggle({
    Name = "⌨️ Auto Press E (Keyboard)",
    Callback = function(v)
        getgenv().AutoE = v
    end
})

NScanner:Notify("N-SHINNEN", "อัปเดตจอยสติ๊กแบบเนียนพิเศษสำเร็จ!", 5)
