-- [[ N-SHINNEN V.7 PRO MAX : RIOT CITY (ULTIMATE STABLE + ANTI-AFK + ZERO DELAY) ]] --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain
local plr = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = plr:GetMouse()

-- ==========================================
-- [ 🛡️ BYPASS ANTI-AFK (ยืนได้เกิน 20 นาที 100%) ]
-- ==========================================
plr.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ==========================================
-- [ 🌐 ระบบเลือกภาษา (LANGUAGE SELECTOR) ]
-- ==========================================
local SelectedLang = nil
local LangUI = Instance.new("ScreenGui", CoreGui)
LangUI.Name = "N_Lang_Selector"
LangUI.IgnoreGuiInset = true

local BG = Instance.new("Frame", LangUI)
BG.Size = UDim2.new(1, 0, 1, 0); BG.BackgroundColor3 = Color3.fromRGB(15, 15, 15); BG.BackgroundTransparency = 0.2

local MainFrame = Instance.new("Frame", BG)
MainFrame.Size = UDim2.new(0, 350, 0, 200); MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100); MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50); Title.BackgroundTransparency = 1; Title.Text = "🌐 Select Language / เลือกภาษา"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 20

local BtnTH = Instance.new("TextButton", MainFrame)
BtnTH.Size = UDim2.new(0, 140, 0, 50); BtnTH.Position = UDim2.new(0, 25, 0, 90); BtnTH.BackgroundColor3 = Color3.fromRGB(40, 40, 200); BtnTH.Text = "🇹🇭 ภาษาไทย"; BtnTH.TextColor3 = Color3.fromRGB(255, 255, 255); BtnTH.Font = Enum.Font.GothamBold; BtnTH.TextSize = 18
Instance.new("UICorner", BtnTH).CornerRadius = UDim.new(0, 8)

local BtnEN = Instance.new("TextButton", MainFrame)
BtnEN.Size = UDim2.new(0, 140, 0, 50); BtnEN.Position = UDim2.new(1, -165, 0, 90); BtnEN.BackgroundColor3 = Color3.fromRGB(200, 40, 40); BtnEN.Text = "🇬🇧 English"; BtnEN.TextColor3 = Color3.fromRGB(255, 255, 255); BtnEN.Font = Enum.Font.GothamBold; BtnEN.TextSize = 18
Instance.new("UICorner", BtnEN).CornerRadius = UDim.new(0, 8)

BtnTH.MouseButton1Click:Connect(function() SelectedLang = "TH" end)
BtnEN.MouseButton1Click:Connect(function() SelectedLang = "EN" end)

repeat task.wait(0.1) until SelectedLang ~= nil
LangUI:Destroy()

-- ==========================================
-- [ 📚 ฐานข้อมูลภาษา (สมบูรณ์ 100%) ]
-- ==========================================
local T = {
    TH = {
        Title = "🔥 N-SHINNEN V.7 PRO MAX (ULTIMATE)",
        VisTab = "👁️ มองทะลุ", VisSec = "ระบบมองทะลุ & ESP", EspEn = "เปิด ESP ผู้เล่น", TracerEn = "เปิดเส้นโยง", BountyEn = "แสดงค่าหัว (Bounty) 👑",
        FovSec = "ตั้งค่าเป้าสายตา (FOV)", FovEn = "แสดงวงกลม FOV", FovSize = "ขนาด FOV",
        AimTab = "🔫 ต่อสู้", AimSec = "ระบบเล็ง & Aimbot", AimbotEn = "🎯 Aimbot (ล็อคหัว)", MagicEn = "🎯 Magic Bullet (กระสุนเลี้ยว)", WallCheck = "🚧 เช็คกำแพง (Wall Check)", LockVeh = "🚗 ล็อคคนในรถ", AimSmooth = "ความสมูทกล้อง", Predict = "ค่าดักหน้า (Prediction)",
        GodSec = "ระดับพระเจ้า (God Tier)", GodEn = "👻 กันดาเมจ 100% (กันเซ็นเซอร์ & เลเซอร์)", AutoEBtn = "⚡ Auto E (ความเร็วแสง)",
        MoveTab = "🏃 เคลื่อนที่", MoveSec = "ระบบเคลื่อนที่ & บิน", SpeedEn = "⚡ เปิดใช้งานวิ่งไว", SpeedVal = "ความเร็ววิ่ง", NoclipEn = "👻 Noclip ทะลุทุกอย่าง", FlyEn = "🦅 เปิดใช้งานบิน", FlyVal = "ความเร็วบิน",
        TpTab = "🌀 เทเลพอร์ต", BountySec = "💀 นักล่าค่าหัวอัตโนมัติ", MinBounty = "ล่าค่าหัวขั้นต่ำ", MaxBounty = "ล่าค่าหัวสูงสุด",
        ToolDrop = "🎒 เลือกไอเทมที่จะสลับถือ", RefreshTool = "🔄 รีเฟรชไอเทม", LockTool = "🔒 ล็อคถือไอเทมค้าง", ToggleTool = "🔄 ล็อคและสลับถือไอเทม",
        AutoBounty = "🔥 ออโต้วาร์ปล่าค่าหัว", FastArrest = "⚡ โหมดจับกุมความเร็วสูง",
        TpSec = "📍 วาร์ปหาผู้เล่น", PlayerDrop = "👤 เลือกเป้าหมาย", RefreshPlr = "🔄 รีเฟรชรายชื่อ", WarpPlr = "🚀 วาร์ปไปหาผู้เล่น", HeadPlr = "🐒 วาร์ปเกาะบนหัว", BackPlr = "🐒 วาร์ปมุดใต้ดินด้านหลัง",
        MapTab = "📍 ฟาร์ม & สถานที่", FarmSec = "💰 ระบบฟาร์ม ATM ไร้ดีเลย์ (0s Delay)", FarmOnceBtn = "🚀 ฟาร์ม 1 รอบ (ครบ 13 ตู้กลับที่เดิม)", FarmLoopTgl = "🔁 ฟาร์มวนลูป (ทำงานต่อเนื่องไม่นิ่ง)",
        MapSec = "วาร์ปไปยังสถานที่",
        GfxTab = "🖥️ กราฟิก", GfxSec = "ระบบจัดการภาพหน้าจอ", RTXEn = "✨ กราฟิก Ultra RTX (สวยขั้นสุด)", FPSEn = "🚀 ลดแลคภาพกาก (FPS Boost)"
    },
    EN = {
        Title = "🔥 N-SHINNEN V.7 PRO MAX (ULTIMATE)",
        VisTab = "👁️ Visuals", VisSec = "ESP System", EspEn = "Enable Player ESP", TracerEn = "Enable Tracers", BountyEn = "Show Bounty 👑",
        FovSec = "FOV Settings", FovEn = "Show FOV Circle", FovSize = "FOV Size",
        AimTab = "🔫 Combat", AimSec = "Aimbot System", AimbotEn = "🎯 Aimbot", MagicEn = "🎯 Magic Bullet", WallCheck = "🚧 Wall Check", LockVeh = "🚗 Lock Players in Vehicle", AimSmooth = "Aim Smoothness", Predict = "Prediction Factor",
        GodSec = "God Tier", GodEn = "👻 100% Anti-Damage (Sensor/Laser)", AutoEBtn = "⚡ Auto E (Instant)",
        MoveTab = "🏃 Movement", MoveSec = "Speed & Fly", SpeedEn = "⚡ Enable Speed", SpeedVal = "Walk Speed", NoclipEn = "👻 Noclip", FlyEn = "🦅 Enable Fly", FlyVal = "Fly Speed",
        TpTab = "🌀 Teleport", BountySec = "💀 Auto Bounty Hunter", MinBounty = "Minimum Bounty", MaxBounty = "Maximum Bounty",
        ToolDrop = "🎒 Select Tool", RefreshTool = "🔄 Refresh Inventory", LockTool = "🔒 Lock Tool (Always Hold)", ToggleTool = "🔄 Toggle Tool Hold",
        AutoBounty = "🔥 Auto Bounty Teleport", FastArrest = "⚡ Fast Arrest Mode",
        TpSec = "📍 Player Teleport", PlayerDrop = "👤 Select Target", RefreshPlr = "🔄 Refresh Players", WarpPlr = "🚀 Warp to Player", HeadPlr = "🐒 Attach to Head", BackPlr = "🐒 Attach Behind",
        MapTab = "📍 Farm & Maps", FarmSec = "💰 Zero Delay ATM Farm", FarmOnceBtn = "🚀 Farm ATM Once (Instant+Return)", FarmLoopTgl = "🔁 Farm ATM Loop (Continuous)",
        MapSec = "Teleport Locations",
        GfxTab = "🖥️ Graphics", GfxSec = "Visual Settings", RTXEn = "✨ Ultra RTX Graphics", FPSEn = "🚀 Low Detail (FPS Boost)"
    }
}
local L = T[SelectedLang]

