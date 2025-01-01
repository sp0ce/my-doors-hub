local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local CurrentRooms = workspace:WaitForChild("CurrentRooms")

function AddHighlight(Part: BasePart, Color: Color3)
	if Part and not Part:FindFirstChild("Highlight") then
		local Highlight = Instance.new("Highlight", Part)
		Highlight.FillColor = Color
		Highlight.OutlineColor = Color
	end
end

function RoomScan(Room: Model)
	pcall(function()
		for _, v in pairs(Room:GetChildren()) do
			if v.Name == "Door" then
				Test(v:FindFirstChild("Door"), Color3.new(1, 1, 1))
			elseif v.Name == "Assets" then
				for _, v in pairs(v:GetDescendants()) do
					if v.Name == "ChestBox" then
						Test(v.Main, Color3.new(1, 1, 1))
					elseif v.Name == "ChestBoxLocked" then
						Test(v.Main, Color3.new(1, 1, 1))
					elseif v.Name == "KeyObtain" then
						Test(v.Hitbox, Color3.new(1, 1, 1))
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
