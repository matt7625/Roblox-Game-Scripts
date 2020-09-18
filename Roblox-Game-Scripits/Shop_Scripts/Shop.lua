local DataStore2 = require(game.ServerScriptService:WaitForChild("MainModule"))
local ServerStorage = game:GetService("ServerStorage")

game.ReplicatedStorage:WaitForChild("RequestInformation").OnServerInvoke = function(plr,item)
	local data = {}
	local bought = false
	local description = game.ServerStorage.UnlockableArmor[item.Name].Information.Description.Value
	local title = item.Name
	local cost = game.ServerStorage.UnlockableArmor[item.Name].Information.Cost.Value
	local costType = game.ServerStorage.UnlockableArmor[item.Name].Information.CostType.Value
	
	
	--may have to change this so we can properly see if they have bought the item
	if game.ServerStorage.PlayerTools[plr.Name]:FindFirstChild(item.Name)then
		--They have bought it
		bought = true
	else
		bought = false
	end
	
	
	table.insert(data,1,title)
	table.insert(data,2,description)
	table.insert(data,3,cost)
	table.insert(data,4,costType)
	table.insert(data,5,bought)
	
	return data
end  

game.ReplicatedStorage.CreateTransaction.OnServerInvoke = function(player, item) --item name, not object
	local money = game.Players:FindFirstChild(player.Name).leaderstats.Credits
	local cost = game.ServerStorage.UnlockableArmor[item].Information.Cost
	local creditsDataStore = DataStore2("credits", player)
	local rankDataStore = DataStore2("rank", player)
	--Added in
	local rank = player.leaderstats.Rank
	local function rankUpdate(updatedValue)
		rank.Value = rankDataStore:Get(updatedValue)
	end
	
	
	
	if money.Value >= cost.Value and not game.ServerStorage.PlayerTools[player.Name]:FindFirstChild(item) then 
		--The player has enough money and doesnt already own it.
		creditsDataStore:Increment(-cost.Value) --They purchase it
		
	
		
		player.Equipped.Value = item --Meaning this is the name of the current set of armor equipped
		local rank = game.ServerStorage.UnlockableArmor:FindFirstChild(item):clone()
		rank.Parent = game.ServerStorage.PlayerTools[player.Name] -- giving that rank/armor set to the person
		
		wait()
	for _, child in pairs(player.Character:GetChildren()) do
    	if child:IsA("Accessory") then
       		child:Destroy()
    	end
	end
	
	local hat = ServerStorage.UnlockableArmor[item].Hat 
	local rightshoulder = ServerStorage.UnlockableArmor[item].RightShoulder
	local leftshoulder = ServerStorage.UnlockableArmor[item].LeftShoulder
	local upperchest = ServerStorage.UnlockableArmor[item].Chest

	hat:Clone().Parent = player.Character
	rightshoulder:Clone().Parent = player.Character
	leftshoulder:Clone().Parent = player.Character
	upperchest:Clone().Parent = player.Character
	
	player.Character["Body Colors"].LeftArmColor = BrickColor.new(ServerStorage.UnlockableArmor[item].Information.ArmColor.Value)
	player.Character["Body Colors"].LeftLegColor = BrickColor.new(ServerStorage.UnlockableArmor[item].Information.LegColor.Value)
	player.Character["Body Colors"].RightArmColor = BrickColor.new(ServerStorage.UnlockableArmor[item].Information.ArmColor.Value)
	player.Character["Body Colors"].RightLegColor = BrickColor.new(ServerStorage.UnlockableArmor[item].Information.LegColor.Value)
	player.Character["Body Colors"].TorsoColor = BrickColor.new(ServerStorage.UnlockableArmor[item].Information.TorsoColor.Value)
	--player.Character["Body Colors"].HeadColor = BrickColor.new(ServerStorage.UnlockableArmor[item].Information.ArmColor.Value)
	
	
	rankUpdate(item.Name)
	player.leaderstats.Rank.Value = item
	
	return true 
	
	elseif cost.Value > money.Value and not game.ServerStorage.PlayerTools[player.Name]:FindFirstChild(item) then
		--They do not have enough money
		return "not enough credits"
	else
		return "already bought" --error message 
	end
end
	
	
game.ReplicatedStorage.GetToolsBought.OnServerInvoke = function(player)
	
	local armor ={}
	
	for i,tool in pairs(game.ServerStorage.PlayerTools[player.Name]:GetChildren()) do
		table.insert(armor, tool.Name)
	end
	return armor
end

game.ReplicatedStorage.EquipTool.OnServerEvent:Connect(function(player, toolName)
	
	
		--Destroys all their accesories
	wait()
	for _, child in pairs(player.Character:GetChildren()) do
    	if child:IsA("Accessory") then
       		child:Destroy()
    	end
	end
	
	
	player.Equipped.Value = toolName
	wait()
		
	local hat = ServerStorage.UnlockableArmor[toolName].Hat 
	local rightshoulder = ServerStorage.UnlockableArmor[toolName].RightShoulder
	local leftshoulder = ServerStorage.UnlockableArmor[toolName].LeftShoulder
	local upperchest = ServerStorage.UnlockableArmor[toolName].Chest
	
	hat:Clone().Parent = player.Character
	rightshoulder:Clone().Parent = player.Character
	leftshoulder:Clone().Parent = player.Character
	upperchest:Clone().Parent = player.Character
	
	player.Character["Body Colors"].LeftArmColor = BrickColor.new(ServerStorage.UnlockableArmor[item].Information.ArmColor.Value)
	player.Character["Body Colors"].LeftLegColor = BrickColor.new(ServerStorage.UnlockableArmor[item].Information.LegColor.Value)
	player.Character["Body Colors"].RightArmColor = BrickColor.new(ServerStorage.UnlockableArmor[item].Information.ArmColor.Value)
	player.Character["Body Colors"].RightLegColor = BrickColor.new(ServerStorage.UnlockableArmor[item].Information.LegColor.Value)
	player.Character["Body Colors"].TorsoColor = BrickColor.new(ServerStorage.UnlockableArmor[item].Information.TorsoColor.Value)
	wait()

end)

game.ReplicatedStorage.CloseShop.OnServerEvent:Connect(function(player)
 	player.Character.Humanoid.WalkSpeed = 16
	player.inShop.Value = false
end)