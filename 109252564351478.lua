repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "TURKXSRCIPT Hub",
   LoadingTitle = "Auto Farm",
   LoadingSubtitle = "Script",
   ConfigurationSaving = {Enabled = false}
})

local MainTab = Window:CreateTab("Main EN",4483362458)
local MainTH = Window:CreateTab("Main TH",4483362458)

-- หา HRP
local function getHRP()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- หา CFrame object
local function getCF(obj)
    if obj:IsA("BasePart") then
        return obj.CFrame
    else
        return obj:GetPivot()
    end
end

------------------------------------------------
-- AUTO FARM
------------------------------------------------

local AutoFarm = false

local function StartFarm()
    task.spawn(function()
        while AutoFarm do

            local entorno = workspace:FindFirstChild("Entorno")
            if entorno then
                local nivel = entorno:FindFirstChild("Nivel21")

                if nivel and nivel:FindFirstChild("Gameplay") then
                    local boton = nivel.Gameplay:FindFirstChild("BotonWins")

                    if boton then
                        local hrp = getHRP()
                        hrp.CFrame = getCF(boton) + Vector3.new(0,3,0)

                        hrp.CFrame = hrp.CFrame * CFrame.new(0,0,1)
                    end
                end
            end

            task.wait(0.5)
        end
    end)
end

------------------------------------------------
-- AUTO BUY
------------------------------------------------

local AutoBuy = false

local function StartBuy()
    task.spawn(function()
        while AutoBuy do
            local char = Player.Character or Player.CharacterAdded:Wait()
            local remote = char:WaitForChild("Eventos"):WaitForChild("Mejorar")

            remote:FireServer("Experiencia", true)
            remote:FireServer("Combustible", true)
            remote:FireServer("Trofeos", true)

            task.wait(0.5)
        end
    end)
end

------------------------------------------------
-- AUTO REBIRTH
------------------------------------------------

local AutoRebirth = false

local function StartRebirth()
    task.spawn(function()
        while AutoRebirth do
            local char = Player.Character or Player.CharacterAdded:Wait()
            local rebirth = char:WaitForChild("Eventos"):WaitForChild("Renacimiento")

            rebirth:FireServer()

            task.wait(0.5)
        end
    end)
end

------------------------------------------------
-- ENGLISH UI
------------------------------------------------

MainTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      AutoFarm = Value
      if Value then
         StartFarm()
      end
   end
})

MainTab:CreateToggle({
   Name = "Auto Buy Upgrade",
   CurrentValue = false,
   Callback = function(Value)
      AutoBuy = Value
      if Value then
         StartBuy()
      end
   end
})

MainTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Callback = function(Value)
      AutoRebirth = Value
      if Value then
         StartRebirth()
      end
   end
})

------------------------------------------------
-- THAI UI
------------------------------------------------

MainTH:CreateToggle({
   Name = "ฟาร์มอัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
      AutoFarm = Value
      if Value then
         StartFarm()
      end
   end
})

MainTH:CreateToggle({
   Name = "ซื้ออัปเกรดอัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
      AutoBuy = Value
      if Value then
         StartBuy()
      end
   end
})

MainTH:CreateToggle({
   Name = "รีเบิร์ดอัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
      AutoRebirth = Value
      if Value then
         StartRebirth()
      end
   end
})