-- ==========================================
-- [ 🛠️ CORE GLOBALS & LIBRARY ]
-- ==========================================
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/d2950ed16e81d765a8657c180920cc46/raw/12746d9f8836260f1998a453849e87d21c594a5c/HISHINUI"))()
local Win = Library:CreateWindow(L.Title)

-- Variables
getgenv().ESP_Enabled = false; getgenv().Show_Tracer = false; getgenv().Show_Bounty = false
getgenv().FOV_Enabled = false; getgenv().FOV_Size = 150
getgenv().Aimbot_Enabled = false; getgenv().SilentAim_Enabled = false; getgenv().WallCheck_Enabled = false; getgenv().Lock_In_Vehicle = false; getgenv().Aimbot_Smoothness = 1; getgenv().Prediction_Factor = 0
getgenv().Speed_Enabled = false; getgenv().WalkSpeed = 50; getgenv().Noclip_Enabled = false; getgenv().GodMode_Enabled = false; getgenv().AutoE_Enabled = false; getgenv().Fly_Enabled = false; getgenv().Fly_Speed = 50
getgenv().Auto_Bounty_Hunter = false; getgenv().Fast_Arrest = false; getgenv().Min_Bounty = 1000; getgenv().Max_Bounty = 50000
getgenv().Warp_Target_Name = "Select Player"; getgenv().Attach_Head = false; getgenv().Attach_Behind_Under = false 
getgenv().Selected_Tool_To_Lock = "Select Tool"; getgenv().Lock_Tool_Enabled = false; getgenv().Toggle_Tool_Enabled = false
getgenv().AutoFarmATM_Loop = false
getgenv().AutoFarmATM_Running = false 

local CurrentAimTarget, CurrentPredictedPos, FlyBodyVelocity = nil, nil, nil
local MagicPlatform = nil
local Original_CFrame = nil 

