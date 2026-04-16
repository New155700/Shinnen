local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/d2950ed16e81d765a8657c180920cc46/raw/12746d9f8836260f1998a453849e87d21c594a5c/HISHINUI"))()
local Win = Library:CreateWindow("🔥 N-SHINNEN ")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local plr = Players.LocalPlayer
local Mouse = plr:GetMouse()

-- [ ลบ GUI ของเดิมถ้ามีอยู่แล้ว เพื่อป้องกันบั๊กทับซ้อน ]
pcall(function()
    local oldFOV = CoreGui:FindFirstChild("N_FOV_GUI")
    if oldFOV then oldFOV:Destroy() end
    local oldPersistent = CoreGui:FindFirstChild("N_Persistent_GUI")
    if oldPersistent then oldPersistent:Destroy() end
end)

-- [ สร้างวงกลม FOV ]
local FOV_Gui = Instance.new("ScreenGui")
FOV_Gui.Name = "N_FOV_GUI"
FOV_Gui.Parent = CoreGui
FOV_Gui.Enabled = false
FOV_Gui.IgnoreGuiInset = true

local FOV_Frame = Instance.new("Frame", FOV_Gui)
FOV_Frame.AnchorPoint = Vector2.new(0.5, 0.5)
FOV_Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOV_Frame.BackgroundTransparency = 1

local FOV_Stroke = Instance.new("UIStroke", FOV_Frame)
FOV_Stroke.Thickness = 2

local FOV_Corner = Instance.new("UICorner", FOV_Frame)
FOV_Corner.CornerRadius = UDim.new(1, 0)

-- [ สร้าง GUI นับจำนวนคนเล่น ]
local Persistent_Gui = Instance.new("ScreenGui", CoreGui)
Persistent_Gui.Name = "N_Persistent_GUI"
Persistent_Gui.IgnoreGuiInset = true

local PlayerCountTxt = Instance.new("TextLabel", Persistent_Gui)
PlayerCountTxt.Size = UDim2.new(0, 200, 0, 30)
PlayerCountTxt.Position = UDim2.new(0.5, -100, 0, 15)
PlayerCountTxt.BackgroundTransparency = 1
PlayerCountTxt.TextStrokeTransparency = 0
PlayerCountTxt.Font = Enum.Font.SourceSansBold
PlayerCountTxt.TextSize = 26

-- [ โฟลเดอร์สำหรับ ESP ]
local ESP_Folder = CoreGui:FindFirstChild("N_ESP_FOLDER") or Instance.new("Folder", CoreGui)
ESP_Folder.Name = "N_ESP_FOLDER"

-- [ ตั้งค่าเส้นสีแดงกลางจอสำหรับ Silent Aim ]
local TargetLine = Drawing.new("Line")
TargetLine.Thickness = 2
TargetLine.Color = Color3.fromRGB(255, 0, 0)
TargetLine.Transparency = 1
TargetLine.Visible = false

-- [ ตัวแปรตั้งค่าต่างๆ ]
getgenv().ESP_Enabled = false
getgenv().Show_Tracer = false
getgenv().WalkSpeed = 16
getgenv().Noclip_Enabled = false 
getgenv().AntiBump_Enabled = false 
getgenv().HITBOX_CUSTOM = false
getgenv().HitboxSize = 20
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
getgenv().WallCheck_Enabled = true 

getgenv().Follow_Enabled = false
getgenv().Orbit_Enabled = false
local Orbit_Angle = 0

local CurrentAimTarget = nil
local CurrentPredictedPos = nil

local Tracers = {}
local PlayerColors = {}

-- [ ฟังก์ชันเพื่อความเสถียร ]
local function SafeToggle(val)
    if type(val) == "boolean" then return val end
    if type(val) == "table" then return val[1] == true end
    return false
end

