-- [[ N-SHINNEN V.7 PRO MAX : RIOT CITY (ORIGINAL ESP/AIMBOT + NEW FEATURES) ]] --
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/d2950ed16e81d765a8657c180920cc46/raw/12746d9f8836260f1998a453849e87d21c594a5c/HISHINUI"))()
local Win = Library:CreateWindow("🔥 RIOT CITY PRO ")

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
getgenv().Aimbot_Smoothness = 1     -- ปรับเป็น 1 (ล็อคแข็ง) เริ่มต้น
getgenv().Prediction_Factor = 0     -- ปรับเป็น 0 เริ่มต้น (แก้เล็งไม่ตรงในเกม Hitscan)
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

local CurrentAimTarget = nil
local CurrentPredictedPos = nil

-- พิกัดสถานที่
local MapLocations = {
    Store = CFrame.new(841.36, -30.87, -460.57),
    Jewelry = CFrame.new(262.31, -38.00, -1683.00),
    GunStore = CFrame.new(-171.59, -30.34, -1262.56),
    BankTop = CFrame.new(664.56, -7.42, -1258.93),
    CriminalBase = CFrame.new(370.36, 45.00, -2974.59) 
}

local Tracers = {}
local Highlights = {}
local Billboards = {}

-- [ 🟢 GUI SETUP ]
local FOV_Gui = CoreGui:FindFirstChild("N_FOV_GUI")
if FOV_Gui then FOV_Gui:Destroy() end
FOV_Gui = Instance.new("ScreenGui", CoreGui); FOV_Gui.Name = "N_FOV_GUI"; FOV_Gui.IgnoreGuiInset = true 
local FOV_Frame = Instance.new("Frame", FOV_Gui); FOV_Frame.AnchorPoint = Vector2.new(0.5, 0.5); FOV_Frame.Position = UDim2.new(0.5, 0, 0.5, 0); FOV_Frame.BackgroundTransparency = 1
local FOV_Stroke = Instance.new("UIStroke", FOV_Frame); FOV_Stroke.Thickness = 2
local FOV_Corner = Instance.new("UICorner", FOV_Frame); FOV_Corner.CornerRadius = UDim.new(1, 0)

-- แก้ไข Lock Line ให้วาดและเห็นชัดเจน
local LockLineFrame = Instance.new("Frame", FOV_Gui)
LockLineFrame.Name = "N_LOCKLINE"
LockLineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LockLineFrame.ZIndex = 10
LockLineFrame.BorderSizePixel = 0
LockLineFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- สีแดงเข้ม
LockLineFrame.Visible = false

local ESP_Folder = CoreGui:FindFirstChild("N_ESP_FOLDER")
if ESP_Folder then ESP_Folder:Destroy() end
ESP_Folder = Instance.new("ScreenGui", CoreGui); ESP_Folder.Name = "N_ESP_FOLDER"; ESP_Folder.IgnoreGuiInset = true

local CountFrame = Instance.new("Frame", ESP_Folder); CountFrame.AnchorPoint = Vector2.new(0.5, 0); CountFrame.Position = UDim2.new(0.5, 0, 0, 40); CountFrame.Size = UDim2.new(0, 300, 0, 50); CountFrame.BackgroundTransparency = 1
local CountText = Instance.new("TextLabel", CountFrame); CountText.Size = UDim2.new(1, 0, 1, 0); CountText.BackgroundTransparency = 1; CountText.Font = Enum.Font.GothamBlack; CountText.TextSize = 22; CountText.TextStrokeTransparency = 0.2; CountText.Visible = false 

-- [ 🟢 สร้างปุ่ม Auto E ลอย (ลากได้) ]
local MobileUI = CoreGui:FindFirstChild("N_MobileAutoE")
if MobileUI then MobileUI:Destroy() end

MobileUI = Instance.new("ScreenGui", CoreGui)
MobileUI.Name = "N_MobileAutoE"
MobileUI.ResetOnSpawn = false

local E_Button = Instance.new("TextButton", MobileUI)
E_Button.Size = UDim2.new(0, 70, 0, 70)
E_Button.Position = UDim2.new(0.85, -40, 0.4, 0)
E_Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
E_Button.Text = "⚡\nAuto E\n[OFF]"
E_Button.Font = Enum.Font.GothamBold
E_Button.TextSize = 14
E_Button.TextColor3 = Color3.fromRGB(255, 100, 100)
E_Button.Active = true
local UICorner = Instance.new("UICorner", E_Button)
UICorner.CornerRadius = UDim.new(1, 0)
E_Button.Visible = false 

