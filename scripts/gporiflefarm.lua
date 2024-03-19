getgenv().GPO = { 
    Main = {
        ["Farm"] = true,
        ["ServerMode"] = "Public", -- Public,  Private.
        ["PrivateServerCode"] = nil, -- Leave This Nil Unless ServerMode Is Private.
        ["AutoBuyGeppo"] = true, -- Cost 50k Peli
        ["AutoWorldScroll"] = true,
    },
    RifleConfig = {
        ["AutoStats"] = true, -- Gun Mastery.
        ["AutoQuest"] = true, -- Will auto grab Quest.
    },
    ServerCheck = {
        ["BigServerCheck"] = false, -- Will Check If The Server Is To Big.
        ["MaxPeople"] = 8, -- Only Works if BigServerCheck Is On.
    },
    TweenSpeeds = { -- Test Speeds if need
        ["TweenUp"] = 125,
        ["TweenChest"] = 35, 
        ["TweenQuest"] = 25,
        ["TweenMain"] = 25,
    },
    Misc = {
        ["CapFps"] = false,
        ["FpsCap"] = 30,
        ["MuteVolume"] = true,
    }
}

if game.PlaceId == 10516808456 then return end
if game.PlaceId == 1730877806 then wait(2) game:GetService("TeleportService"):Teleport(3978370137, game:GetService("Players").LocalPlayer) end

wait(12)

local Test = false;

for _,v in pairs(getconnections(game:GetService("ScriptContext").Error)) do
    v:Disable()
end
 
for _,v in pairs(getconnections(game:GetService("LogService").MessageOut)) do
    v:Disable()
end

for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do  
    v:Disable()  
end

--** Server Hop Function **--
local function ServerHop()
    if Test then
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"
        local _place = game.PlaceId
        local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
        function ListServers(cursor)
           local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
           return Http:JSONDecode(Raw)
        end
        local Server, Next; repeat
           local Servers = ListServers(Next)
           Server = Servers.data[1]
           Next = Servers.nextPageCursor
        until Server
        TPS:TeleportToPlaceInstance(_place,Server.id,game.Players.LocalPlayer)
    else
        local module = loadstring(game:HttpGet("https://pastebin.com/raw/zpxwY148",true))()
        module:Teleport(game.PlaceId)
        wait(10)
        loadstring(game:HttpGet("https://pastebin.com/raw/pRfv5PQH",true))()
    end
end




-- Rifle Farm Config.
local AutoStats = getgenv().GPO.RifleConfig["AutoStats"];
local AutoQuest = getgenv().GPO.RifleConfig["AutoQuest"];
local ReadyToAutoFarm = false;
local RifleFarmPos = CFrame.new(7835.03515625, -2151.33203125, -17139.115234375);


-- Tween Speed Config.
local TweenUpSpeed = getgenv().GPO.TweenSpeeds["TweenUp"];
local TweenChestSpeed = getgenv().GPO.TweenSpeeds["TweenChest"];
local TweenMainSpeed = getgenv().GPO.TweenSpeeds["TweenMain"];
local TweenQuestSpeed = getgenv().GPO.TweenSpeeds["TweenQuest"];

task.spawn(function()
    while task.wait() do
        TweenUpSpeed = getgenv().GPO.TweenSpeeds["TweenUp"];
        TweenChestSpeed = getgenv().GPO.TweenSpeeds["TweenChest"];
        TweenMainSpeed = getgenv().GPO.TweenSpeeds["TweenMain"];
        TweenQuestSpeed = getgenv().GPO.TweenSpeeds["TweenQuest"];
    end
end)

-- Variables.
local Player = game:GetService("Players").LocalPlayer
local Name = game:GetService("Players").LocalPlayer.Name
local VU = game:GetService('VirtualUser')
if game.Players.LocalPlayer.Character:FindFirstChild("FallDamage") then 
	game.Players.LocalPlayer.Character.FallDamage:Remove()
end

-- Tween Function.
function CreateTweenFloat()
    local Twan = game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("ra") or Instance.new("BodyVelocity")
    Twan.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    Twan.Name = "ra"
    Twan.MaxForce = Vector3.new(100000, 100000, 100000)
    Twan.Velocity = Vector3.new(0,0,0)
end

