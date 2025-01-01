local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local CurrentRooms = workspace:WaitForChild("CurrentRooms")

function Test(Part: BasePart, Color: Color3)
	if not Part:FindFirstChild("Highlight") then
		local Highlight = Instance.new("Highlight", Part)
		Highlight.FillColor = Color
		Highlight.OutlineColor = Color
	end
end

function RoomScan(Room: Model)
	for _, v in pairs(Room:GetChildren()) do
		if v.Name == "Door" then
			Test(v:FindFirstChild("Door"), Color3.new(1, 1, 1))
		elseif v.Name == "Assets" then
			for _, v in pairs(v:GetDescendants()) do
				if v.Name == "ChestBox" then
					Test(v:FindFirstChild("Main"), Color3.new(1, 1, 1))
				elseif v.Name == "ChestBoxLocked" then
					Test(v:FindFirstChild("Main"), Color3.new(1, 1, 1))
				elseif v.Name == "KeyObtain" then
					local a = v:FindFirstChild("Hitbox")
					if a then
						Test(a:FindFirstChild("Key"), Color3.new(1, 1, 1))
					end
				end
			end
		elseif v.Name == "Sideroom" then
			RoomScan(v)
		end
	end
end

while task.wait(.5) do
	for i, v in pairs(CurrentRooms:GetChildren()) do
		RoomScan(v)
	end
end
