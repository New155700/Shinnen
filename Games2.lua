-- [[ N-SHINNEN V50 : PERFECT CENTER FOV & PURE SILENT AIM ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Success, Library = pcall(function()
    return loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/ca3ee71cb4c922c5055bca31b4fa9578/raw/145adea59e4bfc4c4273b7e8b6b925d8969cae49/HIUISHINNEN"))()
end)

if not Success or not Library then return end

local Win = Library:CreateWindow("🔥 N-SHINNEN : PRO MAX")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local Mouse = plr:GetMouse()

-- [ 🟢 FOV GUI (ตรงกลางจอเป๊ะๆ 100%) ]
local FOV_Gui = CoreGui:FindFirstChild("N_FOV_GUI")
if FOV_Gui then FOV_Gui:Destroy() end

FOV_Gui = Instance.new("ScreenGui")
FOV_Gui.Name = "N_FOV_GUI"
FOV_Gui.Parent = CoreGui
FOV_Gui.Enabled = false
FOV_Gui.IgnoreGuiInset = true -- บังคับเมินขอบจอด้านบน

local FOV_Frame = Instance.new("Frame")
FOV_Frame.Parent = FOV_Gui
FOV_Frame.AnchorPoint = Vector2.new(0.5, 0.5)
FOV_Frame.Position = UDim2.new(0.5, 0, 0.5, 0) -- จุดกึ่งกลางเป๊ะ
FOV_Frame.BackgroundTransparency = 1

local FOV_Stroke = Instance.new("UIStroke")
FOV_Stroke.Parent = FOV_Frame
FOV_Stroke.Color = Color3.fromRGB(0, 255, 255)
FOV_Stroke.Thickness = 2

local FOV_Corner = Instance.new("UICorner")
FOV_Corner.Parent = FOV_Frame
FOV_Corner.CornerRadius = UDim.new(1, 0)

local ESP_Folder = CoreGui:FindFirstChild("N_ESP_FOLDER") or Instance.new("Folder", CoreGui)
ESP_Folder.Name = "N_ESP_FOLDER"

-- [ 🟡 Global Variables ]
getgenv().ESP_Enabled = false
getgenv().Show_Tracer = false
getgenv().WalkSpeed = 16
getgenv().Phase_Enabled = false
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

getgenv().Follow_Enabled = false
getgenv().Eel_Enabled = false
getgenv().Orbit_Enabled = false
local Orbit_Angle = 0

-- [ 🔵 Helper Functions ]
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

local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = getgenv().FOV_Size
    -- จุดศูนย์กลางการสแกนตรงกลางหน้าจอเป๊ะ 100%
    local centerPosition = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - centerPosition).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = p
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
            if hrp and hrp:FindFirstChild("N_Tracer") then hrp.N_Tracer:Destroy() end
            if p.Character:FindFirstChild("N_HL") then p.Character.N_HL:Destroy() end
            local cBox = hrp and hrp:FindFirstChild("N_CustomHitbox")
            if cBox then cBox:Destroy() end
        end
    end)
end

local function SafeToggle(val)
    if type(val) == "boolean" then return val end
    if type(val) == "table" then return val[1] == true end
    return false
end

---------------------------------------------------------
-- [ 🎨 UI Setup ]
---------------------------------------------------------
local VisualTab = Win:CreateTab("👁️ ESP & Visuals")
local EspSec = VisualTab:CreateSection("ระบบมองทะลุ & หน้าจอ")
EspSec:CreateToggle("เปิด ESP (ชื่อ+ตัวใส)", function(v) getgenv().ESP_Enabled = SafeToggle(v); if not getgenv().ESP_Enabled then for _, p in pairs(Players:GetPlayers()) do CleanupESP(p) end end end)
EspSec:CreateToggle("เปิดเส้นโยงเป้าหมาย (Tracer)", function(v) getgenv().Show_Tracer = SafeToggle(v) end)
EspSec:CreateToggle("แสดงวงกลม FOV", function(v) getgenv().Show_FOV = SafeToggle(v) end)
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
AimSec:CreateToggle("🎯 Silent Aim (ยิงใน FOV โดน 100%)", function(v) getgenv().SilentAim_Enabled = SafeToggle(v) end)
AimSec:CreateToggle("🔫 ดึงปืนตกพื้นมาหาตัว", function(v) getgenv().Auto_BringGun = SafeToggle(v) end)

local MoveTab = Win:CreateTab("🏃 Movement & Warp")
local HitboxSec = MoveTab:CreateSection("💥 Hitbox")
HitboxSec:CreateToggle("เปิดใช้งาน Hitbox", function(v) getgenv().HITBOX_CUSTOM = SafeToggle(v) end)
HitboxSec:CreateSlider("ขนาด Hitbox", 5, 100, 20, function(v) getgenv().HitboxSize = tonumber(v) or 20 end)

local MoveSec = MoveTab:CreateSection("ความเร็ว & ทะลุ")
MoveSec:CreateSlider("ความเร็วเดิน", 16, 150, 16, function(v) getgenv().WalkSpeed = tonumber(v) or 16 end)
MoveSec:CreateToggle("เดินทะลุคน (Phase)", function(v) getgenv().Phase_Enabled = SafeToggle(v) end)

