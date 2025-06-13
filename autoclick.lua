-- AutoClicker otimizado e seguro para Roblox Studio
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local autoClick = false
local clicks = 0
local lastSecond = tick()
local cps = 0
local clickDelay = 0.05 -- 20 CPS, ajuste se quiser (não recomendo menos que isso!)

-- UI compacta e interativa
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

-- Função autoclick
local clickTask = nil
local function doClicks()
    while autoClick do
        -- Clica na posição do mouse (VirtualUser funciona apenas em Roblox Studio/local)
        VirtualUser:Button1Down(Vector2.new(Mouse.X, Mouse.Y), workspace.CurrentCamera.CFrame)
        VirtualUser:Button1Up(Vector2.new(Mouse.X, Mouse.Y), workspace.CurrentCamera.CFrame)
        clicks = clicks + 1
        task.wait(clickDelay)
    end
end

-- Ativa/desativa clicando na UI
label.MouseButton1Click:Connect(function()
    autoClick = not autoClick
    updateLabel()
    if autoClick and not clickTask then
        clickTask = task.spawn(doClicks)
    end
end)

-- Ativa/desativa pela tecla G
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        autoClick = not autoClick
        updateLabel()
        if autoClick and not clickTask then
            clickTask = task.spawn(doClicks)
        end
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
    -- Reseta a task se parar o autoclick
    if not autoClick then
        clickTask = nil
    end
end)
