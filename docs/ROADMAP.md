# T10SG Roadmap

## Milestone 1 — Core playable loop
- [x] Rojo project structure and shared configuration
- [x] Generated field, markings, goal frames, and team spawn locations
- [x] Balanced team assignment
- [x] Server-validated possession, charged shots, and passes
- [x] Server-side goal validation, score updates, match clock, and ball reset
- [x] Basic scoreboard and control HUD
- [ ] Run in Roblox Studio and fix issues found by play-testing
- [ ] Test with two or more local clients

## Milestone 2 — Soccer feel
- Add tackling / loose-ball challenges with server-side range and cooldown checks
- Add a clear dribble state and possession animation
- Tune ball weight, friction, shot charge, and pass arc after play-tests
- Add kick sounds, goal sounds, a goal flash, and a quick celebration
- Prevent scoring through the side/back of the net and tune out-of-bounds behavior

## Milestone 3 — Real match flow
- Kickoff countdown and consistent player reset positions
- Match-end / rematch flow and a results screen
- Optional 3v3 or 4v4 team sizes and player-count handling
- Goalkeeper role, saves, and keeper-specific controls

## Milestone 4 — Identity and polish
- Custom T10SG visual identity and original UI
- Better stadium kit, crowd details, lighting, and materials
- Animations and sound design
- Controller and mobile control layouts
- Accessibility settings and performance checks

## Milestone 5 — Release readiness
- Server/client exploit review and remote rate limiting
- Latency and multi-device testing
- Data persistence only for features that actually need it
- Analytics, moderation/reporting considerations, and store-page assets
