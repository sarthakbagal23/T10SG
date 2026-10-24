# T10SG Manual Test Plan

Run this list in Roblox Studio after syncing with Rojo. Use **Test → Start** and choose two or more players for multiplayer checks. Watch the **Output** window throughout.

## Boot and map
- [ ] Rojo connects and syncs without a project-mapping error.
- [ ] The server starts without red errors in Output.
- [ ] The pitch, markings, two goals, ball, and both team spawn points appear.
- [ ] The HUD shows a 0–0 score and a 03:00 timer.
- [ ] Each new player is assigned to Blue or Orange; teams stay as balanced as possible.

## Ball actions
- [ ] Press **E** while more than 9 studs away: possession is not granted.
- [ ] Press **E** while close to the loose ball: it moves in front of the character and follows while held.
- [ ] Hold left mouse and release: the ball shoots forward; a longer charge goes farther/higher than a short charge.
- [ ] Press right mouse while holding the ball: the ball passes.
- [ ] Press Shoot or Pass without possession: nothing happens.
- [ ] Two players cannot both acquire the ball at the same time.
- [ ] Resetting/dying or leaving while holding the ball does not leave the ball stuck.

## Scoring and match flow
- [ ] A ball crossing into the +Z goal increments Blue's score exactly once.
- [ ] A ball crossing into the -Z goal increments Orange's score exactly once.
- [ ] The ball resets after a goal and play can continue.
- [ ] Shots wide of the goals do not count.
- [ ] A ball sent far out of bounds resets to the center.
- [ ] The timer counts down and the match-end message appears at 00:00.
- [ ] The next match begins after the short results pause.

## Multiplayer and security checks
- [ ] Run with 2–4 local clients and confirm the score is the same for everyone.
- [ ] Spam the E key and repeated remotes; actions should remain rate-limited.
- [ ] Confirm that a client cannot score by sending a remote request alone.
- [ ] Test near the edges of the goal, from different distances, and with slower network emulation if available.
- [ ] Re-test ball feel with multiple players; server-owned ball physics may feel less responsive than client-owned physics.

## Record issues before expanding
For every failure, note: **steps to reproduce**, **expected result**, **actual result**, and any red Output message. Fix boot and ball/goal bugs before adding tackles, animations, or progression.
