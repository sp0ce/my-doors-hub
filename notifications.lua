local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local AchievementsHolder = Player.PlayerGui:WaitForChild("MainUI"):WaitForChild("AchievementsHolder")
local AchievementTemplate = AchievementsHolder:WaitForChild("Achievement"):Clone()

function EntityNotification(Icon: string, Title: string, Desc: string, Reason: string)
	local Notification: Frame = AchievementTemplate:Clone()
	Notification.Parent = AchievementsHolder
	Notification.Visible = true
	
	Notification.Frame.Position = UDim2.fromScale(1.5, 0)
	
	Notification.Frame.UIStroke.Color = Color3.fromHSV(0, .8, 1)
	
	Notification.Frame.Glow.ImageColor3 = Color3.fromHSV(0, .8, 1)
	
	Notification.Frame.TextLabel.Text = "ENTITY SPAWNED"
	Notification.Frame.TextLabel.TextColor3 = Color3.fromHSV(0, .8, 1)
	
	Notification.Frame.ImageLabel.Image = Icon
	
	Notification.Frame.Details.Title.Text = Title
	Notification.Frame.Details.Title.TextColor3 = Color3.fromHSV(0, .8, 1)
	
	Notification.Frame.Details.Desc.Text = Desc
	Notification.Frame.Details.Desc.TextColor3 = Color3.fromHSV(0, .8, 1)
	
	Notification.Frame.Details.Reason.Text = Reason
	Notification.Frame.Details.Reason.TextColor3 = Color3.fromHSV(0, .8, 1)
	
	TweenService:Create(Notification.Frame, TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0, 0)}):Play()
	TweenService:Create(Notification.Frame.Glow, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
	Notification.Sound:Play()
	task.wait(4)
	TweenService:Create(Notification.Frame, TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.In), {Position = UDim2.fromScale(1.5, 0)}):Play()
	task.wait(1)
	Notification:Destroy()
end

workspace.ChildAdded:Connect(function(Child)
	if Child.Name == "RushMoving" then
		EntityNotification("", "Rush", "", "")
	end
end)
