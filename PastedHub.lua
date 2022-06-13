local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local EspLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatSovietShiba/EpicPFCheat/main/ESP.lua"))()


--auto deploy



--menu
local Window = Library:CreateWindow({
    Title = 'PastedHub V0.1.1',
    Center = false, 
    AutoShow = true,
})

local Tabs = {
    Visuals = Window:AddTab('Visuals'),
    --Player = Window:AddTab('Player'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('Configs and Themes'),
}

local ESPGroup = Tabs.Visuals:AddLeftGroupbox('ESP')
--local MovementGroup = Tabs.Player:AddLeftGroupbox('Movement')
local AutoGroup = Tabs.Misc:AddLeftGroupbox('Automation')

--Visuals
ESPGroup:AddToggle('BoxToggle', {
    Text = 'Boxes',
    Default = false,
})

ESPGroup:AddToggle('SkeletonToggle', {
    Text = 'Skeletons',
    Default = false,
})

ESPGroup:AddToggle('NameToggle', {
    Text = 'Player Info',
    Default = false,
})

ESPGroup:AddToggle('HPToggle', {
    Text = 'Health Bars',
    Default = false,
})

ESPGroup:AddToggle('TracerToggle', {
    Text = 'Tracers',
    Default = false,
})

ESPGroup:AddToggle('HeadDotToggle', {
    Text = 'Head Dots',
    Default = false,
})

ESPGroup:AddToggle('ViewToggle', {
    Text = 'View Lines',
    Default = false,
})

ESPGroup:AddToggle('TeamToggle', {
    Text = 'Team Check',
    Default = false,
})

--[[Player
MovementGroup:AddToggle('SpeedToggle', {
    Text = 'Speed',
    Default = false,
})

MovementGroup:AddSlider('SpeedValue', {
    Text = 'Speed',
    Default = 16,
    Min = 1,
    Max = 169,
    Rounding = 0,
    Compact = true,
})

MovementGroup:AddToggle('JumpToggle', {
    Text = 'Super Jump',
    Default = false, 
})

MovementGroup:AddSlider('JumpValue', {
    Text = 'Super Jump',
    Default = 4,
    Min = 1,
    Max = 169,
    Rounding = 0,
    Compact = true,
})]]

AutoGroup:AddToggle('DeployToggle',{
    Text = 'Auto Deploy',
    Default = false,
})


--Visuals Mods
--ESP Options
Toggles.BoxToggle:OnChanged(function()
    if Toggles.BoxToggle.Value == true then
        getgenv().EspSettings.Boxes.Enabled = true
    end
    if Toggles.BoxToggle.Value == false then
        getgenv().EspSettings.Boxes.Enabled = false
    end
end)

Toggles.SkeletonToggle:OnChanged(function()
    if Toggles.SkeletonToggle.Value == true then
        getgenv().EspSettings.Skeletons.Enabled = true
    end
    if Toggles.SkeletonToggle.Value == false then
        getgenv().EspSettings.Skeletons.Enabled = false
    end
end)

Toggles.NameToggle:OnChanged(function()
    if Toggles.NameToggle.Value == true then
        getgenv().EspSettings.Names.Enabled = true
    end
    if Toggles.NameToggle.Value == false then
        getgenv().EspSettings.Names.Enabled = false
    end
end)

Toggles.HPToggle:OnChanged(function()
    if Toggles.HPToggle.Value == true then
        getgenv().EspSettings.HealthBars.Enabled = true
    end
    if Toggles.HPToggle.Value == false then
        getgenv().EspSettings.HealthBars.Enabled = false
    end
end)

Toggles.HPToggle:OnChanged(function()
    if Toggles.HPToggle.Value == true then
        getgenv().EspSettings.HealthBars.Enabled = true
    end
    if Toggles.HPToggle.Value == false then
        getgenv().EspSettings.HealthBars.Enabled = false
    end
end)

Toggles.TracerToggle:OnChanged(function()
    if Toggles.TracerToggle.Value == true then
        getgenv().EspSettings.Tracers.Enabled = true
    end
    if Toggles.TracerToggle.Value == false then
        getgenv().EspSettings.Tracers.Enabled = false
    end
end)

Toggles.HeadDotToggle:OnChanged(function()
    if Toggles.HeadDotToggle.Value == true then
        getgenv().EspSettings.HeadDots.Enabled = true
    end
    if Toggles.HeadDotToggle.Value == false then
        getgenv().EspSettings.HeadDots.Enabled = false
    end
end)

Toggles.ViewToggle:OnChanged(function()
    if Toggles.ViewToggle.Value == true then
        getgenv().EspSettings.LookTracers.Enabled = true
    end
    if Toggles.ViewToggle.Value == false then
        getgenv().EspSettings.LookTracers.Enabled = false
    end
end)

Toggles.TeamToggle:OnChanged(function()
    if Toggles.TeamToggle.Value == true then
        getgenv().EspSettings.TeamCheck = true
    end
    if Toggles.TeamToggle.Value == false then
        getgenv().EspSettings.TeamCheck = false
    end
end)



--Player Mods
--[[speedhack
Toggles.SpeedToggle:OnChanged(function()
    if Toggles.SpeedToggle.Value == true then
        getgenv().WalkSpeedValue = Options.SpeedValue.Value;
        local Player = (game:service'Players'.LocalPlayer);
        Player.Character.Humanoid:GetPropertyChangedSignal'WalkSpeed':Connect(function()
        Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
        end)
        Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
        Options.SpeedValue:OnChanged(function()
            if Toggles.SpeedToggle.Value == true then
                getgenv().WalkSpeedValue = Options.SpeedValue.Value;
                local Player = (game:service'Players'.LocalPlayer);
                Player.Character.Humanoid:GetPropertyChangedSignal'WalkSpeed':Connect(function()
                Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
                end)
                Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
            end
        end)
    end
    if Toggles.SpeedToggle.Value == false then
        getgenv().WalkSpeedValue = 16;
        local Player = (game:service'Players'.LocalPlayer);
        Player.Character.Humanoid:GetPropertyChangedSignal'WalkSpeed':Connect(function()
        Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
        end)
        Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
    end
end)

--superjump
Toggles.JumpToggle:OnChanged(function()
    if Toggles.JumpToggle.Value == true then
        getgenv().JumpPowerValue = Options.JumpValue.Value;
        local Player = (game:service'Players'.LocalPlayer);
        Player.Character.Humanoid:GetPropertyChangedSignal'JumpPower':Connect(function()
        Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
        end)
        Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
        Options.JumpValue:OnChanged(function()
            if Toggles.JumpToggle.Value == true then
                getgenv().JumpPowerValue = Options.JumpValue.Value;
                local Player = (game:service'Players'.LocalPlayer);
                Player.Character.Humanoid:GetPropertyChangedSignal'JumpPower':Connect(function()
                Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
                end)
                Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
            end
        end)
    end
    if Toggles.JumpToggle.Value == false then
        getgenv().JumpPowerValue = 4;
        local Player = (game:service'Players'.LocalPlayer);
        Player.Character.Humanoid:GetPropertyChangedSignal'JumpPower':Connect(function()
        Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
        end)
        Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
    end
end)]]


--extra shit
Library:SetWatermarkVisibility(true)

Library:SetWatermark('PastedHub')

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' }) 

Library.ToggleKeybind = Options.MenuKeybind


ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)


