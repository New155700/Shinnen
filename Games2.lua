local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/New155700/ca3ee71cb4c922c5055bca31b4fa9578/raw/145adea59e4bfc4c4273b7e8b6b925d8969cae49/HIUISHINNEN"))()
local Win = Library:CreateWindow("🔥 N-SHINNEN PRO ")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local plr = Players.LocalPlayer
local Mouse = plr:GetMouse()

local FOV_Gui = CoreGui:FindFirstChild("N_FOV_GUI")
if FOV_Gui then FOV_Gui:Destroy() end

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
FOV_Stroke.Color = Color3.fromRGB(255, 255, 255)
FOV_Stroke.Thickness = 2

local FOV_Corner = Instance.new("UICorner")
FOV_Corner.Parent = FOV_Frame
FOV_Corner.CornerRadius = UDim.new(1, 0)

local ESP_Folder = CoreGui:FindFirstChild("N_ESP_FOLDER") or Instance.new("Folder", CoreGui)
ESP_Folder.Name = "N_ESP_FOLDER"

getgenv().Bypass_Enabled = true 
getgenv().ESP_Enabled = false
getgenv().Show_Tracer = false
getgenv().WalkSpeed = 16
getgenv().Phase_Enabled = false
getgenv().Bypass_Collision = true 

getgenv().Fly_Enabled = false
getgenv().Fly_Speed = 50

getgenv().HITBOX_CUSTOM = false
getgenv().HitboxSize = 20
getgenv().Prediction_Factor = 0.165
getgenv().Aimbot_Smoothness = 0.15

getgenv().Aim_Target_Name = "[ Auto-Lock Murderer ]" 
getgenv().Warp_Target_Name = "[ Auto-Lock Murderer ]" 

getgenv().Aimbot_Enabled = false 
getgenv().SilentAim_Enabled = false
getgenv().Show_FOV = false
getgenv().FOV_Size = 150
getgenv().Auto_BringGun = false
getgenv().WallCheck_Enabled = true 

getgenv().Follow_Enabled = false
getgenv().Eel_Enabled = false
getgenv().Orbit_Enabled = false
getgenv().SpinPush_Enabled = false 
getgenv().Saved_Origin_CFrame = nil 
local Orbit_Angle = 0

local mt = getrawmetatable(game)
local oldNewIndex = mt.__newindex
setreadonly(mt, false)
mt.__newindex = newcclosure(function(t, k, v)
    if not checkcaller() and getgenv().Bypass_Enabled then
        if t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
            return
        end
    end
    return oldNewIndex(t, k, v)
end)
setreadonly(mt, true)

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

local function GetPlayersList()
    local t = {"[ Auto-Lock Murderer ]", "[ Reset Target ]"} 
    for _, v in pairs(Players:GetPlayers()) do if v ~= plr then table.insert(t, v.Name) end end
    return t
end

local function GetSpecificTarget(targetName)
    if targetName == "[ Auto-Lock Murderer ]" then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr and GetRole(p) == "ฆาตกร" then return p end
        end
    elseif targetName and targetName ~= "[ Reset Target ]" then
        return Players:FindFirstChild(targetName)
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
    return not workspace:Raycast(origin, direction, params)
end

local function GetAimbotTarget()
    if getgenv().Aim_Target_Name ~= "[ Auto-Lock Murderer ]" and getgenv().Aim_Target_Name ~= "[ Reset Target ]" then
        local explicitTarget = Players:FindFirstChild(getgenv().Aim_Target_Name)
        if explicitTarget and explicitTarget.Character and explicitTarget.Character:FindFirstChild("Humanoid") and explicitTarget.Character.Humanoid.Health > 0 then
            if getgenv().WallCheck_Enabled and not IsVisible(explicitTarget.Character) then return nil end
            return explicitTarget
        end
    end

    local closestPlayer = nil
    local shortestDistance = getgenv().FOV_Size
    local centerPosition = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local myRole = GetRole(plr)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pRole = GetRole(p)
            local isValidTarget = false

            if myRole == "นายอำเภอ" or myRole == "ผู้บริสุทธิ์" then
                if pRole == "ฆาตกร" then isValidTarget = true end
            elseif myRole == "ฆาตกร" then
                local sheriffExists = false
                for _, checkP in pairs(Players:GetPlayers()) do
                    if checkP ~= plr and GetRole(checkP) == "นายอำเภอ" then sheriffExists = true break end
                end
                if sheriffExists then
                    if pRole == "นายอำเภอ" then isValidTarget = true end
                else
                    isValidTarget = true
                end
            end

            if isValidTarget then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    if getgenv().WallCheck_Enabled and not IsVisible(p.Character) then continue end
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

