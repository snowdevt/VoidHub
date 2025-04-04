local key = "finallyupdate"

-- a very quick note: im cool

-- services
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

-- Create UI
local ui = Instance.new("ScreenGui")
ui.Name = "VoidHub"
ui.Parent = game.CoreGui
ui.ResetOnSpawn = false

-- Main Frame with Shadow
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 1, 0) -- Start off-screen
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = ui

local shadow = Instance.new("ImageLabel")
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Parent = frame

-- Dragger Bar
local dragger = Instance.new("Frame")
dragger.Size = UDim2.new(1, 0, 0, 40)
dragger.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
dragger.BorderSizePixel = 0
dragger.Parent = frame

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame
uiCorner:Clone().Parent = dragger

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "VOID Scripts Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = dragger

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = dragger
uiCorner:Clone().Parent = closeButton

-- Key Input Section
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0, 220, 0, 40)
keyBox.Position = UDim2.new(0.5, -110, 0.25, 0)
keyBox.PlaceholderText = "Enter Key Here"
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
keyBox.TextSize = 16
keyBox.Font = Enum.Font.Gotham
keyBox.Parent = frame
uiCorner:Clone().Parent = keyBox

local confirmButton = Instance.new("TextButton")
confirmButton.Size = UDim2.new(0, 120, 0, 40)
confirmButton.Position = UDim2.new(0.5, -60, 0.4, 0)
confirmButton.Text = "Verify"
confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
confirmButton.TextSize = 16
confirmButton.Font = Enum.Font.GothamBold
confirmButton.Parent = frame
uiCorner:Clone().Parent = confirmButton

-- Script Frame
local scriptFrame = Instance.new("ScrollingFrame")
scriptFrame.Size = UDim2.new(1, -20, 1, -60)
scriptFrame.Position = UDim2.new(0, 10, 0, 50)
scriptFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scriptFrame.ScrollBarThickness = 4
scriptFrame.BackgroundTransparency = 1
scriptFrame.Visible = false
scriptFrame.Parent = frame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.Parent = scriptFrame

-- Sounds
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://9112699520"
clickSound.Parent = ui

local successSound = Instance.new("Sound")
successSound.SoundId = "rbxassetid://9119722923"
successSound.Parent = ui

-- Tween Functions
local function tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Animation on Start
tween(frame, {Position = UDim2.new(0.5, -150, 0.5, -200)}, 0.5)

-- Draggable Functionality
local dragging, dragInput, dragStart, startPos
dragger.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragger.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
    end
end)

-- Button Hover Effects
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        tween(button, {BackgroundColor3 = button.BackgroundColor3:lerp(Color3.fromRGB(255, 255, 255), 0.1)}, 0.2)
    end)
    button.MouseLeave:Connect(function()
        tween(button, {BackgroundColor3 = button.BackgroundColor3:lerp(Color3.fromRGB(255, 255, 255), -0.1)}, 0.2)
    end)
end

addHoverEffect(closeButton)
addHoverEffect(confirmButton)

-- Script Button Creation
local function createScriptButton(name, scriptUrl)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = scriptFrame
    uiCorner:Clone().Parent = button
    
    addHoverEffect(button)
    
    button.MouseButton1Click:Connect(function()
        clickSound:Play()
        setclipboard("https://discord.gg/2QzyBNz34V")
        loadstring(game:HttpGet(scriptUrl))()
    end)
    
    scriptFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
end

-- Key Verification
confirmButton.MouseButton1Click:Connect(function()
    clickSound:Play()
    if keyBox.Text == key then
        successSound:Play()
        tween(keyBox, {Position = UDim2.new(0.5, -110, -0.2, 0), Transparency = 1}, 0.3)
        tween(confirmButton, {Position = UDim2.new(0.5, -60, -0.2, 0), Transparency = 1}, 0.3).Completed:Connect(function()
            keyBox.Visible = false
            confirmButton.Visible = false
            scriptFrame.Visible = true
            
            local scripts = {
                {"Blue Lock Rivals", "https://raw.githubusercontent.com/IAmJamal10/Scripts/refs/heads/main/BlueLock"},
                {"Murder Mystery 2", "https://raw.githubusercontent.com/Athergaming/Roblox-Murder-Mystery-2-Script/main/AtherHub%20Murder%20Mystery%202%20Script.lua"},
                {"Dead Rails", "https://raw.githubusercontent.com/Emplic/deathrails/refs/heads/main/bond"},
                {"Blox Fruits", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/BloxFruitsScript.lua"},
                {"Arsenal", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/ArsenalScript.lua"},
                {"Doors", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/DoorsScript.lua"},
                {"Da Hood", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/DaHoodScript.lua"},
                {"Brookhaven", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/BrookhavenScript.lua"},
                {"Pet Simulator X", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/PetSimulatorX.lua"},
                {"Tower of Hell", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/TowerOfHell.lua"},
                {"BedWars", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/BedWarsScript.lua"},
                {"Phantom Forces", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/PhantomForces.lua"},
                {"Anime Adventures", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/AnimeAdventures.lua"},
                {"Jujutsu Shenanigans", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/JujutsuShenanigans.lua"},
                {"Blade Ball", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/BladeBall.lua"},
                {"Volleyball Legends", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/VolleyballLegends.lua"},
                {"Fisch Script", "https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/FischScript.lua"}
            }
            
            for _, script in ipairs(scripts) do
                createScriptButton(script[1], script[2])
            end
        end)
    else
        keyBox.TextColor3 = Color3.fromRGB(255, 0, 0)
        keyBox.Text = "Invalid Key!"
        tween(keyBox, {Rotation = 5}, 0.1).Completed:Connect(function()
            tween(keyBox, {Rotation = -5}, 0.2).Completed:Connect(function()
                tween(keyBox, {Rotation = 0}, 0.1)
            end)
        end)
        wait(1)
        keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyBox.Text = ""
    end
end)

closeButton.MouseButton1Click:Connect(function()
    clickSound:Play()
    tween(frame, {Position = UDim2.new(0.5, -150, 1, 0)}, 0.5).Completed:Connect(function()
        ui:Destroy()
    end)
end)

setclipboard("https://discord.gg/2QzyBNz34V")
