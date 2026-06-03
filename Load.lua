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
local CHECK_STATUS_URL = "https://nnshopth.online/api/check_status" 
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

-- [ 🛡️ WATCHDOG SYSTEM ]
local function StartWatchdog(key)
    task.spawn(function()
        while true do
            task.wait(10)
            local req = (syn and syn.request) or (http and http.request) or request or http_request
            if req then
                local success, res = pcall(function()
                    return req({
                        Url = CHECK_STATUS_URL,
                        Method = "POST",
                        Headers = { ["Content-Type"] = "application/json" },
                        Body = HttpService:JSONEncode({key = key}) 
                    })
                end)
                
                if success and res then
                    local data = HttpService:JSONDecode(res.Body)
                    if data.status == "kicked" then
                        plr:Kick("🚨 [SECURITY]: " .. (data.reason or "คีย์ถูกระงับหรือหมดอายุ"))
                        break
                    end
                end
            end
        end
    end)
end

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
            
            print("✅ [SHINNEN PRO]: ยืนยันคีย์สำเร็จ! กำลังรัน -> " .. fileName)
            local runSuccess, runErr = pcall(func)
            if not runSuccess then
                warn("🚨 [RUNTIME ERROR]: โค้ดในไฟล์ " .. fileName .. " มีปัญหาตอนทำงาน: " .. tostring(runErr))
            end
        else
            plr:Kick("🚨 [SYNTAX ERROR]: โค้ดใน " .. fileName .. " มีจุดพิมพ์ผิด\n\n" .. tostring(err))
        end
    else
        plr:Kick("🚨 [HTTP ERROR]: ไม่สามารถเชื่อมต่อ GitHub ได้ ลองเช็คเน็ตหรือลิงก์ดูครับ")
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
    BlurBg.BorderSizePixel = 0
    BlurBg.Parent = KeyUI

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
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

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0, 0, 0, 35)
    SubTitle.Text = "Premium Key System"
    SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 12
    SubTitle.Parent = MainFrame

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.85, 0, 0, 45)
    KeyBox.Position = UDim2.new(0.075, 0, 0.35, 0)
    KeyBox.PlaceholderText = "Paste your Premium Key here..."
    KeyBox.Text = ""
    KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 14
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = MainFrame
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", KeyBox).Color = Color3.fromRGB(50, 50, 60)

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(0.85, 0, 0, 45)
    VerifyBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
    VerifyBtn.Text = "VERIFY KEY"
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Font = Enum.Font.GothamBlack
    VerifyBtn.TextSize = 16
    VerifyBtn.AutoButtonColor = false
    VerifyBtn.Parent = MainFrame
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, 0, 0, 20)
    StatusText.Position = UDim2.new(0, 0, 0.88, 0)
    StatusText.Text = ""
    StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusText.BackgroundTransparency = 1
    StatusText.Font = Enum.Font.GothamSemibold
    StatusText.TextSize = 13
    StatusText.Parent = MainFrame

    TweenService:Create(BlurBg, TweenInfo.new(0.5), {BackgroundTransparency = 0.6}):Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 380, 0, 220)}):Play()
    PlaySound(6066151433, SoundSettings.VolumeOpen)

    StarterGui:SetCore("SendNotification", {
        Title = "👋 สวัสดีครับ!",
        Text = "ยินดีต้อนรับสู่ Shinnen Hub โปรดใส่คีย์เพื่อใช้งาน",
        Duration = 3
    })

    VerifyBtn.MouseEnter:Connect(function() TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(167, 139, 250)}):Play() end)
    VerifyBtn.MouseLeave:Connect(function() TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(139, 92, 246)}):Play() end)

    VerifyBtn.MouseButton1Click:Connect(function()
        PlaySound(4739564027, SoundSettings.VolumeClick)
        
        -- ล้างค่าช่องว่างเผื่อก๊อปมาติด
        local finalKey = string.gsub(KeyBox.Text, "%s+", "")
        
        if finalKey == "" then
            StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
            StatusText.Text = "⚠️ กรุณาใส่คีย์ก่อน!"
            MainStroke.Color = Color3.fromRGB(255, 100, 100)
            PlaySound(2868333334, SoundSettings.VolumeClose)
            return
        end

        VerifyBtn.Text = "CHECKING..."
        TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 120)}):Play()
        StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
        StatusText.Text = "กำลังตรวจสอบฐานข้อมูล..."
        MainStroke.Color = Color3.fromRGB(150, 150, 150)

        local req = (syn and syn.request) or (http and http.request) or request or http_request
        if not req then
            StatusText.Text = "❌ Executor ไม่รองรับ"
            return
        end

        -- [แก้ไขจุดนี้] ส่งค่าให้ตรงกับ Python Server (ใช้ 'key' และ 'game_id')
        local success, res = pcall(function()
            return req({
                Url = API_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({
                    key = finalKey, 
                    game_id = tostring(currentId), 
                    hwid = game:GetService("RbxAnalyticsService"):GetClientId()
                })
            })
        end)

        if success and res then
            local successDecode, resData = pcall(function() return HttpService:JSONDecode(res.Body) end)
            if successDecode and type(resData) == "table" and resData.status == "success" then
                PlaySound(2868331684, SoundSettings.VolumeOpen)
                StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
                StatusText.Text = "✅ " .. (resData.message or "ยืนยันสำเร็จ!")
                VerifyBtn.Text = "SUCCESS!"
                TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(16, 185, 129)}):Play()
                
                task.wait(1)
                TweenService:Create(BlurBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
                closeTween:Play()
                closeTween.Completed:Wait()
                
                KeyUI:Destroy()
                StartWatchdog(finalKey)
                LoadMainScript()
            else
                PlaySound(2868333334, SoundSettings.VolumeClose)
                StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
                StatusText.Text = "❌ " .. (resData.message or "คีย์ไม่ถูกต้อง")
                VerifyBtn.Text = "VERIFY KEY"
                TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(139, 92, 246)}):Play()
            end
        else
            PlaySound(2868333334, SoundSettings.VolumeClose)
            StatusText.Text = "❌ เชื่อมต่อเซิร์ฟเวอร์ไม่ได้"
            VerifyBtn.Text = "VERIFY KEY"
        end
    end)
end

CreateKeySystem()
