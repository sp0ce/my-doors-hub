local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local Character = Player.Character or Player.CharacterAdded:Wait()
local Root: BasePart = Character:WaitForChild("HumanoidRootPart")

local CurrentRooms = workspace:WaitForChild("CurrentRooms")

local GPSs = {}
local HLs = {}
local Clr = false

function Esp(Active, Object1, Object2, Text, Color)
	local GPS = Object1:FindFirstChild("ObjectGPS")
	local HL = Object2:FindFirstChild("ObjectHL")
	if Active then
		if SH_ESPS_GPS_ENABLED then
			if not GPS then
				GPS = Instance.new("BillboardGui", Object1)
				GPS.AlwaysOnTop = true
				GPS.Size = UDim2.fromOffset(200, 50)
				GPS.Name = "ObjectGPS"

				local TL = Instance.new("TextLabel", GPS)
				TL.BackgroundTransparency = 1
				TL.Size = UDim2.fromScale(1, .5)
				TL.Font = Enum.Font.Oswald
				TL.Text = Text
				TL.TextColor3 = Color
				TL.TextScaled = true
				TL.TextStrokeTransparency = .8

				local DL = Instance.new("TextLabel", GPS)
				DL.BackgroundTransparency = 1
				DL.Position = UDim2.fromScale(0, .5)
				DL.Size = UDim2.fromScale(1, .5)
				DL.Font = Enum.Font.Oswald
				DL.TextColor3 = Color
				DL.TextScaled = true
				DL.TextStrokeTransparency = .8

				RunService.RenderStepped:Connect(function()
					DL.Text = math.round((Object1.Position - Root.Position).Magnitude) .. "s"
				end)
				
				GPS:GetPropertyChangedSignal("Parent"):Once(function()
					GPS:Destroy()
				end)
				
				table.insert(GPSs, GPS)
			end
		else
			if GPS then
				GPS:Destroy()
			end
		end
		if SH_ESPS_HL_ENABLED then
			if not HL then
				HL = Instance.new("Highlight", Object2)
				HL.FillColor = Color
				HL.OutlineColor = Color
				HL.Name = "ObjectHL"
				
				HL:GetPropertyChangedSignal("Parent"):Once(function()
					HL:Destroy()
				end)
				
				table.insert(HLs, HL)
			end
		else
			if HL then
				HL:Destroy()
			end
		end
	else
		if GPS then
			GPS:Destroy()
		end
		if HL then
			HL:Destroy()
		end
	end
end

function RoomScan(Room: Model)
	for i, v in pairs(Room:GetChildren()) do
		if v.Name == "Door" then
			pcall(function() Esp(SH_ESP_DOOR, v.Collision, v.Door, "Door", Color3.new(1, 1, 1)) end)
		elseif v.Name == "Assets" then
			for i, v in pairs(v:GetDescendants()) do
				if v.Name == "KeyObtain" then
					pcall(function() Esp(SH_ESP_KEY, v.Hitbox, v, "Key", Color3.new(1, 1, 1)) end)
				elseif v.Name == "LeverForGate" then
					pcall(function() Esp(SH_ESP_LEVER, v.Main, v.Main, "Lever", Color3.new(1, 1, 1)) end)
				elseif v.Name == "TimerLever" then
					pcall(function() Esp(SH_ESP_LEVER, v.Hitbox, v, "Lever", Color3.new(1, 1, 1)) end)
				elseif v.Name == "Lighter" then
					pcall(function() Esp(SH_ESP_LOOT, v.Handle, v, "Lighter", Color3.new(1, 1, 1)) end)
				elseif v.Name == "Smoothie" then
					pcall(function() Esp(SH_ESP_LOOT, v.Handle, v, "Smoothie", Color3.new(1, 1, 1)) end)
				elseif v.Name == "GlitchCube" then
					pcall(function() Esp(SH_ESP_LOOT, v.MainPart, v, "Glitch Fragment", Color3.new(1, 1, 1)) end)
				end
			end
		elseif v.Name == "Sideroom" then
			RoomScan(v)
		end
	end
end

task.spawn(function()
	while task.wait(.5) do
		if SH_ESPS_ENABLED then
			Clr = false
			for i, v in pairs(CurrentRooms:GetChildren()) do
				RoomScan(v)
			end
		elseif Clr == false then
			Clr = true
			for i, v in pairs(GPSs) do
				if v then
					v:Destroy()
				end
			end
			for i, v in pairs(HLs) do
				if v then
					v:Destroy()
				end
			end
		end
	end
end)
