local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local Character = Player.Character or Player.CharacterAdded:Wait()
local Root: BasePart = Character:WaitForChild("HumanoidRootPart")

local CurrentRooms = workspace:WaitForChild("CurrentRooms")

function AddHighlight(Part: BasePart, Color: Color3)
	if Part and not Part:FindFirstChild("Highlight") then
		local Highlight = Instance.new("Highlight", Part)
		Highlight.FillColor = Color
		Highlight.OutlineColor = Color
	end
end

function RemoveHighlight(Part: BasePart)
	local Highlight = Part:FindFirstChild("Highlight")
	if Highlight then
		Highlight:Destroy()
	end
end

function AddGps(Part: BasePart, Color: Color3, Text: string)
	if Part and not Part:FindFirstChild("BillboardGui") then
		local BillboardGui = Instance.new("BillboardGui", Part)
		BillboardGui.AlwaysOnTop = true
		BillboardGui.Size = UDim2.fromOffset(200, 50)
		
		local TextLabel = Instance.new("TextLabel", BillboardGui)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Size = UDim2.fromScale(1, .5)
		TextLabel.Font = Enum.Font.Oswald
		TextLabel.Text = Text
		TextLabel.TextColor3 = Color
		TextLabel.TextScaled = true
		TextLabel.TextStrokeTransparency = .8
		
		local DistanceLabel = Instance.new("TextLabel", BillboardGui)
		DistanceLabel.BackgroundTransparency = 1
		DistanceLabel.Position = UDim2.fromScale(0, .5)
		DistanceLabel.Size = UDim2.fromScale(1, .5)
		DistanceLabel.Font = Enum.Font.Oswald
		DistanceLabel.TextColor3 = Color
		DistanceLabel.TextScaled = true
		DistanceLabel.TextStrokeTransparency = .8
		
		RunService.RenderStepped:Connect(function()
			DistanceLabel.Text = math.round((Part.Position - Root.Position).Magnitude) .. "s"
		end)
	end
end

function RemoveGps(Part: BasePart)
	local BillboardGui = Part:FindFirstChild("BillboardGui")
	if BillboardGui then
		BillboardGui:Destroy()
	end
end

function RoomScan(Room: Model)
	pcall(function()
		for _, v in pairs(Room:GetChildren()) do
			if v.Name == "Door" then
				if SH_ESPS_DOORS and not v:GetAttribute("Opened") then
					AddHighlight(v.Door, Color3.new(1, 1, 1))
					AddGps(v.Door, Color3.new(1, 1, 1), "Door")
				else
					RemoveHighlight(v.Door)
					RemoveGps(v.Door)
				end
			elseif v.Name == "Assets" then
				for _, v in pairs(v:GetDescendants()) do
					if v.Name == "ChestBox" then
						AddHighlight(v.Main, Color3.new(1, 1, 1))
					elseif v.Name == "ChestBoxLocked" then
						AddHighlight(v.Main, Color3.new(1, 1, 1))
					elseif v.Name == "KeyObtain" then
						if SH_ESPS_KEYS then
							AddHighlight(v, Color3.new(1, 1, 1))
							AddGps(v.Hitbox, Color3.new(1, 1, 1), "Key")
						else
							RemoveHighlight(v)
							RemoveGps(v.Hitbox)
						end
					elseif v.Name == "Flashlight" then
						AddHighlight(v, Color3.new(1, 1, 1))
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