local function CalculatePrediction(target)
    if not target or not target.Character then return nil end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    local hum = target.Character:FindFirstChild("Humanoid")
    if hrp and hum then
        local moveDir = hum.MoveDirection 
        local walkSpd = hum.WalkSpeed
        local fallVel = hrp.Velocity.Y
        local predOffset = (moveDir * walkSpd * getgenv().Prediction_Factor) + Vector3.new(0, fallVel * (getgenv().Prediction_Factor * 0.5), 0)
        return hrp.Position + predOffset + Vector3.new(0, 1.5, 0)
    end
    return nil
end

local function CleanupESP(p)
    pcall(function()
        local tag = ESP_Folder:FindFirstChild("TAG_" .. p.Name)
        if tag then tag:Destroy() end
        if p.Character then
            if p.Character:FindFirstChild("HumanoidRootPart") and p.Character.HumanoidRootPart:FindFirstChild("N_Tracer") then p.Character.HumanoidRootPart.N_Tracer:Destroy() end
            if p.Character:FindFirstChild("N_HL") then p.Character.N_HL:Destroy() end
            if p.Character:FindFirstChild("HumanoidRootPart") and p.Character.HumanoidRootPart:FindFirstChild("N_CustomHitbox") then p.Character.HumanoidRootPart.N_CustomHitbox:Destroy() end
        end
    end)
end

local function FixWeight()
    local char = plr.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if hum then
        hum.PlatformStand = false
        hum.WalkSpeed = getgenv().WalkSpeed
    end
    
    if hrp and not getgenv().Fly_Enabled and not getgenv().SpinPush_Enabled then
        for _, v in pairs(hrp:GetChildren()) do
            if (v:IsA("BodyVelocity") or v:IsA("BodyGyro") or v:IsA("BodyPosition")) and v.Name ~= "FlyVel" and v.Name ~= "FlyGyro" then
                v:Destroy()
            end
        end
    end
end

local function SafeToggle(v) if type(v) == "boolean" then return v elseif type(v) == "table" then return v[1] == true end return false end

local VisualTab = Win:CreateTab("👁️ Visuals")
local EspSec = VisualTab:CreateSection("ระบบมองทะลุ & ESP")
EspSec:CreateToggle("เปิด ESP (ชื่อ+ตัวใส)", function(v) getgenv().ESP_Enabled = SafeToggle(v); if not getgenv().ESP_Enabled then for _, p in pairs(Players:GetPlayers()) do CleanupESP(p) end end end)
EspSec:CreateToggle("เปิดเส้นโยงเป้าหมาย (Tracer)", function(v) getgenv().Show_Tracer = SafeToggle(v) end)

local FovSec = VisualTab:CreateSection("ตั้งค่าเป้าสายตา (FOV RGB)")
FovSec:CreateToggle("แสดงวงกลม FOV (สีรุ้ง)", function(v) getgenv().Show_FOV = SafeToggle(v) end)
FovSec:CreateSlider("ขนาด FOV", 50, 500, 150, function(v) getgenv().FOV_Size = tonumber(v) or 150 end)

local AimTab = Win:CreateTab("🔫 Aim")
local AimTargetSec = AimTab:CreateSection("🎯 เลือกเป้าหมายสำหรับ Aimbot")
local AimDrop = AimTargetSec:CreateDropdown("รายชื่อผู้เล่น (เลือกล็อคหัว)", GetPlayersList(), function(v) getgenv().Aim_Target_Name = v end)

