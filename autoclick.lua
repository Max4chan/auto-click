-- AutoClicker aprimorado com FPS Counter e melhorias de robustez

local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Remove contador antigo se existir
pcall(function() CoreGui.FPSCounter:Destroy() end)

-- FPS Counter (apenas texto)
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSCounter"
fpsLabel.AnchorPoint = Vector2.new(0, 0)
fpsLabel.Position = UDim2.new(0, 5, 0, 5)
fpsLabel.Size = UDim2.new(0, 100, 0, 24)
fpsLabel.BackgroundTransparency = 1
fpsLabel.BorderSizePixel = 0
fpsLabel.TextColor3 = Color3.new(1, 1, 1)
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 18
fpsLabel.TextStrokeTransparency = 0.7
fpsLabel.Text = "FPS: 0"
fpsLabel.Parent = CoreGui

local lastUpdate = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastUpdate >= 1 then
        fpsLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        lastUpdate = tick()
    end
end)

-- AutoClicker
local autoClick = false
local clickThread = nil
local clickDelay = 0.05 -- ajuste a velocidade aqui

local function doClick()
    while autoClick do
        VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(0.01)
        VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(clickDelay)
    end
    clickThread = nil -- Garante que a thread seja liberada ao parar
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.ScrollLock then
        autoClick = not autoClick
        if autoClick and not clickThread then
            clickThread = task.spawn(doClick)
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "AutoClicker";
                    Text = "Ativado (Scroll Lock)!";
                    Duration = 2;
                })
            end)
        else
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "AutoClicker";
                    Text = "Desativado!";
                    Duration = 2;
                })
            end)
        end
    end
end)

print("AutoClicker carregado. Pressione Scroll Lock para ativar/desativar.")