-- [ 📌 จุด ATM 13 จุด ดั้งเดิม ]
local ATM_Locations = {
    CFrame.new(1414.58423, -16.6551094, -1546.9967, 0.965929627, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, 0.965929627),
    CFrame.new(1066.67896, -31.7288399, -1553.45471, -0.965929747, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, -0.965929747),
    CFrame.new(924.703918, -31.6292191, -1986.01855, -0.965929747, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, -0.965929747),
    CFrame.new(-141.067398, -31.7288399, -1304.32129, 0.258864343, -0, -0.965913713, 0, 1, -0, 0.965913713, 0, 0.258864343),
    CFrame.new(623.425964, -31.7288399, -1173.1449, -0.258864403, 0, 0.965913713, 0, 1, 0, -0.965913713, 0, -0.258864403),
    CFrame.new(602.406555, -31.7288399, -1251.5907, -0.258864403, 0, 0.965913713, 0, 1, 0, -0.965913713, 0, -0.258864403),
    CFrame.new(498.25415, -31.7288361, -980.237915, 0.965929627, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, 0.965929627),
    CFrame.new(346.194122, -31.7288399, -1684.86145, 0.258864343, -0, -0.965913713, 0, 1, -0, 0.965913713, 0, 0.258864343),
    CFrame.new(-1220.28918, 13.0121841, -2711.61694, 0.207885921, 0, 0.97815311, 0, 1, 0, -0.97815311, 0, 0.207885921),
    CFrame.new(770.682678, -31.2973804, -437.688293, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    CFrame.new(841.363892, -30.878376, -460.57782, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    CFrame.new(-713.074524, -9.44199467, -963.541077, 0.990270376, 0, 0.13915664, 0, 1, 0, -0.13915664, 0, 0.990270376),
    CFrame.new(268.014252, -31.754837, -925.52948, 0.258864343, -0, -0.965913713, 0, 1, -0, 0.965913713, 0, 0.25886434)
}

local MapLocations = {
    [SelectedLang == "TH" and "🏠 ปล้นบ้าน" or "🏠 House Robbery"] = CFrame.new(359.733612, 15.1995354, -2404.07397),
    [SelectedLang == "TH" and "🛒 ร้านค้า" or "🛒 Store"] = CFrame.new(841.36, -30.87, -460.57),
    [SelectedLang == "TH" and "💎 ร้านเพชร" or "💎 Jewelry"] = CFrame.new(262.31, -38.00, -1683.00),
    [SelectedLang == "TH" and "🔫 ร้านปืน" or "🔫 Gun Store"] = CFrame.new(-171.59, -30.34, -1262.56),
    [SelectedLang == "TH" and "🏦 ดาดฟ้าธนาคาร" or "🏦 Bank Top"] = CFrame.new(664.56, -7.42, -1258.93),
    [SelectedLang == "TH" and "🦹 ฐานโจร" or "🦹 Criminal Base"] = CFrame.new(370.36, 45.00, -2974.59),
    [SelectedLang == "TH" and "🛡️ เซฟโซน" or "🛡️ Safe Zone"] = CFrame.new(500, 200, -1000),
    ["N SHINNEN"] = CFrame.new(268.014252, -31.754837, -925.52948, 0.258864343, -0, -0.965913713, 0, 1, -0, 0.965913713, 0, 0.25886434)
}
local Tracers, Highlights, Billboards = {}, {}, {}

-- ==========================================
-- [ 🔵 HELPER FUNCTIONS ]
-- ==========================================
local function SafeToggle(v) return (type(v) == "boolean" and v) or (type(v) == "table" and v[1] == true) or false end
local function ShowNotification(t, d) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title=t, Text=d, Duration=4}) end) end

local function GetPlayerBounty(p)
    local b = 0; pcall(function() b = (p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Bounty") and tonumber(p.leaderstats.Bounty.Value)) or (p:FindFirstChild("Bounty") and tonumber(p.Bounty.Value)) or 0 end); return b
end

local function GetPlayerMoney()
    local m = 0; pcall(function() m = (plr:FindFirstChild("leaderstats") and plr.leaderstats:FindFirstChild("Cash") and tonumber(plr.leaderstats.Cash.Value)) or (plr:FindFirstChild("leaderstats") and plr.leaderstats:FindFirstChild("Money") and tonumber(plr.leaderstats.Money.Value)) or 0 end); return m
end

local function GetPlayersList()
    local t = {}; for _, v in pairs(Players:GetPlayers()) do if v ~= plr then table.insert(t, v.Name) end end; table.sort(t); return t
end

local function GetInventoryTools()
    local tools = {"Select Tool"}
    if plr.Character then
        local bp = plr:FindFirstChild("Backpack")
        if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then table.insert(tools, t.Name) end end end
        local equipped = plr.Character:FindFirstChildOfClass("Tool")
        if equipped then
            local found = false
            for _, name in ipairs(tools) do if name == equipped.Name then found = true; break end end
            if not found then table.insert(tools, equipped.Name) end
        end
    end
    return tools
end

local function IsVisible(targetChar)
    if not getgenv().WallCheck_Enabled then return true end 
    if not plr.Character or not targetChar then return false end
    local tp = targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
    if not tp then return false end
    local params = RaycastParams.new(); params.FilterDescendantsInstances = {plr.Character, targetChar, workspace:FindFirstChild("Vehicles")}; params.FilterType = Enum.RaycastFilterType.Exclude
    return not workspace:Raycast(Camera.CFrame.Position, tp.Position - Camera.CFrame.Position, params)
end

local function GetClosestPlayerInFOV()
    local cp, sd = nil, getgenv().FOV_Size
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            if p.Character.Humanoid.Sit and not getgenv().Lock_In_Vehicle then continue end
            local tp = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
            if tp then
                local pos, onScreen = Camera:WorldToViewportPoint(tp.Position)
                if onScreen and pos.Z > 0 then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist <= sd and IsVisible(p.Character) then sd = dist; cp = p end
                end
            end
        end
    end
    return cp
end

local function GetPlayerColor(p) return p.Team and p.TeamColor.Color or Color3.fromRGB(255, 255, 255) end
local function GetPredictedPosition(target)
    if not target or not target.Character then return nil end
    local ap = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
    if ap then return ap.Position + ((target.Character.HumanoidRootPart and target.Character.HumanoidRootPart.Velocity or ap.Velocity) * getgenv().Prediction_Factor) end
    return nil
end

local function DrawLine2D(frame, p1, p2)
    local dist, angle = (p1 - p2).Magnitude, math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X))
    frame.Size, frame.Position, frame.Rotation = UDim2.new(0, dist, 0, 2), UDim2.new(0, (p1.X + p2.X) / 2, 0, (p1.Y + p2.Y) / 2), angle
end

