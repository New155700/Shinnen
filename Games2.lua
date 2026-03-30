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
end    Name = "เปิดแสง RGB ให้ Hitbox (Rainbow)",
    CurrentValue = false,
    Callback = function(v) HitboxRGB = v end
})

TabMain:CreateToggle({
    Name = "เปิดระบบตีไว (Fast Attack)",
    CurrentValue = false,
    Callback = function(v) AttackSpeedEnabled = v end
})

-- [[ 2. MOVEMENT & PROTECTION ]] --
TabMain:CreateSection("Movement")

TabMain:CreateToggle({
    Name = "เปิดระบบวิ่งไว (Fixed Speed)",
    CurrentValue = false,
    Callback = function(v) SpeedEnabled = v end
})

TabMain:CreateSlider({
   Name = "ระดับความเร็ว",
   Range = {16, 250},
   Increment = 2,
   CurrentValue = 16,
   Callback = function(Value) CustomSpeed = Value end,
})

TabMain:CreateToggle({
    Name = "ล็อกตัวไม่ให้ล้ม (Anti-Ragdoll)",
    CurrentValue = false,
    Callback = function(v) AntiFallEnabled = v end
})

-- [[ 3. TELEPORT (ดึงค่าแม่นยำจาก V14) ]] --
local posOriginal = CFrame.new(256.114014, -160, -2032.05005, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local pos2vs2_1 = CFrame.new(218.5952, -80.5689316, -1911.20142, 0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, 0.707134247)
local pos2vs2_2 = CFrame.new(285.697601, -80.7534561, -1911.35657, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)

TabTp:CreateButton({
    Name = "วาร์ปจุดแรกสุด (Original CF)",
    Callback = function() if plr.Character then plr.Character.HumanoidRootPart.CFrame = posOriginal end end
})

TabTp:CreateButton({
    Name = "วาร์ป 2vs2 (จุดที่ 1)",
    Callback = function() if plr.Character then plr.Character.HumanoidRootPart.CFrame = pos2vs2_1 end end
})

TabTp:CreateButton({
    Name = "วาร์ป 2vs2 (จุดที่ 2)",
    Callback = function() if plr.Character then plr.Character.HumanoidRootPart.CFrame = pos2vs2_2 end end
})

-- [[ 4. GRAPHICS & FPS ]] --
TabVisual:CreateToggle({
    Name = "โหมดภาพสวยคมชัด (High Graphics)",
    CurrentValue = false,
    Callback = function(v)
        local lighting = game:GetService("Lighting")
        if v then
            lighting.Brightness = 2.5
            lighting.FogEnd = 100000
            local bloom = lighting:FindFirstChild("ShinnenBloom") or Instance.new("BloomEffect", lighting)
            bloom.Intensity = 0.5
            bloom.Enabled = true
        else
            lighting.Brightness = 1
            if lighting:FindFirstChild("ShinnenBloom") then lighting.ShinnenBloom.Enabled = false end
        end
    end
})

TabVisual:CreateSlider({
   Name = "ปลดล็อก FPS",
   Range = {60, 360},
   Increment = 10,
   CurrentValue = 60,
   Callback = function(v) setfpscap(v) end,
})

-- [[ CORE SYSTEM INJECTION ]] --
game:GetService("RunService").Heartbeat:Connect(function()
    pcall(function()
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if char and hum and hrp then
            if SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
                hrp.Velocity = Vector3.new(hum.MoveDirection.X * CustomSpeed, hrp.Velocity.Y, hum.MoveDirection.Z * CustomSpeed)
            end
            if AntiFallEnabled and (hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.FallingDown) then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            if AttackSpeedEnabled then
                local tool = char:FindFirstChildWhichIsA("Tool")
                if tool then
                    for _, v in pairs(tool:GetDescendants()) do
                        if v:IsA("NumberValue") and (v.Name:lower():find("cooldown") or v.Name:lower():find("wait")) then
                            v.Value = 0.01
                        end
                    end
                end
            end
        end
    end)
end)

-- [[ DYNAMIC HITBOX LOOP ]] --
task.spawn(function()
    while task.wait(0.5) do
        local Color = Color3.fromHSV(tick() % 5 / 5, 1, 1) 
        
        pcall(function()
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local TargetPart = v.Character.HumanoidRootPart
                    
                    if HitboxEnabled then
                        TargetPart.Size = HitboxSize
                        TargetPart.CanCollide = false
                        TargetPart.Transparency = 0.8 -- ความจางคงที่เพื่อความสบายตา
                        
                        -- เช็กว่าเปิด RGB หรือไม่
                        if HitboxRGB then
                            TargetPart.Color = Color
                            TargetPart.Material = Enum.Material.Neon
                        else
                            TargetPart.Color = Color3.fromRGB(255, 0, 0) -- สีแดงปกติถ้าไม่เปิด RGB
                            TargetPart.Material = Enum.Material.Plastic
                        end
                    else
                        -- คืนค่าเดิมถ้าปิด Hitbox
                        TargetPart.Size = Vector3.new(2, 2, 1)
                        TargetPart.Transparency = 1
                    end
                end
            end
        end)
    end
end)

Rayfield:Notify({Title = "V1 Final Updated", Content = "แยกปุ่มเปิด-ปิด Hitbox และ RGB เรียบร้อยครับ", Duration = 5})

}) -- วงเล็บปิดของ Window

-- สร้างหน้าเมนู (Tab)
local MainTab = Win:CreateTab("Main", 4483362458)

-- สร้างปุ่มทดสอบ
MainTab:CreateButton({
   Name = "Test Hub",
   Callback = function()
       print("Hub is Working!")
   end,
})