local WarpSec = MoveTab:CreateSection("🌀 ระบบวาร์ป (ตามเป้าหมายที่เลือก)")
WarpSec:CreateToggle("Head TP (เกาะบนหัว)", function(v) getgenv().Follow_Enabled = SafeToggle(v) end)
WarpSec:CreateToggle("Eel Dance (ปลาไหล)", function(v) getgenv().Eel_Enabled = SafeToggle(v) end)
WarpSec:CreateToggle("Orbit Mode (หมุนรอบตัว)", function(v) getgenv().Orbit_Enabled = SafeToggle(v) end)

---------------------------------------------------------
-- [ 🚀 ENGINE: PURE SILENT AIM & PHYSICS FIX ]
---------------------------------------------------------

-- 🔴 Thread 1: FOV UI & Smooth Aimbot (กล้อง)
RunService:BindToRenderStep("N_Aimbot", Enum.RenderPriority.Camera.Value + 1, function()
    if FOV_Gui then
        FOV_Gui.Enabled = getgenv().Show_FOV
        FOV_Frame.Size = UDim2.new(0, getgenv().FOV_Size * 2, 0, getgenv().FOV_Size * 2)
    end

    if getgenv().Aimbot_Enabled then
        local target = GetClosestPlayerInFOV()
        if target then
            local predPos = GetPredictedPosition(target)
            if predPos then
                local currentCamCFrame = Camera.CFrame
                local targetCamCFrame = CFrame.new(currentCamCFrame.Position, predPos)
                Camera.CFrame = currentCamCFrame:Lerp(targetCamCFrame, getgenv().Aimbot_Smoothness)
            end
        end
    end
end)

-- 🔴 Thread 2: ESP, Hitbox, Tracer
task.spawn(function()
    while task.wait(0.1) do
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

                    if hrp then
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

                        if getgenv().Show_Tracer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local myHrp = plr.Character.HumanoidRootPart
                            local myAtt = myHrp:FindFirstChild("N_MyAtt") or Instance.new("Attachment", myHrp)
                            myAtt.Name = "N_MyAtt"; myAtt.Position = Vector3.new(0, -3, 0)
                            local theirAtt = hrp:FindFirstChild("N_TheirAtt") or Instance.new("Attachment", hrp)
                            theirAtt.Name = "N_TheirAtt"; theirAtt.Position = Vector3.new(0, 0, 0)

                            local beam = hrp:FindFirstChild("N_Tracer") or Instance.new("Beam", hrp)
                            beam.Name = "N_Tracer"; beam.Attachment0 = myAtt; beam.Attachment1 = theirAtt
                            beam.FaceCamera = true; beam.Width0 = 0.05; beam.Width1 = 0.05
                            beam.Color = ColorSequence.new(rCol); beam.Transparency = NumberSequence.new(0.3)
                            beam.ZOffset = 5; beam.Enabled = true
                        else
                            if hrp:FindFirstChild("N_Tracer") then hrp.N_Tracer:Destroy() end
                        end
                    else
                        CleanupESP(p)
                    end
                end)
            end
        end
    end
end)

-- 🔴 Thread 3: Movement & Warp
RunService.Stepped:Connect(function()
    pcall(function()
        local char = plr.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local myRoot = char:FindFirstChild("HumanoidRootPart")

        if hum and hum.WalkSpeed ~= getgenv().WalkSpeed then 
            hum.WalkSpeed = getgenv().WalkSpeed 
        end
        
        if getgenv().Phase_Enabled then
            for _, v in pairs(char:GetChildren()) do 
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then 
                    v.CanCollide = false 
                end 
            end
        end

        if getgenv().Follow_Enabled or getgenv().Eel_Enabled or getgenv().Orbit_Enabled then
            local target = getgenv().Orbit_Target
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and myRoot then
                local tRoot = target.Character.HumanoidRootPart
                
                myRoot.Velocity = Vector3.new(0,0,0)
                if getgenv().Follow_Enabled then
                    myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 4.5, 0)
                elseif getgenv().Eel_Enabled then  
                    myRoot.CFrame = tRoot.CFrame * CFrame.new(math.sin(tick()*25)*2, 0, 3) * CFrame.Angles(0, math.rad(180), 0)
                elseif getgenv().Orbit_Enabled then  
                    Orbit_Angle = Orbit_Angle + 10
                    myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(math.cos(math.rad(Orbit_Angle))*5, 0, math.sin(math.rad(Orbit_Angle))*5), tRoot.Position)
                end
            end
        end
    end)
end)

-- 🔴 Thread 4: PURE SILENT AIM (อิสระ 100% กระสุนเลี้ยวเข้าหัวเอง)
task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(t, k)
            if getgenv().SilentAim_Enabled and t == Mouse and (k == "Hit" or k == "Target") then
                local target = GetClosestPlayerInFOV()
                if target and target.Character then
                    local predPos = GetPredictedPosition(target)
                    if predPos then
                        -- [ ✅ เอาการหันกล้องออกทั้งหมด กระสุนจะวิ่งเข้าจุดตกกระทบโดยตรง ]
                        if k == "Hit" then return CFrame.new(predPos) end
                        if k == "Target" then return target.Character.HumanoidRootPart end
                    end
                end
            end
            return oldIndex(t, k)
        end)
        setreadonly(mt, true)
    end)
end)

-- 🔴 Thread 5: Item & Refresh List
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

task.spawn(function()
    while task.wait(5) do
        if getgenv().AutoRefresh_List then
            pcall(function() PlayerDrop:Refresh(GetPlayersList(), true) end)
        end
    end
end)

Players.PlayerRemoving:Connect(function(p) CleanupESP(p) end)
