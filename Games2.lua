local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/ca3ee71cb4c922c5055bca31b4fa9578/raw/145adea59e4bfc4c4273b7e8b6b925d8969cae49/HIUISHINNEN"))()
local Win = Library:CreateWindow("🔥 N-SHINNEN ")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local plr = Players.LocalPlayer
local Mouse = plr:GetMouse()

-- [ ลบ GUI ของเดิมถ้ามีอยู่แล้ว ]
local FOV_Gui = CoreGui:FindFirstChild("N_FOV_GUI")
if FOV_Gui then FOV_Gui:Destroy() end

local Persistent_Gui = CoreGui:FindFirstChild("N_Persistent_GUI")
if Persistent_Gui then Persistent_Gui:Destroy() end

-- [ สร้างวงกลม FOV ]
FOV_Gui = Instance.new("ScreenGui")
FOV_Gui.Name = "N_FOV_GUI"
FOV_Gui.Parent = CoreGui
FOV_Gui.Enabled = false
FOV_Gui.IgnoreGuiInset = true

local FOV_Frame = Instance.new("Frame")
FOV_Frame.Parent = FOV_Gui
FOV_Frame.AnchorPoint = Vector2.new(0.5, 0.5)
FOV_Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOV_Frame.BackgroundTransparency = 1

local FOV_Stroke = Instance.new("UIStroke")
FOV_Stroke.Parent = FOV_Frame
FOV_Stroke.Thickness = 2

local FOV_Corner = Instance.new("UICorner")
FOV_Corner.Parent = FOV_Frame
FOV_Corner.CornerRadius = UDim.new(1, 0)

-- [ สร้าง GUI นับจำนวนคนเล่น (ด้านบนกลาง) - ปรับขนาดใหญ่ขึ้น ]
Persistent_Gui = Instance.new("ScreenGui", CoreGui)
Persistent_Gui.Name = "N_Persistent_GUI"
Persistent_Gui.IgnoreGuiInset = true

local PlayerCountTxt = Instance.new("TextLabel", Persistent_Gui)
PlayerCountTxt.Size = UDim2.new(0, 200, 0, 30)
PlayerCountTxt.Position = UDim2.new(0.5, -100, 0, 15) -- ตรงกลางด้านบน
PlayerCountTxt.BackgroundTransparency = 1
PlayerCountTxt.TextStrokeTransparency = 0 -- ขอบดำให้มองง่าย
PlayerCountTxt.Font = Enum.Font.SourceSansBold
PlayerCountTxt.TextSize = 26 -- ขยายขนาดใหญ่ขึ้น

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

-- ตารางเก็บเส้น Tracer และสีของแต่ละคน
local Tracers = {}
local PlayerColors = {}

-- [ ฟังก์ชันเช็คบทบาท ]
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

-- [ ฟังก์ชันคำนวณการเคลื่อนที่ล่วงหน้า ]
local function GetPredictedPosition(target)
    if not target or not target.Character then return nil end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    local hum = target.Character:FindFirstChild("Humanoid")
    if hrp and hum then
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

-- [ ฟังก์ชันเช็คกำแพง ]
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

-- [ ฟังก์ชันหาคนที่ใกล้เป้าที่สุดใน FOV ]
local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = getgenv().FOV_Size
    local centerPosition = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local isVis = true
                if getgenv().WallCheck_Enabled then
                    isVis = IsVisible(p.Character)
                end
                
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
            -- ลบ 3D Tracer เก่าที่อาจจะค้างอยู่
            if hrp and hrp:FindFirstChild("N_Tracer") then hrp.N_Tracer:Destroy() end
        end
        -- ลบเส้น 2D Tracer ออก
        if Tracers[p] then
            Tracers[p]:Remove()
            Tracers[p] = nil
        end
        PlayerColors[p] = nil
    end)
end

local function SafeToggle(val)
    if type(val) == "boolean" then return val end
    if type(val) == "table" then return val[1] == true end
    return false
end

-- [ ส่วนของเมนู GUI ]
local VisualTab = Win:CreateTab("👁️ ESP & Visuals")
local EspSec = VisualTab:CreateSection("ระบบมองทะลุ & หน้าจอ")
EspSec:CreateToggle("เปิด ESP (ชื่อ+ตัวใส)", function(v) getgenv().ESP_Enabled = SafeToggle(v); if not getgenv().ESP_Enabled then for _, p in pairs(Players:GetPlayers()) do CleanupESP(p) end end end)
EspSec:CreateToggle("เปิดเส้นโยงเป้าหมาย (Tracer)", function(v) getgenv().Show_Tracer = SafeToggle(v) end)
EspSec:CreateToggle("แสดงวงกลม FOV (สีรุ้ง)", function(v) getgenv().Show_FOV = SafeToggle(v) end)
EspSec:CreateSlider("ขนาด FOV", 50, 500, 150, function(v) getgenv().FOV_Size = tonumber(v) or 150 end)

local AimTab = Win:CreateTab("🔫 Aim & Target")
local TargetSec = AimTab:CreateSection("🎯 ล็อคเป้าหมาย (สำหรับวาร์ป/เส้นโยง)")
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