local dragging, dragInput, dragStart, startPos
E_Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = E_Button.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
E_Button.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart; E_Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
E_Button.MouseButton1Click:Connect(function()
    getgenv().AutoE_Enabled = not getgenv().AutoE_Enabled
    E_Button.Text = getgenv().AutoE_Enabled and "⚡\nAuto E\n[ON]" or "⚡\nAuto E\n[OFF]"
    E_Button.TextColor3 = getgenv().AutoE_Enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

ProximityPromptService.PromptShown:Connect(function(prompt)
    if getgenv().AutoE_Enabled then prompt.HoldDuration = 0; prompt:InputHoldBegin(); task.wait(0.05); prompt:InputHoldEnd() end
end)

-- [ 🔵 HELPER FUNCTIONS ]
local function GetPlayersList()
    local t = {}; local sortedNames = {}
    for _, v in pairs(Players:GetPlayers()) do if v ~= plr then table.insert(sortedNames, v.Name) end end
    table.sort(sortedNames); for _, name in ipairs(sortedNames) do table.insert(t, name) end
    return t
end

local function DrawLine(frame, p1, p2)
    local distance = (p1 - p2).Magnitude
    local angle = math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X))
    frame.Size = UDim2.new(0, distance, 0, 2)
    frame.Position = UDim2.new(0, (p1.X + p2.X) / 2, 0, (p1.Y + p2.Y) / 2)
    frame.Rotation = angle
end

local function IsVisible(targetChar)
    if not getgenv().WallCheck_Enabled then return true end 
    if not plr.Character or not targetChar then return false end
    local origin = Camera.CFrame.Position
    local targetPart = targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
    if not targetPart then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {plr.Character, targetChar, workspace:FindFirstChild("Vehicles")}
    params.FilterType = Enum.RaycastFilterType.Exclude
    return not workspace:Raycast(origin, targetPart.Position - origin, params)
end

local function GetClosestPlayerInFOV()
    local closestPlayer = nil; local shortestDistance = getgenv().FOV_Size
    local centerPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            if p.Character.Humanoid.Sit and not getgenv().Lock_In_Vehicle then continue end
            local targetPart = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen and pos.Z > 0 then
                    local dist = (Vector2.new(pos.X, pos.Y) - centerPos).Magnitude
                    if dist <= shortestDistance and IsVisible(p.Character) then
                        shortestDistance = dist; closestPlayer = p
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function GetPlayerColor(p) return p.Team and p.TeamColor.Color or Color3.fromRGB(255, 255, 255) end

local function GetPredictedPosition(target)
    if not target or not target.Character then return nil end
    local aimPart = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
    if aimPart then
        local velocity = target.Character.HumanoidRootPart and target.Character.HumanoidRootPart.Velocity or aimPart.Velocity
        return aimPart.Position + (velocity * getgenv().Prediction_Factor)
    end
    return nil
end

local function GetPlayerBounty(p)
    local bounty = 0
    pcall(function()
        if p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Bounty") then bounty = tonumber(p.leaderstats.Bounty.Value) or 0
        elseif p:FindFirstChild("Bounty") then bounty = tonumber(p.Bounty.Value) or 0 end
    end)
    return bounty
end

local function SafeToggle(v) if type(v) == "boolean" then return v elseif type(v) == "table" then return v[1] == true end return false end

-- [ 🛡️ BYPASS & MAGIC BULLET HOOKS (อัปเกรดใหม่) ]
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldNewIndex = mt.__newindex
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__newindex = newcclosure(function(t, k, v)
    if not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then return end
    return oldNewIndex(t, k, v)
end)

