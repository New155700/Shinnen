-- [[ N-SHINNEN : INSTANT BYPASS & TURBO CLICK V5 ]] --

local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/49f2dcb1a4bf968cba35f5521c684bb6/raw/ae4518df255ca958f4a07b5e066ed9df1ad26cea/HiSHINUI"))()
local Win = Library:CreateWindow("🔥 N-SHINNEN TURBO")

local plr = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

getgenv().Speed = 16
getgenv().Distance = 50
getgenv().AutoE = false
getgenv().TurboMode = false -- ฟังชั่นกด 1 ได้ 40
getgenv().ClickAmount = 1

---------------------------------------------------------
-- [ ระบบหน้าต่างลอย Floating Button ]
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

local btnStroke = Instance.new("UIStroke", toggleBtn)
btnStroke.Thickness = 3
btnStroke.Color = Color3.fromRGB(255, 50, 50)

-- ลากปุ่มลอย
local dragging, dragInput, dragStart, startPos
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = toggleBtn.Position
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local function SyncAutoE(state)
    getgenv().AutoE = state
    toggleBtn.Text = state and "TURBO: ON" or "TURBO: OFF"
    toggleBtn.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
    btnStroke.Color = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
end

toggleBtn.MouseButton1Click:Connect(function()
    SyncAutoE(not getgenv().AutoE)
end)

---------------------------------------------------------
-- [ Master Bypass & Turbo Logic ]
---------------------------------------------------------

-- 1. Bypass ProximityPrompt (ทำให้ปุ่มกดได้ทันที/ไม่ต้องรอหมุน/ระยะไกล)
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                    v.ClickablePrompt = true
                    v.RequiresLineOfSight = false
                    v.MaxActivationDistance = getgenv().Distance
                    -- Bypass อนิเมชั่นการรอ
                    if getgenv().AutoE then
                        v:InputHoldBegin()
                        v:InputHoldEnd()
                    end
                end
            end
        end)
    end
end)

-- 2. Turbo Click Loop (ส่งคำสั่งรัวๆ)
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if getgenv().AutoE then
            pcall(function()
                -- ถ้าเปิดโหมด Turbo จะกดเบิ้ล 40 ครั้งต่อ 1 รอบการทำงาน
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

local MainTab = Win:CreateTab("Turbo Settings")
local FarmSec = MainTab:CreateSection("⚡ Instant Click System")

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

-- Loop WalkSpeed
task.spawn(function()
    while task.wait() do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = getgenv().Speed
            end
        end)
    end
end)

Library:Notify("N-SHINNEN", "Turbo System Loaded! กดปุ่มลอยเพื่อเริ่มความไว", 5)
