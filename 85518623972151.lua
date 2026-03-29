repeat task.wait() until game:IsLoaded()

-- SERVICES
local RS = game:GetService("ReplicatedStorage")
local E = RS:WaitForChild("Events")
local VIM = game:GetService("VirtualInputManager")
local P = game.Players.LocalPlayer

-- CORE
local function HRP()
    return (P.Character or P.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
end

local function TP(v)
    HRP().Parent:PivotTo(CFrame.new(v + Vector3.new(0,5,0)))
end

local function Press(t)
    VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game)
    task.wait(t)
    VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game)
end

local function Parse(t)
    local n = tonumber(t:match("%d+")) or 0
    return t:find("M") and n*1e6 or t:find("K") and n*1e3 or n
end

local function Plot()
    for _,v in pairs(workspace:GetChildren()) do
        if v.Name:find("Plot_") and v.Name:find(P.Name) then return v end
    end
end

-- SETTINGS
local Boost = 30
local Tog = {Jump=false,Speed=false,Rebirth=false,Farm=false,Up=false,Collect=false}

-- BOOST
task.spawn(function()
    while task.wait() do
        if Tog.Jump then pcall(function() E.ClaimJumpBoost:FireServer(Boost) end) end
        if Tog.Speed then pcall(function() E.ClaimSpeedBoost:FireServer(Boost) end) end
        if Tog.Rebirth then pcall(function() E.RequestRebirth:FireServer() end) task.wait(10) end
    end
end)

-- FARM
task.spawn(function()
    while task.wait(1) do
        if Tog.Farm then
            local pl = Plot()
            local home = pl and pl:GetPivot().Position

            TP(Vector3.new(5.3999,215.1799,3348.1491))
            task.wait(0.4)

            local sp = workspace:FindFirstChild("ItemSpawners")
            local sec = sp and sp:FindFirstChild("SecretItem")

            if sec then
                TP(sec:GetPivot().Position)
                task.wait(0.1)
                Press(0.1)
            else
                local best,val = nil,0
                local cel = sp and sp:FindFirstChild("Celestial")

                if cel then
                    for _,i in pairs(cel:GetChildren()) do
                        if i.Name=="SpawnedItem" then
                            local l = i:FindFirstChild("Earnings",true)
                            if l then
                                local v = Parse(l.Text)
                                if v>val then val,best=v,i end
                            end
                        end
                    end
                end

                if best then
                    TP(best:GetPivot().Position)
                    task.wait(0.1)
                    Press(0.1)
                    Press(2)
                end
            end

            if home then TP(home) end
        end
    end
end)

-- UPGRADE
task.spawn(function()
    while task.wait(2) do
        if Tog.Up then
            for f=1,3 do
                for s=1,10 do
                    pcall(function()
                        E.RequestSlotUpgrade:FireServer("Floor"..f,"Slot"..s)
                    end)
                end
            end
        end
    end
end)

-- COLLECT (no TP)
task.spawn(function()
    while task.wait(0.3) do
        if Tog.Collect then
            local pl = Plot()
            if not pl then continue end
            local hrp = HRP()

            for f=1,3 do
                local fl = pl:FindFirstChild("Floor"..f)
                local sl = fl and fl:FindFirstChild("Slots")
                if sl then
                    for s=1,10 do
                        local slot = sl:FindFirstChild("Slot"..s)
                        local vis = slot and slot:FindFirstChild("Spawn") and slot.Spawn:FindFirstChild("VisualItem")
                        local t = slot and slot:FindFirstChild("CollectTouch")
                        if vis and t then
                            firetouchinterest(hrp,t,0)
                            firetouchinterest(hrp,t,1)
                        end
                    end
                end
            end
        end
    end
end)

-- UI
local Ray = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local W = Ray:CreateWindow({Name="",LoadingTitle="Script",LoadingSubtitle="+1 Speed +1 Jump for Brainrots",ConfigurationSaving={Enabled=false}})
local T = W:CreateTab("Main",4483362458)

T:CreateInput({
    Name="Boost Amount",
    PlaceholderText="10/30/50",
    Callback=function(v) local n=tonumber(v) if n then Boost=n end end
})

for k,_ in pairs(Tog) do
    T:CreateToggle({
        Name="Auto"..k,
        Callback=function(v) Tog[k]=v end
    })
end

local Tp = W:CreateTab("Teleport",4483362458)

Tp:CreateButton({
    Name="My Plot",
    Callback=function()
        local p=Plot()
        if p then TP(p:GetPivot().Position) end
    end
})

local loc={
{"Common",Vector3.new(3.8533,0,234.3311)},
{"Uncommon",Vector3.new(4.1033,7.2235,622.3965)},
{"Rare",Vector3.new(4.1033,15.42,987.6230)},
{"Epic",Vector3.new(3.9999,34.1199,1442.9499)},
{"Legendary",Vector3.new(3.9999,65.6340,1944.25)},
{"Mythic",Vector3.new(4.7,133.9899,2599.6010)},
{"Celestial",Vector3.new(5.3999,215.1799,3348.1491)},
{"Secret",Vector3.new(4.8978,323.6099,4670.3510)},
}

for _,v in pairs(loc) do
    Tp:CreateButton({Name=v[1],Callback=function() TP(v[2]) end})
end

Ray:Notify({Title="โหลดสำเร็จ",Content="เวอร์ชันย่อ",Duration=5})