mt.__index = newcclosure(function(t, k)
    if getgenv().SilentAim_Enabled and t == Mouse and (k == "Hit" or k == "Target") then
        if CurrentPredictedPos and CurrentAimTarget and CurrentAimTarget.Character then
            if k == "Hit" then return CFrame.new(CurrentPredictedPos) end
            if k == "Target" then return CurrentAimTarget.Character:FindFirstChild("Head") or CurrentAimTarget.Character:FindFirstChild("HumanoidRootPart") end
        end
    end
    return oldIndex(t, k)
end)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and (method == "Kick" or method == "kick") then return end
    
    if getgenv().SilentAim_Enabled and not checkcaller() and CurrentPredictedPos then
        -- แบบที่ 1: ดักจับระบบยิงที่ใช้ ScreenPointToRay (พวกปืน ACS ชอบใช้)
        if method == "ScreenPointToRay" or method == "ViewportPointToRay" then
            local originalRay = oldNamecall(self, ...)
            return Ray.new(originalRay.Origin, (CurrentPredictedPos - originalRay.Origin).Unit * 1000)
            
        -- แบบที่ 2: ดักจับ Raycast ปรับทิศทางเข้าหัว 100% แต่ใช้ความแรงเดิมปืนจะไม่บัค
        elseif method == "Raycast" and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
            local origin = args[1]
            local originalDirection = args[2]
            local mag = originalDirection.Magnitude
            args[2] = (CurrentPredictedPos - origin).Unit * mag
            return oldNamecall(self, unpack(args))
            
        -- แบบที่ 3: ดักจับ FindPartOnRay
        elseif string.find(method, "FindPartOnRay") and typeof(args[1]) == "Ray" then
            local origin = args[1].Origin
            local mag = args[1].Direction.Magnitude
            args[1] = Ray.new(origin, (CurrentPredictedPos - origin).Unit * mag)
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [ 🎨 UI SETUP ]
local VisTab = Win:CreateTab("👁️ Visuals")
local EspSec = VisTab:CreateSection("ระบบมองทะลุ & ESP")
EspSec:CreateToggle("เปิด ESP (Auto-Refresh)", function(v) getgenv().ESP_Enabled = SafeToggle(v); CountText.Visible = getgenv().ESP_Enabled end)
EspSec:CreateToggle("เปิดเส้นโยง", function(v) getgenv().Show_Tracer = SafeToggle(v) end)
EspSec:CreateToggle("แสดงค่าหัว (Bounty) 👑", function(v) getgenv().Show_Bounty = SafeToggle(v) end)

local FovSec = VisTab:CreateSection("ตั้งค่าเป้าสายตา (FOV)")
FovSec:CreateToggle("แสดงวงกลม FOV", function(v) getgenv().FOV_Enabled = SafeToggle(v) end)
FovSec:CreateSlider("ขนาด FOV", 50, 600, 150, function(v) getgenv().FOV_Size = tonumber(v) or 150 end)

local AimTab = Win:CreateTab("🔫 Combat & GodMode")
local AimSec = AimTab:CreateSection("ระบบเล็ง & Aimbot")
AimSec:CreateToggle("🎯 Aimbot (ล็อคหัวเป้าหมาย)", function(v) getgenv().Aimbot_Enabled = SafeToggle(v) end)
AimSec:CreateToggle("🎯 Magic Bullet (กระสุนเลี้ยวเข้าตัว)", function(v) getgenv().SilentAim_Enabled = SafeToggle(v) end)
AimSec:CreateToggle("🚧 เช็คกำแพง (Wall Check)", function(v) getgenv().WallCheck_Enabled = SafeToggle(v) end)
AimSec:CreateToggle("🚗 ล็อคคนในรถ", function(v) getgenv().Lock_In_Vehicle = SafeToggle(v) end)
AimSec:CreateSlider("ความสมูทกล้อง", 1, 100, 100, function(v) getgenv().Aimbot_Smoothness = (tonumber(v) or 100) / 100 end)
AimSec:CreateSlider("ค่าดักหน้า (Prediction)", 0, 50, 0, function(v) getgenv().Prediction_Factor = (tonumber(v) or 0) / 100 end)

