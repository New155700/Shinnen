-- [[ 🔥 SHINNEN HUB | MASTER LOADER V7 PRO + CLOUDFLARE TUNNEL ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local plr = Players.LocalPlayer
local currentId = game.PlaceId 

-- ==========================================
-- [ ⚙️ CONFIGURATION & SOUND SETTINGS ]
-- ==========================================
local API_URL = "https://nnshopth.online/api/verify" 
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

local SoundSettings = {
    VolumeOpen    = 1.5,
    VolumeClose   = 0.8,
    VolumeClick   = 1.0
}

local MapConfig = {
    [113745337705295] = "Games1.lua",
    [142823291]       = "Games2.lua",
    [14469379009]     = "Games3.lua",
}

-- ==========================================
-- [ 🔊 SOUND CONTROLLER ]
-- ==========================================
local function PlaySound(id, volume)
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. tostring(id)
        sound.Volume = volume
        sound.Parent = (gethui and gethui()) or CoreGui
        sound:Play()
        sound.Ended:Wait()
        sound:Destroy()
    end)
end

-- ==========================================
-- [ 🧹 CLEAR OLD UI ]
-- ==========================================
pcall(function()
    local targetGui = (gethui and gethui()) or CoreGui
    for _, v in pairs(targetGui:GetChildren()) do
        if v:IsA("ScreenGui") and (v.Name == "N_FOV_GUI" or v.Name == "ShinnenUI" or v.Name == "ShinnenKeyUI" or v.Name == "N_ESP_FOLDER" or v.Name == "N_MobileAutoE") then
            v:Destroy()
        end
    end
end)

local fileName = MapConfig[currentId]
if not fileName then
    plr:Kick("🚨 [SECURITY]: แมพนี้ไม่ได้รับอนุญาต!\n\nโปรดนำ ID แมพนี้ไปเพิ่มใน MapConfig: " .. tostring(currentId))
    return
end

-- ==========================================
-- [ 🚀 FUNCTION: โหลดสคริปต์จาก GITHUB ]
-- ==========================================
local function LoadMainScript()
    local fetchUrl = baseUrl .. fileName .. "?t=" .. tostring(tick())
    local success, content = pcall(function() return game:HttpGet(fetchUrl) end)

    if success and content and content ~= "" then
        if content:match("404: Not Found") then
            plr:Kick("🚨 [ERROR]: ไม่พบไฟล์ " .. fileName .. " ใน GitHub (404 Not Found)")
            return
        end

        local func, err = loadstring(content)
        if func then
            StarterGui:SetCore("SendNotification", {
                Title = "🔥 SHINNEN PRO",
                Text = "ระบบกำลังดึงสคริปต์หลัก ขอให้สนุกครับ!",
                Icon = "rbxassetid://6023426923",
                Duration = 5
            })
            
            local runSuccess, runErr = pcall(func)
            if not runSuccess then
                warn("🚨 [RUNTIME ERROR]: " .. tostring(runErr))
            end
        else
            plr:Kick("🚨 [SYNTAX ERROR]: " .. tostring(err))
        end
    else
        plr:Kick("🚨 [HTTP ERROR]: ไม่สามารถเชื่อมต่อ GitHub ได้")
    end
end

-- ==========================================
-- [ 🔑 KEY SYSTEM UI (PREMIUM EDITION) ]
-- ==========================================
local function CreateKeySystem()
    local KeyUI = Instance.new("ScreenGui")
    KeyUI.Name = "ShinnenKeyUI"
    KeyUI.Parent = (gethui and gethui()) or CoreGui
    KeyUI.IgnoreGuiInset = true

    local BlurBg = Instance.new("Frame")
    BlurBg.Size = UDim2.new(1, 0, 1, 0)
    BlurBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlurBg.BackgroundTransparency = 1
    BlurBg.Parent = KeyUI

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 380, 0, 220) -- ปรับไซส์เริ่มให้พอดี
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = KeyUI
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(139, 92, 246)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "🔥 SHINNEN HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.Parent = MainFrame

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.85, 0, 0, 45)
    KeyBox.Position = UDim2.new(0.075, 0, 0.35, 0)
    KeyBox.PlaceholderText = "Paste your Premium Key here..."
    KeyBox.Text = ""
    KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 14
    KeyBox.Parent = MainFrame
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(0.85, 0, 0, 45)
    VerifyBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
    VerifyBtn.Text = "VERIFY KEY"
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Font = Enum.Font.GothamBlack
    VerifyBtn.Parent = MainFrame
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, 0, 0, 20)
    StatusText.Position = UDim2.new(0, 0, 0.88, 0)
    StatusText.Text = ""
    StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusText.BackgroundTransparency = 1
    StatusText.Parent = MainFrame

    -- [ ⚙️ FUNCTION: ตรวจสอบคีย์ ]
    VerifyBtn.MouseButton1Click:Connect(function()
        local inputKey = KeyBox.Text
        if inputKey == "" then return end

        VerifyBtn.Text = "CHECKING..."
        
        local req = (syn and syn.request) or (http and http.request) or request or http_request
        
        -- ปรับปรุง JSON ตรงนี้ให้ส่งชื่อตัวแปรตรงกับ Python
        local success, res = pcall(function()
            return req({
                Url = API_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({
                    key = inputKey,
                    game_id = tostring(currentId),
                    hwid = game:GetService("RbxAnalyticsService"):GetClientId()
                })
            })
        end)

        if success then
            local data = HttpService:JSONDecode(res.Body)
            if data.status == "success" then
                StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
                StatusText.Text = "✅ ยืนยันสำเร็จ!"
                task.wait(1)
                KeyUI:Destroy()
                LoadMainScript()
            else
                StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
                StatusText.Text = "❌ " .. (data.message or "คีย์ผิดพลาด")
                VerifyBtn.Text = "VERIFY KEY"
            end
        else
            StatusText.Text = "❌ เชื่อมต่อเซิร์ฟเวอร์ไม่ได้"
            VerifyBtn.Text = "VERIFY KEY"
        end
    end)
end

CreateKeySystem()
