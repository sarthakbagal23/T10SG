# T10SG

T10SG is an arcade-style Roblox soccer game built with Luau, Roblox Studio, and Rojo.

## First playable slice

- Generated soccer pitch, field markings, goal frames, and spawn points
- Auto-balanced Blue and Orange teams
- Server-validated possession, charged shots, and passes
- Goal validation, scoring, a three-minute match clock, and ball resets
- A basic scoreboard, match messages, and shot-charge bar

## Run it locally

1. Install [Rokit](https://rojo.space/docs/v7/getting-started/installation/) and make sure its command is available in a new terminal.
2. Clone this repository and enter the folder:
   ```powershell
   git clone https://github.com/sarthakbagal23/T10SG.git
   cd T10SG
   ```
3. Install the pinned Rojo tool version and start the sync server:
   ```powershell
   rokit install
   rojo serve
   ```
4. Open a place in Roblox Studio. Click the Rojo plugin and connect to the local server shown in your terminal.
5. Check the Explorer: the project maps code into `ReplicatedStorage`, `ServerScriptService`, and `StarterPlayerScripts`. Use **Test → Start** with at least two players for the multiplayer pass.

Rojo needs both sides: its command-line server running on your computer and its plugin inside Studio. See the [official Rojo setup guide](https://rojo.space/docs/v7/getting-started/new-game/).

## Controls

- **E** — request possession when close to the loose ball
- **Hold left mouse, then release** — charge and shoot
- **Right mouse** — pass toward the camera's horizontal aim direction

The control scheme is intentionally small for the first test. Tackling, advanced dribbling, goalkeeper roles, mobile controls, cosmetics, and progression are later milestones.

## Project layout

- `default.project.json` — maps source files into Roblox services
- `rokit.toml` — pins the Rojo CLI version
- `src/shared/GameConfig.lua` — shared gameplay tuning
- `src/server/Main.server.lua` — wires remotes and server systems
- `src/server/Services/` — arena generation, teams, ball actions, and match scoring
- `src/client/T10Client.client.lua` — HUD and input handling
- `docs/` — game direction, roadmap, and manual test plan

## Status and important limitation

The source scaffold has been committed, but it has **not yet been run inside Roblox Studio in this environment**. Treat it as the first prototype, not a tested release. First check Studio's **Output** window, then follow [the manual test plan](docs/TEST_PLAN.md). Server-side validation is included for core requests, but the game still needs realistic multiplayer/latency tests and a security review before publishing.
