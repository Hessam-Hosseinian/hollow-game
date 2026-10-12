# Development Roadmap

Status reflects this execution segment, not a promise of final art quality.

| Milestone | Status | Evidence / remaining work |
|---|---|---|
| 1 Foundation | Implemented and tested | Godot 4.7.2 import, main scene, display/input/resources, Git |
| 2 Player slice | Implemented and tested | Four forms, energy/costs, physics traversal and jumps, keyboard jump, dodge |
| 3 Combat | Implemented and tested | Shared health/death/marks, three enemy types, specials, feedback |
| 4 Roguelike | Implemented and tested | Seeded layouts, ten-room progression, altars, eight upgrades, reset |
| 5 Boss | Implemented and tested | Three patterns, health phase, form-sensitive ward, victory flow |
| 6 Art production | Partial | One AI-generated background, original temporary atlas/tile/icon assets, prompts/manifest; production sprites missing |
| 7 Polish | Partial | HUD/screens visually checked, effects/audio/telegraphs; human difficulty tuning and production animation/audio remain |
| 8 QA / release | Partial | Automated checks and graphical screenshots; Godot PCK packaging; independent Windows/Linux binaries require installed export templates |

Next concrete milestone: play several unassisted seeded runs, tune enemy spacing/damage/run duration, then replace the shared player reference and its four form animation sheets in controlled batches. Verify native pixel density and pivots before increasing animation count. Export binaries after installing matching 4.7.2 templates and test Windows on Windows.
