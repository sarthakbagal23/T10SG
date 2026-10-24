--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local actionRemote = remotes:WaitForChild("ActionRequest")
local matchRemote = remotes:WaitForChild("MatchUpdate")

local navy = Color3.fromRGB(13, 20, 29)
local panel = Color3.fromRGB(23, 33, 45)
local white = Color3.fromRGB(244, 247, 250)
local muted = Color3.fromRGB(177, 190, 204)
local blue = Color3.fromRGB(65, 151, 255)
local orange = Color3.fromRGB(255, 145, 58)
local accent = Color3.fromRGB(79, 218, 151)

local screen = Instance.new("ScreenGui")
screen.Name = "T10HUD"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.DisplayOrder = 10
screen.Parent = player:WaitForChild("PlayerGui")

local function addCorner(guiObject, radius)
  local corner = Instance.new("UICorner")
  corner.CornerRadius = UDim.new(0, radius)
  corner.Parent = guiObject
end

local function makeLabel(parent, name, text, size, position, fontSize, color, font)
  local label = Instance.new("TextLabel")
  label.Name = name
  label.BackgroundTransparency = 1
  label.Size = size
  label.Position = position
  label.Text = text
  label.TextColor3 = color
  label.TextSize = fontSize
  label.Font = font or Enum.Font.GothamMedium
  label.TextScaled = false
  label.TextWrapped = false
  label.Parent = parent
  return label
end

local scorePanel = Instance.new("Frame")
scorePanel.Name = "ScorePanel"
scorePanel.Size = UDim2.fromOffset(460, 82)
scorePanel.Position = UDim2.new(0.5, -230, 0, 20)
scorePanel.BackgroundColor3 = navy
scorePanel.BackgroundTransparency = 0.08
scorePanel.BorderSizePixel = 0
scorePanel.Parent = screen
addCorner(scorePanel, 14)

local blueLabel = makeLabel(scorePanel, "BlueTeam", "BLUE", UDim2.fromOffset(110, 28), UDim2.fromOffset(16, 28), 18, blue, Enum.Font.GothamBold)
blueLabel.TextXAlignment = Enum.TextXAlignment.Left

local scoreLabel = makeLabel(scorePanel, "Score", "0  —  0", UDim2.fromOffset(160, 38), UDim2.new(0.5, -80, 0, 25), 27, white, Enum.Font.GothamBlack)

local orangeLabel = makeLabel(scorePanel, "OrangeTeam", "ORANGE", UDim2.fromOffset(110, 28), UDim2.new(1, -126, 0, 28), 18, orange, Enum.Font.GothamBold)
orangeLabel.TextXAlignment = Enum.TextXAlignment.Right

local timerLabel = makeLabel(scorePanel, "Timer", "03:00", UDim2.fromOffset(100, 20), UDim2.new(0.5, -50, 0, 4), 13, muted, Enum.Font.GothamBold)

local statusPanel = Instance.new("Frame")
statusPanel.Name = "StatusPanel"
statusPanel.Size = UDim2.fromOffset(430, 48)
statusPanel.Position = UDim2.new(0.5, -215, 0, 112)
statusPanel.BackgroundColor3 = panel
statusPanel.BackgroundTransparency = 0.12
statusPanel.BorderSizePixel = 0
statusPanel.Parent = screen
addCorner(statusPanel, 10)

local statusLabel = makeLabel(statusPanel, "Status", "T10SG  •  E NEAR THE BALL TO TAKE POSSESSION", UDim2.new(1, -18, 1, 0), UDim2.fromOffset(9, 0), 13, white, Enum.Font.GothamSemibold)
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

local controlsPanel = Instance.new("Frame")
controlsPanel.Name = "ControlsPanel"
controlsPanel.Size = UDim2.fromOffset(390, 76)
controlsPanel.Position = UDim2.new(0.5, -195, 1, -96)
controlsPanel.BackgroundColor3 = navy
controlsPanel.BackgroundTransparency = 0.08
controlsPanel.BorderSizePixel = 0
controlsPanel.Parent = screen
addCorner(controlsPanel, 12)