local function GetRole(p)
    if not p then return "ผู้บริสุทธิ์", Color3.fromRGB(240, 240, 245) end 
    local isM, isS = false, false
    pcall(function()
        local function check(container)
            if not container then return end
            for _, i in pairs(container:GetChildren()) do
                if i:IsA("Tool") then
                    local n = i.Name:lower()
                    if n:find("knife") or n:find("blade") or n:find("murder") then isM = true end
                    if n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") then isS = true end
                end
            end
        end
        check(p.Character); check(p.Backpack)
    end)
    if isM then return "ฆาตกร", Color3.fromRGB(255, 20, 20) end 
    if isS then return "นายอำเภอ", Color3.fromRGB(20, 200, 255) end 
    return "ผู้บริสุทธิ์", Color3.fromRGB(240, 240, 245) 
end

local function GetPredictedPosition(target)
    if not target or not target.Character then return nil end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    local hum = target.Character:FindFirstChild("Humanoid")
    if hrp and hum and hum.Health > 0 then
        local velocity = hrp.Velocity
        local moveDir = hum.MoveDirection
        local pred = velocity * getgenv().Prediction_Factor
        if moveDir.Magnitude > 0 then
            pred = (velocity + (moveDir * 16)) * getgenv().Prediction_Factor
        end
        return hrp.Position + pred + Vector3.new(0, 1.5, 0)
    end
    return nil
end

local function IsVisible(targetChar)
    if not plr.Character or not targetChar then return false end
    local origin = Camera.CFrame.Position
    local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Head")
    if not targetPart then return false end
    
    local direction = targetPart.Position - origin
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {plr.Character, targetChar}
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    
    local result = workspace:Raycast(origin, direction, params)
    return not result
end

local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = getgenv().FOV_Size
    local centerPosition = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local isVis = true
                if getgenv().WallCheck_Enabled then isVis = IsVisible(p.Character) end
                if isVis then
                    local distance = (Vector2.new(pos.X, pos.Y) - centerPosition).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = p
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function GetPlayersList()
    local t = {"[ Auto-Lock Murderer ]", "[ Reset Target ]"} 
    for _, v in pairs(Players:GetPlayers()) do if v ~= plr then table.insert(t, v.Name) end end
    return t
end

local function CleanupESP(p)
    pcall(function()
        local tag = ESP_Folder:FindFirstChild("TAG_" .. p.Name)
        if tag then tag:Destroy() end
        if p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if p.Character:FindFirstChild("N_HL") then p.Character.N_HL:Destroy() end
            local cBox = hrp and hrp:FindFirstChild("N_CustomHitbox")
            if cBox then cBox:Destroy() end
            if hrp and hrp:FindFirstChild("N_Tracer") then hrp.N_Tracer:Destroy() end
        end
        if Tracers[p] then
            Tracers[p]:Remove()
            Tracers[p] = nil
        end
        PlayerColors[p] = nil
    end)
end

-- ==========================================
-- [ ส่วนของเมนู GUI ]
-- ==========================================
local VisualTab = Win:CreateTab("👁️ ESP & Visuals")
local EspSec = VisualTab:CreateSection("ระบบมองทะลุ & หน้าจอ")
EspSec:CreateToggle("เปิด ESP (ชื่อ+ตัวใส)", function(v) getgenv().ESP_Enabled = SafeToggle(v); if not getgenv().ESP_Enabled then for _, p in pairs(Players:GetPlayers()) do CleanupESP(p) end end end)
EspSec:CreateToggle("เปิดเส้นโยงเป้าหมาย (Tracer)", function(v) getgenv().Show_Tracer = SafeToggle(v) end)
EspSec:CreateToggle("แสดงวงกลม FOV (สีรุ้ง)", function(v) getgenv().Show_FOV = SafeToggle(v) end)
EspSec:CreateSlider("ขนาด FOV", 50, 500, 150, function(v) getgenv().FOV_Size = tonumber(v) or 150 end)

local AimTab = Win:CreateTab("🔫 Aim & Target")
local TargetSec = AimTab:CreateSection("🎯 ล็อคเป้าหมาย")
local PlayerDrop = TargetSec:CreateDropdown("รายชื่อผู้เล่น", GetPlayersList(), function(v) 
    if v == "[ Auto-Lock Murderer ]" then getgenv().AutoLock_Murderer = true; getgenv().Orbit_Target = nil
    elseif v == "[ Reset Target ]" then getgenv().AutoLock_Murderer = false; getgenv().Orbit_Target = nil
    else getgenv().AutoLock_Murderer = false; getgenv().Orbit_Target = Players:FindFirstChild(v) end
end)
TargetSec:CreateToggle("🔄 รีเฟรชรายชื่ออัตโนมัติ", function(v) getgenv().AutoRefresh_List = SafeToggle(v) end)

