# T10SG — Game Direction

## Product goal

T10SG is an arcade-style Roblox soccer experience. The early goal is a responsive, readable football loop—not a large menu system or a fake finished stadium.

## First vertical slice

1. Spawn into a readable pitch and get assigned to Blue or Orange.
2. Request the loose ball with **E** while nearby.
3. Hold **left mouse** to charge a shot and release to shoot.
4. Press **right mouse** to pass.
5. Score by sending the ball through a goal; the scoreboard updates and the ball resets.
6. Play a short three-minute match.

## First-build design principles

- Responsiveness: possession should be predictable and kicks should have visible power.
- Readability: strong field markings, contrasting team labels, and a clear scoreboard.
- Fairness: validate gameplay requests on the server; do not trust a client-provided score or player/ball position.
- Iteration: use simple generated geometry before importing a stadium or avatar assets.
- Multiplayer first: test with Studio's local server and multiple clients before treating gameplay as ready.

## Current control scheme

| Input | Action |
| --- | --- |
| E | Request possession when close to the loose ball |
| Hold left mouse, then release | Charge and shoot |
| Right mouse | Pass toward the camera's horizontal aim |

## Inspiration and differentiation

Existing Roblox soccer experiences show that separate shooting, passing, tackling, and dribbling actions are familiar in this genre. T10SG starts with a smaller control set so we can tune its fundamentals and then add signature mechanics, animation, sound, and visual identity. We should learn from the genre without copying another game's branding, assets, UI, or code.

## Known prototype limitations

- The first version uses two auto-balanced teams, not selectable positions or matchmaking.
- No goalkeeper role, tackles, skill moves, stamina, player ratings, cosmetics, persistent progression, or mobile-specific buttons yet.
- Ball presentation and physics need testing under real latency.
- Touching a goal is not by itself trusted: the server will check the ball's actual bounds and current match state too.
