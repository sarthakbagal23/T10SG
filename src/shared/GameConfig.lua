--!strict
-- Shared, non-secret settings used by both client and server.
local GameConfig = {
  MatchLengthSeconds = 180,
  GoalPauseSeconds = 2,
  GoalMessageSeconds = 2,

  FieldWidth = 150,
  FieldLength = 240,
  FieldThickness = 1,

  GoalWidth = 30,
  GoalHeight = 13,
  GoalTriggerDepth = 6,

  BallSize = 3,
  BallSpawnHeight = 1.7,
  PossessionDistance = 9,
  PossessionOffset = 3.3,
  PossessionDropOffset = 2.1,
  RequestCooldownSeconds = 0.12,
  KickCooldownSeconds = 0.4,

  ShotSpeedMin = 62,
  ShotSpeedMax = 112,
  ShotLiftMin = 5,
  ShotLiftMax = 22,
  PassSpeed = 56,
  PassLift = 3.5,

  OutOfBoundsX = 95,
  OutOfBoundsZ = 145,
  OutOfBoundsY = -15,
}

return table.freeze(GameConfig)
