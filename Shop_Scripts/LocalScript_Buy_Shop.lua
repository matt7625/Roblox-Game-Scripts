local modelName = script.Parent.Parent.ModelName
local boxName = script.Parent.Parent.Parent.CurrentBox
local player = game.Players.LocalPlayer
local ServerStorage = game:GetService("ServerStorage")

script.Parent.MouseButton1Click:Connect(function()

	local outcome = game.ReplicatedStorage.CreateTransaction:InvokeServer(modelName.Value)
	
	if outcome == true then
		
		-- Purchase was successful
		
		script.Parent.Text = "Equip"
	
	elseif outcome == "not enough credits" then
		-- They do not have enough cash
	elseif outcome == "already bought" then
		if game.Players.LocalPlayer.Equipped.Value ~= modelName.Value then
			game.ReplicatedStorage.EquipTool:FireServer(modelName.Value)
			script.Parent.Text = "Equipped"
		end
	end

end)
	
	
boxName:GetPropertyChangedSignal("Value"):Connect(function()
	
	local model = nil
	
	for i, object in pairs(game.Workspace.ItemRoller["Box"..boxName.Value]:GetChildren()) do
	
		if object:IsA("Model") then
			model = object -- Swtting the model variable to the object
		end
	
	end
	
	local toolsBought = game.ReplicatedStorage.GetToolsBought:InvokeServer()
	
	for i, tool in pairs(toolsBought) do
		
		if tool == model.Name then
			-- Already bought by the player
			
			script.Parent.Text = "Equipped"
		else
			script.Parent.Text = "Equip"
			
		end	
	end
end)