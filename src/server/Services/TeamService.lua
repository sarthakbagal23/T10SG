--!strict
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

local TeamService = {}
TeamService.__index = TeamService

local function getOrCreateTeam(name, brickColor)
  local team = Teams:FindFirstChild(name)
  if not team then
    team = Instance.new("Team")
    team.Name = name
    team.Parent = Teams
  end
  team.TeamColor = brickColor
  team.AutoAssignable = false
  return team
end

function TeamService.new()
  local self = setmetatable({}, TeamService)
  self.Blue = getOrCreateTeam("Blue", BrickColor.new("Bright blue"))
  self.Orange = getOrCreateTeam("Orange", BrickColor.new("Bright orange"))

  Players.PlayerAdded:Connect(function(player)
    self:AssignPlayer(player)
  end)

  for _, player in ipairs(Players:GetPlayers()) do
    self:AssignPlayer(player)
  end

  return self
end

function TeamService:AssignPlayer(player)
  local blueCount = 0
  local orangeCount = 0
  for _, candidate in ipairs(Players:GetPlayers()) do
    if candidate ~= player then
      if candidate.Team == self.Blue then
        blueCount += 1
      elseif candidate.Team == self.Orange then
        orangeCount += 1
      end
    end
  end

  player.Team = if blueCount <= orangeCount then self.Blue else self.Orange
  player.Neutral = false
end

function TeamService:GetTeamName(player)
  if player.Team == self.Blue then
    return "Blue"
  elseif player.Team == self.Orange then
    return "Orange"
  end
  return nil
end

return TeamService