-- ==========================================
-- [ 🛡️ BYPASS & MAGIC BULLET ]
-- ==========================================
local mt = getrawmetatable(game); local oldNamecall = mt.__namecall; local oldNewIndex = mt.__newindex; local oldIndex = mt.__index
setreadonly(mt, false)
mt.__newindex = newcclosure(function(t, k, v)
    if not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then return end
    return oldNewIndex(t, k, v)
end)
mt.__index = newcclosure(function(t, k)
    if getgenv().SilentAim_Enabled and t == Mouse and (k == "Hit" or k == "Target") and CurrentPredictedPos and CurrentAimTarget and CurrentAimTarget.Character then
        if k == "Hit" then return CFrame.new(CurrentPredictedPos) end
        if k == "Target" then return CurrentAimTarget.Character:FindFirstChild("Head") or CurrentAimTarget.Character:FindFirstChild("HumanoidRootPart") end
    end
    return oldIndex(t, k)
end)
mt.__namecall = newcclosure(function(self, ...)
    local method, args = getnamecallmethod(), {...}
    if not checkcaller() and (method == "Kick" or method == "kick") then return end
    if getgenv().SilentAim_Enabled and not checkcaller() and CurrentPredictedPos then
        if method == "ScreenPointToRay" or method == "ViewportPointToRay" then
            local orig = oldNamecall(self, ...)
            return Ray.new(orig.Origin, (CurrentPredictedPos - orig.Origin).Unit * 1000)
        elseif method == "Raycast" and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
            args[2] = (CurrentPredictedPos - args[1]).Unit * args[2].Magnitude
            return oldNamecall(self, unpack(args))
        elseif string.find(method, "FindPartOnRay") and typeof(args[1]) == "Ray" then
            args[1] = Ray.new(args[1].Origin, (CurrentPredictedPos - args[1].Origin).Unit * args[1].Direction.Magnitude)
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- ==========================================
-- [ 🎨 กราฟิกภาพสวย (ULTRA PREMIUM RTX) ]
-- ==========================================
local function ApplyPremiumGraphics(state)
    if state then
        Lighting.GlobalShadows = true
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(120, 120, 120)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 245, 230)
        Terrain.Decoration = true
        Terrain.WaterColor = Color3.fromRGB(15, 90, 120)
        Terrain.WaterWaveSize = 0.2
        Terrain.WaterWaveSpeed = 15
        Terrain.WaterReflectance = 0.8
        
        if not Lighting:FindFirstChild("UltraCC") then
            local cc = Instance.new("ColorCorrectionEffect", Lighting); cc.Name = "UltraCC"; cc.Saturation = 0.4; cc.Contrast = 0.2
            local bloom = Instance.new("BloomEffect", Lighting); bloom.Name = "UltraBloom"; bloom.Intensity = 0.15; bloom.Size = 24
            local sun = Instance.new("SunRaysEffect", Lighting); sun.Name = "UltraSun"; sun.Intensity = 0.08; sun.Spread = 0.8
            local dof = Instance.new("DepthOfFieldEffect", Lighting); dof.Name = "UltraDOF"; dof.FocusDistance = 50; dof.InFocusRadius = 50
        else
            Lighting.UltraCC.Enabled = true; Lighting.UltraBloom.Enabled = true; Lighting.UltraSun.Enabled = true; Lighting.UltraDOF.Enabled = true
        end
    else
        if Lighting:FindFirstChild("UltraCC") then Lighting.UltraCC.Enabled = false; Lighting.UltraBloom.Enabled = false; Lighting.UltraSun.Enabled = false; Lighting.UltraDOF.Enabled = false end
    end
end

local function ApplyFPSBoost(state)
    if state then
        Lighting.GlobalShadows = false
        Terrain.Decoration = false
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                v.Material = Enum.Material.SmoothPlastic
                if v:IsA("Texture") or v:IsA("Decal") then v.Transparency = 1 end
            end
        end
    end
end

-- ==========================================
-- [ 🟢 GUI SETUP (HUD & Auto E) ]
-- ==========================================
local FOV_Gui = CoreGui:FindFirstChild("N_FOV_GUI")
if FOV_Gui then FOV_Gui:Destroy() end
FOV_Gui = Instance.new("ScreenGui", CoreGui); FOV_Gui.Name = "N_FOV_GUI"; FOV_Gui.IgnoreGuiInset = true 
local FOV_Frame = Instance.new("Frame", FOV_Gui); FOV_Frame.AnchorPoint = Vector2.new(0.5, 0.5); FOV_Frame.Position = UDim2.new(0.5, 0, 0.5, 0); FOV_Frame.BackgroundTransparency = 1
local FOV_Stroke = Instance.new("UIStroke", FOV_Frame); FOV_Stroke.Thickness = 2
local FOV_Corner = Instance.new("UICorner", FOV_Frame); FOV_Corner.CornerRadius = UDim.new(1, 0)

local LockLineFrame = Instance.new("Frame", FOV_Gui); LockLineFrame.Name = "N_LOCKLINE"; LockLineFrame.AnchorPoint = Vector2.new(0.5, 0.5); LockLineFrame.ZIndex = 10; LockLineFrame.BorderSizePixel = 0; LockLineFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0); LockLineFrame.Visible = false

local ESP_Folder = CoreGui:FindFirstChild("N_ESP_FOLDER")
if ESP_Folder then ESP_Folder:Destroy() end
ESP_Folder = Instance.new("ScreenGui", CoreGui); ESP_Folder.Name = "N_ESP_FOLDER"; ESP_Folder.IgnoreGuiInset = true
local CountFrame = Instance.new("Frame", ESP_Folder); CountFrame.AnchorPoint = Vector2.new(0.5, 0); CountFrame.Position = UDim2.new(0.5, 0, 0, 40); CountFrame.Size = UDim2.new(0, 300, 0, 50); CountFrame.BackgroundTransparency = 1
local CountText = Instance.new("TextLabel", CountFrame); CountText.Size = UDim2.new(1, 0, 1, 0); CountText.BackgroundTransparency = 1; CountText.Font = Enum.Font.GothamBlack; CountText.TextSize = 22; CountText.TextStrokeTransparency = 0.2; CountText.Visible = false