local AimSec = AimTab:CreateSection("ระบบช่วยเล็ง (คาดเดาตาม WASD)")
AimSec:CreateToggle("🎯 Smart Aimbot (กันยิงพวกเดียวกัน)", function(v) getgenv().Aimbot_Enabled = SafeToggle(v) end)
AimSec:CreateSlider("ความสมูทกล้อง (100 = ล็อคแน่นเปรี๊ยะ)", 1, 100, 15, function(v) getgenv().Aimbot_Smoothness = tonumber(v) or 15 end)
AimSec:CreateToggle("🎯 Silent Aim (ยิงโดน 100%)", function(v) getgenv().SilentAim_Enabled = SafeToggle(v) end)
AimSec:CreateToggle("🚧 เช็คกำแพง (Wall Check)", function(v) getgenv().WallCheck_Enabled = SafeToggle(v) end) 
AimSec:CreateToggle("🔫 ดึงปืนตกพื้นมาหาตัว", function(v) getgenv().Auto_BringGun = SafeToggle(v) end)

local HitboxSec = AimTab:CreateSection("💥 Hitbox")
HitboxSec:CreateToggle("ขยายตัวละคร (Hitbox)", function(v) getgenv().HITBOX_CUSTOM = SafeToggle(v) end)
HitboxSec:CreateSlider("ขนาด Hitbox", 5, 100, 20, function(v) getgenv().HitboxSize = tonumber(v) or 20 end)

local MoveTab = Win:CreateTab("🏃 Warp & Move")
local FlySec = MoveTab:CreateSection("🕊️ ระบบบินอิสระ (Smooth Fly)")
local flyVel, flyGyro
FlySec:CreateToggle("เปิดใช้งานบิน", function(v) 
    getgenv().Fly_Enabled = SafeToggle(v) 
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if getgenv().Fly_Enabled then
        flyVel = Instance.new("BodyVelocity")
        flyVel.Name = "FlyVel"
        flyVel.MaxForce = Vector3.new(100000, 100000, 100000)
        flyVel.Velocity = Vector3.new(0, 0, 0)
        flyVel.Parent = hrp

        flyGyro = Instance.new("BodyGyro")
        flyGyro.Name = "FlyGyro"
        flyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        flyGyro.CFrame = hrp.CFrame
        flyGyro.Parent = hrp
    else
        if hrp:FindFirstChild("FlyVel") then hrp.FlyVel:Destroy() end
        if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
        flyVel = nil flyGyro = nil
    end
end)
FlySec:CreateSlider("ความเร็วการบิน", 10, 200, 50, function(v) getgenv().Fly_Speed = tonumber(v) or 50 end)

local WarpTargetSec = MoveTab:CreateSection("เป้าหมายสำหรับการวาร์ปป่วน")
local WarpDrop = WarpTargetSec:CreateDropdown("รายชื่อผู้เล่น (เป้าหมายวาร์ป)", GetPlayersList(), function(v) getgenv().Warp_Target_Name = v end)

local WarpSec = MoveTab:CreateSection("🌀 ระบบวาร์ปเกาะติด")
WarpSec:CreateToggle("เกาะบนหัว (Head TP)", function(v) getgenv().Follow_Enabled = SafeToggle(v) end)
WarpSec:CreateToggle("เต้นปลาไหล (Eel Dance)", function(v) getgenv().Eel_Enabled = SafeToggle(v) end)
WarpSec:CreateToggle("หมุนรอบตัว (Orbit)", function(v) getgenv().Orbit_Enabled = SafeToggle(v) end)
WarpSec:CreateToggle("🌪️ วาร์ปปั่นแนวตั้ง (ดันกระเด็น)", function(v) 
    getgenv().SpinPush_Enabled = SafeToggle(v) 
    local char = plr.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    
    if getgenv().SpinPush_Enabled then
        if myRoot then getgenv().Saved_Origin_CFrame = myRoot.CFrame end
    else
        if myRoot and getgenv().Saved_Origin_CFrame then
            myRoot.CFrame = getgenv().Saved_Origin_CFrame
            myRoot.Velocity = Vector3.new(0,0,0)
            myRoot.RotVelocity = Vector3.new(0,0,0)
        end
    end
end)

