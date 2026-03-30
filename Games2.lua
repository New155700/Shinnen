local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Win = Rayfield:CreateWindow({
    Name = "Shinnen Hub | V1 Custom",
    LoadingTitle = "Splitting Toggles...🌼🌼",
    LoadingSubtitle = "by Shinnen Custom 🌼🌼",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false 
})

-- [[ SETTINGS ]] --
local plr=game.Players.LocalPlayer
getgenv().AutoBuy=false
getgenv().AutoLock=false
getgenv().AutoBrainrots=false
getgenv().Ranks={}
getgenv().Speed=16

-- หา Base
local function getBase()
	for i=1,8 do
		local b=workspace.Bases:FindFirstChild(tostring(i))
		if b then
			local ok,name=pcall(function()
				return b.OwnerBoard.Board.SurfaceGui.Username.Text
			end)
			if ok and name and name:find(plr.Name) then
				return b
			end
		end
	end
end

-- ⚡ Prompt instant
task.spawn(function()
	while task.wait(1) do
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				v.HoldDuration=0
			end
		end
	end
end)

-- ⚡ Speed
task.spawn(function()
	while task.wait() do
		local c=plr.Character
		if c then
			local h=c:FindFirstChildOfClass("Humanoid")
			if h then h.WalkSpeed=getgenv().Speed end
		end
	end
end)

-- ยิงสุ่ม
local function fire()
	local args={{{"\001","\187Q\213a\211\155A\207\128&\189F\158\203WN",{}}, "\020"}}
	game:GetService("ReplicatedStorage")
	:WaitForChild("ncxyzero_bridgenet2-fork@1.1.5")
	:WaitForChild("dataRemoteEvent")
	:FireServer(unpack(args))
end

-- 🔒 AutoLock (วาปไป-กลับ 100%)
task.spawn(function()
	while task.wait(0.2) do
		if getgenv().AutoLock then
			local b=getBase()
			if b then
				local btn=b:FindFirstChild("Buttons") and b.Buttons:FindFirstChild("ForceFieldBuy")
				if btn then
					local part=btn:FindFirstChild("Base")
					local txt=""
					pcall(function() txt=btn.Info.Timer.Text end)

					txt=tostring(txt):gsub("%s+","")

					if txt=="1s" or txt=="" then
						local char=plr.Character
						local hrp=char and char:FindFirstChild("HumanoidRootPart")

						if hrp and part then
							local old=hrp.CFrame

							-- วาปไป
							hrp.CFrame=part.CFrame+Vector3.new(0,2,0)
							task.wait(0.1)

							-- กด
							firetouchinterest(hrp,part,0)
							firetouchinterest(hrp,part,1)

							task.wait(0.05)

							-- วาปกลับชัวร์
							if hrp then
								hrp.CFrame=old
							end
						end
					end
				end
			end
		end
	end
end)

-- 🧠 Auto Brainrots
task.spawn(function()
	while task.wait(0.5) do
		if getgenv().AutoBrainrots then
			local b=getBase()
			if b and b:FindFirstChild("SetBrainrots") then
				for _,m in pairs(b.SetBrainrots:GetChildren()) do
					game:GetService("ReplicatedStorage")
					:WaitForChild("ncxyzero_bridgenet2-fork@1.1.5")
					:WaitForChild("dataRemoteEvent")
					:FireServer({m.Name,"\v"})
				end
			end
		end
	end
end)

-- 🛒 AutoBuy
task.spawn(function()
	while task.wait(0.3) do
		if getgenv().AutoBuy then
			local b=getBase()
			if b and b:FindFirstChild("BrainrotsOnCoveyor") then
				local found=false
				for _,m in pairs(b.BrainrotsOnCoveyor:GetChildren()) do
					local ok,rank=pcall(function()
						return m.HumanoidRootPart.RunwayBGUINew.Main.Rarity.Text
					end)
					if ok and getgenv().Ranks[rank] then
						local p=m.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt")
						if p then
							found=true
							repeat
								fireproximityprompt(p)
								task.wait(0.2)
							until not p.Parent or not m.Parent
						end
					end
				end
				if not found then
					fire()
					task.wait(5)
				end
			end
		end
	end
end)

-- 🗑️ ลบ Gate + Plot
local function clearMap()
	local my=getBase()
	for _,b in pairs(workspace.Bases:GetChildren()) do
		if b~=my then
			pcall(function()
				if b:FindFirstChild("Gate") then b.Gate:Destroy() end
				if b:FindFirstChild("PlotTeritory") then b.PlotTeritory:Destroy() end
			end)
		end
	end
-- ลบ UI
pcall(function()
	for _,v in pairs(game.CoreGui:GetChildren()) do
		if v.Name=="Rayfield" then v:Destroy() end
	end
end)

local Rayfield=loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Win=Rayfield:CreateWindow({Name="⚡ Farm Hub",ConfigurationSaving={Enabled=false}})

local plr=game.Players.LocalPlayer
getgenv().AutoBuy=false
getgenv().AutoLock=false
getgenv().AutoBrainrots=false
getgenv().Ranks={}
getgenv().Speed=16