local function TweenTP(e, studspersecond, offset)
    local input = Instance.new("Part", game.Workspace)
    input.CanCollide = false
    input.Transparency = 1
    input.CFrame = e * CFrame.new(0, offset, 0)
    input.Name = "LocationMain"
    wait()
    input.Anchored = true
    

    local replicatedStorage = game:GetService("ReplicatedStorage")

    CreateTweenFloat()

    local char = game:GetService("Players").LocalPlayer.Character;
    local input = input or print("input is nil");
    local studspersecond = studspersecond or 1000;
    local offset = offset or CFrame.new(0,0,0);
    local vec3, cframe;
 
    if typeof(input) == "table" then
        vec3 = Vector3.new(unpack(input)); cframe = CFrame.new(unpack(input));
    elseif typeof(input) ~= "Instance" then
        return print("wrong format used");
    end;
 
    --TweenPart
    Time = (char.HumanoidRootPart.Position - (vec3 or input.Position)).magnitude/studspersecond;
    local twn = game.TweenService:Create(char.HumanoidRootPart, TweenInfo.new(Time,Enum.EasingStyle.Linear), {CFrame = (cframe or input.CFrame)});

    repeat wait() until not game.Players.LocalPlayer.Character:FindFirstChild("SafeForceField") wait()
    twn:Play();
    twn.Completed:Wait();
    if game.workspace:FindFirstChild("LocationMain") then
        game.workspace.LocationMain:Destroy()
    end
    if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("ra") then
        game.Players.LocalPlayer.Character.HumanoidRootPart["ra"]:Destroy()
    end
end



-- Find Chest.
local plr = game.Players.LocalPlayer
local function GetNearestChest()
	local Chest
	for i, v in ipairs(game.workspace.Env:GetChildren()) do
		if plr.Character:FindFirstChild("HumanoidRootPart") and v.Name == "Chest" and v:IsA("Model") and v:FindFirstChild("MeshPart") then
			if not Chest then
                Chest=v 
            end
            if (v.MeshPart.Position - plr.Character.HumanoidRootPart.Position).magnitude<(Chest.MeshPart.Position - plr.Character.HumanoidRootPart.Position).magnitude then 
                Chest=v 
            end
		end
	end
	return Chest
end
function IsChestAlive(chest) 
    if chest.Parent and chest:FindFirstChild("MeshPart") then 
        return true
    end
    return false
end


-- Collect Chest.
function CollectChest(chest) 
    TweenTP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, TweenUpSpeed, 40)
    TweenTP(chest.MeshPart.CFrame, TweenChestSpeed, 6)
        if not IsChestAlive(chest) then
            return false 
        end
        if GetNearestChest()~=chest then 
            return false
        end
    if IsChestAlive(chest) then 
        wait(1)
       		for i, v in ipairs(game.workspace.Env:GetChildren()) do 
    		 local clickDetector = v:FindFirstChild("ClickDetector")
  			  if clickDetector then 
      		    if (v.Position - plr.Character.HumanoidRootPart.Position).magnitude < 10 then 
         	fireclickdetector(clickDetector)
        end
    end
end
    end
end


-- Chest Farm.
local function ChestFarm()
    local Chest = GetNearestChest()
    if Chest and Chest:FindFirstChild("MeshPart") and IsChestAlive(Chest) then
        CollectChest(Chest)
        wait(0.3)
        local plr = game.Players.LocalPlayer
        for i, v in ipairs(game.workspace.Env:GetChildren()) do 
            if v:FindFirstChild("ClickDetector") then 
                if (v.Position - plr.Character.HumanoidRootPart.Position).magnitude < 10 then 

                end
            end
        end
    else
        ServerHop()
    end
end


-- Get Quest.
local function SpawnQuest()
    local t = tick()
    repeat
        wait()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.T, false, game)
    until game.Players.LocalPlayer.PlayerGui:FindFirstChild("NPCCHAT") or tick() - t > 3
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("NPCCHAT") and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local cur = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
        repeat
            wait()
            if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and rac then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = cur + Vector3.new(0, -11, 0)
            end
            pcall(function()
                for k, v in pairs(getconnections(game.Players.LocalPlayer.PlayerGui:FindFirstChild("NPCCHAT").Frame.go.MouseButton1Click)) do
                    v:Fire()
                end
            end)
        until not game.Players.LocalPlayer.PlayerGui:FindFirstChild("NPCCHAT")
        -- This Means It Set Spawn Point
    end
end


-- Find Rifle.
local function FindRifle()
    if game.Players.LocalPlayer.Backpack:FindFirstChild("Rifle") or game.Players.LocalPlayer.Character:FindFirstChild("Rifle") then
        return true
    else
        return false
    end