local MobileUI = CoreGui:FindFirstChild("N_MobileAutoE")
if MobileUI then MobileUI:Destroy() end
MobileUI = Instance.new("ScreenGui", CoreGui); MobileUI.Name = "N_MobileAutoE"; MobileUI.ResetOnSpawn = false
local E_Button = Instance.new("TextButton", MobileUI); E_Button.Size, E_Button.Position = UDim2.new(0, 70, 0, 70), UDim2.new(0.85, -40, 0.4, 0); E_Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40); E_Button.Text = "⚡\nAuto E\n[OFF]"; E_Button.Font = Enum.Font.GothamBold; E_Button.TextSize = 14; E_Button.TextColor3 = Color3.fromRGB(255, 100, 100); E_Button.Visible = false
local UICornerBtn = Instance.new("UICorner", E_Button); UICornerBtn.CornerRadius = UDim.new(1, 0)
local dragging, dragStart, startPos
E_Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = E_Button.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end
end)
UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        local delta = input.Position - dragStart; E_Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
E_Button.MouseButton1Click:Connect(function()
    getgenv().AutoE_Enabled = SafeToggle(not getgenv().AutoE_Enabled)
    E_Button.Text = getgenv().AutoE_Enabled and "⚡\nAuto E\n[ON]" or "⚡\nAuto E\n[OFF]"
    E_Button.TextColor3 = getgenv().AutoE_Enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

-- ==========================================
-- [ ⚡ ZERO DELAY EVENT HANDLER & UPGRADE PROMPT ]
-- ==========================================
ProximityPromptService.PromptShown:Connect(function(prompt)
    prompt.HoldDuration = 0; prompt.RequiresLineOfSight = false 
    local act = prompt.ActionText:lower()
    local obj = prompt.ObjectText:lower()

    local isRob = string.find(act, "ปล้น") or string.find(act, "rob") or string.find(act, "ขโมย") or string.find(act, "steal")
    if isRob and (getgenv().AutoFarmATM_Running or getgenv().AutoE_Enabled) then
        if fireproximityprompt then 
            fireproximityprompt(prompt, 1)
            fireproximityprompt(prompt, 0) 
        end
        return 
    end

    if getgenv().AutoE_Enabled or getgenv().Auto_Bounty_Hunter then 
        local isVeh = act:find("drive") or act:find("passenger") or act:find("enter") or act:find("sit") or obj:find("vehicle") or obj:find("car")
        if prompt.Parent and (prompt.Parent:IsA("VehicleSeat") or prompt.Parent:IsA("Seat")) then isVeh = true end
        
        if not isVeh and (act:find("cuff") or act:find("arrest") or act:find("จับ") or act:find("eject") or act:find("ดีด") or act:find("kick")) then
            if fireproximityprompt then 
                fireproximityprompt(prompt, 1)
                fireproximityprompt(prompt, 0) 
            end
        end
    end
end)

local function UpgradePrompt(prompt)
    if prompt:IsA("ProximityPrompt") then 
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false 
        -- เพิ่มระยะเห็นและระยะกดจากเดิมอีก 10 หน่วย
        prompt.MaxActivationDistance = prompt.MaxActivationDistance + 10
    end
end
for _, obj in pairs(workspace:GetDescendants()) do UpgradePrompt(obj) end
workspace.DescendantAdded:Connect(UpgradePrompt)

-- ==========================================
-- [ 🏦 ACTIVE ATM FARMING LOGIC ]
-- ==========================================
local function ExecuteATMFarm(loopMode)
    if getgenv().AutoFarmATM_Running and not loopMode then return end
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    
    getgenv().AutoFarmATM_Running = true
    local root = plr.Character.HumanoidRootPart
    
    if Original_CFrame == nil then
        Original_CFrame = root.CFrame
    end

    local startCash = GetPlayerMoney()
    
    local plat = Instance.new("Part", workspace)
    plat.Size = Vector3.new(5, 1, 5)
    plat.Anchored = true; plat.Transparency = 1; plat.CanCollide = true

    while true do
        for i, atmCFrame in ipairs(ATM_Locations) do
            if loopMode and not getgenv().AutoFarmATM_Loop then break end
            if not plr.Character or not root then break end

            local standPos = CFrame.new(atmCFrame.Position + Vector3.new(0, 4.5, 0), atmCFrame.Position + Vector3.new(0, 4.5, -1))
            plat.CFrame = standPos * CFrame.new(0, -3.5, 0)
            root.CFrame = standPos
            root.Velocity = Vector3.new(0,0,0)
            
            local preCash = GetPlayerMoney()
            local success = false
            
            for attempt = 1, 15 do
                if GetPlayerMoney() > preCash then
                    success = true
                    break
                end
                
                local partsNear = workspace:GetPartBoundsInRadius(root.Position, 15)
                for _, part in ipairs(partsNear) do
                    for _, p in ipairs(part:GetChildren()) do
                        if p:IsA("ProximityPrompt") and p.Enabled then
                            local act = p.ActionText:lower()
                            if act:find("ปล้น") or act:find("rob") or act:find("ขโมย") or act:find("steal") then
                                p.RequiresLineOfSight = false; p.HoldDuration = 0
                                if fireproximityprompt then 
                                    fireproximityprompt(p, 1)
                                    fireproximityprompt(p, 0) 
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
            
            if success then task.wait(0.2) end
        end
        
        if not loopMode or not getgenv().AutoFarmATM_Loop then break end
    end
    
    if plat then plat:Destroy() end
    
    local gained = GetPlayerMoney() - startCash
    if gained > 0 then
        ShowNotification("💰 สรุปยอดฟาร์ม ATM", "ได้รับเงินทั้งหมด: +$" .. gained)
    end

    if not loopMode or not getgenv().AutoFarmATM_Loop then
        if Original_CFrame then
            root.CFrame = Original_CFrame
            Original_CFrame = nil 
        end
        getgenv().AutoFarmATM_Running = false
    end
end

task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoFarmATM_Loop and not getgenv().AutoFarmATM_Running then
            ExecuteATMFarm(true)
        end
    end
end)

