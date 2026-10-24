# T10SG

T10SG is an arcade-style Roblox soccer project built with Luau, Roblox Studio, and Rojo.

## Current goal

Build a small, testable vertical slice before expanding into full team matches, goalkeeper mechanics, progression, cosmetics, and matchmaking.

### First playable slice
- Procedurally generated soccer pitch, goals, and team spawn points
- Balanced Blue and Orange teams
- Server-validated ball possession, charged shots, and passes
- Goal detection, score tracking, and a match timer
- Simple in-game HUD and control hints

## Development workflow

This repository uses [Rojo](https://rojo.space/) to sync source files into Roblox Studio. The Studio plugin needs a running Rojo CLI server on your computer.

1. Install the Rojo CLI with [Rokit](https://rojo.space/docs/v7/getting-started/installation/).
2. Clone this repository.
3. From the project folder, run `rokit install` and then `rojo serve`.
4. In Roblox Studio, open the Rojo plugin and connect to the local server.
5. Use **Test → Start** with at least two players to test team assignment and multiplayer behavior.

## Initial controls

- **E** — request possession when close to the ball
- **Hold left mouse button** — charge a shot; release to shoot
- **Right mouse button** — pass toward the camera's horizontal aim direction

Controls are a starting point and will be tuned after play-testing.

## Project status

The initial prototype is a starting point, not a finished or fully tested game. Test changes in Studio before publishing. Gameplay-critical actions are checked on the server, but the prototype still needs multiplayer, latency, and exploit-resistance testing.

See [docs/GAME_DESIGN.md](docs/GAME_DESIGN.md) and [docs/ROADMAP.md](docs/ROADMAP.md) for the design and next milestones.