local WarpSec = MoveTab:CreateSection("🌀 ระบบวาร์ป (ตามเป้าหมายที่เลือก)")
WarpSec:CreateToggle("Head TP (เกาะบนหัว)", function(v) getgenv().Follow_Enabled = SafeToggle(v) end)
WarpSec:CreateToggle("Orbit Mode (หมุนรอบตัว)", function(v) getgenv().Orbit_Enabled = SafeToggle(v) end)

-- [ แก้ปัญหากล้องซูมเข้าออกเวลาชนกำแพง/เข้าห้องเล็ก ]
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if plr then
                -- บังคับให้กำแพงโปร่งใสแทนการดึงกล้องซูมเข้าตัว
                plr.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            end
        end)
    end
end)

-- [ ระบบอัปเดตแบบทุกเฟรม (Aimbot & FOV & สีรุ้ง PlayerCount & เส้น Tracer) ]
RunService:BindToRenderStep("N_Aimbot", Enum.RenderPriority.Camera.Value + 1, function()
    -- ทำข้อความจำนวนคนให้เป็นสีรุ้ง RGB ตลอดเวลา
    if PlayerCountTxt then
        PlayerCountTxt.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end

    if FOV_Gui then
        FOV_Gui.Enabled = getgenv().Show_FOV
        FOV_Frame.Size = UDim2.new(0, getgenv().FOV_Size * 2, 0, getgenv().FOV_Size * 2)
        -- อัปเดตสี FOV สีรุ้งตลอดเวลา
        FOV_Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end

    CurrentAimTarget = GetClosestPlayerInFOV()
    if CurrentAimTarget then
        CurrentPredictedPos = GetPredictedPosition(CurrentAimTarget)
    else
        CurrentPredictedPos = nil
    end

    -- วาดเส้นสีแดงชี้เป้า (Aimbot Line) กลางจอ
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

    -- [ ระบบวาดเส้น Tracer ให้ออกมาจากข้อความจำนวนคนด้านบนกลางจอ ]
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr then
            -- สร้างเส้นถ้ายังไม่มี
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
                    -- โยงจากจุดกึ่งกลางด้านบนจอ (X ครึ่งจอ, Y ประมาณ 40px ลงมาจากบนสุดตรงกับตำแหน่งข้อความ)
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

-- [ ระบบวาด ESP, อัปเดตจำนวนคน และ Hitbox ]
task.spawn(function()
    while task.wait(0.1) do
        -- อัปเดตจำนวนคนเล่น
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
                pcall(function()
                    local char = p.Character
                    if not char then return end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local head = char:FindFirstChild("Head")
                    local hum = char:FindFirstChild("Humanoid")
                    local rName, rCol = GetRole(p)
                    
                    -- บันทึกสีของผู้เล่นไว้ใช้กับ Tracer
                    PlayerColors[p] = rCol

                    if hrp then
                        -- ลบ 3D Beam ของเก่าที่ติดตัวผู้เล่นทิ้งให้เกลี้ยง
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
                end)
            end
        end
    end
end)

-- [ ระบบความเร็วและวาร์ป & ฟิสิกส์การทะลุ ]
RunService.Stepped:Connect(function()
    pcall(function()
        local char = plr.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local myRoot = char:FindFirstChild("HumanoidRootPart")

        -- ปรับความเร็ว
        if hum and hum.WalkSpeed ~= getgenv().WalkSpeed then 
            hum.WalkSpeed = getgenv().WalkSpeed 
        end
        
        -- เดินทะลุกำแพง (Noclip: ปิดการชนทุกชิ้นส่วน)
        if getgenv().Noclip_Enabled then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end

        -- กันคนเดินชน (Anti-Bump)
        if getgenv().AntiBump_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character then
                    for _, v in pairs(p.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end
        end

        -- โหมดวาร์ปติดตาม
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

-- [ ระบบ Magic Bullet / ยิงตรงไหนก็โดน ]
task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        local oldIndex = mt.__index
        setreadonly(mt, false)

        -- Hook เปลี่ยนจุดตกกระทบของเมาส์
        mt.__index = newcclosure(function(t, k)
            if getgenv().SilentAim_Enabled and t == Mouse and (k == "Hit" or k == "Target") then
                if CurrentPredictedPos and CurrentAimTarget and CurrentAimTarget.Character then
                    if k == "Hit" then return CFrame.new(CurrentPredictedPos) end
                    if k == "Target" then return CurrentAimTarget.Character:FindFirstChild("HumanoidRootPart") end
                end
            end
            return oldIndex(t, k)
        end)

        -- Hook หักเลี้ยววิถีกระสุน
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

-- [ ระบบดึงปืนอัตโนมัติ ]
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

-- [ รีเฟรชรายชื่อใน Dropdown ]
task.spawn(function()
    while task.wait(5) do
        if getgenv().AutoRefresh_List then
            pcall(function() PlayerDrop:Refresh(GetPlayersList(), true) end)
        end
    end
end)

-- [ ทำความสะอาด ESP เมื่อมีคนออกเกม ]
Players.PlayerRemoving:Connect(function(p) CleanupESP(p) end)
