local ServerStorage = game:GetService("ServerStorage")
local DataStore2 = require(game.ServerScriptService:WaitForChild("MainModule"))
team1 = game.Teams["Fighters"]
team2 = game.Teams["Boss"]

local aura = ServerStorage.BossSkins.ZombieSkin.Aura
local dagger = ServerStorage.Weapons.ZombieDagger 

local function getPlayerFromCharacter(character)
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Character == character then
			return player
		end
	end
end

local function getPlayerName(array, name)
		--This function looks through the array and returns the index at which the given value is located at
		for currentIndex = 1, #array do
		if array[currentIndex] == name then
			return currentIndex
		end
	end			
		end

game.Players.PlayerAdded:connect(function(Player) --Just a way for me to get the Player.
	Player.CharacterAdded:connect(function(Character) --Just a way for me to get the Player's Character.
	
		repeat wait() until Character:FindFirstChild("Humanoid") ~= nil --Wait's for the Player's humanoid. The basis to a Character's health.
		Character.Humanoid.Died:connect(function() --Called when a Player dies.
		
		local creator = Character.Humanoid:FindFirstChild("creator")
		if creator and creator.ClassName == "ObjectValue" then
		local killer = creator.Value
		local creditsDataStore = DataStore2("credits", killer)
		
		
		if killer.isZombie.Value then
		creditsDataStore:Increment(1,0)
		end
		
		if killer.isBoss.Value then
			creditsDataStore:Increment(3,0)
		end
		
		if not killer.isBoss.Value and not killer.isZombie.Value then
			if Player.isBoss.Value then
				creditsDataStore:Increment(10,0)
			else
					creditsDataStore:Increment(2,0)
			end
		end
	end
	
	
		if Player.GameActive.Value then
			wait(3)
			Player:LoadCharacter()
			Player.TeamColor = game.Teams.Boss.TeamColor --Changes the player's team, on death
			
			if not Player.isZombie.Value then
				Player.isZombie.Value = true
			end
			
				for _, child in pairs(Player.Character:GetChildren()) do
    				if child:IsA("Accessory") then
      					  child:Destroy()
   					 end
				end
			
			Player.Character["Body Colors"].LeftArmColor = BrickColor.new("Moss")
			Player.Character["Body Colors"].LeftLegColor = BrickColor.new("Moss")
			Player.Character["Body Colors"].RightArmColor = BrickColor.new("Moss")
			Player.Character["Body Colors"].RightLegColor = BrickColor.new("Moss")
			Player.Character["Body Colors"].TorsoColor = BrickColor.new("Moss")
			Player.Character["Body Colors"].HeadColor = BrickColor.new("Moss")
			aura:Clone().Parent = Player.Character
			dagger:Clone().Parent = Player.Backpack
			
			end
		end)
	end)
end)