local MoveSec = MoveTab:CreateSection("ตั้งค่าตัวละคร & บายพาส")
MoveSec:CreateSlider("ความเร็วเดิน", 16, 150, 16, function(v) getgenv().WalkSpeed = tonumber(v) or 16 end)
MoveSec:CreateToggle("👻 ทะลุแมพและกำแพง (Phase)", function(v) getgenv().Phase_Enabled = SafeToggle(v) end)
MoveSec:CreateToggle("🛡️ กันผู้เล่นอื่นชน (NoCollide Players)", function(v) getgenv().Bypass_Collision = SafeToggle(v) end)

RunService:BindToRenderStep("N_Aimbot", Enum.RenderPriority.Camera.Value + 1, function()
    if FOV_Gui then
        FOV_Gui.Enabled = getgenv().Show_FOV
        FOV_Frame.Size = UDim2.new(0, getgenv().FOV_Size * 2, 0, getgenv().FOV_Size * 2)
        if getgenv().Show_FOV then FOV_Stroke.Color = Color3.fromHSV((tick() % 3) / 3, 1, 1) end
    end

    if getgenv().Aimbot_Enabled then
        local target = GetAimbotTarget()
        if target then
            local predPos = CalculatePrediction(target)
            if predPos then
                local currentCamCFrame = Camera.CFrame
                local targetCamCFrame = CFrame.new(currentCamCFrame.Position, predPos)
                local smoothFactor = getgenv().Aimbot_Smoothness / 100
                if smoothFactor >= 1 then
                    Camera.CFrame = targetCamCFrame
                else
                    Camera.CFrame = currentCamCFrame:Lerp(targetCamCFrame, smoothFactor)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
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

RunService.Stepped:Connect(function()
    pcall(function()
        local char = plr.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local myRoot = char:FindFirstChild("HumanoidRootPart")

        FixWeight()

        if getgenv().Fly_Enabled and flyVel and flyGyro and hum and myRoot then
            local camCFrame = Camera.CFrame
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                local forward = (UIS:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
                local right = (UIS:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.A) and 1 or 0)
                local targetVel = Vector3.new(0,0,0)
                if UIS.TouchEnabled then
                    targetVel = camCFrame:VectorToWorldSpace(Vector3.new(moveDir.X, 0, moveDir.Z * -1))
                else
                    targetVel = (camCFrame.LookVector * forward) + (camCFrame.RightVector * right)
                end
                flyVel.Velocity = targetVel.Unit * getgenv().Fly_Speed
            else
                flyVel.Velocity = Vector3.new(0, 0, 0)
            end
            flyGyro.CFrame = camCFrame
        end
                
        local warpTarget = GetSpecificTarget(getgenv().Warp_Target_Name)
        if warpTarget and warpTarget.Character and warpTarget.Character:FindFirstChild("HumanoidRootPart") and myRoot then
            local tRoot = warpTarget.Character.HumanoidRootPart
            if getgenv().Follow_Enabled then myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 3.5, 0)
            elseif getgenv().Eel_Enabled then myRoot.CFrame = tRoot.CFrame * CFrame.new(0, math.sin(tick() * 10) * 3, 0)
            elseif getgenv().Orbit_Enabled then Orbit_Angle = Orbit_Angle + 0.05; myRoot.CFrame = tRoot.CFrame * CFrame.Angles(0, Orbit_Angle, 0) * CFrame.new(0, 0, 5)
            end
        end

        if getgenv().SpinPush_Enabled and myRoot then
            myRoot.CFrame = myRoot.CFrame * CFrame.Angles(0, math.rad(50), 0)
            myRoot.Velocity = myRoot.CFrame.LookVector * 100
        end

        if getgenv().Phase_Enabled then
            for _, part in ipairs(char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end
        end
        
        if getgenv().Bypass_Collision then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character then
                    for _, part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end
                end
            end
        end

    end)
end)
