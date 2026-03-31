local ExoHubUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ExoHub Configuration - Fixed Black & Orange Theme
local Config = {
	Colors = {
		Background = Color3.fromRGB(0, 0, 0),        -- Pure black
		Secondary = Color3.fromRGB(15, 15, 15),      -- Dark gray/black
		Accent = Color3.fromRGB(255, 153, 0),        -- ExoHub Orange
		Accent2 = Color3.fromRGB(255, 102, 0),       -- Darker orange
		Text = Color3.fromRGB(255, 255, 255),        -- White
		Subtext = Color3.fromRGB(170, 170, 170),     -- Gray
		Border = Color3.fromRGB(40, 40, 40),         -- Dark border
		Success = Color3.fromRGB(0, 255, 128),
		Error = Color3.fromRGB(255, 50, 50),
		Warning = Color3.fromRGB(255, 200, 0)
	},
	Transparency = {
		Background = 0.05,
		Secondary = 0.1,
		Elements = 0.15,
		Stroke = 0.3,
		Accent = 0.9
	},
	Animation = {
		Smoothness = 0.1,
		Elastic = 0.15
	},
	ToggleKey = Enum.KeyCode.RightControl,
	Theme = "ExoHub"
}

local function Create(className, properties)
	local instance = Instance.new(className)
	for prop, value in pairs(properties or {}) do
		instance[prop] = value
	end
	return instance
end

local function Tween(instance, properties, duration, easingStyle, easingDirection)
	if not instance or not instance.Parent then return end
	local tween = TweenService:Create(
		instance,
		TweenInfo.new(duration or Config.Animation.Smoothness, easingStyle or Enum.EasingStyle.Quart, easingDirection or Enum.EasingDirection.Out),
		properties
	)
	tween:Play()
	return tween
end

local function CreateCorner(parent, radius)
	return Create("UICorner", {
		CornerRadius = UDim.new(0, radius or 8),
		Parent = parent
	})
end

local function CreateStroke(parent, color, thickness)
	return Create("UIStroke", {
		Color = color or Config.Colors.Border,
		Thickness = thickness or 1.5,
		Transparency = Config.Transparency.Stroke,
		Parent = parent
	})
end

-- Initialize notifications
local NotificationGui, NotificationContainer

local function InitNotifications()
	if NotificationGui and NotificationGui.Parent then return end
	
	NotificationGui = Create("ScreenGui", {
		Name = "ExoHubNotifications",
		Parent = PlayerGui,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})
	
	NotificationContainer = Create("Frame", {
		Name = "Container",
		Size = UDim2.new(0, 340, 1, 0),
		Position = UDim2.new(1, -360, 0, 20),
		BackgroundTransparency = 1,
		Parent = NotificationGui
	})
	
	Create("UIListLayout", {
		Padding = UDim.new(0, 12),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Parent = NotificationContainer
	})
end

