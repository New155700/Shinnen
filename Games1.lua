-- [[ N-SHINNEN V.7 PRO MAX : RIOT CITY (SAFE ROAMING + MAGIC PLATFORM) ]] --
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/d2950ed16e81d765a8657c180920cc46/raw/12746d9f8836260f1998a453849e87d21c594a5c/HISHINUI"))()
local Win = Library:CreateWindow("🔥 RIOT CITY PRO MAX")

-- [ 🛠️ CORE SERVICES ]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local plr = Players.LocalPlayer
local Mouse = plr:GetMouse()

-- [ 🟡 GLOBAL VARIABLES ]
getgenv().ESP_Enabled = false
getgenv().Show_Tracer = false
getgenv().Show_Bounty = false
getgenv().FOV_Enabled = false
getgenv().FOV_Size = 150
getgenv().Aimbot_Enabled = false
getgenv().Aimbot_Smoothness = 1
getgenv().Prediction_Factor = 0
getgenv().WallCheck_Enabled = false 
getgenv().Lock_In_Vehicle = false 
getgenv().Speed_Enabled = false
getgenv().WalkSpeed = 50
getgenv().Noclip_Enabled = false 
getgenv().GodMode_Enabled = false 
getgenv().AutoE_Enabled = false 
getgenv().Warp_Target_Name = "Select Player"
getgenv().Attach_Head = false
getgenv().Attach_Behind_Under = false 
getgenv().SilentAim_Enabled = false
getgenv().Fly_Enabled = false
getgenv().Fly_Speed = 50
getgenv().Auto_Bounty_Hunter = false
getgenv().Fast_Arrest = false

-- ตัวแปรระบบสลับถือไอเทม
getgenv().Selected_Tool_To_Lock = "Select Tool"
getgenv().Lock_Tool_Enabled = false
getgenv().Toggle_Tool_Enabled = false

getgenv().AutoFarmATM_Running = false
local CurrentAimTarget = nil
local CurrentPredictedPos = nil
local FlyBodyVelocity = nil
local CurrentBountyTarget = nil
local BustCooldown = tick()
local HandcuffTimer = tick()
local RoamTimer = tick()
local CurrentRoamIndex = 1
local MagicPlatform = nil

local ATM_Locations = {
    CFrame.new(602.396851, -30.6047096, -1251.58752, -0.258864403, 0, 0.965913713, 0, 1, 0, -0.965913713, 0, -0.258864403),
    CFrame.new(623.416199, -30.6047096, -1173.14172, -0.258864403, 0, 0.965913713, 0, 1, 0, -0.965913713, 0, -0.258864403),
    CFrame.new(346.203735, -30.6047096, -1684.86462, 0.258864343, -0, -0.965913713, 0, 1, -0, 0.965913713, 0, 0.258864343),
    CFrame.new(356.594788, -43.4439888, -1667.9585, 0.965929627, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, 0.965929627),
    CFrame.new(-1220.28918, 13.0121841, -2711.61694, 0.207885921, 0, 0.97815311, 0, 1, 0, -0.97815311, 0, 0.207885921),
    CFrame.new(1414.58081, -15.530982, -1547.00623, 0.965929627, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, 0.965929627),
    CFrame.new(268.023834, -30.6307068, -925.532593, 0.258864343, -0, -0.965913713, 0, 1, -0, 0.965913713, 0, 0.258864343),
    CFrame.new(492.613464, -30.6047096, -1689.10303, -0.258864403, 0, 0.965913713, 0, 1, 0, -0.965913713, 0, -0.258864403),
    CFrame.new(-141.057709, -30.6047096, -1304.32422, 0.258864343, -0, -0.965913713, 0, 1, -0, 0.965913713, 0, 0.258864343),
    CFrame.new(-713.075928, -8.3178606, -963.550964, 0.990270376, 0, 0.13915664, 0, 1, 0, -0.13915664, 0, 0.990270376),
    CFrame.new(924.706787, -30.5050888, -1986.00903, -0.965929747, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, -0.965929747)
}