local AimSec = AimTab:CreateSection("ระบบช่วยเล็ง (ทำงานออโต้ใน FOV)")
AimSec:CreateToggle("🎯 Aimbot (กล้องหันตามสมูทๆ)", function(v) getgenv().Aimbot_Enabled = SafeToggle(v) end)
AimSec:CreateSlider("ความสมูทกล้อง (น้อย=เนียนมาก)", 1, 100, 10, function(v) getgenv().Aimbot_Smoothness = (tonumber(v) or 10) / 100 end)
AimSec:CreateToggle("🎯 Magic Bullet (กระสุนดูดเข้าตัว)", function(v) getgenv().SilentAim_Enabled = SafeToggle(v) end)
AimSec:CreateToggle("🚧 เช็คกำแพง (ไม่ล็อคเป้าหลังกำแพง)", function(v) getgenv().WallCheck_Enabled = SafeToggle(v) end) 
AimSec:CreateToggle("🔫 ดึงปืนตกพื้นมาหาตัว", function(v) getgenv().Auto_BringGun = SafeToggle(v) end)

local MoveTab = Win:CreateTab("🏃 Movement & Warp")
local HitboxSec = MoveTab:CreateSection("💥 Hitbox")
HitboxSec:CreateToggle("เปิดใช้งาน Hitbox", function(v) getgenv().HITBOX_CUSTOM = SafeToggle(v) end)
HitboxSec:CreateSlider("ขนาด Hitbox", 5, 100, 20, function(v) getgenv().HitboxSize = tonumber(v) or 20 end)

local MoveSec = MoveTab:CreateSection("ความเร็ว & ทะลุ")
MoveSec:CreateSlider("ความเร็วเดิน", 16, 150, 16, function(v) getgenv().WalkSpeed = tonumber(v) or 16 end)
MoveSec:CreateToggle("กันคนเดินชน (Anti-Bump)", function(v) getgenv().AntiBump_Enabled = SafeToggle(v) end)
MoveSec:CreateToggle("เดินทะลุกำแพง (Noclip)", function(v) getgenv().Noclip_Enabled = SafeToggle(v) end)

-- [ เพิ่มปุ่มวาร์ปและรีเซ็ต ]
local WarpSec = MoveTab:CreateSection("🌀 ระบบวาร์ป (ตามเป้าหมายที่เลือก)")
WarpSec:CreateToggle("Head TP (เกาะบนหัวเป้าหมาย)", function(v) getgenv().Follow_Enabled = SafeToggle(v) end)
WarpSec:CreateToggle("Orbit Mode (หมุนรอบตัวเป้าหมาย)", function(v) getgenv().Orbit_Enabled = SafeToggle(v) end)

WarpSec:CreateButton("⚡ วาร์ปไปหาเป้าหมายทันที", function()
    pcall(function()
        local target = getgenv().Orbit_Target
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                -- วาร์ปไปด้านหลังเป้าหมาย 3 Studs
                plr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end)
end)

WarpSec:CreateButton("💀 รีเซ็ตตัวละคร (ฆ่าตัวตาย)", function()
    pcall(function()
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.Health = 0
        end
    end)
end)

-- ==========================================
-- [ อัปเดตลูปการทำงานต่างๆ ให้เสถียรขึ้น ]
-- ==========================================

-- แก้ปัญหากล้องซูมเข้าออกเวลาชนกำแพง
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if plr then
                plr.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            end
        end)
    end
end)