ExoHubUI.Notify = function(notifyConfig)
	notifyConfig = notifyConfig or {}
	local Title = notifyConfig.Title or "ExoHub"
	local Content = notifyConfig.Content or "System notification"
	local Duration = notifyConfig.Duration or 8
	local Type = notifyConfig.Type or "Info"
	local ButtonText = notifyConfig.ButtonText or "Confirm"
	local Callback = notifyConfig.Callback or function() end
	
	local TypeColors = {
		Info = Config.Colors.Accent,
		Success = Config.Colors.Success,
		Error = Config.Colors.Error,
		Warning = Config.Colors.Warning
	}
	local AccentColor = TypeColors[Type] or Config.Colors.Accent
	
	InitNotifications()
	
	local NotifFrame = Create("Frame", {
		Name = "Notification",
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Config.Colors.Background,
		BackgroundTransparency = Config.Transparency.Background,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		ClipsDescendants = true,
		Parent = NotificationContainer
	})
	
	CreateCorner(NotifFrame, 12)
	CreateStroke(NotifFrame, AccentColor, 2)
	
	local Glow = Create("ImageLabel", {
		Size = UDim2.new(1, 40, 1, 40),
		Position = UDim2.new(0, -20, 0, -20),
		BackgroundTransparency = 1,
		Image = "rbxassetid://10822646395",
		ImageColor3 = AccentColor,
		ImageTransparency = 0.9,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(50, 50, 50, 50),
		Parent = NotifFrame
	})
	
	Create("Frame", {
		Size = UDim2.new(0, 3, 1, 0),
		BackgroundColor3 = AccentColor,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Parent = NotifFrame
	})
	
	local TitleLabel = Create("TextLabel", {
		Size = UDim2.new(1, -60, 0, 28),
		Position = UDim2.new(0, 18, 0, 12),
		BackgroundTransparency = 1,
		Text = Title,
		TextColor3 = AccentColor,
		TextSize = 17,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = NotifFrame
	})
	
	local CloseX = Create("TextButton", {
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -32, 0, 10),
		BackgroundTransparency = 0.9,
		BackgroundColor3 = Config.Colors.Secondary,
		Text = "×",
		TextColor3 = Config.Colors.Subtext,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		Parent = NotifFrame
	})
	CreateCorner(CloseX, 6)
	
	local ContentLabel = Create("TextLabel", {
		Size = UDim2.new(1, -36, 0, 0),
		Position = UDim2.new(0, 18, 0, 42),
		BackgroundTransparency = 1,
		Text = Content,
		TextColor3 = Config.Colors.Text,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = NotifFrame
	})
	
	local OkayBtn = Create("TextButton", {
		Size = UDim2.new(0, 90, 0, 32),
		Position = UDim2.new(1, -105, 1, -8),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = AccentColor,
		BackgroundTransparency = 0.2,
		Text = ButtonText,
		TextColor3 = Config.Colors.Background,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Parent = NotifFrame
	})
	CreateCorner(OkayBtn, 8)
	
	task.wait()
	local contentHeight = ContentLabel.AbsoluteSize.Y
	local targetHeight = math.max(110, 42 + contentHeight + 50)
	
	NotifFrame.Size = UDim2.new(1, 0, 0, 0)
	NotifFrame.Visible = false
	NotifFrame.Visible = true
	
	Tween(NotifFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.4, Enum.EasingStyle.Back)
	Tween(Glow, {ImageTransparency = 0.7}, 0.6)
	
	local TimeLeft = Duration
	local TimerLabel
	
	if Duration > 0 then
		TimerLabel = Create("TextLabel", {
			Size = UDim2.new(0, 50, 0, 20),
			Position = UDim2.new(1, -60, 0, 12),
			BackgroundTransparency = 1,
			Text = tostring(TimeLeft) .. "s",
			TextColor3 = Config.Colors.Subtext,
			TextSize = 13,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = NotifFrame
		})
		
		task.spawn(function()
			while TimeLeft > 0 and NotifFrame and NotifFrame.Parent do
				task.wait(1)
				TimeLeft = TimeLeft - 1
				if TimerLabel and TimerLabel.Parent then
					TimerLabel.Text = tostring(TimeLeft) .. "s"
				end
			end
			if NotifFrame and NotifFrame.Parent and TimeLeft <= 0 then
				CloseNotification()
			end
		end)
	end
	
	local Closing = false
	function CloseNotification()
		if Closing then return end
		Closing = true
		Tween(NotifFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In).Completed:Connect(function()
			if NotifFrame and NotifFrame.Parent then
				NotifFrame:Destroy()
			end
		end)
		Callback()
	end
	
	CloseX.MouseButton1Click:Connect(CloseNotification)
	OkayBtn.MouseButton1Click:Connect(CloseNotification)
	
	return {
		Close = CloseNotification,
		Update = function(newConfig)
			if newConfig.Title then TitleLabel.Text = newConfig.Title end
			if newConfig.Content then ContentLabel.Text = newConfig.Content end
		end
	}
end