-- ==========================================
-- [ 🎨 UI MENU SETUP ]
-- ==========================================
local VisTab = Win:CreateTab(L.VisTab)
local EspSec = VisTab:CreateSection(L.VisSec)
EspSec:CreateToggle(L.EspEn, function(v) getgenv().ESP_Enabled = SafeToggle(v); CountText.Visible = getgenv().ESP_Enabled end)
EspSec:CreateToggle(L.TracerEn, function(v) getgenv().Show_Tracer = SafeToggle(v) end)
EspSec:CreateToggle(L.BountyEn, function(v) getgenv().Show_Bounty = SafeToggle(v) end)

local FovSec = VisTab:CreateSection(L.FovSec)
FovSec:CreateToggle(L.FovEn, function(v) getgenv().FOV_Enabled = SafeToggle(v) end)
FovSec:CreateSlider(L.FovSize, 50, 600, 150, function(v) getgenv().FOV_Size = tonumber(v) end)

local AimTab = Win:CreateTab(L.AimTab)
local AimSec = AimTab:CreateSection(L.AimSec)
AimSec:CreateToggle(L.AimbotEn, function(v) getgenv().Aimbot_Enabled = SafeToggle(v) end)
AimSec:CreateToggle(L.MagicEn, function(v) getgenv().SilentAim_Enabled = SafeToggle(v) end)
AimSec:CreateToggle(L.WallCheck, function(v) getgenv().WallCheck_Enabled = SafeToggle(v) end)
AimSec:CreateToggle(L.LockVeh, function(v) getgenv().Lock_In_Vehicle = SafeToggle(v) end)
AimSec:CreateSlider(L.AimSmooth, 1, 100, 100, function(v) getgenv().Aimbot_Smoothness = (tonumber(v) or 100) / 100 end)
AimSec:CreateSlider(L.Predict, 0, 50, 0, function(v) getgenv().Prediction_Factor = (tonumber(v) or 0) / 100 end)

local GodSec = AimTab:CreateSection(L.GodSec)
GodSec:CreateToggle(L.GodEn, function(v) 
    getgenv().GodMode_Enabled = SafeToggle(v) 
    if not getgenv().GodMode_Enabled and plr.Character then
        -- ตอนปิด God Mode คืนค่าการ Touch ทันที
        for _, part in pairs(plr.Character:GetDescendants()) do 
            if part:IsA("BasePart") then part.CanTouch = true end 
        end
        if plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            plr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
    end
end)
GodSec:CreateToggle(L.AutoEBtn, function(v) getgenv().AutoE_Enabled = SafeToggle(v); E_Button.Visible = getgenv().AutoE_Enabled end)

local MoveTab = Win:CreateTab(L.MoveTab)
local SpeedSec = MoveTab:CreateSection(L.MoveSec)
SpeedSec:CreateToggle(L.SpeedEn, function(v) getgenv().Speed_Enabled = SafeToggle(v) end)
SpeedSec:CreateSlider(L.SpeedVal, 16, 200, 50, function(v) getgenv().WalkSpeed = tonumber(v) end)
SpeedSec:CreateToggle(L.NoclipEn, function(v) getgenv().Noclip_Enabled = SafeToggle(v) end)
SpeedSec:CreateToggle(L.FlyEn, function(v) getgenv().Fly_Enabled = SafeToggle(v) end)
SpeedSec:CreateSlider(L.FlyVal, 10, 300, 50, function(v) getgenv().Fly_Speed = tonumber(v) end)

local TpTab = Win:CreateTab(L.TpTab)
local BountySec = TpTab:CreateSection(L.BountySec)
local ToolDrop = BountySec:CreateDropdown(L.ToolDrop, GetInventoryTools(), function(v) getgenv().Selected_Tool_To_Lock = v end)
BountySec:CreateButton(L.RefreshTool, function() ToolDrop:Refresh(GetInventoryTools()) end)
BountySec:CreateToggle(L.LockTool, function(v) getgenv().Lock_Tool_Enabled = SafeToggle(v); if v then getgenv().Toggle_Tool_Enabled = false end end)
BountySec:CreateToggle(L.ToggleTool, function(v) getgenv().Toggle_Tool_Enabled = SafeToggle(v); if v then getgenv().Lock_Tool_Enabled = false end end)
BountySec:CreateSlider(L.MinBounty, 0, 100000, 1000, function(v) getgenv().Min_Bounty = tonumber(v) end)
BountySec:CreateSlider(L.MaxBounty, 1000, 1000000, 50000, function(v) getgenv().Max_Bounty = tonumber(v) end)
BountySec:CreateToggle(L.AutoBounty, function(v) getgenv().Auto_Bounty_Hunter = SafeToggle(v) end)
BountySec:CreateToggle(L.FastArrest, function(v) getgenv().Fast_Arrest = SafeToggle(v) end)

local TpSec = TpTab:CreateSection(L.TpSec)
local WarpDrop = TpSec:CreateDropdown(L.PlayerDrop, GetPlayersList(), function(v) getgenv().Warp_Target_Name = v end)
TpSec:CreateButton(L.RefreshPlr, function() WarpDrop:Refresh(GetPlayersList()) end)
TpSec:CreateButton(L.WarpPlr, function()
    local t = Players:FindFirstChild(getgenv().Warp_Target_Name)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end
end)
TpSec:CreateToggle(L.HeadPlr, function(v) getgenv().Attach_Head = SafeToggle(v) end)
TpSec:CreateToggle(L.BackPlr, function(v) getgenv().Attach_Behind_Under = SafeToggle(v) end)

local MapTab = Win:CreateTab(L.MapTab)
local FarmSec = MapTab:CreateSection(L.FarmSec)
FarmSec:CreateButton(L.FarmOnceBtn, function() 
    if getgenv().AutoFarmATM_Loop or getgenv().AutoFarmATM_Running then ShowNotification("⚠️", "ระบบกำลังทำงานอยู่!"); return end
    task.spawn(function() ExecuteATMFarm(false) end) 
end)
FarmSec:CreateToggle(L.FarmLoopTgl, function(v) 
    getgenv().AutoFarmATM_Loop = SafeToggle(v)
    if not getgenv().AutoFarmATM_Loop and Original_CFrame and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = Original_CFrame
        Original_CFrame = nil
        getgenv().AutoFarmATM_Running = false
    end
end)

