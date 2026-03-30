-- ลบ UI เก่า
pcall(function()
	for _,v in pairs(game.CoreGui:GetChildren()) do
		if v.Name=="Rayfield" then v:Destroy() end
	end
end)

local Rayfield=loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Win=Rayfield:CreateWindow({Name=" test ",ConfigurationSaving={Enabled=false}})

local plr=game.Players.LocalPlayer
local VIM=game:GetService("VirtualInputManager")

getgenv().Speed=50
getgenv().AutoE=false

-- วิ่งไว
task.spawn(function()
	while task.wait() do
		local c=plr.Character
		if c then
			local hum=c:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed=getgenv().Speed
			end
		end
	end
end)

-- Prompt instant
task.spawn(function()
	while task.wait(0.1) do
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				v.HoldDuration=0
			end
		end
	end
end)

-- กด E รัว
task.spawn(function()
	while task.wait(0.1) do
		if getgenv().AutoE then
			VIM:SendKeyEvent(true,"E",false,game)
			VIM:SendKeyEvent(false,"E",false,game)
		end
	end
end)

-- UI
local tab=Win:CreateTab("Main")

tab:CreateInput({
	Name="⚡ Speed",
	PlaceholderText="50",
	Callback=function(v)
		local n=tonumber(v)
		if n then getgenv().Speed=n end
	end
})

tab:CreateToggle({
	Name="⌨️ Auto E",
	CurrentValue=false,
	Callback=function(v)
		getgenv().AutoE=v
	end
})
