--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local BallService = {}
BallService.__index = BallService

local function isFiniteNumber(value)
  return typeof(value) == "number" and value == value and math.abs(value) < 100000
end

local function isFiniteVector(vector)
  return typeof(vector) == "Vector3"
    and isFiniteNumber(vector.X)
    and isFiniteNumber(vector.Y)
    and isFiniteNumber(vector.Z)
end

local function getAliveCharacter(player)
  local character = player.Character
  if not character then
    return nil, nil, nil
  end
  local root = character:FindFirstChild("HumanoidRootPart")
  local humanoid = character:FindFirstChildOfClass("Humanoid")
  if not root or not root:IsA("BasePart") or not humanoid or humanoid.Health <= 0 then
    return nil, nil, nil
  end
  return character, root, humanoid
end

function BallService.new(ball, config)
  local self = setmetatable({}, BallService)
  self.Ball = ball
  self.Config = config
  self.Owner = nil
  self.LastKickAt = {}
  self.LastPossessAt = {}

  pcall(function()
    ball:SetNetworkOwner(nil)
  end)

  RunService.Heartbeat:Connect(function()
    if self.Owner then
      local _, root, humanoid = getAliveCharacter(self.Owner)
      if not root or not humanoid then
        self:Reset()
        return
      end

      local forward = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
      if forward.Magnitude < 0.01 then
        forward = Vector3.new(0, 0, -1)
      else
        forward = forward.Unit
      end
      local position = root.Position
        + forward * self.Config.PossessionOffset
        + Vector3.new(0, -self.Config.PossessionDropOffset, 0)
      self.Ball.CFrame = CFrame.new(position)
    end
  end)

  return self
end

function BallService:GetOwner()
  return self.Owner
end

function BallService:IsLoose()
  return self.Owner == nil
end

function BallService:TryAcquire(player)
  if self.Owner ~= nil then
    return false
  end

  local now = os.clock()
  local previous = self.LastPossessAt[player.UserId] or 0
  if now - previous < self.Config.RequestCooldownSeconds then
    return false
  end
  self.LastPossessAt[player.UserId] = now

  local _, root = getAliveCharacter(player)
  if not root then
    return false
  end
  if (self.Ball.Position - root.Position).Magnitude > self.Config.PossessionDistance then
    return false
  end

  self.Owner = player
  self.Ball.AssemblyLinearVelocity = Vector3.zero
  self.Ball.AssemblyAngularVelocity = Vector3.zero
  self.Ball.Anchored = true
  self.Ball.CanCollide = false
  self.Ball.CanTouch = false
  self.Ball.CFrame = CFrame.new(root.Position + root.CFrame.LookVector * self.Config.PossessionOffset
    + Vector3.new(0, -self.Config.PossessionDropOffset, 0))
  return true
end

function BallService:Kick(player, action, payload)
  if self.Owner ~= player then
    return false
  end

  local now = os.clock()
  local lastKick = self.LastKickAt[player.UserId] or 0
  if now - lastKick < self.Config.KickCooldownSeconds then
    return false
  end
  self.LastKickAt[player.UserId] = now

  local _, root = getAliveCharacter(player)
  if not root then
    self:Reset()
    return false
  end

  local rawDirection = payload and payload.direction
  if not isFiniteVector(rawDirection) then
    rawDirection = root.CFrame.LookVector
  end
  local direction = Vector3.new(rawDirection.X, 0, rawDirection.Z)
  if direction.Magnitude < 0.05 then
    direction = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
  end
  if direction.Magnitude < 0.05 then
    direction = Vector3.new(0, 0, -1)
  end
  direction = direction.Unit

  local charge = payload and payload.charge
  if not isFiniteNumber(charge) then
    charge = 0
  end
  charge = math.clamp(charge, 0, 1)

  local speed
  local lift
  if action == "Pass" then
    speed = self.Config.PassSpeed
    lift = self.Config.PassLift
  else
    speed = self.Config.ShotSpeedMin
      + (self.Config.ShotSpeedMax - self.Config.ShotSpeedMin) * charge
    lift = self.Config.ShotLiftMin
      + (self.Config.ShotLiftMax - self.Config.ShotLiftMin) * charge
  end

  local forward = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
  if forward.Magnitude < 0.05 then
    forward = Vector3.new(0, 0, -1)
  else
    forward = forward.Unit
  end

  self.Owner = nil
  self.Ball.CFrame = CFrame.new(root.Position + forward * (self.Config.PossessionOffset + 0.5)
    + Vector3.new(0, -self.Config.PossessionDropOffset, 0))
  self.Ball.Anchored = false
  self.Ball.CanCollide = true
  self.Ball.CanTouch = true

  pcall(function()
    self.Ball:SetNetworkOwner(nil)
  end)

  local mass = math.max(self.Ball.AssemblyMass, 0.1)
  self.Ball:ApplyImpulse(direction * mass * speed + Vector3.new(0, mass * lift, 0))
  return true
end

function BallService:Reset()
  self.Owner = nil
  local ball = self.Ball
  ball.AssemblyLinearVelocity = Vector3.zero
  ball.AssemblyAngularVelocity = Vector3.zero
  ball.Anchored = true
  ball.CanCollide = false
  ball.CanTouch = false
  ball.CFrame = CFrame.new(0, self.Config.BallSpawnHeight, 0)
  ball.Anchored = false
  ball.CanCollide = true
  ball.CanTouch = true
  pcall(function()
    ball:SetNetworkOwner(nil)
  end)
end

Players.PlayerRemoving:Connect(function(player)
  -- The active owner is checked by Heartbeat; clean up per-player rate-limit data.
  -- This listener does not depend on a specific BallService instance.
end)

return BallService
