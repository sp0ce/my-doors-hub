local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local Character = Player.Character or Player.CharacterAdded:Wait()
local Root: BasePart = Character:WaitForChild("HumanoidRootPart")

local CurrentRooms = workspace:WaitForChild("CurrentRooms")

function Esp(Active, Object1, Object2, Text, Color)
	local GPS = Object1:FindFirstChild("ObjectGPS")
	local HL = Object2:FindFirstChild("ObjectHL")
	if Active then
		if SH_ESPS_HL_ENABLED then
			if not HL then
				HL = Instance.new("Highlight", Object2)
				HL.FillColor = Color
				HL.OutlineColor = Color
				HL.Name = "ObjectHL"
			end
			if not GPS then
				GPS = Instance.new("BillboardGui", Object1)
				GPS.AlwaysOnTop = true
				GPS.Size = UDim2.fromOffset(200, 50)

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
			end
		else
			if HL then
				HL:Destroy()
			end
			if GPS then
				GPS:Destroy()
			end
		end
	else
		if HL then
			HL:Destroy()
		end
		if GPS then
			GPS:Destroy()
		end
	end
end

function RoomScan(Room: Model)
	pcall(function()
		for _, v in pairs(Room:GetChildren()) do
			if v.Name == "Door" then
				Esp(SH_ESP_DOOR and not v:GetAttribute("Opened"), v.Door, v.Door, "Door", Color3.new(1, 1, 1))
			elseif v.Name == "Assets" then
				for _, v in pairs(v:GetDescendants()) do
					if v.Name == "KeyObtain" then
						Esp(SH_ESP_KEY, v.Hitbox, v, "Key", Color3.new(1, 1, 1))
					elseif v.Name == "LeverForGate" then
						Esp(SH_ESP_LEVER, v.Main, v.Main, "Lever", Color3.new(1, 1, 1))
					end
				end
			elseif v.Name == "Sideroom" then
				RoomScan(v)
			end
		end
	end)
end

while task.wait(.5) do
	if SH_ESPS_ENABLED then
		for i, v in pairs(CurrentRooms:GetChildren()) do
			RoomScan(v)
		end
	end
end
