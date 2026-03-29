repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Remote")

local Window = Rayfield:CreateWindow({
    Name = "Guess My Number",
    LoadingTitle = "Guess My Number",
    LoadingSubtitle = "Reveal & Hint Tool",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Main", 4483362458)

Tab:CreateButton({
    Name = "Reveal Number",
    Callback = function()
        RemoteFolder.UseRevealNumber:FireServer()
        Rayfield:Notify({
            Title = "Reveal Number",
            Content = "Sent reveal request",
            Duration = 4
        })
    end
})

Tab:CreateButton({
    Name = "Hint Number",
    Callback = function()
        RemoteFolder.UseHint:FireServer()
        Rayfield:Notify({
            Title = "Hint Number",
            Content = "Sent hint request",
            Duration = 4
        })
    end
})

Tab:CreateParagraph({
    Title = "How to Use",
    Content = "• Click 'Reveal Number' to show the secret number\n• Click 'Hint Number' to get a hint\n• Press M to toggle the old menu (if any)"
})

Rayfield:Notify({
    Title = "Script Loaded ✅",
    Content = "Guess My Number Tool is ready",
    Duration = 6
})