end


-- At Fishman Check.
local function AtFishman()
    if workspace.islandMusic.SoundId == "rbxassetid://1842953528" then
        return true
    else
        return false
    end
end

-- Fishman TP.
local function FishmanTP()
    VU:CaptureController()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5639.86865, -92.762001, -16611.4688, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    wait(0.1)
    VU:SetKeyDown('0x61')
    wait(0.15)
    VU:SetKeyUp('0x61')
    VU:SetKeyDown('0x64')
    wait(0.15)
    VU:SetKeyUp('0x64')
end


-- Peli Check
local function PeliValue()
    return game:GetService("ReplicatedStorage"):FindFirstChild("Stats"..Name).Stats.Peli.Value
end


-- Checks




-- Rifle Farm Stuff
local function StartFarmFoundRifle()
    if AtFishman() then
        TweenTP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, TweenUpSpeed, 40) -- Tween Up.
        TweenTP(CFrame.new(7976.9326171875, -2152.83203125, -17074.994140625), TweenMainSpeed, 25) -- Tween To Guy For Spawn Point.
        wait(1)
        SpawnQuest() -- Get Spawn Point.
        TweenTP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, TweenUpSpeed, 75) -- Tween Up.
        TweenTP(CFrame.new(7835.03515625, -2151.33203125, -17139.115234375), TweenMainSpeed, 75) -- Tween Above Auto Farm Spot.
        TweenTP(CFrame.new(7835.03515625, -2151.33203125, -17139.115234375), TweenMainSpeed, 0) -- Tween Down To Auto Farm Spot.
        wait(1)
        ReadyToAutoFarm = true
    else
        repeat wait()
            FishmanTP()
            wait(3)
        until AtFishman()
        TweenTP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, TweenUpSpeed, 40) -- Tween Up.
        TweenTP(CFrame.new(7976.9326171875, -2152.83203125, -17074.994140625), TweenMainSpeed, 25) -- Tween To Guy For Spawn Point.
        wait(1)
        SpawnQuest() -- Get Spawn Point.
        TweenTP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, TweenUpSpeed, 75) -- Tween Up.
        TweenTP(CFrame.new(7835.03515625, -2151.33203125, -17139.115234375), TweenMainSpeed, 75) -- Tween Above Auto Farm Spot.
        TweenTP(CFrame.new(7835.03515625, -2151.33203125, -17139.115234375), TweenMainSpeed, 0) -- Tween Down To Auto Farm Spot.
        wait(1)
        ReadyToAutoFarm = true
    end
end


-- Rifle Farm Stuff
local function StartFarmNoRifle()
    if PeliValue() < 300 then
        repeat
            ChestFarm()
            wait(3.8)
        until PeliValue() >= 300
        TweenTP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, TweenUpSpeed, 40) -- Tween Up.
        TweenTP(CFrame.new(1012.418701171875, 12.75523567199707, 1129.62939453125), TweenMainSpeed, 40) -- Tween To Buy Rifle.
        wait(2)
        game:GetService("ReplicatedStorage").Events.Shop:InvokeServer(game:GetService("Workspace").BuyableItems.Rifle)
        repeat wait()
            game:GetService("ReplicatedStorage").Events.Shop:InvokeServer(game:GetService("Workspace").BuyableItems.Rifle)
            wait(0.2)
        until PeliValue() < 300
        repeat wait()
            game:GetService("ReplicatedStorage").Events.Tools:InvokeServer("equip", "Rifle")
        until game.Players.LocalPlayer.Backpack:FindFirstChild("Rifle") or game.Players.LocalPlayer.Character:FindFirstChild("Rifle")
        StartFarmFoundRifle()
        ReadyToAutoFarm = true
    elseif PeliValue() >= 300 then
        TweenTP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, TweenUpSpeed, 40) -- Tween Up.
        TweenTP(CFrame.new(1012.418701171875, 12.75523567199707, 1129.62939453125), TweenMainSpeed, 40) -- Tween To Buy Rifle.
        wait(2)
        game:GetService("ReplicatedStorage").Events.Shop:InvokeServer(game:GetService("Workspace").BuyableItems.Rifle)
        repeat wait()
            game:GetService("ReplicatedStorage").Events.Shop:InvokeServer(game:GetService("Workspace").BuyableItems.Rifle)
            wait(0.2)
        until PeliValue() < 300 or FindRifle()
        repeat wait()
            game:GetService("ReplicatedStorage").Events.Tools:InvokeServer("equip", "Rifle")
        until game.Players.LocalPlayer.Backpack:FindFirstChild("Rifle") or game.Players.LocalPlayer.Character:FindFirstChild("Rifle")
        StartFarmFoundRifle()
        ReadyToAutoFarm = true
    end
