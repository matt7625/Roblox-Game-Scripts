
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local MapsFolder = ServerStorage:WaitForChild("Maps")
local Status = ReplicatedStorage:WaitForChild("Status")
local players = game:GetService("Players")
local Teams = game:GetService("Teams"):GetTeams()
local DataStore2 = require(game.ServerScriptService:WaitForChild("MainModule"))
local Fighters = Teams[2]
local Boss = Teams[1] 
local Neutral = Teams[3]
_G.fig = {} --active fighters in game (global)
local Boss_Alive = false


--Game Variables
local GameTime = 100
local HideTime = 2
local LobbyTimer = 10
local zero = 0
local BossWinReward = 15
local FighterWinReward = 30



--Functions
local function Respawn()
	 for i, player in ipairs(game.Players:GetPlayers()) do
            if player.Character then
                local hum = player.Character:FindFirstChild('Humanoid')
				player.isZombie.Value = false
				player.isBoss.Value = false
                if hum then
					if player.isInGame.Value then
                	player:LoadCharacter()
					player.isInGame.Value = false
                end	          
		  end
	    end
end
end

local function removeWeapons()
	 for i, player in ipairs(game.Players:GetPlayers()) do
            if player.Character then
                player.character.Humanoid:UnequipTools()
				local c = player.Backpack:GetChildren()
				for i = 1, #c do
					c[i]:Destroy()
		  end
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
		
local function getPlayerId(player)
	return player.UserId
end
		
local function setTeam(player, teamName)
	--This function sets the team of the player to the given teamname
    wait()
    player.TeamColor = game.Teams[teamName].TeamColor
    player.Team = game.Teams[teamName]
    wait()
    
       if player.Character then    
        --player.Character:BreakJoints() -- Kills the players' character
       end  
end

function makeFighters()
	--This function sets everyone in the game to fighters
	for i, player in pairs(game.Players:GetPlayers()) do
		setTeam(player, "Fighters")
		table.insert(_G.fig, player) --adds all fighters to the "fig" table
		player.isInGame.Value = true
	end
end

function giveGuns()
	local pistol = ServerStorage.Weapons.Pistol
	local shotgun = ServerStorage.Weapons.Shotgun
	for i, player in pairs(game.Teams["Fighters"]:GetPlayers())do
	pistol:Clone().Parent = player.Backpack
	shotgun:Clone().Parent = player.Backpack
	end
end
	
function makeNeutral(player)
	for i, player in pairs(game.Players:GetPlayers()) do
		setTeam(player, "Neutral")
	end	
end
	

local function chooseBoss()
	
	--This function randomly chooses a boss from players in the game and removes them from the active fighter array
    Status.Value = "Choosing Boss..."   
    wait(3)
	
   	local Boss_Player = game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())]
	Status.Value = Boss_Player.Name .. " is the Boss!!" 
	Boss_Player.isBoss.Value= true
	wait(2) 
		Boss_Character = Boss_Player.character
	 --Destory the Bosses backpack
	Boss_Character.Humanoid:UnequipTools()
	local c = Boss_Player.Backpack:GetChildren()
	for i =1, #c do 
		c[i]:Destroy()
	end
	
    setTeam(Boss_Player, "Boss")
    Status.Value = "Game Starting... Teleporting"   

	local Boss_Name = Boss_Player.Name

	local temp = getPlayerName(_G.fig, Boss_Player.Name)
	table.remove(_G.fig,temp)
	
	for _, child in pairs(Boss_Character:GetChildren()) do
    if child:IsA("Accessory") then
        child:Destroy()
    end
end
	
	BossSize(Boss_Player)
local hat = ServerStorage.BossSkins.Boss.Hat
local rightshoulder = ServerStorage.BossSkins.Boss.RightShoulder
local leftshoulder = ServerStorage.BossSkins.Boss.LeftShoulder
local upperchest = ServerStorage.BossSkins.Boss.Chest

hat:Clone().Parent = Boss_Player.Character
rightshoulder:Clone().Parent = Boss_Player.Character
leftshoulder:Clone().Parent = Boss_Player.Character
upperchest:Clone().Parent = Boss_Player.Character

Boss_Character["Body Colors"].LeftArmColor = BrickColor.new("Black")
Boss_Character["Body Colors"].LeftLegColor = BrickColor.new("Black")
Boss_Character["Body Colors"].RightArmColor = BrickColor.new("Black")
Boss_Character["Body Colors"].RightLegColor = BrickColor.new("Black")
Boss_Character["Body Colors"].TorsoColor = BrickColor.new("Black")
Boss_Character["Body Colors"].HeadColor = BrickColor.new("Black")
local hammer = ServerStorage.Weapons.MyHammer
hammer:Clone().Parent = Boss_Player.Backpack

end
	
	

