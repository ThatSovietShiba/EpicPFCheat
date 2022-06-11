local SpeedValue = {};
local JumpValue = {};

function Speed()
    getgenv().WalkSpeedValue = SpeedValue;
    local Player = (game:service'Players'.LocalPlayer);
    Player.Character.Humanoid:GetPropertyChangedSignal'WalkSpeed':Connect(function()
    Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
    end)
    Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
end

function Jump()
    getgenv().JumpPowerValue = JumpValue;
    local Player = (game:service'Players'.LocalPlayer);
    Player.Character.Humanoid:GetPropertyChangedSignal'JumpPower':Connect(function()
    Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
    end)
    Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
end
