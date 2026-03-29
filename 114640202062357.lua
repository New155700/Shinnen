repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local Rep = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

-------------------------------------------------
-- SETTINGS
-------------------------------------------------

local AutoFarm = false
local AutoBuy = false
local AutoRebirth = false
local AutoUpgradePods = false
local AutoCollect = false

local PlayerPlot = nil

-------------------------------------------------
-- HOLD E
-------------------------------------------------

local function HoldE()

for i = 1,3 do
VIM:SendKeyEvent(true,"E",false,game)
task.wait(1)
VIM:SendKeyEvent(false,"E",false,game)
task.wait(0.15)
end

end

-------------------------------------------------
-- FIND PLOT
-------------------------------------------------

local function FindPlot()

for _,plot in pairs(workspace.Plots:GetChildren()) do

local owner = plot:FindFirstChild("OwnerName")

if owner and tostring(owner.Value) == player.Name then
PlayerPlot = plot
return
end

local attr = plot:GetAttribute("OwnerName")

if attr and attr == player.Name then
PlayerPlot = plot
return
end

end

end

-------------------------------------------------
-- TELEPORT ZONE
-------------------------------------------------

local function TeleportZone(num)

local zone = workspace.Zones:FindFirstChild(tostring(num))

if zone then

local part = zone:FindFirstChild("Part")

if part then

local hrp = player.Character:FindFirstChild("HumanoidRootPart")
hrp.CFrame = part.CFrame + Vector3.new(0,5,0)

end

end

end

-------------------------------------------------
-- FIND RARE
-------------------------------------------------

local function FindRare()

local folder = workspace:FindFirstChild("VisualBrainrots")
if not folder then return nil end

for _,model in pairs(folder:GetChildren()) do

local board = model:FindFirstChild("LevelBoard")

if board and board:FindFirstChild("Frame") then

local rarity = board.Frame:FindFirstChild("Rarity")

if rarity then

local text = string.upper(rarity.Text)

if text == "MYTHIC" or text == "SECRET" then
return model
end

end

end

end

return nil

end

-------------------------------------------------
-- AUTO FARM
-------------------------------------------------

task.spawn(function()

while task.wait(1) do

if AutoFarm then

local rare = FindRare()

if rare then

local part = rare:FindFirstChildWhichIsA("BasePart")

if part then

local hrp = player.Character:FindFirstChild("HumanoidRootPart")
hrp.CFrame = part.CFrame + Vector3.new(0,3,0)

HoldE()

end

else

for i = 1,10 do

if not AutoFarm then break end

TeleportZone(i)

task.wait(0.8)

local rareCheck = FindRare()

if rareCheck then
break
end

end

end

end

end

end)

-------------------------------------------------
-- AUTO COLLECT
-------------------------------------------------

task.spawn(function()

while task.wait(0.3) do

if AutoCollect then

if not PlayerPlot then
FindPlot()
end

if PlayerPlot then

local pods = PlayerPlot:FindFirstChild("Pods")

if pods then

local hrp = player.Character.HumanoidRootPart

for _,pod in pairs(pods:GetChildren()) do

local touch = pod:FindFirstChild("TouchPart")

if touch then
firetouchinterest(hrp,touch,0)
firetouchinterest(hrp,touch,1)
end

end

end

end

end

end

end)

-------------------------------------------------
-- AUTO UPGRADE
-------------------------------------------------

task.spawn(function()

while task.wait(0.5) do

if AutoUpgradePods then

if not PlayerPlot then
FindPlot()
end

if PlayerPlot then

local pods = PlayerPlot:FindFirstChild("Pods")

if pods then

for _,pod in pairs(pods:GetChildren()) do
Rep.Remotes.UpgradeBrainrot:FireServer(pod)
end

end

end

end

end

end)

-------------------------------------------------
-- AUTO BUY
-------------------------------------------------

task.spawn(function()

while task.wait(0.4) do

if AutoBuy then

Rep.Remotes.UpgradeStats:FireServer("Power",1)
Rep.Remotes.UpgradeStats:FireServer("Reach_Distance",1)
Rep.Remotes.UpgradeStats:FireServer("GrabAmount",1)

end

end

end)

-------------------------------------------------
-- AUTO REBIRTH
-------------------------------------------------

task.spawn(function()

while task.wait(1) do

if AutoRebirth then
Rep.Remotes.Rebirth:FireServer()
end

end

end)

-------------------------------------------------
-- UI
-------------------------------------------------

local Window = Rayfield:CreateWindow({
Name = "TURKXSCRIPT HUB",
LoadingTitle = "Brainrot Script",
LoadingSubtitle = "Complete Version"
})

local MainTab = Window:CreateTab("Main",4483362458)

-------------------------------------------------
-- MAIN MENU
-------------------------------------------------

MainTab:CreateToggle({
Name = "Auto Farm MYTHIC / SECRET",
CurrentValue = false,
Callback = function(v)

AutoFarm = v

if not v then
local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if hum then
hum.Health = 0
end
end

end
})

MainTab:CreateToggle({
Name = "Auto Collect Money",
CurrentValue = false,
Callback = function(v)
AutoCollect = v
end
})

MainTab:CreateToggle({
Name = "Auto Upgrade Pods",
CurrentValue = false,
Callback = function(v)
AutoUpgradePods = v
end
})

MainTab:CreateToggle({
Name = "Auto Buy All",
CurrentValue = false,
Callback = function(v)
AutoBuy = v
end
})

MainTab:CreateToggle({
Name = "Auto Rebirth",
CurrentValue = false,
Callback = function(v)
AutoRebirth = v
end
})