SaveManager:IgnoreThemeSettings() 


SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })


ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')


SaveManager:BuildConfigSection(Tabs['UI Settings']) 


ThemeManager:ApplyToTab(Tabs['UI Settings'])


--misc
local AutoDeploy = false
Toggles.DeployToggle:OnChanged(function()
    if Toggles.DeployToggle.Value == true then
        AutoDeploy = true
        local _deploy;

        for i,v in next, debug.getregistry() do
            if (typeof(v) == "function") then
                for a, b in next, debug.getupvalues(v) do
                    if (typeof(b) == "table" and rawget(b, "deploy")) then
                        _deploy = b;
                    end;
                end;
            end;

            if (_deploy) then
                break;
            end;
        end;

        while wait(1) do
            if AutoDeploy == true then
                if (not _deploy.isdeployed()) then
                    _deploy:deploy();
                end
            end
            ;
        end;
    end
    if Toggles.DeployToggle.Value == false then
        AutoDeploy = false
        local _deploy;

        for i,v in next, debug.getregistry() do
            if (typeof(v) == "function") then
                for a, b in next, debug.getupvalues(v) do
                    if (typeof(b) == "table" and rawget(b, "deploy")) then
                        _deploy = b;
                    end;
                end;
            end;

            if (_deploy) then
                break;
            end;
        end;

        while wait(1) do
            if AutoDeploy == true then
                if (not _deploy.isdeployed()) then
                    _deploy:deploy();
                end
            end
            ;
        end;
    end
end)
