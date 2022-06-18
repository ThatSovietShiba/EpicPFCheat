-- made by siper#9938
-- ^ I heared Integer and Siper are very good long-term friends :)
syn.set_thread_identity(2)
-- modules
local network, char, gamelogic, particle, loadgun, loadknife; do
    for _, object in next, getgc(true) do
        if (typeof(object) == "table") then
            if (rawget(object, "send")) then
                network = object;
            elseif (rawget(object, "setbasewalkspeed")) then
                char = object;
            elseif (rawget(object, "controllerstep") and rawget(object, "setsprintdisable")) then
                gamelogic = object;
            elseif rawget(object, "new") and rawget(object, "step") and rawget(object, "reset") then
                local new = object.new
                if string.find(debug.getinfo(new).source, "particle") then
                    particle = object;
                end
            end
        elseif (typeof(object) == "function") then
            local name = debug.getinfo(object).name;

            if (name == "loadgun") then
                loadgun = object;
            elseif (name == "loadknife") then
                loadknife = object;
            end
        end
    end
end

-- services
local replicatedStorage = game:GetService("ReplicatedStorage");
local players = game:GetService("Players")
local localplayer = players.LocalPlayer

-- cache
local content = replicatedStorage:WaitForChild("Content");
local productionContent = content:WaitForChild("ProductionContent");
local attachmentModules = productionContent:WaitForChild("AttachmentModules");
local gunModules = productionContent:WaitForChild("GunModules");

-- stored data
local gunIgnore = {"JUGGUN", "HK417Old", "PAINTBALL GUN", "RAILGUN OLD", "PPK12", "SVK12E", "MG42"};
local weaponData = {};
local attachmentData = {};
local primaryClasses = { "ASSAULT", "BATTLE", "CARBINE", "SHOTGUN", "PDW", "DMR", "LMG", "SNIPER" };
local generalClassData = {
    ["ASSAULT"] = "AK12",
    ["BATTLE"] = "AK12",
    ["CARBINE"] = "M4A1",
    ["SHOTGUN"] = "KSG 12",
    ["PDW"] = "MP5K",
    ["DMR"] = "INTERVENTION",
    ["LMG"] = "COLT LMG",
    ["SNIPER"] = "INTERVENTION",
    ["PISTOL"] = "M9",
    ["MACHINE PISTOL"] = "M9",
    ["REVOLVER"] = "M9",
    ["OTHER"] = "M9",
    ["FRAGMENTATION"] = "M67 FRAG",
    ["HIGH EXPLOSIVE"] = "M67 FRAG",
    ["IMPACT"] = "M67 FRAG",
    ["ONE HAND BLADE"] = "KNIFE",
    ["TWO HAND BLADE"] = "KNIFE",
    ["ONE HAND BLUNT"] = "MAGLITE CLUB",
    ["TWO HAND BLUNT"] = "HOCKEY STICK",
};
local weapons = {};

