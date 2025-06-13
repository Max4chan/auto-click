-- AutoClicker para KRNL, Delta e similares

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

local autoClick = false
local clicks = 0
local lastSecond = tick()
local cps = 0
local clickDelay = 0.05 -- 20 CPS

-- UI compacta
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClickerGui"
screenGui.Parent = Player:WaitForChild("PlayerGui")

local label = Instance.new("TextButton")
label.Name = "CPSLabel"
label.Size = UDim2.new(0, 120, 0, 28)
label.Position = UDim2.new(0, 10, 0, 10)
label.BackgroundTransparency = 0.3
label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 18
label.Text = "CPS: 0 | OFF"
label.AutoButtonColor = true
label.Parent = screenGui

local function updateLabel()
    label.Text = string.format("CPS: %d | %s", cps, autoClick and "ON" or "OFF")
    label.BackgroundColor3 = autoClick and Color3.fromRGB(50, 120, 50) or Color3.fromRGB(30, 30, 30)
end

-- Função universal para mouse1click
local function safeClick()
    if mouse1click then
        mouse1click()
    elseif syn and syn.mouse1click then
        syn.mouse1click()
    elseif mouse1press and mouse1release then
        mouse1press()
        mouse1release()
    end
end

-- Task única de autoclick
task.spawn(function()
    while true do
        if autoClick then
            safeClick()
            clicks = clicks + 1
            task.wait(clickDelay)
        else
            task.wait(0.1)
        end
    end
end)

-- Ativa/desativa clicando na UI
label.MouseButton1Click:Connect(function()
    autoClick = not autoClick
    updateLabel()
end)

-- Ativa/desativa pela tecla G
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        autoClick = not autoClick
        updateLabel()
    end
end)

-- Atualiza CPS na UI
RunService.RenderStepped:Connect(function()
    if tick() - lastSecond >= 1 then
        cps = clicks
        clicks = 0
        lastSecond = tick()
        updateLabel()
    end
end)
