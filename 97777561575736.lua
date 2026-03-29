repeat task.wait() until game:IsLoaded()

-- Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- Window
local Window = Rayfield:CreateWindow({
   Name = "🚣 Kayak Racing Hub",
   LoadingTitle = "TURKXSRCIPT Hub",
   LoadingSubtitle = "YT: TURKXSRCIPT",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- Tabs
local MainTab = Window:CreateTab("Main EN",4483362458)
local MainTH = Window:CreateTab("Main TH",4483362458)

local SettingsTab = Window:CreateTab("Settings EN",4483362458)
local SettingsTH = Window:CreateTab("Settings TH",4483362458)

-- Remote
local Reliable = ReplicatedStorage:WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable")

-- Variables
local AutoReliable = false
local AutoWin = false
local AutoRebirth = false

local CurrentStage = 1
local MaxStage = 18
local SpeedWarp = 0.1

local TargetPosition = Vector3.new(119.26,5.63,-18.36)

-- =========================
-- Functions
-- =========================

local function WarpToSign(stage)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local track = Workspace:FindFirstChild("Track")
    if not track then return end

    local stageName = "Stage"..string.format("%02d",stage)
    local stageFolder = track:FindFirstChild(stageName)

    if stageFolder then
        local sign = stageFolder:FindFirstChild("Sign")
        if sign then
            hrp.CFrame = sign.CFrame + Vector3.new(0,3,0)
        end
    end
end

local function WarpToPosition(pos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos)
end

-- =========================
-- UI EN
-- =========================

MainTab:CreateToggle({
   Name = "Auto Reliable",
   CurrentValue = false,
   Callback = function(Value)
      AutoReliable = Value
   end
})

MainTab:CreateToggle({
   Name = "Auto Win",
   CurrentValue = false,
   Callback = function(Value)
      AutoWin = Value
   end
})

MainTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Callback = function(Value)
      AutoRebirth = Value
   end
})

SettingsTab:CreateSlider({
   Name = "Warp Speed",
   Range = {0,1},
   Increment = 0.05,
   CurrentValue = 0.1,
   Callback = function(Value)
      SpeedWarp = Value
   end
})

-- =========================
-- UI TH
-- =========================

MainTH:CreateToggle({
   Name = "ฟาร์ม Reliable อัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
      AutoReliable = Value
   end
})

MainTH:CreateToggle({
   Name = "วินอัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
      AutoWin = Value
   end
})

MainTH:CreateToggle({
   Name = "รีเบิร์ดอัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
      AutoRebirth = Value
   end
})

SettingsTH:CreateSlider({
   Name = "ความเร็ววาร์ป",
   Range = {0,1},
   Increment = 0.05,
   CurrentValue = 0.1,
   Callback = function(Value)
      SpeedWarp = Value
   end
})

-- =========================
-- AUTO RELIABLE LOOP
-- =========================

task.spawn(function()
while true do
task.wait()

if AutoReliable then

for i = 1,12 do

local args = {
buffer.fromstring("\029"),
buffer.fromstring("\254\002\000\006\005Power\001"..string.char(i))
}

pcall(function()
Reliable:FireServer(unpack(args))
end)

end

end

end
end)

-- =========================
-- AUTO REBIRTH LOOP
-- =========================

task.spawn(function()
while true do
task.wait(0.5)

if AutoRebirth then

pcall(function()

local args = {
buffer.fromstring("\002"),
buffer.fromstring("\254\000\000")
}

Reliable:FireServer(unpack(args))

end)

end

end
end)

-- =========================
-- AUTO WIN LOOP
-- =========================

task.spawn(function()

while true do
task.wait(SpeedWarp)

if AutoWin then

pcall(function()

local doorFolder = Workspace:FindFirstChild("WorldMain") and Workspace.WorldMain:FindFirstChild("Door")
local signStatus = doorFolder and doorFolder:FindFirstChild("SignStatus")

if signStatus then

WarpToPosition(TargetPosition)

else

WarpToSign(CurrentStage)

CurrentStage += 1
if CurrentStage > MaxStage then
CurrentStage = 1
end

end

end)

end

end

end)

Rayfield:Notify({
   Title = "TURKXSRCIPT Hub",
   Content = "Script Loaded Successfully",
   Duration = 5
})