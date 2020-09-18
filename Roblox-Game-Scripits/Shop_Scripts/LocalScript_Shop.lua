local replicatedStorage = game:GetService("ReplicatedStorage")
local shopFrame = script.Parent:WaitForChild("ShopFrame")
local back = shopFrame.Back
local forward = shopFrame.Forward
local buy = shopFrame.Buy
local description = shopFrame.Description
local title = shopFrame.Title
local camera = game.Workspace.CurrentCamera
local itemRoller = game.Workspace:WaitForChild("ItemRoller")
local blackBG = script.Parent:WaitForChild("BlackBG")
local currentBox = script.Parent:WaitForChild("CurrentBox")
local player = game.Players.LocalPlayer
local DISABLED_BUTTON_COLOR = Color3.fromRGB(118,110,153)
local ENABLED_BUTTON_COLOR = Color3.fromRGB(255,255,255)


replicatedStorage.OpenShop.OnClientEvent:Connect(function()
		
		camera.CameraType = "Scriptable"
		
		for i = 1, 0, -0.1 do
			blackBG.BackgroundTransparency = i
			wait(0.05)
		end
		
		wait(0.2)
		
	camera:Interpolate(itemRoller["Box0"].CamPart.CFrame,itemRoller["Box0"].Hitbox.CFrame,0.1)
	
	shopFrame.Visible = true
	
	script.Parent.initiateShop:Fire()
	
	wait(0.2)
	
	for i = 0,1, 0.1 do
		blackBG.BackgroundTransparency = i
		wait(0.05)
	end
	
	
end)

script.Parent.initiateShop.Event:Connect(function()
	
	local boxName = currentBox
	boxName.Value = 0
	
	back.ImageColor3 = DISABLED_BUTTON_COLOR
	forward.ImageColor3 = ENABLED_BUTTON_COLOR
	
	local model = nil
	
	for i, object in pairs(itemRoller["Box"..boxName.Value]:GetChildren())do
		if object:IsA("Model") then
			model = object
			shopFrame.ModelName.Value = object.Name
		end
	end
	
	local data = replicatedStorage.RequestInformation:InvokeServer(model)	
	
	
	for i, v in pairs(data)do
		print(v)
	end 
	
title.Text = tostring(data[1])
description.Text = tostring(data[2])

if data[5] == false then
	--havent bought it yet
	buy.Text = "$".. tostring(data[3])
else
	--has been bought
	if player.Equipped.Value == model.Name then
		buy.Text = "Equipped"
	else
		buy.Text = "Equip"
	end
end

	
end)

replicatedStorage.PlayerReset.OnClientEvent:Connect(function()
	shopFrame.Visible = false
	currentBox.Value = 0
	shopFrame.ModelName.Value = 0
	forward.ImageColor3 = ENABLED_BUTTON_COLOR
	back.ImageColor3 = ENABLED_BUTTON_COLOR
	wait(2)
	camera.CameraType = "Custom"
	game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
	player.inShop.Value = false
end)