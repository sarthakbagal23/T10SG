--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))
local Services = script:WaitForChild("Services")
local TeamService = require(Services:WaitForChild("TeamService"))
local ArenaService = require(Services:WaitForChild("ArenaService"))
local BallService = require(Services:WaitForChild("BallService"))
local MatchService = require(Services:WaitForChild("MatchService"))

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local actionRemote = remotesFolder:FindFirstChild("ActionRequest")
if not actionRemote then
  actionRemote = Instance.new("RemoteEvent")
  actionRemote.Name = "ActionRequest"
  actionRemote.Parent = remotesFolder
end

local matchRemote = remotesFolder:FindFirstChild("MatchUpdate")
if not matchRemote then
  matchRemote = Instance.new("RemoteEvent")
  matchRemote.Name = "MatchUpdate"
  matchRemote.Parent = remotesFolder
end

local teamService = TeamService.new()
local arena = ArenaService.new(Config)
local ballService = BallService.new(arena.Ball, Config)
local matchService = MatchService.new(arena, ballService, matchRemote, Config)

local lastRequestAt = {}
actionRemote.OnServerEvent:Connect(function(player, action, payload)
  if typeof(action) ~= "string" then
    return
  end

  -- Basic server-side rate limit; every action is also validated in its service.
  local now = os.clock()
  local previous = lastRequestAt[player.UserId] or 0
  if now - previous < Config.RequestCooldownSeconds then
    return
  end
  lastRequestAt[player.UserId] = now

  if action == "Possess" then
    ballService:TryAcquire(player)
  elseif action == "Shoot" or action == "Pass" then
    if typeof(payload) ~= "table" then
      payload = {}
    end
    ballService:Kick(player, action, payload)
  end
end)

Players.PlayerRemoving:Connect(function(player)
  lastRequestAt[player.UserId] = nil
  if ballService:GetOwner() == player then
    ballService:Reset()
  end
end)

RunService.Heartbeat:Connect(function()
  if ballService:IsLoose() then
    local position = arena.Ball.Position
    if math.abs(position.X) > Config.OutOfBoundsX
      or math.abs(position.Z) > Config.OutOfBoundsZ
      or position.Y < Config.OutOfBoundsY then
      ballService:Reset()
    end
  end
end)

matchService:Start()
print("[T10SG] Server initialized. Try Studio's local server with 2+ players.")
