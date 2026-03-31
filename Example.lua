local ExoHubUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/ExoHub-UI/refs/heads/main/script.lua"))()

local Window = ExoHubUI.CreateWindow({
    Title = "ExoHub UI",
    Size = UDim2.new(0, 650, 0, 500)
})

local MainTab = Window.CreateTab({Name = "Main"})
local VisualsTab = Window.CreateTab({Name = "Visuals"})
local SettingsTab = Window.CreateTab({Name = "Settings"})

local GeneralSection = MainTab.CreateSection({Name = "General"})

GeneralSection:AddButton({
    Name = "Print Hello",
    Callback = function()
        print("Hello World!")
        ExoHubUI.Notify({
            Title = "Success",
            Content = "Button clicked!",
            Duration = 3,
            Type = "Success"
        })
    end
})

local AutoFarmToggle = GeneralSection:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

GeneralSection:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

GeneralSection:AddDropdown({
    Name = "Select Mode",
    Options = {"Normal", "Hard", "Extreme"},
    Default = "Normal",
    Callback = function(option)
        print("Mode:", option)
    end
})

GeneralSection:AddTextbox({
    Name = "Player Name",
    Placeholder = "Enter target...",
    Callback = function(text, enterPressed)
        if enterPressed then
            print("Target:", text)
        end
    end
})

GeneralSection:AddLabel({
    Text = "Status: Ready",
    Color = Color3.fromRGB(255, 153, 0),
    Bold = true
})

local ConfigSection = SettingsTab.CreateSection({Name = "Configuration"})

ConfigSection:AddButton({
    Name = "Save Settings",
    Callback = function()
        ExoHubUI.Notify({
            Title = "Saved",
            Content = "Settings saved successfully!",
            Duration = 3,
            Type = "Success"
        })
    end
})

ConfigSection:AddButton({
    Name = "Reset All",
    Callback = function()
        ExoHubUI.Notify({
            Title = "Reset",
            Content = "All settings reset to default!",
            Duration = 3,
            Type = "Warning"
        })
    end
})

-- Welcome notification
ExoHubUI.Notify({
    Title = "ExoHub UI Loaded",
    Content = "Welcome! Press RightControl to toggle UI",
    Duration = 5,
    Type = "Info"
})