local MapLocations = {
    Store = CFrame.new(841.36, -30.87, -460.57),
    Jewelry = CFrame.new(262.31, -38.00, -1683.00),
    GunStore = CFrame.new(-171.59, -30.34, -1262.56),
    BankTop = CFrame.new(664.56, -7.42, -1258.93),
    CriminalBase = CFrame.new(370.36, 45.00, -2974.59),
    SafeZone1 = CFrame.new(500, 200, -1000), -- ย้าย Safezone ขึ้นฟ้าสูงๆ
    SafeZone2 = CFrame.new(-500, 200, -1500),
    SafeZone3 = CFrame.new(0, 200, -2000),
    PoliceSpawn = CFrame.new(615.54, 45.10, -1565.34)
}
local RoamPoints = {MapLocations.SafeZone1, MapLocations.SafeZone2, MapLocations.SafeZone3, MapLocations.PoliceSpawn}

local Tracers, Highlights, Billboards = {}, {}, {}

-- [ 🔵 HELPER FUNCTIONS ]
local function SafeToggle(v) return (type(v) == "boolean" and v) or (type(v) == "table" and v[1] == true) or false end
local function ShowNotification(t, d) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title=t, Text=d, Duration=4}) end) end

local function GetPlayerBounty(p)
    local b = 0
    pcall(function() b = (p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Bounty") and tonumber(p.leaderstats.Bounty.Value)) or (p:FindFirstChild("Bounty") and tonumber(p.Bounty.Value)) or 0 end)
    return b
end

local function GetPlayerMoney()
    local m = 0
    pcall(function() m = (plr:FindFirstChild("leaderstats") and plr.leaderstats:FindFirstChild("Cash") and tonumber(plr.leaderstats.Cash.Value)) or (plr:FindFirstChild("leaderstats") and plr.leaderstats:FindFirstChild("Money") and tonumber(plr.leaderstats.Money.Value)) or 0 end)
    return m
end

local function GetPlayersList()
    local t, sortedNames = {}, {}
    for _, v in pairs(Players:GetPlayers()) do if v ~= plr then table.insert(sortedNames, v.Name) end end
    table.sort(sortedNames); for _, name in ipairs(sortedNames) do table.insert(t, name) end
    return t
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

-- [ 🟢 GUI SETUP (HUD) ]
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
local UICorner = Instance.new("UICorner", E_Button); UICorner.CornerRadius = UDim.new(1, 0)
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

-- [ 🟢 ADVANCED AUTO INTERACT (ขยายระยะ & ลดแลค) ]
local function UpgradePrompt(prompt)
    if prompt:IsA("ProximityPrompt") then 
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false 
        if prompt.MaxActivationDistance < 25 then
            prompt.MaxActivationDistance = 25
        end
    end
end
for _, obj in pairs(workspace:GetDescendants()) do UpgradePrompt(obj) end
workspace.DescendantAdded:Connect(UpgradePrompt)

-- 1. Auto E (ทั่วไป)
ProximityPromptService.PromptShown:Connect(function(prompt)
    prompt.HoldDuration = 0; prompt.RequiresLineOfSight = false 
    if getgenv().AutoE_Enabled then 
        local act, obj = prompt.ActionText:lower(), prompt.ObjectText:lower()
        local isVeh = act:find("drive") or act:find("passenger") or act:find("enter") or act:find("sit") or obj:find("vehicle") or obj:find("car")
        if prompt.Parent and (prompt.Parent:IsA("VehicleSeat") or prompt.Parent:IsA("Seat")) then isVeh = true end
        
        if not isVeh and not act:find("cuff") and not act:find("arrest") and not act:find("eject") and not act:find("kick") then
            if tick() - BustCooldown >= 1.5 then
                if fireproximityprompt then fireproximityprompt(prompt, 1); fireproximityprompt(prompt, 0) 
                else prompt:InputHoldBegin(); task.wait(0.01); prompt:InputHoldEnd() end
                BustCooldown = tick()
            end
        end
    end
end)

-- 2. Auto Bust (ล่าค่าหัว - ลดแลค & ปรับความรัวได้)
task.spawn(function()
    while task.wait(0.2) do -- ความถี่การสแกนแบบไม่หน่วงเครื่อง
        if getgenv().Auto_Bounty_Hunter and CurrentBountyTarget and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled and prompt.Parent and prompt.Parent:IsA("BasePart") then
                    if (prompt.Parent.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 25 then
                        local act = prompt.ActionText:lower()
                        local obj = prompt.ObjectText:lower()
                        
                        local isVeh = act:find("drive") or act:find("passenger") or act:find("enter") or act:find("sit") or obj:find("vehicle") or obj:find("car")
                        if prompt.Parent and (prompt.Parent:IsA("VehicleSeat") or prompt.Parent:IsA("Seat")) then isVeh = true end

                        if not isVeh and (act:find("cuff") or act:find("arrest") or act:find("จับ") or act:find("eject") or act:find("ดีด") or act:find("kick")) then
                            
                            local cooldownTime = getgenv().Fast_Arrest and 0.5 or 1.5
                            
                            if tick() - BustCooldown >= cooldownTime then
                                prompt.RequiresLineOfSight = false
                                prompt.HoldDuration = 0
                                if fireproximityprompt then 
                                    fireproximityprompt(prompt, 1); fireproximityprompt(prompt, 0)
                                else 
                                    prompt:InputHoldBegin(); task.wait(0.02); prompt:InputHoldEnd() 
                                end
                                BustCooldown = tick()
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- 🔵 [ AUTO FARM ATM ]
local function ExecuteAutoFarm()
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then getgenv().AutoFarmATM_Running = false; return end
    local root = plr.Character.HumanoidRootPart; local origCF = root.CFrame
    local stMoney = GetPlayerMoney()
    
    local plat = Instance.new("Part", workspace); plat.Size = Vector3.new(15, 1, 15); plat.Anchored = true; plat.Transparency = 1; plat.CanCollide = true
    ShowNotification("🚀 เริ่มต้นระบบฟาร์ม", "โหมดฟาร์มสายฟ้าแลบ เริ่มต้น! ⚡")
    
    for i, atmCFrame in ipairs(ATM_Locations) do
        if not plr.Character or not root then break end
        local tgtPos = atmCFrame * CFrame.new(0, 0, 2.5); plat.CFrame = tgtPos * CFrame.new(0, -3.5, 0)
        root.CFrame = tgtPos; root.Velocity = Vector3.new(0,0,0)
        task.wait(0.2)
        local col, att = false, 0
        while att < 10 do 
            local curMoney = GetPlayerMoney()
            for _, pm in pairs(workspace:GetDescendants()) do
                if pm:IsA("ProximityPrompt") and pm.Enabled and pm.Parent and pm.Parent:IsA("BasePart") then
                    if (pm.Parent.Position - root.Position).Magnitude <= 20 then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, pm.Parent.Position)
                        pm.RequiresLineOfSight = false; pm.HoldDuration = 0
                        if fireproximityprompt then fireproximityprompt(pm, 1); fireproximityprompt(pm, 0) end
                        pm:InputHoldBegin(); task.wait(0.01); pm:InputHoldEnd()
                    end
                end
            end
            task.wait(0.2)
            if GetPlayerMoney() > curMoney then col = true; ShowNotification("🏦 ตู้ ATM " .. i, "Done ✅"); break end
            att = att + 1
        end
        if not col then ShowNotification("🏦 ตู้ ATM " .. i, "ข้าม ⏩") end
    end
    plat:Destroy(); if plr.Character and root then root.CFrame = origCF end
    
    local endMoney = GetPlayerMoney()
    ShowNotification("✅ ฟาร์มเสร็จสิ้น", "ได้เงินทั้งหมด: $" .. tostring(endMoney - stMoney))
    getgenv().AutoFarmATM_Running = false
end

-- [ 🛡️ BYPASS & MAGIC BULLET (ORIGINAL - ปลอดภัย 100%) ]
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

-- [ 🎨 UI SETUP ]
local VisTab = Win:CreateTab("👁️ Visuals")
local EspSec = VisTab:CreateSection("ระบบมองทะลุ & ESP")
EspSec:CreateToggle("เปิด ESP ผู้เล่น", function(v) getgenv().ESP_Enabled = SafeToggle(v); CountText.Visible = getgenv().ESP_Enabled end)
EspSec:CreateToggle("เปิดเส้นโยง", function(v) getgenv().Show_Tracer = SafeToggle(v) end)
EspSec:CreateToggle("แสดงค่าหัว (Bounty) 👑", function(v) getgenv().Show_Bounty = SafeToggle(v) end)

local FovSec = VisTab:CreateSection("ตั้งค่าเป้าสายตา (FOV)")
FovSec:CreateToggle("แสดงวงกลม FOV", function(v) getgenv().FOV_Enabled = SafeToggle(v) end)
FovSec:CreateSlider("ขนาด FOV", 50, 600, 150, function(v) getgenv().FOV_Size = tonumber(v) end)

local AimTab = Win:CreateTab("🔫 Combat")
local AimSec = AimTab:CreateSection("ระบบเล็ง & Aimbot")
AimSec:CreateToggle("🎯 Aimbot (ล็อคหัว)", function(v) getgenv().Aimbot_Enabled = SafeToggle(v) end)
AimSec:CreateToggle("🎯 Magic Bullet (กระสุนเลี้ยว)", function(v) getgenv().SilentAim_Enabled = SafeToggle(v) end)
AimSec:CreateToggle("🚧 เช็คกำแพง (Wall Check)", function(v) getgenv().WallCheck_Enabled = SafeToggle(v) end)
AimSec:CreateToggle("🚗 ล็อคคนในรถ", function(v) getgenv().Lock_In_Vehicle = SafeToggle(v) end)
AimSec:CreateSlider("ความสมูทกล้อง", 1, 100, 100, function(v) getgenv().Aimbot_Smoothness = (tonumber(v) or 100) / 100 end)
AimSec:CreateSlider("ค่าดักหน้า (Prediction)", 0, 50, 0, function(v) getgenv().Prediction_Factor = (tonumber(v) or 0) / 100 end)

local GodSec = AimTab:CreateSection("ระดับพระเจ้า (God Tier)")
GodSec:CreateToggle("👻 กันดาเมจ (เลเซอร์/ตกตึก/ลงรถ)", function(v) 
    getgenv().GodMode_Enabled = SafeToggle(v) 
    if not getgenv().GodMode_Enabled and plr.Character then
        for _, p in pairs(plr.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanTouch = true end end
        if plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            plr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
    end
end)
GodSec:CreateToggle("⚡ Auto E (ลากปุ่มได้)", function(v) getgenv().AutoE_Enabled = SafeToggle(v); E_Button.Visible = getgenv().AutoE_Enabled end)

local MoveTab = Win:CreateTab("🏃 Movement")
local SpeedSec = MoveTab:CreateSection("ระบบเคลื่อนที่ & บิน")
SpeedSec:CreateToggle("⚡ เปิดใช้งานวิ่งไว", function(v) getgenv().Speed_Enabled = SafeToggle(v) end)
SpeedSec:CreateSlider("ความเร็ววิ่ง", 16, 200, 50, function(v) getgenv().WalkSpeed = tonumber(v) end)
SpeedSec:CreateToggle("👻 Noclip ทะลุทุกอย่าง", function(v) getgenv().Noclip_Enabled = SafeToggle(v) end)
SpeedSec:CreateToggle("🦅 เปิดใช้งานบิน (Mobile Fly)", function(v) getgenv().Fly_Enabled = SafeToggle(v) end)
SpeedSec:CreateSlider("ความเร็วบิน", 10, 300, 50, function(v) getgenv().Fly_Speed = tonumber(v) end)

local TpTab = Win:CreateTab("🌀 เทเลพอร์ต & ล็อคไอเทม")
local BountySec = TpTab:CreateSection("💀 นักล่าค่าหัวอัตโนมัติ (Bounty Hunter)")

local ToolDrop = BountySec:CreateDropdown("🎒 เลือกไอเทมที่จะสลับถือ", GetInventoryTools(), function(v) getgenv().Selected_Tool_To_Lock = v end)
BountySec:CreateButton("🔄 รีเฟรชไอเทมในกระเป๋า", function() ToolDrop:Refresh(GetInventoryTools()) end)
BountySec:CreateToggle("🔒 ล็อคถือไอเทมแบบค้าง (ถือตลอดเวลา)", function(v) getgenv().Lock_Tool_Enabled = SafeToggle(v); if v then getgenv().Toggle_Tool_Enabled = false end end)
BountySec:CreateToggle("🔄 ล็อคและสลับถือไอเทม (สลับมือเปล่า)", function(v) getgenv().Toggle_Tool_Enabled = SafeToggle(v); if v then getgenv().Lock_Tool_Enabled = false end end)

BountySec:CreateToggle("🔥 ออโต้วาร์ปล่าค่าหัว (ค่าหัว 1000+)", function(v) 
    getgenv().Auto_Bounty_Hunter = SafeToggle(v) 
    if v then getgenv().Attach_Head = false; getgenv().Attach_Behind_Under = false end
end)
BountySec:CreateToggle("⚡ โหมดจับกุมความเร็วสูง (รัวแต่ปลอดภัย)", function(v) getgenv().Fast_Arrest = SafeToggle(v) end)

local TpSec = TpTab:CreateSection("📍 วาร์ปหาผู้เล่น (กำหนดเอง)")
local WarpDrop = TpSec:CreateDropdown("👤 เลือกผู้เล่นเป้าหมาย", GetPlayersList(), function(v) getgenv().Warp_Target_Name = v end)
TpSec:CreateButton("🔄 รีเฟรชรายชื่อผู้เล่น", function() WarpDrop:Refresh(GetPlayersList()) end)
TpSec:CreateButton("🚀 วาร์ปไปหาผู้เล่น", function()
    local t = Players:FindFirstChild(getgenv().Warp_Target_Name)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end
end)
TpSec:CreateToggle("🐒 วาร์ปเกาะบนหัวเป้าหมาย", function(v) getgenv().Attach_Head = SafeToggle(v); if v then getgenv().Attach_Behind_Under = false; getgenv().Auto_Bounty_Hunter = false end end)
TpSec:CreateToggle("🐒 วาร์ปมุดใต้ดินด้านหลัง", function(v) getgenv().Attach_Behind_Under = SafeToggle(v); if v then getgenv().Attach_Head = false; getgenv().Auto_Bounty_Hunter = false end end)

local MapTab = Win:CreateTab("📍 สถานที่ & ฟาร์ม")
local FarmSec = MapTab:CreateSection("💰 ระบบฟาร์มเงินอัตโนมัติ")
FarmSec:CreateButton("🚀 เริ่ม Auto Farm ATM (11 จุด)", function()
    if getgenv().AutoFarmATM_Running then ShowNotification("⚠️", "ระบบกำลังทำงานอยู่"); return end
    getgenv().AutoFarmATM_Running = true; task.spawn(ExecuteAutoFarm)
end)
local MapSec = MapTab:CreateSection("วาร์ปไปยังสถานที่ (Teleport)")
for k, v in pairs(MapLocations) do 
    if k ~= "SafeZone1" and k ~= "SafeZone2" and k ~= "SafeZone3" and k ~= "PoliceSpawn" then
        MapSec:CreateButton(k, function() if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.CFrame = v end end) 
    end
end

-- [ 🚀 ENGINE LOOPS ]
local function DrawLine2D(frame, p1, p2)
    local dist, angle = (p1 - p2).Magnitude, math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X))
    frame.Size, frame.Position, frame.Rotation = UDim2.new(0, dist, 0, 2), UDim2.new(0, (p1.X + p2.X) / 2, 0, (p1.Y + p2.Y) / 2), angle
end

local function ManageESP(p)
    if p == plr then return end
    if not Tracers[p] then local l = Instance.new("Frame", ESP_Folder); l.AnchorPoint = Vector2.new(0.5, 0.5); l.BorderSizePixel = 0; l.ZIndex = 1; l.Visible = false; Tracers[p] = l end
    if not Highlights[p] then local h = Instance.new("Highlight", CoreGui); h.FillTransparency = 0.7; h.OutlineTransparency = 0.2; h.Enabled = false; Highlights[p] = h end
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
            for _, p in ipairs(Players:GetPlayers()) do if p.Team then local n = p.Team.Name:lower(); if n:find("police") or n:find("cop") then pol = pol + 1 elseif n:find("crim") or n:find("prison") then cri = cri + 1 end end end
            CountText.Text = string.format("👮 ตำรวจ : %d   |   🦹 นักโทษ : %d", pol, cri); CountText.TextColor3 = curRGB
        end
        
        -- อัปเดตสีแผ่นกระจก RGB
        if MagicPlatform then MagicPlatform.Color = curRGB end
        
        for p, tl in pairs(Tracers) do
            local char = p.Character; local ap = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
            if getgenv().ESP_Enabled and char and ap and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(ap.Position); local pc = GetPlayerColor(p)
                if getgenv().Show_Tracer and onScreen and pos.Z > 0 then tl.Visible = true; tl.BackgroundColor3 = curRGB; DrawLine2D(tl, Vector2.new(Camera.ViewportSize.X/2, 65), Vector2.new(pos.X, pos.Y)) else tl.Visible = false end
                Highlights[p].Enabled, Highlights[p].Adornee, Highlights[p].FillColor = true, char, pc
                local b = Billboards[p]; b.Gui.Enabled, b.Gui.Adornee = true, ap
                local bTxt = (getgenv().Show_Bounty and GetPlayerBounty(p) > 0) and "\n💰 [$"..GetPlayerBounty(p).."]" or ""
                b.Txt.Text, b.Txt.TextColor3 = p.Name.."\n["..math.floor((Camera.CFrame.Position - ap.Position).Magnitude).."m]"..bTxt, pc
            else 
                tl.Visible = false; Highlights[p].Enabled = false; Billboards[p].Gui.Enabled = false
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

-- 🔒 [ ลูปสำหรับล็อคถือไอเทมค้าง (ถือตลอดเวลา) ]
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Lock_Tool_Enabled and getgenv().Selected_Tool_To_Lock ~= "Select Tool" then
            pcall(function()
                local char = plr.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local currentTool = char:FindFirstChildOfClass("Tool")
                    if not currentTool or currentTool.Name ~= getgenv().Selected_Tool_To_Lock then
                        local bp = plr:FindFirstChild("Backpack")
                        if bp then
                            local targetTool = bp:FindFirstChild(getgenv().Selected_Tool_To_Lock)
                            if targetTool then
                                char.Humanoid:EquipTool(targetTool)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 🔄 [ ลูปสำหรับสลับถือไอเทม (Toggle Tool Lock สลับมือเปล่า) ]
task.spawn(function()
    while task.wait(2) do
        if getgenv().Toggle_Tool_Enabled and getgenv().Selected_Tool_To_Lock ~= "Select Tool" then
            pcall(function()
                local char = plr.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local currentTool = char:FindFirstChildOfClass("Tool")
                    if currentTool and currentTool.Name == getgenv().Selected_Tool_To_Lock then
                        char.Humanoid:UnequipTools()
                    else
                        local bp = plr:FindFirstChild("Backpack")
                        if bp then
                            local targetTool = bp:FindFirstChild(getgenv().Selected_Tool_To_Lock)
                            if targetTool then char.Humanoid:EquipTool(targetTool) end
                        end
                    end
                end
            end)
        end
    end
end)

-- ควักไอเทมให้ทันทีเมื่อเกิดใหม่ หากเปิดระบบล็อคไว้
plr.CharacterAdded:Connect(function() 
    task.wait(1.5) 
    if getgenv().Lock_Tool_Enabled or getgenv().Toggle_Tool_Enabled then 
        pcall(function()
            local bp = plr:FindFirstChild("Backpack")
            if bp then
                local targetTool = bp:FindFirstChild(getgenv().Selected_Tool_To_Lock)
                if targetTool and plr.Character and plr.Character:FindFirstChild("Humanoid") then 
                    plr.Character.Humanoid:EquipTool(targetTool) 
                end
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = plr.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- จัดการแผ่นกันตก RGB (เปิดเมื่อล่าค่าหัว หรือเกาะติดผู้เล่น หรือบิน)
        if getgenv().Fly_Enabled or getgenv().Auto_Bounty_Hunter or getgenv().Attach_Head or getgenv().Attach_Behind_Under then
            if not MagicPlatform or not MagicPlatform.Parent then
                MagicPlatform = Instance.new("Part", workspace)
                MagicPlatform.Name = "N_MagicPlatform"
                MagicPlatform.Size = Vector3.new(15, 1, 15)
                MagicPlatform.Anchored = true
                MagicPlatform.CanCollide = true
                MagicPlatform.Material = Enum.Material.Neon
                MagicPlatform.Transparency = 0.5
            end
            MagicPlatform.CFrame = root.CFrame * CFrame.new(0, -3.5, 0)
        else
            if MagicPlatform then 
                MagicPlatform:Destroy()
                MagicPlatform = nil
            end
        end
        
        -- 🦅 ระบบบินบนมือถือ
        if getgenv().Fly_Enabled then
            if not FlyBodyVelocity then 
                FlyBodyVelocity = Instance.new("BodyVelocity", root)
                FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge) 
            end
            char.Humanoid.PlatformStand = true 
            local md = char.Humanoid.MoveDirection
            if md.Magnitude > 0 then
                FlyBodyVelocity.Velocity = Vector3.new(md.X, Camera.CFrame.LookVector.Y * math.abs(md.Magnitude), md.Z).Unit * getgenv().Fly_Speed
            else
                FlyBodyVelocity.Velocity = Vector3.new(0,0,0)
            end
        else
            if FlyBodyVelocity then 
                FlyBodyVelocity:Destroy(); FlyBodyVelocity = nil 
                char.Humanoid.PlatformStand = false 
            end
        end
        
        -- 🔥 Auto Bounty Hunter (Smart Stance + Moving Arrest)
        if getgenv().Auto_Bounty_Hunter then
            local bestTarget = nil; local maxBounty = 0
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    local bounty = GetPlayerBounty(p)
                    if bounty >= 1000 and bounty > maxBounty then maxBounty = bounty; bestTarget = p end
                end
            end
            
            if bestTarget ~= CurrentBountyTarget and bestTarget ~= nil then
                CurrentBountyTarget = bestTarget
                ShowNotification("💀 ล่าค่าหัวเป้าหมายใหม่", "เป้าหมาย: " .. bestTarget.Name .. "\n💰 ค่าหัว: $" .. tostring(maxBounty))
            end
            
            if bestTarget and bestTarget.Character and bestTarget.Character:FindFirstChild("HumanoidRootPart") then
                local tRoot = bestTarget.Character.HumanoidRootPart
                local tHum = bestTarget.Character:FindFirstChild("Humanoid")
                
                -- ชดเชยการเคลื่อนที่ (Predict Velocity)
                local predictedPos = tRoot.CFrame + (tRoot.Velocity * 0.05) 
                
                if tHum and (tHum:GetState() == Enum.HumanoidStateType.Seated or tRoot.Size.Y < 1.5) then
                    root.CFrame = predictedPos * CFrame.new(0, 0.5, 1.2)
                else
                    root.CFrame = predictedPos * CFrame.new(0, 1.5, 1.8)
                end
                
                root.Velocity = Vector3.new(0,0,0)
            else
                CurrentBountyTarget = nil
                if tick() - RoamTimer >= math.random(3, 4) then
                    CurrentRoamIndex = CurrentRoamIndex + 1
                    if CurrentRoamIndex > #RoamPoints then CurrentRoamIndex = 1 end
                    root.CFrame = RoamPoints[CurrentRoamIndex]
                    root.Velocity = Vector3.new(0,0,0)
                    RoamTimer = tick()
                end
            end
        else
            CurrentBountyTarget = nil
            
            -- Manual TP (เกาะหัว/มุดดิน)
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

RunService.Stepped:Connect(function()
    pcall(function()
        local char = plr.Character; if not char then return end
        
        -- 🛡️ God Mode
        if getgenv().GodMode_Enabled then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanTouch = false end end
            if char:FindFirstChild("Humanoid") then
                char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end

        if char:FindFirstChild("Humanoid") and not getgenv().Fly_Enabled then char.Humanoid.WalkSpeed = getgenv().Speed_Enabled and getgenv().WalkSpeed or 16 end
        if getgenv().Noclip_Enabled or getgenv().Auto_Bounty_Hunter or getgenv().Attach_Head or getgenv().Attach_Behind_Under then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)
end)
