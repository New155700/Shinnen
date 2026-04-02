-- [[ N-SHINNEN : LOADER & UI BRIDGE ]] --

-- 1. ดึง Library
local URL = "https://gist.githubusercontent.com/New155700/3b4ee43d4cccb63f00fe75702086590a/raw/99d545c6d6784de87103009ddfd81f55f1f4bac2/Shinen"
local success, NScanner = pcall(function()
    return loadstring(game:HttpGet(URL))()
end)

if not success then return end

-- 2. สร้างหน้าต่าง และหน้าเมนู (ใช้ MainTab)
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
-- [ ส่วนของ UI : ใช้ Add เท่านั้น ปุ่มถึงจะขึ้น ]
---------------------------------------------------------

MainTab:AddToggle("🕹️ เปิดระบบควบคุม (Joystick)", false, function(v)
    -- โค้ดเปิดปิด GUI ของคุณ
end)

-- อันนี้คือ Slider ที่คุณต้องการ ปรับระยะได้จริง
MainTab:AddSlider("📏 ระยะกด (Reach)", 10, 500, 50, function(v)
    getgenv().Distance = tonumber(v)
end)

MainTab:AddInput("⚡ ความเร็วการเดิน (Speed)", function(v)
    getgenv().Speed = tonumber(v) or 16
end)

MainTab:AddToggle("⌨️ Auto Press E", false, function(v)
    getgenv().AutoE = v
end)

---------------------------------------------------------
-- [ วงจรทำงานหลัก ]
---------------------------------------------------------

-- วิ่งไว
task.spawn(function()
    while task.wait() do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                plr.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = getgenv().Speed
            end
        end)
    end
end)

-- ระยะกด (Reach)
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

-- กด E รัว
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

NScanner:Notify("N-SHINNEN", "ฟังก์ชันกลับมาครบแล้ว!", 5)
