local replicatedStorage = game:GetService("ReplicatedStorage")
local gui = script.Parent.Parent.Parent
local frame = gui:WaitForChild("ShopFrame")
local buy = frame:WaitForChild("Buy")
local title = frame:WaitForChild("Title")
local description = frame:WaitForChild("Description")
local back = frame:WaitForChild("Back")
local DISABLED_BUTTON_COLOR = Color3.fromRGB(118, 110, 153)
local ENABLED_BUTTON_COLOR = Color3.fromRGB(255,255,255)
local itemRoller = game.Workspace.ItemRoller

script.Parent.Activated:Connect(function()

	local boxName = script.Parent.Parent.Parent.CurrentBox
	local boxToMoveTo = boxName.Value + 1
	
	if game.Workspace.ItemRoller:FindFirstChild("Box"..boxToMoveTo) then
		-- There is a box for when we click the back button
		script.Parent.ImageColor3 = ENABLED_BUTTON_COLOR
		back.ImageColor3 = ENABLED_BUTTON_COLOR
		game.Workspace.CurrentCamera:Interpolate(game.Workspace.ItemRoller["Box"..boxToMoveTo].CamPart.CFrame,game.Workspace.ItemRoller["Box"..boxToMoveTo].Hitbox.CFrame,0.5) 
		boxName.Value = boxName.Value + 1
		
		
		local model = nil
	
		for i, object in pairs(itemRoller["Box"..boxName.Value]:GetChildren()) do
			
			if object:IsA("Model") then
				model = object
				frame.ModelName.Value = object.Name
			end
			
		end
		
		local data = replicatedStorage.RequestInformation:InvokeServer(model)
		
		for i, v in pairs(data) do
			print(v)
		end
		
		title.Text = tostring(data[1])
		description.Text = tostring(data[2])
		
		if data[5] == false then
			buy.Text = "$"..tostring(data[3])
		end
		
	else
		
		script.Parent.ImageColor3 = DISABLED_BUTTON_COLOR
		
		
		end
	
	if game.Workspace.ItemRoller:FindFirstChild("Box"..boxToMoveTo+1) then
		script.Parent.ImageColor3 = ENABLED_BUTTON_COLOR
	else
		script.Parent.ImageColor3 = DISABLED_BUTTON_COLOR
		back.ImageColor3 = ENABLED_BUTTON_COLOR
	end



end)