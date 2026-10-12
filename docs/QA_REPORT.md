# QA Report — 2026-10-12

Test environment: installed Godot `4.7.2.stable.arch_linux.ed1daf0bf`, Linux, Compatibility/OpenGL renderer, Intel Iris Xe/Mesa. Python/Pillow available through `/usr/bin/python`. No desktop export templates installed. Full-resolution engine screenshots are under `docs/screenshots/`.

## Executed checks

| Check | Result | Evidence |
|---|---|---|
| Assets and configuration | PASS: 1437 checks, zero failures | `docs/qa_logs/assets.log` |
| Headless editor/import | PASS: no script/import errors | `docs/qa_logs/import.log` |
| Gameplay integration | PASS: 1257 checks, zero failures | `docs/qa_logs/integration.log` |
| Live enemy/boss AI input smoke | PASS: all archetypes attack, all forms exercised | `docs/qa_logs/live_combat.log` |
| Godot PCK export and startup | PASS: room spawns retained, initial encounter loaded | `docs/qa_logs/export_pack.log`, `docs/qa_logs/pack_smoke.log` |
| Fresh source archive startup | PASS: automatic import and encounter startup without cache | `docs/qa_logs/cold_start.log` |
| Packed-game integration | PASS: 1257 checks, zero failures | `docs/qa_logs/pack_integration.log` |
| Graphical render smoke | PASS: 11 captures, clean shutdown | `docs/qa_logs/render.log` |

Integration covers the exact transformation cost matrix, insufficient/exact energy, transition locking, shared health, energy cap/regeneration, damage immunity, parry/stagger/mark reward, Devour hit-only healing, dash marks, cross-form detonation, phase/dodge safety, all eight upgrades, pause/resume, settings/statistics round trip, 256 reproducible seeds, six-layout bags, unique reward choices and resource geometry.

Physics tests use actual CharacterBody2D and TileMapLayer collisions. Each of the six templates can be crossed from entry to exit using movement, with mandatory wall collisions. Every one of the fifteen optional platforms is reached with a full physics jump at the normal physics timestep. Variable-height jump uses injected input. Full progression is tested through actual attack damage, enemy death signals, seal unlocking, altar interaction, upgrade selection, rest healing, exit interaction, boss victory, death, menu cleanup and clean restart. These completion fixtures inject positioning and suppress enemy AI to isolate progression; they are not unassisted playthroughs or balance measurements.

Boss tests cover melee in/out of range, two low shockwaves, second-phase health threshold, the three-shot fan, and extra damage on changed attacking form. Phase and dash never disable world collision. No transform immunity is granted.

Native renders include menu, each form, pause, settings, upgrade choice, boss windup, defeat and victory. Visual review identified and fixed expanded health bars and overflowing reward descriptions. Transparent sprite corners, consistent sheet dimensions and alpha-preserving death fades are checked. The generated backdrop's source and interim integrated rendition are explicitly distinguished.

## Issues corrected during execution

- TileSet physics data configured before atlas attachment: attached the source before assigning collision polygons; floor collision works.
- Repeated room removal during restart: owner reference is cleared immediately after queueing a room for deletion.
- UI minimum-size expansion: constraints are applied after theme/layout updates; upgrade text wraps within its card.
- Opaque corners during temporary enemy death: opacity now multiplies the existing alpha mask.
- Fresh-source editor shutdown: the first `--import --quit` cold run aborted (SIGABRT) after import. Coredump inspection found unsymbolized Godot frames on the main thread, with no OOM evidence. The exact cause is unconfirmed. The launcher now uses `--editor --quit-after 120`; two fresh checkouts completed import and game startup cleanly. The failed initial log is retained in `docs/qa_logs/cold_import_failure.log`. No project source was lost. The extracted diagnostic core was deleted.
- Audio resource release on exit: stop playback before quitting and allow the audio thread to drain; checks reject resource leak logs.
- Packed resource export lost enemy spawn positions in the installed engine build: spawn configuration now uses typed Vector2 arrays, with dedicated PCK validation.
- Optional ledge reachability: original provisional jump and high ledges were incompatible. Full-jump strength and ledges are now coordinated and every optional ledge is physics-tested. Accelerated simulation is not used to measure jump trajectories.

Live AI smoke runs with a deliberately high-health fixture, actual enemy AI and injected input; it verifies that all three archetypes and the second-phase boss execute attacks and damage the player, while all forms can be used. This fixture does not establish balance.

## Remaining validation / limitations

Manual unassisted combat enjoyment, difficulty and the 10–15 minute target remain unverified. Timing-heavy coyote/buffer feel should receive a human keyboard pass. Controller/remapping and localization are not implemented. Production art/audio and authored boss/attack animation are incomplete. Windows executable testing remains pending. Independent Linux/Windows exports require matching export templates. PCK packaging uses the installed Godot runtime and is not advertised as a standalone executable.

Use `/usr/bin/python tools/check_project.py --render --live` to repeat available validation. Use `/usr/bin/python tools/build_pack.py --deep` to rebuild and validate the PCK, including the full integration suite against exported resources. The render option requires a graphical display. Automated tests use separate QA save files.
