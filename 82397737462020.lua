pcall(function()
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    -- ... rest of code
end)

-- รอมันโหลดเสร็จก่อน
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local plr = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- เช็คให้ชัวร์ว่า Remote มีอยู่จริง ถ้าไม่มีจะไม่รันต่อเพื่อกัน Error
local remote = RS:WaitForChild("Modules"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent")

-- ========================
-- SETTINGS (ตัวแปรควบคุม)
-- ========================
local AutoFarm = false
local AutoEquip = false
local AutoRebirth = false
local BuySize = false
local BuySpeed = false
local BuyCarry = false
local UpBase = false
local UpStand = false

local dropPos = Vector3.new(489.1172, 2150.6230, 1026.4221)

local zonePos = {
    Common = Vector3.new(495, 2135, 276),
    Uncommon = Vector3.new(568, 2139, -179),
    Rare = Vector3.new(549, 2139, -735),
    Epic = Vector3.new(538, 2139, -1464),
    Mythical = Vector3.new(524, 2139, -4199),
    Divine = Vector3.new(539, 2139, -6719),
    Godly = Vector3.new(502, 2139, -7648),
    Secret = Vector3.new(520, 6272, -7864)
}

-- ฟังก์ชัน TP (ปรับให้นุ่มนวลขึ้นเล็กน้อย)
local function tp(pos)
    if not pos then return end
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- ดึงค่าขนาดตัวละครจาก UI
local function getSize()
    local hud = plr:FindFirstChild("PlayerGui") and plr.PlayerGui:FindFirstChild("HUD")
    if hud then
        local label = hud.Values.Upgrades.SizeLabel.SizeLabel.Text
        local a, b = label:match("(%d+)'([%d%.]+)")
        if a and b then
            return tonumber(a) + (tonumber(b) / 10)
        end
    end
    return 10 -- ค่า Default ถ้าหา UI ไม่เจอ
end

local function getMyZone()
    local s = getSize()
    if s > 6.7 then return "Common"
    elseif s > 6.0 then return "Uncommon"
    elseif s > 4.4 then return "Rare"
    elseif s > 3.0 then return "Epic"
    elseif s > 2.0 then return "Legendary"
    elseif s > 1.2 then return "Mythical"
    elseif s > 0.87 then return "Divine"
    elseif s > 0.31 then return "Godly"
    else return "Secret" end
end

-- หาเป้าหมายที่ดีที่สุดในโซน
local function getBest(zone)
    local worldVehicles = workspace:FindFirstChild("_WorldVehicles")
    local f = worldVehicles and worldVehicles:FindFirstChild(zone .. "Zone")
    if not f then return nil end

    local best, val = nil, 0
    for _, m in pairs(f:GetChildren()) do
        local g = m:FindFirstChild("InfoGui", true)
        if g and g:FindFirstChild("incomePerSec") then
            local num = tonumber(g.incomePerSec.Text:match("([%d%.]+)")) or 0
            if num > val then
                val = num
                best = m
            end
        end
    end
    return best
end

-- ========================
-- LOOPS (การทำงานอัตโนมัติ)
-- ========================

-- Loop: Farm
task.spawn(function()
    while true do
        task.wait(0.6)
        if AutoFarm then
            local zone = getMyZone()
            local target = getBest(zone)
            
            if target then
                local part = target:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    tp(part.Position)
                    task.wait(0.3)
                    -- กด E อัตโนมัติ
                    for _, p in pairs(target:GetDescendants()) do
                        if p:IsA("ProximityPrompt") then
                            fireproximityprompt(p, 0)
                        end
                    end
                    task.wait(0.5)
                    tp(dropPos)
                    task.wait(1.5)
                end
            end
        end
    end
end)

-- Loop: Buy Upgrades
task.spawn(function()
    while true do
        task.wait(0.5)
        if BuySize then remote:FireServer(buffer.fromstring("\018\005\005")) end
        if BuySpeed then remote:FireServer(buffer.fromstring("\018\005\001")) end
        if BuyCarry then remote:FireServer(buffer.fromstring("\018\005\004")) end
    end
end)

-- Loop: Rebirth / Equip
task.spawn(function()
    while true do
        if AutoEquip then 
            remote:FireServer(buffer.fromstring("\"\028\v\006Source\v\016SatchelEquipBest\000")) 
        end
        task.wait(2)
        if AutoRebirth then 
            remote:FireServer(buffer.fromstring("\022\028\v\006Action\v\aRebirth\000")) 
        end
        task.wait(3)
    end
end)

-- ========================
-- UI SETUP (Rayfield)
-- ========================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Win = Rayfield:CreateWindow({
    Name = "Shrink For Brainrot | Shinnen",
    LoadingTitle = "Loading Script...",
    LoadingSubtitle = "by New155700",
    ConfigurationSaving = {Enabled = false}
})

local Tab = Win:CreateTab("Main", 4483362458)
local Tp = Win:CreateTab("Teleport", 4483362458)

Tab:CreateToggle({Name = "Auto Farm", CurrentValue = false, Callback = function(v) AutoFarm = v end})
Tab:CreateToggle({Name = "Auto Equip", CurrentValue = false, Callback = function(v) AutoEquip = v end})
Tab:CreateToggle({Name = "Auto Rebirth", CurrentValue = false, Callback = function(v) AutoRebirth = v end})
Tab:CreateSection("Auto Buy")
Tab:CreateToggle({Name = "Buy Size", CurrentValue = false, Callback = function(v) BuySize = v end})
Tab:CreateToggle({Name = "Buy Speed", CurrentValue = false, Callback = function(v) BuySpeed = v end})
Tab:CreateToggle({Name = "Buy Carry", CurrentValue = false, Callback = function(v) BuyCarry = v end})

for n, p in pairs(zonePos) do
    Tp:CreateButton({Name = "Go to " .. n, Callback = function() tp(p) end})
end
Tp:CreateButton({Name = "Drop Point", Callback = function() tp(dropPos) end})

Rayfield:Notify({Title = "Script Loaded", Content = "Enjoy your farm!", Duration = 5})
-- ========================
local function tp(pos)
	if not pos then return end
	local hrp=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame=CFrame.new(pos+Vector3.new(0,3,0))
	end
end

-- ========================
-- SIZE → ZONE
-- ========================
local function getSize()
	local t=plr.PlayerGui.HUD.Values.Upgrades.SizeLabel.SizeLabel.Text
	local a,b=t:match("(%d+)'([%d%.]+)")
	return a and (tonumber(a)+tonumber(b)/10) or 0
end

local function getMyZone()
	local s=getSize()
	if s>6.7 then return "Common"
	elseif s<=6.6 and s>6.0 then return "Uncommon"
	elseif s<=5.9 and s>4.4 then return "Rare"
	elseif s<=4.3 and s>3.0 then return "Epic"
	elseif s<=2.9 and s>2.0 then return "Legendary"
	elseif s<=1.9 and s>1.2 then return "Mythical"
	elseif s<=1.1 and s>0.87 then return "Divine"
	elseif s<=0.86 and s>0.31 then return "Godly"
	else return "Secret" end
end

-- ========================
-- GET BEST TARGET
-- ========================
local function getBest(zone)
	local f=workspace._WorldVehicles:FindFirstChild(zone.."Zone")
	if not f then return end

	local best,val=nil,0

	for _,m in pairs(f:GetChildren()) do
		local g=m:FindFirstChild("InfoGui",true)
		if g and g:FindFirstChild("incomePerSec") then
			local num=tonumber(g.incomePerSec.Text:match("([%d%.]+)")) or 0
			if num>val then
				val=num
				best=m
			end
		end
	end
	return best
end

-- ========================
-- AUTO FARM
-- ========================
task.spawn(function()
	while task.wait(0.6) do
		if AutoFarm then
			local zone=getMyZone()

			tp(zonePos[zone])

			local target=getBest(zone)
			if not target then continue end

			local part=target:FindFirstChildWhichIsA("BasePart",true)
			if not part then continue end

			tp(part.Position)
			task.wait(1)

			for _,p in pairs(target:GetDescendants()) do
				if p:IsA("ProximityPrompt") then
					fireproximityprompt(p,0)
				end
			end

			tp(dropPos)
			task.wait(2)
		end
	end
end)

-- ========================
-- AUTO BUY
-- ========================
task.spawn(function()
	while task.wait(0.5) do
		if BuySize then remote:FireServer(buffer.fromstring("\018\005\005")) end
		if BuySpeed then remote:FireServer(buffer.fromstring("\018\005\001")) end
		if BuyCarry then remote:FireServer(buffer.fromstring("\018\005\004")) end
	end
end)

-- ========================
-- AUTO EQUIP
-- ========================
task.spawn(function()
	while task.wait(5) do
		if AutoEquip then
			remote:FireServer(buffer.fromstring("\"\028\v\006Source\v\016SatchelEquipBest\000"))
		end
	end
end)

-- ========================
-- AUTO REBIRTH
-- ========================
task.spawn(function()
	while task.wait(3) do
		if AutoRebirth then
			remote:FireServer(buffer.fromstring("\022\028\v\006Action\v\aRebirth\000"))
		end
	end
end)

-- ========================
-- AUTO UPGRADE
-- ========================
task.spawn(function()
	while task.wait(1) do
		if UpBase then
			remote:FireServer(buffer.fromstring(" \028\v\005Floor\005\002\000"))
		end

		if UpStand then
			for i=1,46 do
				remote:FireServer(buffer.fromstring("!\028\v\nStandIndex\005"..string.char(i).."\000"))
				task.wait(0.05)
			end
		end
	end
end)

-- ========================
-- UI
-- ========================
local Rayfield=loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Win=Rayfield:CreateWindow({Name="Shrink For Brainrot",ConfigurationSaving={Enabled=false}})

local Tab=Win:CreateTab("Main",4483362458)
local Tp=Win:CreateTab("Teleport",4483362458)

Tab:CreateToggle({Name="Auto Farm",Callback=function(v)AutoFarm=v end})
Tab:CreateToggle({Name="Auto Equip",Callback=function(v)AutoEquip=v end})
Tab:CreateToggle({Name="Auto Rebirth",Callback=function(v)AutoRebirth=v end})

Tab:CreateToggle({Name="Buy Size",Callback=function(v)BuySize=v end})
Tab:CreateToggle({Name="Buy Speed",Callback=function(v)BuySpeed=v end})
Tab:CreateToggle({Name="Buy Carry",Callback=function(v)BuyCarry=v end})

Tab:CreateToggle({Name="Upgrade Base",Callback=function(v)UpBase=v end})
Tab:CreateToggle({Name="Upgrade Stand",Callback=function(v)UpStand=v end})

for n,p in pairs(zonePos) do
	Tp:CreateButton({Name=n,Callback=function() tp(p) end})
end

Tp:CreateButton({Name="Drop",Callback=function() tp(dropPos) end})
