-- 1. ล้าง UI เก่าทั้งหมด
pcall(function()
    if game.CoreGui:FindFirstChild("Rayfield") then game.CoreGui.Rayfield:Destroy() end
    if game.CoreGui:FindFirstChild("CustomControlGui") then game.CoreGui.CustomControlGui:Destroy() end
    if game.CoreGui:FindFirstChild("FloatingAutoE") then game.CoreGui.FloatingAutoE:Destroy() end
end)

-- 2. โหลด Rayfield
local Rayfield = nil
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/c0688399d1caea380905ffb1f5e02459/raw/30ef6c815c9191bbf17b6dcbd3358276b34bd63a/gistfile1.txt"))()
end)

if not success or not Rayfield then
    warn("ไม่สามารถโหลด Rayfield ได้: ", err)
    return
end

local Win = Rayfield:CreateWindow({
    Name = "Pro Gamer Hub V4",
    LoadingTitle = "กำลังโหลดข้อมูล...",
    LoadingSubtitle = "No Bug Version",
    ConfigurationSaving = {Enabled = false}
})

-- 3. ตัวแปรพื้นฐาน
local plr = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local defaultWalkSpeed = 16
pcall(function()
    if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
        defaultWalkSpeed = plr.Character:FindFirstChildOfClass("Humanoid").WalkSpeed
    end
end)

getgenv().Speed = defaultWalkSpeed
getgenv().Distance = 50
getgenv().AutoE = false

---------------------------------------------------------
-- ระบบ หน้าต่างลอย (Floating Button) สำหรับเปิด/ปิด Auto E
---------------------------------------------------------
local floatGui = Instance.new("ScreenGui")
floatGui.Name = "FloatingAutoE"
floatGui.ResetOnSpawn = false
floatGui.Parent = game.CoreGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0.5, -60, 0, 20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- สีแดง (ปิด)
toggleBtn.Text = "Auto E : OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
local uiCornerFloat = Instance.new("UICorner")
uiCornerFloat.CornerRadius = UDim.new(0, 8)
uiCornerFloat.Parent = toggleBtn
toggleBtn.Parent = floatGui

-- ระบบลากปุ่มลอย (Drag)
local dragToggle, dragInput2, dragStart2, startPos2
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart2 = input.Position
        startPos2 = toggleBtn.Position
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

-- ระบบกดเปิด/ปิด
toggleBtn.MouseButton1Click:Connect(function()
    getgenv().AutoE = not getgenv().AutoE
    if getgenv().AutoE then
        toggleBtn.Text = "Auto E : ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- สีเขียว
    else
        toggleBtn.Text = "Auto E : OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- สีแดง
    end
end)

---------------------------------------------------------
-- ระบบ Control GUI (จอยสติ๊ก & ปุ่มกระโดด)
---------------------------------------------------------
local controlGui = Instance.new("ScreenGui")
controlGui.Name = "CustomControlGui"
controlGui.Enabled = false
controlGui.ResetOnSpawn = false
controlGui.Parent = game.CoreGui

-- Joystick
local joyBase = Instance.new("Frame")
joyBase.Size = UDim2.new(0, 150, 0, 150)
joyBase.Position = UDim2.new(0, 50, 1, -220)
joyBase.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
joyBase.BackgroundTransparency = 0.6
joyBase.Active = true
local uiCornerBase = Instance.new("UICorner")
uiCornerBase.CornerRadius = UDim.new(1, 0)
uiCornerBase.Parent = joyBase
joyBase.Parent = controlGui

local joyStick = Instance.new("Frame")
joyStick.Size = UDim2.new(0, 65, 0, 65)
joyStick.Position = UDim2.new(0.5, 0, 0.5, 0)
joyStick.AnchorPoint = Vector2.new(0.5, 0.5)
joyStick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
joyStick.BackgroundTransparency = 0.4
local uiCornerStick = Instance.new("UICorner")
uiCornerStick.CornerRadius = UDim.new(1, 0)
uiCornerStick.Parent = joyStick
joyStick.Parent = joyBase

-- Jump Button
local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0, 90, 0, 90)
jumpBtn.Position = UDim2.new(1, -150, 1, -180)
jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
jumpBtn.BackgroundTransparency = 0.6
jumpBtn.Text = "JUMP"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.Font = Enum.Font.GothamBold
jumpBtn.TextSize = 20
local uiCornerJump = Instance.new("UICorner")
uiCornerJump.CornerRadius = UDim.new(1, 0)
uiCornerJump.Parent = jumpBtn
jumpBtn.Parent = controlGui

jumpBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Joystick Logic
local isDragging = false
local moveDirX, moveDirY = 0, 0
local dragInput = nil

joyBase.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        isDragging = true
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and isDragging then
        local baseCenter = joyBase.AbsolutePosition + (joyBase.AbsoluteSize / 2)
        local inputPos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = inputPos - baseCenter
        local maxRadius = joyBase.AbsoluteSize.X / 2
        if delta.Magnitude > maxRadius then delta = delta.Unit * maxRadius end
        joyStick.Position = UDim2.new(0.5, delta.X, 0.5, delta.Y)
        moveDirX = delta.X / maxRadius
        moveDirY = delta.Y / maxRadius
    end
end)

UIS.InputEnded:Connect(function(input)
    if input == dragInput then
        isDragging = false
        dragInput = nil
        joyStick:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Back", 0.2)
        moveDirX, moveDirY = 0, 0
    end
end)

RunService.RenderStepped:Connect(function()
    if isDragging then
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local cam = workspace.CurrentCamera
            local forward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
            local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit
            hum:Move((right * moveDirX) + (forward * -moveDirY), false)
        end
    end
end)

---------------------------------------------------------
-- ฟังก์ชันกดไวแบบดั้งเดิม (เอามาจากสคริปต์แรก 100%)
---------------------------------------------------------

-- วิ่งไว
task.spawn(function()
    while task.wait() do
        pcall(function()
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = getgenv().Speed end
        end)
    end
end)

-- Prompt instant & เพิ่มระยะ (ลูปทุก 0.1 วิเหมือนต้นฉบับ)
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                    v.MaxActivationDistance = getgenv().Distance -- ระยะกด
                    v.RequiresLineOfSight = false -- กดทะลุกำแพง
                end
            end
        end)
    end
end)

-- กด E รัว (เอาดีเลย์ 0.1 ออก ให้รัวที่สุดด้วย VIM แบบต้นฉบับ)
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
-- สร้างหน้าเมนู (Tabs)
---------------------------------------------------------
local MainTab = Win:CreateTab("หน้าหลัก", 4483362458)

MainTab:CreateToggle({
    Name = "🕹️ เปิดระบบควบคุม (จอยสติ๊ก/กระโดด)",
    CurrentValue = false,
    Callback = function(v)
        controlGui.Enabled = v
    end
})

MainTab:CreateSlider({
    Name = "📏 ระยะกด (Reach)",
    Range = {10, 100},
    Increment = 5,
    Suffix = "Studs",
    CurrentValue = 50,
    Callback = function(v)
        getgenv().Distance = v
    end
})

MainTab:CreateInput({
    Name = "⚡ ความเร็วการเดิน (Speed)",
    PlaceholderText = tostring(defaultWalkSpeed),
    Callback = function(v)
        local n = tonumber(v)
        if n then getgenv().Speed = n end
    end
})

Rayfield:Notify({
    Title = "อัปเดตเสร็จสมบูรณ์!",
    Content = "รวมระบบกดไวแบบดั้งเดิมเข้ากับ UI ใหม่ (ไม่บัคแน่นอน)",
    Duration = 5,
    Image = 4483362458,
})
