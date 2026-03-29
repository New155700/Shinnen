repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Rep = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-------------------------------------------------
-- SETTINGS
-------------------------------------------------

local AutoFarm = false
local AutoPlace = false
local AutoCollect = false
local AutoUpgradeBase = false
local AutoUpgradeItem = false
local AutoCarry = false
local AutoSpeed = false
local AutoSell = false

local TargetItem = "Pain"

-------------------------------------------------
-- TELEPORT
-------------------------------------------------

local function TP(cf)

local char = player.Character
if not char then return end

local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return end

hrp.CFrame = cf

end

-------------------------------------------------
-- RETURN PLOT
-------------------------------------------------

local function ReturnPlot()

local plot = workspace:FindFirstChild("Plot_"..player.Name)
if not plot then return end

local part = plot:FindFirstChildWhichIsA("BasePart")

if part then
TP(part.CFrame + Vector3.new(0,5,0))
end

end

-------------------------------------------------
-- FIND NORMAL FARM ITEM
-------------------------------------------------

local function FindItem()

local folder = workspace:FindFirstChild("ItemSpawns")
if not folder then return end

for _,z in ipairs({8,7,6}) do

for _,zone in pairs(folder:GetChildren()) do

if zone.Name == tostring(z) then

local spawned = zone:FindFirstChild("SpawnedItem")

if spawned then

local handle = spawned:FindFirstChild("Handle")

if handle then
return handle
end

end

end

end

end

end

-------------------------------------------------
-- FIND ITEM BY NAME
-------------------------------------------------

local function FindItemByName(name)

local spawns = workspace:FindFirstChild("ItemSpawns")
if not spawns then return end

for _,zone in pairs(spawns:GetChildren()) do

local item = zone:FindFirstChild("SpawnedItem")

if item then

local handle = item:FindFirstChild("Handle")

if handle then

local prompt = handle:FindFirstChildOfClass("ProximityPrompt")

if prompt and prompt.ObjectText == name then
return handle
end

end

end

end

end

-------------------------------------------------
-- FARM SELECTED ITEM ONCE
-------------------------------------------------

local function FarmItemOnce(name)

task.spawn(function()

while true do

local handle = FindItemByName(name)

if handle then

TP(handle.CFrame + Vector3.new(0,3,0))

task.wait(0.2)

VirtualInputManager:SendKeyEvent(true,"E",false,game)
task.wait(0.1)
VirtualInputManager:SendKeyEvent(false,"E",false,game)

task.wait(0.5)

ReturnPlot()

break

end

task.wait(1)

end

end)

end

-------------------------------------------------
-- GET TOOL
-------------------------------------------------

local function GetTool()

for _,v in pairs(player.Backpack:GetChildren()) do
if v:IsA("Tool") then
return v
end
end

if player.Character then
for _,v in pairs(player.Character:GetChildren()) do
if v:IsA("Tool") then
return v
end
end
end

end

-------------------------------------------------
-- GET EMPTY SLOT
-------------------------------------------------

local function GetEmptySlot()

local plot = workspace:FindFirstChild("Plot_"..player.Name)
if not plot then return end

for f = 1,4 do

local floor = plot:FindFirstChild("Floor"..f)

if floor then

local slots = floor:FindFirstChild("Slots")

if slots then

for s = 1,10 do

local slot = slots:FindFirstChild("Slot"..s)

if slot then

local spawn = slot:FindFirstChild("Spawn")

if spawn and not spawn:FindFirstChild("VisualItem") then
return spawn
end

end

end

end

end

end

end

-------------------------------------------------
-- AUTO COLLECT
-------------------------------------------------

local function CollectAll()

local plot = workspace:FindFirstChild("Plot_"..player.Name)
if not plot then return end

local char = player.Character
if not char then return end

local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return end

for f = 1,4 do

local floor = plot:FindFirstChild("Floor"..f)

if floor then

local slots = floor:FindFirstChild("Slots")

if slots then

for s = 1,10 do

local slot = slots:FindFirstChild("Slot"..s)

if slot then

local touch = slot:FindFirstChild("CollectTouch")

