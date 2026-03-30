-- [[ SHINNEN HUB | V1 ULTIMATE EDITION ]] --
-- รวม Speed, Auto E, ESP (Name/Health), Teleport Player, และ Graphics --

-- 1. ลบ UI เก่า
pcall(function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "Rayfield" or v.Name == "ShinnenInfo" then v:Destroy() end
    end
end)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Win = Rayfield:CreateWindow({
    Name = "Shinnen Hub | V1 MASTER",
    LoadingTitle = "👿 System Booting...",
    LoadingSubtitle = "by Shinnen Custom👿",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false 
})

-- 2. ตั้งค่าตัวแปร (Global)
local plr = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

getgenv().Speed = 50
getgenv().AutoE = false
getgenv().EspEnabled = false
getgenv().SelectedPlayer = nil

-- [[ ฟังก์ชันเสริม ]] --

-- ระบบ ESP (ชื่อ + เลือด)
local function CreateESP(p)
    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = Color3.new(1, 1, 1)
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Outline = true

    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if getgenv().EspEnabled and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local hum = p.Character.Humanoid
            local hrp = p.Character.HumanoidRootPart
            local pos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                nameTag.Position = Vector2.new(pos.X, pos.Y - 40)
                nameTag.Text = string.format("%s\n[HP: %.0f/%.0f]", p.Name, hum.Health, hum.MaxHealth)
                -- เปลี่ยนสีตามเลือด
                nameTag.Color = hum.Health < 30 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1)
                nameTag.Visible = true
            else
                nameTag.Visible = false
            end
        else
            nameTag.Visible = false
            if not p.Parent or not game.CoreGui:FindFirstChild("Rayfield") then
                nameTag:Destroy()
                connection:Disconnect()
            end
        end
    end)
end

-- สแกนผู้เล่นในเซิร์ฟเพื่อทำ ESP
for _, v in ipairs(game.Players:GetPlayers()) do if v ~= plr then CreateESP(v) end end
game.Players.PlayerAdded:Connect(function(v) if v ~= plr then CreateESP(v) end end)

-- [[ LOOPS ]] --

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

-- Prompt Instant (Hold 0 วินาที)
task.spawn(function()
    while task.wait(0.5) do
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
        end
    end
end)

-- กด E อัตโนมัติ
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoE then
            VIM:SendKeyEvent(true, "E", false, game)
            VIM:SendKeyEvent(false, "E", false, game)
        end
    end
end)

-- [[ UI TABS ]] --
local TabMain = Win:CreateTab("Main & Movement", 4483362458)
local TabVisual = Win:CreateTab("Visual & ESP", 4483362458)
local TabTeleport = Win:CreateTab("Teleport Player", 4483362458)

-- MAIN TAB
TabMain:CreateInput({
    Name = "⚡ ปรับความเร็ว (Speed)",
    PlaceholderText = "50",
    Callback = function(v)
        local n = tonumber(v)
        if n then getgenv().Speed = n end
    end
})

TabMain:CreateToggle({
    Name = "⌨️ เปิด/ปิด Auto E รัว",
    CurrentValue = false,
    Callback = function(v) getgenv().AutoE = v end
})

-- VISUAL TAB
TabVisual:CreateToggle({
    Name = "👁️ เปิดระบบมอง (ESP Name/Health)",
    CurrentValue = false,
    Callback = function(v) getgenv().EspEnabled = v end
})

TabVisual:CreateSection("Graphics")
TabVisual:CreateButton({
    Name = "✨ เปิดภาพสวย (Full Bright/Shadows)",
    Callback = function()
        local L = game:GetService("Lighting")
        L.Brightness = 2.5
        L.GlobalShadows = true
        L.ClockTime = 14
    end
})

TabVisual:CreateSlider({
    Name = "🚀 ปลดล็อก FPS",
    Range = {60, 360},
    Increment = 10,
    CurrentValue = 60,
    Callback = function(v) setfpscap(v) end
})

-- TELEPORT TAB
TabTeleport:CreateInput({
    Name = "🔍 ค้นหาชื่อผู้เล่น (พิมพ์ชื่อ)",
    PlaceholderText = "พิมพ์ชื่อที่นี่...",
    Callback = function(v)
        for _, p in pairs(game.Players:GetPlayers()) do
            if string.find(p.Name:lower(), v:lower()) or string.find(p.DisplayName:lower(), v:lower()) then
                getgenv().SelectedPlayer = p.Name
                Rayfield:Notify({Title = "พบผู้เล่น!", Content = "เลือก: " .. p.Name, Duration = 3})
                break
            end
        end
    end
})

TabTeleport:CreateButton({
    Name = "📍 วาร์ปไปหาผู้เล่นที่เลือก",
    Callback = function()
        if getgenv().SelectedPlayer then
            local target = game.Players:FindFirstChild(getgenv().SelectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            else
                Rayfield:Notify({Title = "Error", Content = "ไม่พบตัวละครของผู้เล่น", Duration = 3})
            end
        else
            Rayfield:Notify({Title = "Error", Content = "กรุณาค้นหาชื่อผู้เล่นก่อน", Duration = 3})
        end
    end
})

Rayfield:Notify({Title = "V41 READY", Content = "ระบบทั้งหมดพร้อมใช้งานแล้ว!", Duration = 5})
