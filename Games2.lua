-- [[ N-SHINNEN V100 : PRO MAX (UI FIXED) ]] --
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/ca3ee71cb4c922c5055bca31b4fa9578/raw/145adea59e4bfc4c4273b7e8b6b925d8969cae49/HIUISHINNEN"))()
local Win = Library:CreateWindow("🔥 N-SHINNEN ")

local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- [ 🟢 FOV GUI Setup ]
local function SetupFOV()
    local old = CoreGui:FindFirstChild("N_FOV_GUI")
    if old then old:Destroy() end

    local FOV_Gui = Instance.new("ScreenGui")
    FOV_Gui.Name = "N_FOV_GUI"
    FOV_Gui.Parent = CoreGui
    FOV_Gui.IgnoreGuiInset = true
    FOV_Gui.Enabled = false

    local FOV_Frame = Instance.new("Frame", FOV_Gui)
    FOV_Frame.Name = "MainCircle"
    FOV_Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    FOV_Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    FOV_Frame.BackgroundTransparency = 1
    
    local FOV_Stroke = Instance.new("UIStroke", FOV_Frame)
    FOV_Stroke.Color = Color3.fromRGB(0, 255, 255)
    FOV_Stroke.Thickness = 2

    local FOV_Corner = Instance.new("UICorner", FOV_Frame)
    FOV_Corner.CornerRadius = UDim.new(1, 0)
    
    return FOV_Gui, FOV_Frame
end

local MainFOV, MainCircle = SetupFOV()
local ESP_Folder = CoreGui:FindFirstChild("N_ESP_FOLDER") or Instance.new("Folder", CoreGui)
ESP_Folder.Name = "N_ESP_FOLDER"

-- [ 🟡 Global Variables ]
getgenv().ESP_Enabled = false
getgenv().Show_Tracer = false
getgenv().WalkSpeed = 16
getgenv().Phase_Enabled = false
getgenv().Prediction_Factor = 0.165
getgenv().Aimbot_Smoothness = 0.15

getgenv().Orbit_Target = nil 
getgenv().AutoLock_Murderer = true 
getgenv().AutoRefresh_List = true 
getgenv().Aimbot_Enabled = false 
getgenv().SilentAim_Enabled = false
getgenv().Show_FOV = false
getgenv().FOV_Size = 150
getgenv().Auto_BringGun = false

-- [ 🔵 Helper Functions ]
local function IsAlive(p)
    return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0
end

local function GetRole(p)
    if not IsAlive(p) then return "ผู้บริสุทธิ์", Color3.fromRGB(240, 240, 245) end 
    local isM, isS = false, false
    pcall(function()
        local function check(container)
            if not container then return end
            for _, i in pairs(container:GetChildren()) do
                if i:IsA("Tool") then
                    local n = i.Name:lower()
                    if n:find("knife") or n:find("murder") then isM = true end
                    if n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") then isS = true end
                end
            end
        end
        check(p.Character); check(p.Backpack)
        if p.Character:FindFirstChild("LowerTorso") and p.Character.LowerTorso:FindFirstChild("GunBelt") then isS = true end
    end)
    if isM then return "ฆาตกร", Color3.fromRGB(255, 20, 20) end 
    if isS then return "นายอำเภอ", Color3.fromRGB(20, 200, 255) end 
    return "ผู้บริสุทธิ์", Color3.fromRGB(240, 240, 245) 
end

local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = getgenv().FOV_Size
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and IsAlive(p) then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = p
                end
            end
        end
    end
    return closestPlayer
end

-- [ 🚀 UI TABS SETUP ]
local MainTab = Win:CreateTab("Main Settings")
local EspSec = MainTab:CreateSection("👁️ ESP & Visuals")

EspSec:CreateToggle("เปิด ESP ชื่อ+บทบาท", function(v) getgenv().ESP_Enabled = v end)
EspSec:CreateToggle("แสดงวงกลม FOV", function(v) getgenv().Show_FOV = v end)
EspSec:CreateSlider("ขนาด FOV", 50, 500, 150, function(v) getgenv().FOV_Size = v end)

local CombatSec = MainTab:CreateSection("🎯 Combat & Aim")
CombatSec:CreateToggle("🎯 Aimbot (ล็อคกล้องสมูท)", function(v) getgenv().Aimbot_Enabled = v end)
CombatSec:CreateToggle("🎯 Silent Aim (เข้าหัว 100%)", function(v) getgenv().SilentAim_Enabled = v end)
CombatSec:CreateToggle("🔫 วาร์ปเก็บปืน (Stealth)", function(v) getgenv().Auto_BringGun = v end)

local MoveSec = MainTab:CreateSection("🏃 Movement")
MoveSec:CreateSlider("ความเร็วเดิน", 16, 150, 16, function(v) getgenv().WalkSpeed = v end)
MoveSec:CreateToggle("เดินทะลุคน (Phase)", function(v) getgenv().Phase_Enabled = v end)

-- [ ⚙️ ENGINE SYSTEMS ]

-- 🔴 Render Loop (UI & Aimbot)
RunService.RenderStepped:Connect(function()
    MainFOV.Enabled = getgenv().Show_FOV
    MainCircle.Size = UDim2.new(0, getgenv().FOV_Size * 2, 0, getgenv().FOV_Size * 2)

    if getgenv().Aimbot_Enabled then
        local target = GetClosestPlayerInFOV()
        if IsAlive(target) then
            local targetPos = target.Character.Head.Position
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, getgenv().Aimbot_Smoothness)
        end
    end

    if getgenv().ESP_Enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr and IsAlive(p) then
                local rName, rCol = GetRole(p)
                local hl = p.Character:FindFirstChild("N_HL") or Instance.new("Highlight", p.Character)
                hl.Name = "N_HL"; hl.FillColor = rCol; hl.FillTransparency = 0.8; hl.Enabled = true
            end
        end
    end
end)

-- 🔴 Silent Aim Hook
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index
mt.__index = newcclosure(function(t, k)
    if getgenv().SilentAim_Enabled and t == Mouse and (k == "Hit" or k == "Target") then
        local target = GetClosestPlayerInFOV()
        if IsAlive(target) then
            return (k == "Hit" and target.Character.Head.CFrame or target.Character.Head)
        end
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

-- 🔴 Physics Loop (Speed & Pickup)
local bringing = false
RunService.Stepped:Connect(function()
    if IsAlive(plr) then
        plr.Character.Humanoid.WalkSpeed = getgenv().WalkSpeed
        if getgenv().Phase_Enabled then
            for _, v in pairs(plr.Character:GetChildren()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.CanCollide = false end
            end
        end
    end

    if getgenv().Auto_BringGun and not bringing then
        local gun = workspace:FindFirstChild("GunDrop") or (workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("GunDrop"))
        if gun and IsAlive(plr) then
            bringing = true
            local oldPos = plr.Character.HumanoidRootPart.CFrame
            plr.Character.HumanoidRootPart.CFrame = gun.CFrame
            task.delay(0.1, function()
                plr.Character.HumanoidRootPart.CFrame = oldPos
                task.wait(1)
                bringing = false
            end)
        end
    end
end)

print("✅ UI Fixed and Ready!")
