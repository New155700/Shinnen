repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- toggles
local AutoReel = false
local AutoCollect = false
local AutoPower = false
local AutoCatch = false
local AutoRodMutation = false
local AutoBuyRod = false
local AutoRebirth = false
local AutoSell = false

local CollectSpeed = 0.2

local DeleteSetting = {
    Uncommon = false,
    Rare = false,
    Epic = false,
    Legendary = false,
    Mythic = false,
    Godly = false,
    Divine = false,
    Secret = false
}

-------------------------------------------------
-- UI
-------------------------------------------------

local Window = Rayfield:CreateWindow({
    Name = "Fishing Hub",
    LoadingTitle = "Fishing Script",
    LoadingSubtitle = "Auto Farm",
    ConfigurationSaving = {Enabled = false}
})

local Main = Window:CreateTab("Main",4483362458)
local SellTab = Window:CreateTab("Sell Setting",4483362458)

-------------------------------------------------
-- AUTO REEL
-------------------------------------------------

task.spawn(function()
    while true do
        if AutoReel then
            ReplicatedStorage.RemoteHandler.Fishing:FireServer("Caught",2)
        end
        task.wait(0.05)
    end
end)

-------------------------------------------------
-- AUTO COLLECT (FIX)
-------------------------------------------------

task.spawn(function()

    local plot = 1

    while true do

        if AutoCollect then

            ReplicatedStorage.RemoteHandler.Collect:FireServer("Plot"..plot)

            plot += 1

            if plot > 30 then
                plot = 1
            end

            task.wait(CollectSpeed)

        else
            task.wait(0.2)
        end

    end

end)

-------------------------------------------------
-- AUTO POWER
-------------------------------------------------

task.spawn(function()
    while true do
        if AutoPower then
            ReplicatedStorage.RemoteHandler.Upgrade:FireServer("power1")
        end
        task.wait(0.1)
    end
end)

-------------------------------------------------
-- AUTO CATCH
-------------------------------------------------

task.spawn(function()
    while true do
        if AutoCatch then
            ReplicatedStorage.RemoteHandler.Upgrade:FireServer("catch1")
        end
        task.wait(0.1)
    end
end)

-------------------------------------------------
-- AUTO ROD MUTATION
-------------------------------------------------

task.spawn(function()
    while true do
        if AutoRodMutation then
            for i = 1,7 do
                ReplicatedStorage.RemoteHandler.RodMutation:FireServer("Buy","RodMutation"..i)
                task.wait(0.5)
            end
        end
        task.wait(2)
    end
end)

-------------------------------------------------
-- AUTO BUY ROD
-------------------------------------------------

task.spawn(function()
    while true do
        if AutoBuyRod then
            for i = 1,17 do
                ReplicatedStorage.RemoteHandler.FishingRod:FireServer("Buy","FishingRod"..i)
                task.wait(0.5)
            end
        end
        task.wait(3)
    end
end)

-------------------------------------------------
-- AUTO REBIRTH
-------------------------------------------------

task.spawn(function()
    while true do
        if AutoRebirth then
            ReplicatedStorage.RemoteHandler.Rebirth:FireServer()
        end
        task.wait(1)
    end
end)

-------------------------------------------------
-- AUTO SELL
-------------------------------------------------

task.spawn(function()
    while true do
        if AutoSell then
            ReplicatedStorage.RemoteHandler.SellMultiple:FireServer(DeleteSetting)
        end
        task.wait(0.5)
    end
end)

-------------------------------------------------
-- UI MAIN
-------------------------------------------------

Main:CreateSlider({
    Name = "Collect Speed",
    Range = {0.05,1},
    Increment = 0.05,
    CurrentValue = 0.2,
    Callback = function(v)
        CollectSpeed = v
    end
})

Main:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = false,
    Callback = function(v)
        AutoCollect = v
    end
})

Main:CreateToggle({
    Name = "Auto Reel",
    CurrentValue = false,
    Callback = function(v)
        AutoReel = v
    end
})

Main:CreateToggle({
    Name = "Auto Buy Power",
    CurrentValue = false,
    Callback = function(v)
        AutoPower = v
    end
})

Main:CreateToggle({
    Name = "Auto Buy Catch",
    CurrentValue = false,
    Callback = function(v)
        AutoCatch = v
    end
})

Main:CreateToggle({
    Name = "Auto Rod Mutation",
    CurrentValue = false,
    Callback = function(v)
        AutoRodMutation = v
    end
})

Main:CreateToggle({
    Name = "Auto Buy Rod",
    CurrentValue = false,
    Callback = function(v)
        AutoBuyRod = v
    end
})

Main:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Callback = function(v)
        AutoRebirth = v
    end
})

Main:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Callback = function(v)
        AutoSell = v
    end
})

-------------------------------------------------
-- SELL SETTING
-------------------------------------------------

for rarity,_ in pairs(DeleteSetting) do

    SellTab:CreateToggle({
        Name = "Sell "..rarity,
        CurrentValue = false,
        Callback = function(v)
            DeleteSetting[rarity] = v
        end
    })

end