if touch and touch:IsA("BasePart") then
firetouchinterest(hrp,touch,0)
firetouchinterest(hrp,touch,1)
end

end

end

end

end

end

end

-------------------------------------------------
-- AUTO UPGRADE ITEMS
-------------------------------------------------

local function UpgradeItems()

local event = Rep:WaitForChild("Events"):WaitForChild("RequestSlotUpgrade")

for f = 1,4 do
for s = 1,10 do
event:FireServer("Floor"..f,"Slot"..s)
end
end

end

-------------------------------------------------
-- MAIN LOOP
-------------------------------------------------

task.spawn(function()

while task.wait(0.15) do

-------------------------------------------------
-- AUTO FARM
-------------------------------------------------

if AutoFarm then

local handle = FindItem()

if handle then

TP(handle.CFrame + Vector3.new(0,3,0))

for i=1,3 do
VirtualInputManager:SendKeyEvent(true,"E",false,game)
task.wait(0.05)
VirtualInputManager:SendKeyEvent(false,"E",false,game)
task.wait(0.1)
end

task.wait(0.5)

ReturnPlot()
task.wait(0.5)

end

end

-------------------------------------------------
-- AUTO PLACE
-------------------------------------------------

if AutoPlace then

local slot = GetEmptySlot()

if slot then

local tool = GetTool()

if tool then

tool.Parent = player.Character
task.wait(0.2)

TP(slot.CFrame + Vector3.new(0,3,0))

VirtualInputManager:SendKeyEvent(true,"E",false,game)
task.wait(0.1)
VirtualInputManager:SendKeyEvent(false,"E",false,game)

end

end

end

-------------------------------------------------

if AutoCollect then
CollectAll()
end

if AutoUpgradeItem then
UpgradeItems()
end

if AutoUpgradeBase then
Rep.Events.RequestBaseUpgrade:FireServer()
end

if AutoCarry then
Rep.Events.PurchaseCarry:FireServer()
end

if AutoSpeed then
Rep.Events.PurchaseSpeed:FireServer(1)
end

if AutoSell then
Rep.Events.RequestSell:FireServer("Inventory")
end

end

end)

-------------------------------------------------
-- UI
-------------------------------------------------

local Window = Rayfield:CreateWindow({
Name = "Fruit Farm Hub",
LoadingTitle = "Loading Script",
LoadingSubtitle = "Rayfield"
})

local Tab = Window:CreateTab("Main",4483362458)

Tab:CreateToggle({
Name = "Auto Farm",
CurrentValue = false,
Callback = function(v)
AutoFarm = v
end
})

Tab:CreateToggle({
Name = "Auto Place",
CurrentValue = false,
Callback = function(v)
AutoPlace = v
end
})

Tab:CreateToggle({
Name = "Auto Collect",
CurrentValue = false,
Callback = function(v)
AutoCollect = v
end
})

Tab:CreateToggle({
Name = "Auto Upgrade Items",
CurrentValue = false,
Callback = function(v)
AutoUpgradeItem = v
end
})

Tab:CreateToggle({
Name = "Auto Upgrade Base",
CurrentValue = false,
Callback = function(v)
AutoUpgradeBase = v
end
})

Tab:CreateToggle({
Name = "Auto Carry",
CurrentValue = false,
Callback = function(v)
AutoCarry = v
end
})

Tab:CreateToggle({
Name = "Auto Speed",
CurrentValue = false,
Callback = function(v)
AutoSpeed = v
end
})

Tab:CreateToggle({
Name = "Auto Sell",
CurrentValue = false,
Callback = function(v)
AutoSell = v
end
})

-------------------------------------------------
-- ITEM FINDER TAB
-------------------------------------------------

local FinderTab = Window:CreateTab("Item Finder",4483362458)

FinderTab:CreateInput({
Name = "Item Name (ObjectText)",
PlaceholderText = "Pain / Diamond",
RemoveTextAfterFocusLost = false,
Callback = function(text)
TargetItem = text
end
})

FinderTab:CreateButton({
Name = "Collect Selected Item",
Callback = function()
FarmItemOnce(TargetItem)
end
})
