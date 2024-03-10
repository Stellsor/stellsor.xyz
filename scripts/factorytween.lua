getgenv().Config = {
    ["Speed"] = 50,
    ["ChargeTimes"] = 25
} 

for _,v in pairs(getconnections(game:GetService("ScriptContext").Error)) do
    v:Disable()
end
 
for _,v in pairs(getconnections(game:GetService("LogService").MessageOut)) do
    v:Disable()
end

for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do  
    v:Disable()  
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
    input.CFrame = e * CFrame.new(0, offset, 0)
    input.Transparency = 1
    input.CanCollide = false
    input.Name = "LocationMain"
    wait()
    input.Anchored = true



    local replicatedStorage = game:GetService("ReplicatedStorage")
    local faceMouseEvent = replicatedStorage.Events:FindFirstChild("faceMouse")

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
    faceMouseEvent:FireServer()
    twn:Play();
    twn.Completed:Wait();
    faceMouseEvent:FireServer()
    if game.workspace:FindFirstChild("LocationMain") then
        game.workspace.LocationMain:Destroy()
    end
    if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("ra") then
        game.Players.LocalPlayer.Character.HumanoidRootPart["ra"]:Destroy()
    end
end




-- Function to calculate combined score based on Y-coordinate difference and Euclidean distance
local function calculateScore(localPosition, NPCPosition)
    local yDifference = math.abs(localPosition.Y - NPCPosition.Y)
    local distance = (localPosition - NPCPosition).magnitude
    -- You can adjust the weights for each factor as needed
    return yDifference + distance
end

-- Function to find the closest Scientist NPC to the local player based on combined score
local function getClosestScientistNPCToLocalPlayer()
    local localPlayer = game:GetService("Players").LocalPlayer
    local localCharacter = localPlayer.Character
    if not localCharacter then
        return nil
    end

    local localPosition = localCharacter.PrimaryPart.Position
    local NPCs = game.Workspace.NPCs:GetChildren() -- Get children of the Workspace.NPCs folder
    local closestNPC = nil
    local minScore = math.huge -- Set initial score to a very large number

    -- Iterate through each NPC and find the one with minimum combined score
    for _, NPC in ipairs(NPCs) do
        if (NPC.Name == "Scientist" or NPC.Name == "Devil Fruit Scientist" or NPC.Name == "Law") and NPC:FindFirstChild("HumanoidRootPart") then -- Check if NPC's name is "Scientist" and it has a HumanoidRootPart
            local NPCPosition = NPC.HumanoidRootPart.Position
            local score = calculateScore(localPosition, NPCPosition)
            if score < minScore then
                minScore = score
                closestNPC = NPC
            end
        end
    end

    return closestNPC
end

local busoFound = false
local Wave = 0
game:GetService("RunService").RenderStepped:Connect(function()
    local closestScientistNPC = getClosestScientistNPCToLocalPlayer()
    if closestScientistNPC then
        if closestScientistNPC.Name == "Devil Fruit Scientist" and not busoFound then
            task.spawn(function()
                repeat task.wait(1)
                    local args = {[1] = "Buso"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Haki"):FireServer(unpack(args))
                until busoFound
            end)
        end
        local Distance = (closestScientistNPC.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        TweenTP(closestScientistNPC.HumanoidRootPart.CFrame, getgenv().Config["Speed"], CFrame.new())
    else
        if workspace.Env.FactoryPool.HumanoidRootPart and workspace.Env.FactoryPool.barrelHP.Value > 10 and workspace.Islands["Rose Kingdom"].Factory.FrontDoor.Top.BillboardGui.TextLabel.Text:find("CURRENT ALERT LEVEL:") then
            TweenTP(CFrame.new(8643.7998046875, 309.6028137207031, 11825.2607421875), getgenv().Config["Speed"], CFrame.new())
        end
    end
end)

task.spawn(function()
    while wait() do
        for _, part in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if part:IsA("NumberValue") then
                if string.find(part.Name, "Buso") then
                    busoFound = true
                else
                    busoFound = false
                end
            elseif not string.find(part.Name, "Buso") then
                busoFound = false
            end
        end
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if v:IsA('BasePart') and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end
end)

for i = 1, getgenv().Config["ChargeTimes"] do
    game:GetService("ReplicatedStorage").Events.Skill:InvokeServer("Firework Parade")
    task.wait(20)
end