--Have to change this function
function BossSize(player)
 
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        if humanoid:FindFirstChild("BodyHeightScale") then
            humanoid.BodyHeightScale.Value = 2.5  
        end
        if humanoid:FindFirstChild("BodyWidthScale") then
            humanoid.BodyWidthScale.Value = 2
        end
        if humanoid:FindFirstChild("BodyDepthScale") then
            humanoid.BodyDepthScale.Value = 2
        end
        if humanoid:FindFirstChild("HeadScale") then
            humanoid.HeadScale.Value = 1.5

		humanoid.WalkSpeed = 16
		humanoid.MaxHealth = 1000
		humanoid.Health = 1000
       end
	end
end

--Game Loop

while true do
	  Status.Value = "Waiting for enough players"
	  repeat wait(1) until game.Players.NumPlayers >= 1 --CHANGE BACK TO 2
	
	--Timer begins to go down once more than 2 players are in the server
	 for i = LobbyTimer,0,-1 do
        wait(1) 
        Status.Value = "Game starting in "..i.." seconds"   
    end
	local plrs = {}
	
	--Add each player into the plrs table (making them accessible)
	for i, player in pairs(game.Players:GetPlayers()) do
		if player then
			table.insert(plrs,player) 
		end
	end
	wait(1)
	Status.Value = "Choosing Map....."
	
	-- Choosing a random map from the mapsfolder --
	local AvaiableMaps = MapsFolder:GetChildren()
	local ChosenMap = AvaiableMaps[math.random(1,#AvaiableMaps)]
	Status.Value = ChosenMap.Name.." Chosen"
	local ClonedMap = ChosenMap:Clone()
	ClonedMap.Parent = workspace.MapsinGame
	
	--Turn entire lobby into fighters
	makeFighters()
	
	
	wait(4)
	
	-- Teleport players to the map --
	Status.Value = "Teleporting..."
	
	local SpawnPoints = ClonedMap:FindFirstChild("SpawnPoints")

	for i,v in pairs(game.Teams["Fighters"]:GetPlayers()) do
	if not SpawnPoints then
		print("Spawnpoints not found!")
	end
	
	local AvailableSpawnPoints = ClonedMap.SpawnPoints:GetChildren()
	
	for i, player in pairs(plrs) do
		if player then
			character = player.Character
			
			if character then
				character:FindFirstChild("HumanoidRootPart").CFrame = AvailableSpawnPoints[1].CFrame
				table.remove(AvailableSpawnPoints,1)
			end
		end
	end	
end 

	
	for i = HideTime,0,-1 do
		wait(1)
		Status.Value = "Boss Spawning in "..i.." seconds" 
	end
	
print(_G.fig)
	--Choose a random boss and teleports to the start
	chooseBoss()

	local bosses = {}
	
	for i, player in pairs(game.Teams["Boss"]:GetPlayers()) do
		if player then
			table.insert(bosses,player) 
		end
	end
	
	for i,v in pairs(game.Teams["Boss"]:GetPlayers()) do
	if not SpawnPoints then
		print("Spawnpoints not found!")
	end
	
	local AvailableSpawnPoints = ClonedMap.SpawnPoints:GetChildren()
	
		for i, player in pairs(bosses) do
			if player then
				character = player.Character
			
				if character then
					character:FindFirstChild("HumanoidRootPart").CFrame = AvailableSpawnPoints[1].CFrame
					table.remove(AvailableSpawnPoints,1)
				
				end
			end
		end	
	end 

	Boss_Alive = true
	
	--Putting everyone's gameactive values as true
	for i, player in pairs(game.Players:GetPlayers()) do
		player.GameActive.Value = true	
	end
	
	--Give Fighters guns
	giveGuns()
	
	--The game has begun
	for i = GameTime,0,-1 do
		wait(1)
		Status.Value = "Game in progress "..i.." seconds left"
		
		
		--If all fighters are dead
		local nfighters = Fighters:GetPlayers()
		if #nfighters == 0 then
			removeWeapons()
			Status.Value = "The Boss Wins!"
			
		for i, player in pairs(game.Players:GetPlayers()) do
			player.GameActive.Value = false
			local creditsDataStore = DataStore2("credits", player)
			
			if player.isBoss.Value then
				creditsDataStore:Increment(30,0)
			elseif player.isZombie.Value then
				creditsDataStore:Increment(15,0)
			end
		
		end
			removeWeapons()
			break
		end

		--If the boss dies the game ends
		Boss_Character.Humanoid.Died:connect(function()
			Boss_Alive = false
			end)
		
		if Boss_Alive == false then
			removeWeapons()
			Status.Value = "The Fighters Win!"
			
			for i, player in pairs(game.Players:GetPlayers()) do
			player.GameActive.Value = false
			
			if not player.isBoss.Value and not player.isZombie.Value then
			local creditsDataStore = DataStore2("credits", player)
			creditsDataStore:Increment(30,0)
			end
			
		end
			removeWeapons()
			break
		end
	
	end
	
	--Makes everyone no longer in the game
	
	
	makeNeutral()
	wait(2)
	Respawn()
	wait()
	Status.Value = "Game Over"
	

	workspace.MapsinGame:ClearAllChildren()
	wait()
end 