-- ระบบ Render แบบเฟรมต่อเฟรม (UI/Aimbot/Tracers)
RunService:BindToRenderStep("N_Aimbot_Render", Enum.RenderPriority.Camera.Value + 1, function()
    pcall(function()
        local hue = tick() % 5 / 5
        local rainbowColor = Color3.fromHSV(hue, 1, 1)

        if PlayerCountTxt then PlayerCountTxt.TextColor3 = rainbowColor end

        if FOV_Gui then
            FOV_Gui.Enabled = getgenv().Show_FOV
            FOV_Frame.Size = UDim2.new(0, getgenv().FOV_Size * 2, 0, getgenv().FOV_Size * 2)
            FOV_Stroke.Color = rainbowColor
        end

        CurrentAimTarget = GetClosestPlayerInFOV()
        if CurrentAimTarget then
            CurrentPredictedPos = GetPredictedPosition(CurrentAimTarget)
        else
            CurrentPredictedPos = nil
        end

        if getgenv().SilentAim_Enabled and CurrentAimTarget and CurrentAimTarget.Character and CurrentAimTarget.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(CurrentAimTarget.Character.HumanoidRootPart.Position)
            if onScreen then
                TargetLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                TargetLine.To = Vector2.new(pos.X, pos.Y)
                TargetLine.Visible = true
            else
                TargetLine.Visible = false
            end
        else
            TargetLine.Visible = false
        end

        if getgenv().Aimbot_Enabled and CurrentPredictedPos then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, CurrentPredictedPos), getgenv().Aimbot_Smoothness)
        end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then
                if not Tracers[p] then
                    local line = Drawing.new("Line")
                    line.Thickness = 1.5
                    line.Transparency = 1
                    Tracers[p] = line
                end
                
                local tracer = Tracers[p]
                local char = p.Character

                if getgenv().ESP_Enabled and getgenv().Show_Tracer and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local pos, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                    if onScreen then
                        tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 40)
                        tracer.To = Vector2.new(pos.X, pos.Y)
                        tracer.Color = PlayerColors[p] or Color3.fromRGB(255, 255, 255)
                        tracer.Visible = true
                    else
                        tracer.Visible = false
                    end
                else
                    tracer.Visible = false
                end
            end
        end
    end)
end)

-- ระบบวาด ESP, อัปเดตจำนวนคน และ Hitbox
task.spawn(function()
    while task.wait(0.2) do -- ปรับเป็น 0.2 ลดการทำงานซ้ำซ้อน
        pcall(function()
            if PlayerCountTxt then
                PlayerCountTxt.Text = "ผู้เล่นทั้งหมด: " .. #Players:GetPlayers() .. " คน"
            end

            if getgenv().AutoLock_Murderer then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= plr and GetRole(p) == "ฆาตกร" then getgenv().Orbit_Target = p break end
                end
            end

            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr then
                    local char = p.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local head = char:FindFirstChild("Head")
                        local hum = char:FindFirstChild("Humanoid")
                        local rName, rCol = GetRole(p)
                        PlayerColors[p] = rCol

                        if hrp then
                            if hrp:FindFirstChild("N_Tracer") then hrp.N_Tracer:Destroy() end

                            if getgenv().HITBOX_CUSTOM then
                                local cBox = hrp:FindFirstChild("N_CustomHitbox")
                                if not cBox then
                                    cBox = Instance.new("Part")
                                    cBox.Name = "N_CustomHitbox"; cBox.Shape = Enum.PartType.Block
                                    cBox.Transparency = 0.65; cBox.Material = Enum.Material.ForceField
                                    cBox.CanCollide = false; cBox.Massless = true; cBox.CFrame = hrp.CFrame; cBox.Parent = hrp
                                    local weld = Instance.new("WeldConstraint")
                                    weld.Part0 = cBox; weld.Part1 = hrp; weld.Parent = cBox
                                end
                                cBox.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                                cBox.Color = rCol
                            else
                                local cBox = hrp:FindFirstChild("N_CustomHitbox")
                                if cBox then cBox:Destroy() end
                            end
                        end

                        if getgenv().ESP_Enabled and hum and hum.Health > 0 and hrp and head then
                            local tagName = "TAG_" .. p.Name
                            local tag = ESP_Folder:FindFirstChild(tagName) or Instance.new("BillboardGui", ESP_Folder)
                            tag.Name = tagName; tag.Adornee = head; tag.Size = UDim2.new(0, 200, 0, 50)
                            tag.StudsOffset = Vector3.new(0, 1.5, 0); tag.AlwaysOnTop = true; tag.MaxDistance = math.huge
                            
                            local nameTxt = tag:FindFirstChild("Name") or Instance.new("TextLabel", tag)
                            nameTxt.Name = "Name"; nameTxt.Size = UDim2.new(1, 0, 1, 0)
                            nameTxt.BackgroundTransparency = 1; nameTxt.Text = p.Name .. "\n[" .. rName .. "]"
                            nameTxt.TextColor3 = rCol; nameTxt.Font = Enum.Font.SourceSansBold; nameTxt.TextSize = 14; nameTxt.TextStrokeTransparency = 0.4
                            
                            local hl = char:FindFirstChild("N_HL") or Instance.new("Highlight", char)
                            hl.Name = "N_HL"; hl.FillColor = rCol; hl.OutlineColor = rCol
                            hl.FillTransparency = 0.8; hl.OutlineTransparency = 0.5; hl.Enabled = true
                        else
                            CleanupESP(p)
                        end
                    end
                end
            end
        end)
    end
end)

