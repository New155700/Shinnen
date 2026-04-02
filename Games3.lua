-- [[ N-SHINNEN : CUSTOM TURBO & INSTANT BYPASS V15 ]] --

local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/49f2dcb1a4bf968cba35f5521c684bb6/raw/ae4518df255ca958f4a07b5e066ed9df1ad26cea/HiSHINUI"))()
local Win = Library:CreateWindow("🔥 N-SHINNEN V15 TURBO")

local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Variables
getgenv().Speed = 16
getgenv().Distance = 100
getgenv().AutoE = false
getgenv().HardcoreMode = false 
getgenv().TurboMultiplier = 1 -- เริ่มต้นที่ 1 ครั้ง

---------------------------------------------------------
-- [ ระบบจัดการ Proximity Prompt (กดมือติดทันที + ออโต้รัว) ]
---------------------------------------------------------
local function TriggerPrompt(v, count)
    if v:IsA("ProximityPrompt") then
        -- ทำให้กดด้วยมือติดทันที
        v.HoldDuration = 0 
        v.MaxActivationDistance = getgenv().Distance
        
        -- ระบบออโต้ส่งค่ารัว
        if getgenv().AutoE then
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local root = plr.Character.HumanoidRootPart
                local promptPos = (v.Parent:IsA("BasePart") and v.Parent.Position) or root.Position
                if (root.Position - promptPos).Magnitude <= v.MaxActivationDistance then
                    for i = 1, count do
                        v:InputHoldBegin()
                        v:InputHoldEnd()
                    end
                end
            end
        end
    end
end

-- ตรวจสอบ Object ตลอดเวลา
task.spawn(function()
    while task.wait(0.1) do
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0 -- บังคับให้ไม่มีการโหลดตลอดเวลา
            end
        end
    end
end)

-- Loop การฟาร์ม
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoE then
            local count = getgenv().HardcoreMode and getgenv().TurboMultiplier or 1
            for _, v in pairs(workspace:GetDescendants()) do
                TriggerPrompt(v, count)
            end
        end
    end
end)

---------------------------------------------------------
-- [ Floating UI (ปุ่มลอยควบคุมหน้าจอ) ]
---------------------------------------------------------
local floatGui = Instance.new("ScreenGui", game.CoreGui)
floatGui.Name = "N_Shinnen_V15_Float"

local function CreateFloatButton(name, pos, color, text)
    local btn = Instance.new("TextButton", floatGui)
    btn.Size = UDim2.new(0, 65, 0, 65)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255,255,255)

    -- Drag System
    local dragging, dragStart, startPos
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = btn.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    btn.InputEnded:Connect(function(input) dragging = false end)
    return btn
end

local autoBtn = CreateFloatButton("AutoBtn", UDim2.new(0.85, 0, 0.4, 0), Color3.fromRGB(0, 150, 255), "AUTO: OFF")
local hardBtn = CreateFloatButton("HardBtn", UDim2.new(0.85, 0, 0.52, 0), Color3.fromRGB(255, 50, 50), "TURBO: OFF")

local function UpdateVisuals()
    autoBtn.Text = getgenv().AutoE and "AUTO: ON" or "AUTO: OFF"
    autoBtn.BackgroundColor3 = getgenv().AutoE and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(0, 150, 255)
    hardBtn.Text = getgenv().HardcoreMode and "TURBO: ON" or "TURBO: OFF"
    hardBtn.BackgroundColor3 = getgenv().HardcoreMode and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(255, 50, 50)
end

autoBtn.MouseButton1Click:Connect(function() getgenv().AutoE = not getgenv().AutoE; UpdateVisuals() end)
hardBtn.MouseButton1Click:Connect(function() getgenv().HardcoreMode = not getgenv().HardcoreMode; UpdateVisuals() end)

---------------------------------------------------------
-- [ เมนู UI ]
---------------------------------------------------------
local MainTab = Win:CreateTab("Settings")
local FarmSec = MainTab:CreateSection("⚡ Turbo Bypass System")

FarmSec:CreateToggle("Auto Bypass (ปกติ)", function(v)
    getgenv().AutoE = v
    UpdateVisuals()
end)

FarmSec:CreateToggle("🔥 Hardcore Turbo Mode", function(v)
    getgenv().HardcoreMode = v
    UpdateVisuals()
end)

FarmSec:CreateSlider("ส่งค่ารัว (1 - 1000 ครั้ง)", 1, 1000, 1, function(v)
    getgenv().TurboMultiplier = v
end)

local MoveSec = MainTab:CreateSection("🏃 Movement")
MoveSec:CreateSlider("WalkSpeed", 16, 500, 16, function(v) getgenv().Speed = v end)
MoveSec:CreateSlider("Distance (Reach)", 10, 1000, 100, function(v) getgenv().Distance = v end)

RunService.RenderStepped:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = getgenv().Speed
    end
end)

Library:Notify("N-SHINNEN V15", "ระบบ Turbo เลือกค่าได้ 1-1000 พร้อมระบบกดมือทันที!", 5)