local GodSec = AimTab:CreateSection("ระดับพระเจ้า (God Tier)")
GodSec:CreateToggle("👻 กันดาเมจ/กันเลเซอร์ (ตัวไม่ล่องหน)", function(v) 
    getgenv().GodMode_Enabled = SafeToggle(v) 
    if not getgenv().GodMode_Enabled and plr.Character then
        for _, p in pairs(plr.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanTouch = true end end
    end
end)
GodSec:CreateToggle("🔘 แสดงปุ่ม Auto E (ลอยหน้าจอลากได้)", function(v) E_Button.Visible = SafeToggle(v) end)

local MoveTab = Win:CreateTab("🏃 Movement")
local SpeedSec = MoveTab:CreateSection("ระบบเคลื่อนที่")
SpeedSec:CreateToggle("⚡ เปิดใช้งานวิ่งไว", function(v) getgenv().Speed_Enabled = SafeToggle(v) end)
SpeedSec:CreateSlider("ความเร็ว", 16, 200, 50, function(v) getgenv().WalkSpeed = tonumber(v) or 50 end)
SpeedSec:CreateToggle("👻 Noclip ทะลุทุกอย่าง", function(v) getgenv().Noclip_Enabled = SafeToggle(v) end)

local TpTab = Win:CreateTab("🌀 Teleport")
local TpSec = TpTab:CreateSection("ระบบวาร์ปหาผู้เล่น")
local WarpDrop = TpSec:CreateDropdown("เลือกเป้าหมาย", GetPlayersList(), function(v) getgenv().Warp_Target_Name = v end)
TpSec:CreateButton("🔄 รีเฟรชรายชื่อ", function() WarpDrop:Refresh(GetPlayersList()) end)
TpSec:CreateButton("📍 วาร์ปไปหา (Teleport)", function()
    local target = Players:FindFirstChild(getgenv().Warp_Target_Name)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)
TpSec:CreateToggle("เกาะบนหัว (Head TP)", function(v) getgenv().Attach_Head = SafeToggle(v) end)
TpSec:CreateToggle("มุดใต้ดินด้านหลัง (ลึก 8 หลัง 5)", function(v) getgenv().Attach_Behind_Under = SafeToggle(v) end)

local MapTab = Win:CreateTab("📍 Map Locations")
local MapSec = MapTab:CreateSection("วาร์ปไปยังสถานที่")
MapSec:CreateButton("🏪 ร้านสะดวกซื้อ", function() plr.Character.HumanoidRootPart.CFrame = MapLocations.Store end)
MapSec:CreateButton("💎 ตึกปล้นเพชร", function() plr.Character.HumanoidRootPart.CFrame = MapLocations.Jewelry end)
MapSec:CreateButton("🔫 ร้านปืน", function() plr.Character.HumanoidRootPart.CFrame = MapLocations.GunStore end)
MapSec:CreateButton("🏦 ตึกแบงค์", function() plr.Character.HumanoidRootPart.CFrame = MapLocations.BankTop end)
MapSec:CreateButton("🦹 ฐานโจร", function() plr.Character.HumanoidRootPart.CFrame = MapLocations.CriminalBase end)

-- [ 🚀 ENGINE LOOPS ]
local function CreateESP(p)
    if p == plr then return end
    if not Tracers[p] then local line = Instance.new("Frame", ESP_Folder); line.AnchorPoint = Vector2.new(0.5, 0.5); line.BorderSizePixel = 0; line.ZIndex = 1; line.Visible = false; Tracers[p] = line end
    if not Highlights[p] then local hl = Instance.new("Highlight", CoreGui); hl.FillTransparency = 0.7; hl.OutlineTransparency = 0.2; hl.Enabled = false; Highlights[p] = hl end
    if not Billboards[p] then
        local bg = Instance.new("BillboardGui", ESP_Folder); bg.Size = UDim2.new(0, 200, 0, 75); bg.StudsOffset = Vector3.new(0, 3.5, 0); bg.AlwaysOnTop = true; bg.Enabled = false
        local txt = Instance.new("TextLabel", bg); txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1; txt.Font = Enum.Font.GothamBold; txt.TextSize = 14; txt.TextStrokeTransparency = 0.4
        Billboards[p] = {Gui = bg, Txt = txt}
    end
end
local function RemoveESP(p)
    if Tracers[p] then Tracers[p]:Destroy(); Tracers[p] = nil end
    if Highlights[p] then Highlights[p]:Destroy(); Highlights[p] = nil end
    if Billboards[p] then if Billboards[p].Gui then Billboards[p].Gui:Destroy() end; Billboards[p] = nil end
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

RunService.RenderStepped:Connect(function()
    pcall(function()
        local currentRGB = Color3.fromHSV((tick() % 5) / 5, 1, 1)
        if FOV_Gui then
            FOV_Gui.Enabled = getgenv().FOV_Enabled
            FOV_Frame.Size = UDim2.new(0, getgenv().FOV_Size * 2, 0, getgenv().FOV_Size * 2); FOV_Stroke.Color = currentRGB
        end
        if CountText.Visible then
            local police, criminal = 0, 0
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Team then
                    local n = p.Team.Name:lower()
                    if n:find("police") or n:find("cop") then police = police + 1 elseif n:find("criminal") or n:find("prisoner") then criminal = criminal + 1 end
                end
            end
            CountText.Text = string.format("👮 ตำรวจ : %d   |   🦹 นักโทษ : %d", police, criminal); CountText.TextColor3 = currentRGB
        end
        
        for p, tracerLine in pairs(Tracers) do
            if not p or not p.Parent or not p.Character then
                tracerLine.Visible = false; if Highlights[p] then Highlights[p].Enabled = false end; if Billboards[p] then Billboards[p].Gui.Enabled = false end
                continue
            end
            local char = p.Character; local aimPart = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
            if getgenv().ESP_Enabled and char and aimPart and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(aimPart.Position); local pColor = GetPlayerColor(p)
                if getgenv().Show_Tracer and onScreen and pos.Z > 0 then
                    tracerLine.Visible = true; tracerLine.BackgroundColor3 = currentRGB; 
                    -- แก้เส้นโยง ESP ให้มาจากข้างบนจอ (ค่า Y = 65) เหมือนเดิม
                    DrawLine(tracerLine, Vector2.new(Camera.ViewportSize.X/2, 65), Vector2.new(pos.X, pos.Y))
                else tracerLine.Visible = false end
                
                if Highlights[p] then Highlights[p].Enabled = true; Highlights[p].Adornee = char; Highlights[p].FillColor = pColor end
                if Billboards[p] then
                    Billboards[p].Gui.Enabled = true; Billboards[p].Gui.Adornee = aimPart; local dist = math.floor((Camera.CFrame.Position - aimPart.Position).Magnitude)
                    local bTxt = getgenv().Show_Bounty and GetPlayerBounty(p) > 0 and "\n💰 [$"..GetPlayerBounty(p).."]" or ""
                    Billboards[p].Txt.Text = p.Name.."\n["..dist.."m]"..bTxt; Billboards[p].Txt.TextColor3 = pColor
                end
            else 
                tracerLine.Visible = false; if Highlights[p] then Highlights[p].Enabled = false end; if Billboards[p] then Billboards[p].Gui.Enabled = false end
            end
        end
        
        CurrentAimTarget = GetClosestPlayerInFOV()
        CurrentPredictedPos = GetPredictedPosition(CurrentAimTarget)
        
        -- ลากเส้นล็อคเป้าสีแดง ให้อยู่เฉพาะในกรอบ FOV
        if CurrentAimTarget and (getgenv().Aimbot_Enabled or getgenv().SilentAim_Enabled) and CurrentPredictedPos then
            local pos, onScreen = Camera:WorldToViewportPoint(CurrentPredictedPos)
            if onScreen and pos.Z > 0 then
                LockLineFrame.Visible = true
                -- ลากจากตรงกลางเป้าเล็ง ไปหาตัวที่เรากำลังเล็งอยู่ (ในกรอบ FOV)
                local centerScreen = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                DrawLine(LockLineFrame, centerScreen, Vector2.new(pos.X, pos.Y))
            else LockLineFrame.Visible = false end
        else LockLineFrame.Visible = false end

        if CurrentAimTarget and getgenv().Aimbot_Enabled and CurrentPredictedPos then
            local pos, onScreen = Camera:WorldToViewportPoint(CurrentPredictedPos)
            if onScreen and pos.Z > 0 then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, CurrentPredictedPos), getgenv().Aimbot_Smoothness) end
        end
    end)
end)

RunService.Stepped:Connect(function()
    pcall(function()
        local char = plr.Character; if not char then return end
        char.Humanoid.WalkSpeed = getgenv().Speed_Enabled and getgenv().WalkSpeed or 16
        if getgenv().Noclip_Enabled or getgenv().Attach_Behind_Under then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)
end)