-- ระบบฟิสิกส์ (ความเร็ว, วาร์ป, ทะลุ)
RunService.Stepped:Connect(function()
    pcall(function()
        local char = plr.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local myRoot = char:FindFirstChild("HumanoidRootPart")

        if hum and hum.WalkSpeed ~= getgenv().WalkSpeed then 
            hum.WalkSpeed = getgenv().WalkSpeed 
        end
        
        if getgenv().Noclip_Enabled then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end

        if getgenv().AntiBump_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character then
                    for _, v in pairs(p.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end
        end

        if getgenv().Follow_Enabled or getgenv().Orbit_Enabled then
            local target = getgenv().Orbit_Target
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and myRoot then
                local tRoot = target.Character.HumanoidRootPart
                myRoot.Velocity = Vector3.new(0,0,0)
                if getgenv().Follow_Enabled then
                    myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 4.5, 0)
                elseif getgenv().Orbit_Enabled then  
                    Orbit_Angle = Orbit_Angle + 10
                    myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(math.cos(math.rad(Orbit_Angle))*5, 0, math.sin(math.rad(Orbit_Angle))*5), tRoot.Position)
                end
            end
        end
    end)
end)

-- ระบบ Magic Bullet (Metatable Hooking) เสถียรขึ้น
task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        local oldIndex = mt.__index
        setreadonly(mt, false)

        mt.__index = newcclosure(function(t, k)
            if getgenv().SilentAim_Enabled and t == Mouse and not checkcaller() then
                if CurrentPredictedPos and CurrentAimTarget and CurrentAimTarget.Character then
                    if k == "Hit" then return CFrame.new(CurrentPredictedPos) end
                    if k == "Target" then return CurrentAimTarget.Character:FindFirstChild("HumanoidRootPart") end
                end
            end
            return oldIndex(t, k)
        end)

        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            if getgenv().SilentAim_Enabled and not checkcaller() and CurrentPredictedPos then
                if method == "Raycast" then
                    args[2] = (CurrentPredictedPos - args[1]).Unit * 10000
                    return oldNamecall(self, unpack(args))
                elseif string.find(method, "FindPartOnRay") then
                    local origin = args[1].Origin
                    args[1] = Ray.new(origin, (CurrentPredictedPos - origin).Unit * 10000)
                    return oldNamecall(self, unpack(args))
                end
            end
            return oldNamecall(self, ...)
        end)

        setreadonly(mt, true)
    end)
end)

-- ระบบดึงปืนอัตโนมัติ
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Auto_BringGun then
            pcall(function()
                local gun = workspace:FindFirstChild("GunDrop")
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if gun and hrp then 
                    if firetouchinterest then
                        firetouchinterest(hrp, gun, 0)
                        firetouchinterest(hrp, gun, 1)
                    else
                        gun.CFrame = hrp.CFrame
                    end
                end
            end)
        end
    end
end)

-- รีเฟรชรายชื่อใน Dropdown
task.spawn(function()
    while task.wait(5) do
        if getgenv().AutoRefresh_List then
            pcall(function() PlayerDrop:Refresh(GetPlayersList(), true) end)
        end
    end
end)

Players.PlayerRemoving:Connect(function(p) CleanupESP(p) end)