local MapSec = MapTab:CreateSection(L.MapSec)
for k, v in pairs(MapLocations) do 
    MapSec:CreateButton(k, function() if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.CFrame = v end end) 
end

local GfxTab = Win:CreateTab(L.GfxTab)
local GfxSec = GfxTab:CreateSection(L.GfxSec)
GfxSec:CreateToggle(L.RTXEn, function(v) ApplyPremiumGraphics(SafeToggle(v)) end)
GfxSec:CreateToggle(L.FPSEn, function(v) ApplyFPSBoost(SafeToggle(v)) end)

-- ==========================================
-- [ 🚀 ENGINE LOOPS & RENDERING ]
-- ==========================================
local function ManageESP(p)
    if p == plr then return end
    if not Tracers[p] then local l = Instance.new("Frame", ESP_Folder); l.AnchorPoint = Vector2.new(0.5, 0.5); l.BorderSizePixel = 0; l.ZIndex = 1; l.Visible = false; Tracers[p] = l end
    if not Highlights[p] then 
        pcall(function()
            local h = Instance.new("Highlight", CoreGui)
            h.FillTransparency = 0.7; h.OutlineTransparency = 0.2; h.Enabled = false; Highlights[p] = h 
        end)
    end
    if not Billboards[p] then
        local bg = Instance.new("BillboardGui", ESP_Folder); bg.Size, bg.StudsOffset, bg.AlwaysOnTop, bg.Enabled = UDim2.new(0, 200, 0, 75), Vector3.new(0, 3.5, 0), true, false
        local txt = Instance.new("TextLabel", bg); txt.Size, txt.BackgroundTransparency, txt.Font, txt.TextSize, txt.TextStrokeTransparency = UDim2.new(1, 0, 1, 0), 1, Enum.Font.GothamBold, 14, 0.4
        Billboards[p] = {Gui = bg, Txt = txt}
    end
end
for _, p in pairs(Players:GetPlayers()) do ManageESP(p) end; Players.PlayerAdded:Connect(ManageESP)
Players.PlayerRemoving:Connect(function(p)
    if Tracers[p] then Tracers[p]:Destroy(); Tracers[p] = nil end
    if Highlights[p] then Highlights[p]:Destroy(); Highlights[p] = nil end
    if Billboards[p] then Billboards[p].Gui:Destroy(); Billboards[p] = nil end
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        local curRGB = Color3.fromHSV((tick() % 5) / 5, 1, 1)
        if FOV_Gui then FOV_Gui.Enabled = getgenv().FOV_Enabled; FOV_Frame.Size = UDim2.new(0, getgenv().FOV_Size * 2, 0, getgenv().FOV_Size * 2); FOV_Stroke.Color = curRGB end
        if CountText.Visible then
            local pol, cri = 0, 0
            for _, p in ipairs(Players:GetPlayers()) do 
                if p.Team then 
                    local n = p.Team.Name:lower()
                    if n:find("police") or n:find("cop") then pol = pol + 1 
                    elseif n:find("crim") or n:find("prison") or n:find("fugitive") then cri = cri + 1 
                    end 
                end 
            end
            CountText.Text = SelectedLang == "TH" and string.format("👮 ตำรวจ : %d   |   🦹 อาชญากร/นักโทษ : %d", pol, cri) or string.format("👮 Police : %d   |   🦹 Criminals/Prisoners : %d", pol, cri)
            CountText.TextColor3 = curRGB
        end
        if MagicPlatform then MagicPlatform.Color = curRGB end
        
        for p, tl in pairs(Tracers) do
            local char = p.Character; local ap = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
            if getgenv().ESP_Enabled and char and ap and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(ap.Position); local pc = GetPlayerColor(p)
                if getgenv().Show_Tracer and onScreen and pos.Z > 0 then tl.Visible = true; tl.BackgroundColor3 = curRGB; DrawLine2D(tl, Vector2.new(Camera.ViewportSize.X/2, 65), Vector2.new(pos.X, pos.Y)) else tl.Visible = false end
                if Highlights[p] then Highlights[p].Enabled, Highlights[p].Adornee, Highlights[p].FillColor = true, char, pc end
                local b = Billboards[p]; b.Gui.Enabled, b.Gui.Adornee = true, ap
                local bTxt = (getgenv().Show_Bounty and GetPlayerBounty(p) > 0) and "\n💰 [$"..GetPlayerBounty(p).."]" or ""
                b.Txt.Text, b.Txt.TextColor3 = p.Name.."\n["..math.floor((Camera.CFrame.Position - ap.Position).Magnitude).."m]"..bTxt, pc
            else 
                tl.Visible = false; 
                if Highlights[p] then Highlights[p].Enabled = false end; 
                Billboards[p].Gui.Enabled = false
            end
        end
        
        CurrentAimTarget = GetClosestPlayerInFOV(); CurrentPredictedPos = GetPredictedPosition(CurrentAimTarget)
        if CurrentAimTarget and (getgenv().Aimbot_Enabled or getgenv().SilentAim_Enabled) and CurrentPredictedPos then
            local pos, onScreen = Camera:WorldToViewportPoint(CurrentPredictedPos)
            if onScreen and pos.Z > 0 then LockLineFrame.Visible = true; DrawLine2D(LockLineFrame, Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2), Vector2.new(pos.X, pos.Y)) else LockLineFrame.Visible = false end
            if getgenv().Aimbot_Enabled then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, CurrentPredictedPos), getgenv().Aimbot_Smoothness) end
        else LockLineFrame.Visible = false end
    end)
end)

-- Tool Logic
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Lock_Tool_Enabled and getgenv().Selected_Tool_To_Lock ~= "Select Tool" then
            pcall(function()
                local char = plr.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local currentTool = char:FindFirstChildOfClass("Tool")
                    if not currentTool or currentTool.Name ~= getgenv().Selected_Tool_To_Lock then
                        local bp = plr:FindFirstChild("Backpack")
                        if bp then local targetTool = bp:FindFirstChild(getgenv().Selected_Tool_To_Lock); if targetTool then char.Humanoid:EquipTool(targetTool) end end
                    end
                end
            end)
        end
    end
