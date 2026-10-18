-- Servicios necesarios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- Variables de estado
local speedEnabled = false
local speedValue = 16
local jumpEnabled = false
local jumpValue = 50
local noclipEnabled = false

-- Crear la interfaz gráfica (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GutierrezHub"
ScreenGui.ResetOnSpawn = false
-- Usar CoreGui si es posible, si no PlayerGui
pcall(function()
	ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
	ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Botón Flotante Minimizado (Círculo "Gutiérrez Hub")
local MinButton = Instance.new("TextButton")
MinButton.Name = "MinButton"
MinButton.Size = UDim2.new(0, 60, 0, 60)
MinButton.Position = UDim2.new(0.1, 0, 0.1, 0)
MinButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.TextSize = 11
MinButton.Font = Enum.Font.SourceSansBold
MinButton.TextWrapped = true
MinButton.Text = "Gutiérrez Hub"
MinButton.Visible = false
MinButton.Parent = ScreenGui

local UICornerMin = Instance.new("UICorner")
UICornerMin.CornerRadius = UDim.new(1, 0) -- Hace que sea un círculo perfecto
UICornerMin.Parent = MinButton

-- Ventana Principal del Menú
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Permite mover la ventana principal
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

-- Título del Menú
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Gutiérrez Hub - Admin Panel"
Title.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 10)
UICornerTitle.Parent = Title

-- Botón de Minimizar (Dentro del menú)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Text = "-"
MinimizeBtn.Parent = MainFrame

local UICornerMinBtn = Instance.new("UICorner")
UICornerMinBtn.CornerRadius = UDim.new(1, 0)
UICornerMinBtn.Parent = MinimizeBtn

-- Función para alternar entre menú y botón flotante
local function toggleMinimize()
	MainFrame.Visible = not MainFrame.Visible
	MinButton.Visible = not MainFrame.Visible
end

MinimizeBtn.MouseButton1Click:Connect(toggleMinimize)
MinButton.MouseButton1Click:Connect(toggleMinimize)

-- Hacer arrastrable el botón flotante (en dispositivos móviles y PC)
local dragging, dragInput, dragStart, startPos
MinButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MinButton.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		MinButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- --- CONTROLES DENTRO DEL MENÚ ---

-- 1. Velocidad (Speed)
local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Size = UDim2.new(0, 260, 0, 35)
SpeedToggle.Position = UDim2.new(0, 20, 0, 55)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggle.TextSize = 14
SpeedToggle.Font = Enum.Font.SourceSansBold
SpeedToggle.Text = "Activar Velocidad: OFF"
SpeedToggle.Parent = MainFrame

SpeedToggle.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	SpeedToggle.Text = "Activar Velocidad: " .. (speedEnabled and "ON" or "OFF")
	SpeedToggle.BackgroundColor3 = speedEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0, 260, 0, 30)
SpeedBox.Position = UDim2.new(0, 20, 0, 95)
SpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.TextSize = 14
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.PlaceholderText = "Velocidad (Ej: 100 o 1000)"
SpeedBox.Text = "16"
SpeedBox.Parent = MainFrame

SpeedBox.FocusLost:Connect(function()
	local val = tonumber(SpeedBox.Text)
	if val then
		speedValue = val
	else
		SpeedBox.Text = tostring(speedValue)
	end
end)

-- 2. Salto (JumpPower)
local JumpToggle = Instance.new("TextButton")
JumpToggle.Size = UDim2.new(0, 260, 0, 35)
JumpToggle.Position = UDim2.new(0, 20, 0, 135)
JumpToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpToggle.TextSize = 14
JumpToggle.Font = Enum.Font.SourceSansBold
JumpToggle.Text = "Activar Salto: OFF"
JumpToggle.Parent = MainFrame

JumpToggle.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
	JumpToggle.Text = "Activar Salto: " .. (jumpEnabled and "ON" or "OFF")
	JumpToggle.BackgroundColor3 = jumpEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

local JumpBox = Instance.new("TextBox")
JumpBox.Size = UDim2.new(0, 260, 0, 30)
JumpBox.Position = UDim2.new(0, 20, 0, 175)
JumpBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpBox.TextSize = 14
JumpBox.Font = Enum.Font.SourceSans
JumpBox.PlaceholderText = "Salto (Ej: 100)"
JumpBox.Text = "50"
JumpBox.Parent = MainFrame

JumpBox.FocusLost:Connect(function()
	local val = tonumber(JumpBox.Text)
	if val then
		jumpValue = val
	else
		JumpBox.Text = tostring(jumpValue)
	end
end)

-- 3. Noclip
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(0, 260, 0, 35)
NoclipToggle.Position = UDim2.new(0, 20, 0, 215)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NoclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipToggle.TextSize = 14
NoclipToggle.Font = Enum.Font.SourceSansBold
NoclipToggle.Text = "Noclip: OFF"
NoclipToggle.Parent = MainFrame

NoclipToggle.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	NoclipToggle.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
	NoclipToggle.BackgroundColor3 = noclipEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

-- Créditos
local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(1, 0, 0, 30)
Credits.Position = UDim2.new(0, 0, 1, -35)
Credits.BackgroundTransparency = 1
Credits.TextColor3 = Color3.fromRGB(150, 150, 150)
Credits.TextSize = 12
Credits.Font = Enum.Font.SourceSansItalic
Credits.Text = "Hecho para Gutiérrez Hub"
Credits.Parent = MainFrame

-- --- BUCLE PRINCIPAL DE FUNCIONALIDADES ---
RunService.Stepped:Connect(function()
	local character = player.Character
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	
	-- Aplicar Velocidad
	if speedEnabled and humanoid then
		humanoid.WalkSpeed = speedValue
	end
	
	-- Aplicar Salto
	if jumpEnabled and humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = jumpValue
	end
	
	-- Aplicar Noclip (atraviesa paredes)
	if noclipEnabled then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