-- hooks
do
    do
        local function tsn(tbl, value)
            for i=1, #tbl do
                if tbl[i] == value then return true end
            end
        end

        local reg = getgc()
        for i=1, #reg do
            local v = reg[i]
            if typeof(v) == "function" then
                local dbg = debug.getinfo(v)
                if string.find(dbg.short_src, "network", 1, true) then
                    local consts = debug.getconstants(v)
                    if tsn(consts, "warn") and tsn(consts, "Tried to call a unregistered network event %s") then
                        local ups = debug.getupvalues(v)
                        if typeof(ups[1]) == "table" then
                            network.receivers = ups[1]
                        end
                        network._receiver = v
                    end
                end
            end
        end

        local remapped = {}
        for index, callback in pairs(network.receivers) do
            local const = debug.getconstants(callback)
            if tsn(const, "streamermode") and tsn(const, "GunImg") and tsn(const, "Victim") and tsn(const, " studs") then
                -- killfeed
                remapped[index] = "killfeed"
            end

            local upvalues = debug.getupvalues(callback)
            if upvalues[1] and typeof(upvalues[1]) == "function" and islclosure(upvalues[1]) then
                local const = debug.getconstants(upvalues[1])
                if tsn(const, "ui_begin") and tsn(const, "kill") and tsn(const, "killshot") then
                    -- bigaward
                    remapped[index] = "bigaward"
                end
            end
        end

        local topassthrough = {
            gamelogic = gamelogic,
            localplayer = localplayer,
            remapped = remapped,
        }
        topassthrough.receiver = hookfunction(network._receiver, function(index, ...)
            local name = remapped[index]
            
            if name == "killfeed" then
                local args = {...}
                local killer = args[1]
                local victim = args[2]
                local studs = args[3]
                local weapon = args[4]
                local isheadshot = args[5]

                local gamelogic = topassthrough.gamelogic
                local localplayer = topassthrough.localplayer
                if killer == localplayer and gamelogic.currentgun then
                    if gamelogic.currentgun.knife then
                        args[4] = gamelogic.currentgun.name
                    elseif gamelogic.currentgun.data then
                        args[4] = gamelogic.currentgun.data.name
                    end
                end

                return topassthrough.receiver(index, unpack(args))
            end

            if name == "bigaward" then
                local args = {...}
                local type = args[1]
                local victim = args[2]
                local weapon = args[3]
                local experience = args[4]

                if type == "kill" then
                    local gamelogic = topassthrough.gamelogic
                    if gamelogic.currentgun then
                        if gamelogic.currentgun.knife then
                            args[3] = gamelogic.currentgun.name
                        elseif gamelogic.currentgun.data then
                            args[3] = gamelogic.currentgun.data.name
                        end
                    end
                end

                return topassthrough.receiver(index, unpack(args))
            end

            return topassthrough.receiver(index, ...)
        end)
    end

    local oldparticlenew = particle.new
    setreadonly(particle, false)
    function particle.new(data, ...)
        if data.onplayerhit and data.ontouch then
            if gamelogic.currentgun and gamelogic.currentgun.data and generalClassData[gamelogic.currentgun.data.type] then
                local gundata = require(gunModules:FindFirstChild(generalClassData[gamelogic.currentgun.data.type]))
                data.velocity = data.velocity.Unit * gundata.bulletspeed
            end
        end

        return oldparticlenew(data, ...)
    end
    setreadonly(particle, true)
    
    local oldNetworkSend = network.send; network.send = function(self, name, ...)
        local args = {...};

        if (name == "changewep") then
            weaponData[args[1]] = args[2];
            args[2] = generalClassData[weapons[args[2]].type];
        end

        if (name == "changeatt") then
            attachmentData[args[2]] = args[3];
            return
        end

        if (name == "newbullets" and gamelogic.currentgun and gamelogic.currentgun.data and generalClassData[gamelogic.currentgun.data.type]) then
            local gundata = require(gunModules:FindFirstChild(generalClassData[gamelogic.currentgun.data.type]))
            local bullets = args[1].bullets
            for i=1, #bullets do
                bullets[i][1] = bullets[i][1].Unit * gundata.bulletspeed
            end
        end

        return oldNetworkSend(self, name, unpack(args));
    end

    local oldLoadgrenade = char.loadgrenade; char.loadgrenade = function(self, name, ...)
        name = weaponData["Grenade"] or name;
        return oldLoadgrenade(self, name, ...);
    end;

    local oldLoadknife; oldLoadknife = hookfunction(loadknife, function(name, ...)
        name = weaponData["Knife"] or name;
        return oldLoadknife(name, ...);
    end);

    local oldLoadgun; oldLoadgun = hookfunction(loadgun, function(name, magsize, sparerounds, attachments, ...)
        local gunData = weapons[name];
        local newName = table.find(primaryClasses, gunData.type) and weaponData["Primary"] or weaponData["Secondary"];

        name = (newName and newName or name);

        local attachs = attachmentData[name];

        if (attachs) then
            attachments = attachs;
        end

        return oldLoadgun(name, magsize, sparerounds, attachments, ...);
    end);
end

-- init
do
    for _, module in next, gunModules:GetChildren() do
        if (not table.find(gunIgnore, module.Name)) then
            local data = require(module);
            weapons[module.Name] = data;
        end
    end

    for _, module in next, attachmentModules:GetChildren() do
        local data = require(module);
        data.unlockkills = 0;
    end

    for _, module in next, gunModules:GetChildren() do
        if (not table.find(gunIgnore, module.Name)) then
            local data = require(module);
            data.unlockrank = 0;
            data.adminonly = false;
            data.supertest = false;
            data.exclusiveunlock = false;
            data.hideunlessowned = false;
            data.adminonly = false;
        end
    end
end

-- makes the railgun uhhh, not shit? :)
-- put on the Triple Core attachment, it's fun
local railgun = gunModules:FindFirstChild("RAILGUN")
local gundata = require(railgun)

-- lucy - 5964660989, 5964676610, 5964899623
-- level up - 5153733046

gundata.magfeed = false
local reload = gundata.animations["reload"]
for i=1, #reload do
    local frame = reload[i]
    for k=1, #frame do
        local framedata = frame[k]
        if framedata.soundid == "rbxassetid://2105452146" then
            framedata.soundid = "rbxassetid://5153733046"
        end
    end
end

gundata.animations["tacticalreload"] = reload
gundata.animations["extendedreload"] = reload
gundata.animations["extendedtacticalreload"] = reload

local v17 = {};
v17.node = "OtherNode";
v17.altreload = "";
v17.altreloadlong = "";
v17.replacemag = gundata.replacemag;
v17.type = gundata.type;
v17.pelletcount = 1;
v17.magsize = 3;
v17.firerate = 150;
gundata.attachments:modify("Other", "Triple Core (RAILGUN)", v17);
local v18 = {};
v18.node = "OtherNode";
v18.altreload = "";
v18.altreloadlong = "";
v18.replacemag = gundata.replacemag;
v18.type = gundata.type;
v18.pelletcount = 1;
v18.magsize = 4;
v18.hipchoke = 0.25;
v18.aimchoke = 0.25;
v18.firerate = 999000;
v18.firemodes = {
	true
};
gundata.attachments:modify("Other", "Multi-Core Charge (RAILGUN)", v18);
