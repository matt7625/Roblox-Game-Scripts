local DataStore2 = require(game.ServerScriptService:WaitForChild("MainModule"))
local ServerStorage = game:GetService("ServerStorage")
local defaultValue = 0
local defaultRank = "Unranked"

game.Players.PlayerAdded:connect(function(player)

	local playerToolsFolder = Instance.new("Folder")
	playerToolsFolder.Name = player.Name
	playerToolsFolder.Parent = game.ServerStorage.PlayerTools
	
	local equipped = Instance.new("StringValue")
	equipped.Name = "Equipped"
	equipped.Parent = player
	
	local inShop = Instance.new("BoolValue")
	inShop.Name = "inShop"
	inShop.Value = false
	inShop.Parent = player
	
	local GameActive = Instance.new("BoolValue")
	GameActive.Parent = player
	GameActive.Name = "GameActive"
	wait()
	player.GameActive.Value = false
	
	local isZombie = Instance.new("BoolValue")
	isZombie.Parent = player
	isZombie.Name = "isZombie"
	wait()
	player.isZombie.Value = false
	
	local isBoss = Instance.new("BoolValue")
	isBoss.Parent = player
	isBoss.Name = "isBoss"
	wait()
	player.isBoss.Value = false

	local isInGame = Instance.new("BoolValue")
	isInGame.Parent = player
	isInGame.Name = "isInGame"
	wait()
	player.isInGame.Value = false
	
	game.ReplicatedStorage.PlayerReset:FireClient(player)
	player.inShop.Value = false
	

	
	--This should check the rankStore datastore to see if the player already has a prexisting
	--rank. If so it gives them that rank. Otherwise it makes them Unranked and saves that to
	--the datastore
	
	local creditsDataStore = DataStore2("credits",player)
	
	local leaderstats = Instance.new("Folder",player)
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local credits = Instance.new("IntValue", leaderstats)
	credits.Name = "Credits"
	credits.Parent = leaderstats
	
	local function creditsUpdate(updatedValue)
		credits.Value = creditsDataStore:Get(updatedValue)
	end
	
	creditsUpdate(defaultValue)
	
	creditsDataStore:OnUpdate(creditsUpdate)
	
	
	local rankDataStore = DataStore2("rank", player)
	
	local rank = Instance.new("StringValue", leaderstats)
	rank.Name = "Rank"
	
	
	local function rankUpdate(updatedValue)
		rank.Value = rankDataStore:Get(updatedValue)
	end
	
	rankUpdate(defaultRank)
	
	
	--Does the same as above but with currency
	wait()

	
	if player.leaderstats.Rank.Value ~= "Unranked" then
	
	local hat = ServerStorage.UnlockableArmor[player.leaderstats.Rank.Value].Hat
	local rightshoulder = ServerStorage.UnlockableArmor[player.leaderstats.Rank.Value].RightShoulder
    local leftshoulder = ServerStorage.UnlockableArmor[player.leaderstats.Rank.Value].LeftShoulder
	local upperchest = ServerStorage.UnlockableArmor[player.leaderstats.Rank.Value].Chest
	
	
	hat:Clone().Parent = player.Character
	rightshoulder:Clone().Parent = player.Character
	leftshoulder:Clone().Parent = player.Character
	upperchest:Clone().Parent = player.Character
	
	player.Character["Body Colors"].LeftArmColor = BrickColor.new(ServerStorage.UnlockableArmor[player.leaderstats.Rank.Value].Information.ArmColor.Value)
	player.Character["Body Colors"].LeftLegColor = BrickColor.new(ServerStorage.UnlockableArmor[player.leaderstats.Rank.Value].Information.LegColor.Value)
	player.Character["Body Colors"].RightArmColor = BrickColor.new(ServerStorage.UnlockableArmor[player.leaderstats.Rank.Value].Information.ArmColor.Value)
	player.Character["Body Colors"].RightLegColor = BrickColor.new(ServerStorage.UnlockableArmor[player.leaderstats.Rank.Value].Information.LegColor.Value)
	player.Character["Body Colors"].TorsoColor = BrickColor.new(ServerStorage.UnlockableArmor[player.leaderstats.Rank.Value].Information.TorsoColor.Value)
	
	end	
end)
