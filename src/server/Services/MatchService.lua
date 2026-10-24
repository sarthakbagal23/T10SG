--!strict
local MatchService = {}
MatchService.__index = MatchService

function MatchService.new(arena, ballService, matchRemote, config)
  local self = setmetatable({}, MatchService)
  self.Arena = arena
  self.BallService = ballService
  self.MatchRemote = matchRemote
  self.Config = config
  self.BlueScore = 0
  self.OrangeScore = 0
  self.TimeLeft = config.MatchLengthSeconds
  self.Finished = false
  self.GoalLocked = false

  for _, zone in ipairs(arena.GoalZones) do
    zone.Trigger.Touched:Connect(function(hit)
      self:HandleGoalTouch(zone, hit)
    end)
  end

  return self
end

function MatchService:Broadcast(eventType, message)
  self.MatchRemote:FireAllClients({
    type = eventType or "Update",
    blueScore = self.BlueScore,
    orangeScore = self.OrangeScore,
    timeLeft = self.TimeLeft,
    message = message or "",
  })
end

function MatchService:HandleGoalTouch(zone, hit)
  if hit ~= self.Arena.Ball or not self.BallService:IsLoose() then
    return
  end
  if self.Finished or self.GoalLocked then
    return
  end

  local ballPosition = self.Arena.Ball.Position
  local halfLength = self.Config.FieldLength / 2
  local insideGoalMouth = math.abs(ballPosition.X) <= self.Config.GoalWidth / 2 - 0.5
    and ballPosition.Y >= self.Config.BallSize / 2 * 0.8
    and ballPosition.Y <= self.Config.GoalHeight - self.Config.BallSize / 2
    and ballPosition.Z * zone.Sign >= halfLength - 0.5
    and ballPosition.Z * zone.Sign <= halfLength + 10

  if not insideGoalMouth then
    return
  end

  self.GoalLocked = true
  if zone.ScoringTeam == "Blue" then
    self.BlueScore += 1
  else
    self.OrangeScore += 1
  end

  self:Broadcast("Goal", string.upper(zone.ScoringTeam) .. " SCORES!")
  task.delay(self.Config.GoalPauseSeconds, function()
    if self.Finished then
      self.BallService:Reset()
      return
    end
    self.BallService:Reset()
    self.GoalLocked = false
    self:Broadcast("Update", "PLAY ON")
  end)
end

function MatchService:Start()
  self:Broadcast("Update", "E NEAR THE BALL TO TAKE POSSESSION")

  task.spawn(function()
    while true do
      for remaining = self.Config.MatchLengthSeconds, 0, -1 do
        self.TimeLeft = remaining
        self:Broadcast("Update", "")
        if remaining > 0 then
          task.wait(1)
        end
      end

      self.Finished = true
      self.GoalLocked = true
      local result = "DRAW"
      if self.BlueScore > self.OrangeScore then
        result = "BLUE WINS"
      elseif self.OrangeScore > self.BlueScore then
        result = "ORANGE WINS"
      end
      self.BallService:Reset()
      self:Broadcast("MatchEnd", "FULL TIME — " .. result)
      task.wait(8)

      self.BlueScore = 0
      self.OrangeScore = 0
      self.TimeLeft = self.Config.MatchLengthSeconds
      self.Finished = false
      self.GoalLocked = false
      self.BallService:Reset()
      self:Broadcast("Update", "NEW MATCH")
    end
  end)
end

return MatchService
