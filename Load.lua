-- [[ 🔥 SHINNEN HUB | MASTER LOADER V7 PRO + CLOUDFLARE TUNNEL ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local plr = Players.LocalPlayer
local currentId = game.PlaceId 

-- ==========================================
-- [ ⚙️ CONFIGURATION ]
-- ==========================================
-- ใช้โดเมนของคุณส่งผ่านระบบ Cloudflare Tunnel ตรงเข้ามือถือ
local API_URL = "https://nnshop.online/api/verify" 
local baseUrl = "https://raw.githubusercontent.com/New155700/Shinnen/main/"

-- [ 📋 ตารางแมพ ]
local MapConfig = {
    [113745337705295] = "Games1.lua", -- ID แมพตำรวจจับโจร
    [142823291]       = "Games2.lua", -- ID แมพ Murder Mystery 2
    [14469379009]     = "Games3.lua", -- ID แมพแข่งกันกินอาหารเป็นทีม
}

-- [ 🧹 CLEAR OLD UI ]
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

-- [ 🚀 FUNCTION: LOAD SCRIPT FROM GITHUB ]
local function LoadMainScript()
    local fetchUrl = baseUrl .. fileName .. "?t=" .. tostring(tick())
    local success, content = pcall(function() return game:HttpGet(fetchUrl) end)

    if success and content and content ~= "" then
        if content:match("404: Not Found") then
            plr:Kick("🚨 [ERROR]: ไม่พบไฟล์ " .. fileName .. " ใน GitHub")
            return
        end
        local func, err = loadstring(content)
        if func then
            print("✅ [SHINNEN PRO]: ดึงข้อมูลสำเร็จ! กำลังรัน -> " .. fileName)
            pcall(func)
        else
            plr:Kick("🚨 [SYNTAX ERROR]: โค้ดพิมพ์ผิด\n\n" .. tostring(err))
        end
    else
        plr:Kick("🚨 [HTTP ERROR]: เชื่อมต่อ GitHub ล้มเหลว")
    end
end

-- [ 🔑 KEY SYSTEM UI & TUNNEL VERIFICATION ]
local function CreateKeySystem()
    local KeyUI = Instance.new("ScreenGui")
    KeyUI.Name = "ShinnenKeyUI"
    KeyUI.Parent = (gethui and gethui()) or CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 180)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeyUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "🔥 SHINNEN HUB | KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = MainFrame

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.8, 0, 0, 40)
    KeyBox.Position = UDim2.new(0.1, 0, 0.28, 0)
    KeyBox.PlaceholderText = "Paste your key here..."
    KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 14
    KeyBox.Parent = MainFrame
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 5)

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(0.8, 0, 0, 40)
    VerifyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 15
    VerifyBtn.Parent = MainFrame
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 5)

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, 0, 0, 20)
    StatusText.Position = UDim2.new(0, 0, 0.82, 0)
    StatusText.Text = ""
    StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusText.BackgroundTransparency = 1
    StatusText.Font = Enum.Font.Gotham
    StatusText.TextSize = 12
    StatusText.Parent = MainFrame

    VerifyBtn.MouseButton1Click:Connect(function()
        local inputKey = KeyBox.Text
        if inputKey == "" then
            StatusText.Text = "⚠️ กรุณาใส่คีย์ก่อน!"
            return
        end

        VerifyBtn.Text = "Checking..."
        StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
        StatusText.Text = "กำลังส่งสัญญาณไปที่มือถือหลังบ้าน..."

        local req = (syn and syn.request) or (http and http.request) or request or http_request
        if not req then
            StatusText.Text = "❌ Executor ไม่รองรับ HTTP Request"
            VerifyBtn.Text = "Verify Key"
            return
        end

        -- ปรับรูปแบบการยิงให้อ่านค่าผ่านคำสั่งดึงแบบคำขอของโค้ดคุณ (GET/POST URL Args)
        local targetUrl = API_URL .. "?key=" .. HttpService:UrlEncode(inputKey) .. "&gameId=" .. HttpService:UrlEncode(tostring(currentId)) .. "&hwid=NO_HWID"

        local success, res = pcall(function()
            return req({
                Url = targetUrl,
                Method = "GET" -- เปลี่ยนมาใช้สไตล์ตามหลักสคริปต์ของแอดมินเป๊ะๆ
            })
        end)

        if success and res then
            local successDecode, resData = pcall(function()
                return HttpService:JSONDecode(res.Body)
            end)

            if successDecode and type(resData) == "table" then
                if resData.status == "success" then
                    StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
                    StatusText.Text = "✅ ยืนยันสำเร็จ! กำลังโหลดสคริปต์..."
                    task.wait(1)
                    KeyUI:Destroy()
                    LoadMainScript()
                else
                    StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
                    StatusText.Text = "❌ " .. (resData.message or "คีย์ไม่ถูกต้อง")
                    VerifyBtn.Text = "Verify Key"
                end
            else
                StatusText.Text = "❌ เซิร์ฟเวอร์ตอบกลับผิดพลาด"
                VerifyBtn.Text = "Verify Key"
            end
        else
            StatusText.Text = "❌ ไม่สามารถติดต่อเซิร์ฟเวอร์โดเมนได้"
            VerifyBtn.Text = "Verify Key"
        end
    end)
end

CreateKeySystem()
