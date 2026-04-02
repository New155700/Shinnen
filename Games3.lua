-- [[ N-SHINNEN : ULTIMATE TURBO BYPASS V12 (CLEAN UI) ]] --

local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/49f2dcb1a4bf968cba35f5521c684bb6/raw/ae4518df255ca958f4a07b5e066ed9df1ad26cea/HiSHINUI"))()
local Win = Library:CreateWindow("🔥 N-SHINNEN V12 TURBO")

local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Variables
getgenv().Speed = 16
getgenv().Distance = 100
getgenv().AutoE = false
getgenv().HardcoreMode = false 
getgenv().TurboMultiplier = 100 -- ค่าเริ่มต้น 100 ครั้ง

---------------------------------------------------------
-- [ ระบบจัดการ Proximity Prompt (Bypass & Turbo) ]
---------------------------------------------------------
local function TriggerPrompt(v, count)
    if v:IsA("ProximityPrompt") then
        v.HoldDuration = 0 
        v.MaxActivationDistance = getgenv().Distance
        
        -- ตรวจสอบระยะตัวละคร
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            local promptPos = (v.Parent:IsA("BasePart") and v.Parent.Position) or root.Position
            if (root.Position - promptPos).Magnitude <= v.MaxActivationDistance then
                -- วนลูปส่งค่าตามจำนวนที่ตั้งไว้
                for i = 1, count do
                    v:InputHoldBegin()
                    v:InputHoldEnd()
                end
            end
        end
    end
end

-- ระบบ Loop ตรวจสอบ
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoE then
            local count = getgenv().HardcoreMode and getgenv().TurboMultiplier or 1
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    TriggerPrompt(v, count)
                end
            end
        end
    end
end)

-- ระบบ WalkSpeed
RunService.RenderStepped:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = getgenv().Speed
    end
end)

---------------------------------------------------------
-- [ เมนู UI ]
---------------------------------------------------------
local MainTab = Win:CreateTab("Settings")
local FarmSec = MainTab:CreateSection("⚡ Turbo Bypass System")

FarmSec:CreateToggle("เปิดระบบ Auto Bypass (ปกติ)", function(v)
    getgenv().AutoE = v
end)

FarmSec:CreateToggle("🔥 Hardcore Mode (ส่งค่ารัว)", function(v)
    getgenv().HardcoreMode = v
    if v then
        Library:Notify("HARDCORE ON", "ส่งค่าการกดคูณ "..getgenv().TurboMultiplier.." ครั้ง!", 3)
    end
end)

FarmSec:CreateSlider("ปรับค่า Turbo (100 - 1,000)", 100, 1000, 100, function(v)
    getgenv().TurboMultiplier = v
end)

local MoveSec = MainTab:CreateSection("🏃 Movement")

MoveSec:CreateSlider("ความเร็วเดิน", 16, 500, 16, function(v)
    getgenv().Speed = v
end)

MoveSec:CreateSlider("ระยะการกด (Reach)", 10, 1000, 100, function(v)
    getgenv().Distance = v
end)

Library:Notify("N-SHINNEN V12", "ลบปุ่มควบคุมออกแล้ว และอัปเกรดระบบ Turbo!", 5)