end)
task.spawn(function()
    while task.wait(2) do
        if getgenv().Toggle_Tool_Enabled and getgenv().Selected_Tool_To_Lock ~= "Select Tool" then
            pcall(function()
                local char = plr.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local currentTool = char:FindFirstChildOfClass("Tool")
                    if currentTool and currentTool.Name == getgenv().Selected_Tool_To_Lock then char.Humanoid:UnequipTools()
                    else
                        local bp = plr:FindFirstChild("Backpack")
                        if bp then local targetTool = bp:FindFirstChild(getgenv().Selected_Tool_To_Lock); if targetTool then char.Humanoid:EquipTool(targetTool) end end
                    end
                end
            end)
        end
    end
end)
plr.CharacterAdded:Connect(function() 
    task.wait(1.5) 
    if getgenv().Lock_Tool_Enabled or getgenv().Toggle_Tool_Enabled then 
        pcall(function()
            local bp = plr:FindFirstChild("Backpack")
            if bp then local targetTool = bp:FindFirstChild(getgenv().Selected_Tool_To_Lock); if targetTool and plr.Character and plr.Character:FindFirstChild("Humanoid") then plr.Character.Humanoid:EquipTool(targetTool) end end
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = plr.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        
        if getgenv().Fly_Enabled or getgenv().Auto_Bounty_Hunter or getgenv().Attach_Head or getgenv().Attach_Behind_Under then
            if not MagicPlatform or not MagicPlatform.Parent then
                MagicPlatform = Instance.new("Part", workspace); MagicPlatform.Size = Vector3.new(15, 1, 15); MagicPlatform.Anchored = true; MagicPlatform.CanCollide = true; MagicPlatform.Material = Enum.Material.Neon; MagicPlatform.Transparency = 0.5
            end
            MagicPlatform.CFrame = root.CFrame * CFrame.new(0, -3.5, 0)
        else
            if MagicPlatform then MagicPlatform:Destroy(); MagicPlatform = nil end
        end
        
        if getgenv().Fly_Enabled then
            if not FlyBodyVelocity then 
                FlyBodyVelocity = Instance.new("BodyVelocity", root); FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge) 
            end
            char.Humanoid.PlatformStand = true 
            local md = char.Humanoid.MoveDirection
            if md.Magnitude > 0 then FlyBodyVelocity.Velocity = Vector3.new(md.X, Camera.CFrame.LookVector.Y * math.abs(md.Magnitude), md.Z).Unit * getgenv().Fly_Speed else FlyBodyVelocity.Velocity = Vector3.new(0,0,0) end
        else
            if FlyBodyVelocity then 
                if FlyBodyVelocity.Parent then FlyBodyVelocity:Destroy() end
                FlyBodyVelocity = nil
            end
            if char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = false
            end
        end
        
        if getgenv().Auto_Bounty_Hunter then
            local bestTarget = nil; local maxBounty = 0
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    local bounty = GetPlayerBounty(p)
                    if bounty >= getgenv().Min_Bounty and bounty <= getgenv().Max_Bounty and bounty > maxBounty then maxBounty = bounty; bestTarget = p end
                end
            end
            
            if bestTarget and bestTarget.Character and bestTarget.Character:FindFirstChild("HumanoidRootPart") then
                local tRoot = bestTarget.Character.HumanoidRootPart
                root.CFrame = (tRoot.CFrame + (tRoot.Velocity * 0.05)) * CFrame.new(0, 1.5, 1.8); root.Velocity = Vector3.new(0,0,0)
                
                local partsNear = workspace:GetPartBoundsInRadius(root.Position, 15)
                for _, part in ipairs(partsNear) do
                    for _, p in ipairs(part:GetChildren()) do
                        if p:IsA("ProximityPrompt") and p.Enabled then
                            local act = p.ActionText:lower()
                            if act:find("cuff") or act:find("arrest") or act:find("จับ") or act:find("eject") or act:find("ดีด") or act:find("kick") then
                                p.RequiresLineOfSight = false; p.HoldDuration = 0
                                if fireproximityprompt then 
                                    fireproximityprompt(p, 1)
                                    fireproximityprompt(p, 0) 
                                end
                            end
                        end
                    end
                end
            else
                root.CFrame = CFrame.new(500, 200, -1000); root.Velocity = Vector3.new(0,0,0)
            end
        else
            if getgenv().Attach_Head or getgenv().Attach_Behind_Under then
                local t = Players:FindFirstChild(getgenv().Warp_Target_Name)
                if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
                    local tRoot = t.Character.HumanoidRootPart
                    root.CFrame = getgenv().Attach_Head and (tRoot.CFrame * CFrame.new(0, 2.5, 0)) or (tRoot.CFrame * CFrame.new(0, -8, 5))
                    root.Velocity = Vector3.new(0,0,0)
                end
            end
        end
    end)
end)

UserInputService.JumpRequest:Connect(function()
    if getgenv().GodMode_Enabled and plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    pcall(function()
        local char = plr.Character; if not char then return end

        -- [ 🛡️ GOD MODE: กันดาเมจเซ็นเซอร์/เลเซอร์ 100% ]
        if getgenv().GodMode_Enabled then
            for _, v in pairs(char:GetDescendants()) do 
                if v:IsA("BasePart") then v.CanTouch = false end 
            end
            if char:FindFirstChild("Humanoid") then
                char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end

        if char:FindFirstChild("Humanoid") and not getgenv().Fly_Enabled then 
            if getgenv().Speed_Enabled then char.Humanoid.WalkSpeed = getgenv().WalkSpeed else char.Humanoid.WalkSpeed = 16 end
        end
        
        if getgenv().Noclip_Enabled or getgenv().Auto_Bounty_Hunter or getgenv().Attach_Head or getgenv().Attach_Behind_Under then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)
end)