-- หา Base
local function getBase()
	for i=1,8 do
		local b=workspace.Bases:FindFirstChild(tostring(i))
		if b then
			local ok,name=pcall(function()
				return b.OwnerBoard.Board.SurfaceGui.Username.Text
			end)
			if ok and name and name:find(plr.Name) then
				return b
			end
		end
	end
end

-- ⚡ Prompt instant
task.spawn(function()
	while task.wait(1) do
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				v.HoldDuration=0
			end
		end
	end
end)

-- ⚡ Speed
task.spawn(function()
	while task.wait() do
		local c=plr.Character
		if c then
			local h=c:FindFirstChildOfClass("Humanoid")
			if h then h.WalkSpeed=getgenv().Speed end
		end
	end
end)

-- ยิงสุ่ม
local function fire()
	local args={{{"\001","\187Q\213a\211\155A\207\128&\189F\158\203WN",{}}, "\020"}}
	game:GetService("ReplicatedStorage")
	:WaitForChild("ncxyzero_bridgenet2-fork@1.1.5")
	:WaitForChild("dataRemoteEvent")
	:FireServer(unpack(args))
end

-- 🔒 AutoLock (วาปไป-กลับ 100%)
task.spawn(function()
	while task.wait(0.2) do
		if getgenv().AutoLock then
			local b=getBase()
			if b then
				local btn=b:FindFirstChild("Buttons") and b.Buttons:FindFirstChild("ForceFieldBuy")
				if btn then
					local part=btn:FindFirstChild("Base")
					local txt=""
					pcall(function() txt=btn.Info.Timer.Text end)

					txt=tostring(txt):gsub("%s+","")

					if txt=="1s" or txt=="" then
						local char=plr.Character
						local hrp=char and char:FindFirstChild("HumanoidRootPart")

						if hrp and part then
							local old=hrp.CFrame

							-- วาปไป
							hrp.CFrame=part.CFrame+Vector3.new(0,2,0)
							task.wait(0.1)

							-- กด
							firetouchinterest(hrp,part,0)
							firetouchinterest(hrp,part,1)

							task.wait(0.05)

							-- วาปกลับชัวร์
							if hrp then
								hrp.CFrame=old
							end
						end
					end
				end
			end
		end
	end
end)

-- 🧠 Auto Brainrots
task.spawn(function()
	while task.wait(0.5) do
		if getgenv().AutoBrainrots then
			local b=getBase()
			if b and b:FindFirstChild("SetBrainrots") then
				for _,m in pairs(b.SetBrainrots:GetChildren()) do
					game:GetService("ReplicatedStorage")
					:WaitForChild("ncxyzero_bridgenet2-fork@1.1.5")
					:WaitForChild("dataRemoteEvent")
					:FireServer({m.Name,"\v"})
				end
			end
		end
	end
end)

-- 🛒 AutoBuy
task.spawn(function()
	while task.wait(0.3) do
		if getgenv().AutoBuy then
			local b=getBase()
			if b and b:FindFirstChild("BrainrotsOnCoveyor") then
				local found=false
				for _,m in pairs(b.BrainrotsOnCoveyor:GetChildren()) do
					local ok,rank=pcall(function()
						return m.HumanoidRootPart.RunwayBGUINew.Main.Rarity.Text
					end)
					if ok and getgenv().Ranks[rank] then
						local p=m.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt")
						if p then
							found=true
							repeat
								fireproximityprompt(p)
								task.wait(0.2)
							until not p.Parent or not m.Parent
						end
					end
				end
				if not found then
					fire()
					task.wait(5)
				end
			end
		end
	end
end)

-- 🗑️ ลบ Gate + Plot
local function clearMap()
	local my=getBase()
	for _,b in pairs(workspace.Bases:GetChildren()) do
		if b~=my then
			pcall(function()
				if b:FindFirstChild("Gate") then b.Gate:Destroy() end
				if b:FindFirstChild("PlotTeritory") then b.PlotTeritory:Destroy() end
			end)
		end
	end
end

-- UI
local auto=Win:CreateTab("⚡ Auto")
local farm=Win:CreateTab("🌾 Rank")

auto:CreateInput({
	Name="⚡ Speed",
	PlaceholderText="50",
	Callback=function(v)
		local n=tonumber(v)
		if n then getgenv().Speed=n end
	end
})

auto:CreateToggle({Name="🧠 Auto Collect",Callback=function(v)getgenv().AutoBrainrots=v end})
auto:CreateToggle({Name="🛒 Auto Buy",Callback=function(v)getgenv().AutoBuy=v end})
auto:CreateToggle({Name="🔒 Auto Lock (วาปไป-กลับ)",Callback=function(v)getgenv().AutoLock=v end})

auto:CreateButton({Name="🗑️ ลบ Gate+Plot",Callback=clearMap})

for _,r in ipairs({"Common","Uncommon","Rare","Epic","Legendary","Mythic", "Secret"}) do
	farm:CreateToggle({
		Name=r,
		Callback=function(v)
			getgenv().Ranks[r]=v and true or nil
		end
	})
end
	
-- วงเล็บปิดของ Window

-- สร้างหน้าเมนู (Tab)
local MainTab = Win:CreateTab("Main", 4483362458)

-- สร้างปุ่มทดสอบ
MainTab:CreateButton({
   Name = "Test Hub",
   Callback = function()
       print("Hub is Working!")
   end,
})