makeLabel(controlsPanel, "ControlsHeader", "CONTROLS", UDim2.fromOffset(100, 18), UDim2.fromOffset(14, 8), 11, muted, Enum.Font.GothamBold)
makeLabel(controlsPanel, "ControlHints", "E  Possess      LMB  Charge / Shoot      RMB  Pass", UDim2.new(1, -24, 0, 22), UDim2.fromOffset(12, 28), 12, white, Enum.Font.GothamMedium)

local chargeBackground = Instance.new("Frame")
chargeBackground.Name = "ChargeBackground"
chargeBackground.Size = UDim2.new(1, -28, 0, 5)
chargeBackground.Position = UDim2.fromOffset(14, 60)
chargeBackground.BackgroundColor3 = Color3.fromRGB(48, 61, 76)
chargeBackground.BorderSizePixel = 0
chargeBackground.Parent = controlsPanel
addCorner(chargeBackground, 3)

local chargeFill = Instance.new("Frame")
chargeFill.Name = "ChargeFill"
chargeFill.Size = UDim2.new(0, 0, 1, 0)
chargeFill.BackgroundColor3 = accent
chargeFill.BorderSizePixel = 0
chargeFill.Parent = chargeBackground
addCorner(chargeFill, 3)

local charging = false
local chargeStartedAt = 0
local maxChargeSeconds = 1.15
local lastStatus = ""

local function getAimDirection()
  local camera = workspace.CurrentCamera
  if not camera then
    return Vector3.new(0, 0, -1)
  end
  return camera.CFrame.LookVector
end

local function formatTime(seconds)
  seconds = math.max(0, math.floor(seconds or 0))
  local minutes = math.floor(seconds / 60)
  local remainder = seconds % 60
  return string.format("%02d:%02d", minutes, remainder)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
  if gameProcessed then
    return
  end

  if input.KeyCode == Enum.KeyCode.E then
    actionRemote:FireServer("Possess")
  elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
    charging = true
    chargeStartedAt = os.clock()
  elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
    actionRemote:FireServer("Pass", {
      direction = getAimDirection(),
      charge = 0,
    })
  end
end)

UserInputService.InputEnded:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 and charging then
    charging = false
    local charge = math.clamp((os.clock() - chargeStartedAt) / maxChargeSeconds, 0, 1)
    actionRemote:FireServer("Shoot", {
      direction = getAimDirection(),
      charge = charge,
    })
  end
end)

RunService.RenderStepped:Connect(function()
  if charging then
    local charge = math.clamp((os.clock() - chargeStartedAt) / maxChargeSeconds, 0, 1)
    chargeFill.Size = UDim2.new(charge, 0, 1, 0)
    chargeFill.BackgroundColor3 = charge >= 0.85 and orange or accent
  else
    chargeFill.Size = UDim2.new(0, 0, 1, 0)
    chargeFill.BackgroundColor3 = accent
  end
end)

matchRemote.OnClientEvent:Connect(function(data)
  if typeof(data) ~= "table" then
    return
  end

  local blueScore = tonumber(data.blueScore) or 0
  local orangeScore = tonumber(data.orangeScore) or 0
  scoreLabel.Text = string.format("%d  —  %d", blueScore, orangeScore)
  timerLabel.Text = formatTime(data.timeLeft)

  local message = typeof(data.message) == "string" and data.message or ""
  if message ~= "" then
    statusLabel.Text = message
    lastStatus = message
  elseif data.type == "Update" then
    if lastStatus == "" or lastStatus == "PLAY ON" or lastStatus == "NEW MATCH" then
      statusLabel.Text = "T10SG  •  E NEAR THE BALL TO TAKE POSSESSION"
    end
  end

  if data.type == "Goal" or data.type == "MatchEnd" then
    local receivedMessage = message
    task.delay(2.5, function()
      if statusLabel.Parent and lastStatus == receivedMessage then
        lastStatus = ""
        statusLabel.Text = "T10SG  •  E NEAR THE BALL TO TAKE POSSESSION"
      end
    end)
  end
end)