end






--// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //
--                            Starting Rifle Farm                         --
--// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //



game:GetService("ReplicatedStorage").Events.Tools:InvokeServer("equip", "Rifle")

-- HasRifle Start
if FindRifle() then
    repeat wait()
        game:GetService("ReplicatedStorage").Events.Tools:InvokeServer("equip", "Rifle")
    until game.Players.LocalPlayer.Backpack:FindFirstChild("Rifle") or game.Players.LocalPlayer.Character:FindFirstChild("Rifle")

    StartFarmFoundRifle()
else
    StartFarmNoRifle()
end









-- All The Autofarm Stuff
task.spawn(function()
    while task.wait(0.05) and ReadyToAutoFarm do

        local Level = game:GetService("ReplicatedStorage"):FindFirstChild("Stats"..Name).Stats.Level.Value
        local CurrentQuest = game:GetService("ReplicatedStorage"):FindFirstChild("Stats"..Name).Quest.CurrentQuest.Value
        local GunMastery = game:GetService("ReplicatedStorage"):FindFirstChild("Stats"..Name).Stats.GunMastery.Value
        local TPFarmPos = true;


        if getgenv().GPO.Main["Farm"] then
            --** RifleFarm **--
            if true then
                if TPFarmPos and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    TweenTP(CFrame.new(7835.03515625, -2151.33203125, -17139.115234375), TweenMainSpeed, 0) -- Tween To Autofarm POS.
                end
                if game:GetService("Workspace").NPCs:FindFirstChild("Fishman Karate User") and game:GetService("Workspace").NPCs:FindFirstChild("Fishman Karate User"):FindFirstChild("Head") then
                    -- Fire
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("CIcklcon"):FireServer("fire", {["Start"] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, ["Gun"] = "Rifle", ["joe"] = "true", ["Position"] = game:GetService("Workspace").NPCs:WaitForChild("Fishman Karate User"):FindFirstChild("Head").Position + Vector3.new(0, 0, 0)})

                    -- Reload
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("CIcklcon"):WaitForChild("gunFunctions"):InvokeServer("reload", {["Gun"] = "Rifle"})
                end
            end


            -- Auto Equip.
            if not game.Players.LocalPlayer.Character:FindFirstChild("Rifle") then
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                    if game.Players.LocalPlayer ~= nil and game.Players.LocalPlayer.Backpack and game.Players.LocalPlayer.Backpack:FindFirstChild("Rifle") then
                        game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):EquipTool(game.Players.LocalPlayer.Backpack:WaitForChild("Rifle"))     
                    end
                end
            end


            -- Auto Stats.
            if getgenv().GPO.RifleConfig["AutoStats"] then
                if GunMastery <= 655 then
                    game:GetService("ReplicatedStorage").Events.stats:FireServer("GunMastery", nil, 1)
                end
            end


            -- Auto Quest.
            if getgenv().GPO.RifleConfig["AutoQuest"] then
                if Level >= 190 and CurrentQuest == "None" then
                    TPFarmPos = false
                    TweenTP(CFrame.new(7733.7294921875, -2175.83154296875, -17222.744140625), TweenQuestSpeed, 0) -- Tween To Get Quest.
                    game:GetService("ReplicatedStorage").Events.Quest:InvokeServer({"takequest", "Help becky"}) -- Grab Quest
                    TweenTP(CFrame.new(7835.03515625, -2151.33203125, -17139.115234375), TweenQuestSpeed, 20) -- Tween Back To Autofarm 1.
                    TweenTP(CFrame.new(7835.03515625, -2151.33203125, -17139.115234375), TweenQuestSpeed, 0) -- Tween Back To Autofarm 2.
                    TPFarmPos = true
                end
            end

            -- Auto Buy Geppo.
            if getgenv().GPO.Main["AutoBuyGeppo"] then
                if PeliValue() >= 50000 and game:GetService("ReplicatedStorage"):FindFirstChild("Stats"..game.Players.LocalPlayer.Name).Skills.skyWalk.Value == false then
                    repeat task.wait()
                        game:GetService("ReplicatedStorage").Events.learnStyle:FireServer("skyWalkTrainer")
                    until game:GetService("ReplicatedStorage"):FindFirstChild("Stats"..game.Players.LocalPlayer.Name).Skills.skyWalk.Value == true
                end
            end

            if getgenv().GPO.Main["AutoWorldScroll"] then
                if Level >= 575 then
                    local httpService = game:GetService("HttpService")
                    local inventoryData = httpService:JSONDecode(game:GetService("ReplicatedStorage")["Stats"..game.Players.LocalPlayer.Name].Inventory.Inventory.Value)
                    
                    if inventoryData["World Scroll"] then
                        print("You Already Have World Scroll")
                    else
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12182.2041, 3.07369924, -18545.7578, 0.00755592529, 6.60752564e-09, -0.999971449, -1.50575126e-08, 1, 6.49393783e-09, 0.999971449, 1.50080144e-08, 0.00755592529)
                        wait(1)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12182.2041, 3.07369924, -18545.7578, 0.00755592529, 6.60752564e-09, -0.999971449, -1.50575126e-08, 1, 6.49393783e-09, 0.999971449, 1.50080144e-08, 0.00755592529)
                        wait(0.2)
                        if game:GetService("Workspace").Effects:FindFirstChild("World Scroll") then
                            repeat wait()
                                local httpService = game:GetService("HttpService") 
                                local function tp() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12182.2041, 3.07369924, -18545.7578, 0.00755592529, 6.60752564e-09, -0.999971449, -1.50575126e-08, 1, 6.49393783e-09, 0.999971449, 1.50080144e-08, 0.00755592529) end
                                local function prox() fireproximityprompt(game:GetService("Workspace").Effects:WaitForChild("World Scroll").ProximityPrompt, 500) end
                                tp() prox() prox() wait(1) tp() prox() prox() wait(.3) tp() prox() prox() wait(.2) prox() tp() prox() prox() 
                            until inventoryData["World Scroll"]
                            game:GetService("TeleportService"):Teleport(10516808456, game:GetService("Players").LocalPlayer)
                        else
                            print("World Scroll Isnt Spawned")
                            queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
                            game.Players.LocalPlayer.OnTeleport:Connect(function(State)
                                if queueteleport then
                                    queueteleport([[
                                        wait(14)
                                        local httpService = game:GetService("HttpService")
                                        local inventoryData = httpService:JSONDecode(game:GetService("ReplicatedStorage")["Stats"..game.Players.LocalPlayer.Name].Inventory.Inventory.Value)
                                        
                                        if inventoryData["World Scroll"] then
                                            print("You Already Have World Scroll")
                                        else
                                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12182.2041, 3.07369924, -18545.7578, 0.00755592529, 6.60752564e-09, -0.999971449, -1.50575126e-08, 1, 6.49393783e-09, 0.999971449, 1.50080144e-08, 0.00755592529)
                                            wait(1)
                                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12182.2041, 3.07369924, -18545.7578, 0.00755592529, 6.60752564e-09, -0.999971449, -1.50575126e-08, 1, 6.49393783e-09, 0.999971449, 1.50080144e-08, 0.00755592529)
                                            wait(0.2)
                                            if game:GetService("Workspace").Effects:FindFirstChild("World Scroll") then
                                                repeat wait()
                                                    local httpService = game:GetService("HttpService") 
                                                    local function tp() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12182.2041, 3.07369924, -18545.7578, 0.00755592529, 6.60752564e-09, -0.999971449, -1.50575126e-08, 1, 6.49393783e-09, 0.999971449, 1.50080144e-08, 0.00755592529) end
                                                    local function prox() fireproximityprompt(game:GetService("Workspace").Effects:WaitForChild("World Scroll").ProximityPrompt, 500) end
                                                    tp() prox() prox() wait(1) tp() prox() prox() wait(.3) tp() prox() prox() wait(.2) prox() tp() prox() prox() 
                                                until inventoryData["World Scroll"]
                                                game:GetService("TeleportService"):Teleport(10516808456, game:GetService("Players").LocalPlayer)
                                            else
                                                print("World Scroll Isnt Spawned")
                                            end
                                        end
                                    ]])
                                end
                            end)
                            local module = loadstring(game:HttpGet("https://pastebin.com/raw/zpxwY148",true))()
                            module:Teleport(game.PlaceId)
                            wait(10)
                            loadstring(game:HttpGet("https://pastebin.com/raw/pRfv5PQH",true))()
                        end
                    end
                end
            end
        end
    end
end)
