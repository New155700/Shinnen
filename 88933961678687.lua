repeat task.wait() until game:IsLoaded()

local R = game:GetService("ReplicatedStorage").Remotes
local Step = R.StepTaken
local Rebirth = R.RequestRebirth
local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

game.Players.LocalPlayer.CharacterAdded:Connect(function(c) hrp = c:WaitForChild("HumanoidRootPart") end)

local WP = Vector3.new(0,5,-9076)
_G.S = false; _G.W = false; _G.R = false; _G.N = 1

task.spawn(function() while true do
    if _G.S and hrp then for i=1,_G.N do Step:FireServer(math.huge,false) end end
    task.wait(0.007)
end end)

task.spawn(function() while true do if _G.W and hrp then hrp.CFrame = CFrame.new(WP) end task.wait(3) end end)
task.spawn(function() while true do if _G.R then Rebirth:FireServer("free") end task.wait(1) end end)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local W = Rayfield:CreateWindow({Name="Hyper Speed Runner"})
local T = W:CreateTab("Farm")

T:CreateToggle({Name="Auto Step",Callback=function(v)_G.S=v end})
T:CreateSlider({Name="Steps Per Loop",Range={1,50},Increment=1,CurrentValue=1,Callback=function(v)_G.N=v end})
T:CreateToggle({Name="Auto Win",Callback=function(v)_G.W=v end})
T:CreateToggle({Name="Auto Rebirth (1s)",Callback=function(v)_G.R=v end})