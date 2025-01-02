local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local Character = Player.Character or Player.CharacterAdded:Wait()
local Root: BasePart = Character:WaitForChild("HumanoidRootPart")

local CurrentRooms = workspace:WaitForChild("CurrentRooms")

local GPSs = {}
local Clr = false

function Esp(Active, Part, Text, Color)
	local GPS = Part:FindFirstChild("ObjectGPS")
	if Active then
		if SH_ESPS_GPS_ENABLED then
			if not GPS then
				GPS = Instance.new("BillboardGui", Part)
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
				
				table.insert(GPSs, GPS)
			end
		else
			if GPS then
				GPS:Destroy()
			end
		end
	else
		if GPS then
			GPS:Destroy()
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
					pcall(function() Esp(SH_ESP_KEY, v.Hitbox, "Key", Color3.new(1, 1, 1)) end)
				elseif v.Name == "LeverForGate" then
					pcall(function() Esp(SH_ESP_LEVER, v.Main, "Lever", Color3.new(1, 1, 1)) end)
				elseif v.Name == "TimerLever" then
					pcall(function() Esp(SH_ESP_LEVER, v.Hitbox, "Lever", Color3.new(1, 1, 1)) end)
				elseif v.Name == "Lighter" then
					pcall(function() Esp(SH_ESP_LOOT, v.Handle, "Lighter", Color3.new(1, 1, 1)) end)
				elseif v.Name == "Smoothie" then
					pcall(function() Esp(SH_ESP_LOOT, v.Handle, "Smoothie", Color3.new(1, 1, 1)) end)
				elseif v.Name == "GlitchCube" then
					pcall(function() Esp(SH_ESP_LOOT, v.MainPart, "Glitch Fragment", Color3.new(1, 1, 1)) end)
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
		end
	end
end)
