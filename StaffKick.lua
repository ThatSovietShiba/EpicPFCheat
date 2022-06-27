_G.Enabled = true;

_G.CertainPlayer = true; --Set to false if you want it to kick you if anyone joins and true if you want to use playerlist

_G.Kick = false; --If it kicks you or just gives a notification that someone joined

_G.Notify = true;

playerlist = {"pastehubOP","Raspberry Pi","Toothless the Dragon","Shay","AxisAngles","litozinnamon","BlazeAnimal","Fire","EpsiIonn","Drew_unfakE","Multi","nik","Alpha","MrNobody","SeekingTranquility","Krispy_Kreme03","Zen","tyler","Urban","D3vision","loujine","Activitx","Qyvar","Ckretlow","ECHELON","Rainsford","Miku","Duo","Spezi","shayne","SilentTelemetry","Threadripperr","Shelby","OMEGA942","tammy_the","hlelo_wolrd","Lyko","Tricky_Vic","Charley","DarkmanBree","mrblauwk","FlamingSwifferDuster","willow","bloxche","glowy_dingus","Terrance","Chelsea","sordide","CalsChaos","vivian","Cri","HAL","Poodros","Arekan","Hypo","Galactic_Bot","Quenty","CaesarSalad","Freqvently","scotter1995","XLR","okimawiw","Dev","ivrignavn","StacyVenables (spirals_j)","StriderPF","DeputyWick","SincereIyAbby","ShadowSentinal","Bolts","The_Wanderer","Reim","Ellie","rubie","anto_doe2","alphacobra16","Jinxed Puppy","Gundam0XZ",} -- Just add more if you want too
--------------------------------------------------------------------------------------SCRIPT
if(_G.Enabled == true) then

game:GetService("Players").PlayerAdded:Connect(function(user)
local Time = os.date("*t")

if(_G.CertainPlayer == true) then
    
for i = 1, #playerlist do
   
if(user.Name == playerlist[i]) then
        if(_G.Kick == true) and (_G.Notify == false) then
  game.Players.LocalPlayer:Kick("\nA risky player joined:\n"..playerlist[i].."\n"..Time.hour..":"..Time.min)
       end
    
if(_G.Kick == false) and (_G.Notify == true) then
print(playerlist[i].." Joined at ".." ,at: "..Time.hour..":"..Time.min.."")
game.StarterGui:SetCore("SendNotification", {
Title = "A Risky Player Joined!";
Text = playerlist[i].." at: "..Time.hour..":"..Time.min.."";
Duration = 7;
})    
makefolder("PastedHub/PhantomForces/StaffKick")
writefile("PastedHub/PhantomForces/StaffKick\\PlayerJoinedLIST.txt",
playerlist[i].." joined at "..Time.hour..":"..Time.min
    )
end
end
end
end
end)
end