ExoHubUI.CreateWindow = function(config)
	config = config or {}
	local Window = {}
	local Built = false
	
	local function BuildWindow()
		if Built then return end
		Built = true
		
		InitNotifications()
		
		local IsOpen = true
		local TargetSize = config.Size or UDim2.new(0, 650, 0, 450)
		
		local ScreenGui = Create("ScreenGui", {
			Name = "ExoHubUI",
			Parent = PlayerGui,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		})
		
		local MainFrame = Create("Frame", {
			Name = "MainFrame",
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = Config.Colors.Background,
			BackgroundTransparency = Config.Transparency.Background,
			BorderSizePixel = 0,
			Parent = ScreenGui
		})
		CreateCorner(MainFrame, 16)
		CreateStroke(MainFrame, Config.Colors.Border, 2)
		
		local AmbientGlow = Create("ImageLabel", {
			Size = UDim2.new(1, 100, 1, 100),
			Position = UDim2.new(0, -50, 0, -50),
			BackgroundTransparency = 1,
			Image = "rbxassetid://10822646395",
			ImageColor3 = Config.Colors.Accent,
			ImageTransparency = 0.95,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(50, 50, 50, 50),
			ZIndex = 0,
			Parent = MainFrame
		})
		
		local ToggleKey = config.ToggleKey or Config.ToggleKey
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then return end
			if input.KeyCode == ToggleKey then
				if IsOpen then
					IsOpen = false
					Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In).Completed:Connect(function()
						if MainFrame and MainFrame.Parent then
							MainFrame.Visible = false
						end
					end)
					Tween(AmbientGlow, {ImageTransparency = 1}, 0.3)
				else
					IsOpen = true
					if MainFrame and MainFrame.Parent then
						MainFrame.Visible = true
						Tween(MainFrame, {Size = TargetSize, Position = UDim2.new(0.5, -TargetSize.X.Offset/2, 0.5, -TargetSize.Y.Offset/2)}, 0.4, Enum.EasingStyle.Back)
						Tween(AmbientGlow, {ImageTransparency = 0.95}, 0.4)
					end
				end
			end
		end)
		
		local TopBar = Create("Frame", {
			Name = "TopBar",
			Size = UDim2.new(1, 0, 0, 45),
			BackgroundColor3 = Config.Colors.Secondary,
			BackgroundTransparency = Config.Transparency.Secondary,
			BorderSizePixel = 0,
			Parent = MainFrame
		})
		CreateCorner(TopBar, 16)
		Create("Frame", {
			Size = UDim2.new(1, 0, 0.5, 0),
			Position = UDim2.new(0, 0, 0.5, 0),
			BackgroundColor3 = Config.Colors.Secondary,
			BackgroundTransparency = Config.Transparency.Secondary,
			BorderSizePixel = 0,
			Parent = TopBar
		})
		
		-- ExoHub Title - P*rnHub Style
		local TitleContainer = Create("Frame", {
			Name = "TitleContainer",
			Size = UDim2.new(0, 250, 1, 0),
			Position = UDim2.new(0, 20, 0, 0),
			BackgroundTransparency = 1,
			Parent = TopBar
		})
		
		-- "Exo" in white
		local TitleExo = Create("TextLabel", {
			Name = "TitleExo",
			Size = UDim2.new(0, 55, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Text = "Exo",
			TextColor3 = Config.Colors.Text,
			TextSize = 22,
			Font = Enum.Font.GothamBlack,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = TitleContainer
		})
		
		-- "Hub" in orange (P*rnHub style)
		local TitleHub = Create("TextLabel", {
			Name = "TitleHub",
			Size = UDim2.new(0, 60, 0, 30),
			Position = UDim2.new(0, 52, 0.5, -15),
			BackgroundColor3 = Config.Colors.Accent,
			BackgroundTransparency = 0.1,
			Text = "Hub",
			TextColor3 = Config.Colors.Background,
			TextSize = 20,
			Font = Enum.Font.GothamBlack,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = TitleContainer
		})
		CreateCorner(TitleHub, 6)
		
		-- "UI" in white
		local TitleUI = Create("TextLabel", {
			Name = "TitleUI",
			Size = UDim2.new(0, 40, 1, 0),
			Position = UDim2.new(0, 118, 0, 0),
			BackgroundTransparency = 1,
			Text = " UI",
			TextColor3 = Config.Colors.Text,
			TextSize = 22,
			Font = Enum.Font.GothamBlack,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = TitleContainer
		})
		
		local Underline = Create("Frame", {
			Size = UDim2.new(0, 0, 0, 2),
			Position = UDim2.new(0, 20, 1, -2),
			BackgroundColor3 = Config.Colors.Accent,
			BorderSizePixel = 0,
			Parent = TopBar
		})
		task.delay(0.5, function()
			Tween(Underline, {Size = UDim2.new(0, 40, 0, 2)}, 0.6, Enum.EasingStyle.Back)
		end)
		
		local CloseBtn = Create("TextButton", {
			Name = "Close",
			Size = UDim2.new(0, 32, 0, 32),
			Position = UDim2.new(1, -40, 0, 6),
			BackgroundColor3 = Config.Colors.Secondary,
			BackgroundTransparency = 0.5,
			Text = "×",
			TextColor3 = Config.Colors.Text,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			Parent = TopBar
		})
		CreateCorner(CloseBtn, 8)
		CreateStroke(CloseBtn, Config.Colors.Border, 1)
		
		CloseBtn.MouseEnter:Connect(function()
			Tween(CloseBtn, {BackgroundColor3 = Config.Colors.Error, TextColor3 = Color3.new(1,1,1)}, 0.2)
		end)
		CloseBtn.MouseLeave:Connect(function()
			Tween(CloseBtn, {BackgroundColor3 = Config.Colors.Secondary, TextColor3 = Config.Colors.Text}, 0.2)
		end)
		CloseBtn.MouseButton1Click:Connect(function()
			Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3).Completed:Connect(function()
				if ScreenGui and ScreenGui.Parent then
					ScreenGui:Destroy()
				end
			end)
		end)
		
		local MinimizeBtn = Create("TextButton", {
			Name = "Minimize",
			Size = UDim2.new(0, 32, 0, 32),
			Position = UDim2.new(1, -80, 0, 6),
			BackgroundColor3 = Config.Colors.Secondary,
			BackgroundTransparency = 0.5,
			Text = "−",
			TextColor3 = Config.Colors.Text,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			Parent = TopBar
		})
		CreateCorner(MinimizeBtn, 8)
		CreateStroke(MinimizeBtn, Config.Colors.Border, 1)
		
		local Minimized = false
		MinimizeBtn.MouseButton1Click:Connect(function()
			Minimized = not Minimized
			if Minimized then
				Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 45)}, 0.3)
				MinimizeBtn.Text = "+"
			else
				Tween(MainFrame, {Size = TargetSize}, 0.3)
				MinimizeBtn.Text = "−"
			end
		end)
		
		local TabContainer = Create("Frame", {
			Name = "TabContainer",
			Size = UDim2.new(0, 160, 1, -55),
			Position = UDim2.new(0, 8, 0, 50),
			BackgroundColor3 = Config.Colors.Secondary,
			BackgroundTransparency = Config.Transparency.Secondary,
			BorderSizePixel = 0,
			Parent = MainFrame
		})
		CreateCorner(TabContainer, 12)
		
		local TabList = Create("ScrollingFrame", {
			Name = "TabList",
			Size = UDim2.new(1, -12, 1, -12),
			Position = UDim2.new(0, 6, 0, 6),
			BackgroundTransparency = 1,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Config.Colors.Accent,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Active = true,
			Parent = TabContainer
		})
		Create("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = TabList
		})
		Create("UIPadding", {
			PaddingBottom = UDim.new(0, 6),
			Parent = TabList
		})
		
		local ContentContainer = Create("Frame", {
			Name = "ContentContainer",
			Size = UDim2.new(1, -180, 1, -55),
			Position = UDim2.new(0, 175, 0, 50),
			BackgroundColor3 = Config.Colors.Secondary,
			BackgroundTransparency = Config.Transparency.Secondary,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = MainFrame
		})
		CreateCorner(ContentContainer, 12)
		
		local Dragging = false
		local DragStart, StartPos
		TopBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPos = MainFrame.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - DragStart
				MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = false
			end
		end)
		
		local Tabs = {}
		local CurrentTab = nil
		local FirstTabCreated = false
		
		Window.CreateTab = function(tabConfig)
			tabConfig = tabConfig or {}
			local Tab = {}
			
			local TabBtn = Create("TextButton", {
				Name = tabConfig.Name or "Tab",
				Size = UDim2.new(1, 0, 0, 38),
				BackgroundColor3 = Config.Colors.Background,
				BackgroundTransparency = Config.Transparency.Elements,
				Text = tabConfig.Name or "Tab",
				TextColor3 = Config.Colors.Subtext,
				TextSize = 15,
				Font = Enum.Font.GothamBold,
				Parent = TabList
			})
			CreateCorner(TabBtn, 8)
			
			local Indicator = Create("Frame", {
				Size = UDim2.new(0, 3, 0, 0),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Config.Colors.Accent,
				BorderSizePixel = 0,
				Parent = TabBtn
			})
			CreateCorner(Indicator, 2)
			
			local TabContent = Create("ScrollingFrame", {
				Name = tabConfig.Name or "Tab",
				Size = UDim2.new(1, -12, 1, -12),
				Position = UDim2.new(0, 6, 0, 6),
				BackgroundTransparency = 1,
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = Config.Colors.Accent,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				Visible = false,
				Active = true,
				Parent = ContentContainer
			})
			Create("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = TabContent
			})
			Create("UIPadding", {
				PaddingBottom = UDim.new(0, 10),
				Parent = TabContent
			})
			
			TabBtn.MouseButton1Click:Connect(function()
				if CurrentTab == Tab then return end
				if CurrentTab then
					Tween(CurrentTab.Button, {BackgroundColor3 = Config.Colors.Background, TextColor3 = Config.Colors.Subtext}, 0.2)
					Tween(CurrentTab.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
					CurrentTab.Content.Visible = false
				end
				CurrentTab = Tab
				Tween(TabBtn, {BackgroundColor3 = Config.Colors.Accent, TextColor3 = Config.Colors.Background}, 0.2)
				Tween(Indicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.3, Enum.EasingStyle.Back)
				TabContent.Visible = true
				TabContent.Position = UDim2.new(0, 15, 0, 6)
				Tween(TabContent, {Position = UDim2.new(0, 6, 0, 6)}, 0.3, Enum.EasingStyle.Back)
			end)
			
			Tab.Button = TabBtn
			Tab.Content = TabContent
			Tab.Indicator = Indicator
			
			if not CurrentTab then
				task.spawn(function()
					task.wait(0.1)
					TabBtn.MouseButton1Click:Fire()
				end)
			end
			
			Tab.CreateSection = function(sectionConfig)
				sectionConfig = sectionConfig or {}
				local SectionFrame = Create("Frame", {
					Name = "Section",
					Size = UDim2.new(1, -4, 0, 35),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Parent = TabContent
				})
				local SectionLabel = Create("TextLabel", {
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundTransparency = 1,
					Text = sectionConfig.Name or "Section",
					TextColor3 = Config.Colors.Accent,
					TextSize = 13,
					Font = Enum.Font.GothamBlack,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = SectionFrame
				})
				local Line = Create("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 0, 24),
					BackgroundColor3 = Config.Colors.Border,
					BackgroundTransparency = 0.5,
					BorderSizePixel = 0,
					Parent = SectionFrame
				})
				return {
					Set = function(text) SectionLabel.Text = text end,
					Get = function() return SectionLabel.Text end
				}
			end
			
			Tab.CreateButton = function(btnConfig)
				btnConfig = btnConfig or {}
				local ButtonFrame = Create("TextButton", {
					Name = "Button",
					Size = UDim2.new(1, -4, 0, 38),
					BackgroundColor3 = Config.Colors.Background,
					BackgroundTransparency = Config.Transparency.Elements,
					Text = btnConfig.Name or "Button",
					TextColor3 = Config.Colors.Text,
					TextSize = 15,
					Font = Enum.Font.GothamBold,
					Parent = TabContent
				})
				CreateCorner(ButtonFrame, 8)
				CreateStroke(ButtonFrame, Config.Colors.Border, 1)
				
				local Glow = Create("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Config.Colors.Accent,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = 0,
					Parent = ButtonFrame
				})
				CreateCorner(Glow, 8)
				
				-- Orange hover effect
				ButtonFrame.MouseEnter:Connect(function()
					Tween(Glow, {BackgroundTransparency = 0.85}, 0.2)
					Tween(ButtonFrame, {BackgroundColor3 = Config.Colors.Accent, TextColor3 = Config.Colors.Background}, 0.2)
				end)
				ButtonFrame.MouseLeave:Connect(function()
					Tween(Glow, {BackgroundTransparency = 1}, 0.2)
					Tween(ButtonFrame, {BackgroundColor3 = Config.Colors.Background, TextColor3 = Config.Colors.Text}, 0.2)
				end)
				ButtonFrame.MouseButton1Click:Connect(function()
					Tween(ButtonFrame, {Size = UDim2.new(0.97, -4, 0, 38)}, 0.05).Completed:Connect(function()
						Tween(ButtonFrame, {Size = UDim2.new(1, -4, 0, 38)}, 0.1, Enum.EasingStyle.Back)
					end)
					if btnConfig.Callback then
						btnConfig.Callback()
					end
				end)
				return {
					Set = function(text) ButtonFrame.Text = text end,
					Get = function() return ButtonFrame.Text end
				}
			end
			
			Tab.CreateToggle = function(toggleConfig)
				toggleConfig = toggleConfig or {}
				local Enabled = toggleConfig.Default or false
				
				local ToggleFrame = Create("Frame", {
					Name = "Toggle",
					Size = UDim2.new(1, -4, 0, 38),
					BackgroundColor3 = Config.Colors.Background,
					BackgroundTransparency = Config.Transparency.Elements,
					BorderSizePixel = 0,
					Parent = TabContent
				})
				CreateCorner(ToggleFrame, 8)
				CreateStroke(ToggleFrame, Config.Colors.Border, 1)
				
				Create("TextLabel", {
					Size = UDim2.new(1, -70, 1, 0),
					Position = UDim2.new(0, 14, 0, 0),
					BackgroundTransparency = 1,
					Text = toggleConfig.Name or "Toggle",
					TextColor3 = Config.Colors.Text,
					TextSize = 15,
					Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = ToggleFrame
				})
				
				local ToggleBtn = Create("TextButton", {
					Name = "ToggleBtn",
					Size = UDim2.new(0, 48, 0, 26),
					Position = UDim2.new(1, -58, 0.5, -13),
					BackgroundColor3 = Enabled and Config.Colors.Accent or Config.Colors.Border,
					BackgroundTransparency = Enabled and 0.3 or 0.5,
					Text = "",
					AutoButtonColor = false,
					Parent = ToggleFrame
				})
				CreateCorner(ToggleBtn, 13)
				
				local ToggleCircle = Create("Frame", {
					Name = "Circle",
					Size = UDim2.new(0, 20, 0, 20),
					Position = Enabled and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10),
					BackgroundColor3 = Config.Colors.Text,
					BorderSizePixel = 0,
					Parent = ToggleBtn
				})
				CreateCorner(ToggleCircle, 10)
				
				local function UpdateToggle()
					Enabled = not Enabled
					Tween(ToggleBtn, {
						BackgroundColor3 = Enabled and Config.Colors.Accent or Config.Colors.Border,
						BackgroundTransparency = Enabled and 0.3 or 0.5
					}, 0.2)
					Tween(ToggleCircle, {
						Position = Enabled and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
					}, 0.2, Enum.EasingStyle.Back)
					if toggleConfig.Callback then
						toggleConfig.Callback(Enabled)
					end
				end
				
				ToggleBtn.MouseButton1Click:Connect(UpdateToggle)
				
				return {
					Set = function(value)
						if Enabled ~= value then
							UpdateToggle()
						end
					end,
					Get = function() return Enabled end
				}
			end
			
			Tab.CreateSlider = function(sliderConfig)
				sliderConfig = sliderConfig or {}
				local Min = sliderConfig.Min or 0
				local Max = sliderConfig.Max or 100
				local Value = sliderConfig.Default or Min
				local Rounding = sliderConfig.Rounding or 1
				
				local SliderFrame = Create("Frame", {
					Name = "Slider",
					Size = UDim2.new(1, -4, 0, 55),
					BackgroundColor3 = Config.Colors.Background,
					BackgroundTransparency = Config.Transparency.Elements,
					BorderSizePixel = 0,
					Parent = TabContent
				})
				CreateCorner(SliderFrame, 8)
				CreateStroke(SliderFrame, Config.Colors.Border, 1)
				
				Create("TextLabel", {
					Size = UDim2.new(0.5, 0, 0, 28),
					Position = UDim2.new(0, 14, 0, 0),
					BackgroundTransparency = 1,
					Text = sliderConfig.Name or "Slider",
					TextColor3 = Config.Colors.Text,
					TextSize = 15,
					Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = SliderFrame
				})
				
				local ValueLabel = Create("TextLabel", {
					Size = UDim2.new(0.5, -24, 0, 28),
					Position = UDim2.new(0.5, 12, 0, 0),
					BackgroundTransparency = 1,
					Text = tostring(Value),
					TextColor3 = Config.Colors.Accent,
					TextSize = 15,
					Font = Enum.Font.GothamBlack,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = SliderFrame
				})
				
				local SliderBg = Create("TextButton", {
					Name = "Background",
					Size = UDim2.new(1, -28, 0, 8),
					Position = UDim2.new(0, 14, 0, 36),
					BackgroundColor3 = Config.Colors.Secondary,
					BackgroundTransparency = 0.5,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					Parent = SliderFrame
				})
				CreateCorner(SliderBg, 4)
				
				local SliderFill = Create("Frame", {
					Name = "Fill",
					Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0),
					BackgroundColor3 = Config.Colors.Accent,
					BackgroundTransparency = 0.2,
					BorderSizePixel = 0,
					Parent = SliderBg
				})
				CreateCorner(SliderFill, 4)
				
				local SliderKnob = Create("Frame", {
					Name = "Knob",
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new((Value - Min) / (Max - Min), -8, 0.5, -8),
					BackgroundColor3 = Config.Colors.Text,
					BorderSizePixel = 0,
					Parent = SliderBg
				})
				CreateCorner(SliderKnob, 8)
				
				local Dragging = false
				local function UpdateSlider(input)
					local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
					local newValue = Min + (Max - Min) * pos
					newValue = math.floor(newValue * (10 ^ Rounding) + 0.5) / (10 ^ Rounding)
					Value = newValue
					ValueLabel.Text = tostring(Value)
					SliderFill.Size = UDim2.new(pos, 0, 1, 0)
					SliderKnob.Position = UDim2.new(pos, -8, 0.5, -8)
					if sliderConfig.Callback then
						sliderConfig.Callback(Value)
					end
				end
				
				SliderBg.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = true
						UpdateSlider(input)
					end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						UpdateSlider(input)
					end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = false
					end
				end)
				
				return {
					Set = function(newVal)
						newVal = math.clamp(newVal, Min, Max)
						local pos = (newVal - Min) / (Max - Min)
						Value = newVal
						ValueLabel.Text = tostring(Value)
						Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
						Tween(SliderKnob, {Position = UDim2.new(pos, -8, 0.5, -8)}, 0.1)
						if sliderConfig.Callback then
							sliderConfig.Callback(Value)
						end
					end,
					Get = function() return Value end
				}
			end
			
			Tab.CreateDropdown = function(dropdownConfig)
				dropdownConfig = dropdownConfig or {}
				local Options = dropdownConfig.Options or {}
				local Selected = dropdownConfig.Default or (Options[1] or "None")
				local Opened = false
				
				local DropdownContainer = Create("Frame", {
					Name = "DropdownContainer",
					Size = UDim2.new(1, -4, 0, 38),
					BackgroundTransparency = 1,
					ClipsDescendants = false,
					ZIndex = 10,
					Parent = TabContent
				})
				
				local DropdownFrame = Create("Frame", {
					Name = "Dropdown",
					Size = UDim2.new(1, 0, 0, 38),
					BackgroundColor3 = Config.Colors.Background,
					BackgroundTransparency = Config.Transparency.Elements,
					BorderSizePixel = 0,
					ClipsDescendants = false,
					ZIndex = 10,
					Parent = DropdownContainer
				})
				CreateCorner(DropdownFrame, 8)
				CreateStroke(DropdownFrame, Config.Colors.Border, 1)
				
				local DropdownBtn = Create("TextButton", {
					Size = UDim2.new(1, 0, 0, 38),
					BackgroundTransparency = 1,
					Text = "",
					AutoButtonColor = false,
					ZIndex = 11,
					Parent = DropdownFrame
				})
				
				local DropdownLabel = Create("TextLabel", {
					Size = UDim2.new(1, -45, 1, 0),
					Position = UDim2.new(0, 14, 0, 0),
					BackgroundTransparency = 1,
					Text = (dropdownConfig.Name or "Select") .. ": " .. tostring(Selected),
					TextColor3 = Config.Colors.Text,
					TextSize = 15,
					Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 12,
					Parent = DropdownBtn
				})
				
				local DropdownIcon = Create("TextLabel", {
					Size = UDim2.new(0, 24, 0, 24),
					Position = UDim2.new(1, -32, 0.5, -12),
					BackgroundTransparency = 1,
					Text = "▼",
					TextColor3 = Config.Colors.Accent,
					TextSize = 14,
					Font = Enum.Font.GothamBlack,
					ZIndex = 12,
					Parent = DropdownBtn
				})
				
				local OptionsFrame = Create("ScrollingFrame", {
					Size = UDim2.new(1, -12, 0, 0),
					Position = UDim2.new(0, 6, 0, 38),
					BackgroundColor3 = Config.Colors.Secondary,
					BackgroundTransparency = 0.1,
					BorderSizePixel = 0,
					Visible = false,
					ClipsDescendants = true,
					ZIndex = 20,
					Active = true,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ScrollBarThickness = 4,
					ScrollBarImageColor3 = Config.Colors.Accent,
					ScrollBarImageTransparency = 0.2,
					CanvasSize = UDim2.new(0, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
					Parent = DropdownFrame
				})
				CreateCorner(OptionsFrame, 6)
				
				Create("UIListLayout", {
					Padding = UDim.new(0, 3),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = OptionsFrame
				})
				
				local function CloseDropdown()
					Opened = false
					Tween(DropdownIcon, {Rotation = 0}, 0.2)
					Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 38)}, 0.2)
					Tween(OptionsFrame, {Size = UDim2.new(1, -12, 0, 0)}, 0.2)
					task.wait(0.2)
					OptionsFrame.Visible = false
					DropdownContainer.ZIndex = 10
					DropdownFrame.ZIndex = 10
				end
				
				local function OpenDropdown()
					Opened = true
					DropdownContainer.ZIndex = 100
					DropdownFrame.ZIndex = 100
					OptionsFrame.ZIndex = 101
					for _, child in ipairs(OptionsFrame:GetChildren()) do
						if child:IsA("TextButton") then
							child.ZIndex = 102
						end
					end
					OptionsFrame.Visible = true
					local totalHeight = math.min(#Options * 32 + 6, 160)
					Tween(DropdownIcon, {Rotation = 180}, 0.2)
					Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 38 + totalHeight)}, 0.2)
					Tween(OptionsFrame, {Size = UDim2.new(1, -12, 0, totalHeight - 6)}, 0.2)
				end
				
				local function SelectOption(option)
					Selected = option
					DropdownLabel.Text = (dropdownConfig.Name or "Select") .. ": " .. tostring(Selected)
					CloseDropdown()
					if dropdownConfig.Callback then
						dropdownConfig.Callback(Selected)
					end
				end
				
				for _, option in ipairs(Options) do
					local OptionBtn = Create("TextButton", {
						Size = UDim2.new(1, 0, 0, 30),
						BackgroundColor3 = Config.Colors.Secondary,
						BackgroundTransparency = 0.5,
						Text = tostring(option),
						TextColor3 = Config.Colors.Subtext,
						TextSize = 14,
						Font = Enum.Font.GothamBold,
						ZIndex = 102,
						Parent = OptionsFrame
					})
					CreateCorner(OptionBtn, 4)
					
					-- Orange hover for dropdown options
					OptionBtn.MouseEnter:Connect(function()
						Tween(OptionBtn, {BackgroundColor3 = Config.Colors.Accent, TextColor3 = Config.Colors.Background}, 0.15)
					end)
					OptionBtn.MouseLeave:Connect(function()
						Tween(OptionBtn, {BackgroundColor3 = Config.Colors.Secondary, TextColor3 = Config.Colors.Subtext}, 0.15)
					end)
					OptionBtn.MouseButton1Click:Connect(function()
						SelectOption(option)
					end)
				end
				
				-- Orange hover for main dropdown button
				DropdownBtn.MouseEnter:Connect(function()
					if not Opened then
						Tween(DropdownFrame, {BackgroundColor3 = Config.Colors.Accent, BackgroundTransparency = 0.85}, 0.2)
						Tween(DropdownLabel, {TextColor3 = Config.Colors.Background}, 0.2)
					end
				end)
				DropdownBtn.MouseLeave:Connect(function()
					if not Opened then
						Tween(DropdownFrame, {BackgroundColor3 = Config.Colors.Background, BackgroundTransparency = Config.Transparency.Elements}, 0.2)
						Tween(DropdownLabel, {TextColor3 = Config.Colors.Text}, 0.2)
					end
				end)
				
				DropdownBtn.MouseButton1Click:Connect(function()
					if Opened then
						CloseDropdown()
					else
						OpenDropdown()
					end
				end)
				
				return {
					Set = function(value)
						if table.find(Options, value) then
							SelectOption(value)
						end
					end,
					Get = function() return Selected end
				}
			end
			
			Tab.CreateTextBox = function(textboxConfig)
				textboxConfig = textboxConfig or {}
				
				local TextBoxContainer = Create("Frame", {
					Name = "TextBoxContainer",
					Size = UDim2.new(1, -4, 0, 38),
					BackgroundTransparency = 1,
					Parent = TabContent
				})
				
				local TextBoxFrame = Create("Frame", {
					Name = "TextBox",
					Size = UDim2.new(1, 0, 0, 38),
					BackgroundColor3 = Config.Colors.Background,
					BackgroundTransparency = Config.Transparency.Elements,
					BorderSizePixel = 0,
					Parent = TextBoxContainer
				})
				CreateCorner(TextBoxFrame, 8)
				CreateStroke(TextBoxFrame, Config.Colors.Border, 1)
				
				Create("TextLabel", {
					Size = UDim2.new(0.35, 0, 1, 0),
					Position = UDim2.new(0, 14, 0, 0),
					BackgroundTransparency = 1,
					Text = textboxConfig.Name or "Input",
					TextColor3 = Config.Colors.Text,
					TextSize = 15,
					Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = TextBoxFrame
				})
				
				local InputBox = Create("TextBox", {
					Size = UDim2.new(0.65, -24, 0, 28),
					Position = UDim2.new(0.35, 12, 0.5, -14),
					BackgroundColor3 = Config.Colors.Secondary,
					BackgroundTransparency = 0.5,
					Text = tostring(textboxConfig.Default or ""),
					TextColor3 = Config.Colors.Text,
					TextSize = 14,
					Font = Enum.Font.Gotham,
					ClearTextOnFocus = false,
					Parent = TextBoxFrame
				})
				CreateCorner(InputBox, 6)
				InputBox.PlaceholderText = textboxConfig.Placeholder or "Enter..."
				InputBox.PlaceholderColor3 = Config.Colors.Subtext
				
				if textboxConfig.NumbersOnly then
					InputBox:GetPropertyChangedSignal("Text"):Connect(function()
						InputBox.Text = InputBox.Text:gsub("[^%d.]", "")
					end)
				end
				
				InputBox.FocusLost:Connect(function(enterPressed)
					if textboxConfig.Callback then
						textboxConfig.Callback(InputBox.Text, enterPressed)
					end
				end)
				
				return {
					Set = function(text)
						InputBox.Text = tostring(text)
						if textboxConfig.Callback then
							textboxConfig.Callback(tostring(text), false)
						end
					end,
					Get = function() return InputBox.Text end
				}
			end
			
			Tab.CreateLabel = function(labelConfig)
				labelConfig = labelConfig or {}
				local LabelContainer = Create("Frame", {
					Name = "LabelContainer",
					Size = UDim2.new(1, -4, 0, 28),
					BackgroundTransparency = 1,
					Parent = TabContent
				})
				local LabelText = Create("TextLabel", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = labelConfig.Text or "Label",
					TextColor3 = labelConfig.Color or Config.Colors.Subtext,
					TextSize = labelConfig.Size or 14,
					Font = labelConfig.Bold and Enum.Font.GothamBlack or Enum.Font.Gotham,
					TextXAlignment = labelConfig.Alignment or Enum.TextXAlignment.Left,
					TextWrapped = true,
					Parent = LabelContainer
				})
				return {
					Set = function(text) LabelText.Text = tostring(text) end,
					Get = function() return LabelText.Text end
				}
			end
			
			if not FirstTabCreated then
				FirstTabCreated = true
				local FooterContainer = Create("Frame", {
					Name = "ExoHubFooter",
					Size = UDim2.new(1, -4, 0, 35),
					BackgroundTransparency = 1,
					Parent = TabContent
				})
				Create("TextLabel", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = "ExoHub UI // Premium Scripting Interface",
					TextColor3 = Config.Colors.Subtext,
					TextSize = 13,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextTransparency = 0.3,
					Parent = FooterContainer
				})
			end
			
			table.insert(Tabs, Tab)
			return Tab
		end
		
		Tween(MainFrame, {
			Size = TargetSize,
			Position = UDim2.new(0.5, -TargetSize.X.Offset/2, 0.5, -TargetSize.Y.Offset/2)
		}, 0.5, Enum.EasingStyle.Back)
		Tween(AmbientGlow, {ImageTransparency = 0.9}, 0.8)
		
		-- Show initialization notification
		task.spawn(function()
			task.wait(0.5)
			ExoHubUI.Notify({
				Title = "ExoHub UI Loaded",
				Content = "Premium black interface loaded. Press RightControl to toggle visibility.",
				Duration = 8,
				Type = "Success",
				ButtonText = "Start",
				Callback = function()
					print("ExoHub UI Ready")
				end
			})
		end)
		
		return Window
	end
	
	return BuildWindow()
end

getfenv().ExoHubUI = ExoHubUI
return ExoHubUI
