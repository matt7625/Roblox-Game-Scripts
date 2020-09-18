script.Parent.MouseButton1Click:Connect(function()
	
	script.Parent.Parent.Visible = false
	script.Parent.Parent.Parent.CurrentBox.Value = 0
	script.Parent.Parent.ModelName.Value = 0
	script.Parent.Parent.Forward.ImageColor3 = Color3.fromRGB(255,255,255)
	script.Parent.Parent.Back.ImageColor3 = Color3.fromRGB(255,255,255)
	
	game.Workspace.CurrentCamera.CameraType = "Custom"
	game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
	game.ReplicatedStorage.CloseShop:FireServer()
end)