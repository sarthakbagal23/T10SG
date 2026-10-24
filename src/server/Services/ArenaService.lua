--!strict
local ArenaService = {}

local GREEN = Color3.fromRGB(45, 135, 78)
local LIGHT_GREEN = Color3.fromRGB(52, 148, 86)
local WHITE = Color3.fromRGB(238, 244, 239)
local DARK = Color3.fromRGB(27, 36, 43)
local BLUE = BrickColor.new("Bright blue")
local ORANGE = BrickColor.new("Bright orange")

local function makePart(parent, name, size, cframe, color, material, transparency)
  local part = Instance.new("Part")
  part.Name = name
  part.Size = size
  part.CFrame = cframe
  part.Color = color
  part.Material = material or Enum.Material.SmoothPlastic
  part.Transparency = transparency or 0
  part.Anchored = true
  part.TopSurface = Enum.SurfaceType.Smooth
  part.BottomSurface = Enum.SurfaceType.Smooth
  part.Parent = parent
  return part
end

function ArenaService.new(config)
  local oldArena = workspace:FindFirstChild("T10Arena")
  if oldArena then
    oldArena:Destroy()
  end

  local arenaModel = Instance.new("Model")
  arenaModel.Name = "T10Arena"
  arenaModel.Parent = workspace

  local halfWidth = config.FieldWidth / 2
  local halfLength = config.FieldLength / 2

  local field = makePart(
    arenaModel,
    "Pitch",
    Vector3.new(config.FieldWidth, config.FieldThickness, config.FieldLength),
    CFrame.new(0, -config.FieldThickness / 2, 0),
    GREEN,
    Enum.Material.Grass
  )
  field.Locked = true

  local function line(name, size, position)
    local part = makePart(arenaModel, name, size, CFrame.new(position), WHITE, Enum.Material.SmoothPlastic)
    part.CanCollide = false
    part.CanTouch = false
    part.Locked = true
    return part
  end

  local lineY = 0.09
  line("Touchline_Left", Vector3.new(0.3, 0.12, config.FieldLength), Vector3.new(-halfWidth + 1, lineY, 0))
  line("Touchline_Right", Vector3.new(0.3, 0.12, config.FieldLength), Vector3.new(halfWidth - 1, lineY, 0))
  line("GoalLine_North", Vector3.new(config.FieldWidth - 2, 0.12, 0.3), Vector3.new(0, lineY, halfLength - 1))
  line("GoalLine_South", Vector3.new(config.FieldWidth - 2, 0.12, 0.3), Vector3.new(0, lineY, -halfLength + 1))
  line("Halfway_Line", Vector3.new(config.FieldWidth - 2, 0.12, 0.3), Vector3.new(0, lineY, 0))
  line("Center_Spot", Vector3.new(2.2, 0.14, 2.2), Vector3.new(0, lineY, 0))

  local boxWidth = 48
  local boxDepth = 34
  for _, sign in ipairs({ -1, 1 }) do
    local boxStart = sign * (halfLength - boxDepth)
    local boxCenter = sign * (halfLength - boxDepth / 2)
    line("PenaltyBox_SideA_" .. sign, Vector3.new(0.3, 0.12, boxDepth), Vector3.new(-boxWidth / 2, lineY, boxCenter))
    line("PenaltyBox_SideB_" .. sign, Vector3.new(0.3, 0.12, boxDepth), Vector3.new(boxWidth / 2, lineY, boxCenter))
    line("PenaltyBox_Front_" .. sign, Vector3.new(boxWidth, 0.12, 0.3), Vector3.new(0, lineY, boxStart))
  end

  -- Simple, low-profile stands make the first test arena feel intentional
  -- without relying on imported models or external asset IDs.
  for _, sign in ipairs({ -1, 1 }) do
    makePart(
      arenaModel,
      "Sideline_Stand_" .. sign,
      Vector3.new(12, 5, config.FieldLength - 8),
      CFrame.new(sign * (halfWidth + 10), 2.5, 0),
      DARK,
      Enum.Material.Metal
    )
    for row = 1, 3 do
      makePart(
        arenaModel,
        "Stand_Seat_" .. sign .. "_" .. row,
        Vector3.new(10, 0.6, config.FieldLength - 18),
        CFrame.new(sign * (halfWidth + 10), 4 + row * 1.3, 0),
        row % 2 == 0 and BLUE.Color or ORANGE.Color,
        Enum.Material.SmoothPlastic
      )
    end
  end

  local function createSpawn(name, teamColor, position)
    local spawn = Instance.new("SpawnLocation")
    spawn.Name = name
    spawn.Size = Vector3.new(8, 1, 8)
    spawn.CFrame = CFrame.new(position)
    spawn.Anchored = true
    spawn.Neutral = false
    spawn.TeamColor = teamColor
    spawn.AllowTeamChangeOnTouch = false
    spawn.Duration = 0
    spawn.Transparency = 1
    spawn.CanCollide = false
    spawn.Parent = arenaModel
    return spawn
  end

  createSpawn("Blue_Spawn", BLUE, Vector3.new(0, 0.6, -halfLength * 0.62))
  createSpawn("Orange_Spawn", ORANGE, Vector3.new(0, 0.6, halfLength * 0.62))

  local goalZones = {}
  local function createGoal(sign, scoringTeam)
    local goalZ = sign * halfLength
    local goalWidth = config.GoalWidth
    local goalHeight = config.GoalHeight

    for _, x in ipairs({ -goalWidth / 2, goalWidth / 2 }) do
      makePart(
        arenaModel,
        "GoalPost_" .. scoringTeam .. "_" .. tostring(x),
        Vector3.new(1.1, goalHeight, 1.1),
        CFrame.new(x, goalHeight / 2, goalZ),
        WHITE,
        Enum.Material.Metal
      )
    end
    makePart(
      arenaModel,
      "GoalCrossbar_" .. scoringTeam,
      Vector3.new(goalWidth + 1.1, 1.1, 1.1),
      CFrame.new(0, goalHeight, goalZ),
      WHITE,
      Enum.Material.Metal
    )

    local net = makePart(
      arenaModel,
      "GoalNet_" .. scoringTeam,
      Vector3.new(goalWidth, goalHeight - 1, 0.25),
      CFrame.new(0, (goalHeight - 1) / 2, sign * (halfLength + 8)),
      Color3.fromRGB(210, 222, 230),
      Enum.Material.ForceField,
      0.68
    )
    net.CanCollide = false
    net.CanTouch = false

    local trigger = makePart(
      arenaModel,
      "GoalTrigger_" .. scoringTeam,
      Vector3.new(goalWidth - 1, goalHeight - 1, config.GoalTriggerDepth),
      CFrame.new(0, (goalHeight - 1) / 2, sign * (halfLength + config.GoalTriggerDepth / 2)),
      WHITE,
      Enum.Material.SmoothPlastic,
      1
    )
    trigger.CanCollide = false
    trigger.CanTouch = true
    trigger.CanQuery = false

    table.insert(goalZones, {
      Trigger = trigger,
      Sign = sign,
      ScoringTeam = scoringTeam,
    })
  end

  -- Blue attacks toward +Z; Orange attacks toward -Z.
  createGoal(1, "Blue")
  createGoal(-1, "Orange")

  local ball = Instance.new("Part")
  ball.Name = "SoccerBall"
  ball.Shape = Enum.PartType.Ball
  ball.Size = Vector3.new(config.BallSize, config.BallSize, config.BallSize)
  ball.Color = Color3.fromRGB(245, 245, 239)
  ball.Material = Enum.Material.SmoothPlastic
  ball.Anchored = false
  ball.CanCollide = true
  ball.CanTouch = true
  ball.CanQuery = true
  ball.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.45, 0.28, 1, 1)
  ball.Position = Vector3.new(0, config.BallSpawnHeight, 0)
  ball.Parent = arenaModel

  return {
    Model = arenaModel,
    Ball = ball,
    GoalZones = goalZones,
  }
end

return ArenaService
